Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE12FCC9D5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A24B6B008C; Tue, 10 Mar 2026 03:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879106B0089; Tue, 10 Mar 2026 03:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723C76B008A; Tue, 10 Mar 2026 03:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5676B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:24:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFCC1160584
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:24:24 +0000 (UTC)
X-FDA: 84529315248.21.76DE583
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf08.hostedemail.com (Postfix) with ESMTP id 645DA160002;
	Tue, 10 Mar 2026 07:24:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JDM+DRfU;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=KpXmOQhJ3sL1UpmJly60whFZCDkostnJo92E4Hsv4QE=;
	b=fNotsZDTaIzk+L7IUlvjpsZWnvsYAf96Fkx52m13UJppZtRCGimEGdHvFb9oI96PAoEix3
	bqPoxOtCb36fxkrOwfLy+Mq87tnICFECl8rL++0/bJJC3FpJFSpF2v8bQgNxHcTfoXJTTJ
	K6Qr2q0EMy5Y1seN0dtt8f59VEfhzF8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JDM+DRfU;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773127461; a=rsa-sha256;
	cv=fail;
	b=w/gOnAlVxvG63V8NJUtiXMCquDOEIMFFhTYlxbEY0JR0obUhPemGsc1oivTH07piCOeY7Y
	C+LFgGJ9PRwARPzF8gw3su4RZoakMcnWTzvBEpH5xXPfGC4rk0NbO+Xm5RtuAUuKgKwb4x
	QTSmpXlvZAkCD0Vv6DF8WnvNqM2fXsA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773127460; x=1804663460;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=Q6gdGzBjkEr28FaFLHfyKH7rBfhdW+v63vzPu81yPXY=;
  b=JDM+DRfUndQNKCceK1ei81aO8H7nLRZ9A1zGC1O4A9ANvaoNm/G790Ke
   m8KhhC2FhqbGPYt1omEQDWclyP2uQabOngLwM1XMbUPNq2weDdYQ2VRIc
   uqUNQrVDgv9uPb0H8owHIi+K47UttgftqPDrwzXC9lVKRRgmlCwigyBIq
   DuQ98G8m7xWsGjbq+dAbLH1y+NEus+MqFtfEUpHNx5EoRb24kpMb7DQP7
   UdKOOCdPgM0+wxETGkbn1aaM4APmRlrIoaN0ZNJbn90U1D66+ymgMXoda
   2wEkQIhEx2xlkdcsqrzF7qEutrGfk5LItXYQIdS2ZreH4d/cjoP5LqjHc
   w==;
X-CSE-ConnectionGUID: APq/43xsQS2YsuIZ5yNXkw==
X-CSE-MsgGUID: p5VXQc52Tk6f+VYISg8OUw==
X-IronPort-AV: E=McAfee;i="6800,10657,11724"; a="74042003"
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="74042003"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 00:24:16 -0700
X-CSE-ConnectionGUID: l4d7Z50lQVyzcJmCOD1/9A==
X-CSE-MsgGUID: 2U84qiPiT2itrDl7s9eLmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,111,1770624000"; 
   d="scan'208";a="218015735"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 00:24:15 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 10 Mar 2026 00:24:14 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 10 Mar 2026 00:24:14 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.32)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 10 Mar 2026 00:24:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpKQHUl3jRnx0KcMNqPaFu4P+lyiYvaG65/O5MIhQcFozhaT5iJhTBrQ+j+alol5fFMLmttlcImUytShxfrvT7VSvalB5mrbFxUSPTRt05ISzsHMSKo7+oUpFPP7VCqVy2m6IqRjdNBuBiu2QyyoM9UyyaLEfNMWWlGeu+6b7TpmG2Z/1ZvmhH2a8HcblJT9VeQMuqnDlmVjOBjrALFiRxjojPe4JGZSu9MkK3+qk8tCshvD+NaZ0bA7gmPIsHXZdji8QY4F0hh/TkCperMhKzy+jMluHUHSeN6GpoGfEl4pWYCYRlr0bGMaOEr71WbhmSlXFY2/AK6BN6oDctMWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpXmOQhJ3sL1UpmJly60whFZCDkostnJo92E4Hsv4QE=;
 b=jM6huFPll0yGt6hgPcH1ERlHCK49f5cDMal0/FaL8AiSxcEO+HmJPL6prHSvSK+Iru57aK5WnlBRjPf+rBPvj5iVtUxEmOXp4v4/+4b8ImtQBu7Rm65/d0BibeocTgoI67oKkn9CISV3UfFTDGGBH2DyjBwLBbx+pO2e10w0aJFk1LFsDz9WwPD1o+PThppdqs/6NZUeZ1TsEaK+lB2SGOjgWN34ymimBRZYwdJhtwrwilG4F+MulwOdo0kMLBim3tDW46Jro+tAOoJROCXGwS6iouj6v56q6B+TF2JPAnNiqsyfpsR6Db9iJuuN+iL/Yw2+SAJF2dDplyo+zSDRtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4033.namprd11.prod.outlook.com (2603:10b6:405:78::25)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 07:24:11 +0000
Received: from BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1]) by BN6PR11MB4033.namprd11.prod.outlook.com
 ([fe80::2c28:2983:2947:24b1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 07:24:11 +0000
Date: Tue, 10 Mar 2026 15:24:00 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jan Kara <jack@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<ltp@lists.linux.it>, <linux-fsdevel@vger.kernel.org>, Christian Brauner
	<brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	<linux-ext4@vger.kernel.org>, Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian"
	<aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, OGAWA Hirofumi
	<hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
	<linux-aio@kvack.org>, Benjamin LaHaise <bcrl@kvack.org>, Jan Kara
	<jack@suse.cz>, <oliver.sang@intel.com>
Subject: Re: [PATCH 12/32] hugetlbfs: Stop using i_private_data
Message-ID: <202603101532.fecbeae3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-44-jack@suse.cz>
X-ClientProxiedBy: TPYP295CA0055.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::15) To BN6PR11MB4033.namprd11.prod.outlook.com
 (2603:10b6:405:78::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR11MB4033:EE_|SN7PR11MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: 2102a4ff-4d67-4d66-509f-08de7e760685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: pmSeKy3XcbYFaItN5JCigQb7zp6pOwKzMnc6OjQKUR9S8/XqyHCgzp8PkpoDvW6GoSJnZ4VOxwcb3y/G0YJrVAcNqT43fTr39Re7o+A10GC4XTAeONWbenGo+/A/JQXRUYwadKVU9f6d1FeeqC5D43u8TUx68Y3e+xLIkpsr4VAxn43iTaMY5ajTlw6t5BsaBpQ5GM3xlTIlImwbiWnjXe9L1tBr4PIRhF/X83jXeR2/yPZyDJJt0B1S+y2omSKPiRSXuQO7kKNWehmtigJh9k7r2NhteGkKVDKFBoVWnJF8ejCmkbPSrXvEIkUZI+AxHfs/ep3egudYJvjOIYiiAhyWra9bo0GJHh/ogJGRAVjwfBmEKsl0LVkHElcGsR5iYxm6yt/GhFD3RiTW8M2gV0xOaB3qNeiVTX8J2+ndzQ9Q6I1XUGVKioQ41zWOGvDp/cC7y0TLaadCuJ3GAS8DqWgUB62zLA3VZVIqaGeu37u3t7RVX0AnWURgXsk20UOIEPwfp0ehuiI9BBUQ2BrlaSPkRAQqdyvFOcyh0Q8ZAyHRlnTSP0gF+qwzKKCFIw1TdOVOkOPt6CpJgnLUzVOPbXSjm7WTNmK7gJ6vPCM1qUyqDT90ejFhUpH6hTK+q9qo2PpvX1Xb0zadpGa66NWe13ln3THXJeDjudaNCm5iAR7NXpt58Tw5PR+scf7d1CU/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4033.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dj/lLYIDkg7cjqoGCMJmmujXBKv7+MvHnV/6pWJdxNJlv8KnNNHPNHlKD167?=
 =?us-ascii?Q?7TRpeWb+XQV3nMZB+MK/OcYR7KV7Z0SE0iW2YWQ4hH6aubAh6nV/ZeEeN2dM?=
 =?us-ascii?Q?ixiqSEhFHI8D3jbW79vzxwA7NJaCH41uaUtI2k1B5DCRhAXPZTQH/uGYALdH?=
 =?us-ascii?Q?7HFoUUb9/cW1lzFSpgI0YkytUL8xsHkndZ8JMlZ2jrmI1qlgunISbkD7DR7/?=
 =?us-ascii?Q?5sAC7I5ADXA71h6bAuxq3Xb6IIkuR4b16qqnKl0ZImigWQby2Sxbg3ultCAl?=
 =?us-ascii?Q?wmYbD+RW2dSMUsJj9TCPtk9Mk+W6aSZzyiIe7LLkq6KqQK/VHeR9b81A6B2+?=
 =?us-ascii?Q?Gruwpv4Z5WySNn2EGxzkLd4vmuY+rxy+r8KyO3qY33YBLssjIlir+VDE1v9w?=
 =?us-ascii?Q?VTbP3HZO0AZMHxKR5snXU4dUbctxJ6UjJeLxsDlozgta/EMz79G1RanmZSaR?=
 =?us-ascii?Q?9zR6o5npH+F3L7LBEHi6pmmm6cnTyGdPNnGOKZFK9sEfglYmphQHgAJWGFob?=
 =?us-ascii?Q?RDYPPLqKibkHRyX/3HjicGCy2j5zhoT4uvvdQATmNsrVmwFVTSK7RCvwNola?=
 =?us-ascii?Q?i/jIh2D8gKqVMWL78Dzad6LBjc15xW8Co/2vQ59i9fgDe9pxuXVeNrBVGRrX?=
 =?us-ascii?Q?8gDotLaaiM3BloSNzRyvkHi4apXIqSXDMzhf2H82n1XiMrQeoXvwKL6KCJSB?=
 =?us-ascii?Q?ErGH3oAl7uNSmcoLlxOVZT0bUWHQu3UgsHND/6tHRXB1IIUkSneoynI/3cp+?=
 =?us-ascii?Q?nUoJqS9LRSu9q1VZULeyjXh/EqDml2nHHOO13y7HBeuzqGv0A6R+571DmpIm?=
 =?us-ascii?Q?MIgTUzMKpW4oyzOY1kMHgMLTemXPqC7szAZZlHeMf+FaclS6ZkrPDqq7BCr/?=
 =?us-ascii?Q?33xkI6vyZ4PT0w8DmWRdj+O3YeKzE9MwYyb142GtiMXi+Cr2iPbswO3eUu1P?=
 =?us-ascii?Q?MXa5U58mHwXyKn+MPfgS+VhBRptwQxRHr7Mbw7nmEE78IJCm2AbBWTA9sR71?=
 =?us-ascii?Q?WZiNkuou4iztPBlT3DpQy4qSq7zOB8k7p1dbC1AGTDjTqiTB3ldmAB4XnNAM?=
 =?us-ascii?Q?yMzV6Dkvz9UKdAtn6BJgLcJuE7+5JXPinMM2RytqM4kKTuC8wicM4D2a7ZTs?=
 =?us-ascii?Q?U14XmkxEZeXl959JMFsEO77NpaTDs1/AqVKrcRNDFXfacxcB3MJv4E8TPQI0?=
 =?us-ascii?Q?SydlooHl2012uX84cYluB16hg1rSj72o49t1SwgurqryrnZNxE6A0TmB+X7l?=
 =?us-ascii?Q?KIUyKMs6Tlpz7SqN5ozGpZMd+JkXiH48l2yJr473sQzNYGSoqK7PcTXvAdsT?=
 =?us-ascii?Q?E8kyUB31RYOrStOC5nAwyP1klnpEBkQwqE49cCW6XGbpJmNqZVf1n9XlEexM?=
 =?us-ascii?Q?gHA8pxdj5jtUKVAOuuP6PmYZ6ZxmIzXlCJj/codXU4txLNkimroPImzjPTn2?=
 =?us-ascii?Q?GMLabPUCTMBfUSgCXOyKF3I2ug+atb4xsR6n+QXDLBtdf7TMMFYLIV9fygmN?=
 =?us-ascii?Q?b3mdtzADX4dT0gQlZlHdPiCTxHvkuExzKviiMKtJjF60kl2N3cysvtw8VIGM?=
 =?us-ascii?Q?c8nbHFmdF9Cq60ymcfzq9NVAxhqYLx1MAJ7yvG0xjaeXDgX4+Dy8WJ3VaxqQ?=
 =?us-ascii?Q?bLU1HeIn3BT2A9rLNPeu/bpucVfQbuPOCLyHSxJ8a78pyDJ5e4vagsEjnX3n?=
 =?us-ascii?Q?7+YWiwUatf3Qy6BgPOsLJm/tPNVAYAM4MFqJs5e19ZAyRbII2DN3EFPZQFKO?=
 =?us-ascii?Q?wFDMfsRcIA=3D=3D?=
X-Exchange-RoutingPolicyChecked: rgieXA0dh7hiJvuHsJhf7dn6ii1cWymrxTrYcqyUBEI/gxZdcQ3o2sbPnTTJoIjDy6DnGKVdPqNrfbEK6gz6zAyMHCfPMM8LTEEqSVr/0izK5NS5N7qPRwkrVOqi7aisw2giyjbpjgQJvCTWiB96/PsenNOBcgB98DKEWjvxw+/fZiHEDtVfbLILYykTguKPctaX3Oo/m2JYGas3yCyuFyjHe0RpbX7SSk9RqrJQKQoYkou/jIoQIkDkYdJ+a9pWeGNPlcZN3QLZPNHvqbWSOlW2zR+mA2oRhGY+kLSDUrQI4gSvyjH/zaDOkR3qoRm8wD9vFoMuV44Y1ueH9GfaYg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2102a4ff-4d67-4d66-509f-08de7e760685
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4033.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 07:24:11.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOKwgk5PhpmWKPjZkj3XlI4NqzbYk5NlRjeFQRgSoTy4EP4iee/v2nBe0CZ0Gpwj23ty9dui7IHWCArM4Kg2XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 645DA160002
X-Rspamd-Server: rspam08
X-Stat-Signature: i9g646m3xbn649i1ri9dnaxdiou4e8j4
X-HE-Tag: 1773127459-690154
X-HE-Meta: U2FsdGVkX1+hAqX/tvieFwrmudpr/hkAwsAA+LIh6/We/MVcAHTa2moLw3CsiO2vmp8L868QoiCLhVxBD0iBOVnlP2Avm1tLDpEyEj2lg4Bhn3lcUYIrv29l4eeI1LLrSvJs3myucT45C++NXMjJoyvaMkE9FANC/gBDdpbfZsbhWZPVggJqMep2P2BJrxjZiJtn4rbXoH/No6OWDI7Tz/jsLBLjnowZ3juVo7tQGeJb5PdzsJzEaLlLFAHAGTDS6JKUnbkPN/lOSSbSnxL1MNQ8xqoizyTuI9eusylD27tt6w5RsxHKa+c3sMNwhT8xlqvkoEoD7UmDTO6U7gkxePLHa0ZBw4RnQOg0aNfBh37FUhBGJF3QwH/O7JaeMlil+nYbHjfyeJVPeBFWbSKxzgdYcKWfEFOC7fdZCsl4TdkgrSEhP8sLf0wO+MtfU4HpOJZwIsrt8+hMXjiJ6BXwqoIcZXLgEtdHCjsx8ew7+k0u4aZdqZbuhdPWWCgvjY3eWCF4xCx1yqLanFPuDG9QQt49Cl60t29fa0ysC7hO7Gqhk/vs5+amp/mPojpaSBgbJxH70BS/L4SVvjPjTlG4O6bax8U4VNacvBwsInRmBgZc5sHrU9QoLvuMdX0+qNdD9KEDrSSO5eLpi99ygu+bJ8dsABbdq7Fo3rWocKmKX6qkmUFHa1Nr4i67GfB9QNVMpjRNtzw7plUHxp5i6Qh5IRK+OZVKMFM9dVkqgBMeXzECTTDpEXQ1ngNwob9spKe1joxFx+oqJuXp2lAoVFyDLJaHTcdMjrc+QyjKphOEXATxAnOeiXYet/zaVp1vjQd43wu0Rij8m2W/Auhjc8RNbOVCDTxHv3w8v3CBhk2YaVJs7PSoLwh7G5JpQfftAhz8Faynxcpe91YyrmpztJD6Cx0v2xAsxNjuHKt351SlaUeJ+9X4nPGGIaQ8i40j+IlD2HvcNMmMuc0Ihbk4s7G
 HoFutM7q
 v1c4g+OEBthUVR5NCgcJwGbzRfNzXmTCamhi13H3DC9C1Lgc+FLJFoeLLhPbk0FVfbUbqeEwPqe5nSW+XpqRvzIlspJWig+dKlKYG1HgfmG/WLpszv6x6Lq0wSP7pRckzRoEP/86ZIcXN5b6zVLZvMkfO+J3Mp3WJqJcnTdkJfB2akqkKzPnxFZUWVxn09j2h6l9oeHAonrmsJ9+mlFI6Un9LGT3yzyo/Vd5Ztw3JYXVDThRGX8iY55PjGpI9K1Xv/jEcTjUxXB+T/g/IlxyjxedhyhUXow2CgkBVDLDrUeNgOkN5WbPuGDQvjYEhLMi1m5sqELX7WpY4rGbcJR1BlKW6VniSU7GbeSWrjJVRYFPzAlX73h0iCPCc6JIezAztxBxSMletuFYMqSZigik9O11dTPUgg+tCHx5fV93RLMaEYMF/MgT/v6DFEGSEJ6qr+WTLU6pO8QKQL9Hi8Qw6MT9Rq1sGPOTrz4Mj2vwQtEKYj/fBeyPJv9zIrnNLN05o+IjaiSzQj+eUG3UCC/ojV0q7RW4f2aZS1ygzgoVcE9+1IuEZ/XqAh7TsTYxzouYC3f3DALUi2iPNETuTnIsrN8D6ohqgKB4y/byo0aN+01d644pNYwIaVsfe1BUfXNc3QQ/lRoKNDcne/crf2tx8MxwfxRl4lfaKDZtvZAqjojqHFypIHPIHGgmrHlA1d5tErx5P0pJYG9GqqTsc6D3UKP75xymZt40fgz+t2qI8f8ireQ5dy7Cv389JcUOV3l8Pa0Ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:KASAN:wild-memory-access_in_raw_spin_lock" on:

commit: 75576f3c4ced72ab572ee9275b464cd79763fd85 ("[PATCH 12/32] hugetlbfs: Stop using i_private_data")
url: https://github.com/intel-lab-lkp/linux/commits/Jan-Kara/fat-Sync-and-invalidate-metadata-buffers-from-fat_evict_inode/20260303-183910
base: https://git.kernel.org/cgit/linux/kernel/git/vfs/vfs.git vfs.all
patch link: https://lore.kernel.org/all/20260303103406.4355-44-jack@suse.cz/
patch subject: [PATCH 12/32] hugetlbfs: Stop using i_private_data

in testcase: ltp
version: 
with following parameters:

	test: hugetlb



config: x86_64-rhel-9.4-ltp
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz (Kaby Lake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603101532.fecbeae3-lkp@intel.com



[  270.445802][ T4529] BUG: KASAN: wild-memory-access in _raw_spin_lock (include/linux/instrumented.h:55 include/linux/atomic/atomic-instrumented.h:1301 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:154)
[  270.453010][ T4529] Write of size 4 at addr ccccccccccccccd0 by task hugefallocate01/4529
[  270.461165][ T4529]
[  270.463347][ T4529] CPU: 2 UID: 0 PID: 4529 Comm: hugefallocate01 Tainted: G S        I         7.0.0-rc1-00214-g75576f3c4ced #1 PREEMPT(lazy)
[  270.463352][ T4529] Tainted: [S]=CPU_OUT_OF_SPEC, [I]=FIRMWARE_WORKAROUND
[  270.463353][ T4529] Hardware name: Dell Inc. OptiPlex 7050/062KRH, BIOS 1.2.0 12/22/2016
[  270.463355][ T4529] Call Trace:
[  270.463356][ T4529]  <TASK>
[  270.463358][ T4529]  dump_stack_lvl (lib/dump_stack.c:122)
[  270.463362][ T4529]  ? _raw_spin_lock (include/linux/instrumented.h:55 include/linux/atomic/atomic-instrumented.h:1301 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:154)
[  270.463365][ T4529]  kasan_report (mm/kasan/report.c:597)
[  270.463369][ T4529]  ? _raw_spin_lock (include/linux/instrumented.h:55 include/linux/atomic/atomic-instrumented.h:1301 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:154)
[  270.463372][ T4529]  kasan_check_range (mm/kasan/generic.c:186 (discriminator 1) mm/kasan/generic.c:200 (discriminator 1))
[  270.463374][ T4529]  _raw_spin_lock (include/linux/instrumented.h:55 include/linux/atomic/atomic-instrumented.h:1301 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:154)
[  270.463377][ T4529]  ? __pfx__raw_spin_lock (kernel/locking/spinlock.c:153)
[  270.463380][ T4529]  ? filemap_get_folios_tag (include/linux/pagevec.h:56 mm/filemap.c:2359)
[  270.463384][ T4529]  region_del (mm/hugetlb.c:864)
[  270.463387][ T4529]  hugetlb_unreserve_pages (mm/hugetlb.c:6757)
[  270.463390][ T4529]  remove_inode_hugepages (fs/hugetlbfs/inode.c:616)
[  270.463394][ T4529]  ? __pfx_remove_inode_hugepages (fs/hugetlbfs/inode.c:579)
[  270.463398][ T4529]  ? stack_trace_save (kernel/stacktrace.c:123)
[  270.463403][ T4529]  ? __pfx_stack_trace_save (kernel/stacktrace.c:114)
[  270.463407][ T4529]  ? stack_depot_save_flags (lib/stackdepot.c:667)
[  270.463411][ T4529]  ? kasan_save_stack (mm/kasan/common.c:59)
[  270.463413][ T4529]  ? kasan_save_stack (mm/kasan/common.c:58)
[  270.463415][ T4529]  ? kasan_record_aux_stack (mm/kasan/generic.c:556 (discriminator 1))
[  270.463417][ T4529]  ? __call_rcu_common+0xc9/0x970
[  270.463421][ T4529]  ? deactivate_locked_super (fs/super.c:476)
[  270.463426][ T4529]  ? cleanup_mnt (fs/namespace.c:227 fs/namespace.c:1313)
[  270.463430][ T4529]  ? inode_wait_for_writeback (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 include/asm-generic/qspinlock.h:57 fs/fs-writeback.c:1598)
[  270.463433][ T4529]  ? __pfx_inode_wait_for_writeback (fs/fs-writeback.c:1594)
[  270.463455][ T4529]  ? __call_rcu_common+0xc9/0x970
[  270.463458][ T4529]  ? task_work_run (kernel/task_work.c:235)
[  270.463460][ T4529]  ? exit_to_user_mode_loop (include/linux/memcontrol.h:915 (discriminator 2) include/linux/resume_user_mode.h:59 (discriminator 2) kernel/entry/common.c:67 (discriminator 2) kernel/entry/common.c:98 (discriminator 2))
[  270.463463][ T4529]  ? do_syscall_64 (include/linux/irq-entry-common.h:226 include/linux/irq-entry-common.h:256 include/linux/entry-common.h:325 arch/x86/entry/syscall_64.c:100)
[  270.463465][ T4529]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[  270.463468][ T4529]  ? _raw_spin_lock (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:159 (discriminator 4) kernel/locking/spinlock.c:154 (discriminator 4))
[  270.463483][ T4529]  ? __pfx__raw_spin_lock (kernel/locking/spinlock.c:153)
[  270.463486][ T4529]  hugetlbfs_evict_inode (fs/hugetlbfs/inode.c:625 (discriminator 1))
[  270.463489][ T4529]  evict (fs/inode.c:849)
[  270.463507][ T4529]  ? __pfx_evict (fs/inode.c:822)
[  270.463511][ T4529]  ? __pfx__raw_spin_lock (kernel/locking/spinlock.c:153)
[  270.463514][ T4529]  ? _raw_spin_trylock (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:97 (discriminator 4) include/linux/spinlock.h:193 (discriminator 4) include/linux/spinlock_api_smp.h:90 (discriminator 4) kernel/locking/spinlock.c:138 (discriminator 4))
[  270.463517][ T4529]  ? iput (fs/inode.c:1963 fs/inode.c:2012 fs/inode.c:1975)
[  270.463519][ T4529]  __dentry_kill (fs/dcache.c:673 (discriminator 51))
[  270.463522][ T4529]  finish_dput (fs/dcache.c:879)
[  270.463525][ T4529]  shrink_dcache_for_umount (fs/dcache.c:920 fs/dcache.c:1657 fs/dcache.c:1671)
[  270.463528][ T4529]  ? __pfx___call_rcu_common+0x10/0x10
[  270.463531][ T4529]  generic_shutdown_super (fs/super.c:625)
[  270.463534][ T4529]  kill_anon_super (fs/super.c:437 fs/super.c:1293)
[  270.463536][ T4529]  deactivate_locked_super (fs/super.c:437 fs/super.c:478)
[  270.463538][ T4529]  cleanup_mnt (fs/namespace.c:227 fs/namespace.c:1313)
[  270.463540][ T4529]  task_work_run (kernel/task_work.c:235)
[  270.463543][ T4529]  ? __pfx_task_work_run (kernel/task_work.c:201)
[  270.463545][ T4529]  ? __x64_sys_umount (fs/namespace.c:2065 fs/namespace.c:2070 fs/namespace.c:2068 fs/namespace.c:2068)
[  270.463547][ T4529]  exit_to_user_mode_loop (include/linux/memcontrol.h:915 (discriminator 2) include/linux/resume_user_mode.h:59 (discriminator 2) kernel/entry/common.c:67 (discriminator 2) kernel/entry/common.c:98 (discriminator 2))
[  270.463550][ T4529]  do_syscall_64 (include/linux/irq-entry-common.h:226 include/linux/irq-entry-common.h:256 include/linux/entry-common.h:325 arch/x86/entry/syscall_64.c:100)
[  270.463552][ T4529]  ? __pfx_vfs_write (fs/read_write.c:669)
[  270.463555][ T4529]  ? fdget_pos (include/linux/atomic/atomic-arch-fallback.h:479 (discriminator 2) include/linux/atomic/atomic-instrumented.h:50 (discriminator 2) fs/file.c:1196 (discriminator 2) fs/file.c:1210 (discriminator 2) fs/file.c:1256 (discriminator 2))
[  270.463558][ T4529]  ? fdget_pos (include/linux/atomic/atomic-arch-fallback.h:479 (discriminator 2) include/linux/atomic/atomic-instrumented.h:50 (discriminator 2) fs/file.c:1196 (discriminator 2) fs/file.c:1210 (discriminator 2) fs/file.c:1256 (discriminator 2))
[  270.463560][ T4529]  ? ksys_write (fs/read_write.c:740)
[  270.463563][ T4529]  ? ksys_write (fs/read_write.c:740)
[  270.463566][ T4529]  ? __pfx_ksys_write (fs/read_write.c:730)
[  270.463571][ T4529]  ? do_syscall_64 (arch/x86/include/asm/atomic64_64.h:15 include/linux/atomic/atomic-arch-fallback.h:2583 include/linux/atomic/atomic-long.h:38 include/linux/atomic/atomic-instrumented.h:3189 include/linux/unwind_deferred.h:37 include/linux/irq-entry-common.h:296 include/linux/entry-common.h:327 arch/x86/entry/syscall_64.c:100)
[  270.463574][ T4529]  ? do_syscall_64 (arch/x86/include/asm/atomic64_64.h:15 include/linux/atomic/atomic-arch-fallback.h:2583 include/linux/atomic/atomic-long.h:38 include/linux/atomic/atomic-instrumented.h:3189 include/linux/unwind_deferred.h:37 include/linux/irq-entry-common.h:296 include/linux/entry-common.h:327 arch/x86/entry/syscall_64.c:100)
[  270.463578][ T4529]  ? irqentry_exit (arch/x86/include/asm/atomic64_64.h:15 include/linux/atomic/atomic-arch-fallback.h:2583 include/linux/atomic/atomic-long.h:38 include/linux/atomic/atomic-instrumented.h:3189 include/linux/unwind_deferred.h:37 include/linux/irq-entry-common.h:296 include/linux/irq-entry-common.h:341 kernel/entry/common.c:219)
[  270.463581][ T4529]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[  270.463583][ T4529] RIP: 0033:0x7fc1ffd84217
[  270.463586][ T4529] Code: 0d 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 c9 4b 0d 00 f7 d8 64 89 02 b8
All code
========
   0:	0d 00 f7 d8 64       	or     $0x64d8f700,%eax
   5:	89 02                	mov    %eax,(%rdx)
   7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   c:	c3                   	ret
   d:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  13:	31 f6                	xor    %esi,%esi
  15:	e9 09 00 00 00       	jmp    0x23
  1a:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  21:	00 00 
  23:	b8 a6 00 00 00       	mov    $0xa6,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	77 01                	ja     0x33
  32:	c3                   	ret
  33:	48 8b 15 c9 4b 0d 00 	mov    0xd4bc9(%rip),%rdx        # 0xd4c03
  3a:	f7 d8                	neg    %eax
  3c:	64 89 02             	mov    %eax,%fs:(%rdx)
  3f:	b8                   	.byte 0xb8

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	77 01                	ja     0x9
   8:	c3                   	ret
   9:	48 8b 15 c9 4b 0d 00 	mov    0xd4bc9(%rip),%rdx        # 0xd4bd9
  10:	f7 d8                	neg    %eax
  12:	64 89 02             	mov    %eax,%fs:(%rdx)
  15:	b8                   	.byte 0xb8
[  270.463588][ T4529] RSP: 002b:00007ffc300541e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  270.463592][ T4529] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fc1ffd84217
[  270.463593][ T4529] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000056024b59b06a
[  270.463595][ T4529] RBP: 00007ffc30054470 R08: 0000000000000000 R09: 0000000000000000
[  270.463596][ T4529] R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
[  270.463598][ T4529] R13: 000056024b59b06a R14: 000056024b59b7d0 R15: 000056024b59f8b0
[  270.463600][ T4529]  </TASK>
[  270.463601][ T4529] ==================================================================
[  270.864814][ T4529] Disabling lock debugging due to kernel taint
[  270.870833][ T4529] Oops: general protection fault, probably for non-canonical address 0xccccccccccccccd0: 0000 [#1] SMP KASAN PTI
[  270.882549][ T4529] CPU: 2 UID: 0 PID: 4529 Comm: hugefallocate01 Tainted: G S  B     I         7.0.0-rc1-00214-g75576f3c4ced #1 PREEMPT(lazy)
[  270.895404][ T4529] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [I]=FIRMWARE_WORKAROUND
[  270.903398][ T4529] Hardware name: Dell Inc. OptiPlex 7050/062KRH, BIOS 1.2.0 12/22/2016
[  270.911474][ T4529] RIP: 0010:_raw_spin_lock (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:159 (discriminator 4) kernel/locking/spinlock.c:154 (discriminator 4))
[  270.916599][ T4529] Code: be 04 00 00 00 c7 44 24 20 00 00 00 00 e8 8f 19 e5 fd be 04 00 00 00 48 8d 7c 24 20 e8 80 19 e5 fd ba 01 00 00 00 8b 44 24 20 <f0> 0f b1 13 75 2d 48 b8 00 00 00 00 00 fc ff df 48 c7 44 05 00 00
All code
========
   0:	be 04 00 00 00       	mov    $0x4,%esi
   5:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%rsp)
   c:	00 
   d:	e8 8f 19 e5 fd       	call   0xfffffffffde519a1
  12:	be 04 00 00 00       	mov    $0x4,%esi
  17:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
  1c:	e8 80 19 e5 fd       	call   0xfffffffffde519a1
  21:	ba 01 00 00 00       	mov    $0x1,%edx
  26:	8b 44 24 20          	mov    0x20(%rsp),%eax
  2a:*	f0 0f b1 13          	lock cmpxchg %edx,(%rbx)		<-- trapping instruction
  2e:	75 2d                	jne    0x5d
  30:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  37:	fc ff df 
  3a:	48                   	rex.W
  3b:	c7                   	.byte 0xc7
  3c:	44                   	rex.R
  3d:	05                   	.byte 0x5
	...

Code starting with the faulting instruction
===========================================
   0:	f0 0f b1 13          	lock cmpxchg %edx,(%rbx)
   4:	75 2d                	jne    0x33
   6:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   d:	fc ff df 
  10:	48                   	rex.W
  11:	c7                   	.byte 0xc7
  12:	44                   	rex.R
  13:	05                   	.byte 0x5


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260310/202603101532.fecbeae3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


