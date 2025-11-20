Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54023CF64BC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B115D6B002E; Thu, 20 Nov 2025 00:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2376B0030; Thu, 20 Nov 2025 00:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B04B6B0031; Thu, 20 Nov 2025 00:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86EFF6B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:57:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC6DE89CA5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:57:36 +0000 (UTC)
X-FDA: 84129928512.16.20B0486
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CA951C0009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:57:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=glY300y1;
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763618254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iR1GgGxXZfS71fZL6x0P4A5Lk6ajLL2TKvBMpQGpDHQ=;
	b=Es4UrvecHRd9COZLiTGwdU5CzPxiQkZ0ToNNr45menZen/+CIy28OvhrgKsjEmPnLdSo6t
	fIUEtXeorpCMpwzPb0sMTEhKzTOoeNCiBEHkfSUS7xDi5om9+ej2EGmiMug2Svgxvx1Lq/
	erNUGxFIDYwzyLTKouXzaatbV7YNwIY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=glY300y1;
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763618254; a=rsa-sha256;
	cv=fail;
	b=rAm4VkYkXzVOKlcg9n1u0WrvHtHfO+urTnlzkhOQWae/ZqSzuPUZx+IFyCLOwtn3zzOZpe
	BM+PbKK+S1/Mv8dBzMdRD/vqZTMJ/raS8rMQjBdTCFDHMbJQNvc2nxH7T7ay15sB27DMtC
	AGDHb22I+lc7+Kjs+ZC1k7zt2MyleeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763618254; x=1795154254;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hK5fqF44Eh11MjzDH+NC/1HPvZw7Hmv8Y7T3gEIj7TI=;
  b=glY300y1I9jb5d7W6pKy1gPpuH0GRopm6aVmNUMLGuOyNbIEvZLZTV+m
   TkzGfkanmjLiIkLAIelX8HLueZzA4I/HVcaqzRkUbfxJQi/z6fdNe/KH5
   LjL9A7SXQski792BYFm9GkYkvU/DuXFX98LhzT/Yl2HBV0I2gBdzd5fzp
   eS8b0fj6cdQW2xLNHPBOPB/0RSeftDpw4R4CvaQ/Ashnk7sME0hdmQ5M9
   4OAE3YgU23Rv5VMihTPSSTxLY/Y/HcAAYMhakvtsnBd3noGhmSvJcaAb5
   1V4DqiZijQnxrPF+3cIr3Q2be7aPdzNiltVRmh27fAOZoLCCad6Gh4QNc
   w==;
X-CSE-ConnectionGUID: 2eTdMreOS4OuNsWp7z5SSA==
X-CSE-MsgGUID: lNa8/yqESgKKppix7dhVbA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76003076"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76003076"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 21:57:33 -0800
X-CSE-ConnectionGUID: D66+7l/FT++pcYovgbiGFA==
X-CSE-MsgGUID: muxF/bcWQW+wiPtuaVXnYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="221914544"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 21:57:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 21:57:31 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 21:57:31 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.11) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 21:57:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A3+HObZ+S2fmZCpG8RKu864xW0aZaksclhXP2avm4xPI4NaDp2ws8wwBrP/dffPYCq35Z/kZOlS2CvjFTj7DZGF5LQM5NtKM4hNMTQfKcRBRzRmpJIhf7rPmKY6/AtmAOOtvm4G1nt85jrYKDAAGhlI0YAp0XRVz4s8+pIIi8YZvhi2RfTJ1Y9crY/SZ4E49+fkIsG4SU+WoKk+CK4FEVuedOf03Bl1C/HAG2LXxqD00AhhbnjBsojGZjIbb68U4U/uhW//nFVFdDaxuw6cLVxCG5ZKKDFVBKM6Uj2ef0haIKsar685Ihq7w6DjnrXl6rqjU1P4z2d366PBFjmv3JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iR1GgGxXZfS71fZL6x0P4A5Lk6ajLL2TKvBMpQGpDHQ=;
 b=UX2K6jFutaJZGF7GZQRFb2EdksjkZJUojasdvKuqFZI8h2MWWlxutvzjSe/OPRBXuzJtTnxZ1nOSNcg2OmXGGb72sjH5eQpyaquKOh+Zv03evz6uqWLs4sTRaa/BjtPczvddHHXAFRCr18s1l/9hPdCFZ/Iq7DavZjus5bbnftFlFbANlEWydQ0vwPioy5RyzfEELht1Vphf+WCmGu9LnMNU2FSX2r8e/bWeUOodjN7+ea2NuG1dg1paqt/J6EhAEkiKj5JVMBqAbMFuKSneMgX9uLsk/fFOj4ZYBvk61TipnIpQD7e4wTrLF5L32cj7omMrfLPQAPkSy8kYhsCgWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CY8PR11MB6817.namprd11.prod.outlook.com (2603:10b6:930:63::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 05:57:29 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 05:57:29 +0000
Date: Thu, 20 Nov 2025 13:57:20 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mempool]  022e94e2c3:
 BUG:KASAN:double-free_in_mempool_free
Message-ID: <202511201309.55538605-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2P153CA0029.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::16) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CY8PR11MB6817:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f51867-bac7-40e8-7d50-08de27f9b051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?M/C4DgVOnh7LYynMM1V0/ZjQuCjwr1ZGmchz173akh1d7G8ETcvYpKmt4pJY?=
 =?us-ascii?Q?SANeGjpMp3z/ttHiFF0ovqe2BGzgfGmeJnD6k0khAsqMBJS86FX5GJr1X+Xm?=
 =?us-ascii?Q?i3E0mqZd0vuC9lLq6+XC+NfCFNOM4IoyMzfPAPaqJpvh1ecfMvAzH5C9MFvX?=
 =?us-ascii?Q?H7JTa2DkyLPNZTOTxLj9SK3uHBd81Opxou1iisREIC48BGjS6aY7cztbPlvT?=
 =?us-ascii?Q?Te8Ea4eQ1erp8ucDs60LVMlBQMepXbXTiUu3uKbKb3yE9FCGxJ9JOnCILEGS?=
 =?us-ascii?Q?wYec6CvyJuX0Vqu75O9/Vw92Uid+8mN47BmtP2ctJSpcsTQJB7uZDw6FqaVD?=
 =?us-ascii?Q?rLR9qWJYPrxJucRJzPlTq7kZmO10aylfTyGry2srwzgDnCWd+SNtZDpdU1Vc?=
 =?us-ascii?Q?jifkaK/vPQUtY0sqdSWdRZiTaO97vE/QQ2j4sxTOWHoFNM6XZfus+nLFLVA/?=
 =?us-ascii?Q?O0kVtiwyMKjxvAyFz5Y3RIs4Y51ez0O7Ihnf7HxEja7dHVLB3HA8XUNkxcYc?=
 =?us-ascii?Q?HKQYKUWgKnpW+ABiAKPBtcetHXYPg3YaGBRcKMOokaFHoKCClIcupJFofnId?=
 =?us-ascii?Q?Vlc0ZCAlI9crhPqf7EHScc49iFLBeLi1bXFvIA1y+BJnelEk1aW4M62G2x6l?=
 =?us-ascii?Q?ke5/G7+dhlmII81Xh2sFmncxn8yAGtqOOSQBU8HZMaZH80s2iAdK/zPKOGlA?=
 =?us-ascii?Q?3PL6he5vbgaiDnC38nZcBGCgc/gFkJL+S6K/NsZI7Uo0Ug85T0rJCUxncHhZ?=
 =?us-ascii?Q?7q51h6R3SoOveZreY61oxxidM8QuZoPlPKb7YKj2O63bQWHkrfh5+dAFvxUl?=
 =?us-ascii?Q?poCUlYXX6EsbaNPYWP6TXzf6WCJDFx+0ggx82weLvRVW9T6s+3bPwaUrv08A?=
 =?us-ascii?Q?3cTlqO0Wl9diRmxIgaajEClfXWCDP0dqCVX/sYtsTej3NrWeEJmZ9pybPjbh?=
 =?us-ascii?Q?WWxg3m8w0TZnCNchhGzf4BjYfRrgyo8tJU5ydrsUjDorMKnCC7HcF+C+33b1?=
 =?us-ascii?Q?m08wzB51QHd8U2y1/ORv6lQ0iI/GjxaKd+pU/qt4tmSSRR37dwP3Ujd4xo0y?=
 =?us-ascii?Q?UnwEC+smZHiXlzkaXK4v65Zsiin6YISqkBHfMByO9x+gy2YjwjgpgK58Dorv?=
 =?us-ascii?Q?GBgUOf8O3iW2mrEurr5GTMe+E5kybgjfi/7Rh5wmFO9vWC2JgBSPRRuNtCdE?=
 =?us-ascii?Q?0ZvFR6sRDMjZcgP8cRhO1hanqnl240N8RvnWF4hzd7PkFl0AViKWbFFgbGP+?=
 =?us-ascii?Q?6LkHtQuCbshoTfm09aSZv70/XX4Kk+eLxcQNJxUJ/3sgJtHUyG/KfRytaWy3?=
 =?us-ascii?Q?2FU2wLNsczlJbfNWg9K1/PNzkURRtwB91MixE3i7ZN26JxiUgIopk5IYdx7z?=
 =?us-ascii?Q?8Yh4Vhvoeyk504PaewLYedHtOcTSQ/F1fyAL0LszX3SybxNGlHu5GNkXkKzq?=
 =?us-ascii?Q?j+YbCK+7aR4Yc6J24Er9Ni9dsWEB3YaBpCtC49yq4Vkj4e4u79pDJw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4Y8PQ5K9+eH7A48H16y8fVLgQ3T/8CgycoXCoM7sgVh/J0JcIgOZGZ6pMSt?=
 =?us-ascii?Q?DtB/SGCP3CCo9YkfkHmp6pNeIIWIXydqlBxz6M4wuhpEjUuWYvldg5GVDRUQ?=
 =?us-ascii?Q?q1fAWh/G+jw0Q3bf2TzEbrVLjSSXtuaUJkj0aVqpMgtrujDQTiX/eGL+lphH?=
 =?us-ascii?Q?JgSyZ9oP3wAaMfvfMLIWMFP3MpMGY1OW8v0qyWSICAe9AZ1CfEG6R02Qf7Aw?=
 =?us-ascii?Q?SPGQuSZE81AMY7Dw4ymiiCjF2QdTb1dvsFsttROdfE1V3rAS1zf7N3mnt7op?=
 =?us-ascii?Q?yXrI3K4FhUZ4h6BX/S25MkubwfcxXJ/c1/AwBTJO3/He6ojbO7YbewlRpicD?=
 =?us-ascii?Q?HhipVaASRHHT7GqdsguDDikKP0LC+hlO6cIuQzJrxATRD2G+qf/5LxGroIUX?=
 =?us-ascii?Q?sBLanG33KtX0TASp65giYmmmJV8CkjKg295o60t8j4roVvONPydwZ29zDgI+?=
 =?us-ascii?Q?VK8lDlzLHnzvkeWj01HMJNCuNPbVGp0K9w5ABnSwi+GssfMspTVmNYgFuwOT?=
 =?us-ascii?Q?ICnx7rYwnnYzXu25mJre706ilmh/93xZrgD1AL69GJ+5VAgaL91iZcTopi4y?=
 =?us-ascii?Q?dFPPO061AGI9d0PF1JjbNjy3xCHeZQ5EvCIWp+qjXqPGBZuFIn8+OfZpbIGB?=
 =?us-ascii?Q?NPmFrnSDTeF9T68Y6nOGohdGnoDu8gs4VEtRSG0nn/ONZB8LlkfUw/eXduEO?=
 =?us-ascii?Q?KpBPgyJgeh9pYnrMqhjdWUQ45UpUJ6bs/3x7ZzO87A3QwWqPHdg+l7fB77gY?=
 =?us-ascii?Q?j8FUTXOvo6PhL6h9boWL/TMP9S4LPXHLUgGyimWsXwVD0u7eJrG3wOhDLk2U?=
 =?us-ascii?Q?qH7Gmro/lVTHMz9T/ZABBhnOfncLW22J31e/ncpBnvMALe8Ix9aSw9MUfk5E?=
 =?us-ascii?Q?ctpONi1r6+WiVUzJJ7SylCd5/FGwPqkl5X7/leL/+PdkSJ4QRa83RqE+u1nY?=
 =?us-ascii?Q?xqmfZJRBnQ8UNcN1EK7uZ0l52DcfMeumSd9DhfdxAi5hFCIFt+rBJZo3owEv?=
 =?us-ascii?Q?O5bRN0Xs0UjdvNMGIECHgYBkDeuU+4HDF4vnZ94EUpiW0VZMrV6YfM1zWYam?=
 =?us-ascii?Q?IuFu9hYh6YDkrGuwOuEkjZvjEDfUf1cwZFZOkoenOfKWy/HlD/AwUi6p4/A+?=
 =?us-ascii?Q?MgdCrsS5VoBnNHDWUrdeyBKVgI3FzSAlEz5w15TIDYO3HiLfrPLRIrZrJXoA?=
 =?us-ascii?Q?a9TytxpYAaL8qvMwXNTT3BhG+bIXEHtTJ4ei2p7rjXj3gbdwwXO97OeV9A1/?=
 =?us-ascii?Q?kVF76NysrZttf/3nEzSm9n1ryt5VbqDcmzSL6RZtAUqGAAD1JBok6gD7z3kk?=
 =?us-ascii?Q?iBzvVPnkMTm0J213bLmemz29G9vsN/HZp6hiDTqBGnh2qHFjO9uK8wiysAhK?=
 =?us-ascii?Q?GNBWAcYDI/iLgtnCXLCrW3anh5eQh4l2XTWIjeYb4CGB47EJLqMejHYO5bUm?=
 =?us-ascii?Q?2ob2Oa5t7+8iYEls6EkEmYbVnyRKV9sLlcCH22w3s8UfJBSVsWOroKxCvrYj?=
 =?us-ascii?Q?3ndWjYb0dFKHmcxqqXnmHOfZ6IUx0vSrSuLSwMwvq5B+/Y2Pgfp0U/6VFbge?=
 =?us-ascii?Q?1/aHyJi8heoQ8smUx7/bwsMjxhZWXjwndq5QpwbYLWt3xYq8VE1cbfNmY5uH?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f51867-bac7-40e8-7d50-08de27f9b051
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 05:57:29.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0DIobHsSlR8ovtKzaF3coSQv2OSmRaN0HguTLcqbhjMw2ptIEOeae73ikulSE81fgqteUSCEjeZUZ9pqh0inw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6817
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CA951C0009
X-Stat-Signature: 9yzpf1uiewn814591tjzupmgtnubipmi
X-Rspam-User: 
X-HE-Tag: 1763618253-963924
X-HE-Meta: U2FsdGVkX18sPjCMuI48ljV5ZvNqN9I8DmCGK5tVP7In2DvR9G1tjuuyV8WzrCOlJYsTBSAfk1+a72Brk/lJ/CKZGD4c3CLBqlaWdbqvdTvOVmY18IO2hLEPmni8refiTv/xxHo4f95aojf1i1lfLzw+JRpuJtFdXodkPfTpD+DpsGckHviMxEPtBU61cYmFSKwknIm1JHX53UiQQeglaNIdEwLOe37DUpfgZPsEL3t5veR11E4s8ZICjtRjn8XFBdDpuiIg1a9Oixz1vXvefXFThVoGqhv6XSOnHDf6RtvL1p7NRchdsGSwlVg+yHsuiGkU/y4sb4cwY6VhT3O3jDlJZr3ANpY4jJdjTiqj6YFF26oPaY7QCXpVwOxCsiiXgJwpGzoLB2nMqnRMPBtn/QCnUbsPYD5dVJZNO+bru3jhuMB8RhjiDzd0mVVjXIxizeNKSY+dtLees3xTP5XiE2ckWItjwJu+7LtyU8I+VQ278cDN2G5zVZYqudMP8ilouuyigrlSvqj8xF6L6AygAzuyuzuE7C1EsWiz/YbAelHY0QIV/IypVVk5ShEGHNIXD2msafPNJ/ATdxSFf38XYV7wa1TJ+0zjrcW8wqZUBQVQcQdQ+eKZN4mkMdskRAEkj70PFczq2Fsd9rAhm9/Kl3F5hy8XtqoVEFBBGvyztlXlvZZovkQYUfYOF0hoodnTBa75+LFrEHnpA9HF55LTOxa9n9MjEpEUNxmfKU+y3nHl3t84JtZJCQGk2cbmRvELXXMH1taZ3whTGLhld3gsDo8K5ya370M/5ghOHLo7fFPJMNS2Bd0o7Li+0RtZ/VZ1rhiTcsBJl9lpzIkJQJTvAMkj1Ca2zNjfU8prXx41F1zBxPUETg90rJhD7MGe+EVIliWpmYgDy1bD919UlQbGaJpOC7bRpzboItFmP8rCkHcIYfX+rTrgUOp3m89FRol2TkLJ7bGZSEnUX+Hjs/L
 x/OadlxC
 +no7zJDzaPKgS5nlYNbHxTseNpw2RbPz3XZ99
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:KASAN:double-free_in_mempool_free" on:

commit: 022e94e2c304505973d00dedca4b1432c231fbf6 ("mempool: add mempool_{alloc,free}_bulk")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 187dac290bfd0741b9d7d5490af825c33fd9baa4]

in testcase: kunit
version: 
with following parameters:

	group: group-03



config: x86_64-rhel-9.4-kunit
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511201309.55538605-lkp@intel.com


kern  :err   : [  152.903458] [   T4181] ==================================================================
kern  :err   : [  152.916375] [   T4181] BUG: KASAN: double-free in mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.922918] [   T4181] Free of addr ffff88812a92b800 by task kunit_try_catch/4181

kern  :err   : [  152.932343] [   T4181] CPU: 2 UID: 0 PID: 4181 Comm: kunit_try_catch Tainted: G S  B            N  6.18.0-rc3-00007-g022e94e2c304 #1 PREEMPT(voluntary)
kern  :err   : [  152.932348] [   T4181] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [N]=TEST
kern  :err   : [  152.932350] [   T4181] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
kern  :err   : [  152.932351] [   T4181] Call Trace:
kern  :err   : [  152.932353] [   T4181]  <TASK>
kern  :err   : [  152.932354] [   T4181]  dump_stack_lvl (lib/dump_stack.c:122)
kern  :err   : [  152.932358] [   T4181]  print_address_description+0x88/0x320
kern  :err   : [  152.932362] [   T4181]  print_report (mm/kasan/report.c:483)
kern  :err   : [  152.932365] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.932367] [   T4181]  kasan_report_invalid_free (mm/kasan/report.c:563)
kern  :err   : [  152.932371] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.932374] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.932376] [   T4181]  ? mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.932378] [   T4181]  check_slab_allocation (mm/kasan/common.c:230)
kern  :err   : [  152.932381] [   T4181]  __kasan_mempool_poison_object (mm/kasan/common.c:542 (discriminator 1))
kern  :err   : [  152.932384] [   T4181]  mempool_free_bulk (mm/mempool.c:137 mm/mempool.c:160 mm/mempool.c:653)
kern  :err   : [  152.932387] [   T4181]  ? mempool_init_node (mm/mempool.c:140 mm/mempool.c:160 mm/mempool.c:245)
kern  :err   : [  152.932389] [   T4181]  ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
kern  :err   : [  152.932393] [   T4181]  mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :err   : [  152.932395] [   T4181]  ? __pfx_mempool_free (mm/mempool.c:686)
kern  :err   : [  152.932398] [   T4181]  ? kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
kern  :err   : [  152.932400] [   T4181]  ? remove_element (mm/mempool.c:172)
kern  :err   : [  152.932414] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1444 (discriminator 17)) kasan_test
kern  :err   : [  152.932423] [   T4181]  ? __pfx_mempool_double_free_helper (mm/kasan/kasan_test_c.c:1436) kasan_test
kern  :err   : [  152.932440] [   T4181]  ? sched_clock (arch/x86/include/asm/preempt.h:95 arch/x86/kernel/tsc.c:289)
kern  :err   : [  152.932442] [   T4181]  ? __update_idle_core (kernel/sched/sched.h:1340 kernel/sched/fair.c:7584)
kern  :err   : [  152.932445] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
kern  :err   : [  152.932453] [   T4181]  ? __pfx_mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1448) kasan_test
kern  :err   : [  152.932461] [   T4181]  ? __switch_to (arch/x86/include/asm/cpufeature.h:101 arch/x86/kernel/process_64.c:378 arch/x86/kernel/process_64.c:666)
kern  :err   : [  152.932463] [   T4181]  ? __pfx_mempool_kmalloc (mm/mempool.c:715)
kern  :err   : [  152.932466] [   T4181]  ? __pfx_mempool_kfree (mm/mempool.c:722)
kern  :err   : [  152.932468] [   T4181]  ? __pfx_read_tsc (arch/x86/include/asm/tsc.h:57 arch/x86/kernel/tsc.c:1134)
kern  :err   : [  152.932471] [   T4181]  ? ktime_get_ts64 (kernel/time/timekeeping.c:387 kernel/time/timekeeping.c:404 kernel/time/timekeeping.c:967)
kern  :err   : [  152.932474] [   T4181]  ? __pfx___schedule (kernel/sched/core.c:6785)
kern  :err   : [  152.932477] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
kern  :err   : [  152.932480] [   T4181]  ? __pfx_kunit_try_run_case (lib/kunit/test.c:480)
kern  :err   : [  152.932483] [   T4181]  ? _raw_spin_lock_irqsave (arch/x86/include/asm/atomic.h:107 (discriminator 4) include/linux/atomic/atomic-arch-fallback.h:2170 (discriminator 4) include/linux/atomic/atomic-instrumented.h:1302 (discriminator 4) include/asm-generic/qspinlock.h:111 (discriminator 4) include/linux/spinlock.h:187 (discriminator 4) include/linux/spinlock_api_smp.h:111 (discriminator 4) kernel/locking/spinlock.c:162 (discriminator 4))
kern  :err   : [  152.932486] [   T4181]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161)
kern  :err   : [  152.932489] [   T4181]  ? __pfx__raw_spin_lock_irqsave (kernel/locking/spinlock.c:161)
kern  :err   : [  152.932492] [   T4181]  ? __pfx_kunit_try_run_case (lib/kunit/test.c:480)
kern  :err   : [  152.932494] [   T4181]  ? __pfx_kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:26)
kern  :err   : [  152.932498] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
kern  :err   : [  152.932501] [   T4181]  kthread (kernel/kthread.c:463)
kern  :err   : [  152.932503] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
kern  :err   : [  152.932505] [   T4181]  ? __pfx__raw_spin_lock_irq (kernel/locking/spinlock.c:169)
kern  :err   : [  152.932509] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
kern  :err   : [  152.932511] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
kern  :err   : [  152.932513] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
kern  :err   : [  152.932516] [   T4181]  ? __pfx_kthread (kernel/kthread.c:412)
kern  :err   : [  152.932518] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
kern  :err   : [  152.932522] [   T4181]  </TASK>

kern  :err   : [  153.201368] [   T4181] Allocated by task 4181:
kern  :warn  : [  153.205558] [   T4181]  kasan_save_stack (mm/kasan/common.c:57)
kern  :warn  : [  153.210098] [   T4181]  kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
kern  :warn  : [  153.214637] [   T4181]  remove_element (mm/mempool.c:172)
kern  :warn  : [  153.219176] [   T4181]  mempool_alloc_preallocated (include/linux/spinlock.h:406 mm/mempool.c:409 mm/mempool.c:585)
kern  :warn  : [  153.224582] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1439) kasan_test
kern  :warn  : [  153.231213] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
kern  :warn  : [  153.237839] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
kern  :warn  : [  153.242727] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
kern  :warn  : [  153.248830] [   T4181]  kthread (kernel/kthread.c:463)
kern  :warn  : [  153.252759] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
kern  :warn  : [  153.257211] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)

kern  :err   : [  153.264025] [   T4181] Freed by task 4181:
kern  :warn  : [  153.267866] [   T4181]  kasan_save_stack (mm/kasan/common.c:57)
kern  :warn  : [  153.272416] [   T4181]  kasan_save_track (mm/kasan/common.c:69 (discriminator 1) mm/kasan/common.c:78 (discriminator 1))
kern  :warn  : [  153.276964] [   T4181]  __kasan_save_free_info (mm/kasan/generic.c:590 (discriminator 1))
kern  :warn  : [  153.282025] [   T4181]  __kasan_mempool_poison_object (mm/kasan/common.c:534)
kern  :warn  : [  153.287868] [   T4181]  mempool_free_bulk (mm/mempool.c:137 mm/mempool.c:160 mm/mempool.c:653)
kern  :warn  : [  153.292668] [   T4181]  mempool_free (mm/mempool.c:687 (discriminator 1))
kern  :warn  : [  153.296944] [   T4181] mempool_double_free_helper (mm/kasan/kasan_test_c.c:1444 (discriminator 5)) kasan_test
kern  :warn  : [  153.303573] [   T4181] mempool_kmalloc_double_free (mm/kasan/kasan_test_c.c:1457) kasan_test
kern  :warn  : [  153.310203] [   T4181]  kunit_try_run_case (lib/kunit/test.c:450 lib/kunit/test.c:493)
kern  :warn  : [  153.315091] [   T4181]  kunit_generic_run_threadfn_adapter (lib/kunit/try-catch.c:31)
kern  :warn  : [  153.321198] [   T4181]  kthread (kernel/kthread.c:463)
kern  :warn  : [  153.325127] [   T4181]  ret_from_fork (arch/x86/kernel/process.c:164)
kern  :warn  : [  153.329576] [   T4181]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)

kern  :err   : [  153.336387] [   T4181] The buggy address belongs to the object at ffff88812a92b800
which belongs to the cache kmalloc-128 of size 128
kern  :err   : [  153.350320] [   T4181] The buggy address is located 0 bytes inside of
128-byte region [ffff88812a92b800, ffff88812a92b880)

kern  :err   : [  153.365488] [   T4181] The buggy address belongs to the physical page:
kern  :warn  : [  153.371765] [   T4181] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12a92a
kern  :warn  : [  153.380478] [   T4181] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
kern  :warn  : [  153.388842] [   T4181] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
kern  :warn  : [  153.396513] [   T4181] page_type: f5(slab)
kern  :warn  : [  153.400355] [   T4181] raw: 0017ffffc0000040 ffff888100042a00 ffffea00040b9600 0000000000000004
kern  :warn  : [  153.408806] [   T4181] raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
kern  :warn  : [  153.417258] [   T4181] head: 0017ffffc0000040 ffff888100042a00 ffffea00040b9600 0000000000000004
kern  :warn  : [  153.425800] [   T4181] head: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
kern  :warn  : [  153.434338] [   T4181] head: 0017ffffc0000001 ffffea0004aa4a81 00000000ffffffff 00000000ffffffff
kern  :warn  : [  153.442876] [   T4181] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
kern  :warn  : [  153.451422] [   T4181] page dumped because: kasan: bad access detected

kern  :err   : [  153.459902] [   T4181] Memory state around the buggy address:
kern  :err   : [  153.465395] [   T4181]  ffff88812a92b700: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
kern  :err   : [  153.473335] [   T4181]  ffff88812a92b780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
kern  :err   : [  153.481266] [   T4181] >ffff88812a92b800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
kern  :err   : [  153.489195] [   T4181]                    ^
kern  :err   : [  153.493121] [   T4181]  ffff88812a92b880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
kern  :err   : [  153.501051] [   T4181]  ffff88812a92b900: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
kern  :err   : [  153.508980] [   T4181] ==================================================================
kern  :info  : [  153.517054] [   T3993]     ok 51 mempool_kmalloc_double_free
kern  :err   : [  153.517141] [   T4183] ==================================================================


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251120/202511201309.55538605-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


