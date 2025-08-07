Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537FBC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2F98E0002; Thu,  7 Aug 2025 03:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72BE8E0001; Thu,  7 Aug 2025 03:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14788E0002; Thu,  7 Aug 2025 03:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A15CE8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:17:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74464136BE9
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:17:04 +0000 (UTC)
X-FDA: 83749104768.21.15C15C4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BB18C000F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:17:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btqTUYZK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754551021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx1QSMpAW6GYqIYDLC2AbU+BvmCz9S8ZQ3NU2H5o8oM=;
	b=At4bYjj8nyFhDxYfqRUnlSN9V5Uj7dRKq4eLoGvC70k5KkYLjyac4cowawqpP0TpRWTe8/
	dOwI2RGP1YM1/eOI0nm7rHSFpVDTZAzZRtwT0rVmSkNFYpbDt3pxT/2c0KfRZK3nGHif55
	veo1QGbGbzE8jtlyws0UQfMHhQCpHtA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754551021; a=rsa-sha256;
	cv=fail;
	b=4zO+fdszlbVI5MmA9myCFZdoWLhqcW1l8LM7cY6W6oH2ah2/P+gghIYxDVFeCsybF2h7+D
	s2UN9nC7Yx913/3tYei6zHnwtJz9muZgvJgugEJEUBohuyPWoHU17ABk+mGkifNDuh7SQF
	OUkiWf3hmMGl/cIkoBa0GY3EQP3RhRs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btqTUYZK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754551020; x=1786087020;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BVQRGNRAOZ6AHnOLT7hxncWjA0ouDpnhW7Kjyh9N3PU=;
  b=btqTUYZKOZa8NBcGLE3gQ7Vbc4uReSl0EiFZ4bBZVWvcmpdZQ3vQ7oU2
   U0FRAZ6vPw03tpGuJYMrlj62la58l3YW/O/2kW7E2AmaEvN+9yyk8ZNkJ
   tD1mDDmciAbbZh9BskLxDo/6RJDXyYd7aLu9IMDjVHp8WffQeWnyL6j2W
   lhruTzOLoWXqW7SR27qBfphrUz36kCNYw7/DOGUZ+kjB6MA3APLQMTser
   4d5mcHAYKvM1bqhpeG7iLQMJw3FziGYBI8WuMb53JlfsbrngGuPls0l91
   yKmpzK6r++aznapFcpEoo4Ukhp+Qt3N1bul2b3S2e8GYCMKo+J6OFiw9X
   A==;
X-CSE-ConnectionGUID: N4iYNIDRQMmm9qwn2pdnFA==
X-CSE-MsgGUID: Z7ScNqrITBmPI4MjOrwyxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68253591"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68253591"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 00:16:59 -0700
X-CSE-ConnectionGUID: eter9VwKTSmyarFgMmk6RQ==
X-CSE-MsgGUID: loqDQUKtTQmhndusYoSg3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202158632"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 00:16:59 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 00:16:58 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 7 Aug 2025 00:16:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.60) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 7 Aug 2025 00:16:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rtCHI1tEVOATDfrLVzw5jwuRKZLbkkB4TfyqCw1uZwUXziH+/9pJtg7J3fBNvG4JNLkoGdsYJsBLVPexgql4W5GQiy8S6qZ6NL34Ja/LNNS7IY12lGg35nrONc+RuzGkid9L5fUUegw5XAn0DAUPTvSicPqBJV/IZ14SRis11LJcqiNU13hrkwtxuX4PcxjrjNtOK49ByOTdzZnZ46DfPmcHO8roVmD5JnSduD3jA9yQqSD7APkknTsVHaGjkFpTrQ5Ztt3Oym19mQ1I61jzj2s1ynooTmPYT9IdRPoXIPWI6QXUpOXs24ByDaDVRyDMeW2jLBHYAJbDl1qHsqStNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hx1QSMpAW6GYqIYDLC2AbU+BvmCz9S8ZQ3NU2H5o8oM=;
 b=PBmqVEtf39ooS5biKRqW/NWuZcg2ruZ8wl15Vv+2XWw9P5TLXvaWn/1kg9yC7ysdmXC6ZznvurGe0TBkTDvc5iPMqZgleJmrbOPLec7YKnRNR57Tm778If0ClrWe83ijdIB7CEytXeQs35OoOfd/SMtNbSIVUs2zaEj3uWVMjQXK0AlPptL+UsgkfE21oqM9Mdfc46Zy0x+1n0QBOqkyaSmx+q8GFG9lbexbpBPV85krIFQWKdzlUgleo9b67spHtIwgJNsE3uVtY39xXzlx2+JdqXAfos7I264kHfgxkOkQV0GDL4hwO/Dfq+v0DjkURo0fIuBtrAC1BTq1bgTUjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10)
 by CH2PR11MB8814.namprd11.prod.outlook.com (2603:10b6:610:281::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Thu, 7 Aug
 2025 07:16:55 +0000
Received: from PH0PR11MB5674.namprd11.prod.outlook.com
 ([fe80::77d3:dfb2:3bd:e02a]) by PH0PR11MB5674.namprd11.prod.outlook.com
 ([fe80::77d3:dfb2:3bd:e02a%3]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 07:16:54 +0000
Date: Thu, 7 Aug 2025 15:16:46 +0800
From: Philip Li <philip.li@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, kernel test robot
	<lkp@intel.com>, Suren Baghdasaryan <surenb@google.com>,
	<oe-kbuild-all@lists.linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>, Vlastimil Babka
	<vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references
 non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Message-ID: <aJRS3iAcvITYGKxq@rli9-mobl>
References: <20250807054349.21561-1-sj@kernel.org>
 <20250807055138.21727-1-sj@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250807055138.21727-1-sj@kernel.org>
X-ClientProxiedBy: SG2PR04CA0163.apcprd04.prod.outlook.com (2603:1096:4::25)
 To PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5674:EE_|CH2PR11MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd7a184-13b6-4801-2f47-08ddd5826326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YhPpMjcf4F4WUHjrwZDPmt5CMFSYXAPjZIf58qoY1zHmlUH//bi5jCJm2xy5?=
 =?us-ascii?Q?RdqfuHfyJ2mYfMeswBYFN2+LzrD+yJp6Rhp9Jm6+uuT3U8TWvp8/XLGWP2vN?=
 =?us-ascii?Q?enDB4oTNwmX/ONofblZrRn6ZOwIWppVh4BQFE2Y6ZP/3cThqpREbwy2rPgGZ?=
 =?us-ascii?Q?qpyezkQZYzV0NEG2UekPUSN5zhbJKN177XSdolxCbnWhqatkuP1hRd9QuYIM?=
 =?us-ascii?Q?pNfC997S7CSWC13ZPD/AdJHQ0DbrhDhcrR9d9W8uMITu/xKsHTK5n/Yq2kll?=
 =?us-ascii?Q?A50EPmLpIRe3ZnDNqANKEs/SmbDssalQhDc+vx5q/nKPCHQGDBzAjJhdfHcG?=
 =?us-ascii?Q?i+nFpxKM2xW70NonFYfj2FGFVQBAgV6CcXiEkRew6WcHOMJKch2t9CSfWmu7?=
 =?us-ascii?Q?1kDs+2XBfP/+gVUmKDGDHIvMmtKTg4Z+E5HWCKCK9IXDoI5CvVhLVacqE/Vi?=
 =?us-ascii?Q?YOZH80s0Tv7TF62zk40G5XGRsgZf0izFf3fCuro+NrKv5jx7hY3d8eaAqYdg?=
 =?us-ascii?Q?3TkQQJTME+vQm+CxN9gXHTNophlZN+f0Qyc4OIsvyXHhxJYvXyV7q6z4zwtR?=
 =?us-ascii?Q?34ESMJzRmB+g9aBR5RC2kUM4OD2SB8ibtXPdEvhgpm6IDyY2SBsDi2cjVYe5?=
 =?us-ascii?Q?AnHo1HokbkAr6DitXWXUew2OwdCn3vJ9z0D9JOIYZ+/WbkwHSmX5k6U+0/88?=
 =?us-ascii?Q?7seiiQA7JHQ4qlh42uzqR4uh4R+CCBXmEs9qJGOB2LPFVc/jRmKyCBainEoT?=
 =?us-ascii?Q?wAgLUHh95dcsy1Ep4WgoLxDG6bti9tVLOUeKK8gZtIZCaUhS0w4u6QArrCVy?=
 =?us-ascii?Q?b7X5cb35qi47KhUvCFUroWwpgCEDx2iTx5Suvmcm7wtAgu+6hLYoilpSRNqn?=
 =?us-ascii?Q?W20On/cAALFdcdTM9/VlVSy33dReMk2Ns78ABYAauJIGUol82sqqzgCZv3wR?=
 =?us-ascii?Q?AldekNmEY4kEBamADayT5WPu4/5NHu7/xvhpI7d4Ct98dph68+5PoN+Lc6Oj?=
 =?us-ascii?Q?RwQoFm0m/FquK2O/cOxvGhIBl6JlBcxqQOP7RLC/m0DpIK8aw2A31Cux9IMm?=
 =?us-ascii?Q?LbYbrHk87s642Aui+vWslcRMPv4Kq05t/iSrc7AgwyqPW8UGe5xVGJTiTnst?=
 =?us-ascii?Q?ProS03K72A5ujrmY2BM3m48xeZJpRVvH5q7v3RVjrwT/DkZ/GnyIR0NMBf0Q?=
 =?us-ascii?Q?3dWjkaENqOx3IznK1LdsbrV3NpqFryIEvgbalTBRYKjwo1+eZ1R44sKv7e1P?=
 =?us-ascii?Q?gSN8yEBcCcrl5XyYvlB4ZMZwmS6rxLF6ObiaVMetOtDjNgIp8DXez7fKniL2?=
 =?us-ascii?Q?CIt1QHsAtYiZc1FtuJ3SXtVbPSjqriA6MMDo1flm4XKuZKR7cpr/n8TMWN9M?=
 =?us-ascii?Q?Pgw0J9ANwJqeal4rLDIW9LAd+C1aXnmWMEx8R7M6ZFaxgCd5fTWQoxWQhxwS?=
 =?us-ascii?Q?W9b183xY54Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5674.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xrt14bFmNqbnU9ODCfQS/J4E+4LcZDc0hKnrfcjUQ4phuSIa2bJVp1FtiLjM?=
 =?us-ascii?Q?KoGkcMJ+GTdGAU9qCtS4gzqWmCqBa90AnglvxzRY7FLQRWO4j5ZfmzVevsYT?=
 =?us-ascii?Q?VMP/rZ1lvAG2/IdrrzynRifjMEgor9u6G65waZYxj4vfGg8CsnR1023eSMm3?=
 =?us-ascii?Q?aDc8yllu07t2LYYGyQ3dssTcFxjVUAUq1iYxbZguoGhd7NYMO2LlWFCxdLUa?=
 =?us-ascii?Q?GJCozqgAaNxmv9aqjIyUc6BSXn9MhHjbvPYJS5NMvItMxS+rhtTbf9B3RqL5?=
 =?us-ascii?Q?QVwR0zBMhnB0mysrpDUH9DRJIXaTW3BfqxHNaIZh8pwawjRtT9H5anaiQHi2?=
 =?us-ascii?Q?PCyHDZYiuJx2/Vhbb6Vt74tpuynBQyC4q8cXKnPs/dhE7/Cq8vzAgaJUJ8Np?=
 =?us-ascii?Q?eYnE3W3k3RUuxFt2BijQX4h5Plq7WIWt1r3FkkWkS6CxJ4G0gsq7a8MyG7wa?=
 =?us-ascii?Q?dMVxCOAdoLLeSsskrx+SeGt3o2/NuOk7w0lVVVRML93hhKnx7XeaQIM0xlxF?=
 =?us-ascii?Q?Dd9gRvPoZK7msiKg2Lg9+28enhRYrPdJvV/z/CRpNsFDeZ6EZ2MKsa3B1IdC?=
 =?us-ascii?Q?Zyl7xcG+SLYEBIlzKpuIB2wBxIRvS7+ee36udQ5yQi+EPgjwc8PGRPhp+J22?=
 =?us-ascii?Q?g+uQZq+e0xzho5yyU15fchYBlzhwSr3ddDnmSJLcnOmC8N/A63+4+J4LA115?=
 =?us-ascii?Q?vGcLty5YGLowr59fYqtijjinu5sEKT8zaLhVfmtRGO+1+PkD8vdAckrzIQRl?=
 =?us-ascii?Q?EUc1BPrgr3li1jH5kDV01txMVGRxS/Ovm0Ql1S0G5usLyQvVOvRoSOp4nltM?=
 =?us-ascii?Q?6ioJLcqNdrRPP0UeHo4pPVUCD0crroEosf9F2XMz1FX2sVox+VIuk53Mza6i?=
 =?us-ascii?Q?xVAvLW8trCWSXT/bT6W45F1z1NjbuaN1hGzXgw26PRCV7dd8zyeoYX0yht48?=
 =?us-ascii?Q?Od7hs4qwLURjbDm9YomtOoJY+D/xsOjBOAUc27Y3/mjPS4Qws0PL//QQltFI?=
 =?us-ascii?Q?/8/cxmtziSvg+tKASDLRF6C07euWXYpb2IT724ySOORfq5cvYoE3PYuXiB1S?=
 =?us-ascii?Q?YSHXfli+EHWktWH7TfqDrND4UJzR/V1VHjI1NE9xKUdkOwH/ME2B1Z7a3nkX?=
 =?us-ascii?Q?PwEQRu0W8q7vuh9I+cxrx/llCnxzEgTuLBTUDe75hR4OkkbeUkhP3/8cvAnj?=
 =?us-ascii?Q?vrWTRUoB71EmH1RFeK9/rYe8oQWt/xtBar6z5RVw1BdHw8xzC0fMvkRfAw4H?=
 =?us-ascii?Q?7oNtWYPFa6FlA+Yx7Nv58JNKkq32Hln+dt+kR/mn/2RKa94ZnVknzWFit9H6?=
 =?us-ascii?Q?rDIxhRkwIwvQQ4MNS/luVKjd1F7qJ5v2qyGxdX046CdLCwloeRiIvI0Fw2pH?=
 =?us-ascii?Q?/mn9g8ZYBKSVZ/T/EobPnGVw3JMD4/tWndUitWvgHAviNNy7RCzzzWev2Tr7?=
 =?us-ascii?Q?6YyZ0o/UJvh7amc3nJprWeGbrAcwvP2GKClNeKCBx7ZAR9Po3BHSK0Fr1/Tc?=
 =?us-ascii?Q?lnQkKvF4QU0ecMWgjFq7C9tuhUVv9y1zmm3p7vz1cUqShS/9835RFN0Gft7v?=
 =?us-ascii?Q?vKFjh9jJ8Og4W4NZ9Rshk+m9uOmGeVPMTAYC4s++?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd7a184-13b6-4801-2f47-08ddd5826326
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5674.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 07:16:54.5567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FbLLrC7G3yGPxI3YngGhUytgo1vj0kcvlSbWBy9jvPVxFZ6BhGSniQ5/PcwY3LZJbubteANTM1Y3VSsptPhePQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8814
X-OriginatorOrg: intel.com
X-Stat-Signature: xcx6u47e4ssyqhcezjj3npyonbk9ahy4
X-Rspamd-Queue-Id: 9BB18C000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754551020-519719
X-HE-Meta: U2FsdGVkX19xkDCv5tQYOgBPsBJuX/71z0Ja5WWWIGGRnBJr6m7a7C8phmj/0w+zb+C+YQsojSDI7iLLFhUF7JCNphEjcSwRIpLEAUyDDtykH4ScmDHBbnmQIewGN2eBhyWi/g+Ez5pPmeBPgtAq9OR8Yde7OjA1pAgovtq71wgfNNmW7/cdHef3pwHJxPn+n4Nma+9QVkVde7mrPdOUiJUXWTbsXhPPyERTnWO8IE+KYcWkD//aowB64/AFA4+pUZVVC0L+Kq5rkS0j6dvGvKEgjV+S/pKEAReEPvXijmILWD/mp9x5n3gDaTO4lTzkj6X1C5lCF+Rl2dTFy80JlpML8aBTGZXLDOzZJLN40wjCDyS7KPeK0ArgeJ8gE/1nJ71vt73eh0z9alzvJpDMipopVBmp/uPq6TNNfasYJhIWi8mwRtlgjSMungDBmJZ5o9YGxErGpGhHk08W+OKEv/+QTfpBdyeCb8b4K2H/8lCThNfSZqe7+MxbUcQix+c4eGVoZOJn6C6+e7uHOHOVVk6lWJjFBqv8A0F8gLPEM11V/72ay7zSFswodfl15hEsAmibFYX8Q4FBP9KtJ6QRVm+TZMqI9dY7zKkzrBo8RAyq2LEM3mLyLlNwdkTilv+CgsvgCkuLAfMuH1LTk8yiwZqThUM6zajnLhxgcu3dgz+M+GLxCbJs7tuOfKEObeoPCq7hyXyAQGKNvuXN+IJ8aofWtqBW/bIxHxzyCvEqnjHHKlCPCKLyaBacrLyMbemTmiH/J8Sq2izeEZ+cqWfcc/nXXfkcEP1TUNseGSVSiUlXJJV/+gs0qc9yu7jWIAXrUZrWoDyXH3ntHwlqYHzxK64nZwCo1tI/qhnUPFt84nSYvPPZ5ZOv1jpp+3yHDpnd913KiuS1UZjcWAFajE3d/Tz7XVciwMNJcwG/f34ICzi8iSNz/z8j2fmP0vfWAZTYaKfLLCZdCI8WwNGwvIz
 wEyX2ml0
 jxmDCSbSLkWv2HG8ZSuSSLKi1Y2MkG0wWZl/6yWp+QhI05hFm1svgHsYf3u3kkPdc+SX/RhCw7xQBnsgYzcafb84wX2u1rHExGzBGelpqRTMcSx0F4rNWvADymelJ8iv8DQKfEf3h6H6KKqcX4Bf6ykxsF2D7xhGmv8YvTteTNZSFSmknzyg3rA5zk6HOgSmrFFuMa5MyGHDH5L6sO6xaCE8/NEvQe2DU6PAWI9ZqLuEZdOh5cyc0Z9JMeuHd6WE0Q7jWFpdXwZvS5VmJzxlRR+lyRbWaAYLgUQDZ+YCzYebHI/jOxCz/5lsl9/EeWULh4X9q/WzdibAEkdsd/1ulL7eNBDXucNVt23vszzd2+MN7ephl5gKmLRnSudX85AUHvYnn2usJvDKM/Egf17mcPKdxjqb6CF2cr03aC4GE4Grmd5h/xbJQPjwjLd2azJz0S6Su9q87VZ3Rnesi3i7+02rPOa1N8A35m20pGaEI9ITErbyE1ivvk7eJMhC5Ya2Hty3nVMwoYa7EMeNeiNuMX1rJjxclyKq7vFrnpPQXYkfvwvfaJ4OICuu7JSCanImBt9jsAyd+asvKKV1sdJ+kTEKtA3O3tDeLkffXhkmEY9ia++MR5lPRYhc98sixpB6bmJg6IRA3+mMWAZGHBpPL6wtbgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:51:38PM -0700, SeongJae Park wrote:
> On Wed,  6 Aug 2025 22:43:49 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Thu, 7 Aug 2025 06:31:25 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > 
> > > +cc SJ, as his tree :)
> > 
> > Thank you, Lorenzo!
> > 
> > > 
> > > On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
> > > 
> > > Not sure why SJ isn't cc'd when it's his tree?
> > > 
> > > Not sure how easy it would be for the scripts to figure this out.
> > 
> > As people might already realized, it is Andrew's mm-new branch.  I started
> > pushing Andrew's mm-{new,unstable,stable} branches to my tree for backup
> > purpose, since DAMON development branch (damon/next) is using mm-new as its
> > baseline.  Seems it caused confusion to kernel test robot and other people.
> > Sorry about that.
> > 
> > kernel test robot, is there a way to mark mm-{new,unstable,stable} branches on
> > my tree be ignored from your tests?  If there is no good way, I can remove the
> > branches from my tree.
> 
> To stop more confusion first rather than waiting for the answer, I just deleted
> the mm-{new,unstable,stable} branches from my tree.  I don't really depend on
> those branches on my tree since I can keep fetching Andrew's tree or using my
> trees outside of kernel.org.  So this is no problem for me.
> 
> kernel test robot, please let me know if there is a way to mark specific
> branches on my tree be ignored from your tests, though, if you get a time and
> have an idea.

Yes, the test bot supports this to ignore branches by pattern, for example,

	branch_denylist: .*-wip|.*-v[0-9]*|.*-[0-9]*
	branch_denylist: mirror/.*

Do you want to just ignore mm-{new,unstable,stable} branches, I can configure the
repo to handle this?

Thanks

> 
> 
> Thanks,
> SJ
> 
> [...]
> 

