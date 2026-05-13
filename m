Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5C6CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E459F6B008A; Wed, 13 May 2026 03:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B946B008C; Wed, 13 May 2026 03:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B056B0092; Wed, 13 May 2026 03:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF1256B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:41:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70C771A079F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:41:21 +0000 (UTC)
X-FDA: 84761601162.07.95BCD31
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3693160008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:41:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BA+d300Q;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/0bn6S2brOA136WPswm2jmX1hrZ12/JwoI/GtW6SCWw=;
	b=aVC0baDh0DJp6MYvfvEg7JBakU3RUrx7m7NDEh9sCdgN+8Tdp4r2HJCvHe1/kRqLBs/wru
	AJuyZL5X/c3hkEvb8T01FE8pk9grKqZknLTX20dcy7xFKgM0HtS/UL/rtuXfa2lZwxMmq1
	lnd4iNRH7Nff0Q8HW8NV9mbrd8d/f+U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BA+d300Q;
	spf=pass (imf08.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778658077; a=rsa-sha256;
	cv=fail;
	b=cmZLhj5ReawYWhXxB/2zayJZmm78//k3troh1GMZxLGsJoZLwqdJGmsXI5/NDWFjcRgqWg
	/vLuhVoQ+n4s6wPj5t4rA1x7KEDkz8tZSaYVYdJsO6h0Yp/46DgBqSZvhTGODBkfX/lStD
	uGsE6+EpurHP4YlK/h+4yyJwUeo7Wm0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778658077; x=1810194077;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=yRU1HGc0eM7hP0e5umhSev26WOWYXHtRzBA/N54RuEE=;
  b=BA+d300QXkACbi0zCuvm3R3FyZgNx7LYdwxxvnusULMOdQE8nVSL+kEE
   Iw6mxWpP/o5eKUvCyZhOKmlkbuV+SVp8xjDRZ6kU1nzjyoKqwWKJ3wPjr
   F25CkG0dA/gKlZDVwDY0nMUP6ObI32zWZ6vHiuNCjuOPS+zEDQeMDjuYd
   483X9gN3QnvyLjrp49Ke4aOZPyLYjUXWptBuPGQHMHllSQwXt7NQnzxyR
   mA5x6ULkOob2yCmvaqtCDs1wTq2AejoWUgvvAgzbKRngCXQk3qLTMK3ih
   gkWjC8sgDiff7OTv2wlR/hBrkY1vr9xMflsFjxUF/j/ouVVuaTcZjRrNM
   g==;
X-CSE-ConnectionGUID: lsHn/m/CTe2VfV6V7nZdnA==
X-CSE-MsgGUID: 3MJLl6U2TF6YfcjGyuvf+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79691120"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="79691120"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 00:41:15 -0700
X-CSE-ConnectionGUID: sEWEazOqSvegO4sEdAG//A==
X-CSE-MsgGUID: N3+5HRuDTrue8nK6LdkEeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="276120781"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 00:41:14 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 00:41:14 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 00:41:14 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.21) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 00:41:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f9+dpa+4rWiEVfceWeOzEDXq0fo3aTFijygQJUksyDa25qN8nffaG90WEYxP3TP2eVaSWF9StmYl+uK0QPFZveEZ97V9N2/cIbB1thA5WtLwWNCB5yC3+yclFBxwlK9pk8+HFZ1aEkHkwvKObU2TzDVykBk1dRPQyBNm52Tz7DnL00thIJkHIJ+SKj4QKaizM6PRfytFXrSnRTd206VWd2XyPUBX1m7APMZnp5cMMrmJaJx3zyYsaYRvUN4WBbITE2zgc3iz84vMvJAdkd9X4yjyCp4QhoyC2cFPiZ/UgtmA9I6jvrPqy/IJLZCFY4KLJ361dvM1TB0Uzma8oEQmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KidfGOrBItJ6FfEjKeCnu6zYGY8xOdvVzoj+Cx4buZk=;
 b=k2RyorYJrfNpu0Svf3YMRbZ4mtTXLQ2Flaa6hh9SvAPh9rLqlMQ/5NuFAKCH/PHHXKwQZsByfOuxWV5n0mesfuJ7GvILwZqW2Husl2wrX5NzfMIFDO4g74/Q0BR5YG2Aqn6IeX0vfF1I9JXKIpONzUuHl5Ur+r+41fZm1JykmO8O9S/vqGwJl4TrmREq5ZawDFNGoce02uuhgL6NRVdg5nv7J3zEc0hIlKh1TW29a98T4o2K57Vnfcheq1Ukp/Rgcg6lC9TSo+524PO4U/4SyvgPHlfSHA2uUqyh7YOiVwsoxrsGYS089uRG39WfJ9daNsYOZR9iSfc5Y0qnwt4Wvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 07:41:11 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9891.019; Wed, 13 May 2026
 07:41:11 +0000
Date: Wed, 13 May 2026 15:40:59 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven
	<geert@linux-m68k.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <202605131554.92e7df6b-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: JH0PR01CA0074.apcprd01.prod.exchangelabs.com
 (2603:1096:990:57::9) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CY8PR11MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 133e76fc-a55b-4ecf-31cf-08deb0c30063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|11063799003|18002099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info: kAvRtwQXfNeoUjEqOBJR6UWMiT6G90flTZrNQ0RNzSi3p7F1WyR83lcCxue2lqtKadnvniywFYy9BfWzjI27MAI7ogaIVo+kU+K8Oo7rznw7czB9B27evg01S8ker6j0+UT+7JblJWpiNijI74HyOEMuWI2QudROqwxvjCy+osTJ0jP8FQZhkdgu8UdPvMdhQNSHJmMKmfSXNI+roTBP+rfj1FThjKjAdplEyICBWv3FifZ7vn3p5ioJpPqru3chMW67zvFUTR/WiYO0yq5MZvSO0Y18b+xJIVAUbBWVOt+QJESVOMsm3/jOq15AgSV2Y8EFu5uk3AdiI41EyA16BpfJe+qPYSgorN0JDGNhqpGTYsE9mBAZ36OOZBGngNVjigewC+RB1IjLmIb2O8d1ffGXtQovZJZ6pAJ6G+Rfy+A7SF3oNiSR3S8ZlIyKFJfXFQjOUqmcuyyWBXgsYP9Cle1b5z3wa+v+xZrQQ/ePlFw7oERzw5PCw+LGkrk7YBziUmf4dQrmQG+ib1Taq9IiC466Z6BVVQhieu5pUxQ/mctWvha4hRTn1i+nLYFNgSbSPNRgUSwWjjTvPBikSfE2jak9dIALAzshG56oCWKu4kKAZbIPjJgLl1q76CQj2GCdwp8C/ATzfQHvEvG+1v06yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(11063799003)(18002099003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?PDpG1ORvYfoADwTrZDCWQZGLqLskf1PU4vCJaSdEV3zYIEUodBvo1zQiUH?=
 =?iso-8859-1?Q?TfpF4kT7hcgVJl+kY9m5d4NVVBWUbfzwPcW6+TDdHUUFnHFQNngFKm6Rqi?=
 =?iso-8859-1?Q?eJ5YNS5UT8YrqlWKxC62j38z/bEej/7qdRARwglTrZJOH8KiFXul+vW1dz?=
 =?iso-8859-1?Q?89ltk/sAJNzZnVw0TJCfbygtjAYfAj9C1RPVDHexsYINko7mKJ/59dxanW?=
 =?iso-8859-1?Q?WlYhf2Z3IyJXss4SOHtN/0TqHpV7zemMaE8rZBj8lHufhr2G+XyCvooGwq?=
 =?iso-8859-1?Q?DoNB+WWS4OIZ3WRv7BsAQXlUFPP6rRyee43LIcBQXxPE/gPTlVpxKPr+Qz?=
 =?iso-8859-1?Q?+zJyM29rRvvLjGJjK2kJHbcM/UbJg1bxY2533gBIeOaEIeyVuGDalWuBXd?=
 =?iso-8859-1?Q?pq/ShOOCld/4HlV5HCLGkSk15HCn7RA4fhEwNvtwwplsVa8EGGEKHE3OmE?=
 =?iso-8859-1?Q?C4ZTchqWtv1NEZLwFp96tWHYq6C/gl0LyVXeC5iKE+3lZaIVt9FMgD2APs?=
 =?iso-8859-1?Q?qIezqSCHBipPalQihxRIDe+IScsf82JGms3RtYTTYlSqXc4Q1Ec5HlBC/r?=
 =?iso-8859-1?Q?TlCQ8QzCkNUOCKof3Mi+0Qd2EfIDbAEXU8VLHFbHPplIrgNKrKNRRnRvSM?=
 =?iso-8859-1?Q?aj/lZYq8uGdEuI9pcTS3+qetkMdympMxwQwx1d24pI36/XYsI48DMDWZjZ?=
 =?iso-8859-1?Q?j2+BcLWxVA/B4RUQh2LQx0+BkYfHbQCIJTIqfF6eq30GQNiakIqTe0UU49?=
 =?iso-8859-1?Q?esoucd0lgojH+Fo4lTL74sXw4NleLdn3JAFXmeZM7dPl/AiJA1wxhdfBD+?=
 =?iso-8859-1?Q?A5JB0vh+e6VRR3YuR63+FCBn3junRixMVuo82AQIhMyUqQcyXKbNLucuDi?=
 =?iso-8859-1?Q?j+mU7tfjpVI6n1HNXQ+1KSDE7Rz8ep+DQ9pI9nYQ1na+U1Jgkzbls6QDgD?=
 =?iso-8859-1?Q?M7CL4Hs3zp2Mh/DSO9WhorLt+AY4wEDDWcKrLj9NTz03mlnyxvDZIniQ29?=
 =?iso-8859-1?Q?UdnoJlCezB7IPgF2Ey+o8ImB1iGYY/tX1EeBqAl71j+lXEdg7MmWpkDAew?=
 =?iso-8859-1?Q?U6ypx7Y4/8k27C7V85GLyZL36+Tn/bC7fYgjDTMiDwsDtjLSlTpVY7ZbT0?=
 =?iso-8859-1?Q?BFD7ergNn26cDTYnW1nHw1taepF0aXg7CHpNkBMNDBMDU0kd1QNUSp9PxV?=
 =?iso-8859-1?Q?moyzGwf2k/Ce+fUWd493oECSSvWKpwKd+nXet+/Mb87Q2mKHGdjpdHKOXe?=
 =?iso-8859-1?Q?+cfJHosMNtXsQvtFRAQAoIfgD1dqDiX1rNL2QWEitWmJWswc67t5jAkIhp?=
 =?iso-8859-1?Q?55/dvRKHC7H36/vsoTBlTSdsm3oVq9BSuehKFPfDg48Ih0o8hyf9fGhDfk?=
 =?iso-8859-1?Q?XKOc0fEnrE5YXUJZeQ3ItSTLqlIp8t2sq0TZI0Fq4n02zKyF5MjLBlDt2Y?=
 =?iso-8859-1?Q?ZdRuaGQUl+T2UpG9AsFAPaur50B35yHUf5xNWz2/rcnadmhJDjfvGHo/mA?=
 =?iso-8859-1?Q?daYrkknQVrsFaRvRAJJfA0A/deiqwGonZNaeyXn14PrZ6nS9/FhniC99GZ?=
 =?iso-8859-1?Q?7jr4P4lY19VDUBt1HGc0TBhSFGoZnSiu9VUjsXshUj2+HO2ddzCRMbd4b0?=
 =?iso-8859-1?Q?ZHwxAxnHMS48jm1E3qdNfODv5Rc3OtxW7niCnphxAZpU7OgO9jj4Nse2Rp?=
 =?iso-8859-1?Q?7KI1tU2BLQFO2pgDGOnJmdxEEmEG04fXTNSt1c+O8QwmIkV8J4Qnhoj8nF?=
 =?iso-8859-1?Q?95KL7TcsEN4fUUIny89LGL2COpJFFUhpkM12ycyefC2dZF9MokPbutLcuL?=
 =?iso-8859-1?Q?48snGv1ZnQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: heGXPjBOydbhjoo4VNOO1gZe2aOc5CyB3yZpZnH1l8JPax9FYkWIDrcNyr8HVI76SnDvcRBk/F6Wy29Dg2Is1Ki1vUaetLTdYoKm6C0f37Svv9iujQKmVIVw3kMupZBMASWZl5P5Obw4BVNCCf5ETAct1V1S2EwLdmpcHW/OPXIwBB6Hlaz3za6ZcdvIUZsZ2PozhUKljcPKWqlcRJPMgUG8Q5MpQiYhzSWnGvCakqLLpJUTSuiFRMcdsCGxMqjAJhpmXIf0kQ6ZPbPZCDK9gwnuTANwIcRA0Yc7SKAr7ijvDZmVvuu0x0QxSKIv9iHICz0NsVPZYoNS/PuSRfWSjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 133e76fc-a55b-4ecf-31cf-08deb0c30063
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 07:41:10.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJ2162SirDZXVaPNlvor3MZhA0ne2uJPCcCbJloI0kdspoZ0MrqJg84EgZQuo0dxuKBuzdwbx4ux0vUCqVKZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3693160008
X-Stat-Signature: qer67zoexshn7bjmmynngytn16otj8gp
X-HE-Tag: 1778658076-476031
X-HE-Meta: U2FsdGVkX1+krFdB7ZCIvWrS64ar4PRZXSecUOkO7syzb4hNy1qGKV3Os9nGVrbBaKiucLIK8Jt5HDkyEnMo51cKV59kJILNjfPt4iCZH0wgBxqfPjgTiPGCWZfOy6R/rg3/hj4taCj9thj6eOUZ5Zr+i5dtROrDlWVkYFPvl65PNxZ7QQdTCcaNoeSvk4caNAA9D3tjpg2i6Nmcm/TQCApIetT70gFU75qgHHEYnLcGjMhVAAWbmm+B7C9b2DA9cTqpiAMHen3B/RgsDfFHT40jgNsXf6Y4gxsNaWWd+fXXI/KaOF6VSGoFuwi+CGajXHcKox1t7X6SIBQS9xpCJ7hFkY6MKPYYz5DWka/Vga52pfXh8tgy9YJ4S+pULZRU8CEgWfwIFE0V2SwCvgh2iJZpJDrrw25txh6XoKfAu44+O4sX6tq8YE2XJ1qwXbOV8ROmXVAUhIXY0vdZFR0lrEH4JTOT5Z414gxRa22B8PpaCGilpSFh386H7XBkNRHD1pX8zs7hw78cqtZzUzv1zNffp06qvBxyZbeAOIDyQeKIjd+7hlMK2IXfYTJUhp17BApNqQef9s5QSRmZU4QEXupQshIEWBPoAo7cr8FlfqlVBjhfEd5i2eHl49lc4CU3CbOYoCI4fnqY8X4ZW2tUMAAtCpxueNJgzsbLSWpetTWbqZU/YgIfrpmdBPRmuzokOiyucFCpwwnDnV3byqWg2hjqFu0WoVY4wWJ6ceug7aJRDYpL1nNz3tq4Dd2hAA5P3TOt7phCkIoFOyq0f9IV+L6Fvt1aOqg7HkxV3mzg478MrFbz9nZyqLWWPnRGloKauWu1Yzf6NqvEttk6U5N9wCoJkK33JNP2RN/bvjyZL4lyX4haEu/oSnwIYfBeRKrWh6tKGukfIEtQT1Plfa4KUmaJ8sSWaFQwkypSRxNqa0kqWvCHIkezjr9mZxoiQQx+Oqnem2Ad282QdXYxT6W
 FPHi3q3U
 Z+VBrxqMjV/74kGOlO7N32mWU4pZHoccguQeoAXiCX6/nCJdOQGYG7E9vJyfPHC8fD3s2LKa2G4tks5pw4Asm70/S1mca4JMLK27vrbSGA8XKL2goPxfIwKATC/4X/BoyODrpcmXSelqV5wjLeWZpy/GX5xg8ngiYjqmsy04xcXQsfCfwtmscHgdxX5AM1NM4npQOCu+7GPGYi2vnUHDTXMJDaQnFFHDtscDwaZ9CUrrCTJDszscBM/w5abxFd9SwvSQcCX6fPQ8QbX9XVgT6gwUNfeprE/NDZyzv8b5boklytnBpSNth6tWHvyrvyStZCK40EeNdINT4VUYQHPs8kemgPfC8bApOEB7Kei+qJb7CWY+Jxwq8aD0+Tz4LY+qHCmhFKLdXo1VPXVNbHoo9/U+U2SBAn5z1ryUlWQLPNqlB6hHaYNB9gmIhE5w0NdnrScRTmg6JuaBNCY8koO3/nYdyCPJefpm4Mw+g2/HAUauP2h474OM9Tt/6btnzTGKxWrWbk1ROKGGsnf1Ga/k2NmN/JUS/LQwMBhXu2zwevU7AhoalwgrYe523j5cbermQoZn6IzNca0OM3+B06r5Qoo1MLCUEYNUFCTN8kqFc1daR5KfdfqGydDn8Ns39cV0ogf1NuenVh3VQZDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:


commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
[still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap2
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605131554.92e7df6b-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale

commit: 
  11e7f22f5e ("maple_tree: add cp_converged() helper")
  280b792cac ("maple_tree: use maple copy node for mas_wr_split()")

11e7f22f5e85058b 280b792cac62ddadca2935766ca 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   6885401            -6.0%    6472359        will-it-scale.48.processes
    143445            -6.0%     134840        will-it-scale.per_process_ops
   6885401            -6.0%    6472359        will-it-scale.workload
     14.44            -1.0       13.42        mpstat.cpu.all.usr%
     17.55            -4.9%      16.69        turbostat.RAMWatt
      4812 ±  4%     -11.4%       4266 ±  4%  vmstat.system.cs
     17354 ±  3%      -9.2%      15750 ±  3%  sched_debug.cpu.nr_switches.avg
     10034 ± 11%     -25.7%       7451 ± 16%  sched_debug.cpu.nr_switches.min
    674817            -2.6%     657530        proc-vmstat.nr_active_anon
   1446441            -1.2%    1429254        proc-vmstat.nr_file_pages
    505185            -3.4%     487999        proc-vmstat.nr_shmem
     50084            -3.1%      48542        proc-vmstat.nr_slab_unreclaimable
    674817            -2.6%     657530        proc-vmstat.nr_zone_active_anon
      0.37 ±  2%      -6.8%       0.35        perf-stat.i.MPKI
  76468991            -1.9%   74991763        perf-stat.i.branch-misses
     20.62 ±  2%      -2.6       18.02 ±  2%  perf-stat.i.cache-miss-rate%
  34114286 ±  2%      -7.8%   31452733        perf-stat.i.cache-misses
 1.675e+08            +6.0%  1.775e+08        perf-stat.i.cache-references
      4800 ±  4%     -11.4%       4254 ±  4%  perf-stat.i.context-switches
      1.55            +0.9%       1.57        perf-stat.i.cpi
      4185 ±  2%      +8.3%       4534        perf-stat.i.cycles-between-cache-misses
 9.151e+10            -1.0%  9.063e+10        perf-stat.i.instructions
      0.37 ±  2%      -6.9%       0.35        perf-stat.overall.MPKI
      0.39            -0.0        0.39        perf-stat.overall.branch-miss-rate%
     20.35 ±  2%      -2.6       17.70 ±  2%  perf-stat.overall.cache-miss-rate%
      1.55            +0.9%       1.57        perf-stat.overall.cpi
      4163 ±  2%      +8.4%       4514        perf-stat.overall.cycles-between-cache-misses
   4010019            +5.4%    4225135        perf-stat.overall.path-length
  76161250            -1.9%   74678157        perf-stat.ps.branch-misses
  34001097 ±  2%      -7.8%   31340807        perf-stat.ps.cache-misses
 1.671e+08            +6.0%  1.771e+08        perf-stat.ps.cache-references
      4780 ±  4%     -11.4%       4233 ±  4%  perf-stat.ps.context-switches
  9.12e+10            -1.0%  9.033e+10        perf-stat.ps.instructions
     19.40            -0.9       18.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     15.57            -0.8       14.77        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      8.86            -0.5        8.39 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     12.99            -0.5       12.52        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      8.50            -0.5        8.05 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      7.73            -0.4        7.32        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      8.46            -0.4        8.06        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.94            -0.4        3.56        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      6.70            -0.4        6.33        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      6.08            -0.4        5.71        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     55.07            -0.4       54.71        perf-profile.calltrace.cycles-pp.__mmap
      3.59            -0.3        3.25        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      3.72            -0.3        3.40        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__mmap
      3.09            -0.3        2.79        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      4.14            -0.3        3.86        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      3.54            -0.3        3.27        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__munmap
      3.22 ±  2%      -0.3        2.96 ±  2%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.57            -0.2        1.37        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.98            -0.2        4.81        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.88            -0.2        0.71        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff
      3.78            -0.1        3.66        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.82 ±  2%      -0.1        1.72 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.65            -0.1        0.56        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.53            -0.1        1.45        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__munmap
      1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.65            -0.1        0.58        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      1.46            -0.1        1.41        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__mmap
      0.97 ±  2%      -0.1        0.91        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
      1.36            -0.0        1.31        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.76            -0.0        0.72        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.69            -0.0        0.66        perf-profile.calltrace.cycles-pp.__filemap_get_folio_mpol.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
      0.56            -0.0        0.53 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.__mmap
      0.78 ±  2%      +0.0        0.83        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      0.72            +0.1        0.80        perf-profile.calltrace.cycles-pp.vma_link_file.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.24            +0.1        1.32        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_final.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.38            +0.1        1.48        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      2.39            +0.2        2.55        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
     45.68            +0.2       45.93        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     45.52            +0.3       45.78        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.82            +0.3        1.09        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.59            +0.3        1.89        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
     44.54            +0.4       44.94        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      7.12            +0.4        7.56        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      6.68            +0.5        7.16        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     42.98            +0.5       43.52        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     41.67            +0.6       42.29        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.47            +0.6        6.10        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.00            +0.6        0.64 ±  8%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
     32.58            +0.7       33.24        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.56 ±  2%      +0.7        1.27        perf-profile.calltrace.cycles-pp.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
     34.16            +0.7       34.89        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.48            +0.7        5.20        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      0.00            +0.7        0.73        perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      4.32            +0.7        5.07        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      0.00            +0.8        0.75        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff
     34.96            +0.8       35.72        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     35.97            +0.8       36.73        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     35.80            +0.8       36.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.00            +0.8        0.79        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.79            +0.8        1.58        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.8        0.80 ±  2%  perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.8        0.80        perf-profile.calltrace.cycles-pp.mas_prev_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
     35.04            +0.8       35.85        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.00            +0.8        0.81 ±  7%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      0.97            +0.8        1.80        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.73            +0.8        1.56        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.9        0.95 ±  7%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
      0.00            +1.1        1.09        perf-profile.calltrace.cycles-pp.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      5.22            +1.5        6.75        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.00            +1.5        1.55 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
     19.61            -0.8       18.76        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     15.58            -0.8       14.79        perf-profile.children.cycles-pp.unmap_region
      8.68            -0.8        7.93        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      8.88            -0.5        8.40 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap
     13.03            -0.5       12.57        perf-profile.children.cycles-pp.__mmap_new_vma
      8.56            -0.5        8.11 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_event
      1.40            -0.4        0.98        perf-profile.children.cycles-pp.memcpy_orig
      7.75            -0.4        7.34        perf-profile.children.cycles-pp.unmap_page_range
      8.08            -0.4        7.67        perf-profile.children.cycles-pp.mas_wr_node_store
      8.48            -0.4        8.07        perf-profile.children.cycles-pp.unmap_vmas
      3.96            -0.4        3.58        perf-profile.children.cycles-pp.free_pgd_range
      6.72            -0.4        6.35        perf-profile.children.cycles-pp.zap_pmd_range
      6.16            -0.4        5.80        perf-profile.children.cycles-pp.free_pgtables
      3.61            -0.3        3.26        perf-profile.children.cycles-pp.free_p4d_range
      3.10            -0.3        2.80        perf-profile.children.cycles-pp.free_pud_range
     54.52            -0.3       54.23        perf-profile.children.cycles-pp.__mmap
      3.24 ±  2%      -0.3        2.98 ±  2%  perf-profile.children.cycles-pp.mas_preallocate
      5.28            -0.2        5.06        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      2.34            -0.2        2.13        perf-profile.children.cycles-pp.mas_walk
      5.00            -0.2        4.82        perf-profile.children.cycles-pp.mas_store_prealloc
      3.46            -0.2        3.31        perf-profile.children.cycles-pp.entry_SYSCALL_64
      3.06            -0.1        2.92        perf-profile.children.cycles-pp.syscall_return_via_sysret
      1.95 ±  2%      -0.1        1.84        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.30 ±  3%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.mas_prev_setup
      1.83 ±  2%      -0.1        1.74        perf-profile.children.cycles-pp.kmem_cache_free
      1.40            -0.1        1.32        perf-profile.children.cycles-pp.__refill_objects_node
      0.70            -0.1        0.62        perf-profile.children.cycles-pp.vma_merge_new_range
      0.27 ±  2%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.57 ±  3%      -0.1        0.50 ±  3%  perf-profile.children.cycles-pp.mas_prev
      0.23 ±  2%      -0.1        0.17 ±  4%  perf-profile.children.cycles-pp.mas_prev_range
      0.38 ±  8%      -0.1        0.32 ±  3%  perf-profile.children.cycles-pp.strlen
      0.43 ±  2%      -0.1        0.37        perf-profile.children.cycles-pp.fput
      0.68 ±  2%      -0.1        0.62 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.62            -0.1        0.57 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.76 ±  2%      -0.0        0.71 ±  2%  perf-profile.children.cycles-pp.prepend_copy
      0.79            -0.0        0.74 ±  4%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      0.99 ±  2%      -0.0        0.95 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
      1.12            -0.0        1.07 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.36 ±  2%      -0.0        0.32 ±  2%  perf-profile.children.cycles-pp.security_mmap_file
      0.38 ±  2%      -0.0        0.34        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
      0.19 ±  3%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.__x64_sys_mmap
      0.63            -0.0        0.60        perf-profile.children.cycles-pp.up_write
      0.39            -0.0        0.36        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.11 ±  4%      -0.0        0.08        perf-profile.children.cycles-pp.get_align_mask
      0.24 ±  3%      -0.0        0.22 ±  4%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.40            -0.0        0.38 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.30 ±  2%      -0.0        0.28 ±  3%  perf-profile.children.cycles-pp.can_vma_merge_right
      0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.33 ±  2%      -0.0        0.31        perf-profile.children.cycles-pp.unmap_single_vma
      0.21 ±  3%      -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.mmap_action_complete
      0.34            -0.0        0.33 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.33            -0.0        0.32        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.09 ±  5%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.14 ±  3%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.get_mmap_base
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.08            +0.0        0.09        perf-profile.children.cycles-pp.mas_nomem
      0.06            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.unlink_file_vma_batch_init
      0.31            +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.13 ±  3%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.vm_area_free
      0.11            +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.build_id_parse_nofault
      0.14 ±  5%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.48            +0.0        0.50        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.20 ±  3%      +0.0        0.22 ±  3%  perf-profile.children.cycles-pp.is_vmalloc_addr
      0.46 ±  2%      +0.0        0.48        perf-profile.children.cycles-pp.filemap_get_entry
      0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.13 ±  7%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.mmap_region
      0.11 ±  4%      +0.0        0.14 ±  5%  perf-profile.children.cycles-pp.mas_next_setup
      0.27 ±  3%      +0.0        0.31 ±  4%  perf-profile.children.cycles-pp.__thp_vma_allowable_orders
      0.31 ±  3%      +0.0        0.35 ±  3%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
      0.13 ±  3%      +0.0        0.18 ±  4%  perf-profile.children.cycles-pp.rb_next
      0.08 ±  6%      +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.ksm_vma_flags
      0.47 ±  3%      +0.1        0.53 ±  3%  perf-profile.children.cycles-pp.down_write
      0.35 ±  3%      +0.1        0.42 ±  3%  perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.74            +0.1        0.82        perf-profile.children.cycles-pp.vma_link_file
      1.24            +0.1        1.33        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
      2.44            +0.1        2.58        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.66 ±  5%      +0.2        0.89        perf-profile.children.cycles-pp.mas_wr_walk_descend
      1.62            +0.3        1.90        perf-profile.children.cycles-pp.mas_rev_awalk
      1.71            +0.3        2.04        perf-profile.children.cycles-pp.mas_wr_store_type
     44.55            +0.4       44.96        perf-profile.children.cycles-pp.ksys_mmap_pgoff
      7.13            +0.4        7.56        perf-profile.children.cycles-pp.__get_unmapped_area
      6.69            +0.5        7.17        perf-profile.children.cycles-pp.shmem_get_unmapped_area
     43.01            +0.5       43.55        perf-profile.children.cycles-pp.vm_mmap_pgoff
      5.53            +0.6        6.14        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
     41.71            +0.6       42.34        perf-profile.children.cycles-pp.do_mmap
     32.60            +0.7       33.26        perf-profile.children.cycles-pp.do_vmi_align_munmap
      5.05            +0.7        5.75        perf-profile.children.cycles-pp.mas_find
     34.19            +0.7       34.90        perf-profile.children.cycles-pp.do_vmi_munmap
      4.49            +0.7        5.21        perf-profile.children.cycles-pp.vm_unmapped_area
      4.34            +0.7        5.09        perf-profile.children.cycles-pp.unmapped_area_topdown
     34.99            +0.8       35.74        perf-profile.children.cycles-pp.__vm_munmap
     35.06            +0.8       35.87        perf-profile.children.cycles-pp.__x64_sys_munmap
      0.00            +1.0        0.99        perf-profile.children.cycles-pp.mas_ascend
     81.44            +1.0       82.44        perf-profile.children.cycles-pp.do_syscall_64
     81.77            +1.0       82.79        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      5.30            +1.5        6.82        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.00            +1.6        1.58        perf-profile.children.cycles-pp.mas_next_node
      1.84            +1.6        3.48        perf-profile.children.cycles-pp.mas_next_slot
      1.75            +2.0        3.72        perf-profile.children.cycles-pp.mas_prev_slot
      0.00            +2.0        2.01        perf-profile.children.cycles-pp.mas_prev_node
      8.62            -0.8        7.87        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.32            -0.4        0.91        perf-profile.self.cycles-pp.memcpy_orig
      4.40            -0.3        4.09        perf-profile.self.cycles-pp.zap_pmd_range
      2.96            -0.3        2.68        perf-profile.self.cycles-pp.free_pud_range
      2.19            -0.2        1.99        perf-profile.self.cycles-pp.mas_walk
      3.05            -0.2        2.89        perf-profile.self.cycles-pp.syscall_return_via_sysret
      3.07            -0.1        2.94        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.38 ±  7%      -0.1        0.27 ±  3%  perf-profile.self.cycles-pp.current_time
      0.62            -0.1        0.52        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.80            -0.1        0.71 ±  5%  perf-profile.self.cycles-pp.do_syscall_64
      0.25 ±  3%      -0.1        0.17 ±  4%  perf-profile.self.cycles-pp.mas_prev_setup
      0.76 ±  5%      -0.1        0.68 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.24            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.52 ±  6%      -0.1        0.46 ±  6%  perf-profile.self.cycles-pp.kmem_cache_free
      0.80            -0.1        0.73 ±  2%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.73            -0.1        0.66        perf-profile.self.cycles-pp.__mmap_new_vma
      0.36 ±  8%      -0.1        0.30 ±  3%  perf-profile.self.cycles-pp.strlen
      0.40 ±  2%      -0.1        0.34        perf-profile.self.cycles-pp.fput
      1.03            -0.1        0.98        perf-profile.self.cycles-pp.__refill_objects_node
      0.36 ±  2%      -0.1        0.30 ±  2%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.68 ±  3%      -0.1        0.62 ±  3%  perf-profile.self.cycles-pp.unmapped_area_topdown
      0.77 ±  2%      -0.1        0.71 ±  4%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.34            -0.1        0.29        perf-profile.self.cycles-pp.__build_id_parse
      0.53            -0.0        0.48        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.64 ±  2%      -0.0        0.59        perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.28 ±  2%      -0.0        0.23        perf-profile.self.cycles-pp.mas_next_range
      0.30 ±  3%      -0.0        0.26 ±  6%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.24            -0.0        0.20 ±  3%  perf-profile.self.cycles-pp.__filemap_get_folio_mpol
      0.60            -0.0        0.56        perf-profile.self.cycles-pp.mas_preallocate
      0.64            -0.0        0.60 ±  5%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.71 ±  2%      -0.0        0.67 ±  2%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.37 ±  2%      -0.0        0.34        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
      0.18 ±  4%      -0.0        0.15 ±  4%  perf-profile.self.cycles-pp.do_vmi_munmap
      0.33 ±  3%      -0.0        0.30 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
      0.25 ±  3%      -0.0        0.22 ±  3%  perf-profile.self.cycles-pp.__get_unmapped_area
      0.10 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.get_align_mask
      0.16 ±  4%      -0.0        0.13 ±  4%  perf-profile.self.cycles-pp.security_mmap_file
      0.34 ±  2%      -0.0        0.32        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.59 ±  2%      -0.0        0.56        perf-profile.self.cycles-pp.up_write
      0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.30 ±  2%      -0.0        0.28        perf-profile.self.cycles-pp.perf_event_mmap
      0.21 ±  3%      -0.0        0.19 ±  4%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.18 ±  2%      -0.0        0.16 ±  3%  perf-profile.self.cycles-pp.mmap_action_complete
      0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.khugepaged_enter_vma
      0.30            -0.0        0.28 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
      0.15 ±  4%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
      0.06            -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.18 ±  3%      -0.0        0.16 ±  4%  perf-profile.self.cycles-pp.unmap_single_vma
      0.31            -0.0        0.29        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.11 ±  3%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.vm_unmapped_area
      0.33            -0.0        0.31 ±  2%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.14 ±  3%      -0.0        0.12 ±  5%  perf-profile.self.cycles-pp.__x64_sys_mmap
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_nomem
      0.05            +0.0        0.06 ±  6%  perf-profile.self.cycles-pp.unlink_file_vma_batch_init
      0.06            +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__pi_memcpy
      0.28            +0.0        0.30 ±  2%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.12 ±  5%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.userfaultfd_unmap_prep
      0.15 ±  6%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.freader_get_folio
      0.23 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.filemap_get_entry
      0.19 ±  2%      +0.0        0.22 ±  4%  perf-profile.self.cycles-pp.remove_vma
      0.24 ±  2%      +0.0        0.26        perf-profile.self.cycles-pp.vma_link_file
      0.07 ±  6%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp.vma_wants_writenotify
      0.12 ±  8%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.mmap_region
      0.23 ±  4%      +0.0        0.26 ±  2%  perf-profile.self.cycles-pp.vma_interval_tree_remove
      0.10 ±  4%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.mas_next_setup
      0.26 ±  2%      +0.0        0.29 ±  4%  perf-profile.self.cycles-pp.__thp_vma_allowable_orders
      0.11 ±  3%      +0.0        0.15 ±  6%  perf-profile.self.cycles-pp.rb_next
      0.27            +0.0        0.30        perf-profile.self.cycles-pp.freader_fetch
      0.29 ±  3%      +0.0        0.33 ±  4%  perf-profile.self.cycles-pp.__x86_indirect_thunk_rax
      0.45 ±  2%      +0.0        0.49 ±  4%  perf-profile.self.cycles-pp.down_write_killable
      0.33 ±  2%      +0.0        0.38 ±  3%  perf-profile.self.cycles-pp.__vma_start_write
      1.55            +0.1        1.60        perf-profile.self.cycles-pp.mas_store_gfp
      0.07 ±  7%      +0.1        0.12 ±  5%  perf-profile.self.cycles-pp.ksm_vma_flags
      0.26            +0.1        0.32        perf-profile.self.cycles-pp.shmem_mmap_prepare
      0.44 ±  4%      +0.1        0.50 ±  3%  perf-profile.self.cycles-pp.down_write
      1.00            +0.1        1.10        perf-profile.self.cycles-pp.mas_wr_store_type
      1.69            +0.1        1.79        perf-profile.self.cycles-pp.mas_next_slot
      0.65            +0.1        0.75 ±  2%  perf-profile.self.cycles-pp.mas_store_prealloc
      1.10            +0.1        1.23        perf-profile.self.cycles-pp.mas_find
      0.62 ±  5%      +0.2        0.84        perf-profile.self.cycles-pp.mas_wr_walk_descend
      1.16            +0.6        1.80        perf-profile.self.cycles-pp.mas_rev_awalk
      0.00            +0.9        0.91        perf-profile.self.cycles-pp.mas_ascend
      0.00            +1.2        1.18        perf-profile.self.cycles-pp.mas_next_node
      0.00            +1.3        1.27 ±  2%  perf-profile.self.cycles-pp.mas_prev_node




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


