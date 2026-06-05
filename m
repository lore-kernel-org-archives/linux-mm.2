Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA33CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8026B0005; Fri,  5 Jun 2026 01:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98B66B0088; Fri,  5 Jun 2026 01:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60476B008A; Fri,  5 Jun 2026 01:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2D886B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:41:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CBECA075D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:41:05 +0000 (UTC)
X-FDA: 84844760490.20.63F70E5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf05.hostedemail.com (Postfix) with ESMTP id E582810000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:41:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jXP507We;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780638062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wPlpEIRyHT6DZGvUEwc41whfA3il65GmnLJg3uD3JqU=;
	b=CPPxck03zcc68Y6s+8SR4z2ot39u+jvcFtR+yOFfMcbi8nm85hGM4vaaT5TCJz4k+mOGku
	pJKP87zSX5s6pevDoj9KhLSysqRKiesQbwZ8kA0J3lOfH5rUjcxBmF5/eEuJgPWpQFRJjq
	MgBFjcPnX8f2h2JjLMOmBMyOMjsaGiM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1780638062;
	b=JAczKeB/jxro+DR0qWG5kYAeqNAE+IsSiqRCJ/VM4n2WMLXaRUGHl6JPIcubii2U+0utdp
	Oe6oY7SL6rtA8RW6FZixDpmmq955Sl6I9b2lrPPhStsqlZMpJ/STWiugUNZbNIdzs5VV/p
	VWZ1bAu1e1IS7BEptotz3VTQ4LA8mDY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jXP507We;
	spf=pass (imf05.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780638061; x=1812174061;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6u/Xx/R5/cYJaBwhYfp+j8Ed4+FUD98VLd8GAtmgrIQ=;
  b=jXP507We8KKALeYaVzeJRBx0AtQ0C6zRNnzwtMH7O60KmStcZTTVSNXt
   pfNPX5zpaKUzsZD2KyFzI0RC+kg+jPkRbBMf32/lVz+WwnZuaI8grZt7O
   j9HWOtufZA3fcriCdy7cudRzd1dbcSkg1gN8EvrpbnLy+GobIgH4+0Ha5
   dO26nc/uyCfFKb9IpaV+Ve+Enh3ShHdQhwa/gvXrLn7UZzZdPT7QMZfas
   dlQEgFyVHhvlgUewu9TMAXNq9Qe51lGLOy4jAFg1Oud5Sq+Rf1Gz2NMYP
   i/MT5zZaLqInIF3OevdTY1CmKKWeLlKaRlmEUVqFuMCzzaPlEMw1kn30B
   w==;
X-CSE-ConnectionGUID: 91lRmFtsRrG+/B82KJ7Rqg==
X-CSE-MsgGUID: 92PFVoWoS7Cu9o7R16bQhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="81470418"
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="81470418"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:40:59 -0700
X-CSE-ConnectionGUID: 9tL9sRCOSd2yUIJjLFN/Gg==
X-CSE-MsgGUID: bTAywSqpQKCpZqLbWUdtlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,188,1774335600"; 
   d="scan'208";a="249681512"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 22:40:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:40:58 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 22:40:58 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 22:40:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HnhaoKh1LR0ygcmtbolzVzDn9ElXdULQrWByc5DgKS0zUbHrdeKdlegqU+r/C5CxIgSt/C9TuIUdg1iEhMBq03l4t/tDODIXHY9ltZTO5h5IcL9Qm1DLHToUA9vjPh996Z4Oox7PBN9q5NkuBGjv8raci8QfhL9cgJ4vegGdrR+I7cihGlrvsTeLalDJpVGLaY4gAO1MgZrSpWjMNMb0xE6hQ9cqMx+85tkRbDt5SkD7fXlLlg60/AGpyCnRJVQKLRHbGo8jywzdUXdKvfAoOzlqtZC6aHt8fYDSqFdHmwyLG/ITGprOK2eo9xrmhWbdKMMtHImDDqDxVUBfF2PwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPlpEIRyHT6DZGvUEwc41whfA3il65GmnLJg3uD3JqU=;
 b=fYcpsDykgFYBy6nXbD8KQQaBQH4f4AHR1k4CgcqUAdx/IXwP32KtFQLbno92xLpoizyjtYCv5sZQTuEAdv2PVGaz6Onz0DlKApVK3r5gMbJ4gBd3F9nFgNT1KmkkCujERQ8AvWVWwPoSvvnxNoost0b975z2CCQteP3hgCRmAK9lepAWEMpIvBGIqw1wAlzF/KMHuxA4EYRN2IpOBCuWqSFMNVoXCa7DivBCNe0Qgg8dsEmz+wrUcKKWBd4c9Ikz39XwZE1R+N95THsh7LR8B0uBFZ73cbnzU56dKPPWxTiN6kWXoZImBcFr4p3e7nU+mgOL7GDevm46tYRZeGQ8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DS0PR11MB6519.namprd11.prod.outlook.com (2603:10b6:8:d1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.8; Fri, 5 Jun 2026 05:40:49 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0092.006; Fri, 5 Jun 2026
 05:40:49 +0000
Date: Fri, 5 Jun 2026 13:40:41 +0800
From: kernel test robot <oliver.sang@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  504f40f6bd:
 kernel_BUG_at_include/linux/page-flags.h
Message-ID: <202606051117.7b999010-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KL1PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::27) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DS0PR11MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 21e346e2-053f-4947-4871-08dec2c4ff8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|56012099006|11063799006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: BE0lzFxu/LCoJCDJkXLDVrf/+CHy3tZ1+PIbsibuJ1mnAWM2li21FvHJrHlSt3vHQARhyrXX0bWo2wqBdUwpDEuRLshj/b3jI7g9SGAnitDC1BdkaidKYXnM8AURDNWYgA4Y3WFpdlOBpvhqOxrIAZMJbMlSTPbwT5gqPOUjRnyXmfYXDYsjrdaN5rrxKOmItsejPANpKOZhNVLOWR9grnbWjMINNINaKc8vXp7I6opK45lgtfSpFlS4QSdT5L/DcMVB8skRxjSqA39iRo8d804fScbE2ycSKy7B5mEQuZpH/zEU2PzcbA7drui2mzH3e7aw6NxXNmkdlsImp5KLQ36fUkFu5UONCNjFHABqzc8hyl4+k+Xc/r9T7MwZxcdeMN5cDnHY8NUDG5O2S2LNz6TnihoCTC6ErS2QYaa7+tuVAtqcvl9hMdEoo3cfuhOycjxbmgwDj7GF9iTg0LQedsANEFC7fVk0S1SU/vnk7rSTvQvJ1uzsyrq+70NGc8wssSPKr3O9xgJC7/dglHI5fIYebpTroN+yTbeQ1XS3KSoZhZv0NRnVnAFwB0KYcZSDOeEygtui5np2YbtlNORl2IleTx1iCwaKrPjWElcSUFrHcLj/5bQbQCDY4jNkRSmItrZXQOZZbHOaZM5N2+S0PExggUr+ZxhQMCi9I/TbsKgWBdWxZ7RqVsyVqEXP5gL/T1qA6Q2zljtJwG64/UR0KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099006)(11063799006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oUSWb/ppsCgIgEBu9mlKtv78R5qgJRt0VrX6r57ebhKJiFigIQGRq2fffze9?=
 =?us-ascii?Q?vsgOElClm85d/lPasx8Z3SojDZY6UC5VLXkdIEY9bjtjpf1rMc1H53izvZ4q?=
 =?us-ascii?Q?gwuqSGMLwRfrR6V3QWhNCoKsqCtTDlGwHgh8PoWduNvlABNYeULZtYPc8vKS?=
 =?us-ascii?Q?CREjb80UBP0rBenoH4TvlZbnzdkQsJt929lc99lBRG3swpA1SD2oNFpJtegI?=
 =?us-ascii?Q?JuC8Omb7eWLLCaZpZtDkEvTn/dAlk8tnFMF85iulPARAWcWLcupMkqq/3x+b?=
 =?us-ascii?Q?IPFYZHlEiglglnniw7Fio2RIZKHAdss1fI6IToh/uSbGPcA9bW1jPmsLOmM2?=
 =?us-ascii?Q?/WeKhbg7FLK3Eft4d3T4lSWP/9lh9svtN01as594WnneCMOD+//aG1iVHCHo?=
 =?us-ascii?Q?U3610A5eKthNM1+B+QFF15oAKn8T/xVsmi+ESuh6vdU3i0ZaWkvm9uzH1AHM?=
 =?us-ascii?Q?WwzTNKeF13vLxtT+h78Zg4O2/R7X8h2dulD33K9VyR8CovSm16nm4y7XcriG?=
 =?us-ascii?Q?75O/fxmfbP8p4BY2tswM91Is/Z1m/H/0638V1eBhuKgjSpCF13g0qlyTP1jz?=
 =?us-ascii?Q?Xhz/9E49pV21YkEKNRJN+jeoOgQajvsonlt61s/GTeNSUVlHT+zFk3Kl6TtV?=
 =?us-ascii?Q?QDBEugYVHyB7SIAZCZmeWsIPEqXbCMBNKyAsIq26QLrEjmIJU9AjJN5N8wlh?=
 =?us-ascii?Q?9R85ltLcFFtsqeZWv/LtdJlf+OAIFyFI3exMBl5/PEdw1iqXeE2TH+jml1Ff?=
 =?us-ascii?Q?cpy9DiNoZNBPKsFpdlX1dA3ejUBt4mytwhhQZQyVmAyHglsywysOOP47gkia?=
 =?us-ascii?Q?aFNrgpLYsLjLO9Xep7Xry4HGZKBEEuE/+VcBI8+sYQbolSVDF80kB7ZMqHUc?=
 =?us-ascii?Q?HNmeUlFBvBliUiSL9ACpy5HffhfG0GnGkxmM5r3+ee/uK3MWNskfI7VUynlA?=
 =?us-ascii?Q?0Yp2qL295YjivPjLSEXgLQMNJ9pSwPwepdz8p6Mn1eMcX2huNT/zje2HlFOv?=
 =?us-ascii?Q?EAzTBUouNP6OOImiUYs042L/tWkHyJ+qeDtSNvfWhYXzoKVEsoXab/MKI3AU?=
 =?us-ascii?Q?+WZmjQ+fLVg3B7r1bpo6QODrGJifjI6CWfhmX1w2OO81axuFjjWn5vUt3v0q?=
 =?us-ascii?Q?fZpnDGVmCBEZ3Z4jrqGBcQH6o/UIhN4d6hhfhkPFWTaaQaC3CspTvhJpJutF?=
 =?us-ascii?Q?OP3gwGKiWTMo1Fnud7gcES3aYwC2cS/X12X590jGNeSxvNqkB6JYvjoTZ3Rw?=
 =?us-ascii?Q?dReiAnTY8zRsOLp/sso4dm2AkLTEQJyeoo6PH2T2cZ0hqzkDS41gAEnYEWVk?=
 =?us-ascii?Q?X6+REmT3tpHFrAExdqc0xX3dBpVvKzN14swESA7dKzcvdsqBQgofrdpmwyXA?=
 =?us-ascii?Q?bwZtGy7PDZ8lxbdndYWznIfNjKVqBos9S8iEijJx/5O2x+d9N3bftnXN+/jV?=
 =?us-ascii?Q?hTg6b9vC6hUvVVgFWXuHXn0GwtJ2qFraVZ4zXsTdW4ZVIZ2JYFOSF4YLOelr?=
 =?us-ascii?Q?CA2iGoZXd9nM4nxpFO1lHPtgEoPdDRLR+B3EKh70xyFen6LLMoIaEgTYhS+Y?=
 =?us-ascii?Q?4u0Bpb7lL60HKHYg0ndpMo6prwTynWqXrDw++D5x8gKe4WoUcNZUKX81aVmC?=
 =?us-ascii?Q?OIo7ge/X+IYTW6X5oI5UPmG3w6T3G7cmpE1vE42aja8ur000MLrZ50iw2fR9?=
 =?us-ascii?Q?3y8vEbH5r3hMkHJu/19AOyFbECZivgumBrCx9R6V69ETLlvp9vnz1FvrOpJO?=
 =?us-ascii?Q?BmOFW7ldig=3D=3D?=
X-Exchange-RoutingPolicyChecked: Jk3M1449NbmWdzZ8Hj+GZQ4ylzq9GoB+VDmhNaCVKDQHdySV+AQtnfRVthBy6X2vbO+TBJT/ZllXZlCW4tZUwhe/OGRXnaJQIoHE+apEBkvNEo7Nhg+soYW8nNideoA8P0VXRKW5+6fAk+H8rbsYo2PZC7/zPFhVmuZPGduSOvAuIqytC20IeOVBNX/8MW+WGB+iUYahk1q9uNjsUOXfzGFsYKL5HDx7t17yOzXXRDtjRL8gYPVIeKxC/tbxbDarQ57NdQLM9mL5aWOBe4OX/tLqXoO4EVrOcJSdr5IDoVFAKWLVmJ/WYQEuK6x3XMlX45lUTgzlYT2oiR0x1Fda8Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e346e2-053f-4947-4871-08dec2c4ff8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 05:40:49.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lld//FuWHdVoY2CWPfXNSaqSYqzlvmBzuIl22S42oAHgikXnCryalxgE6eqyhDibyROz9HfaWjS4kD9oClOaJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6519
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E582810000E
X-Stat-Signature: 5k3xhwqep3jf56ejc6ntyp8mewp3zxxx
X-HE-Tag: 1780638060-103232
X-HE-Meta: U2FsdGVkX1/V2N77QBzx+SdtinsCdPvCaknSyLpl9rF/BxJ2IAVO3oNSK2C+xPVN4bBxHYFgZnOScJBxlCp0MxXggA3Ipf8MY/mew18T0xelMA98j9CDkAi1XqLytP83E9XHdnft7QfvMnpdbEf86BnVa3pi0j2fDVdDeIgJCrPm9zK90rxOtmR0GYn++rWGvZ/pDbKTPFA4xMartoeDIeaSDhPdKBShUjYAwEcmHVsHGUxP4HSuBkNuEr5/f417+Z3UJBMXIvUTGmSFSXZ6KoOJa1vmiDwklAucrgakiZH+30AvdlvSkb5lFCCSlBQKSG+Io2ky1tj/TqZKU8Hv404UJAnQj6ah8T8zl/78Q12PGb0BUiBCuDZHuk31WZsRIg9meFF0BoGJ+DBQlUw7lSkIoDUBoMkU/hyT5CByM7hlhDZAdxwqy8joFdHIei1/sF+FQZkDnxXuoZJbs7152ZBWBNwPY3L1KlBkidsWMV402hgp2ZnjEVQ09udx2Ay4L+3ssC2rXaD5DidywugETER2qneu1IRFUpBq1yXnwl43OPAjmep4GbgGjXOsV8JEARtq1gzKgiVL2PDkGs49layoZnksSvCV1e4Qrln70I6dBzUrCEiMEOaAOmsi3YhdJfTE3FDNI4PWlfYsrN+TCKbpBXQGAwqW0oVWfVPh/xoece07qPhuc6bZ3Hsek8Bj6+3sCKWwSzb+9MjbUPOL/QIaTNk14052AbG6NOYcktziPlSzXFgJfdXURf71fIpivTyLhu8NuZYO7m3KnktY1XcYNUez35JG6lCv1auLKbysU9mwqtJ7szKef1uXKGbfufj/2+DZSZ+QH8OhFQovV9qT+GbNcVjBqxehvv6eiSONsNnBJkSKn0YeuGfinmB2e+hkZT/RFKTLyCRqlCGRyQTNieYo74XqrjWMUCRzjR8b4dsGRZl0DW54x/DWJeqTEBqLTWGDCMN7ZykPyMM
 qvqDlsP4
 ESpI2Tjo6zcAE+OYXJ4ARCANECFSxY9xIXo+njWn0NG/mHuF40Dw5M9IHfj2H+738tJj5+4FWLyoW2czt52+Zgt7EhQHLs4suhok72QHrvzdYeWactTdTaYT4QxvYvuDRUa+h5tTDfwxPOMHNZu/w4ti8KlmaUMcWRFYjFGTWK424mxYTw7Jv/a+SsAr9Ke0lSJsKB5IHOYmteiO0cygfWiLRxvbIrrEuW+J5onUtoBNrtS65Hb938i52/8b/8Wcnq2TIQf+Dy75GdhwzdH0K2XjjC3upomMG+EQDNMImRRkFv2VU8DQPlDjHYVbU+MCFO9HB4OYnFNkt4k2JrQ6it9uRFyZcPjgGFui/3k5H272hxq6dZcpUUCjSERrjeVmvyYcHrJKNpptXTbldiWtcs/gK7Itq18GcG4SRffrnH9kuOX8hk0KEMGLB4fekpBTxXsQ64qnhr+fk4luUpd4n3wILDmmnNAiJ5yoZZHhzXByPPQde23s+5VGErB8yGSWdy+v7r0dTgOgbX9JddtrwcZ7CtThkh62k3946JRaXm/pMLmuy3r0aFT40kGSOu8t4q3gjedMwZAawx40JbLVfAMTRKtqyt4VlYFUj+Ig9Pgup81U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "kernel_BUG_at_include/linux/page-flags.h" on:

commit: 504f40f6bda6afb3c5dc9924f74c583b6e394554 ("mm: page_reporting: skip redundant zeroing of host-zeroed reported pages")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master a225caacc36546a09586e3ece36c0313146e7da9]

in testcase: boot

config: i386-randconfig-002-20251019
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202606051117.7b999010-lkp@intel.com



[    0.218502][    T0] ------------[ cut here ]------------
[    0.219180][    T0] kernel BUG at include/linux/page-flags.h:688!
[    0.219979][    T0] Oops: invalid opcode: 0000 [#1]
[    0.220604][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.0.0-rc2-00009-g504f40f6bda6 #1 PREEMPTLAZY  25f758a7ca9ac6ee8258fdb39cd5b7566f523e33
[    0.222356][    T0] EIP: post_alloc_hook (linux/page-flags.h:688 (discriminator 1) page_alloc.c:1868 (discriminator 1))
[    0.222995][    T0] Code: 83 7d f0 1f 0f 87 10 01 00 00 83 c4 10 5b 5e 5f 5d 31 c0 31 d2 31 c9 c3 8d b6 00 00 00 00 ba 44 7a 3c 9d 89 f0 e8 f4 31 fc ff <0f> 0b b8 14 5e a0 9d e8 90 53 cb ff 2e 8d b4 26 00 00 00 00 8b 45
All code
========
   0:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%rbp)
   4:	0f 87 10 01 00 00    	ja     0x11a
   a:	83 c4 10             	add    $0x10,%esp
   d:	5b                   	pop    %rbx
   e:	5e                   	pop    %rsi
   f:	5f                   	pop    %rdi
  10:	5d                   	pop    %rbp
  11:	31 c0                	xor    %eax,%eax
  13:	31 d2                	xor    %edx,%edx
  15:	31 c9                	xor    %ecx,%ecx
  17:	c3                   	ret
  18:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
  1e:	ba 44 7a 3c 9d       	mov    $0x9d3c7a44,%edx
  23:	89 f0                	mov    %esi,%eax
  25:	e8 f4 31 fc ff       	call   0xfffffffffffc321e
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
  31:	e8 90 53 cb ff       	call   0xffffffffffcb53c6
  36:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  3d:	00 
  3e:	8b                   	.byte 0x8b
  3f:	45                   	rex.RB

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
   7:	e8 90 53 cb ff       	call   0xffffffffffcb539c
   c:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  13:	00 
  14:	8b                   	.byte 0x8b
  15:	45                   	rex.RB
[    0.225477][    T0] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    0.226363][    T0] ESI: f4102340 EDI: 9dc37ba0 EBP: 9d633e20 ESP: 9d633e04
[    0.227277][    T0] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00210046
[    0.228243][    T0] CR0: 80050033 CR2: ffd99000 CR3: 1dd74000 CR4: 00000090
[    0.229132][    T0] Call Trace:
[    0.229534][    T0]  get_page_from_freelist (page_alloc.c:1938 page_alloc.c:4006)
[    0.230201][    T0]  ? __this_cpu_preempt_check (smp_processor_id.c:64)
[    0.230883][    T0]  __alloc_frozen_pages_noprof (page_alloc.c:5297)
[    0.231617][    T0]  allocate_slab (slub.c:3269 (discriminator 2) slub.c:3458 (discriminator 2))
[    0.232174][    T0]  refill_objects (slub.c:3516 slub.c:7153)
[    0.232743][    T0]  __pcs_replace_empty_main (slub.c:2818 slub.c:2839 slub.c:4602)
[    0.233433][    T0]  ? mm_alloc (fork.c:1157 (discriminator 2))
[    0.233945][    T0]  kmem_cache_alloc_noprof (slub.c:4695 slub.c:4829 slub.c:4851)
[    0.234624][    T0]  ? kmem_cache_alloc_noprof (slub.c:4689 (discriminator 2) slub.c:4829 (discriminator 2) slub.c:4851 (discriminator 2))
[    0.235315][    T0]  mm_alloc (fork.c:1157 (discriminator 2))
[    0.235814][    T0]  poking_init (x86/mm/init.c:824)
[    0.236341][    T0]  start_kernel (main.c:1072)
[    0.237088][    T0]  i386_start_kernel (x86/kernel/head32.c:79)
[    0.237969][    T0]  startup_32_smp (x86/kernel/head_32.S:292)
[    0.238817][    T0] Modules linked in:
[    0.239561][    T0] ---[ end trace 0000000000000000 ]---
[    0.240564][    T0] EIP: post_alloc_hook (linux/page-flags.h:688 (discriminator 1) page_alloc.c:1868 (discriminator 1))
[    0.241521][    T0] Code: 83 7d f0 1f 0f 87 10 01 00 00 83 c4 10 5b 5e 5f 5d 31 c0 31 d2 31 c9 c3 8d b6 00 00 00 00 ba 44 7a 3c 9d 89 f0 e8 f4 31 fc ff <0f> 0b b8 14 5e a0 9d e8 90 53 cb ff 2e 8d b4 26 00 00 00 00 8b 45
All code
========
   0:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%rbp)
   4:	0f 87 10 01 00 00    	ja     0x11a
   a:	83 c4 10             	add    $0x10,%esp
   d:	5b                   	pop    %rbx
   e:	5e                   	pop    %rsi
   f:	5f                   	pop    %rdi
  10:	5d                   	pop    %rbp
  11:	31 c0                	xor    %eax,%eax
  13:	31 d2                	xor    %edx,%edx
  15:	31 c9                	xor    %ecx,%ecx
  17:	c3                   	ret
  18:	8d b6 00 00 00 00    	lea    0x0(%rsi),%esi
  1e:	ba 44 7a 3c 9d       	mov    $0x9d3c7a44,%edx
  23:	89 f0                	mov    %esi,%eax
  25:	e8 f4 31 fc ff       	call   0xfffffffffffc321e
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
  31:	e8 90 53 cb ff       	call   0xffffffffffcb53c6
  36:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  3d:	00 
  3e:	8b                   	.byte 0x8b
  3f:	45                   	rex.RB

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	b8 14 5e a0 9d       	mov    $0x9da05e14,%eax
   7:	e8 90 53 cb ff       	call   0xffffffffffcb539c
   c:	2e 8d b4 26 00 00 00 	cs lea 0x0(%rsi,%riz,1),%esi
  13:	00 
  14:	8b                   	.byte 0x8b
  15:	45                   	rex.RB


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260605/202606051117.7b999010-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


