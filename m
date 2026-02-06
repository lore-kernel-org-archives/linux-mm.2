Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA7BECD98B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EA56B0098; Fri,  6 Feb 2026 05:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7533F6B0099; Fri,  6 Feb 2026 05:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A476B00A0; Fri,  6 Feb 2026 05:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC136B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:04:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 091C55B719
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:04:09 +0000 (UTC)
X-FDA: 84413596218.05.BBC615F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C697100003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:04:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cZ0yyk37;
	spf=pass (imf14.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770372245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RB/M4XENTItFycH0qNsJamnol+v0vuu0mpodGibNhNg=;
	b=Kn7GCmhLxMfb/Cx4GLchapF52iLmRQDGYQnXy1PX1FY4UaUazoSt4nGgPUCY4TvUkv2Lhd
	eIminoUvzf6UNa1RtGzja3dznjkYsKYa4+fN4gzaR9Z+vMmyz+vJcc/oykSRbzfW5xKWI6
	cZE4OMgmPtC2OL/6s+n32c/7QLhP+RQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cZ0yyk37;
	spf=pass (imf14.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770372245; a=rsa-sha256;
	cv=fail;
	b=iK9nkXbJFmwQ4c1D3ZqyXSzbOR2MvM3+yILcYPfa3I77p0yGNSjflf/JvdNqaL1hWEQ8w7
	rJ43CTLOLsL+Q9T6W2H0GNUqXmX008NOVXexFVIZAo9ffIduig1N/xEwrs5g0soJ0bxiBy
	p/pSc/HjCFEtMHbAjNtI0jihqIwNfXM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770372244; x=1801908244;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=61k9aBfvmQOVRnNf4IwahaOxLw3cXZU7zoz26keU+5g=;
  b=cZ0yyk37Ev/zPJuK74EVJslsP/zdxSppdxKigLucxZvVygPUAr11vrn1
   TMEr3ux4xZvmwZwrT99ww9hKvS0b+qdz4tzHUupfuwYW5G9phmjOj5oEN
   n/ACz2wutrMGNi+waA3850q0TkXwuzI0ltncQn3gKvGF92O/QUTEfUMbv
   e003V2g5h7EuBDs1NFgKlWhYjhJNm9j6GBG1myyhk07BK7VNzG/YiQniu
   0WC1OkDgpczoybD245ayX3iKNEThGv+nXWrXXBQY3ESx7S7OLcs9nptnE
   SW2A824ilFqjdBh+NNxhmsq4oMoJz0j5OTC1mMKZmadfNAw63uRapgpJ2
   w==;
X-CSE-ConnectionGUID: XNDjKDjtTvCraPnkaHPj6A==
X-CSE-MsgGUID: mO6Ub5KCQ5C7GNfK4SiXjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="75197343"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="75197343"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:04:02 -0800
X-CSE-ConnectionGUID: 6d66cDXFQ3qrdYofL//1zw==
X-CSE-MsgGUID: ZcsmvinrTC+EPG9qa7/Qxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="241310926"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:04:02 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:04:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 02:04:01 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.15) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:04:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2d8ILF7bHdG4u92+rzwZ6+ElxSp2LONlb6hcKqJkm7II8V3aH8TODL63TaFZTHJozN310eivJ5NXjeQQWSKoncxGJ31MFl+0g0lqxv3uIiP87ac5NldM+alytp2sUN1O4lJVHdmlYYpbecXHkwj0FDRtARBfc1Z+pRx4IOGJZQKs3zhOkcjSugtlGaJ2G4yrN4ltFSmiiDLopdsF5SDYKHUxcuAKn+eWfb4rxS6JhjJUaw7V0T41ds3crBMbMFqWDIwfAkac1IKiGqXaFTUwWju+p/H0z1x1XyMBMzfVEfW6k/3ieifHXCJBdMoWUebDdRXqFrBQvTX9KUnc5T0rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJFdSLPm5qLLGy3HIRhZfqPs2ORYNhuAkob1+mQvPb8=;
 b=VFnOBctkxLBinqsZWmmYCo7hjmvaKEwaA+hRFq4lFzTpUy3Tpr/hk7KvDkTowdewHgsofSxr4KuzeOnnCZdTsqjjBPpfiRhKRYmHIKerSxjMeJJnNUwL8nn29ZHl+hjRhDP2QrCLKE2xMtAP7QDFA5rkf6WpdMKVp8zcD8lrrYpwhvK1T6dNtPw7JH/tPU6MtnJiK7KZRIj95Out3bRDXeGoJIBRy8DxYQoFdpC+QcOll0t/al0W6EpugqmYjYwNBglouVtf1XDow81AlJyvcsBrhTwoP3mmgWDyk2zK2Kyc+J7f7ARVClRMjwW9lLwiUnfSRpUBtUDRKYP2ZbMzIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA3PR11MB9111.namprd11.prod.outlook.com (2603:10b6:208:57d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 6 Feb
 2026 10:03:57 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 10:03:57 +0000
Date: Fri, 6 Feb 2026 18:03:44 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Barry Song <v-songbaohua@oppo.com>,
	"Chris Li" <chriscli@google.com>, David Hildenbrand <david@kernel.org>, Harry
 Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, Michal Hocko
	<mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Pedro Falcato
	<pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/rmap]  bfc2b13b05:
 stress-ng.daemon.ops_per_sec 14.0% improvement
Message-ID: <202602061747.855f053f-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: KUZPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:d10:32::12) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA3PR11MB9111:EE_
X-MS-Office365-Filtering-Correlation-Id: 95da6d78-22a7-46f6-8db2-08de65670aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?bHQS3GHTLjJXLTrO7zpXeRYNS6CJ/X8lmCtNvDVLAKX1ICJ3mNTYMbeMA5?=
 =?iso-8859-1?Q?TgfxpegPmqxD4q1MsYHUXQajRvxLBu3zE+EiEJaVFHUSk1mem8PxUEsHuh?=
 =?iso-8859-1?Q?Tvx5r6hvVrNjevj1k/whuLHk9zVGd9g3wwh60gYLq9vk2loEj7GAc5/7wp?=
 =?iso-8859-1?Q?4/R/xOuB5kC18BCe40typCW7Tpdvcc+43mHT5byUk76RtDTQEwexIYiAOm?=
 =?iso-8859-1?Q?6yD8btlzrqW4PUsCycn/YR41K3oGlVWGI6ZbFAA51JMpVJGd+DThePeE4D?=
 =?iso-8859-1?Q?9OBCLeDSdTVV0vphigyQki8/gmXi6q+rxaVKiWRTwpaTDn2bK/KQgSEh0l?=
 =?iso-8859-1?Q?ECaPQYDLYklt3t8JQY6Y1koPfZsZDEoexhfC1os26JOnK/gSoo0IP3pLO4?=
 =?iso-8859-1?Q?EAduSpi6OEG1ONl88vJJ2O2lF7TygxPL6sc7c4WCPBuEfSebtrE/qNN87z?=
 =?iso-8859-1?Q?7t+kVdkJWEjqK3Q3ZskGTkvXX8x/mcWEGoeQZA3GBxQnKTNJHNs5FKA9Jm?=
 =?iso-8859-1?Q?G9v2KS90tZxCUhq5q0SvdFzSgG2tq8zDuc6v8zdTcwb5l6TiDoUmgKfvO+?=
 =?iso-8859-1?Q?Qc+VQcYDiQyxd35GhKeote15kiH7pKLyDvzU9qFxEvmNZpba0VTAEokZg0?=
 =?iso-8859-1?Q?kP9YRgn+BMasFh0n1F/Mxdxdlxzm69N+gKrAJX18B0wvRhEcKNNlt8cVNm?=
 =?iso-8859-1?Q?LNF9CCDDPrMlPBh2Forw9jQ5jnk97IfzTUH1fhx8CY7gNPnE+raO9+7S5h?=
 =?iso-8859-1?Q?XyE9TxB6mYIzwRzSwE3dPCmcr54Z1g/vIBTtseF2TzoyyhDcMoAesu4XRP?=
 =?iso-8859-1?Q?0kReRK86AFPGtHS5bJOHCY8Oxp7icY+hDf3OpHdtgjbIf1tuVGe6WQ+sFw?=
 =?iso-8859-1?Q?RrYwWZoH1HJy7w2FYlud+z+GgFcWAKiDGYisoGYS+o16QiS5/3laCNq5DJ?=
 =?iso-8859-1?Q?jBlm9+4Q3QpbfQO9YK39qudq9Thb6DHslq/yNtVpR94CpR8tdPRl193npf?=
 =?iso-8859-1?Q?tkRCg0JOnviPRmctIQK/t4VPdt3jl+UdHc6yXEWdNtkxCx7NnaEZG05OPL?=
 =?iso-8859-1?Q?8GSqTh0s0CAiJH0LvoyzJoIsKnK9cSWyxacWlW8MAGRr+zw0jIz6mSCzTv?=
 =?iso-8859-1?Q?Onxl3PrjcIU2/jqFBi7wxvhnd/3scvG1wGcbu/j9G4eFa68W2fEugvgx6l?=
 =?iso-8859-1?Q?TfEfROkA9Ce1qm2hK7ywPnzTXBy8JarW3DbezyYtYPn3eNZQJ9SXLhbRri?=
 =?iso-8859-1?Q?YlDTpj3GsICB4hQmb37cBg7gwUZ0bhwfFLDwxnUfCcJB7C323Z9cUu/i2A?=
 =?iso-8859-1?Q?SStzci5vTF9T4U0lKohId/ph4HJ1/4yJlywxqw3vhfawMzGJWOVNSiZOZa?=
 =?iso-8859-1?Q?AIQb4TwVk4MzyA1Z04zhmdFEqlx0IGyUAKZKmg5uge436Ieap8yBQhoniU?=
 =?iso-8859-1?Q?ybeEQGI6ccDtIWlPi3dhqbYVYksduVrF/rLmAgzosM+0QgOxd/s5oUTO3j?=
 =?iso-8859-1?Q?les79ObG2AByoj02DtaQTqGm3W29p4WD9mqEr3qFOFnP9pAOQFQF/SLRKK?=
 =?iso-8859-1?Q?j1iwuPQd5mTEnp+YHnAB/ceUED7zf7cS+ycI59jIljWVSyaDGCiyLPuped?=
 =?iso-8859-1?Q?eVr6WP2T6dEyAovXiLKCGagWYp5Mh7/noW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?TbPEl6prk6QmGpvVoHKnvrg52uRIx4SHVzFKJMODROJCZqKV9EmkVOmw9y?=
 =?iso-8859-1?Q?nCMIhNft/r2K6qo9jlBrXXcwwj88AbBnArvAJL9eo01E7vfoka6cPmRfjP?=
 =?iso-8859-1?Q?eHdaCPb+NPbFG0339Rpd2AQGfK8ffMpCe34Cd0tNps1AjSzvpcWo7Ijucb?=
 =?iso-8859-1?Q?LS61gOyHDsShy2Fo/hrC0hGWn8Pv7qCpsJd2VZBE0lfGnxhwFaKEUTDWL4?=
 =?iso-8859-1?Q?cGc+IrIYbOMBl+du9QanaEF19PW4TTMP5Zadi0jzPIj+6RKUlEtnTJlyzK?=
 =?iso-8859-1?Q?p2eoD40OBVs29fkHFY+WepqWaYrD/nIWrO4pq0s2pgxl+w8X3bFc0dL0uf?=
 =?iso-8859-1?Q?lIQx9BV9DtzG76Gd62BbyQ8+aa4WX7UR4VN71+xZfGHS5CbZ7OOSmSakAg?=
 =?iso-8859-1?Q?4fwlRGnH7OXZT/Bzpu1qFdsfzOUp26SUBhsHKa7ztHS/9GuamSLSypV5U9?=
 =?iso-8859-1?Q?YC0H14sYGO3EnZXllKBB4ptSML6OruGO+6MlHbtn5ZQCYLAHW0Ieoberqf?=
 =?iso-8859-1?Q?3ysuIEsbqp5HaR3mQ3iPrNFWVzBYCOL2PGO7ksBWNcgRX4wNE8Un6Bwuw/?=
 =?iso-8859-1?Q?TguX8S4zq9vhNJFw54lEMaVa6BFBn6YYUn4ir0wtoobwH8v4FUcnDu5QLK?=
 =?iso-8859-1?Q?eB8s/hSRNgCH0SSPx3DeQ8NW+yKSuKCuIcUh0fM9GqjwiU04H87Muaz1pv?=
 =?iso-8859-1?Q?9rFOpzYH8NiF5iESaaGLUjXD/0p7cQfkiTvf8tmtL+U09qrku+MIF24A1P?=
 =?iso-8859-1?Q?ibwpWUfi5ezTOQ6JU0PJyILhdBUY/Sx8uwMa4Ko6L446u3f/19MEnP2lJq?=
 =?iso-8859-1?Q?0zlX2/qn6ophDN4kF60EjoOZJVXZ2xZ0lhQojRTZCcn3mUrtK+Jq7FD6DN?=
 =?iso-8859-1?Q?aCdUGic2Hlt4m9Xox2tfEyn/z7tZGCYMevxOQBY8Uli3FkVNNkKZJvzdyt?=
 =?iso-8859-1?Q?+HCNCQ52PnxGiBh/2pcGyeCF0p+mjjsF2Zo7bL+UUOShLxPSruvf7u48rQ?=
 =?iso-8859-1?Q?MbQDsXpn8b2d9yaWeiGuo3D/Z7mMzVj9dG0VimFB2XO2EQ9hiTWP3p4292?=
 =?iso-8859-1?Q?nm+VNcAiv/9sTPwfGYYS2QsZ+n3c55rn8mwqRc/OkeFzSz7NBLcrjNqTOs?=
 =?iso-8859-1?Q?QPotSjBjb3KDt11m/35cWMdvd2u2kO0K1Tr8GTFyc4AbAQnnvuFK+gFDhj?=
 =?iso-8859-1?Q?MChONweRNdfyThJoCmGO3m0z+0Br2mSWAvqrdgHw7HE1bFWFVb/GDmzcMm?=
 =?iso-8859-1?Q?Ra6r3sX2+IjVfDqBSgUfmlQsC2Gpi+FeDbWmpL0cK9qeaoyyZiFxpTpLwp?=
 =?iso-8859-1?Q?5AWWDNafMLTltiM4FQJ6ljPgxVLRq3JPzbiqYLEFMfekLYmGPKjq4zwOXv?=
 =?iso-8859-1?Q?eXxkHihgD2teVluAl+jsNRdHLlc42fKuMDpHS0aADrTXRwat7KIBhfsMpy?=
 =?iso-8859-1?Q?87h+v8JS5PugTHnnur0hNZaBmFoxSK1ClsdjRZElTdTTVfDdKBP1IhBFo5?=
 =?iso-8859-1?Q?qblsPFS+kzXLrH9Y4ppYIAzzEgl9UDXZvrm/hVaOh+WzfmfgdbXUTMBri4?=
 =?iso-8859-1?Q?4ye8jMQb2XgdA9+m6ada5QOrr+QNcuryI1klH+FNZU7RSJJbk7Xa6Fkd5H?=
 =?iso-8859-1?Q?50fGYcXNYMkibrg4NnQY8b3a17isDt06TZceDGzfOiBBZsnhk6h3bH+t8K?=
 =?iso-8859-1?Q?9DsMaex4u+A4pqZtaYZ96OmpfMBaXIFbbdw5r/SE1Gfg+NBrnY2SB6ACZi?=
 =?iso-8859-1?Q?m5G63AJfVzodocX/JNzEGPiHGfcM+RkefHFBgJK1/WEw1qPCYtJBYXI53m?=
 =?iso-8859-1?Q?d+7xIsJJtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95da6d78-22a7-46f6-8db2-08de65670aaf
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:03:57.2976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IBhZSaWSx7I8VMqJtXhbFEEQ/vO2q3w30BDK0KHwjy225vlcJ9MruWoQz+ltwt+CnWSGiqB2vzWIifFZHCn9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9111
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C697100003
X-Rspamd-Server: rspam07
X-Stat-Signature: 8s1nkkma887gj66xp11udy4xpcom3oix
X-HE-Tag: 1770372244-358584
X-HE-Meta: U2FsdGVkX1+C8bCUhk09v2jv4NXpvcNpea0J7GQDYl7II+XrX8aTMJZkhrVTyUXBsf5hywY83eqhmkgiqJ5jgrqVz3GvRRAQ3DzR9yEVxdI9pJsf2uxQaYYgIbicB9lTrMoV37e0h3fPogF3eVFQvedCcyfacrUZJoyrPSicusHDxyeIVdrUoiVqih2ijd51IryPIHG4+PUS6BuWhIUblnPpGCvIqAhJx+sIWGqmWXTP9dnLs2DFcJyePKZjMZAGEJNzkkCwHn7+XLNVKcWcvubverw0O36aCEtTb4NIJjo3Abg+7B66gdmWmnbiez7c86/kmS4SYMQy7tsUVYMSLpzWbOFcGyaCykaZnOQdxMjGsAoeCaTzWdMLXogvoAjWgqz7RI4kPPB3dz1q3irP7O772cxQOzpF6yIKPhApyaAIKebOCmTYjTJf2FgXy47YrDubgRQeV2t4O2tX8XKlz15OnL6/BefD6huWrpyMEKgymnSvGq3bdS/+TtP4rt+0/M41kko5YlPbATeEpCPy3cPxrxwCuMSVL9PXSnJN7xxz92YtnSFFdTilm/kxSvjFKy37hw9+SY/RBdrYjGcRbEBHvx7Y1SF70Iox5AH+DBx68cdNveQ/AdoXfhpyLFJY3QK6O0wfjIj97ASmqGr8XbTaR6i9WrD85G0ojiiGXXw+Heovl+06wbTbRQFJq2HzyZW7/ODBGQijDLJDnR4L2vteFEPfjVsqgyFBmMea/HVzhwsqpAi17OXKTdA9677ZFtak8c2c72RxiG483BF/5wqNkKXG0uGcffjCPqNS2Zh/nK02XORAg3gWGCSnYwnTMbSrmhISjG0A3qcix/4A4YgByE47JQTAMcsHfOj5QIuqBIRn6mNESyQOm//MxnMwUGRo39aCekJuwuqi1rEM4n9ww/hST7HAxS2XISkhYHUoirH//T3DT8hkCypFupL2JTchJ8dODAqL8HybJRm
 Tlutgh4K
 Xiyd0k8qZwZvA8Nwl6dZTNPXW1lxAAaO67WoDbt7DzBcmUdi2k82zAKXwX/BAQ5YSR7C1A7rLqm3aVm697hU9WEmjZpHBPM5zJYzDqzUWdVAUjHy5bEwVHXTCp3EpL5aSPsom+mFOdAAorwAvsvdeTNqVnybOoL6WSZLF3DMkETacYIWAsiZ/apzqk/CG5lTFwbprNTr+MYclkNX9IxfgLdJBiczaVlCm4d8GZUP8YDk+BSNHEZIS2FDP+SihRKAAgJ+qUz4UcNutZOvSNbkjiuM2j8kEmrYy/HasGzOVOLXhY5ONas+2+qYhchlQFP0qLZcLDhdJnlFK9VS+X2S9kpz5V/aRlPUD4oZqe3pg/nEphRpXFBBFOBTilRKe2WXOux9T0pKsjiQX3XA4WidMCttTUMujxra3uPq8iqzKta60GotfmBqZcwpCZpF8lFd0ZZqmlxBSmCYzmPBZkix/s1+FopMpITYKG1lFDYp+c8FD4MYFzkcfduPPuP6WDd/RuSCVTy+JL81VgzZvcTsZdJKBm0O3JrxWgHiWnI7m41SW9a/cKWzUJdrYRy2TF06jq4S0RtU4OGRi+r3aJtO6qJmqgzQWUjDJma1BLUqcPEThJz7BQRXBygLgA8f0sWebAhM+wp3kkbr2y10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 14.0% improvement of stress-ng.daemon.ops_per_sec on:


commit: bfc2b13b05a1343bb60a85d840fd8956731866c5 ("mm/rmap: allocate anon_vma_chain objects unlocked when possible")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: daemon
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+----------------------------------------------------------------------------------------------+
| testcase: change | stress-ng: stress-ng.netlink-proc.ops_per_sec 25.7% improvement                              |
| test machine     | 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory  |
| test parameters  | cpufreq_governor=performance                                                                 |
|                  | nr_threads=100%                                                                              |
|                  | test=netlink-proc                                                                            |
|                  | testtime=60s                                                                                 |
+------------------+----------------------------------------------------------------------------------------------+


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260206/202602061747.855f053f-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-emr-2sp1/daemon/stress-ng/60s

commit: 
  85f03a8631 ("mm/mmap_lock: add vma_is_attached() helper")
  bfc2b13b05 ("mm/rmap: allocate anon_vma_chain objects unlocked when possible")

85f03a86318c4172 bfc2b13b05a1343bb60a85d840f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      8054 ± 16%     +54.6%      12455 ± 16%  perf-c2c.DRAM.local
      0.13 ±  8%     +10.4%       0.15 ±  3%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.13 ±  8%     +10.4%       0.15 ±  3%  perf-sched.total_sch_delay.average.ms
     38.55            +6.0       44.57 ±  3%  mpstat.cpu.all.idle%
      0.47            -0.0        0.42 ±  2%  mpstat.cpu.all.irq%
     59.36            -6.1       53.28 ±  2%  mpstat.cpu.all.sys%
      1.21            +0.1        1.30        mpstat.cpu.all.usr%
   2817245           +14.1%    3214286 ±  2%  stress-ng.daemon.ops
     47149           +14.0%      53750 ±  2%  stress-ng.daemon.ops_per_sec
     49.50 ±  3%     +18.2%      58.50 ±  2%  stress-ng.time.percent_of_cpu_this_job_got
   2759543           +13.2%    3123624 ±  2%  stress-ng.time.voluntary_context_switches
      0.15 ± 46%      -0.1        0.05 ± 41%  turbostat.C1%
      3.58 ±  5%      +9.0%       3.90 ±  3%  turbostat.CPU%c1
    647.37            +1.9%     659.97        turbostat.PkgWatt
     28.80 ±  2%      +7.1%      30.83        turbostat.RAMWatt
     25720            +7.4%      27633 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.avg
     25656            +7.6%      27595 ±  2%  sched_debug.cfs_rq:/.zero_vruntime.avg
      2214 ±  3%     +51.1%       3345 ±  6%  sched_debug.cpu.clock.stddev
      2726 ±  2%     +40.8%       3838 ±  5%  sched_debug.cpu.clock_task.stddev
   1420062           +14.0%    1619139 ±  2%  sched_debug.cpu.curr->pid.max
      0.00 ±  3%     +51.0%       0.00 ±  6%  sched_debug.cpu.next_balance.stddev
    182592            +3.7%     189367        meminfo.KReclaimable
    260530 ±  2%      -8.3%     238883        meminfo.Mapped
  18519139           +18.4%   21919824 ±  3%  meminfo.Memused
    310935 ±  4%      +9.2%     339441 ±  2%  meminfo.PageTables
    182592            +3.7%     189367        meminfo.SReclaimable
   6259412 ±  3%     +52.7%    9561140 ±  6%  meminfo.SUnreclaim
   6442004 ±  3%     +51.4%    9750508 ±  6%  meminfo.Slab
  18519311           +18.4%   21919824 ±  3%  meminfo.max_used_kB
  25317761 ±  4%     +14.8%   29072594 ±  3%  numa-numastat.node0.local_node
  25429773 ±  4%     +14.8%   29188651 ±  3%  numa-numastat.node0.numa_hit
  25578903 ±  4%     +15.2%   29473906 ±  3%  numa-numastat.node1.local_node
  25681455 ±  4%     +15.2%   29588761 ±  3%  numa-numastat.node1.numa_hit
  25472065 ±  4%     +19.2%   30373362 ±  2%  numa-numastat.node2.local_node
  25579152 ±  4%     +19.1%   30461365 ±  2%  numa-numastat.node2.numa_hit
  25502240 ±  4%     +18.2%   30147059 ±  2%  numa-numastat.node3.local_node
  25588119 ±  4%     +18.2%   30236863 ±  2%  numa-numastat.node3.numa_hit
    208008            +2.0%     212227        proc-vmstat.nr_anon_pages
   6090914            -1.4%    6006008        proc-vmstat.nr_dirty_background_threshold
  12196722            -1.4%   12026702        proc-vmstat.nr_dirty_threshold
  61229635            -1.4%   60379327        proc-vmstat.nr_free_pages
  61094372            -1.4%   60257849        proc-vmstat.nr_free_pages_blocks
     65170 ±  2%      -8.3%      59741        proc-vmstat.nr_mapped
     77887 ±  4%      +9.1%      85010 ±  3%  proc-vmstat.nr_page_table_pages
     45655            +3.7%      47350        proc-vmstat.nr_slab_reclaimable
   1565161 ±  3%     +52.8%    2390881 ±  6%  proc-vmstat.nr_slab_unreclaimable
 1.023e+08 ±  4%     +16.8%  1.195e+08 ±  2%  proc-vmstat.numa_hit
 1.019e+08 ±  4%     +16.9%  1.191e+08 ±  2%  proc-vmstat.numa_local
 1.109e+08 ±  3%     +17.3%  1.301e+08 ±  2%  proc-vmstat.pgalloc_normal
 1.748e+08 ±  3%     +15.3%  2.015e+08 ±  4%  proc-vmstat.pgfault
 1.064e+08 ±  3%     +16.2%  1.236e+08 ±  2%  proc-vmstat.pgfree
   4897546 ± 28%     +25.4%    6140878 ± 25%  numa-meminfo.node0.MemUsed
     74758 ±  7%     +15.2%      86146 ±  7%  numa-meminfo.node0.PageTables
   1585565 ±  3%     +49.9%    2376337 ±  6%  numa-meminfo.node0.SUnreclaim
   1644278 ±  3%     +48.5%    2442550 ±  5%  numa-meminfo.node0.Slab
    612346 ± 43%     -69.9%     184504 ± 45%  numa-meminfo.node1.Active
    612342 ± 43%     -69.9%     184500 ± 45%  numa-meminfo.node1.Active(anon)
   1674209 ± 85%     -78.1%     366914 ± 42%  numa-meminfo.node1.FilePages
     75408 ±  5%     +15.6%      87173 ±  6%  numa-meminfo.node1.PageTables
   1573523 ±  4%     +52.0%    2391230 ±  7%  numa-meminfo.node1.SUnreclaim
    465316 ± 27%     -72.7%     127017 ± 75%  numa-meminfo.node1.Shmem
   1626985 ±  4%     +49.0%    2424297 ±  7%  numa-meminfo.node1.Slab
   4023313 ± 31%     +58.4%    6371888 ± 27%  numa-meminfo.node2.MemUsed
   1571082 ±  3%     +55.3%    2440472 ±  5%  numa-meminfo.node2.SUnreclaim
   1604428 ±  3%     +55.3%    2492401 ±  6%  numa-meminfo.node2.Slab
   1548894 ±  4%     +54.2%    2388081 ±  6%  numa-meminfo.node3.SUnreclaim
   1586066 ±  4%     +53.0%    2427265 ±  6%  numa-meminfo.node3.Slab
     18610 ±  6%     +16.4%      21662 ±  7%  numa-vmstat.node0.nr_page_table_pages
    396573 ±  3%     +49.9%     594571 ±  6%  numa-vmstat.node0.nr_slab_unreclaimable
  25430185 ±  4%     +14.8%   29188938 ±  3%  numa-vmstat.node0.numa_hit
  25318163 ±  4%     +14.8%   29072880 ±  3%  numa-vmstat.node0.numa_local
    153177 ± 43%     -69.8%      46194 ± 45%  numa-vmstat.node1.nr_active_anon
    418628 ± 85%     -78.1%      91778 ± 42%  numa-vmstat.node1.nr_file_pages
     18770 ±  5%     +16.7%      21911 ±  7%  numa-vmstat.node1.nr_page_table_pages
    116405 ± 28%     -72.7%      31803 ± 75%  numa-vmstat.node1.nr_shmem
    393591 ±  4%     +52.0%     598339 ±  7%  numa-vmstat.node1.nr_slab_unreclaimable
    153176 ± 43%     -69.8%      46192 ± 45%  numa-vmstat.node1.nr_zone_active_anon
  25681692 ±  4%     +15.2%   29589055 ±  3%  numa-vmstat.node1.numa_hit
  25579141 ±  4%     +15.2%   29474199 ±  3%  numa-vmstat.node1.numa_local
    392991 ±  3%     +55.4%     610669 ±  5%  numa-vmstat.node2.nr_slab_unreclaimable
  25579351 ±  4%     +19.1%   30461531 ±  2%  numa-vmstat.node2.numa_hit
  25472265 ±  4%     +19.2%   30373528 ±  2%  numa-vmstat.node2.numa_local
    387461 ±  4%     +54.2%     597608 ±  6%  numa-vmstat.node3.nr_slab_unreclaimable
  25588424 ±  4%     +18.2%   30237199 ±  2%  numa-vmstat.node3.numa_hit
  25502545 ±  4%     +18.2%   30147394 ±  2%  numa-vmstat.node3.numa_local
      5.21 ±  3%     +11.9%       5.83 ±  2%  perf-stat.i.MPKI
      0.47 ±  2%      +0.1        0.55 ±  3%  perf-stat.i.branch-miss-rate%
 1.854e+08           +18.3%  2.194e+08 ±  4%  perf-stat.i.branch-misses
 1.039e+09 ±  2%     +15.1%  1.196e+09 ±  3%  perf-stat.i.cache-misses
 1.747e+09 ±  2%     +15.0%  2.008e+09 ±  3%  perf-stat.i.cache-references
      2.90            -1.9%       2.85        perf-stat.i.cpi
     67064 ±  3%     +10.5%      74100 ±  4%  perf-stat.i.cpu-migrations
    557.14 ±  3%     -12.3%     488.69 ±  3%  perf-stat.i.cycles-between-cache-misses
 1.994e+11            +2.9%  2.051e+11        perf-stat.i.instructions
      0.34            +1.9%       0.35        perf-stat.i.ipc
    252.47 ± 31%    +100.4%     505.88 ± 16%  perf-stat.i.major-faults
     24.13 ±  2%     +14.2%      27.55 ±  4%  perf-stat.i.metric.K/sec
   2906494 ±  3%     +15.6%    3358742 ±  3%  perf-stat.i.minor-faults
   2906746 ±  3%     +15.6%    3359248 ±  3%  perf-stat.i.page-faults
      5.21 ±  3%     +11.9%       5.83 ±  2%  perf-stat.overall.MPKI
      0.47 ±  2%      +0.1        0.55 ±  3%  perf-stat.overall.branch-miss-rate%
      2.90            -1.9%       2.85        perf-stat.overall.cpi
    557.08 ±  3%     -12.3%     488.29 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.34            +1.9%       0.35        perf-stat.overall.ipc
 1.808e+08           +18.6%  2.144e+08 ±  4%  perf-stat.ps.branch-misses
 1.015e+09 ±  2%     +15.4%  1.171e+09 ±  3%  perf-stat.ps.cache-misses
 1.706e+09           +15.2%  1.966e+09 ±  3%  perf-stat.ps.cache-references
     65460 ±  3%     +10.8%      72507 ±  4%  perf-stat.ps.cpu-migrations
 1.947e+11            +3.1%  2.008e+11        perf-stat.ps.instructions
    246.17 ± 31%    +100.9%     494.53 ± 16%  perf-stat.ps.major-faults
   2838136 ±  3%     +15.8%    3287669 ±  3%  perf-stat.ps.minor-faults
   2838383 ±  3%     +15.8%    3288164 ±  3%  perf-stat.ps.page-faults
 1.169e+13            +2.8%  1.201e+13        perf-stat.total.instructions
     35.08            -3.1       31.96 ±  2%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.unlink_anon_vmas.free_pgtables.exit_mmap
     35.27            -3.1       32.16 ±  2%  perf-profile.calltrace.cycles-pp.down_write.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
     39.70            -2.3       37.35        perf-profile.calltrace.cycles-pp.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput.exit_mm
     39.54            -2.3       37.20        perf-profile.calltrace.cycles-pp.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm.copy_process
     40.13            -2.2       37.91        perf-profile.calltrace.cycles-pp.anon_vma_fork.dup_mmap.dup_mm.copy_process.kernel_clone
     40.88            -2.2       38.70        perf-profile.calltrace.cycles-pp.free_pgtables.exit_mmap.__mmput.exit_mm.do_exit
     31.32 ±  2%      -2.2       29.16 ±  3%  perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write.unlink_anon_vmas.free_pgtables
     33.10            -2.1       31.01 ±  2%  perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.anon_vma_clone.anon_vma_fork.dup_mmap
     33.39            -2.1       31.31 ±  2%  perf-profile.calltrace.cycles-pp.down_write.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
     44.86            -1.4       43.49        perf-profile.calltrace.cycles-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
     45.45            -1.3       44.18        perf-profile.calltrace.cycles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
     45.91            -1.2       44.70        perf-profile.calltrace.cycles-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     46.43            -1.1       45.30        perf-profile.calltrace.cycles-pp.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     46.43            -1.1       45.30        perf-profile.calltrace.cycles-pp.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     94.97            -1.0       93.97        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     94.97            -1.0       93.98        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      3.30 ±  6%      -0.9        2.38 ±  8%  perf-profile.calltrace.cycles-pp.rwsem_spin_on_owner.rwsem_down_write_slowpath.down_write.unlink_anon_vmas.free_pgtables
      3.36 ±  2%      -0.7        2.66 ±  4%  perf-profile.calltrace.cycles-pp.anon_vma_interval_tree_insert.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
      2.67 ±  7%      -0.7        1.98 ±  9%  perf-profile.calltrace.cycles-pp.rwsem_spin_on_owner.rwsem_down_write_slowpath.down_write.anon_vma_clone.anon_vma_fork
      0.60            +0.1        0.68        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_dup.dup_mmap.dup_mm.copy_process
      0.65            +0.1        0.74 ±  3%  perf-profile.calltrace.cycles-pp.__vma_start_write.free_pgtables.exit_mmap.__mmput.exit_mm
      0.64            +0.1        0.74        perf-profile.calltrace.cycles-pp.vm_area_dup.dup_mmap.dup_mm.copy_process.kernel_clone
      0.77 ±  2%      +0.1        0.87 ±  3%  perf-profile.calltrace.cycles-pp.__vma_start_write.dup_mmap.dup_mm.copy_process.kernel_clone
      0.58 ±  5%      +0.1        0.68 ±  5%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.unlink_anon_vmas.free_pgtables.exit_mmap
      0.43 ± 44%      +0.2        0.61 ±  3%  perf-profile.calltrace.cycles-pp.mm_init.dup_mm.copy_process.kernel_clone.__do_sys_clone
      1.05 ±  5%      +0.2        1.26 ±  7%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
      1.23 ±  4%      +0.2        1.46 ±  5%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free.unlink_anon_vmas.free_pgtables.exit_mmap
      0.34 ± 70%      +0.2        0.58 ±  2%  perf-profile.calltrace.cycles-pp.wake_up_new_task.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.39 ±  3%      +0.2        1.63 ±  5%  perf-profile.calltrace.cycles-pp.__anon_vma_interval_tree_remove.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
      1.02 ±  9%      +0.2        1.27 ±  5%  perf-profile.calltrace.cycles-pp.copy_present_ptes.copy_pte_range.copy_p4d_range.copy_page_range.dup_mmap
      1.42 ±  6%      +0.3        1.74 ±  4%  perf-profile.calltrace.cycles-pp.copy_pte_range.copy_p4d_range.copy_page_range.dup_mmap.dup_mm
      1.59 ±  5%      +0.3        1.93 ±  4%  perf-profile.calltrace.cycles-pp.copy_p4d_range.copy_page_range.dup_mmap.dup_mm.copy_process
      1.62 ±  4%      +0.4        1.97 ±  3%  perf-profile.calltrace.cycles-pp.copy_page_range.dup_mmap.dup_mm.copy_process.kernel_clone
      0.18 ±141%      +0.4        0.56 ±  6%  perf-profile.calltrace.cycles-pp.up_write.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
      2.04 ±  4%      +0.4        2.43 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
      1.08 ± 12%      +0.5        1.54 ±  9%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap
      1.09 ± 13%      +0.5        1.58 ±  7%  perf-profile.calltrace.cycles-pp.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range
      0.08 ±223%      +0.5        0.57 ±  4%  perf-profile.calltrace.cycles-pp.up_write.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.kmem_cache_free.exit_mmap.__mmput.exit_mm.do_exit
      1.24 ±  3%      +0.6        1.79 ±  8%  perf-profile.calltrace.cycles-pp.next_uptodate_folio.filemap_map_pages.do_read_fault.do_fault.__handle_mm_fault
      1.45 ± 10%      +0.6        2.03 ±  8%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput
      1.46 ± 10%      +0.6        2.05 ±  7%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput.exit_mm
      1.48 ± 10%      +0.6        2.07 ±  8%  perf-profile.calltrace.cycles-pp.tlb_finish_mmu.exit_mmap.__mmput.exit_mm.do_exit
      0.08 ±223%      +0.6        0.71 ±  8%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      0.08 ±223%      +0.6        0.71 ±  8%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range
      0.08 ±223%      +0.6        0.71 ±  8%  perf-profile.calltrace.cycles-pp.tlb_flush_mmu.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
      1.85 ±  3%      +0.7        2.58 ±  7%  perf-profile.calltrace.cycles-pp.filemap_map_pages.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault
      1.94 ±  3%      +0.8        2.70 ±  7%  perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      1.93 ±  3%      +0.8        2.69 ±  7%  perf-profile.calltrace.cycles-pp.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      2.27 ±  3%      +0.8        3.08 ±  6%  perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2.34 ±  3%      +0.8        3.16 ±  6%  perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2.68 ±  3%      +0.9        3.57 ±  6%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
      2.66 ±  3%      +0.9        3.56 ±  6%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2.88 ±  3%      +0.9        3.80 ±  6%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault
      2.56 ±  7%      +1.0        3.51 ±  5%  perf-profile.calltrace.cycles-pp.zap_present_ptes.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas
      3.40 ±  6%      +1.3        4.72 ±  5%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap
      3.45 ±  6%      +1.3        4.78 ±  5%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.exit_mmap.__mmput
      3.50 ±  6%      +1.3        4.85 ±  5%  perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.exit_mmap.__mmput.exit_mm
      3.63 ±  6%      +1.4        4.98 ±  5%  perf-profile.calltrace.cycles-pp.unmap_vmas.exit_mmap.__mmput.exit_mm.do_exit
     68.28            -5.1       63.15 ±  2%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
     68.93            -5.1       63.84 ±  2%  perf-profile.children.cycles-pp.down_write
     61.34 ±  2%      -3.5       57.82 ±  3%  perf-profile.children.cycles-pp.osq_lock
     39.70            -2.3       37.37        perf-profile.children.cycles-pp.unlink_anon_vmas
     39.56            -2.3       37.23        perf-profile.children.cycles-pp.anon_vma_clone
     40.14            -2.2       37.92        perf-profile.children.cycles-pp.anon_vma_fork
     40.88            -2.2       38.71        perf-profile.children.cycles-pp.free_pgtables
      6.01 ±  6%      -1.6        4.41 ±  9%  perf-profile.children.cycles-pp.rwsem_spin_on_owner
     44.93            -1.4       43.56        perf-profile.children.cycles-pp.dup_mmap
     45.45            -1.3       44.18        perf-profile.children.cycles-pp.dup_mm
     45.91            -1.2       44.70        perf-profile.children.cycles-pp.copy_process
     46.43            -1.1       45.30        perf-profile.children.cycles-pp.__do_sys_clone
     46.43            -1.1       45.30        perf-profile.children.cycles-pp.kernel_clone
     95.09            -1.0       94.09        perf-profile.children.cycles-pp.do_syscall_64
     95.09            -1.0       94.09        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      3.37 ±  2%      -0.7        2.67 ±  4%  perf-profile.children.cycles-pp.anon_vma_interval_tree_insert
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.autoremove_wake_function
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.lru_add_drain_cpu
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.mas_dup_alloc
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.sched_move_task
      0.07            +0.0        0.08        perf-profile.children.cycles-pp.process_one_work
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.__wake_up_common
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.delayed_vfree_work
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.vfree
      0.10            +0.0        0.11 ±  3%  perf-profile.children.cycles-pp.__mt_dup
      0.07            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.anon_pipe_write
      0.05            +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.folio_batch_move_lru
      0.05            +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.lru_add_drain
      0.06            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.__wake_up_sync_key
      0.08            +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.__wp_page_copy_user
      0.08            +0.0        0.09 ±  5%  perf-profile.children.cycles-pp.__put_user_4
      0.07 ±  9%      +0.0        0.08 ±  5%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.08 ±  5%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp.vm_normal_page
      0.11 ±  4%      +0.0        0.12 ±  3%  perf-profile.children.cycles-pp.vfs_write
      0.15 ±  2%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.vma_mark_detached
      0.08 ±  6%      +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.do_wp_page
      0.09 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.kernel_init_pages
      0.12 ±  3%      +0.0        0.14 ±  2%  perf-profile.children.cycles-pp.worker_thread
      0.08 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.__vmalloc_node_noprof
      0.08 ±  5%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.__vmalloc_node_range_noprof
      0.12            +0.0        0.14 ±  3%  perf-profile.children.cycles-pp.acct_collect
      0.12 ±  4%      +0.0        0.13 ±  2%  perf-profile.children.cycles-pp.ksys_write
      0.05 ± 13%      +0.0        0.07 ± 14%  perf-profile.children.cycles-pp.__pmd_alloc
      0.10 ±  3%      +0.0        0.12 ±  5%  perf-profile.children.cycles-pp.rb_next
      0.17 ±  4%      +0.0        0.19 ±  2%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.11 ±  6%      +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.09 ±  7%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.prep_new_page
      0.10 ±  4%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.rmqueue
      0.16 ±  2%      +0.0        0.18 ±  3%  perf-profile.children.cycles-pp.kthread
      0.08 ±  4%      +0.0        0.10 ±  4%  perf-profile.children.cycles-pp._copy_from_user
      0.23 ±  5%      +0.0        0.26 ±  2%  perf-profile.children.cycles-pp.sched_balance_rq
      0.17 ±  2%      +0.0        0.20 ±  3%  perf-profile.children.cycles-pp.sync_regs
      0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.__x64_sys_rt_sigprocmask
      0.12 ±  6%      +0.0        0.14 ±  4%  perf-profile.children.cycles-pp.__memcg_kmem_charge_page
      0.21            +0.0        0.24 ±  3%  perf-profile.children.cycles-pp.mas_next_slot
      0.09 ±  4%      +0.0        0.12 ±  5%  perf-profile.children.cycles-pp.__put_anon_vma
      0.26            +0.0        0.28 ±  2%  perf-profile.children.cycles-pp.mas_find
      0.16 ±  6%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.16 ±  2%      +0.0        0.20 ±  2%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.18 ±  7%      +0.0        0.22 ±  2%  perf-profile.children.cycles-pp.tlb_remove_table_rcu
      0.23            +0.0        0.26 ±  2%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.11 ±  6%      +0.0        0.14 ± 10%  perf-profile.children.cycles-pp.__put_partials
      0.24 ±  2%      +0.0        0.27 ±  3%  perf-profile.children.cycles-pp.__pi_memset
      0.22 ±  5%      +0.0        0.25 ±  2%  perf-profile.children.cycles-pp.wp_page_copy
      0.16 ±  3%      +0.0        0.20 ±  3%  perf-profile.children.cycles-pp.remove_vma
      0.14 ±  3%      +0.0        0.18 ±  5%  perf-profile.children.cycles-pp.fput
      0.09 ±  4%      +0.0        0.13 ±  7%  perf-profile.children.cycles-pp.getname_flags
      0.20 ±  6%      +0.0        0.24        perf-profile.children.cycles-pp.pte_alloc_one
      0.09 ±  4%      +0.0        0.13 ±  7%  perf-profile.children.cycles-pp.strncpy_from_user
      0.20 ±  4%      +0.0        0.24 ±  3%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.10 ±  4%      +0.0        0.13 ±  7%  perf-profile.children.cycles-pp.user_path_at
      0.10 ±  3%      +0.0        0.14 ±  7%  perf-profile.children.cycles-pp.__x64_sys_chdir
      0.22 ±  3%      +0.0        0.26 ±  3%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.29            +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.__percpu_counter_sum
      0.36 ±  2%      +0.0        0.40 ±  2%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.33 ±  3%      +0.0        0.37 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
      0.35 ±  2%      +0.0        0.40        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.18 ±  2%      +0.0        0.22 ±  4%  perf-profile.children.cycles-pp.do_task_dead
      0.24 ±  3%      +0.0        0.29 ±  2%  perf-profile.children.cycles-pp.schedule_tail
      1.28            +0.0        1.32        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.37            +0.0        0.41 ±  3%  perf-profile.children.cycles-pp.update_sg_wakeup_stats
      0.25 ±  2%      +0.0        0.30 ±  3%  perf-profile.children.cycles-pp.__percpu_counter_init_many
      0.18 ±  6%      +0.0        0.24 ±  8%  perf-profile.children.cycles-pp.get_partial_node
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.vm_area_init_from
      1.32            +0.1        1.37        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.40 ±  3%      +0.1        0.45 ±  3%  perf-profile.children.cycles-pp.rcu_core
      0.38 ±  3%      +0.1        0.43 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
      0.44            +0.1        0.50 ±  2%  perf-profile.children.cycles-pp.mas_store
      0.30 ±  3%      +0.1        0.35        perf-profile.children.cycles-pp.vfs_read
      0.25 ±  3%      +0.1        0.30 ±  2%  perf-profile.children.cycles-pp.anon_pipe_read
      0.33            +0.1        0.38        perf-profile.children.cycles-pp.finish_task_switch
      0.30 ±  2%      +0.1        0.36        perf-profile.children.cycles-pp.ksys_read
      0.38 ±  2%      +0.1        0.43 ±  3%  perf-profile.children.cycles-pp.sched_balance_find_dst_group
      0.36 ±  2%      +0.1        0.42 ±  2%  perf-profile.children.cycles-pp.__mmdrop
      0.37 ±  3%      +0.1        0.42 ±  2%  perf-profile.children.cycles-pp.refill_obj_stock
      0.57 ±  2%      +0.1        0.63 ±  2%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.36            +0.1        0.42 ±  4%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.44 ±  3%      +0.1        0.50 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
      0.32 ±  5%      +0.1        0.38 ±  2%  perf-profile.children.cycles-pp.alloc_pages_noprof
      0.60 ±  3%      +0.1        0.66 ±  3%  perf-profile.children.cycles-pp.handle_softirqs
      0.48            +0.1        0.54 ±  3%  perf-profile.children.cycles-pp.select_task_rq_fair
      0.41 ±  5%      +0.1        0.48 ±  4%  perf-profile.children.cycles-pp.__rb_insert_augmented
      0.38 ±  2%      +0.1        0.44 ±  3%  perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      0.34 ±  5%      +0.1        0.41 ±  2%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.33 ±  5%      +0.1        0.40 ±  2%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.42            +0.1        0.49 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      0.42            +0.1        0.49 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.50            +0.1        0.58 ±  2%  perf-profile.children.cycles-pp.wake_up_new_task
      0.34 ±  8%      +0.1        0.42 ±  8%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.20 ±  3%      +0.1        0.28 ±  6%  perf-profile.children.cycles-pp.folio_add_file_rmap_ptes
      0.35 ±  5%      +0.1        0.42 ±  9%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      0.46 ±  2%      +0.1        0.55 ±  3%  perf-profile.children.cycles-pp.pcpu_alloc_noprof
      0.31 ±  3%      +0.1        0.40 ±  5%  perf-profile.children.cycles-pp.set_pte_range
      0.65            +0.1        0.74        perf-profile.children.cycles-pp.vm_area_dup
      0.74 ±  2%      +0.1        0.84 ±  3%  perf-profile.children.cycles-pp.__vma_enter_locked
      0.51 ±  2%      +0.1        0.61 ±  3%  perf-profile.children.cycles-pp.mm_init
      0.97 ±  4%      +0.2        1.14 ±  3%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      1.43 ±  2%      +0.2        1.62 ±  3%  perf-profile.children.cycles-pp.__vma_start_write
      1.40 ±  3%      +0.2        1.64 ±  5%  perf-profile.children.cycles-pp.__anon_vma_interval_tree_remove
      1.04 ±  9%      +0.2        1.28 ±  4%  perf-profile.children.cycles-pp.copy_present_ptes
      1.46 ±  3%      +0.2        1.70 ±  5%  perf-profile.children.cycles-pp.__slab_free
      1.20 ±  7%      +0.3        1.45 ±  4%  perf-profile.children.cycles-pp.up_write
      0.42 ± 12%      +0.3        0.71 ±  8%  perf-profile.children.cycles-pp.tlb_flush_mmu
      1.44 ±  6%      +0.3        1.75 ±  4%  perf-profile.children.cycles-pp.copy_pte_range
      1.60 ±  4%      +0.3        1.94 ±  4%  perf-profile.children.cycles-pp.copy_p4d_range
      1.63 ±  4%      +0.3        1.97 ±  4%  perf-profile.children.cycles-pp.copy_page_range
      2.10 ±  3%      +0.4        2.46 ±  3%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      1.11 ± 13%      +0.5        1.60 ±  7%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      2.82 ±  3%      +0.5        3.32 ±  4%  perf-profile.children.cycles-pp.kmem_cache_free
      1.32 ±  3%      +0.6        1.90 ±  8%  perf-profile.children.cycles-pp.next_uptodate_folio
      1.48 ± 10%      +0.6        2.07 ±  8%  perf-profile.children.cycles-pp.tlb_finish_mmu
      1.41 ± 12%      +0.7        2.10 ±  6%  perf-profile.children.cycles-pp.folios_put_refs
      1.98 ±  3%      +0.8        2.76 ±  7%  perf-profile.children.cycles-pp.filemap_map_pages
      2.05 ±  3%      +0.8        2.86 ±  7%  perf-profile.children.cycles-pp.do_read_fault
      2.05 ±  3%      +0.8        2.87 ±  7%  perf-profile.children.cycles-pp.do_fault
      2.43 ±  3%      +0.9        3.31 ±  6%  perf-profile.children.cycles-pp.__handle_mm_fault
      1.88 ± 10%      +0.9        2.76 ±  6%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      1.88 ± 10%      +0.9        2.76 ±  6%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
      2.51 ±  3%      +0.9        3.40 ±  6%  perf-profile.children.cycles-pp.handle_mm_fault
      2.88 ±  3%      +1.0        3.84 ±  6%  perf-profile.children.cycles-pp.exc_page_fault
      2.87 ±  3%      +1.0        3.83 ±  6%  perf-profile.children.cycles-pp.do_user_addr_fault
      2.61 ±  7%      +1.0        3.58 ±  5%  perf-profile.children.cycles-pp.zap_present_ptes
      3.12 ±  3%      +1.0        4.11 ±  6%  perf-profile.children.cycles-pp.asm_exc_page_fault
      3.41 ±  6%      +1.3        4.74 ±  5%  perf-profile.children.cycles-pp.zap_pte_range
      3.45 ±  6%      +1.3        4.79 ±  5%  perf-profile.children.cycles-pp.zap_pmd_range
      3.51 ±  6%      +1.3        4.85 ±  5%  perf-profile.children.cycles-pp.unmap_page_range
      3.63 ±  6%      +1.4        4.99 ±  5%  perf-profile.children.cycles-pp.unmap_vmas
     60.76 ±  2%      -3.5       57.25 ±  3%  perf-profile.self.cycles-pp.osq_lock
      5.95 ±  6%      -1.6        4.36 ±  9%  perf-profile.self.cycles-pp.rwsem_spin_on_owner
      3.32 ±  2%      -0.7        2.62 ±  4%  perf-profile.self.cycles-pp.anon_vma_interval_tree_insert
      0.05            +0.0        0.06        perf-profile.self.cycles-pp._find_next_and_bit
      0.06 ±  7%      +0.0        0.08 ±  6%  perf-profile.self.cycles-pp.vm_normal_page
      0.09 ±  5%      +0.0        0.10        perf-profile.self.cycles-pp.kernel_init_pages
      0.07 ±  5%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.__memcg_kmem_charge_page
      0.14 ±  3%      +0.0        0.16 ±  2%  perf-profile.self.cycles-pp.vma_mark_detached
      0.10 ±  3%      +0.0        0.12 ±  4%  perf-profile.self.cycles-pp.set_pte_range
      0.07 ±  7%      +0.0        0.09 ± 11%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.15 ±  3%      +0.0        0.18 ±  2%  perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.17 ±  3%      +0.0        0.19 ±  3%  perf-profile.self.cycles-pp.sync_regs
      0.24 ±  3%      +0.0        0.27 ±  3%  perf-profile.self.cycles-pp.__account_obj_stock
      0.14 ±  3%      +0.0        0.17 ±  6%  perf-profile.self.cycles-pp.get_partial_node
      0.18 ±  2%      +0.0        0.20 ±  3%  perf-profile.self.cycles-pp.refill_obj_stock
      0.22 ±  2%      +0.0        0.24 ±  3%  perf-profile.self.cycles-pp.__percpu_counter_sum
      0.25            +0.0        0.28        perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      0.22 ±  3%      +0.0        0.25 ±  3%  perf-profile.self.cycles-pp.__pi_memset
      0.14 ±  3%      +0.0        0.18 ±  4%  perf-profile.self.cycles-pp.fput
      0.30            +0.0        0.34        perf-profile.self.cycles-pp.mas_store
      0.22 ±  3%      +0.0        0.26 ±  3%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.30            +0.0        0.33 ±  4%  perf-profile.self.cycles-pp.update_sg_wakeup_stats
      0.37 ±  4%      +0.0        0.41 ±  4%  perf-profile.self.cycles-pp.rwsem_down_write_slowpath
      0.28 ±  6%      +0.0        0.32 ±  4%  perf-profile.self.cycles-pp.zap_pte_range
      0.16 ±  3%      +0.0        0.20 ±  3%  perf-profile.self.cycles-pp.pcpu_alloc_noprof
      0.28 ±  3%      +0.0        0.33 ±  6%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.27            +0.0        0.31 ±  5%  perf-profile.self.cycles-pp.kmem_cache_free
      0.38            +0.0        0.43        perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.cpu_util
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.free_pcppages_bulk
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mas_find
      0.40 ±  5%      +0.1        0.46 ±  4%  perf-profile.self.cycles-pp.__rb_insert_augmented
      0.20 ±  3%      +0.1        0.27 ±  6%  perf-profile.self.cycles-pp.folio_add_file_rmap_ptes
      0.35 ±  5%      +0.1        0.42 ±  9%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.68 ±  2%      +0.1        0.78 ±  2%  perf-profile.self.cycles-pp.__vma_start_write
      0.33 ±  3%      +0.1        0.43 ±  7%  perf-profile.self.cycles-pp.filemap_map_pages
      0.54            +0.1        0.64 ±  3%  perf-profile.self.cycles-pp.dup_mmap
      0.71 ±  2%      +0.1        0.81 ±  4%  perf-profile.self.cycles-pp.__vma_enter_locked
      0.63 ±  5%      +0.1        0.74 ±  5%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.46 ±  5%      +0.2        0.64 ±  5%  perf-profile.self.cycles-pp.free_pages_and_swap_cache
      1.28 ±  4%      +0.2        1.51 ±  5%  perf-profile.self.cycles-pp.__anon_vma_interval_tree_remove
      0.99 ±  9%      +0.2        1.22 ±  5%  perf-profile.self.cycles-pp.copy_present_ptes
      1.43 ±  3%      +0.2        1.67 ±  5%  perf-profile.self.cycles-pp.__slab_free
      0.30 ±  2%      +0.3        0.57 ±  6%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.96 ±  3%      +0.3        1.24 ±  2%  perf-profile.self.cycles-pp.up_write
      1.36 ±  3%      +0.5        1.82 ±  6%  perf-profile.self.cycles-pp.zap_present_ptes
      1.08 ± 13%      +0.5        1.56 ±  7%  perf-profile.self.cycles-pp.folio_remove_rmap_ptes
      1.24 ±  3%      +0.6        1.81 ±  8%  perf-profile.self.cycles-pp.next_uptodate_folio
      1.33 ± 12%      +0.7        2.01 ±  6%  perf-profile.self.cycles-pp.folios_put_refs


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/netlink-proc/stress-ng/60s

commit: 
  85f03a8631 ("mm/mmap_lock: add vma_is_attached() helper")
  bfc2b13b05 ("mm/rmap: allocate anon_vma_chain objects unlocked when possible")

85f03a86318c4172 bfc2b13b05a1343bb60a85d840f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   9243133            -5.2%    8760646        cpuidle..usage
    346361            -6.4%     324082        meminfo.Mapped
   1529351            +6.6%    1630248        meminfo.Shmem
      0.35 ±  2%      +0.1        0.44        mpstat.cpu.all.soft%
      0.98            +0.1        1.09        mpstat.cpu.all.usr%
    298266            -2.9%     289575        vmstat.system.cs
    577247            +2.4%     590966        vmstat.system.in
   7105876            +7.0%    7601087        turbostat.NMI
    332.10            +2.8%     341.32        turbostat.PkgWatt
     25.50            +6.4%      27.14        turbostat.RAMWatt
  37440414 ±  9%     +26.7%   47453343 ±  7%  numa-numastat.node0.local_node
  37552968 ±  9%     +26.6%   47551257 ±  7%  numa-numastat.node0.numa_hit
  35626288 ±  2%     +30.3%   46417467 ±  2%  numa-numastat.node1.local_node
  35715809 ±  2%     +30.3%   46520561 ±  2%  numa-numastat.node1.numa_hit
  37554292 ±  9%     +26.6%   47552046 ±  7%  numa-vmstat.node0.numa_hit
  37441738 ±  9%     +26.7%   47454132 ±  7%  numa-vmstat.node0.numa_local
  35716707 ±  2%     +30.2%   46520870 ±  2%  numa-vmstat.node1.numa_hit
  35627089 ±  2%     +30.3%   46417777 ±  2%  numa-vmstat.node1.numa_local
     18927 ± 22%     +25.0%      23668 ±  2%  perf-c2c.DRAM.local
    147147 ± 19%     +29.2%     190098 ±  5%  perf-c2c.DRAM.remote
    263763 ± 20%     +48.3%     391131 ±  5%  perf-c2c.HITM.local
    118030 ± 19%     +30.4%     153956 ±  5%  perf-c2c.HITM.remote
    381793 ± 20%     +42.8%     545088 ±  4%  perf-c2c.HITM.total
    341231           +25.7%     429025        stress-ng.netlink-proc.ops
      5697           +25.7%       7159        stress-ng.netlink-proc.ops_per_sec
    726075           +27.3%     924191        stress-ng.time.involuntary_context_switches
      7082 ±119%    +175.4%      19501 ± 62%  stress-ng.time.major_page_faults
 1.257e+08           +27.8%  1.607e+08 ±  2%  stress-ng.time.minor_page_faults
     42.26           +26.2%      53.32        stress-ng.time.user_time
   6952244           -12.2%    6106739        stress-ng.time.voluntary_context_switches
      0.09           +11.7%       0.10        perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     76.37 ± 18%     -20.8%      60.45 ± 12%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.09           +11.7%       0.10        perf-sched.total_sch_delay.average.ms
     76.37 ± 18%     -20.8%      60.45 ± 12%  perf-sched.total_sch_delay.max.ms
      2571 ± 16%     +44.4%       3714 ± 11%  perf-sched.total_wait_and_delay.max.ms
      2571 ± 16%     +44.4%       3714 ± 11%  perf-sched.total_wait_time.max.ms
      2571 ± 16%     +44.4%       3714 ± 11%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      2571 ± 16%     +44.4%       3714 ± 11%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    601141            +4.8%     629898        proc-vmstat.nr_active_anon
   1307815            +1.9%    1333006        proc-vmstat.nr_file_pages
     86624            -6.4%      81044        proc-vmstat.nr_mapped
    382407            +6.6%     407598        proc-vmstat.nr_shmem
    601141            +4.8%     629898        proc-vmstat.nr_zone_active_anon
  73272349 ±  4%     +28.4%   94075287 ±  2%  proc-vmstat.numa_hit
  73070343 ±  4%     +28.5%   93874463 ±  2%  proc-vmstat.numa_local
  76707662 ±  4%     +28.2%   98366347 ±  2%  proc-vmstat.pgalloc_normal
 1.262e+08           +27.8%  1.613e+08 ±  2%  proc-vmstat.pgfault
  75478722 ±  4%     +28.6%   97070551 ±  2%  proc-vmstat.pgfree
   9954110 ±  2%     +37.2%   13659353 ±  4%  proc-vmstat.pgreuse
    806263           +76.7%    1424830 ± 91%  sched_debug.cfs_rq:/.left_deadline.max
    126768 ± 18%     +47.1%     186420 ± 34%  sched_debug.cfs_rq:/.left_deadline.stddev
    806262           +76.7%    1424828 ± 91%  sched_debug.cfs_rq:/.left_vruntime.max
    126766 ± 18%     +47.1%     186417 ± 34%  sched_debug.cfs_rq:/.left_vruntime.stddev
    806262           +76.7%    1424828 ± 91%  sched_debug.cfs_rq:/.right_vruntime.max
    126766 ± 18%     +47.1%     186418 ± 34%  sched_debug.cfs_rq:/.right_vruntime.stddev
      1083 ±  8%     +12.3%       1217 ±  4%  sched_debug.cfs_rq:/.runnable_avg.max
      1054 ±  7%     +12.4%       1185 ±  4%  sched_debug.cfs_rq:/.util_avg.max
    767399 ±  3%     +18.5%     909720 ±  9%  sched_debug.cpu.curr->pid.avg
   1022954           +25.4%    1283282        sched_debug.cpu.curr->pid.max
    438214 ±  3%     +30.7%     572602 ±  6%  sched_debug.cpu.curr->pid.stddev
      3.56           +17.3%       4.17        perf-stat.i.MPKI
  2.27e+10            +5.1%  2.385e+10        perf-stat.i.branch-instructions
      0.55            +0.1        0.66        perf-stat.i.branch-miss-rate%
 1.231e+08           +26.3%  1.555e+08        perf-stat.i.branch-misses
 4.045e+08           +24.6%  5.038e+08        perf-stat.i.cache-misses
 1.242e+09           +25.5%  1.559e+09        perf-stat.i.cache-references
    308863            -3.2%     298957        perf-stat.i.context-switches
      4.20            -4.9%       3.99        perf-stat.i.cpi
     49492           +20.0%      59366        perf-stat.i.cpu-migrations
      1181           -19.0%     957.01        perf-stat.i.cycles-between-cache-misses
 1.138e+11            +6.0%  1.207e+11        perf-stat.i.instructions
      0.24            +5.1%       0.25        perf-stat.i.ipc
    116.41 ±120%    +174.4%     319.44 ± 62%  perf-stat.i.major-faults
     23.17           +25.7%      29.11 ±  2%  perf-stat.i.metric.K/sec
   2070571           +27.8%    2646416 ±  2%  perf-stat.i.minor-faults
   2070688           +27.8%    2646736 ±  2%  perf-stat.i.page-faults
      3.56           +17.3%       4.17        perf-stat.overall.MPKI
      0.54            +0.1        0.65        perf-stat.overall.branch-miss-rate%
      4.21            -5.0%       4.00        perf-stat.overall.cpi
      1184           -19.0%     960.02        perf-stat.overall.cycles-between-cache-misses
      0.24            +5.2%       0.25        perf-stat.overall.ipc
 2.229e+10            +5.2%  2.344e+10        perf-stat.ps.branch-instructions
 1.212e+08           +26.3%   1.53e+08        perf-stat.ps.branch-misses
 3.974e+08           +24.4%  4.944e+08        perf-stat.ps.cache-misses
 1.222e+09           +25.5%  1.533e+09        perf-stat.ps.cache-references
    303699            -3.2%     294063        perf-stat.ps.context-switches
 4.706e+11            +0.8%  4.746e+11        perf-stat.ps.cpu-cycles
     48643           +19.9%      58334        perf-stat.ps.cpu-migrations
 1.117e+11            +6.1%  1.186e+11        perf-stat.ps.instructions
    114.44 ±119%    +175.5%     315.27 ± 62%  perf-stat.ps.major-faults
   2036962           +27.8%    2602997 ±  2%  perf-stat.ps.minor-faults
   2037076           +27.8%    2603313 ±  2%  perf-stat.ps.page-faults
 6.832e+12            +5.6%  7.215e+12        perf-stat.total.instructions
     48.07           -48.1        0.00        perf-profile.calltrace.cycles-pp._Fork
     47.54           -47.5        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
     47.54           -47.5        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe._Fork
     47.51           -47.5        0.00        perf-profile.calltrace.cycles-pp.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
     47.51           -47.5        0.00        perf-profile.calltrace.cycles-pp.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork
     47.04           -47.0        0.00        perf-profile.calltrace.cycles-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
     44.60           -44.6        0.00        perf-profile.calltrace.cycles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
     43.93           -43.9        0.00        perf-profile.calltrace.cycles-pp.dup_mmap.dup_mm.copy_process.kernel_clone.__do_sys_clone
     41.28           -41.3        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     41.27           -41.3        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.48           -40.5        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.48           -40.5        0.00        perf-profile.calltrace.cycles-pp.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64
     40.48           -40.5        0.00        perf-profile.calltrace.cycles-pp.do_group_exit.__x64_sys_exit_group.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40.48           -40.5        0.00        perf-profile.calltrace.cycles-pp.x64_sys_call.do_syscall_64.entry_SYSCALL_64_after_hwframe
     38.17           -38.2        0.00        perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     38.09           -38.1        0.00        perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group
     38.07           -38.1        0.00        perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
     36.56           -36.6        0.00        perf-profile.calltrace.cycles-pp.anon_vma_fork.dup_mmap.dup_mm.copy_process.kernel_clone
     30.73           -30.7        0.00        perf-profile.calltrace.cycles-pp.free_pgtables.exit_mmap.__mmput.exit_mm.do_exit
     28.47           -28.5        0.00        perf-profile.calltrace.cycles-pp.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput.exit_mm
     23.42           -23.4        0.00        perf-profile.calltrace.cycles-pp.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm.copy_process
     15.86           -15.9        0.00        perf-profile.calltrace.cycles-pp.down_write.anon_vma_clone.anon_vma_fork.dup_mmap.dup_mm
     15.74           -15.7        0.00        perf-profile.calltrace.cycles-pp.down_write.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
     15.57           -15.6        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.unlink_anon_vmas.free_pgtables.exit_mmap
     15.53           -15.5        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.anon_vma_clone.anon_vma_fork.dup_mmap
     12.70           -12.7        0.00        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write.unlink_anon_vmas.free_pgtables
     12.58           -12.6        0.00        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write.anon_vma_clone.anon_vma_fork
     12.49           -12.5        0.00        perf-profile.calltrace.cycles-pp.down_write.anon_vma_fork.dup_mmap.dup_mm.copy_process
     12.36           -12.4        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.anon_vma_fork.dup_mmap.dup_mm
     10.13           -10.1        0.00        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write.anon_vma_fork.dup_mmap
      8.19            -8.2        0.00        perf-profile.calltrace.cycles-pp.__put_anon_vma.unlink_anon_vmas.free_pgtables.exit_mmap.__mmput
      7.76            -7.8        0.00        perf-profile.calltrace.cycles-pp.down_write.__put_anon_vma.unlink_anon_vmas.free_pgtables.exit_mmap
      7.74            -7.7        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_write_slowpath.down_write.__put_anon_vma.unlink_anon_vmas.free_pgtables
      6.72            -6.7        0.00        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_down_write_slowpath.down_write.__put_anon_vma.unlink_anon_vmas
      5.41            -5.4        0.00        perf-profile.calltrace.cycles-pp.prctl
      5.34            -5.3        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.prctl
      5.34            -5.3        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.prctl
      5.33            -5.3        0.00        perf-profile.calltrace.cycles-pp.__do_sys_prctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.prctl
      5.27            -5.3        0.00        perf-profile.calltrace.cycles-pp.proc_comm_connector.__do_sys_prctl.do_syscall_64.entry_SYSCALL_64_after_hwframe.prctl
      5.25            -5.3        0.00        perf-profile.calltrace.cycles-pp.netlink_broadcast_filtered.proc_comm_connector.__do_sys_prctl.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.20            -5.2        0.00        perf-profile.calltrace.cycles-pp.do_one_broadcast.netlink_broadcast_filtered.proc_comm_connector.__do_sys_prctl.do_syscall_64
     94.62           -94.6        0.00        perf-profile.children.cycles-pp.do_syscall_64
     94.62           -94.6        0.00        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     52.82           -52.8        0.00        perf-profile.children.cycles-pp.down_write
     51.93           -51.9        0.00        perf-profile.children.cycles-pp.rwsem_down_write_slowpath
     48.12           -48.1        0.00        perf-profile.children.cycles-pp._Fork
     47.60           -47.6        0.00        perf-profile.children.cycles-pp.kernel_clone
     47.59           -47.6        0.00        perf-profile.children.cycles-pp.__do_sys_clone
     47.12           -47.1        0.00        perf-profile.children.cycles-pp.copy_process
     44.67           -44.7        0.00        perf-profile.children.cycles-pp.dup_mm
     44.01           -44.0        0.00        perf-profile.children.cycles-pp.dup_mmap
     42.44           -42.4        0.00        perf-profile.children.cycles-pp.osq_lock
     40.80           -40.8        0.00        perf-profile.children.cycles-pp.x64_sys_call
     40.79           -40.8        0.00        perf-profile.children.cycles-pp.__x64_sys_exit_group
     40.79           -40.8        0.00        perf-profile.children.cycles-pp.do_group_exit
     40.78           -40.8        0.00        perf-profile.children.cycles-pp.do_exit
     38.18           -38.2        0.00        perf-profile.children.cycles-pp.exit_mm
     38.09           -38.1        0.00        perf-profile.children.cycles-pp.__mmput
     38.07           -38.1        0.00        perf-profile.children.cycles-pp.exit_mmap
     36.63           -36.6        0.00        perf-profile.children.cycles-pp.anon_vma_fork
     30.74           -30.7        0.00        perf-profile.children.cycles-pp.free_pgtables
     28.47           -28.5        0.00        perf-profile.children.cycles-pp.unlink_anon_vmas
     23.47           -23.5        0.00        perf-profile.children.cycles-pp.anon_vma_clone
      9.00            -9.0        0.00        perf-profile.children.cycles-pp.netlink_broadcast_filtered
      8.94            -8.9        0.00        perf-profile.children.cycles-pp.do_one_broadcast
      8.19            -8.2        0.00        perf-profile.children.cycles-pp.__put_anon_vma
      7.89            -7.9        0.00        perf-profile.children.cycles-pp.rwsem_spin_on_owner
      5.42            -5.4        0.00        perf-profile.children.cycles-pp.prctl
      5.34            -5.3        0.00        perf-profile.children.cycles-pp.__do_sys_prctl
      5.28            -5.3        0.00        perf-profile.children.cycles-pp.proc_comm_connector
     41.94           -41.9        0.00        perf-profile.self.cycles-pp.osq_lock
      7.80            -7.8        0.00        perf-profile.self.cycles-pp.rwsem_spin_on_owner
      6.29            -6.3        0.00        perf-profile.self.cycles-pp.do_one_broadcast





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


