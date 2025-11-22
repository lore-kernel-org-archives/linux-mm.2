Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B929CFC538
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 14:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAB26B000A; Sat, 22 Nov 2025 09:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B746B000C; Sat, 22 Nov 2025 09:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4323F6B000D; Sat, 22 Nov 2025 09:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2D06B000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 09:05:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E337DC0905
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:05:31 +0000 (UTC)
X-FDA: 84138415662.11.E02D772
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEDD714001A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:05:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oKVRyp4V;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763820328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+TYSaHShy2mIFDtkum4t0FoEMHws6I5LzOBEE8fQCLM=;
	b=StFWLf7LPErH0QPPEdXM/fe5lx7el8f3zIZEKKEj4Uqab0+0Y75UuLUp/N9c6UKidhh0p3
	m5p2iKsVNxQ/KWBZ2C8nPNxrcWOFN1YSC5WnxKbp6I7Mug1nSz48hCy/QMvX6nKMkmaUoc
	w5Bo7bMG9RyhOq3XTeu49FeN1c2IIEM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763820328; a=rsa-sha256;
	cv=fail;
	b=YgmGzpS1DaOVinifomA+fPQkrRGgC2Sqq7hUEyMEnsFDk4YLuFGkB1x7UbH+x8/FxuaSd+
	xOcYx9X/wkMCPp0MKOkPEArjqSkFPin6BDL+BvThZTDTXKoeZxESg5VEv7lkK5sM/jasK1
	KprNlkxdDgqn+z+mvoius7xnRqJg9BU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=oKVRyp4V;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763820328; x=1795356328;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=hdZrAFcoHFQoss8wBZMBVfZV9NO6ssPUmeVgYOwQYaM=;
  b=oKVRyp4V/iyzsOjb3OMTj/+E7MfoMYflFD+eWoHywA/SqYLXDntWLsbJ
   KGrhhTLOrGlTHYug20S5ARUaaQl1cLvQ2SkRbdlCXaxJbZapplkLqSagM
   W2JpXLvOWk7ccD3/VjUkn/OEpfJ41komPe3B6uz/xJOSKPTMYQbRMATwA
   QIrz6W4yBEh+N32Ablz1sHffp1NpyHcRMq+BnUK/TlWSv8s+rzZE9KOl5
   hktOQl7T+irxLgg5ZAzUEgf1iLxlr9oh+ntCYiF5h9MequOcJVdxh/4nK
   ANXBFQnCnT+mtK/QKg+7FKCDBRAej+6U2/p2DF3GrOvp41xDK7zHuDDBG
   Q==;
X-CSE-ConnectionGUID: 1AjQkkGVQQKj7tArBmbVkQ==
X-CSE-MsgGUID: YLgz6jFWSYO3qYn76aaMtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="64896315"
X-IronPort-AV: E=Sophos;i="6.20,218,1758610800"; 
   d="scan'208";a="64896315"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 06:05:26 -0800
X-CSE-ConnectionGUID: MaOa74G2Q9eVwsR1/F2lQQ==
X-CSE-MsgGUID: 8Qy68ypOSUStjwSxjTYCaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,218,1758610800"; 
   d="scan'208";a="215282159"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 06:05:26 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 06:05:25 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 22 Nov 2025 06:05:25 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.53) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 06:05:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s7gIySorFnajGbQo1I/IkXk85CiBwLOwyV2gg7KZxVD8iugBKx74favHHT4E9ggWE4TKG4/5HiNCmco38G145r0/kKcI3Wlb1O7gt19h2UFpbImTjctLF8x4mGc8B8qdgqsHHN7P5FMJ0U4QkSFeict2uXNXPuYHsbSfUpYmEJT0zHx8fUa7Jcj7ZzdJe7cGz3u9nv+DoaueE0ZM0KvwIVh0WyHUvH+p9jXHLGEUTY5fbI6r6kRo712Sd/9HQb47bnCR+T7FIkDvhiyT8sQRevuvF9lA+GW4exyc1YvRwakhEe2J/4pPaSIwGUJiE07kOGZBpMj/E9MGQ1LIK6iSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=accw4raYDOREhgKe6yIWrpUZZKvddybqhS2tlZ2ZDvU=;
 b=QrNkAjNcp7vLwn6iBrAjqcw3VWnYySF3HgZfeTZw4m3sF+xHCPMmPe8MkiJKSvVpyZ2T7v4mdRD0+3RkBaHmCXH3vJCtYMEep9sOrKnuNVM9r3CQpSFsMRTrd5KQWKUkqtnl86VU8rrrzFRCqnfrL7alcEdF5EHUgdQk1bQWlXcimPk+RvRGueJtiHRRUMPhWjXPraphQNnw4Wze/Gjc/0SUHnP3oqOHOVkLnCiof7c9zIl783aV7iBNrWksJ3DGYUvkQ4ZUI0Ntpdb7wRnnf9ftLA/8I+GzEPwkqURL3wnnA4Vqt5Gk69lGMrjAGsGppmJepP7eTPRXXlF7uLD6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26)
 by IA1PR11MB6219.namprd11.prod.outlook.com (2603:10b6:208:3e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 14:05:23 +0000
Received: from BY5PR11MB4165.namprd11.prod.outlook.com
 ([fe80::3876:1eb1:8e84:84e7]) by BY5PR11MB4165.namprd11.prod.outlook.com
 ([fe80::3876:1eb1:8e84:84e7%6]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 14:05:23 +0000
Date: Sat, 22 Nov 2025 22:05:15 +0800
From: kernel test robot <lkp@intel.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
CC: <oe-kbuild-all@lists.linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, Linux Memory Management List
	<linux-mm@kvack.org>, Wei Yang <richard.weiyang@gmail.com>
Subject: [linux-next:master 10747/11041]
 tools/testing/selftests/../../../tools/testing/selftests/kselftest_harness.h:56:10:
 fatal error: asm/types.h: No such file or directory
Message-ID: <aSHDG6rUzgKnVgO4@rli9-mobl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0161.apcprd04.prod.outlook.com (2603:1096:4::23)
 To BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4165:EE_|IA1PR11MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: df848ff3-c934-4018-c7ea-08de29d02daf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?7XZIrOAZfxykEJTOh/yhOSIUjGAaeJ33A/f7LATU+iV5/9CBWMt22zqoCg?=
 =?iso-8859-1?Q?IcuL0RepcX5gaUxf/OlHJup1pzVXPrWGShkZfYC8lOqTlwsxRFzpaFexv5?=
 =?iso-8859-1?Q?iBPCHVfxne0dlnk4qfBm1JpCpAYoFN96u6j/VHsSubsyOLpH4IF1uJsZva?=
 =?iso-8859-1?Q?PPYmlv1cdm/hksrB1FMppfQvdcZUWE3zZB9daDMHdKnWl0RJcRUkVq88pc?=
 =?iso-8859-1?Q?fXgGxM2nWIZCzS34MzucEENkzZnCQLvDBZV0dB14yR/fDuKVqYBJD1Ni5R?=
 =?iso-8859-1?Q?/2sCMSa6Az/kTEyU2Wj8TaHii/HkFsYivK0pmFa2gVwH/kMK5QFuSjXAfb?=
 =?iso-8859-1?Q?qeEU9hwsC5M/jE4Qc7QiyXAwrhcg4z6mHZjTdzfCm1vJlvb9JDIKI2RMSp?=
 =?iso-8859-1?Q?1ipRY4823X2caJNo2AXav9NUvmof5sA1ZcH5odqDinSkmeWLWEdaLmBIt4?=
 =?iso-8859-1?Q?GEZNf9r5xVFH7qF46WtQ0vs7FSTLOTInHGRW64Ifr+8JRwhz4K/LdUOym2?=
 =?iso-8859-1?Q?GEbDIu/bLkGhaA7V1iVUEhNHeLAegIk2z/R2Y2p1Xa6HP9zOHZqu8LSnyy?=
 =?iso-8859-1?Q?LZgwh+5XWyS9BLxXuom5vAvN0uXjyJzFQVDYYlKj/ugJwAjq8EDVYEwXVO?=
 =?iso-8859-1?Q?+dnzcCGSFGx/z4NSmc8EwjCeQrY7i3Mw78rNjqLcGijvMKaVSWlbAcWZb3?=
 =?iso-8859-1?Q?HfcYu/AkLHRTJJB52BtMV6uNPWjvs/q1GscOatVG2VlZNNCdBDUYS46qEk?=
 =?iso-8859-1?Q?tqkOz2cKHY0h7lUWE7kXv2FZxneq9VpXQZhC6Yb648hwUkhdSwApNblhpx?=
 =?iso-8859-1?Q?Lj8tH2vsAfyL2U1x4KFJcthJBsUCfsHxPFfgj4pJaZ1tlpS1SAmi2WfyiT?=
 =?iso-8859-1?Q?ABP4J3Qa87W+vjCAkdNz6nOTCHRzHortD+J8GxFSp+UhK4PAn57qHogJ0c?=
 =?iso-8859-1?Q?bLplVmLfqHC4/+8EcYMJ9OrjhaPckL7+Z5f5IlljSkNG9aPMnrSL5IYsle?=
 =?iso-8859-1?Q?sknMIMS7ntxBj8pAwnf09M38p1PXp/H8iaFPwS8nqyoPwTvNYP3msB18d8?=
 =?iso-8859-1?Q?W4T8fClgegQCBS+zOE6CwFmpzVZw2gIXNYenfRRwc8shE2BZuOG4jveVEK?=
 =?iso-8859-1?Q?MGyMfby7pERhUy1XsPU4/KYIUpDSUn7SzGR9CxZxYA/6/t69EhFiecdOfe?=
 =?iso-8859-1?Q?ODklJ4h+CvyFHy8PVMt+YnJdBL9ubhqjA3ij6Njo/8u6Uzj/g5FLUErIii?=
 =?iso-8859-1?Q?kM7yK6oIb4ne6GVyMTDBs+MtKGjwJ3FJ+kF7wOQTfmB88gy8Rp2724qrno?=
 =?iso-8859-1?Q?x64eE+wWtKsHhBAzq7m/gLE7rom2BLNMeQJqzXVpSWDV+cFASIEqzhgV6q?=
 =?iso-8859-1?Q?zTyWQBEsbxJmp5y8StJn+eWTw8DvjHYVN4Yk9t0D5tcSPcm8kNl6M1RORm?=
 =?iso-8859-1?Q?Y6QjuKVp+oH1roft9Kg/cgVouYKM4UVyszERzr9mA42o8GakHu656S/Ksf?=
 =?iso-8859-1?Q?8bxtyntWcWGRzfm08IPU86BO7aTXZTgBD3ksVCRk38Mg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4165.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?wMUck7Bjk9e6t1ix/AbK1hWfMwdYqaci88Etmg1zEggjbW9t0CZ+U39rop?=
 =?iso-8859-1?Q?s4SXTVOlin70VmM5V+MVQDi2NCqehqHUTP4brdsN1zpFwDGLHB7ns7o8Or?=
 =?iso-8859-1?Q?ZCWU4u5hjQgOdgtS8QQJaq/Xwij3pHO1fdsup/fHYKvLQ4GmAtN+FUNzjh?=
 =?iso-8859-1?Q?InQIAxXqLCh+gkkILPvx1ShF7tdeUuDwNJwo7aZNwXKvnjcLAWDEyGS/T9?=
 =?iso-8859-1?Q?05tevT+dfmbAullj+1GrBEpHFn+dG15ll4FlcbNjWLS5O3G2fKvcQfiL4B?=
 =?iso-8859-1?Q?xQGkRd21Jtwor3jVYcR+h84zQIQyOAltttHzbMxCPKnUQGMir+LCmUgfE7?=
 =?iso-8859-1?Q?fyHaSG3P58fjSYvLbwxL7NwStEUEXxPBh/5it/1eigi4tRk56qtMSyn3Tp?=
 =?iso-8859-1?Q?jvXmM/nEZLGhpsSGXW63OuzTVdZ9pmIpAWfeNv8W7MnwVPg4HkrspPrp6j?=
 =?iso-8859-1?Q?BpVx7VPkG3fYAr+k6fJVGIohys7VTAFaqX+JR+jfKGHWqMFv7WaTjaQyTB?=
 =?iso-8859-1?Q?nAMAZvn1BwBYcV0dZH74ogVBZkDOX459AjIk4FD3wJRYzo0kwmVZlDJpbd?=
 =?iso-8859-1?Q?zO46Cx16+94svz6HTQLFiT0jcXp8qbDRVR9AJfqHAfpcc6z0Y0vYNiwNF5?=
 =?iso-8859-1?Q?Ws4H57E5pbtr+5yezK1uUpQEzMqjiXzyGNKngUtJWxlTtodLvBarHHTmsn?=
 =?iso-8859-1?Q?VxEFEFahtW7I/f9aw1mtD9RYCR3OkE6xg8mayHDKG0kZT17awSy9W3OlJg?=
 =?iso-8859-1?Q?xU5NMhLeHBMiQ5b6mJubsktOYjrzg9iJZXLY6B24aO/mE4h6NY6AUMz6Yj?=
 =?iso-8859-1?Q?+6Kt+057DoRf3G90jEfhHw3XqbUTkvLo3EgoDeawRe0/+8RSVtR3gTM1KV?=
 =?iso-8859-1?Q?bSpBPcVLCumXOq3lRYi9XNcA931Pf9SLOsQOp3LOyfNbcz13Z5ZK+kQV1d?=
 =?iso-8859-1?Q?S2kBsJ+7MCeCJ0sX4qY34SyKSsd56X4yKtT0fm5QSrGtdNNFaHFBiwhK+/?=
 =?iso-8859-1?Q?UxCN1Nbh/usTi8z02KDQ9XQbo/gLizZaXLukuI5yMTdcZEqLZAShTpYfff?=
 =?iso-8859-1?Q?5u9cfnSQu1GsHJi9PewqnJn/Bs/zHEHvs4Vu4EzjNXXfTrRnlxHsloLw3J?=
 =?iso-8859-1?Q?rQLb28NtPkpttdMltDwrXBiTV5p9KiIl+H4I2JzYETw7w+XQJ/PC91FmNo?=
 =?iso-8859-1?Q?qBD1nj5XXVccuoOWZxPxruTlF6M7XIPQXKHPC8KKkx8hZxSxnnhOC6dZiz?=
 =?iso-8859-1?Q?o6A9Ko3MPzggANUi6RdKVZW9sXjQm6deYijCAbEU5B6Pz1cW51iKfAMRsq?=
 =?iso-8859-1?Q?ITzOPpO7TnUdwKj+Hpp3clHvKsuBSosP5a3BJpdXHvq3f3Y97wUjkxx03h?=
 =?iso-8859-1?Q?mq56qanNO/haP4SOcVAdHVeZBl06+YmW16YoGomifv6fDHid4tFtOgwYkg?=
 =?iso-8859-1?Q?sgSAx5eoaY1oV29XIHFXJWfIUF6MyvjmA5g/xD1bQMHGWM48BjH3usuGMX?=
 =?iso-8859-1?Q?USa3z/817FsduSPlVgcjgU1ZalYBDlWPuzaK+j5KWiKfSVSTh0P1GZ9PeU?=
 =?iso-8859-1?Q?a3/gGHf9b2j2wxyWAt5tE9/b6/4dZZxDV2z1MoO/4fYdBC0PazlHidhpv8?=
 =?iso-8859-1?Q?xQ6m4AK5cyZDtB0S+/PHJZtnKWGATe2jemRVlX4iFjnFX74jc7d3DL9g?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df848ff3-c934-4018-c7ea-08de29d02daf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4165.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 14:05:23.3243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25zLRWcBdbaZMzEwkQYb/Ro4R6IkEpL8bjbVBnSPnDgBSA7vAdJ789IRwYmpFIG0fW3Dut5IIoK0kU8bKqWS6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6219
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEDD714001A
X-Stat-Signature: jhmhtq1azkus3yje935qewbweao1gxur
X-Rspam-User: 
X-HE-Tag: 1763820327-122907
X-HE-Meta: U2FsdGVkX19u7B3+HCvFpguPAJtgCpW20FUPFOSddQPZ7PES0HBrxqwfLrFNqlpIJJcIMcQsJ6fUTPQCQxnSH/15UtEnHCtT+Z0u4fRxtdDv4XqlzuAS0NHASI7rTzUCeom7Cy7DNgzrJ1+ufQ1l6Ii2WWHfcaWxss4V7EXGOrDCFIDE588abwZeFMpEP4qp/4mqvyOoZ6AJTZDkshCEqPg6dGqV5467wAtTxEmIciY4dQ/Nk5ngHqFCNu8NEkQvvpzaNCK6aWIkmGrQZA0GOLALJdfbCxDllaym43olxzTDMhCVKKMFSTHX1Dw+KSAgv4zQxnlUCwh64HJLkgSUJalZvMKGD02xgzAVnBY0hU5ytyEu70n6iMMU1yFrFdVDg7Z7Vs1i1mGFxvgN6qpVGL86+hzrJeMrTt7VbDHnF69GgnCeCUEIPJ6XCeumcwI12i5qKwKCGkGxR1O0BylXPpmBY/Ij8Y8SqkIKbhRujxcx3xgahrkB7Qqcmqk7FJ2pW0/QMEKcWLCAumiDWFA0KsGBbjhba3lZ+c7xfsKSA0B46vVuthXXPgtvRXVpH78nbjldbCkuno8EXLGr4Er1inUkOFTAwmsVsWuh9ukKDNLzqyTYWjwSvt4cWXuf+kA4B0AtXzFqOCeiDqzIEc7KTlgnz56sslBaEqMAwV7Okzrj2E4gjuDC8KL8e+SXo3/nGZMkM9P3U6Q+FxP6vrfx1wo0QN6TuLKwDjlYcff3aYU2tR52LRFjNeB5BxhKzaWRhfGCaXMI1fMEToK2zjtGGOCNlgDAAAuRzv0VS5Y32LeuXM42T3ru6DXs3G7t4IzcNLC+C8kk17ZeeJu9KzipMIAA3hxMWa4AkaVChZ4hdh9SdW6qp4OR7RP9Jjx32eIctBnSDAA1cF+yRUvM1V9cK6lrHSQMirbdfs6bDRXg0EiFniZazJyFpf1bQDRpheE2xxsSGKLOy0kathvgh6L
 ku/YXJ4D
 v7EAflsnz7MIRpy1nOcwtQG+0yFFm4wz7XhVF/z5p+Ofojq54xW0OjZo06wBcAtI1VAOBZQ0PooGMlNmoDlE9k/xgXDlnPqK1CB2+kq5ccPyMfpzdvA9FeUS3j1u1re0UmkSKnyarebO7LfctG1KVRuWT4dXYu0dt9BlYYlkO11SYAmXKqVxdN6VB2w54S/YjSSRxMI6fooj+uwij0CSieyHyMPdXbNmsEzAjMqPnnwK9hUVw6+htgbiEDkGt5SLNwSxn6T7TlFM6jBaAxDCj0Cr9DqFioqqHDvK+aDSI0gT5Q9AdFTFFuPisZf21UhrFULgePsm/36sGNHKzFiFJSPBma330cSyX486j0pQ6RW9D0JPV+PsTeIt9STCHxdU/jMNVoq9NmVK/H9ljppDznsdHw5/208RG1zawbC9m94/hg10j+L9pzf/01nBG/MyCC4tAinj2GHHmHXqdJk1EV8sgT2mtkmYYdbHj6YzeUvJMhsmKLFaJ60B3Uu1PeYNkRVzSc0XSvGQNW2mOGOZva0UQtF7XGWQwnh2hsFZWFrTJXK0HsYNoaOGZuSVRAs2bhQUysHXxOXC4Nr2VrGXfW3/+iVMeiICq9k1rODTJCj9PvIeCfhFHwOk9H+Qoaz87sX3teu6cdy5Yh54aYfRu1xomT4YBZMJSxvqj0XBdWP8HgKmt6QXJspqu91LaTRF+TgPPovds9u3q8KrV2OuXA1ytJ//3T3R6rl/D0kAqZaf2nAFKlgQBSAzZ7Y3zUXHJRNQvFHwjPusyrLxSqyx+e6fQ0pnRGHyhbzlkKjJr9ssXCmpwZo0/tcFI8bsPLbYLZB61
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   d724c6f85e80a23ed46b7ebc6e38b527c09d64f5
commit: b5f70e33435e84a3e8302a5019612630a42dceab [10747/11041] selftests: complete kselftest include centralization
:::::: branch date: 31 hours ago
:::::: commit date: 2 days ago
config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251122/202511222145.tL2NICpQ-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511222145.tL2NICpQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202511222145.tL2NICpQ-lkp@intel.com/

Note: the linux-next/master HEAD d724c6f85e80a23ed46b7ebc6e38b527c09d64f5 builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

   In file included from proc-maps-race.c:26:
>> tools/testing/selftests/../../../tools/testing/selftests/kselftest_harness.h:56:10: fatal error: asm/types.h: No such file or directory
      56 | #include <asm/types.h>
         |          ^~~~~~~~~~~~~
   compilation terminated.
--
   In file included from get_syscall_info.c:10:
>> tools/testing/selftests/../../../tools/testing/selftests/kselftest_harness.h:57:10: fatal error: ctype.h: No such file or directory
      57 | #include <ctype.h>
         |          ^~~~~~~~~
   compilation terminated.
--
   In file included from hmm-tests.c:13:
>> tools/testing/selftests/../../../tools/testing/selftests/kselftest_harness.h:57:10: fatal error: ctype.h: No such file or directory
      57 | #include <ctype.h>
         |          ^~~~~~~~~
   compilation terminated.
   vm_util.c:2:10: fatal error: string.h: No such file or directory
       2 | #include <string.h>
         |          ^~~~~~~~~~
   compilation terminated.
   thp_settings.c:2:10: fatal error: fcntl.h: No such file or directory
       2 | #include <fcntl.h>
         |          ^~~~~~~~~
   compilation terminated.


vim +56 tools/testing/selftests/../../../tools/testing/selftests/kselftest_harness.h

c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  52  
e80068be21824e tools/testing/selftests/kselftest_harness.h    Kees Cook        2020-06-22  53  #ifndef _GNU_SOURCE
cee27ae5f1fb8b tools/testing/selftests/kselftest_harness.h    Shuah Khan       2024-05-16  54  #define _GNU_SOURCE
e80068be21824e tools/testing/selftests/kselftest_harness.h    Kees Cook        2020-06-22  55  #endif
369130b63178e0 tools/testing/selftests/kselftest_harness.h    Mickaël Salaün   2017-08-07 @56  #include <asm/types.h>
65177e47d3035c tools/testing/selftests/kselftest_harness.h    Jakub Kicinski   2023-01-25 @57  #include <ctype.h>
369130b63178e0 tools/testing/selftests/kselftest_harness.h    Mickaël Salaün   2017-08-07  58  #include <errno.h>
73a3cde9767793 tools/testing/selftests/kselftest_harness.h    Thomas Weißschuh 2025-05-05  59  #include <linux/unistd.h>
73a3cde9767793 tools/testing/selftests/kselftest_harness.h    Thomas Weißschuh 2025-05-05  60  #include <poll.h>
369130b63178e0 tools/testing/selftests/kselftest_harness.h    Mickaël Salaün   2017-08-07  61  #include <stdbool.h>
b5bb6d3068eabb tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-12-10  62  #include <stdint.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  63  #include <stdio.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  64  #include <stdlib.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  65  #include <string.h>
0ef67a888375b0 tools/testing/selftests/kselftest_harness.h    Kees Cook        2020-06-22  66  #include <sys/mman.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  67  #include <sys/types.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  68  #include <sys/wait.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  69  #include <unistd.h>
c99ee51a9d9716 tools/testing/selftests/seccomp/test_harness.h Kees Cook        2015-06-16  70  

:::::: The code at line 56 was first introduced by commit
:::::: 369130b63178e0e2f863a2da2a5ad0238ded6d9d selftests: Enhance kselftest_harness.h to print which assert failed

:::::: TO: Mickaël Salaün <mic@digikod.net>
:::::: CC: Shuah Khan <shuahkh@osg.samsung.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


