Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6885DCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30B08E001B; Fri,  5 Sep 2025 14:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08598E0001; Fri,  5 Sep 2025 14:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6F28E001B; Fri,  5 Sep 2025 14:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E10D8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:17:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A06211916C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:17:27 +0000 (UTC)
X-FDA: 83856004134.14.DBB5D3A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76411100016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:17:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i9bn7K/n";
	spf=pass (imf05.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757096244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSNBUepBV0NLBKXO4hD/x/32Bg9vZ1O7IaiMn1spFXQ=;
	b=Kn/uGC4yCqcqu0VxkPN1+L7199SrwJVXARqUkFWcdKK0bKDdm+7q+2TSI3I5gi/sdRlZef
	GKERsXcTQPB0a0UhnVeVbj96M+lQBePi+lN8iiKQq2bjHUBMv/8Sh+v0lORbWV6kI9eVZ0
	m+Zo5dhAl/dg1Y27hp6lR2qq7ysk1c8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="i9bn7K/n";
	spf=pass (imf05.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757096244; a=rsa-sha256;
	cv=fail;
	b=R1LacXIB1HlvsosTlqlpMOTAjm9nWHNi4RNWVW+UdIQUv6RzXSNj/Dp8tcgNGIB/oPZPkA
	tFv924t/D0d+H7SBXbXG5ExEmGDV15krVpb3T1XVeWT8at6TW9TEsor1ipYi2X6BJNYemI
	3xStBrd5KNaG7Okard6Ttkev3/pQBiQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757096244; x=1788632244;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=NTvbXk/fcQjb013V6oTib1DudN7TVqoYCHD80USa8cY=;
  b=i9bn7K/nOWXVGHczkYuCEmBipWVrRs+w5pz2kmVqVTD5nBw9UD3hb/5P
   0glo9+va5YcB2y7r7xkorfdN+7bOp00Eogpm5HWUjz2ocq5pIq1+rl2JY
   ZdxJrYKWqrb7bePUqpFT8kipgJGdZ3Fwa1GnTM91rAx78o8ud6UNaQffN
   xvDHgQBwsTKOLPBYtgPeIIEgn9Hv8OKvW1BMRpYwuoW5LaPNYaskiIX5y
   63D1XKra2mPCaZudVJSrIETeAtDPCnLL6UEORkFmbyx5ozAkwG7Rv4lbf
   UwExIKn/Pwj5J+Ddwqy5VxDCOcipfvSqqdHNyIQgb/g144JPJGtAOVm3e
   g==;
X-CSE-ConnectionGUID: FEUXf7TISJKZ0BidUBs6hA==
X-CSE-MsgGUID: hbi/11YBRsivOrI4bdzSCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="69711862"
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="69711862"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 11:17:23 -0700
X-CSE-ConnectionGUID: nIqsc1jlQzS1vRM5ocEe+Q==
X-CSE-MsgGUID: dtUMDcPIQxWEfTZoa6R/yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="172108153"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 11:17:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 11:17:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 5 Sep 2025 11:17:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.81)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 5 Sep 2025 11:17:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIrAxS3vQcoghS5z5xnDVe7o8yFB7sqVHr/c13A/AMRZappR77fjbhUOjzusI0Dk3JS60pc8tGoT6wCiPXDRJZWpJz8j+Zoa6XSFJTfUQ5shSPoKmazNYNMCZmOYni9xG9hdFe+c8JnJV/0aq0H+Bh/IsBAYvSxpEgERmkfRdVvgG3Ux1TkYVCYAu+j1OjrDeDIQLghIm3zNszONKwDGyJ+2f33w+7lqjttk3RP30nCyuCPQnLU5bTey7THwXp+hISVKEytEM+w5cGWWaSTCVY2wL1bG9wDFSSR17MYyW6+DD6296bU+PxYKJ33ikGOFyNf5azBaIidgQbGtpDrPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSNBUepBV0NLBKXO4hD/x/32Bg9vZ1O7IaiMn1spFXQ=;
 b=YWyMirutfo773XhmrEKX5MUyD3K1ikviCIwH86o2wswej2c7fgy8lV+PDcw68qwGZcZkWVjmIMai1Rv5AhZrWlHWNtlJqykA4ORtLa/qcoTNC04/8TNsek89AOuO5w69ShsTfslLG915FE36f7IkYX+q+SR1O0YTh1lNFyykhovK+FAfKJ/suJQuPJ4a/wfouBnBkf+H2f6kb/Qu6R/UJelI0uepKPIwef7cSKJJXrSJtqcMpU+4vstAzxEGZnrdvNGXxhpbDlMekcZ64RIMYwkPIWyTyWvI7/WANgkFSLbolRdvrSOUSK9ZgQdrnxYc09FkZmAHo6KC1zmC92BHsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB8157.namprd11.prod.outlook.com (2603:10b6:8:187::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:17:13 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.015; Fri, 5 Sep 2025
 18:17:13 +0000
Date: Fri, 5 Sep 2025 11:17:11 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, <surenb@google.com>, "Anderson, Russ"
	<russ.anderson@hpe.com>, <rppt@kernel.org>, <osalvador@suse.de>,
	<nao.horiguchi@gmail.com>, <mhocko@suse.com>, <lorenzo.stoakes@oracle.com>,
	<linmiaohe@huawei.com>, <jiaqiyan@google.com>, <jane.chu@oracle.com>,
	<david@redhat.com>, <bp@alien8.de>, "Meyer, Kyle" <kyle.meyer@hpe.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>, <vbabka@suse.cz>,
	<linux-acpi@vger.kernel.org>, Shawn Fan <shawn.fan@intel.com>
Subject: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Message-ID: <aLspJ5Tpqp4qRDk2@agluck-desk3>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DM4PR11MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: f857284c-3a0f-49bc-aed5-08ddeca86fda
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2shxHcus+Ri0CSP4XvBpkv6LEHC7RScKndBStrtC0NBgMIDP9lV8rH1VQc1w?=
 =?us-ascii?Q?6JO3Xq7JujX7j1AKncEQQPH4BCB1yNyOrZTO+l/Tm96lEqeublXqiRYhsV1x?=
 =?us-ascii?Q?s+fTgS20x9sEvI1Kee9kXp/CUqHrxz9YNi4vzdlRg69QVNXYfIkFTwa+VGQ7?=
 =?us-ascii?Q?scEfNoTUX/6zDQ+Caz34ekk2KwlHun1vN3iFjZBJY2GsEl9hW+9+mnrvs5Xi?=
 =?us-ascii?Q?9PyUjcUdhFR6WEIk6fvcQCmO3o8g2GDDxemtmsngOaidT82xVGWmFyrr6FOG?=
 =?us-ascii?Q?RRaSZ4M7Go3yVLZo47yIoBl5OF1M4dFojT16RcKAOUrCT6fMlFaUs+kMh84P?=
 =?us-ascii?Q?Xi73f4RxUPpOaKWuaCGtWMRrWrFgvFRZaoBFse3SlMMcYfQrFKWIlsIY8OgC?=
 =?us-ascii?Q?9Il+CqSspiRuB0CIkAoK8AxOYMk+tRFouqQVdGVnOru4D89qfFOyzaJmaIjl?=
 =?us-ascii?Q?1928UaWE9dfmF5uuUdlZ9VfxMFaTu958+q6YuIDR1R4KmPDS5f3iVC2QfUsj?=
 =?us-ascii?Q?oU3nEDI778pnPBPmEhA7VyAwz6amWw0Q4nIJ4nbLugXg5Uyb35MoRLE1sK3M?=
 =?us-ascii?Q?vhWoJ9dPvRILkj3T9AYKkpeMjK0rpkrLek7eIUuEQyNsTWAfyGvHZX4xVWj8?=
 =?us-ascii?Q?FqtjG8YpOfYo1iZrTC9mMiUew8Hcb9p4bOe5224MWf8t9p5kaMevbWY8PNEF?=
 =?us-ascii?Q?GYx5mSFKMK3YafEBDTlo1gMzxVYYvb0RgH/s9oq9j8P9LC3fD076oh1Y70S+?=
 =?us-ascii?Q?QWwBfC80HB8BgbMhjCQdgdaybMMl8+C0AgydbAcC+wTvUny1G2TxHIc1BWhJ?=
 =?us-ascii?Q?Kl5ifYIC6Kl89rrdh86psX0jUZWLz+o9hEuygsOnJ2ynL6DkbdgC2na5XXx7?=
 =?us-ascii?Q?SufGk+C92GyC1G3JEqMN0O5K6+4Hv3p78L46RtpCCci0s9MsCktz2VO/NeNQ?=
 =?us-ascii?Q?kN9wJal0A0B0Xlk+H37zDUPcUFVFYiBrh/ot5JTBdIZs4jW0F9DFmhIGhdw7?=
 =?us-ascii?Q?hUeI5hC1AGsdkNHB7LKhKQdk7FATXndxhlhuYXYVEtBBHREK/EcjRvP8Lbwe?=
 =?us-ascii?Q?Hf6pVL1sGlfOzGm61CLGZycHLm6nI84lV8z8YJ9QNymM43JbUGgjI5N+w3rc?=
 =?us-ascii?Q?oiuzyXarwj7em9eTfq4z2pFfHbt5FjKOAZe6VYapio4n1/IFvxSzbt/S5fov?=
 =?us-ascii?Q?XgTL6OpOg8n9ocG0HNLxzeorPG0v9sOErSMktTP3LdNTSywlzJSkGmDcTv8H?=
 =?us-ascii?Q?SIoOZvhQHSIHS53e3gdlo5hCqFpnEJyqK+5d3+mCHFPx4YSLnaRAQIF2DWwU?=
 =?us-ascii?Q?l4yv5DQIkJ1iG0HVqXK5NFvquIpZuruaDXOuC0LdiLdm4qx+yatOSkoSHEEL?=
 =?us-ascii?Q?XAuICAnYo8b69O1/mqm4kTAyEu7jyLxBCP/MxAIhLkmFIvNZMuNY7r/NdvAT?=
 =?us-ascii?Q?yw/kXXUSKuwmmAADZsWEtPEHqFYHpaMvXg8Dfvk45MMm9xL7A/FppA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?McL+STpmZRyErmcPq7+8qV28vwpd2Xrdv6GGAC1kIB9bIgrUD6rEuuMCftHr?=
 =?us-ascii?Q?r6t7pAvxkOCCxpnhJz8qLtUlR96Yyj/zeflbD3A5jUdEDBgy5OsyF2cf4Vrc?=
 =?us-ascii?Q?RBm3XgkwiYtGQD6YkHtMM40FF5/M86UtC7Eh1E6pyYa6qnezJIU1EAZFESz6?=
 =?us-ascii?Q?Mwnf+dS3ySHd+GaymflucxCHlPf2xCqAX4KaGJgE08stWIr71qhAYllILOGk?=
 =?us-ascii?Q?bQXyVW0873JlAIN/ZVeC9+uj6puEeidzEsQKjIPnWWmFQsa4YahJpJ+rcNny?=
 =?us-ascii?Q?MLScD8TBIejlnpMiqYG829EUE5vZb0gp7I8IfId/Wbm7W9KwaPaGG8gNbEpl?=
 =?us-ascii?Q?K28BaJZ2Jaa5L1rJxOujE+XSv7le7PMSh+0OmqKf+wzq+CfET8Fb38WFxruG?=
 =?us-ascii?Q?Un/t93I9yDf7kU6nLnqYYmBcGFxu7Q4APy+clR4tHjgIJ6+Nfsj3UUD0dIVw?=
 =?us-ascii?Q?Mk86sDcqWIFYhW9ivyYOxnKI0ht7bVWomMu4nFfcjWzeDraVQVxToJNk9Qr0?=
 =?us-ascii?Q?Gz4UKyuetdxa5kfYEOFVQRnMZ2QHTlXrVBSPZmkic/DW53aIFMU3OlJPpAKp?=
 =?us-ascii?Q?8dikZflAwXeB6ElUHwRLipgif1h0U/j7njCAJKb5AHYpd+9Dt0jICWDcQiI2?=
 =?us-ascii?Q?DtU8N9q1Y2MAG58h2q3yec59NREZCJeqUq8KAypjRvWbOgCKHXjAhRDpfuK3?=
 =?us-ascii?Q?YGv5P/GWbIWm6QeUpU2Y/XYMkamu+BA63+d2lRR+1TMYiFscvLJwuW9pKRMB?=
 =?us-ascii?Q?mO5tYcivvBYSUocx/lV7k9nt5szbdCG6q2Vfb+LjnfgDKwXdI/QxMoOn0glx?=
 =?us-ascii?Q?T4VWlx1g9SxR/amShE++mYdQdiykwPnj8LUB4+b/xZnUvrcxETkddgne98GP?=
 =?us-ascii?Q?+mfDmvHl5kGsrwRlXvxXxOyqzm+4AmxNYRCFFW41nsLZ350kDsLgjSdDmzYe?=
 =?us-ascii?Q?pipX6kRm43hyxKS26QDIWoyRRdfx6qwEXG+9Rv3IqdOoLQDsZ3zLQw09U+uX?=
 =?us-ascii?Q?3Ob/7vJS9JRU+22LyzE9eaLoN0bTWEgtBbFo30pnRvzOt/9stiD3aNWsaEgq?=
 =?us-ascii?Q?oT0aEvpCQYhfGDP+3EI/dwDSLtgvKfjbowZHL0WgcnZ7d1k6nvVruqKpkXAY?=
 =?us-ascii?Q?Jbkmnm2LaO96sVEZm3Vudp/tZuKpBqF6TH3nTEUvrHR7ChD4nLtyYpP1QuVZ?=
 =?us-ascii?Q?zgWNv6kK6dzxs+pB3mPNXuXb0Dl/JZqKgm5bAjoP33rQ4WtZAK5hy4+bMiWK?=
 =?us-ascii?Q?nb/qa8tkizX6MZdVXA6pI9zYZ0D83s5qp7VG6yMUS0M/rpRUcV1Agbnfxu0g?=
 =?us-ascii?Q?6ChU9Zb0jWtfkjnvpW+yx8tg0PSy7PYLqutUDtIISxtumSlYhQFxw6sBPH6v?=
 =?us-ascii?Q?GGPYnwBxoFEHG0xYxQcBJHa4YmUlANYuYcwXoMRpMywTJfB13WtHW9iaOgj+?=
 =?us-ascii?Q?oH5ail9QYqcuJTl3jZHcuu1eY8eOmn8j6qftvBK/mgjEhof5MwDmLWlBf3kp?=
 =?us-ascii?Q?LOV/KM7bYQUIziRTJyAkdBjLlNtiY8JTLszrWDiOnLa9VUbAFdbQCVng5wRb?=
 =?us-ascii?Q?fucII7agOZSZvU8dzu1oCAArrrY1uWU3OYr5utVs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f857284c-3a0f-49bc-aed5-08ddeca86fda
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:17:13.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9SaDaHQiqzNN59RlmTS30f5UyVB+S5VriB8jGzC4Pk+YhzxJAOLjy8pE573z7z8OwpJwKpyYb1nKh111z0ynrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8157
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 76411100016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jwgkrinpat7e9iof18hu4u6wns9wd53k
X-HE-Tag: 1757096243-191800
X-HE-Meta: U2FsdGVkX18MKHVj09Kz+fiQ+TeIZ/sOs1tEPwiJ5pHm4Ah8JCgEPpVF1s0oHxyNgWC1eYquzOBcUDV++Ozu3kueW9fjkpWGRyw+N1KLCFVjehcLyw1OToA1NKJOtVAeQERZlk3pkm0r1x8hPbp6KMkL0PTMN5wd1iV+QSZLLXdoX47bfR4AvKF4tmfbQkaXeZ4Y2Wo+o1Mwxc/1JnSEJMovLOuccG0WO3IseZPQmsT5LBsfceRu07u5DAQOaxCy8/w2ZNru2/b9fcpoIUx4lGsNwcayQVBKkEm1/5BJXTPIlbxJYc6QCSUR1YCIT/1LcBbjOj8rinP9YsOBcrpi02m9WjkWPfVTLNxvFo78WTY8HVAeNZ+meQ91PXXO+gIDAjoQeMcYdR1svg6jc7i6g9hBcygPJndNzK+J0GKpq9SNwsRoZNUjJ7JtGNXHqgocznFy+iAwWmHMV/Xj2COEoGA4kHv7nTz/Nv+ejBBm5D7WSSyPOyYFC45pyO+C5ZrQbbK5yZefAh5MdZyrVvrMMigcUzOJPXT/qiGe0tX41L8Fsyg1CIK56Pu9HGmNkY4xjUrh8grEPMb51spBcXUOn90l+67EMiFCsubJshz0E4rf/+SqbyBlHYpv5LLrvg8yzQ5PN+1u9pXG8i612GpA5fbMewfM22Zr77meqDfPtkK8JJ+OaF5uZYN6+t1M7Ad2RJ9OZQkWM9s7g27ghIcOJzQfFYkpiZ7UvQ8LwYrHg3L9lny3EcSzg+vSkpxgzshZzTZBeSTzVIWOI2Y5CUxfe4/mQDVQDn5ZPmi54CbHwyxJcLxsqdX4KhZ0/zGM4Gd6i9TKE/JibpbQYki6lyWxmcIz3YUh5qq95kxOS4BeQac4aXuMdi80lBRYPgoLnQrclxZTUu2QI+wukCOifY9tds26uOFHnxukPrryxRRyL6X7fp98VoYIaU0PLs9ouMTXJ+de8FR6O0ACLYFMFAo
 pVUo/5zM
 IlTuS/Pb/CVjPqrhLSgDzT1TtJ1849SA2ARSh62vasCiXW1Bb0/gf9lzuqTjWrx5VEelPp0VdMHLvhZ68/t0UWbQqqOqGWsRFvN5I0VvF5ZS+/nvSN3JDCkNZ8o3Ud1H5YkMtUMfhSPKv2lcsyizOVibxbpyFXHWnQNQbUzmrcMs+XP3KJluIWT2pNNuOTCWoU71OgqFYJvm0hiN/NYKV4UD0GzXznE+n3UZbqP1N5ZT1rGT8MXOqgTXCpWbZcGXPlwB4LQYCGawL7RS2riuOYXEsycVX+R1fA9bg8WrltRuuRrAfbLVRkkv2bBnmaCwebAkGsX5Legt63u/sON7woYMQoEgfmQP6qA2iPUOH3VYtbNUOMw5XNJ7BIL/p8JOIs9+HIGEaOXAo2oP9ZJJllIhBeE8p1W3pctAnVtOoiie3PlxWNZjRwKSuWHh17YhHWTZadvFmixt89UyD5ONPIS7TsF2DXDiehBmW6+f0a4WqDTtM2vpHUFd9RsBuSdy5sbLbrqMeA80vRrkSSqOzkNqWZNtF2t+MVWNwqM3wqYLFWVyc8wYXC9b1SjrZcJUhgD5kSJJkynSE427W1+NxJxi5vNm4j5hOEgZdMd6JNeOuJXlYet987zqVZwtdcGis3egdXml+WQr6Q+O+0ZLfJpDF/2NBuuSHh3ix
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

Change since v2:

Me: Add sanity check on the address (pfn) that BIOS provided. It might
be in some reserved area that doesn't have a "struct page" which would
likely result in an OOPs if fed to pfn_folio().

The original code relied on sanity check of the pfn received from the
BIOS when this eventually feeds into memory_failure(). That used to
result in:
	pr_err("%#lx: memory outside kernel control\n", pfn);
which won't happen with this change, since memory_failure is not
called. Was that a useful message? A Google search mostly shows
references to the code. There are few instances of people reporting
they saw this message.


 drivers/acpi/apei/ghes.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a0d54993edb3..c2fc1196438c 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -540,8 +540,17 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
 
 	/* iff following two events can be handled properly by now */
 	if (sec_sev == GHES_SEV_CORRECTED &&
-	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
-		flags = MF_SOFT_OFFLINE;
+	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
+		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
+
+		if (pfn_valid(pfn)) {
+			struct folio *folio = pfn_folio(pfn);
+
+			/* Only try to offline non-huge pages */
+			if (!folio_test_hugetlb(folio))
+				flags = MF_SOFT_OFFLINE;
+		}
+	}
 	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
 		flags = sync ? MF_ACTION_REQUIRED : 0;
 
-- 
2.51.0


