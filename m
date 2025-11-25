Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606E5CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 03:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF276B002C; Mon, 24 Nov 2025 22:15:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F386B002D; Mon, 24 Nov 2025 22:15:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FFB86B002E; Mon, 24 Nov 2025 22:15:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84E596B002C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:15:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B874160671
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:15:19 +0000 (UTC)
X-FDA: 84147663558.04.555312C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id A4151C000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:15:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QbFW0M9D;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764040515;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVANLCqSu+K5Y54Iozq7z7mYoFCOUZUA65p4CDuyR1k=;
	b=AbhUKWmzeUqfTvH7vgfoE6Nxi5iBFbrm2gorTemxfPCqwtmjG5X1L4fpQr4neny36PaySz
	lA1frg99X/lEFvdDJ1NZr8LthicUvE6DIHsgoFsPrpzLgizwebS2pLBdhY1FmXcaIPH5RA
	6Z2ldzcoIPyQHK2qZSOzQooKEeePs1c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764040516; a=rsa-sha256;
	cv=fail;
	b=gpK5WJ0lHASML0rwzvtl6ON3bY9ByAu41rKMLCtLGeyvvFgyLIif0ZCUoK/Sz9pLm9D0jg
	iK0jaAY7ObD0HrOUGlj9b7QpNofBJBRnM2/jIkD1w0kp/ClslTeJtmgZ2DdRdBhqYwHBs6
	ZIsLq+E9Uz2Kd0jAZ5U+j9Q2QabUoLA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QbFW0M9D;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764040516; x=1795576516;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=BdMJHJj9ia6OK5UnruuFReqsYgFte2tehwwvIy5kkWc=;
  b=QbFW0M9DGR+WT0MHhhKR+6s+bYxqgqKCd4FLayydYn+1xvqrrsfalXc6
   6KGNf3dxMzukgQSqgAWSjoRgvG0hhoORofmJWkI4iwO9TZfd1K1AaNKYd
   kiX6Qy6Mlxu97o5RqhHOS8gSJ5WUE/dLa9nAxyMcztFqv5ZfAXuT9UZ5V
   hS6OUZ9xYntsuPl7xnOsrzZaJsQ3oGuYfpkMzcvH+Dn7i/kIcMmTZtWzk
   hqC6gHOi/SoW05yKbPwWD5vSZF/5ppfWU/LqiMDQtBbt8fBJJP0/uQDXc
   kgtxyzbDvtgQbdwjrSljBS7zDDBBD95tDg8ZK5lQ8OXOiU8vyLPCo/afE
   Q==;
X-CSE-ConnectionGUID: BU/kgUcCT9WX/YtzGDxf4Q==
X-CSE-MsgGUID: VWJrhH0jRC2X8XmbU1pWRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77163688"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77163688"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:14 -0800
X-CSE-ConnectionGUID: 5SBAri3uTGOC0eUoSCiw6A==
X-CSE-MsgGUID: Z7h95KEHTwiiuAip5Juwrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="223487966"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 19:15:13 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:15:13 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 19:15:13 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 19:15:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2tVT6vj0YgNdBIg1HAHcjqO/h0O9cj65bPL6ABgQJWrDszr83GlrlzoOSs+ixfAISZOdvuMAdU8tErC8M/dazJAf1eNjSSyGV6yDROQWztkRW5OCxqdORBB1EhK0hu+Y/X3JnAg0E4nzbMB+37DQSogefAWuqeiZpP7oFy4207wazeFJDw/DWnBEoPj4XaeP5N8EKluCpAdzl8S+BpQxZg/wVJky1xJcTYrHq82+PUClltQTOnNauO/rM2k25VQtiMdqHxKu7/Bizi3y2+2w+3R9CyTY+H1gkqa+Kx6H1rXdx+xtD8a3HogfJnBY34IOOmt4rsbKfY6ZPJ6j5MeWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVANLCqSu+K5Y54Iozq7z7mYoFCOUZUA65p4CDuyR1k=;
 b=y5UznoqChbeqctOKyKKiRZY3sXsxNazT+cHX5ZMdb1HCAkF2be7k9haxcQZC2uA3ZZPbAxdD5RNdlAikqte77euS75yvcCAb6u11DUAfQF1l1Q6cZ6N/JXtN51z8gPTk9nIAJkZSfk2e5wW2SfAa64MGUB+IHghQFVCkkpsKxjPm1mj2we3sw0KR4FvvTMQ8YG/T/9eAcMXhgjx5wiAAy+KvThyVy3ZIjCIup0aMOmIAKESO8XfCnRsjRDOqf/VJub9GkSYzOfJfUGFTZv8Qo3vrSomcC1q29z5eZCAZZJnuVGmS4VkU5wVe6L2DvEfTeWVbaZLYtUkXxNFYzxJejg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 03:15:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 03:15:04 +0000
Date: Tue, 25 Nov 2025 11:13:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121124314.36zlpzhwm5zglih2@amd.com>
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6e3544-69a5-4e5d-0093-08de2bd0d403
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1R438SEfhpsWo6JWx7Bp9TVJeOlGqVekY+wdJjjJxjOoOpYmCM3c3UMpO0we?=
 =?us-ascii?Q?zhDR7ic8zdJZLKAcfkXOOweykksIVgqdbd1xR8wmmBU5DWu5CcIOTNnpxdpT?=
 =?us-ascii?Q?gDmojFJ824gsqiaVBGYUVdtRO1std9YO9S14jHla5V/5+vMiB/xFoZRoOez1?=
 =?us-ascii?Q?VV29koT7qoZvuV0dTG+yaCLPQ+Xwfh+AkIIFsn8F37P+kDT5rfeEd5cHHW9g?=
 =?us-ascii?Q?HcYZdhoeReDwM9TB8QXykiMPq3bpGMNoAj79XG4q/bEP4DvTMDxeGkMdmb4/?=
 =?us-ascii?Q?SUVO1TrgWSxHJDvPHKH2iCDCZyC58LecuWiYimCFdA4wzbT0I26/m2hpi+d6?=
 =?us-ascii?Q?umlE6RYqd7yvlFAH7KwD8WSat1NPw4NDXM2h7GBs2Je+52n5Ou+r3PBWbP9h?=
 =?us-ascii?Q?VZZESo8hc3MyyDUR0CG2dXoasVqU4px5eLvS05VV89NduJ8eoIOXZLaRZF7h?=
 =?us-ascii?Q?VyyxTAKqaNTyfAKB20nj+6TclwJURAPws2hcLPza8TIkn5Vj1+vxmMouASoF?=
 =?us-ascii?Q?e1yV1IeROt7HdXudyEeROf37wETwoJy6Y6hXgwzTKiioWFtmF2pjyGub67Gd?=
 =?us-ascii?Q?9TVhZ6glckwnUm520TrgVuaOu+Yzy8GekTLYC3mowmbsDdtT9oleLYihUX2N?=
 =?us-ascii?Q?6xe9SFDyshZj2S8evTp8edfsnDfvZhQzQz+b/0WH2/fbIpwJb/eBNFS2Mlpl?=
 =?us-ascii?Q?sdmYfg237eR0moLe98Z2XTuKZqLbdGZGUoEGxBmyTQQmnQqX82g/xvZFIa8A?=
 =?us-ascii?Q?2fMXtIOt1Wh4G0UQ3wpRbgpPR6HzkXrC2HsAVZSOr8at/SKdjsaOfVmuEiA4?=
 =?us-ascii?Q?r55TiBAiuBXa8Ai9OBHUk5Qc3wMbb4y1RwvW31xprD0KUO9tFkQc61JntmGr?=
 =?us-ascii?Q?cxl4xblnpSJc21dyTwkPnHG1edX6ENspprNUykDTLbVxKWDhz0uBXRI5ai6A?=
 =?us-ascii?Q?I2ivncyGlJYvCwWpdZ/42eyzi+XnCQoXl19X+1r6DH8Ivp/VJy5+5geZ2c9S?=
 =?us-ascii?Q?UjnYKf+zhVuA2VwCtPdwTT5lC9VskD1PLvFHwJgs4txWKAgprTWTBvJCyN5P?=
 =?us-ascii?Q?DebczMUwh9O3350ghVRrYi1ibTLfajR8xWQwp4BI0AgQ4Dqi8647q0o5mpR7?=
 =?us-ascii?Q?dtN17fWdT67wtxr3k5AUQr4XXADFoayxMv/oqM26gqcK2lhbz+BWqUKDBGoG?=
 =?us-ascii?Q?ryiECNm42717+pD7m8NEEUkTz/zwfLGkCzGQdAU6ACtOjG4jMxIa//IiAMT0?=
 =?us-ascii?Q?rbnGsOO7FV7Q12aS9LlfDL/BbaGcU+dU9PDmnr/lfr3AuOWfWrcD1wUCB10S?=
 =?us-ascii?Q?N/os2Nwp6ykowj2lHTD3oQX2vC6MYmSl/TgsaHjMx6f1x5UDui3hMFNRZ/jS?=
 =?us-ascii?Q?aqFKJnApWSncFJ0tCy5jwFCXpbvEqo28SmyGLivM34qYYrUwpVVjoz46HarK?=
 =?us-ascii?Q?M//PfYLRLvUxPhfzaxvVv5BTFL+ItRF+eHZK0WRmNd3ISjV6+7LpHA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IL8ePmITr98BzmUIqaHoN35i81lq50gxiFD4Y2iP7voM5bS193XXv0T2+To2?=
 =?us-ascii?Q?i1PvsgT4v/eahvmt0GlPLn/wYuEHVGOAxKyicYY/h7Fpz1MHprhNhGJ8BMK3?=
 =?us-ascii?Q?z/+vKSTEmyvuKnexlus7Y2YIcXPskDVBgAXM2jeQHvZE30U2D6ZAqqY37YWe?=
 =?us-ascii?Q?K2IG9Yc7V5kZAQgBQPbPecPVuinP5tH+9FlAWBBz6Ytn/z+cvIQ1N4LiSS0C?=
 =?us-ascii?Q?C+kQJoPIyivCOBXTSKlAGhndigBXeuxdnOBr5vCDkboUhYVgp20dC/NTT/h+?=
 =?us-ascii?Q?gDfsv9xHN3hBqjZHaQxPc6HmP+VsuEj4NTfrukdhenh4TvgbXGn5uFcJJ7uC?=
 =?us-ascii?Q?E55JuvZkMsbVxTPWw/nrLwJbOE2dRn+ecgsQzhqtIi31tA3vNoP2gGn7mh1k?=
 =?us-ascii?Q?qJ3FUmZuRg20pKLQ8Wh6h/v1CSJt2/thAqzUujS9H0h9F8sEjrk+Npj5pVcQ?=
 =?us-ascii?Q?j30iKPy77sRlpZEmNa8v1yUDP+/XoOSMm0xZYOGop1grrcpN5tWdL5EbDGST?=
 =?us-ascii?Q?jcftgfHJxmZzWwbcDJk52EdNT3Amd77bVZX8KXjwfVLF37VorrCdxagnLr8d?=
 =?us-ascii?Q?4HSjGM8M+71+kKwVgmiFmKJzoEdKNUy3O2/qMR8XwopAVHhq9UZRzxaHgjpy?=
 =?us-ascii?Q?7qdZS7Y3B1BNcr9WHofdGyUZ0ZSo8KdoPxidaqfrMNEWiF1LdddxpFvvKcXe?=
 =?us-ascii?Q?18ik7QvLrzcZXB7DoTRkuFOZ510auzuY0xJCa8PxodemGO/x+sz48jue25c9?=
 =?us-ascii?Q?EsFcoJ9mcf/DFH+5u0R2uho0It89Dda0kzD8KUQjMbudru0dEZOZaMikZWC6?=
 =?us-ascii?Q?3+8QwR2qe9H0/cwQvULYU09SMKqK/PS5gCj/bfo7DDRSMrMqHggyMVOqB9Ub?=
 =?us-ascii?Q?Dc1hXWfANPaJqbs1K5AQ8GIjT8rUJ30sL0eoflVyf0XxAZRNuCc+Vv/M/EB8?=
 =?us-ascii?Q?OhyeKizKHe0QRjm7iqhidE6bBcsyDb7odw0xmetpRisjm5yHywRJmIkEXRPh?=
 =?us-ascii?Q?+pZ7XM//p04DDcZsDM2sxnp3uBMJFelW3k8uXU1y6Cg/zqiQ+DMTojjlXYcZ?=
 =?us-ascii?Q?AmNcYf2FYvH5lWxs72Yw8iQNZdVCecKtoi4jNbw172mI43DYtlamEVtrIBqu?=
 =?us-ascii?Q?+Kbi1ukVsqO24QfeLjHDcgvz0NEcKAThMioaxdjE2JWLZGdCRqRIShSMYGjU?=
 =?us-ascii?Q?Hwt7A+6DEChW2duCq8GXIWMjcKocYRm4fUvTRfBHufeImkc4OCEnDCJPPbtL?=
 =?us-ascii?Q?yaOLKy+OYrrccpRDzup8QddEuntD0dEWApVH1076wDCmIbJEBCXxW6vX4f0c?=
 =?us-ascii?Q?Vujz7IKY3lRpsqmWvAfzIl0fZCP3et1MjH92Qia+G2ZPRq9U8Fxmgph8GUxL?=
 =?us-ascii?Q?/UrwzflcEm7fUzXZ4g2E5mGdNX0BFBUQ7F3sGKa1E2PVF+DMzsR3x+iL3LIK?=
 =?us-ascii?Q?mtS8yEMI7kcURILVTZXK4h6FOGk5WGDC89WRPts3EnzUvRljDWUzsorGah38?=
 =?us-ascii?Q?KqzBuCrh9qGeNoP+gAc7zzE/Egccg1S6BqjmJ5SoAwpPpinHKfvSrf702hbW?=
 =?us-ascii?Q?6VkCjIHzNjPfQmqZPaYwntum0qmiAmetAd+VPeoN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6e3544-69a5-4e5d-0093-08de2bd0d403
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 03:15:04.4733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMIq3dsVdgIfPnfgYTV3yTHLn31ApDQoiglpVG1tRCnQpmOPz8GHBQcKalIdnYbyNNZPouyzZOgJS8xRFymsTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A4151C000B
X-Stat-Signature: 7mrxftcd171nx5dd1xf18ah191j9rzgd
X-Rspam-User: 
X-HE-Tag: 1764040515-284280
X-HE-Meta: U2FsdGVkX1+JXQvPXd9OjXm4cAqLS+ZXcnBT5TXy05njAINGeyK14eRLQkoiN95VsX2z8YmayS/zgjX1qX8He9nZCaIizpDdFe18hef9hlSY8BjE9petgESESCw7ovSMEPy4t65pJkhisYlgXC6MpW2zO8s4kG6KFfa/jVBjGiht+fAK/7U36qOrgPafB+TT7zPdONYt4HUiw2ekPWNX5wO3Rf2MufbHjdj3PUxdAUqGuC6aUbSMBSVXB60NaHBG/PYKksVXfTjUuWDBI6BhpM/+KNZcaFPNAMlchKC7drB2zx0mBDn/aNjIdRrm97qEjXI3fEvTzvlH1lJqhSRIf+KtNTIlTJcfcSB4JQgMwZEaMwGLhCNWhbulik99g1XHWkSV/NdL0QxIiRy9/qfUp0j5l1Kerql3m2uM5zqUmbRiSz2PvwNh2FebOCeh8W74mD9ZVTEAFwg2Gp5naltCvM2c7ku0ZoH3wtwqCLuhetitv7t1t0NFrSLd9zSwfZqzy1/7DnxHyo4q9/U1EysdXK84un5QXhs16Mli8DqZHWRACqzicEJ1m9d3uJdv66fkWPqEg/kmYgH/QsI3qnGcVj/e41F+A+Fd5EsxEynRfG9R0CVKaD2/KJlXqZU9WnBDtCclyzc4p3dlBDnT2prCxKt75DF74uqC/Bf9MEfzXnZ/RoSw48XNTx9vXKfprcDm/9mYikbA+X6x+hDjp5l7ZYROnt+TtGYos1uQOGvwbq5Wb2jZkSmiS5putRJHN4QxPlq/77ZVinxXMk+fZP0RSCmAk3krPwbYSGfQDQbSac2h+FIiwRZlT/uz1yF4REUcCq1WO0u4Mt4c4Ekzef3Up+zqtMV0wv3Q99yiCI10k6kcRPGPXwVoUq3V4rca2qp9njYjpMRQaJQzmbZ1BdSD+UoslZ+9/44cRCB/rigE9kbbGgrF2XGj2Rwn3Vt+N5Su2Bo+urDCggMGHgzCV1P
 fB/8wBrw
 +E33NEgte77qPATr6RhdBA4MYSz0DtQqRdmQ1UKzV7avPAqbz300YIqyUDmxJqOBGmLcxnhpRRtYifCoyuS7sdkYq9E+plVMzYqOyY5BnS582XGRn+wc+ca6GLFT+m20todG3aVCedMyqnSfjUPOLNg6fUTlVHRrxOX2PWtfUTo9mIcNXu0xOn5I6FdsyVf6F9hYXt58KpkYsOWgmz+5ft4D+wHWORaomaedkkfKtqtoZ0lf6gxdK1P6mxjX/SW6aeoWPLNC8zOJVjOs9HuW/8lG21pOFCJ4lkDpZFx2HVjCLTIQXu0hcg5jRSRJLbDivOedEaUIzrM87LiIGiyVT5sWTO7G4E0FUweGy3KTBl6FW2gQ25Whi0RfvtjItp8qj5dEKXajtgLRPtmt9Zy4ClKyuoHMZL7QY+6GJZUW4MpSGzxz/+TSTIeWFmsbbEwyn0wu5C89Ki0q4F9Us3OQ27eO0daIza4ISQRs46JRIvAsxounefTpdEfYLrnXZixFHDCStPc1EdA3oGKStD/dWG+dxnq7MWE1lh8Sm1OjxMfBz1fOpS2v4DMirzx6KKesZNt1bfhCZSnjzHEzklUycdXgXyiQn5/+KLehBJ/+/ROh2g0kYKeNltwgofcXPjBm2Z+f21Xolnahrfw4H1mFCkTcNnKqu9xJDIOJwA5RRh8ukoNGV2QSBvcssBJsKuAXjzFkf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > >  {
> > >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > >  	struct folio *folio;
> > > -	bool is_prepared = false;
> > >  	int r = 0;
> > >  
> > >  	CLASS(gmem_get_file, file)(slot);
> > >  	if (!file)
> > >  		return -EFAULT;
> > >  
> > > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > >  	if (IS_ERR(folio))
> > >  		return PTR_ERR(folio);
> > >  
> > > -	if (!is_prepared)
> > > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > +	if (!folio_test_uptodate(folio)) {
> > > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > > +
> > > +		for (i = 0; i < nr_pages; i++)
> > > +			clear_highpage(folio_page(folio, i));
> > > +		folio_mark_uptodate(folio);
> > Here, the entire folio is cleared only when the folio is not marked uptodate.
> > Then, please check my questions at the bottom
> 
> Yes, in this patch at least where I tried to mirror the current logic. I
> would not be surprised if we need to rework things for inplace/hugepage
> support though, but decoupling 'preparation' from the uptodate flag is
> the main goal here.
Could you elaborate a little why the decoupling is needed if it's not for
hugepage?


> > > +	}
> > > +
> > > +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > >  
> > >  	folio_unlock(folio);
> > >  
> > > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  		struct folio *folio;
> > >  		gfn_t gfn = start_gfn + i;
> > >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > -		bool is_prepared = false;
> > >  		kvm_pfn_t pfn;
> > >  
> > >  		if (signal_pending(current)) {
> > > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  			break;
> > >  		}
> > >  
> > > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> > >  		if (IS_ERR(folio)) {
> > >  			ret = PTR_ERR(folio);
> > >  			break;
> > >  		}
> > >  
> > > -		if (is_prepared) {
> > > -			folio_unlock(folio);
> > > -			folio_put(folio);
> > > -			ret = -EEXIST;
> > > -			break;
> > > -		}
> > > -
> > >  		folio_unlock(folio);
> > >  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > >  			(npages - i) < (1 << max_order));
> > TDX could hit this warning easily when npages == 1, max_order == 9.
> 
> Yes, this will need to change to handle that. I don't think I had to
> change this for previous iterations of SNP hugepage support, but
> there are definitely cases where a sub-2M range might get populated 
> even though it's backed by a 2M folio, so I'm not sure why I didn't
> hit it there.
> 
> But I'm taking Sean's cue on touching as little of the existing
> hugepage logic as possible in this particular series so we can revisit
> the remaining changes with some better context.
Frankly, I don't understand why this patch 1 is required if we only want "moving
GUP out of post_populate()" to work for 4KB folios.

> > 
> > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  		p = src ? src + i * PAGE_SIZE : NULL;
> > >  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > >  		if (!ret)
> > > -			kvm_gmem_mark_prepared(folio);
> > > +			folio_mark_uptodate(folio);
> > As also asked in [1], why is the entire folio marked as uptodate here? Why does
> > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> > uptodate?
> 
> Quoting your example from[1] for more context:
> 
> > I also have a question about this patch:
> > 
> > Suppose there's a 2MB huge folio A, where
> > A1 and A2 are 4KB pages belonging to folio A.
> > 
> > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
> >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> 
> In SNP hugepage patchset you responded to, it would only mark A1 as
You mean code in
https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?

> prepared/cleared. There was 4K-granularity tracking added to handle this.
I don't find the code that marks only A1 as "prepared/cleared".
Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_populate()
to mark the entire folio A as uptodate.

However, according to your statement below that "uptodate flag only tracks
whether a folio has been cleared", I don't follow why and where the entire folio
A would be cleared if kvm_gmem_populate() only adds page A1.

> There was an odd subtlety in that series though: it was defaulting to the
> folio_order() for the prep-tracking/post-populate, but it would then clamp
> it down based on the max order possible according whether that particular
> order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is not
> a great way to handle things, and I don't remember if I'd actually intended
> to implement it that way or not... that's probably why I never tripped over
> the WARN_ON() above, now that I think of it.
> 
> But neither of these these apply to any current plans for hugepage support
> that I'm aware of, so probably not worth working through what that series
> did and look at this from a fresh perspective.
> 
> > 
> > (2) kvm_gmem_get_pfn() later faults in page A2.
> >     As folio A is uptodate, clear_highpage() is not invoked on page A2.
> >     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> > 
> > (2) could occur at least in TDX when only a part the 2MB page is added as guest
> > initial memory.
> > 
> > My questions:
> > - Would (2) occur on SEV?
> > - If it does, is the lack of clear_highpage() on A2 a problem ?
> > - Is invoking gmem_prepare on page A1 a problem?
> 
> Assuming this patch goes upstream in some form, we will now have the
> following major differences versus previous code:
> 
>   1) uptodate flag only tracks whether a folio has been cleared
>   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
>      the architecture can handle it's own tracking at whatever granularity
>      it likes.
2) looks good to me.

> My hope is that 1) can similarly be done in such a way that gmem does not
> need to track things at sub-hugepage granularity and necessitate the need
> for some new data structure/state/flag to track sub-page status.
I actually don't understand what uptodate flag helps gmem to track.
Why can't clear_highpage() be done inside arch specific code? TDX doesn't need
this clearing after all.

> My understanding based on prior discussion in guest_memfd calls was that
> it would be okay to go ahead and clear the entire folio at initial allocation
> time, and basically never mess with it again. It was also my understanding
That's where I don't follow in this patch.
I don't see where the entire folio A is cleared if it's only partially mapped by
kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
kvm_gmem_populate() has set the uptodate flag.

> that for TDX it might even be optimal to completely skip clearing the folio
> if it is getting mapped into SecureEPT as a hugepage since the TDX module
> would handle that, but that maybe conversely after private->shared there
> would be some need to reclear... I'll try to find that discussion and
> refresh. Vishal I believe suggested some flags to provide more control over
> this behavior.
> 
> > 
> > It's possible (at least for TDX) that a huge folio is only partially populated
> > by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> > huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> > while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> > belong to the same folio of order 9.
> 
> Would the above scheme of clearing the entire folio up front and not re-clearing
> at fault time work for this case?
This case doesn't affect TDX, because TDX clearing private pages internally in
SEAM APIs. So, as long as kvm_gmem_get_pfn() does not invoke clear_highpage()
after making a folio private, it works fine for TDX.

I was just trying to understand why SNP needs the clearing of entire folio in
kvm_gmem_get_pfn() while I don't see how the entire folio is cleared when it's
partially mapped in kvm_gmem_populate().
Also, I'm wondering if it would be better if SNP could move the clearing of
folio into something like kvm_arch_gmem_clear(), just as kvm_arch_gmem_prepare()
which is always invoked by kvm_gmem_get_pfn() and the architecture can handle
it's own tracking at whatever granularity.

 
> > Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> > 
> > [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> > 
> >  

