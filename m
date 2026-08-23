Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D95C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 13:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EA26B0095; Sun, 23 Aug 2026 09:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A001F6B009B; Sun, 23 Aug 2026 09:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7826B009D; Sun, 23 Aug 2026 09:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F42C6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:23:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B59D16030F
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:23:47 +0000 (UTC)
X-FDA: 85132601694.05.CF3E772
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 869E340009
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 13:23:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RUkYnDFk;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787491424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=P750k92FDOPEiLyfEYlVAZYh/4kBDhf7cRJUBSouW3Q=;
	b=LFRKN4/pD0uATb+hmKZHkbbajXPhz2ODj17QZEZtT1q4kkBZK0DZ5c7gmOLs00zSt/4kbs
	8hdHYu9dVhnT1dvkos2yiaP7QJv9hEqw6uQmgk8LW+lSulo1YuY1uhLSJYHN4BxakCQmXu
	K57WLRVEcjSxgKTcKGKFtUksnzUEanw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RUkYnDFk;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787491424;
	b=f02KS8+4a2Jx7AWTPeG5WLIW6MQpN/WARPv2u/fjhSeM0DLy274Ulv0fqFxylIrUm2yFQ5
	2SvbjCAsjRNTJiljRYlbfcsmRUDJqAI9kb4K41AemebsVJLaDO3vAq4yaIpJ7NUZKN16KI
	MD+4fZYEbUfp0IPR8UFqYDbBnc2Ihv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787491424; x=1819027424;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=buWeOnDAjAbcot4xR0dhWSyqZXplZoESgZ3Vtl6z50c=;
  b=RUkYnDFkuvFszR85xG/7+eF6a3vttVixsbfy5VlEvaqM7HZp8M/Fjozd
   ECrvjiuh/EAX48ds2g5NMzMmXeg5zdKGDe0fODF9yVsw/Dm9KEIoheRO+
   4s3q7HzN4edLY99Gbjgb6mFPeBRq/LICYMW4C1fVj5UTOvaYLqfxiDVxH
   jaILGJZcZt5YYy1mdhszt/FCEyBASwiC04o/IzgEOw/07rr68T2+JG1Y4
   vxP6GfckDfy+ouLW4Q5TZRHiNB9+Umg5s6Tz0G8vyiyAkvNoLpYzZsQgX
   3eEcDub+RBfP4sHP2JhPcqNuQ+HkHz8VD2b1wvkfxgwSuYQUXs4Ceg2VQ
   A==;
X-CSE-ConnectionGUID: zjVrmxt8RheT8bTNsPbWKA==
X-CSE-MsgGUID: kPtJOq01T22gqvk2YWYTog==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="88021294"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="88021294"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:23:43 -0700
X-CSE-ConnectionGUID: CcAjTjA9RrqKKaR3mbnjjA==
X-CSE-MsgGUID: Qk9kpoXUSsixD2i5dI4Jzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="266246370"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 06:23:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:23:42 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 06:23:42 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 06:23:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ef0+B6zz3fN3tJX3hbWZcLQY4bRPl6F2yVYGpWQSle2F8YC6dPZm3Va6fBgxVPsUzsIRv+c/pokOd/lkK94YDO4OAvCn4OOoGWIdi54HoJH7uqz2ImP3LLmUdOU0TLDEoYZG/ph9veGYdyXtn3WgauwT28a+vNPIfCBicppX08DCJ2HkoNjEABCv26yLwhrfD2/9M/2Bpi90LXPtIjmMEOFrYnSZAvkiNv8FYPotWZmQ25SJeA5Ulvb3q0LBIRttCwijU5reTvQiKIc9GnwzqseeoN4/OEdX/6z2szzdRQb8f4S592O9ylELbOf/qO943Pc84RETicJ3qaSNgMDwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P750k92FDOPEiLyfEYlVAZYh/4kBDhf7cRJUBSouW3Q=;
 b=oZ2UBrrm/WUiFoO65V9uDDGLqYwzm2c2SIsgHQw4JoaViwify8B64qd+dgPIHziRW9AOVVErxo0NSMqgGO4J+6spg+XbE78v9Q+7tWMVL/WHmRtY1uq2H2Gf3pFrHEs+jT8XfOEXSEs2mhZTO31GlED+4UL7/YJtqgPKpqaAavDHHwPfw1MnZMBYtlH6oftRr6iTv3kBlwMwhOFXRXj24/QO4Jnbsx5OTRDuuKpgDEHSbowUaHUP7qZezWt9mdKMkp39K80wJTP2tOKCsSUrjSAK7qFT6dL267L5ewRQuBtpNsM7ExC0hor4R3QCj14gEzVZTsJqWWb4LCkQkPjQnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by CO1PR11MB4993.namprd11.prod.outlook.com (2603:10b6:303:6c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 13:23:40 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 13:23:39 +0000
Date: Sun, 23 Aug 2026 21:23:30 +0800
From: kernel test robot <lkp@intel.com>
To: Anthony Iliopoulos <ailiop@suse.com>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>, "Linux Memory
 Management List" <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/profile: remove setup_profiling_timer
Message-ID: <202608231532.dENn2OSP-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260821091744.91496-1-ailiop@suse.com>
X-ClientProxiedBy: KU0P306CA0080.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::16) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|CO1PR11MB4993:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1c01ac-6b12-4875-28ba-08df0119bea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: QAn7n54xw22G6PyN2GCVf5kJPE9IBpKebpdpQh5UnIuk+82tTUdnxsvhj1hs2g1QME0PdqOnY6gvtCRRmQ3KU0D8885n8IynWezpfhsXMCB3xK7Qi4FOZHABpI0jmZFYQp4OngLO8FFg+5Xkdsr7Y8ZYyl2eGWrIHV751WRH+SVhtDTdfaGVaHsQgTBvS+3qv2a/GLQCAptRj3mLcyY3y8MfwVNw0lDb+MAJiymd3lmfaCLFoanPzTIJQlY+kOEnlXtQxjUyCUvRhsdWBdwvfx9oMgkNHIWchMIW2Q1XgK3JhmUauRHn1/ac6uaNwqt254F4xG47VjOScBh2Lk/eVHUD2CTuUtZkl6LcBe8G3wuMPNZXA+cxAT557gG5japLvMo+N4hNbpWKYjjgaXUTnhKOZ7XrZG7sdmstWshKNM1dvUpOYhLTJs8hSLiLJcJWpyvSW31XLyEHAWNw/Zw1LYBti8+YM7RPotLnsDrYa2ygminOU/gzmcWtYLM7KYp9uOww0T7shO6JU7pFjO9zYjiUuLUK3P3ogaM9HbwyVi82hmejV1q2jhDISDASJ/VEdhV+2wkaxCqNSWgU13NFEPgflRYUv6BxxpeQHvPB5j97pmxY6sxC7ySBSkCLlAYT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPWtysDvARmFcdEhSrUGlmNapBJ9TK77dryGMlKsDpIQcrZum4oroFgnwNQT?=
 =?us-ascii?Q?ZjEzC9iej7hfwqYdxM+dHyMgetWH9CbnLldk4EeMlg3UpSYuLKd9AeXgVhs+?=
 =?us-ascii?Q?tGmJaD0YH8JLD/650tDaBDCHFd5TgZUCOvDpUQhwfIgpEWt5PhxJd8bZZSyz?=
 =?us-ascii?Q?+DUjN9yq+pHW3rfgUtm/ugrNyEzz2p0Pl3WSrCyi07s0uklNzYFjbSdrPwTt?=
 =?us-ascii?Q?ss5b9MWzFsMyVimnP9gMeCMPH8/BWJebvihHMf2gOtiGioq/zNec8OFs7+km?=
 =?us-ascii?Q?wEZcPD5kX4WYZKHfliOyEu9w/r9gLeXKD5pDAR9wk4IBH+KSTV+LEBQDyAJN?=
 =?us-ascii?Q?xkrbBWStti1jBx8+IDtvr/Z+g5cIulL2WVH84IsEREajqvnGtEMH/9ONwSm3?=
 =?us-ascii?Q?sfsa39Q6EgF8T+j7w4K/Zu8oUyuZZ5l+Y8U34HXZgUyAVCH1P7wqxpqxtCLX?=
 =?us-ascii?Q?4n2s4nRZ5MQuAY+/v6YEM+iu10JrsFd/coV4dsj8wjXLMDi9W7apSfV9szjr?=
 =?us-ascii?Q?yOhm5nGMcAevqxOswVRghGvsE58a9ZVkXRjGAvNMxQPOZ0wMmVIuIg54E6Gc?=
 =?us-ascii?Q?YcPaFkQmAf5R0IAstM3Q6Hqt2u70nn29A3MgasYeM6Ii2wfK1Pi7fDZsUxU6?=
 =?us-ascii?Q?x2kNH4bTEDT5wnq4lb0tJ/JYIIdKdnEQIQ8V6ijdY3RLe4Pdb+s6IUK+NvP7?=
 =?us-ascii?Q?1CWX+dTCgOeSG7d5nrLQcrTlHSbJ9Q4NTSct3unskimIwToPYQfsJNr5m9/q?=
 =?us-ascii?Q?BEYYkdH6LYW8og8XBJx8bBSSM2FckdTsjqc6yuYIT0pQZM6XNYjfC0uJAg1s?=
 =?us-ascii?Q?HuDYGFAnEUetxnjyG2poUA66HxAkHos084QSl5Mz2TBqyxbspjjgOov5RmRm?=
 =?us-ascii?Q?gTXbQ9TYjmrCPoDPCJW4+N/RQLl5fKfHEiqwmLqTEUdkfx0DHECz4ewDymZ+?=
 =?us-ascii?Q?gON/QiA6eMU7GGhMbOJCYNQSt/Vzw+Mx8BcT+soFrMKlgF1GULMciPi8t+K9?=
 =?us-ascii?Q?dSffi1K6D2WFM8DPxK6LayGwSs9BcZOqAm8InkS208Z/mPmQ48xi9hIgIrRn?=
 =?us-ascii?Q?vM9+paSDoJesyTXGi7UWkgmJMYRrt8j9P+cc59uGTDrRlP8YMiNopErNMr1J?=
 =?us-ascii?Q?bVQos9u7DX+Jot+7El78XCKrtgP+f8P5HcqYlA20SI6kKQRK/+KSrg0zz/BV?=
 =?us-ascii?Q?NIkTsRsTtgcFHbfLDa3Mep1HLY1UCx4W3ldkbGCCdn4OoRn8fKNtvVi+Sh5x?=
 =?us-ascii?Q?oh4ioEEaL1mBNrLohvUZWJg6R39/G8YcYDkdvnfO7wxo4aiKscG8zOGPvhl1?=
 =?us-ascii?Q?mmyFjpiqgaavpAm41B+/4KaYAUjVYzK/oWf738kL9YxDtdSF7xPb8jACjBPO?=
 =?us-ascii?Q?+rfnhkmP8WXYmvyEhtz9inUsOtx1DOxk57KYpsdrAVS7SD9OAeaBCey+Uoqy?=
 =?us-ascii?Q?ZN6VnZakOlSJBKnFbEY7ePyEchNMlADUPnOUOHFUrirl/K1vpjeCIgRTqypo?=
 =?us-ascii?Q?I1EKQ3icX3FdGSJzyjSj2PLvtnTLpk5L284r8rKh1oqeUQg7FAfo8GTwq7JK?=
 =?us-ascii?Q?KZ0mgQ45C4Ol+FOGnOdooQ9REOjz1OibnU2JhzLzCGDmnTA8mvFszhximSP+?=
 =?us-ascii?Q?C10yLjii0Q3aoyKBbeZAZZGEz/QHX6ltNi6/z0PeaAbunC4FtwqMeqa3YI12?=
 =?us-ascii?Q?Y5og/Nkx4ZxjrSNCwyKt590o0b5logNgiedEBd2G9YWBtU1m8XmQ6pOmklYh?=
 =?us-ascii?Q?XKsmbWqNuA=3D=3D?=
X-Exchange-RoutingPolicyChecked: xQK1Bmc/gh+D2pt2IpkjYt24UxPG0B+a8ATP+Jc2hGHuwz/TeDs+7iKL/m6ZHCTctWdWUn5JXbQVw7Ikjpbe2WxEHUWInTQDhfhtZKgJyHZv4jjmYWjgAAkfvQ3HdN3NZ3JL9i0DpcQkK3K4vYWCXklETjXvOT4PCmShpeDa5ulddHSAsVtK/xBCIEcGvx4eK8dWDuTMpwSt4N2CUFn4Fr1Djf/Oj+/CZT7potnmxUjnIINh3blSoEYrAGHyesv1Jhgxqu1r1cIh7NZR7JieCEhcua1M6dIbqk1kJrh5/gX7+bfXC3jiIUYaedKRsAxaqNfBWzAUS/dT3C8eBljRzg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1c01ac-6b12-4875-28ba-08df0119bea1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 13:23:39.6794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnXvlPyh/47TjI2tInvfxKlFZZSRmvlUqCSiukMVnxmMI/lUh8ApCOQ6uo6hDhlQdKbpg9odnyQeRJLbLaw7GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4993
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 869E340009
X-Stat-Signature: g3hiidjeeqwr77h5r7aiiugggb5ye4qg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787491423-33084
X-HE-Meta: U2FsdGVkX195Yj9gnJ4OqP/+PWXcasgV+F3FF5aVpeI+AZnRyjjEmmSPftvKoBFdb1PG573mTn/y0oyloAnUIYDj28ajPiOToarHEwcpgxjHzKhuxPKJ2NpvFxnYYwrYqDiIfHSSdaEQ9J6UBVzfKRf+XGgcV0PnfEN+pGmhoQejmPQONYDnJXESdigP0laCODtQAWrDFTBSeuMhGhCCAp3Ip4aNiNOyoukejH4gO7ryTLufL6uNUtWkxUWkqGEJ18eFsm2P/4c9bbXiFQ8gyZAQaKhSAyW6Wr80P081fp1yY+T4wFGvDA+bYO4d2qcpMA1Ph2rvHTSyGbZ9hictnLtsMSugbORuAvirGB8lOEVXuqRkGG4FYufWMSztfPfxHPJk4qI0CY+mxUV+DUHZJoEngKjfrGOj+ZtUMP8up1PdgjzbLsm/BDClnGenBhvAILTvSn9EuOTexOakqkyiOhzDyhgL3oojQtaWqqTtE4fJZFbn3vFa2KXG+lzDdEqu1Etgrg2YC73DWWQrDY+2+PZ9E0iwZsJtTGKO2beOvuNCL6CS/iw7FdH5XFNOzZ+5j/jJ17mVR+ruSamPey1e3+BCVAF3yIKv73jYBVY23/Tmd80pdFcH74Tvmo3B48ZW/s5/RwbCBEP8VL/AlHc61Ry9N1d9P+jYZDtgH2s6lcCf3yctcC8xKkqfFIRP7ePemnejDoMBqoopYb2gBO0zgKswEbkLYCJNoZzCDvDedAv2aa9z96WjgKVyU22m5N3YOWtFxc0QTjgtahjUXwleMhEvcI7L8XhxPOJCs7ivgzSQmvRBuY/q+as9sddzfH6Y+vjr4jSfePFrLDkUI6HB/jrvLMfiybrPMJOyi4i3EnqunLlaeWnVvN5nXacyepqzM+/tDbSg3xhwUfvAWQLtJMOeb6PSW8cHF1Bva3cijtFUh0R0UmXxDp9F21nyy+/mNLThqz8Nzv/yVteHeTY
 COI9uXFk
 Kz3mSJNC4MWxUiPbJ3g4HVdlcM81LOL80bFhGeBqNeGS7RfQsbYwuqr2QcxmD+56OKt8i4jdys/r8fhjIk7Zy/KH2HVb9IWQYyh+McPvHg25KWTOwWDJlBy1dWXaFWvQy+kJ9Xz7d/HNZirU8YnERPjLvGTluGrysPelmLwyzwJsUJJEgDbGQXNvLDl2QCWi4Osh9Iqw2TGF4dhfbMvZ4WSnF+zGWG4rlN9b1r7IS62Qj07GTIAsAS4tMJ6ng7Ci/mLuw+fCVVNiPPESAytiHKQk9IdU8E2ndrVE56+W8izUP+lfSKvFAuzrB0aWI9RhaIr3psOPCmSuB7t1zDTPV4puOJfmKJ8GVe8DzC2UHoyKV9ERnabJQ1HO3hbI2LjWutc7bdimdTNnOBXMIWwfYKeKMde2Iepm52KM6uYwaDgERD/zrRQaG8DzgD4jeEU0lzfaPij9GRfy5U+qixKMzVEuQsJtjng8xgxkV0WO2lUbUV5gNDPrhZWsanEC8BKDg42I0IZ9nCKRgRN5XDCqJpTtE5/xd6cRZVekkyvS0Zm5BhfPpYgLGWUmwmmvsRNNW1kuyF1Uu4NiKUwXfUUCTWOUSwjc7NmJkqIdTFgvXjt/gG1V0LrOwmTVNij4HAEQ2Ynb4kUcm+oYpyDkWWjWtzdoYIkkCs+aCBOZYzAxF6nk6n8ChzSashJuvx4zlNSoCTmUFF40nkMHtr9FMNXCdGAuFX0rqwzl3Xdf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.2 next-20260821]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anthony-Iliopoulos/kernel-profile-remove-setup_profiling_timer/20260821-111744
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260821091744.91496-1-ailiop%40suse.com
patch subject: [PATCH] kernel/profile: remove setup_profiling_timer
config: loongarch-randconfig-001-20260823 (https://download.01.org/0day-ci/archive/20260823/202608231532.dENn2OSP-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 935bfc708590c60147a79c7df145bb6e68b1d388)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260823/202608231532.dENn2OSP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608231532.dENn2OSP-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kernel/smp.c:720:5: warning: no previous prototype for function 'setup_profiling_timer' [-Wmissing-prototypes]
     720 | int setup_profiling_timer(unsigned int multiplier)
         |     ^
   arch/loongarch/kernel/smp.c:720:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     720 | int setup_profiling_timer(unsigned int multiplier)
         | ^
         | static 
   1 warning generated.


vim +/setup_profiling_timer +720 arch/loongarch/kernel/smp.c

46859ac8af52ae Huacai Chen 2022-05-31  718  
c718a0bad75cce Bibo Mao    2023-09-20  719  #ifdef CONFIG_PROFILING
46859ac8af52ae Huacai Chen 2022-05-31 @720  int setup_profiling_timer(unsigned int multiplier)
46859ac8af52ae Huacai Chen 2022-05-31  721  {
46859ac8af52ae Huacai Chen 2022-05-31  722  	return 0;
46859ac8af52ae Huacai Chen 2022-05-31  723  }
c718a0bad75cce Bibo Mao    2023-09-20  724  #endif
46859ac8af52ae Huacai Chen 2022-05-31  725  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

