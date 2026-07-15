Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02AABC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8274C6B008C; Wed, 15 Jul 2026 00:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7516B0092; Wed, 15 Jul 2026 00:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650E66B0093; Wed, 15 Jul 2026 00:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF026B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:58:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 816391C02CF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:58:32 +0000 (UTC)
X-FDA: 84989805264.05.640BDEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AE36140009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:58:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcYpeqp+;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784091509;
	b=SCTffmx3OS1TGj3SNEDau+khjwdw4Dtzdco0khs5sqEFbuo7n06FCz+vN4d6Cx7/WIxtWl
	hHUkzpXsPPqapLiAF0OY7WKfC1svnKN8uk5TGlBayIjATBRfVEWrT1SVDY5xLH0eysD/9f
	GZKDxYuk8FNtjmBtyFcl/Dac2pPGyIM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcYpeqp+;
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784091509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U62sdZFHvWzib9Rz3XZ5goQMJCFfPtIA130o4NIPnSw=;
	b=Jz4et5pBeudpKtE/GV7ZSxza/OL5ekadBN/E8BfCJcS33mSGYH1wpI9b3+8mavcCPFqdo9
	Pm0q3YrfqI8q5thPzdMk8azlGyN199zPEQB2xvA9/wz+hfsc/wJKoe/MKcOH+kMRGtsXku
	VQCDvWgehhUb/Ive6K7jvw9KWEeABc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784091509; x=1815627509;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=EPAyPQEu5JjRNAbeEtHdUiCHD/Sg56Dh6QCxEvh5MYY=;
  b=PcYpeqp+bNQI4MOgWa6OjawcSs+bdfxTXg1NO05by1xW0yZhu2+mvFDh
   6MwP0rQDqQ5K7S+ORMEv2/5iJ3ppRBovayXdiFctkaeQE+zf+JEZmzVw1
   fmrAe1+JYs4SFVw+zHmulvMwQICUBN8ejQVeJVl/THj1TzLcrd1T4O4y7
   Qtq4Cy3B8KAqZwr6YRAgGlBVlQSgnowdHSDlaJ/8jxNemf/EuY49posXx
   OZ01MQBd5xJ+nptJWTZGOMj/wkTl8l5QSp44fGrRGrgl/roVjxGgOkwcw
   hnsDSzcxhpfMBWuWj42m10zQuC+65sTNmlr1CDG7lfpRGNA40IF2xFdyb
   w==;
X-CSE-ConnectionGUID: kgSU5KQZQJ+rN1ddxRO5SA==
X-CSE-MsgGUID: 4CEEMQbUQXaAM6fINSJuOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="95073227"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="95073227"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:58:26 -0700
X-CSE-ConnectionGUID: TyOGEMD3Tt6oxMUgXdHY+Q==
X-CSE-MsgGUID: jZNemik3QgyAk34JM2hTBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="254315394"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 21:58:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 21:58:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 21:58:25 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.8) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 21:58:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNUS2K95kKZ1FXwv3yvgk/ng5ER2n6wSBYB2iIBvANuJhEvyjRIRY+c7u5JGYxmhidJlV01bKb+7fXe7BxXPHLp4F3RfKDuT3ARSBGFE0rz5uHDN3shKlVqjKl/RZz1aC8BKpX07pesBrboiCYeKDOTljvkMgdNjw8ky2c19MR06JISN1D3kz28MtKE1yBKadcVvFSz45AHV3PKKWGRZOSXsVjT9SbPP9frGrvhJ/enQHM5sFcXyIiNJ71bdBzEPmS2QECpkhkT+4iqEGzrg+YRnNQzu16xqJ0ypkCgZkQAKFcI9NjuEfkIk3QJaHG9OxeeACUDqdKy/ly5/pw7mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyRbQyQ2hjoKkrl17YwvKtSBvEw7aHmBlUjSM6d/G/k=;
 b=oj17h1dxvGBryEAakbJUl0AAlgEkd3fVB/P7dtNlv+Ukmv2+SO+urfb3BBt3jgMYtw+xFpx4p+20Gu3g9qL/KlB9/L6jS1R6drxEPC4eJeHHiuZnNflrmTrxbBYGeSjKb/rCaABzo9dtVQD/t22j5sXTLkmkmZeGiAGH2HhL2n+UCtVrsJOv2qBNdfT9wmRri/LfEwPPWpb4VPiYtFev3vUc2yB3DZ6mLwKfyntv+67lgdRxUawx7WoVcQ33Fu4QP6YDUfPjYVc+M9CaKw1IRJeiKx0DmW3Dy3uhnwtdWB+N3euuRdx+BR5NWd6mmPuY1TGZVCV/USaA6tPMi0Enow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM3PPF5AD378C3B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Wed, 15 Jul
 2026 04:58:18 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 04:58:18 +0000
Date: Wed, 15 Jul 2026 12:58:08 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Liam Howlett
	<liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Mike Rapoport" <rppt@kernel.org>, Pedro Falcato <pfalcato@suse.de>, "Suren
 Baghdasaryan" <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm/page_alloc]  6698721815:
 vm-scalability.throughput 53.9% improvement
Message-ID: <202607151054.c17d30c9-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0034.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::19) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM3PPF5AD378C3B:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b55964e-2528-490f-8acc-08dee22daee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|11063799006|3023799007|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info: mkKI5LG5jk390RDhEhkLeF1JlmwC4l8lA0aVDrV+k2uNgZJpUTO2iBDiMI6rsdG3liCOZtrEkngy6yKnB4tle897d+8Z2ejjKltumK3XHwyyWKWtZ20EZvWIa27ZTE8J7dlaP+OzHHMqYk3PQImvPNj8u4qETHiH5spKVrAiUynf3buE3pqoW2hAk0GmA/eVY98C3WwACuxkB9n3b4Y8w9CcbKwSj/BbiUoefm6HyyaWZ9it3d97O4OYTtTpZBYAJUCwQOh6KcTBhBbyBhIcyw7pfspp0H7cr3xPAbU70tgaC5SY9FNo3DPluUVhGUsUA/T+OQs7zPPktjGwkQzgSxYTXBgFi2FEf60e6RcbnIeHw5zbEIQv91ss/xKthkTlsC2AoWjiHszg3Q7hKPWsZ3OtAvDSyCuh14dc1GjdT7qwEbgFhcoZh9GkOn4+B88YjYvKPiN+ii4D0LXVimpii1cRo4TRHgZdsWEfn+bkNTPwXHDRImHM+mKs3gJFiFtShvDGvmJ1DKR4Og54hlnHe5IVEH3bRHB3hnIaHpBUKpjIRsT+XadpHChd5Xcpgv81WtEGcHfSWKQybPl9uouxu56uUCUkP8QbEIhNbDfiW4AdDDkYn/UQKgUEBcPY3DhG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(11063799006)(3023799007)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?FrU3gRdPRYuOPPgycNR+tM6MtWTcQumzqyQpnY8Vjv4vMvnkUmiXTF0uTg?=
 =?iso-8859-1?Q?om8J6249OQ5JzzWXTeDZ/OUyqCFkKWt2Y62HwhNVN/IJnBjwvvHMfBFPdS?=
 =?iso-8859-1?Q?8y0hQbPm7swe1TRq2IOEfdXDHVEcd1lgQTzJvU4nVDPCjh9cqWqMlk8SlX?=
 =?iso-8859-1?Q?ZcmXN+kpvKMKF2rKlxSKehwO5iY9IHDYpx0bIXg2yiueeyIoK/CgNZQju+?=
 =?iso-8859-1?Q?RBx/SMlWWLkdtiByFrR1OCToLYe6DntN8tRCFTk5pDOZJQXA9fvDQYr3DE?=
 =?iso-8859-1?Q?lHjusoev2ywf2FNbXiFqzAXkfTrb/KR+ATxE9zStLD2MOAN53ihbjSvyrZ?=
 =?iso-8859-1?Q?rFyRbT7KqohoepcpJWuKPn72Z8EmgrjCsnkNdVsA7M8wdLFE2xR25O5NjN?=
 =?iso-8859-1?Q?E4WLjgHFc9vRiyimzk16+oi1dW/Ao0xkPcwXGZ8e8et4A3ny7uL1N2k0cd?=
 =?iso-8859-1?Q?2kfqBLzY6AyKbvkdeO/wPZzTq5ac5WCXo/fUyf/idfmVtM6HdlceCziSIp?=
 =?iso-8859-1?Q?dqN0fy2cfgmQyS646N3KjNFkAdsDAd9IczjoVNdF0MoCyAw/BxbLbsyC7P?=
 =?iso-8859-1?Q?bCNO4+ATmZVfSHx0hoNHBdFumLOETMy0pf1xR6h6vUqhjRXoI6QdENau0O?=
 =?iso-8859-1?Q?E0+TOl9lc/AhnEqkzKthiTO9ASGmmhp0MEwDwZgS2OV8oCrtWbGm+0WH4j?=
 =?iso-8859-1?Q?8CW/dbrjD/dvG2Lhg2C54+t2QyH4l/X24kpPXH7QHkzT3cS+4LXo6v9YfC?=
 =?iso-8859-1?Q?qIpzkHOenpAs9UtDpS5eV3Y5pq9kltW+cOaPtdOWixSajohzmhgmuzTqC5?=
 =?iso-8859-1?Q?Uxs+ndLIy4cy17B+lQqf8Qbc6eKGUmkRr1hDZZJ85Wkbp4JpcEznil7+kK?=
 =?iso-8859-1?Q?a8C36qDXSMsq05mJP0PTl9ZQqEj4KFj5r3Rks42uG5VH0sPpqV83rA3IOn?=
 =?iso-8859-1?Q?e5nP7LNIXh2hEvn93ndiAnK9T8W+0MmbqJ99fKErki291UFjQFpv0tR70L?=
 =?iso-8859-1?Q?GGQ0ggIkScF95uKmJLJwcX7Pn4yjOZiFmJBXZPKiaJKjtqyX6KmvMlT1lE?=
 =?iso-8859-1?Q?GfrCKGCqn/IOkIvd9N1oG/k4lmFIYTFdjSpwIttx9s7Wza3e0QJQ7HU9fM?=
 =?iso-8859-1?Q?lhxHR3QBV/KjzeUkqqMcn98eqDVOU3OKsbDpgqpRbngJr4u/8yDn2V8cI3?=
 =?iso-8859-1?Q?g24BP7+k3lcw99HfL9D9jVCk2S3vyQIKUHBI75hd00fdpM7yoSPthB+iM3?=
 =?iso-8859-1?Q?aj7HnT+kAz+0lWN6YjvOPseV8PfePV65QVWIpiyd9v5iYnhxtaFKcWIbh3?=
 =?iso-8859-1?Q?tY/2R3EabL9Vs7UQOU4rLOPSF+rzRWQBZj3j4D1VG8DwON41g8AQ7920RO?=
 =?iso-8859-1?Q?k8IDKUlPesqkYN86cJpArIVqahWZMhao22+4/S+qsiU1cnlJSrEUvqTG0h?=
 =?iso-8859-1?Q?pG/nMJV+sbqfNYCMrjFDg++NUGRrjbxv5aKVLRuUQKaG89xIxsHbD94lrz?=
 =?iso-8859-1?Q?oKv3Uk2tmGcg2xeP+XjqR820SMyvqE72+GphEpZAnB6g2+yuo+5HsbBQfQ?=
 =?iso-8859-1?Q?EmwPh2XvsF8eHD76vQfQPUF1XCL4Bs+koEaVg4a4nkmTCP4zpTJhqvpPIe?=
 =?iso-8859-1?Q?g9oqp5YZydLecFI5OOhP/T5xBgN/k1fMypa5OwimgiahkiWfQYEG8drEZp?=
 =?iso-8859-1?Q?NerqD993S6B19ZXVQGIpaMtavFU2WnPTZLnvARgASj1suqIaJCBpbIuhnK?=
 =?iso-8859-1?Q?Z+anG9vFtzYd+CbyP6oJfhyAVsMslS0Pd4Zvi7vq4jpssIOE3clNO4xfkJ?=
 =?iso-8859-1?Q?YZq60uX7IA=3D=3D?=
X-Exchange-RoutingPolicyChecked: hmeC5/pwDxAKoQUJXct1jH+LxMU9sj1mNgG2kR3NwlevqpQjou36RR9G2aRH97cmlcJySsW2blDA8LR5Y8gt+Q+3lxVHSvDdzI3uGKIjg8qlxdjBtN14Ka3nfCUNJ39Oxx9b+ABCcaokk0A1j9ZAeFxPuznWYE6svAf4zVNsH3mJCISxp4v8RrTnVviOYyAybXcUvL6Wf4Qg5q1+JhYJSdKjVQC5A1prUmYDK1NQV/X4UTBpltDt/K3PUCLqtYwopj0RnZI+CEVa61lxvUkEwZ9d9Ec8BIfPWoR/4YpInIh8Lu6mr5BfbmJB/RyvBzA9twZvnCfKSGOAccGEX4Mjfg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b55964e-2528-490f-8acc-08dee22daee5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 04:58:17.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFYvSqlmPW/nKZD2KmzOH78wNDFx3vLNZ4J2CIS2npi2QRsH2W60WxcS0MLriZPQhPQnZg+c5x0/C7LAFVZ7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5AD378C3B
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0AE36140009
X-Stat-Signature: jw8tafbid4junxisn5eujoym6aioq5ta
X-HE-Tag: 1784091507-424968
X-HE-Meta: U2FsdGVkX1/IsLf9lLuPnCaMdElwepzkU4hZnjf0I5zrefP7JnM5ah9uB4qt/DPD4y5WCGTXwViyFTuuYGVhQi06OvjLqqqIyMizEldqvxCidrJ2uWAvlujXF5bJ4LI9LvN4RoleMldM6/+ev3GqeU7kG0RW/MwOAZbS+NO7TBrJH3fIu+UAmWPJxdKB1AsDoAJadBZfNddcPZtHnF5dzqqzqmbidr3klCbT66ZZS54AFjtC1wst/1sFA937m9oBEvCnhdKjJRLbr0usGFSAlnJAV/ZMrih0Uf3KyHKo7SmXwS7RMXrC1xv0QfMYedd7kaxo/FnIV7tr2/sH0tYohrhIEvMkz/ISH/0Zb2pDX0Wn2QR/4xnIRnQjgZ9PhoPRKdJKiYJ5z+Fd7vCHPDvtZkeFFgRjdhDiIq/zw0WxTh409K9xuDvdjPOLk8v5PAavQAHcTMND0ZV0kBZhZkjIL8E/MUmvDk33AqwqBRkCHA3QfIYYN5BIyVx5YNcjo+vfvcaUOTZe+BDouaOJ7FytUFGMZNdCBeHEP72rKD2941jqhIQ1BV4b53fKzeqkLtwEVToAqlqZ/nfTjyuQIUtEV5MwNdSj/UE0ocY3TSmYeX3MrFGqe5g7QLjg+lGwcCdVQHTaJP7oNFvMp52Xh8JvGtvkF2VApwBL0DEl1TFSJ18k3JOAGoTfak6EVo0eYlaj8obNsWcH8TE0WUjU0Au2o0FTmZnXzw4PZ9WusJgoxygue4K4O3YgSsE0QfyOz8yfKwZ+VmzjM9AW7GUgqPlYbGarkP/mt2NgMhwXBMQvmcIBnScLDPhvD7t32POuXQesmWR73zy/NjLcAvpU4Q+C6cjQcBxsyxxKpuplaK3Rc4ijgX7VUMQ5+OV548XwLgv4ibWSgmPBxBYsX+j+jKMBMM6heEcvRMDfBMYHwkLIOmcSzS8l2IxqvfFF7lIeKYxseKxqvtdCVMetr7fOfh0
 Yjit4E3Z
 fh1HvUOzywxi9fK23lGYq1laLPrOciafSCXCa6HTM3S2BbQzS5M0x8tp9Z4WNZknunWphpAv3mEMERJat7P6KnNhJTRD4/XMWifQrzBP6VAIx29DEu57CuYR3N/iQ2s6tW3ppZMeQauz8JC14go1Ifhno4VJshXgt9ZgvogF90/ohUzJmVXi1S+xs0tkUHRFz8m57tQoNvZq55TWtbNb6nYGiYxM34sV/3iAGEIncDnxXaywmHpf3KBn7w/qZlKLX28FJHVDjaCyKbJzdnFWM5oYPPHzSK0+FqieK1pe4Sd++xlXp7KOuISvv3OU2AR4Gsate+DYAMinL9W3jMCZMY1O7HdfxE94aPBJ0oJk38Y0bLmO0T/4EKY354B4tFD4qh5ZnMjrXOFUq7M7jjVKwEE2Upgfdo2RZwQoPOqDkS0L67UJbuGvZAxeFFvwMMYGAwdbzulKn/7hF9ev+Dk1MIxV2LNzDB2ZuGIJ0FF5nmR7rWdupcRvu31d1sIZ2Fzbb2dzYJyR/nZVVvANvNrJzvKpLS3yYpTMN3uEVQTEXac7A8H3iusnz9H/MOi38Zibxz/qkCLjON8U2VpDNe5hNn9JrJJsNfqgfmaPHJoM1yduUGuEwyuPm5r7UrA1JnbJiLWSQFZzyx6kPtkgEwx9ct66tr/u+TNm/J05VgOQeA4KpxlXequ0Fa6+iVPcLv9P7iyO9e0KyE6soqgZtfH56MIIc7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

kernel test robot noticed a 53.9% improvement of vm-scalability.throughput on:


commit: 66987218154918a6341a3e3eeeee58110a69e0bb ("mm/page_alloc: ignore the exact initial compaction result")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: vm-scalability
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 512 threads 4 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 128G memory
parameters:

	runtime: 300s
	test: lru-file-mmap-read
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+-------------------------------------------------------------+
| testcase: change | vm-scalability: vm-scalability.throughput 77.1% improvement |
| test parameters  | cpufreq_governor=performance                                |
|                  | runtime=300s                                                |
|                  | test=lru-file-mmap-read                                     |
+------------------+-------------------------------------------------------------+
| testcase: change | vm-scalability: vm-scalability.throughput 16.9% improvement |
| test parameters  | cpufreq_governor=performance                                |
|                  | runtime=300s                                                |
|                  | test=lru-file-readonce                                      |
+------------------+-------------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260715/202607151054.c17d30c9-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/lkp-gnr-4sp2/lru-file-mmap-read/vm-scalability

commit: 
  d17f02417a ("mm/rmap: separate out fork-only logic on anon_vma_clone()")
  6698721815 ("mm/page_alloc: ignore the exact initial compaction result")

d17f02417a337de0 66987218154918a6341a3e3eeee 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     32414           +57.4%      51017 ± 14%  vm-scalability.median
      5348 ± 12%   +1707.0        7055 ± 12%  vm-scalability.stddev%
  17139782           +53.9%   26370901 ± 12%  vm-scalability.throughput
    334.84           -26.7%     245.52 ±  9%  vm-scalability.time.elapsed_time
    334.84           -26.7%     245.52 ±  9%  vm-scalability.time.elapsed_time.max
    111335 ± 11%     -65.4%      38570 ±  7%  vm-scalability.time.major_page_faults
   2894769 ± 10%     +19.2%    3449606 ±  8%  vm-scalability.time.maximum_resident_set_size
  37173495            -7.0%   34581753        vm-scalability.time.minor_page_faults
     42109 ±  2%      -9.0%      38328 ±  4%  vm-scalability.time.percent_of_cpu_this_job_got
    139086 ±  2%     -33.3%      92839 ± 13%  vm-scalability.time.system_time
      1924 ±  3%     -15.2%       1631 ±  4%  vm-scalability.time.user_time
    590.62           -15.0%     502.17 ±  4%  uptime.boot
     18.20 ± 11%     +42.3%      25.90 ± 14%  vmstat.cpu.id
      2.03           +36.7%       2.78 ±  8%  vmstat.memory.buff
    433.27            -8.9%     394.54 ±  4%  vmstat.procs.r
     17.70 ± 12%      +7.7       25.38 ± 15%  mpstat.cpu.all.idle%
      0.23 ±  2%      +0.0        0.27 ±  9%  mpstat.cpu.all.irq%
      0.06 ±  4%      +0.0        0.10 ±  6%  mpstat.cpu.all.soft%
     80.75 ±  2%      -7.9       72.82 ±  5%  mpstat.cpu.all.sys%
  39195313           -10.7%   35002084        meminfo.Active
  37299407           -11.2%   33105760        meminfo.Active(file)
    782231            +6.8%     835553        meminfo.AnonPages
  71104887            +4.5%   74294566        meminfo.Inactive
   2316403            -4.4%    2214979 ±  2%  meminfo.KReclaimable
      1556           -25.1%       1166 ±  9%  meminfo.Mlocked
   3845531           -13.4%    3329034 ±  6%  meminfo.PageTables
   2316403            -4.4%    2214979 ±  2%  meminfo.SReclaimable
    452.06 ±  2%      +9.4%     494.55 ±  3%  perf-stat.i.cpu-migrations
    313.62 ±  9%     -54.6%     142.31 ±  5%  perf-stat.i.major-faults
    117996           +23.7%     145924 ±  7%  perf-stat.i.minor-faults
    118310           +23.5%     146066 ±  7%  perf-stat.i.page-faults
    394.30 ±  4%      +8.8%     428.99 ±  3%  perf-stat.ps.cpu-migrations
    332.11 ± 11%     -52.6%     157.32 ±  5%  perf-stat.ps.major-faults
    115805           +27.6%     147809 ±  8%  perf-stat.ps.minor-faults
    116137           +27.4%     147967 ±  8%  perf-stat.ps.page-faults
     83.23 ±  2%      -7.3       75.91 ±  4%  turbostat.Busy%
      3339            +4.5%       3490        turbostat.Bzy_MHz
      0.16 ± 13%      +0.1        0.25 ± 17%  turbostat.C1E%
     15.27 ± 10%      +6.9       22.21 ± 15%  turbostat.C6P%
      0.09 ±  8%     +63.5%       0.14 ± 13%  turbostat.CPU%c1
      8.16 ±  2%     +51.6%      12.38 ± 17%  turbostat.CPU%c6
     13073 ±  6%     -39.5%       7910 ± 25%  turbostat.CoreThr
 2.433e+08           -20.4%  1.937e+08 ±  9%  turbostat.IRQ
  17754584 ±  4%     -15.1%   15068455 ± 12%  turbostat.NMI
      1.08 ± 19%     -36.3%       0.68 ± 27%  turbostat.Pkg%pc2
    942.66            -2.9%     915.70        turbostat.PkgWatt
     15.88           +19.9%      19.04 ±  5%  turbostat.RAMWatt
    610408 ±  7%     -24.6%     459977 ±  7%  numa-meminfo.node0.KReclaimable
   2581595 ±  8%     -30.1%    1803984 ± 12%  numa-meminfo.node0.MemFree
   1088852           -26.1%     804429 ±  8%  numa-meminfo.node0.PageTables
    610408 ±  7%     -24.6%     459977 ±  7%  numa-meminfo.node0.SReclaimable
    894539 ±  5%     -16.7%     745105 ±  6%  numa-meminfo.node0.Slab
  10623074 ±  5%     -21.9%    8300403 ±  6%  numa-meminfo.node1.Active
  10501025 ±  5%     -23.3%    8051741 ±  7%  numa-meminfo.node1.Active(file)
    965937 ±  2%     -11.0%     860102 ±  5%  numa-meminfo.node1.PageTables
     44946 ± 77%    +477.0%     259352 ± 61%  numa-meminfo.node1.Shmem
  10325120 ±  8%     -16.4%    8636137 ±  5%  numa-meminfo.node2.Active
  10142055 ±  8%     -17.8%    8338298 ±  5%  numa-meminfo.node2.Active(file)
   1324688 ±  6%     +20.2%    1591845 ± 11%  numa-meminfo.node2.MemFree
    930675 ±  2%     -11.3%     825101 ±  7%  numa-meminfo.node2.PageTables
    574144 ±  8%     -14.4%     491696 ±  7%  numa-meminfo.node3.KReclaimable
   1147080 ±  7%     +36.1%    1561726 ± 12%  numa-meminfo.node3.MemFree
    574144 ±  8%     -14.4%     491696 ±  7%  numa-meminfo.node3.SReclaimable
  27688109 ±  2%     -71.4%    7932558 ±  3%  numa-numastat.node0.local_node
   6932657 ± 12%     -22.6%    5366218 ±  7%  numa-numastat.node0.numa_foreign
  27891763 ±  2%     -70.8%    8132776 ±  3%  numa-numastat.node0.numa_hit
  17042862 ±  3%     -53.5%    7916855        numa-numastat.node0.numa_miss
  17246349 ±  3%     -52.9%    8117132        numa-numastat.node0.other_node
  27243977 ±  2%     -63.3%   10008727 ±  3%  numa-numastat.node1.local_node
  10410319 ±  4%     -31.2%    7158769 ±  3%  numa-numastat.node1.numa_foreign
  27414522 ±  2%     -62.7%   10225261 ±  2%  numa-numastat.node1.numa_hit
   6451305 ± 11%     -21.2%    5083744 ±  3%  numa-numastat.node1.numa_miss
   6621760 ± 10%     -20.0%    5300319 ±  2%  numa-numastat.node1.other_node
  26810356           -67.9%    8612376 ±  4%  numa-numastat.node2.local_node
  10413633 ±  3%     -38.9%    6361155        numa-numastat.node2.numa_foreign
  27009179           -67.3%    8821522 ±  4%  numa-numastat.node2.numa_hit
   7189031 ± 11%     -16.1%    6030772 ±  3%  numa-numastat.node2.numa_miss
   7387755 ± 11%     -15.5%    6239885 ±  3%  numa-numastat.node2.other_node
  24673982 ±  4%     -64.2%    8838344 ±  4%  numa-numastat.node3.local_node
  12061985 ±  5%     -51.6%    5838607 ±  2%  numa-numastat.node3.numa_foreign
  24904184 ±  4%     -63.8%    9013239 ±  4%  numa-numastat.node3.numa_hit
   9133188 ±  7%     -37.7%    5691634 ±  2%  numa-numastat.node3.numa_miss
   9363343 ±  7%     -37.4%    5865706 ±  3%  numa-numastat.node3.other_node
  68029369 ±  2%     -37.2%   42722914 ± 16%  sched_debug.cfs_rq:/.avg_vruntime.avg
  73719386           -35.3%   47699544 ± 14%  sched_debug.cfs_rq:/.avg_vruntime.max
   5707574 ± 16%     -31.0%    3939584 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.77            -9.7%       0.70 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.77            -9.7%       0.70 ±  5%  sched_debug.cfs_rq:/.h_nr_runnable.avg
   1000557 ±  7%     -13.9%     861633 ± 10%  sched_debug.cfs_rq:/.load.max
     98403 ±  6%     -11.3%      87308 ±  8%  sched_debug.cfs_rq:/.load.stddev
      0.76 ±  2%     -10.4%       0.68 ±  6%  sched_debug.cfs_rq:/.nr_queued.avg
    789.24            -9.7%     712.93 ±  5%  sched_debug.cfs_rq:/.runnable_avg.avg
    771.65 ±  2%     -10.3%     692.31 ±  5%  sched_debug.cfs_rq:/.util_avg.avg
  67916029 ±  2%     -37.2%   42640744 ± 16%  sched_debug.cfs_rq:/.zero_vruntime.avg
  73618885           -35.3%   47645929 ± 14%  sched_debug.cfs_rq:/.zero_vruntime.max
   5698949 ± 16%     -31.0%    3932419 ±  9%  sched_debug.cfs_rq:/.zero_vruntime.stddev
    406274           -12.2%     356650 ±  3%  sched_debug.cpu.clock.avg
    406463           -12.2%     356811 ±  3%  sched_debug.cpu.clock.max
    406067           -12.2%     356462 ±  3%  sched_debug.cpu.clock.min
    405558           -12.2%     355968 ±  3%  sched_debug.cpu.clock_task.avg
    405980           -12.2%     356356 ±  3%  sched_debug.cpu.clock_task.max
    366406           -13.6%     316713 ±  4%  sched_debug.cpu.clock_task.min
     23717            -8.5%      21696 ±  2%  sched_debug.cpu.curr->pid.max
     29925 ± 49%    +125.6%      67497 ± 44%  sched_debug.cpu.max_idle_balance_cost.stddev
      0.76           -11.8%       0.67 ±  7%  sched_debug.cpu.nr_running.avg
      3269 ± 15%     -21.2%       2577 ±  8%  sched_debug.cpu.nr_switches.avg
      1059 ±  4%     -22.1%     825.21 ±  7%  sched_debug.cpu.nr_switches.min
    406061           -12.2%     356456 ±  3%  sched_debug.cpu_clk
    404524           -12.3%     354916 ±  3%  sched_debug.ktime
      0.00 ± 13%     -36.5%       0.00 ± 23%  sched_debug.rt_rq:.rt_nr_running.avg
      0.47 ± 13%     -36.5%       0.30 ± 23%  sched_debug.rt_rq:.rt_nr_running.max
      0.02 ± 13%     -36.5%       0.01 ± 23%  sched_debug.rt_rq:.rt_nr_running.stddev
    409958           -12.1%     360376 ±  3%  sched_debug.sched_clk
    644556 ±  8%     -29.5%     454680 ± 10%  numa-vmstat.node0.nr_free_pages
    125174 ±  6%     +61.0%     201504 ± 10%  numa-vmstat.node0.nr_free_pages_blocks
    272666           -26.2%     201286 ±  8%  numa-vmstat.node0.nr_page_table_pages
    152750 ±  7%     -24.7%     114963 ±  7%  numa-vmstat.node0.nr_slab_reclaimable
   6932657 ± 12%     -22.6%    5366218 ±  7%  numa-vmstat.node0.numa_foreign
  27891692 ±  2%     -70.8%    8132616 ±  2%  numa-vmstat.node0.numa_hit
  27688038 ±  2%     -71.4%    7932398 ±  3%  numa-vmstat.node0.numa_local
  17042862 ±  3%     -53.5%    7916855        numa-vmstat.node0.numa_miss
  17246349 ±  3%     -52.9%    8117132        numa-vmstat.node0.numa_other
   2045761 ± 31%     -94.3%     116494 ±127%  numa-vmstat.node0.workingset_nodereclaim
   2603402 ±  5%     -21.6%    2041887 ±  8%  numa-vmstat.node1.nr_active_file
    241868 ±  2%     -11.0%     215203 ±  5%  numa-vmstat.node1.nr_page_table_pages
     11244 ± 77%    +481.1%      65341 ± 62%  numa-vmstat.node1.nr_shmem
   2619472 ±  5%     -21.5%    2057197 ±  7%  numa-vmstat.node1.nr_zone_active_file
  10410319 ±  4%     -31.2%    7158769 ±  3%  numa-vmstat.node1.numa_foreign
  27414706 ±  2%     -62.7%   10225141 ±  2%  numa-vmstat.node1.numa_hit
  27244161 ±  2%     -63.3%   10008606 ±  3%  numa-vmstat.node1.numa_local
   6451305 ± 11%     -21.2%    5083744 ±  3%  numa-vmstat.node1.numa_miss
   6621760 ± 10%     -20.0%    5300319 ±  2%  numa-vmstat.node1.numa_other
   2570579 ±  8%     -19.3%    2074584 ±  5%  numa-vmstat.node2.nr_active_file
    330087 ±  6%     +21.8%     402042 ±  9%  numa-vmstat.node2.nr_free_pages
    133245 ± 10%     +44.4%     192364 ±  9%  numa-vmstat.node2.nr_free_pages_blocks
    233075 ±  2%     -11.4%     206482 ±  7%  numa-vmstat.node2.nr_page_table_pages
   2587450 ±  8%     -19.1%    2092405 ±  5%  numa-vmstat.node2.nr_zone_active_file
  10413633 ±  3%     -38.9%    6361155        numa-vmstat.node2.numa_foreign
  27008965           -67.3%    8821940 ±  4%  numa-vmstat.node2.numa_hit
  26810142           -67.9%    8612793 ±  4%  numa-vmstat.node2.numa_local
   7189031 ± 11%     -16.1%    6030772 ±  3%  numa-vmstat.node2.numa_miss
   7387755 ± 11%     -15.5%    6239885 ±  3%  numa-vmstat.node2.numa_other
    285399 ±  7%     +38.2%     394412 ± 12%  numa-vmstat.node3.nr_free_pages
    123692 ±  5%     +52.0%     188035 ±  9%  numa-vmstat.node3.nr_free_pages_blocks
    143631 ±  8%     -14.5%     122856 ±  7%  numa-vmstat.node3.nr_slab_reclaimable
  12061985 ±  5%     -51.6%    5838607 ±  2%  numa-vmstat.node3.numa_foreign
  24904138 ±  4%     -63.8%    9013323 ±  4%  numa-vmstat.node3.numa_hit
  24673937 ±  4%     -64.2%    8838429 ±  4%  numa-vmstat.node3.numa_local
   9133188 ±  7%     -37.7%    5691634 ±  2%  numa-vmstat.node3.numa_miss
   9363343 ±  7%     -37.4%    5865706 ±  3%  numa-vmstat.node3.numa_other
   7820261           -18.9%    6341117        proc-vmstat.allocstall_movable
     98124 ±  9%    +214.9%     309006 ±  2%  proc-vmstat.allocstall_normal
 3.831e+08 ± 17%     -63.1%  1.415e+08 ± 15%  proc-vmstat.compact_daemon_free_scanned
 1.965e+08 ± 19%     -73.5%   52053097 ± 23%  proc-vmstat.compact_daemon_migrate_scanned
      1602 ±  3%     -44.6%     887.17 ± 11%  proc-vmstat.compact_daemon_wake
   9378335 ±  4%     -90.8%     862397 ± 12%  proc-vmstat.compact_fail
 3.901e+08 ± 17%     -62.1%   1.48e+08 ± 15%  proc-vmstat.compact_free_scanned
  16980332 ±  6%     -52.5%    8061992 ± 14%  proc-vmstat.compact_isolated
 1.038e+10 ±  2%     -82.9%  1.778e+09 ± 11%  proc-vmstat.compact_migrate_scanned
  15567410 ±  4%     -87.8%    1900758 ± 10%  proc-vmstat.compact_stall
   6189075 ±  4%     -83.2%    1038360 ±  9%  proc-vmstat.compact_success
    214.50 ± 11%     -34.3%     140.83 ± 10%  proc-vmstat.kswapd_high_wmark_hit_quickly
      2622           -44.0%       1469 ± 13%  proc-vmstat.kswapd_low_wmark_hit_quickly
   9367716           -13.0%    8147854        proc-vmstat.nr_active_file
    195573            +6.8%     208939        proc-vmstat.nr_anon_pages
  28422974            -0.9%   28158284        proc-vmstat.nr_file_pages
    513201 ±  2%     +42.2%     729952 ±  9%  proc-vmstat.nr_free_pages_blocks
  17294365            +5.5%   18244722        proc-vmstat.nr_inactive_file
    104.67 ± 11%     -69.2%      32.21 ± 34%  proc-vmstat.nr_isolated_file
     93490            -1.1%      92453        proc-vmstat.nr_kernel_stack
    389.17           -24.9%     292.20 ± 10%  proc-vmstat.nr_mlock
    962257           -13.5%     832225 ±  6%  proc-vmstat.nr_page_table_pages
    579550            -4.4%     553953 ±  2%  proc-vmstat.nr_slab_reclaimable
   9439348           -12.9%    8217212        proc-vmstat.nr_zone_active_file
  17228867            +5.5%   18177894        proc-vmstat.nr_zone_inactive_file
  39818596 ±  5%     -37.9%   24724749        proc-vmstat.numa_foreign
 1.072e+08           -66.2%   36199639        proc-vmstat.numa_hit
 1.064e+08           -66.7%   35398847        proc-vmstat.numa_local
  39816386 ±  5%     -37.9%   24723006        proc-vmstat.numa_miss
  40619208 ±  4%     -37.2%   25523044        proc-vmstat.numa_other
      2898           -44.2%       1617 ± 12%  proc-vmstat.pageoutrun
  27773213 ±  5%     -38.0%   17221934 ±  4%  proc-vmstat.pgalloc_dma32
 1.044e+09            +2.1%  1.066e+09        proc-vmstat.pgalloc_normal
  39161267            -7.2%   36338994        proc-vmstat.pgfault
    111322 ± 11%     -65.4%      38558 ±  7%  proc-vmstat.pgmajfault
    121496 ± 19%     -68.1%      38721 ± 35%  proc-vmstat.pgmigrate_fail
   8342401 ±  6%     -51.8%    4018763 ± 14%  proc-vmstat.pgmigrate_success
    830.50 ±  7%     +31.0%       1088        proc-vmstat.pgpgin
   7775510 ±  3%     +25.9%    9785771 ± 13%  proc-vmstat.pgrefill
    118571 ±  2%      -9.2%     107610 ±  4%  proc-vmstat.pgreuse
 1.736e+09            +4.6%  1.816e+09        proc-vmstat.pgscan_direct
    385.33 ± 16%    +166.4%       1026 ± 34%  proc-vmstat.pgscan_direct_throttle
 1.837e+09            +4.5%  1.919e+09        proc-vmstat.pgscan_file
   1520233 ±  8%     -70.0%     456777 ± 13%  proc-vmstat.pgskip_dma32
  74336420 ±  2%     -12.2%   65301144 ±  6%  proc-vmstat.pgskip_normal
 9.701e+08            +1.5%  9.848e+08        proc-vmstat.pgsteal_direct
  65653470 ±  2%      -5.7%   61900868        proc-vmstat.pgsteal_kswapd
  24170184 ± 12%    +114.1%   51750265 ± 44%  proc-vmstat.slabs_scanned
     20.90 ± 45%     -20.8        0.15 ±223%  perf-profile.calltrace.cycles-pp.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
     13.37 ± 45%     -13.3        0.11 ±223%  perf-profile.calltrace.cycles-pp.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
     13.35 ± 45%     -13.2        0.11 ±223%  perf-profile.calltrace.cycles-pp.compact_zone.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath
     13.35 ± 45%     -13.2        0.11 ±223%  perf-profile.calltrace.cycles-pp.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
     13.08 ± 45%     -13.0        0.10 ±223%  perf-profile.calltrace.cycles-pp.isolate_migratepages.compact_zone.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact
      9.47 ± 46%      -9.5        0.00        perf-profile.calltrace.cycles-pp.fast_find_migrateblock.isolate_migratepages.compact_zone.compact_zone_order.try_to_compact_pages
      9.31 ± 46%      -9.3        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.fast_find_migrateblock.isolate_migratepages.compact_zone.compact_zone_order
      9.28 ± 46%      -9.3        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.fast_find_migrateblock.isolate_migratepages.compact_zone
      7.53 ± 45%      -7.5        0.00        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
      7.51 ± 45%      -7.5        0.00        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
      7.46 ± 45%      -7.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath
      7.46 ± 45%      -7.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node.balance_pgdat
      0.67 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.kswapd.kthread.ret_from_fork.ret_from_fork_asm
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.shrink_many.shrink_node.balance_pgdat.kswapd.kthread
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.shrink_node.balance_pgdat.kswapd.kthread.ret_from_fork
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.shrink_one.shrink_many.shrink_node.balance_pgdat.kswapd
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.calltrace.cycles-pp.balance_pgdat.kswapd.kthread.ret_from_fork.ret_from_fork_asm
      0.61 ± 45%      +0.9        1.55 ± 32%  perf-profile.calltrace.cycles-pp.__pi_memset.zero_user_segments.iomap_read_folio_iter.iomap_readahead.xfs_vm_readahead
      0.66 ± 45%      +1.0        1.70 ± 32%  perf-profile.calltrace.cycles-pp.zero_user_segments.iomap_read_folio_iter.iomap_readahead.xfs_vm_readahead.read_pages
      0.68 ± 45%      +1.1        1.76 ± 32%  perf-profile.calltrace.cycles-pp.iomap_read_folio_iter.iomap_readahead.xfs_vm_readahead.read_pages.page_cache_ra_order
      0.68 ± 45%      +1.1        1.77 ± 32%  perf-profile.calltrace.cycles-pp.iomap_readahead.xfs_vm_readahead.read_pages.page_cache_ra_order.filemap_fault
      0.68 ± 45%      +1.1        1.77 ± 32%  perf-profile.calltrace.cycles-pp.read_pages.page_cache_ra_order.filemap_fault.__do_fault.do_read_fault
      0.68 ± 45%      +1.1        1.77 ± 32%  perf-profile.calltrace.cycles-pp.xfs_vm_readahead.read_pages.page_cache_ra_order.filemap_fault.__do_fault
      0.00            +2.2        2.23 ± 59%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.list_lru_add.list_lru_add_obj.workingset_update_node
      0.00            +2.2        2.24 ± 58%  perf-profile.calltrace.cycles-pp._raw_spin_lock.list_lru_add.list_lru_add_obj.workingset_update_node.xas_store
      0.00            +2.3        2.26 ± 58%  perf-profile.calltrace.cycles-pp.list_lru_add.list_lru_add_obj.workingset_update_node.xas_store.__filemap_remove_folio
      0.00            +2.3        2.28 ± 57%  perf-profile.calltrace.cycles-pp.list_lru_add_obj.workingset_update_node.xas_store.__filemap_remove_folio.__remove_mapping
      0.00            +2.3        2.28 ± 57%  perf-profile.calltrace.cycles-pp.workingset_update_node.xas_store.__filemap_remove_folio.__remove_mapping.shrink_folio_list
      0.00            +2.3        2.34 ± 55%  perf-profile.calltrace.cycles-pp.xas_store.__filemap_remove_folio.__remove_mapping.shrink_folio_list.evict_folios
      0.00            +2.3        2.35 ± 55%  perf-profile.calltrace.cycles-pp.__filemap_remove_folio.__remove_mapping.shrink_folio_list.evict_folios.try_to_shrink_lruvec
      0.00            +3.7        3.69 ± 72%  perf-profile.calltrace.cycles-pp.__remove_mapping.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      0.00            +4.9        4.92 ± 17%  perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof
      0.00            +5.3        5.34 ± 14%  perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one
      0.00            +5.4        5.42 ± 13%  perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.do_read_fault
      0.00            +5.4        5.42 ± 13%  perf-profile.calltrace.cycles-pp.alloc_pages_mpol.alloc_pages_noprof.pte_alloc_one.do_read_fault.do_fault
      0.00            +5.4        5.42 ± 13%  perf-profile.calltrace.cycles-pp.alloc_pages_noprof.pte_alloc_one.do_read_fault.do_fault.__handle_mm_fault
      0.00            +5.4        5.42 ± 13%  perf-profile.calltrace.cycles-pp.pte_alloc_one.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault
      0.56 ± 45%      +5.9        6.45 ± 21%  perf-profile.calltrace.cycles-pp.page_cache_ra_unbounded.filemap_fault.__do_fault.do_read_fault.do_fault
      0.00            +6.2        6.23 ± 23%  perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_unbounded
      0.00            +6.3        6.28 ± 23%  perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_unbounded.filemap_fault
      0.00            +6.3        6.28 ± 23%  perf-profile.calltrace.cycles-pp.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_unbounded.filemap_fault.__do_fault
      0.00            +6.3        6.28 ± 23%  perf-profile.calltrace.cycles-pp.folio_alloc_noprof.page_cache_ra_unbounded.filemap_fault.__do_fault.do_read_fault
     39.51 ± 45%     +32.2       71.72 ± 11%  perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
      2.89 ±152%     +32.7       35.62 ± 60%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab
      2.89 ±152%     +32.8       35.67 ± 60%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab.shrink_slab_memcg
      2.93 ±150%     +33.0       35.93 ± 60%  perf-profile.calltrace.cycles-pp.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab.shrink_slab_memcg.shrink_one
      2.93 ±150%     +33.0       35.93 ± 60%  perf-profile.calltrace.cycles-pp.list_lru_walk_one_irq.do_shrink_slab.shrink_slab_memcg.shrink_one.shrink_many
      2.98 ±148%     +33.5       36.48 ± 58%  perf-profile.calltrace.cycles-pp.do_shrink_slab.shrink_slab_memcg.shrink_one.shrink_many.shrink_node
      3.00 ±147%     +33.5       36.54 ± 58%  perf-profile.calltrace.cycles-pp.shrink_slab_memcg.shrink_one.shrink_many.shrink_node.do_try_to_free_pages
     39.38 ± 45%     +37.0       76.36 ± 12%  perf-profile.calltrace.cycles-pp.shrink_many.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath
     39.37 ± 45%     +37.0       76.36 ± 12%  perf-profile.calltrace.cycles-pp.shrink_one.shrink_many.shrink_node.do_try_to_free_pages.try_to_free_pages
     39.38 ± 45%     +37.1       76.44 ± 12%  perf-profile.calltrace.cycles-pp.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
     39.40 ± 45%     +37.1       76.46 ± 12%  perf-profile.calltrace.cycles-pp.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
     13.50 ± 45%     -13.4        0.14 ±171%  perf-profile.children.cycles-pp.compact_zone
     13.37 ± 45%     -13.2        0.14 ±170%  perf-profile.children.cycles-pp.try_to_compact_pages
     13.35 ± 45%     -13.2        0.14 ±171%  perf-profile.children.cycles-pp.compact_zone_order
     13.19 ± 45%     -13.1        0.13 ±172%  perf-profile.children.cycles-pp.isolate_migratepages
      9.49 ± 46%      -9.4        0.11 ±171%  perf-profile.children.cycles-pp.fast_find_migrateblock
      0.05 ± 46%      +0.0        0.10 ± 22%  perf-profile.children.cycles-pp.update_process_times
      0.04 ± 45%      +0.1        0.09 ± 26%  perf-profile.children.cycles-pp.folio_remove_rmap_ptes
      0.05 ± 46%      +0.1        0.10 ± 20%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.03 ± 70%      +0.1        0.09 ± 24%  perf-profile.children.cycles-pp.__free_one_page
      0.06 ± 45%      +0.1        0.11 ± 20%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.02 ±144%      +0.1        0.08 ± 21%  perf-profile.children.cycles-pp.xas_create
      0.01 ±223%      +0.1        0.07 ± 21%  perf-profile.children.cycles-pp.sched_tick
      0.08 ± 45%      +0.1        0.14 ± 21%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.08 ± 46%      +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.08 ± 45%      +0.1        0.17 ± 25%  perf-profile.children.cycles-pp.get_pte_pfn
      0.00            +0.1        0.09 ± 44%  perf-profile.children.cycles-pp.kmem_cache_free
      0.01 ±223%      +0.1        0.10 ± 38%  perf-profile.children.cycles-pp.rcu_core
      0.00            +0.1        0.10 ± 38%  perf-profile.children.cycles-pp.rcu_do_batch
      0.00            +0.1        0.11 ± 37%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.01 ±223%      +0.1        0.12 ± 34%  perf-profile.children.cycles-pp.handle_softirqs
      0.12 ± 44%      +0.1        0.24 ± 25%  perf-profile.children.cycles-pp.try_to_unmap_one
      0.12 ± 45%      +0.1        0.25 ± 24%  perf-profile.children.cycles-pp.try_to_unmap
      0.18 ± 44%      +0.1        0.32 ± 31%  perf-profile.children.cycles-pp.perf_mmap__push
      0.18 ± 44%      +0.1        0.32 ± 31%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.00            +0.1        0.15 ± 53%  perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      0.10 ± 45%      +0.2        0.25 ± 18%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.09 ± 45%      +0.2        0.25 ± 34%  perf-profile.children.cycles-pp.__mod_zone_page_state
      0.01 ±223%      +0.2        0.19 ± 32%  perf-profile.children.cycles-pp.__filemap_add_folio
      0.03 ±141%      +0.2        0.23 ± 18%  perf-profile.children.cycles-pp.shadow_lru_isolate
      0.04 ±101%      +0.2        0.24 ± 15%  perf-profile.children.cycles-pp._raw_spin_unlock_irq
      0.17 ± 44%      +0.2        0.39 ± 26%  perf-profile.children.cycles-pp.do_syscall_64
      0.17 ± 44%      +0.2        0.39 ± 26%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.17 ± 45%      +0.2        0.40 ± 17%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.67 ± 44%      +0.3        0.92 ±  8%  perf-profile.children.cycles-pp.kswapd
      0.66 ± 44%      +0.3        0.92 ±  8%  perf-profile.children.cycles-pp.balance_pgdat
      0.18 ± 44%      +0.3        0.46 ± 11%  perf-profile.children.cycles-pp.cmd_record
      0.00            +0.3        0.32 ± 41%  perf-profile.children.cycles-pp.do_sync_mmap_readahead
      0.48 ± 45%      +0.4        0.90 ± 24%  perf-profile.children.cycles-pp.do_rw_once
      0.66 ± 45%      +1.0        1.70 ± 32%  perf-profile.children.cycles-pp.__pi_memset
      0.67 ± 44%      +1.0        1.71 ± 32%  perf-profile.children.cycles-pp.zero_user_segments
      0.72 ± 45%      +1.1        1.79 ± 32%  perf-profile.children.cycles-pp.iomap_read_folio_iter
      0.72 ± 45%      +1.1        1.80 ± 32%  perf-profile.children.cycles-pp.iomap_readahead
      0.72 ± 45%      +1.1        1.80 ± 32%  perf-profile.children.cycles-pp.xfs_vm_readahead
      0.72 ± 45%      +1.1        1.80 ± 32%  perf-profile.children.cycles-pp.read_pages
      0.06 ± 82%      +2.6        2.69 ± 59%  perf-profile.children.cycles-pp.list_lru_add
      0.06 ± 80%      +2.6        2.71 ± 58%  perf-profile.children.cycles-pp.list_lru_add_obj
      0.06 ± 80%      +2.6        2.71 ± 58%  perf-profile.children.cycles-pp.workingset_update_node
      0.11 ± 53%      +2.7        2.80 ± 56%  perf-profile.children.cycles-pp.__filemap_remove_folio
      0.13 ± 51%      +2.7        2.86 ± 54%  perf-profile.children.cycles-pp.xas_store
      0.66 ± 48%      +3.9        4.59 ± 60%  perf-profile.children.cycles-pp._raw_spin_lock
      0.13 ± 52%      +4.0        4.16 ± 69%  perf-profile.children.cycles-pp.__remove_mapping
      0.23 ± 46%      +5.2        5.43 ± 13%  perf-profile.children.cycles-pp.pte_alloc_one
      0.23 ± 46%      +5.3        5.50 ± 13%  perf-profile.children.cycles-pp.alloc_pages_noprof
      0.56 ± 45%      +6.1        6.62 ± 22%  perf-profile.children.cycles-pp.page_cache_ra_unbounded
     66.92 ± 44%     +21.5       88.41 ±  5%  perf-profile.children.cycles-pp.__alloc_pages_slowpath
      2.94 ±150%     +33.3       36.24 ± 60%  perf-profile.children.cycles-pp.__list_lru_walk_one
      2.94 ±150%     +33.3       36.24 ± 60%  perf-profile.children.cycles-pp.list_lru_walk_one_irq
      3.01 ±146%     +33.8       36.80 ± 59%  perf-profile.children.cycles-pp.do_shrink_slab
      3.03 ±145%     +33.8       36.85 ± 58%  perf-profile.children.cycles-pp.shrink_slab_memcg
     18.54 ± 49%     +33.9       52.40 ± 26%  perf-profile.children.cycles-pp._raw_spin_lock_irq
     39.40 ± 45%     +37.7       77.05 ± 12%  perf-profile.children.cycles-pp.do_try_to_free_pages
     39.51 ± 45%     +37.7       77.22 ± 12%  perf-profile.children.cycles-pp.try_to_free_pages
     40.04 ± 45%     +37.8       77.86 ± 12%  perf-profile.children.cycles-pp.shrink_many
     40.04 ± 45%     +37.8       77.86 ± 12%  perf-profile.children.cycles-pp.shrink_one
     40.05 ± 45%     +37.9       77.96 ± 12%  perf-profile.children.cycles-pp.shrink_node
      0.06 ± 45%      +0.1        0.12 ± 23%  perf-profile.self.cycles-pp.get_pte_pfn
      0.00            +0.1        0.07 ± 24%  perf-profile.self.cycles-pp.page_vma_mapped_walk
      0.00            +0.1        0.08 ±  8%  perf-profile.self.cycles-pp._raw_spin_lock_irq
      0.09 ± 45%      +0.2        0.25 ± 34%  perf-profile.self.cycles-pp.__mod_zone_page_state
      0.40 ± 45%      +0.3        0.74 ± 23%  perf-profile.self.cycles-pp.do_rw_once
      0.66 ± 45%      +1.0        1.69 ± 32%  perf-profile.self.cycles-pp.__pi_memset
      0.35 ±132%   +2076.7%       7.53 ±180%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read.do_syscall_64
      2.28 ± 56%     -82.0%       0.41 ± 71%  perf-sched.sch_delay.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ±144%  +21609.1%       0.80 ±120%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork.[unknown]
      0.00 ±122%  +21950.0%       0.74 ±166%  perf-sched.sch_delay.avg.ms.irqentry_exit.asm_exc_page_fault.[unknown].[unknown].[unknown]
      3.08 ± 11%    +243.5%      10.57 ±114%  perf-sched.sch_delay.avg.ms.irqentry_exit.asm_exc_page_fault.do_access
      2.68 ± 27%    +914.4%      27.23 ±190%  perf-sched.sch_delay.avg.ms.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_rw_once
      0.96 ±153%    +487.1%       5.62 ± 23%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.01 ±176%  +34342.4%       3.79 ± 36%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab
      2.72 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pageblock_pfn_to_page.isolate_migratepages.compact_zone
      2.92 ± 19%    +616.4%      20.90 ±166%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pi_memset.zero_user_segments.iomap_read_folio_iter
      0.46 ±222%    +760.5%       3.98 ± 55%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__list_lru_walk_one.list_lru_walk_one_irq
      2.90 ± 18%    +152.7%       7.33 ± 84%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      2.95 ± 17%    +268.1%      10.86 ±121%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.free_one_page.free_unref_folios
      2.65 ± 11%     -86.5%       0.36 ±223%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.isolate_migratepages_block.isolate_migratepages
      2.64 ± 21%    +163.7%       6.95 ± 72%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
      0.59 ±223%    +601.3%       4.12 ± 23%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.filemap_add_folio.page_cache_ra_order.filemap_fault
      2.04 ± 74%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_pfnblock_migratetype.isolate_migratepages.compact_zone
      1.91 ± 51%     -91.4%       0.17 ±223%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages_block.isolate_migratepages.compact_zone
      0.00 ±223%  +1.1e+05%       2.57 ± 59%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.mem_cgroup_get_nr_swap_pages.get_swappiness.lruvec_is_sizable
      0.01 ±151%  +1.2e+05%      10.28 ±165%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_charge_memcg.charge_memcg.__mem_cgroup_charge
      2.19 ± 54%     +65.5%       3.62 ± 22%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_to_shrink_lruvec.shrink_one.shrink_many
      0.16 ± 71%    +326.3%       0.67 ± 33%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      0.23 ± 83%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      0.01 ±223%   +3072.1%       0.23 ± 78%  perf-sched.sch_delay.avg.ms.preempt_schedule_irq.asm_sysvec_call_function_single._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      2.70 ± 23%    +528.7%      17.00 ±145%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
      2.58 ± 24%    +452.3%      14.24 ±127%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk._raw_spin_unlock.__remove_mapping.shrink_folio_list.evict_folios
      2.55 ± 25%    +192.4%       7.46 ± 76%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
      1.64 ± 63%    +235.5%       5.49 ± 56%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
      0.95 ± 70%     -99.8%       0.00 ±223%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.__folio_split.migrate_pages_batch
      3.09 ± 13%    +454.1%      17.13 ±151%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
      2.58 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.lru_add_drain.compact_zone.compact_zone_order.try_to_compact_pages
      0.00 ±223%  +98600.0%       2.63 ± 33%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.up_read.folio_referenced.shrink_folio_list.evict_folios
      0.98 ±112%    +395.3%       4.84 ± 19%  perf-sched.sch_delay.avg.ms.preempt_schedule_thunk.up_read.page_cache_ra_order.filemap_fault.__do_fault
    339.27 ±140%   +1967.5%       7014 ±171%  perf-sched.sch_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read.do_syscall_64
      3.76 ± 68%     -81.4%       0.70 ± 73%  perf-sched.sch_delay.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ±144%  +60022.7%       2.20 ±137%  perf-sched.sch_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork.[unknown]
      0.01 ±130%  +64272.7%       3.54 ±187%  perf-sched.sch_delay.max.ms.irqentry_exit.asm_exc_page_fault.[unknown].[unknown].[unknown]
     89.07 ± 99%   +9506.3%       8556 ±120%  perf-sched.sch_delay.max.ms.irqentry_exit.asm_exc_page_fault.do_access
      6.34 ± 28%  +61338.0%       3893 ±217%  perf-sched.sch_delay.max.ms.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_rw_once
      0.96 ±153%    +812.5%       8.74 ± 44%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.01 ±176%  +53942.4%       5.94 ± 46%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab
      7.02 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pageblock_pfn_to_page.isolate_migratepages.compact_zone
     22.48 ±125%  +26100.5%       5891 ±186%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pi_memset.zero_user_segments.iomap_read_folio_iter
      5.49 ± 38%    +102.5%      11.11 ± 22%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__filemap_add_folio.filemap_add_folio
      0.93 ±222%  +24644.3%     229.46 ±213%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__list_lru_walk_one.list_lru_walk_one_irq
     56.12 ±162%  +20549.2%      11588 ±129%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      4.35 ± 50%     -84.7%       0.66 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.fast_isolate_freepages.isolate_freepages
      6.03 ± 20%     -88.3%       0.70 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.isolate_migratepages_block.isolate_migratepages
     81.64 ±103%   +3507.1%       2944 ±124%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
      0.59 ±223%    +932.1%       6.07 ± 44%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.filemap_add_folio.page_cache_ra_order.filemap_fault
      0.67 ±223%    +541.5%       4.27 ± 48%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.free_tail_page_prepare.free_unref_folios.shrink_folio_list
      4.37 ± 60%    +147.6%      10.82 ± 34%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      5.25 ± 20%     -85.5%       0.76 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath
     79.79 ±193%     -97.1%       2.32 ±152%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_pfnblock_bit.isolate_migratepages.compact_zone
      3.48 ± 47%    -100.0%       0.00        perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_pfnblock_migratetype.isolate_migratepages.compact_zone
      4.04 ± 47%     +98.8%       8.03 ± 21%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.ifs_free.iomap_release_folio.shrink_folio_list
      6.07 ± 24%     +83.1%      11.12 ± 21%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.iomap_set_range_uptodate.iomap_read_folio_iter.iomap_readahead
     44.30 ±152%     -97.5%       1.12 ±141%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages.compact_zone.compact_zone_order
      3.97 ± 38%     -95.8%       0.17 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages_block.isolate_migratepages.compact_zone
      0.00 ±223%  +1.6e+05%       3.66 ± 54%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.mem_cgroup_get_nr_swap_pages.get_swappiness.lruvec_is_sizable
      6.51 ± 30%     -92.1%       0.52 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.pageblock_skip_persistent.isolate_migratepages.compact_zone
      0.73 ±223%    +812.8%       6.62 ± 30%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.shrink_slab_memcg.shrink_one.shrink_many
      0.01 ±151%  +5.7e+05%      50.64 ±203%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_charge_memcg.charge_memcg.__mem_cgroup_charge
      2.84 ± 53%    +140.7%       6.84 ± 21%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_to_shrink_lruvec.shrink_one.shrink_many
      4.21 ± 62%    +128.7%       9.62 ± 29%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.zero_user_segments.iomap_read_folio_iter.iomap_readahead
      1.86 ± 95%    +331.2%       8.04 ±  6%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      0.96 ±221%  +10189.5%      99.17 ±196%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      1.19 ±124%    -100.0%       0.00        perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      0.01 ±223%  +21781.4%       1.57 ±100%  perf-sched.sch_delay.max.ms.preempt_schedule_irq.asm_sysvec_call_function_single._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
     27.51 ± 57%  +27295.5%       7536 ±149%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
      7.26 ± 12%  +1.5e+05%      10542 ±137%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.__remove_mapping.shrink_folio_list.evict_folios
     39.08 ±103%   +9665.4%       3816 ±103%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
     46.77 ±147%  +18053.7%       8490 ±150%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
      0.93 ±222%    +631.9%       6.83 ± 44%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.shrink_one.shrink_many.shrink_node
      1432 ± 33%     +73.6%       2487 ± 32%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity.sched_setaffinity
      3.80 ± 57%     -99.9%       0.00 ±223%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.__folio_split.migrate_pages_batch
      1.65 ±103%    +344.5%       7.31 ± 36%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.do_shrink_slab.shrink_slab_memcg.shrink_one.shrink_many
      6.70 ± 23%    -100.0%       0.00        perf-sched.sch_delay.max.ms.preempt_schedule_thunk.lru_add_drain.compact_zone.compact_zone_order.try_to_compact_pages
      3.79 ± 46%    +166.5%      10.11 ± 23%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.lru_add_drain.shrink_node.do_try_to_free_pages.try_to_free_pages
      8.75 ± 28%  +86401.8%       7566 ±165%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.rmqueue.isra.0.get_page_from_freelist
      0.00 ±223%  +1.6e+05%       4.21 ± 13%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.up_read.folio_referenced.shrink_folio_list.evict_folios
      1.87 ±111%    +329.6%       8.05 ± 19%  perf-sched.sch_delay.max.ms.preempt_schedule_thunk.up_read.page_cache_ra_order.filemap_fault.__do_fault
      1.94 ± 20%    +294.0%       7.66 ±110%  perf-sched.total_sch_delay.average.ms
      2012 ± 62%    +652.2%      15139 ± 87%  perf-sched.total_sch_delay.max.ms
     35903 ± 22%    +230.3%     118571 ± 12%  perf-sched.total_wait_and_delay.count.ms
      4690 ±  9%    +519.5%      29056 ± 92%  perf-sched.total_wait_and_delay.max.ms
      4466 ± 14%    +365.2%      20776 ± 64%  perf-sched.total_wait_time.max.ms
      4.00 ± 76%    +161.4%      10.45 ± 40%  perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown].[unknown]
      6.15 ± 11%    +244.5%      21.20 ±114%  perf-sched.wait_and_delay.avg.ms.irqentry_exit.asm_exc_page_fault.do_access
      5.80 ± 18%    +165.8%      15.41 ± 80%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      1.45 ±144%   +1117.3%      17.68 ±104%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      5.90 ± 17%    +294.7%      23.28 ±114%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.free_one_page.free_unref_folios
      5.27 ± 21%    +178.6%      14.68 ± 66%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
      5.80 ± 18%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages.compact_zone.compact_zone_order
      5.41 ± 23%    +530.1%      34.08 ±144%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
      5.10 ± 25%    +200.5%      15.33 ± 76%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
      1.36 ±146%    +722.0%      11.14 ± 55%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
      5.99 ± 15%    +489.3%      35.33 ±147%  perf-sched.wait_and_delay.avg.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
    301.42 ± 14%     +64.7%     496.31 ± 31%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork.ret_from_fork_asm
    828.41 ± 10%     +85.9%       1539 ± 40%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    764.43 ±  3%     +32.5%       1012 ± 20%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1198 ± 42%    +113.4%       2557 ± 39%  perf-sched.wait_and_delay.count.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.33 ±141%    +900.0%       3.33 ± 47%  perf-sched.wait_and_delay.count.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork.[unknown]
      3616 ± 43%    +300.6%      14486 ± 37%  perf-sched.wait_and_delay.count.irqentry_exit.asm_exc_page_fault.do_access
      2990 ± 37%    +347.1%      13370 ± 44%  perf-sched.wait_and_delay.count.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
    251.33 ±159%   +8845.0%      22481 ± 28%  perf-sched.wait_and_delay.count.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      1828 ± 62%     -99.9%       1.17 ± 91%  perf-sched.wait_and_delay.count.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      3299 ± 36%     -54.5%       1502 ± 31%  perf-sched.wait_and_delay.count.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
    571.17 ± 50%    -100.0%       0.00        perf-sched.wait_and_delay.count.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages.compact_zone.compact_zone_order
    658.67 ± 42%    +401.1%       3300 ± 44%  perf-sched.wait_and_delay.count.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
    874.33 ± 37%    +272.0%       3252 ± 42%  perf-sched.wait_and_delay.count.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
    527.50 ±174%    +856.1%       5043 ± 31%  perf-sched.wait_and_delay.count.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
      1564 ± 25%    +136.3%       3696 ± 14%  perf-sched.wait_and_delay.count.preempt_schedule_thunk.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity.sched_setaffinity
      2075 ± 35%    +306.7%       8441 ± 34%  perf-sched.wait_and_delay.count.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
     21.67 ±  7%    +148.5%      53.83 ± 23%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
     36.17 ± 21%    +254.4%     128.17 ± 29%  perf-sched.wait_and_delay.count.schedule_timeout.kcompactd.kthread.ret_from_fork.ret_from_fork_asm
    760.50 ± 10%    +236.0%       2555 ± 37%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread.ret_from_fork
      2817 ± 17%    +220.6%       9034 ± 14%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2789 ±  7%    +183.5%       7906 ± 21%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      2343 ± 29%    +779.9%      20621 ±107%  perf-sched.wait_and_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read.do_syscall_64
      1707 ± 68%    +921.0%      17430 ±130%  perf-sched.wait_and_delay.max.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
    333.96 ±141%    +202.1%       1008        perf-sched.wait_and_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork.[unknown]
    178.14 ± 99%   +9555.4%      17199 ±119%  perf-sched.wait_and_delay.max.ms.irqentry_exit.asm_exc_page_fault.do_access
    458.02 ± 95%   +3646.8%      17161 ±105%  perf-sched.wait_and_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
    108.49 ±169%  +21384.3%      23308 ±128%  perf-sched.wait_and_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
    408.64 ±119%   +4416.9%      18457 ±132%  perf-sched.wait_and_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.free_one_page.free_unref_folios
    163.28 ±103%   +3556.7%       5970 ±122%  perf-sched.wait_and_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
     88.59 ±152%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages.compact_zone.compact_zone_order
     55.02 ± 57%  +27127.7%      14981 ±151%  perf-sched.wait_and_delay.max.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
     78.15 ±103%   +9834.3%       7764 ±100%  perf-sched.wait_and_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
     88.18 ±159%  +19156.1%      16980 ±150%  perf-sched.wait_and_delay.max.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
    490.98 ± 88%   +3975.8%      20011 ±127%  perf-sched.wait_and_delay.max.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
      4077 ± 27%    +413.3%      20931 ± 63%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2876 ± 30%    +626.3%      20889 ±105%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      2.88 ±127%   +2750.6%      82.08 ±146%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      3.98 ± 76%    +161.0%      10.39 ± 39%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown].[unknown]
      0.20 ±220%  +49316.2%      98.50 ±102%  perf-sched.wait_time.avg.ms.irqentry_exit.asm_exc_page_fault.[unknown]
      3.08 ± 11%    +245.5%      10.63 ±114%  perf-sched.wait_time.avg.ms.irqentry_exit.asm_exc_page_fault.do_access
      2.68 ± 27%    +938.3%      27.87 ±185%  perf-sched.wait_time.avg.ms.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_rw_once
      0.96 ±153%    +487.1%       5.62 ± 23%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.01 ±176%  +34342.4%       3.79 ± 36%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab
      2.72 ± 28%    -100.0%       0.00        perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pageblock_pfn_to_page.isolate_migratepages.compact_zone
      2.92 ± 19%    +619.3%      20.98 ±165%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pi_memset.zero_user_segments.iomap_read_folio_iter
      0.46 ±222%    +760.5%       3.98 ± 55%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__list_lru_walk_one.list_lru_walk_one_irq
      2.90 ± 18%    +178.8%       8.08 ± 78%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      3.38 ±  5%  +14915.6%     508.18 ± 90%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      2.95 ± 17%    +321.2%      12.42 ±108%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.free_one_page.free_unref_folios
      7.82 ±144%     -95.5%       0.35 ±223%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.isolate_migratepages_block.isolate_migratepages
      2.64 ± 21%    +193.5%       7.73 ± 60%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
      0.59 ±223%    +601.3%       4.12 ± 23%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.filemap_add_folio.page_cache_ra_order.filemap_fault
      2.04 ± 74%    -100.0%       0.00        perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_pfnblock_migratetype.isolate_migratepages.compact_zone
      0.00 ±223%  +1.1e+05%       2.57 ± 59%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.mem_cgroup_get_nr_swap_pages.get_swappiness.lruvec_is_sizable
      0.01 ±151%  +2.6e+05%      23.33 ±132%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_charge_memcg.charge_memcg.__mem_cgroup_charge
      2.19 ± 54%     +65.5%       3.62 ± 22%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_to_shrink_lruvec.shrink_one.shrink_many
      0.16 ± 71%   +1256.7%       2.12 ±119%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      0.23 ± 83%    -100.0%       0.00        perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      0.01 ±223%   +3072.1%       0.23 ± 78%  perf-sched.wait_time.avg.ms.preempt_schedule_irq.asm_sysvec_call_function_single._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      2.70 ± 23%    +531.6%      17.08 ±144%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
      2.58 ± 24%    +478.9%      14.94 ±123%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk._raw_spin_unlock.__remove_mapping.shrink_folio_list.evict_folios
      2.55 ± 25%    +208.5%       7.87 ± 77%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
      1.64 ± 63%    +245.1%       5.65 ± 54%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
     78.31 ± 84%    -100.0%       0.00 ±223%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.__folio_split.migrate_pages_batch
      2.90 ± 17%    +526.8%      18.19 ±143%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
      2.58 ± 39%    -100.0%       0.00        perf-sched.wait_time.avg.ms.preempt_schedule_thunk.lru_add_drain.compact_zone.compact_zone_order.try_to_compact_pages
      0.00 ±223%  +98600.0%       2.63 ± 33%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk.up_read.folio_referenced.shrink_folio_list.evict_folios
      0.98 ±112%    +395.3%       4.84 ± 19%  perf-sched.wait_time.avg.ms.preempt_schedule_thunk.up_read.page_cache_ra_order.filemap_fault.__do_fault
    382.14 ±  5%     +32.0%     504.29 ± 27%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait.do_syscall_64
    281.52 ± 10%     +64.2%     462.15 ± 20%  perf-sched.wait_time.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork.ret_from_fork_asm
      2.14 ± 44%    +701.7%      17.13 ± 57%  perf-sched.wait_time.avg.ms.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork.do_syscall_64
    828.14 ± 10%     +85.7%       1538 ± 40%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    762.80 ±  3%     +32.4%       1009 ± 20%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      2343 ± 29%    +616.6%      16794 ± 84%  perf-sched.wait_time.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read.do_syscall_64
      1198 ± 33%    +782.4%      10576 ±104%  perf-sched.wait_time.max.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.59 ± 27%  +1.1e+05%       4003 ±179%  perf-sched.wait_time.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep.do_syscall_64
    189.04 ±197%   +5328.0%      10260 ±130%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    333.96 ±141%    +201.9%       1008        perf-sched.wait_time.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe._Fork.[unknown]
      0.31 ±221%  +1.6e+05%     500.92 ± 99%  perf-sched.wait_time.max.ms.irqentry_exit.asm_exc_page_fault.[unknown]
     89.07 ± 99%   +9620.1%       8657 ±117%  perf-sched.wait_time.max.ms.irqentry_exit.asm_exc_page_fault.do_access
      6.34 ± 28%  +63255.5%       4014 ±209%  perf-sched.wait_time.max.ms.irqentry_exit.asm_sysvec_apic_timer_interrupt.do_rw_once
      0.96 ±153%    +812.5%       8.74 ± 44%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.01 ±176%  +53942.4%       5.94 ± 46%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__list_lru_walk_one.list_lru_walk_one_irq.do_shrink_slab
      7.02 ± 36%    -100.0%       0.00        perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pageblock_pfn_to_page.isolate_migratepages.compact_zone
     22.48 ±125%  +26120.7%       5895 ±186%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.__pi_memset.zero_user_segments.iomap_read_folio_iter
      5.49 ± 38%    +102.5%      11.11 ± 22%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__filemap_add_folio.filemap_add_folio
      0.93 ±222%  +24644.3%     229.46 ±213%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.__list_lru_walk_one.list_lru_walk_one_irq
    229.01 ± 95%   +3731.2%       8773 ±102%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
     56.12 ±162%  +20815.2%      11737 ±126%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
    227.62 ±154%     -99.7%       0.66 ±223%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.fast_isolate_freepages.isolate_freepages
    204.32 ±119%   +4886.0%      10187 ±118%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.free_one_page.free_unref_folios
     51.78 ±196%     -98.6%       0.70 ±223%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.isolate_migratepages_block.isolate_migratepages
     81.64 ±103%   +3640.4%       3053 ±117%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.rmqueue.isra
      0.59 ±223%    +932.1%       6.07 ± 44%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.filemap_add_folio.page_cache_ra_order.filemap_fault
      0.67 ±223%    +541.5%       4.27 ± 48%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.free_tail_page_prepare.free_unref_folios.shrink_folio_list
      4.37 ± 60%    +147.6%      10.82 ± 34%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      5.25 ± 20%     -85.5%       0.76 ±223%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath
      3.48 ± 47%    -100.0%       0.00        perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.get_pfnblock_migratetype.isolate_migratepages.compact_zone
      4.04 ± 47%     +98.8%       8.03 ± 21%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.ifs_free.iomap_release_folio.shrink_folio_list
      6.07 ± 24%     +83.1%      11.12 ± 21%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.iomap_set_range_uptodate.iomap_read_folio_iter.iomap_readahead
     44.30 ±152%     -97.5%       1.12 ±141%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.isolate_migratepages.compact_zone.compact_zone_order
      0.00 ±223%  +1.6e+05%       3.66 ± 54%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.mem_cgroup_get_nr_swap_pages.get_swappiness.lruvec_is_sizable
      6.51 ± 30%     -92.1%       0.52 ±223%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.pageblock_skip_persistent.isolate_migratepages.compact_zone
      0.73 ±223%    +812.8%       6.62 ± 30%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.shrink_slab_memcg.shrink_one.shrink_many
      0.01 ±151%    +1e+06%      89.04 ±134%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_charge_memcg.charge_memcg.__mem_cgroup_charge
      2.84 ± 53%    +140.7%       6.84 ± 21%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.try_to_shrink_lruvec.shrink_one.shrink_many
      4.21 ± 62%    +128.7%       9.62 ± 29%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_apic_timer_interrupt.zero_user_segments.iomap_read_folio_iter.iomap_readahead
      1.86 ± 95%  +13900.2%     260.94 ±146%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.evict_folios.try_to_shrink_lruvec
      0.96 ±221%  +10025.0%      97.59 ±195%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
      1.19 ±124%    -100.0%       0.00        perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_call_function._raw_spin_unlock_irqrestore.fast_find_migrateblock.isolate_migratepages
      0.01 ±223%  +21781.4%       1.57 ±100%  perf-sched.wait_time.max.ms.preempt_schedule_irq.asm_sysvec_call_function_single._raw_spin_unlock_irq.shadow_lru_isolate.__list_lru_walk_one
     27.51 ± 57%  +27256.9%       7526 ±149%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.__folio_batch_add_and_move.filemap_add_folio.page_cache_ra_order.filemap_fault
      7.26 ± 12%  +1.5e+05%      10707 ±133%  perf-sched.wait_time.max.ms.preempt_schedule_thunk._raw_spin_unlock.__remove_mapping.shrink_folio_list.evict_folios
     37.22 ±155%    +756.9%     318.92 ± 28%  perf-sched.wait_time.max.ms.preempt_schedule_thunk._raw_spin_unlock.drain_pages_zone.__drain_all_pages.part
     39.08 ±103%  +10049.0%       3965 ± 96%  perf-sched.wait_time.max.ms.preempt_schedule_thunk._raw_spin_unlock.page_vma_mapped_walk.folio_referenced_one.__rmap_walk_file
     46.77 ±147%  +18055.0%       8490 ±150%  perf-sched.wait_time.max.ms.preempt_schedule_thunk._raw_spin_unlock.shadow_lru_isolate.__list_lru_walk_one.list_lru_walk_one_irq
      0.93 ±222%    +631.9%       6.83 ± 44%  perf-sched.wait_time.max.ms.preempt_schedule_thunk._raw_spin_unlock.shrink_one.shrink_many.shrink_node
    253.78 ± 72%    -100.0%       0.00 ±223%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.__folio_split.migrate_pages_batch
    157.20 ±147%   +6372.5%      10174 ±123%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
      3.80 ±104%  +13113.4%     501.80 ± 99%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.migrate_task_to.task_numa_migrate
      0.49 ±222%    +524.9%       3.07 ± 94%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.cpu_stop_queue_work.stop_one_cpu.sched_exec.bprm_execve
      1.65 ±103%    +344.5%       7.31 ± 36%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.do_shrink_slab.shrink_slab_memcg.shrink_one.shrink_many
      6.70 ± 23%    -100.0%       0.00        perf-sched.wait_time.max.ms.preempt_schedule_thunk.lru_add_drain.compact_zone.compact_zone_order.try_to_compact_pages
      3.79 ± 46%  +17648.9%     673.51 ± 69%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.lru_add_drain.shrink_node.do_try_to_free_pages.try_to_free_pages
    175.03 ±211%   +4829.3%       8627 ±151%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.rmqueue.isra.0.get_page_from_freelist
      0.00 ±223%  +1.6e+05%       4.21 ± 13%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.up_read.folio_referenced.shrink_folio_list.evict_folios
      1.87 ±111%    +329.6%       8.05 ± 19%  perf-sched.wait_time.max.ms.preempt_schedule_thunk.up_read.page_cache_ra_order.filemap_fault.__do_fault
    363.72 ± 25%    +451.3%       2005 ±107%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.drain_all_pages
     37.74 ± 63%   +3561.9%       1382 ±109%  perf-sched.wait_time.max.ms.schedule_timeout.wait_for_completion_state.kernel_clone.__x64_sys_vfork.do_syscall_64
      4076 ± 27%    +407.0%      20666 ± 64%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2452 ± 29%    +569.5%      16418 ± 75%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm


***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/lkp-cpl-4sp2/lru-file-mmap-read/vm-scalability

commit: 
  d17f02417a ("mm/rmap: separate out fork-only logic on anon_vma_clone()")
  6698721815 ("mm/page_alloc: ignore the exact initial compaction result")

d17f02417a337de0 66987218154918a6341a3e3eeee 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    124025 ± 11%     +79.3%     222388        vm-scalability.median
    771.19 ± 24%    +502.6        1273 ± 11%  vm-scalability.stddev%
  28184862 ± 12%     +77.1%   49917865        vm-scalability.throughput
    197.56 ±  8%     -38.8%     120.95        vm-scalability.time.elapsed_time
    197.56 ±  8%     -38.8%     120.95        vm-scalability.time.elapsed_time.max
    465529 ± 12%     -40.0%     279493 ±  9%  vm-scalability.time.involuntary_context_switches
    194874 ± 29%     -79.4%      40132 ±  7%  vm-scalability.time.major_page_faults
   3436532 ±  7%     +52.5%    5239000 ±  8%  vm-scalability.time.maximum_resident_set_size
  38870744 ±  2%     -11.9%   34261089        vm-scalability.time.minor_page_faults
     18928 ±  3%      -9.0%      17231        vm-scalability.time.percent_of_cpu_this_job_got
     35863 ± 11%     -46.9%      19059        vm-scalability.time.system_time
      1630 ±  2%      +9.5%       1784        vm-scalability.time.user_time
    250.21 ±  6%     -30.8%     173.26        uptime.boot
      2.06 ± 17%     -33.1%       1.38 ± 17%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      2.06 ± 17%     -33.1%       1.38 ± 17%  perf-sched.total_sch_delay.average.ms
     20617 ± 31%     +62.0%      33392 ± 14%  perf-sched.total_wait_and_delay.count.ms
     20617 ± 31%     +62.0%      33392 ± 14%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     13.97 ± 20%     +58.3%      22.11 ±  3%  vmstat.cpu.id
      0.08 ±  9%     +60.3%       0.13        vmstat.memory.buff
  15976323 ±  3%     +21.3%   19375377 ±  2%  vmstat.memory.free
    199.30 ±  2%      -9.6%     180.22        vmstat.procs.r
     13.23 ± 19%      +7.6       20.82 ±  2%  mpstat.cpu.all.idle%
      0.71 ±  5%      +0.3        1.04 ±  2%  mpstat.cpu.all.irq%
      0.06 ± 10%      +0.1        0.12 ±  9%  mpstat.cpu.all.soft%
     82.11 ±  3%     -10.8       71.29        mpstat.cpu.all.sys%
      3.89 ±  5%      +2.9        6.74        mpstat.cpu.all.usr%
      3280 ±  3%      -8.8%       2991        turbostat.Avg_MHz
     86.72 ±  3%      -7.7       78.97        turbostat.Busy%
     13.40 ± 20%      +7.8       21.25 ±  2%  turbostat.C1%
     13.28 ± 20%     +58.4%      21.03 ±  2%  turbostat.CPU%c1
      0.17 ±  6%     +12.6%       0.19 ±  2%  turbostat.IPC
 1.587e+08 ±  3%     -34.0%  1.048e+08 ±  3%  turbostat.IRQ
   4627022 ± 43%     -99.9%       2726 ±100%  turbostat.NMI
      0.02 ± 38%      +1.4        1.47 ± 64%  turbostat.PKG_%
     28.40 ±  2%     +18.7%      33.71        turbostat.RAMWatt
      3.19 ± 16%     +41.1%       4.51 ±  3%  perf-stat.i.MPKI
 5.234e+10 ±  6%      +7.5%  5.628e+10        perf-stat.i.branch-instructions
      0.18 ± 12%      +0.1        0.27 ± 25%  perf-stat.i.branch-miss-rate%
  64751254 ±  3%     +20.8%   78195402 ±  2%  perf-stat.i.branch-misses
     64.26 ±  4%      +6.9       71.19        perf-stat.i.cache-miss-rate%
  5.59e+08 ±  6%     +44.1%  8.054e+08        perf-stat.i.cache-misses
 8.465e+08 ±  3%     +33.5%   1.13e+09        perf-stat.i.cache-references
      3.78 ±  6%     -17.2%       3.13 ±  2%  perf-stat.i.cpi
 7.297e+11 ±  3%     -10.8%  6.509e+11        perf-stat.i.cpu-cycles
      1401 ± 10%     -46.2%     754.56        perf-stat.i.cycles-between-cache-misses
      0.31 ±  3%     +20.2%       0.38 ±  3%  perf-stat.i.ipc
    934.45 ± 45%     -66.7%     310.71 ±  7%  perf-stat.i.major-faults
      1.04 ± 45%    +127.3%       2.36        perf-stat.i.metric.K/sec
    195250 ± 12%     +43.1%     279467        perf-stat.i.minor-faults
    196184 ± 12%     +42.6%     279778        perf-stat.i.page-faults
      3.00 ± 15%     +38.4%       4.15        perf-stat.overall.MPKI
     66.13 ±  3%      +5.2       71.31        perf-stat.overall.cache-miss-rate%
      3.87 ±  5%     -11.7%       3.42 ±  2%  perf-stat.overall.cpi
      1309 ±  8%     -37.0%     824.44        perf-stat.overall.cycles-between-cache-misses
      0.26 ±  5%     +12.9%       0.29 ±  2%  perf-stat.overall.ipc
      7898 ± 14%     -37.3%       4953        perf-stat.overall.path-length
 5.238e+10 ±  6%      +8.2%  5.667e+10        perf-stat.ps.branch-instructions
  64488959 ±  3%     +20.7%   77841014        perf-stat.ps.branch-misses
 5.645e+08 ±  6%     +43.8%  8.117e+08        perf-stat.ps.cache-misses
 8.529e+08 ±  2%     +33.5%  1.138e+09        perf-stat.ps.cache-references
 7.352e+11 ±  3%      -9.0%  6.691e+11        perf-stat.ps.cpu-cycles
      1016 ± 42%     -67.7%     328.23 ±  8%  perf-stat.ps.major-faults
    198400 ± 12%     +41.8%     281261        perf-stat.ps.minor-faults
    199416 ± 12%     +41.2%     281589        perf-stat.ps.page-faults
 3.817e+13 ± 14%     -37.3%  2.394e+13        perf-stat.total.instructions
     79.63 ± 44%     -79.6        0.00        perf-profile.calltrace.cycles-pp.do_access
     78.44 ± 44%     -78.4        0.00        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.do_access
     78.42 ± 44%     -78.4        0.00        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.do_access
     78.42 ± 44%     -78.4        0.00        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     78.39 ± 44%     -78.4        0.00        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.do_access
     77.99 ± 44%     -78.0        0.00        perf-profile.calltrace.cycles-pp.__do_fault.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault
     77.99 ± 44%     -78.0        0.00        perf-profile.calltrace.cycles-pp.filemap_fault.__do_fault.do_read_fault.do_fault.__handle_mm_fault
     78.31 ± 44%     -77.8        0.48 ±223%  perf-profile.calltrace.cycles-pp.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
     77.44 ± 44%     -77.4        0.00        perf-profile.calltrace.cycles-pp.page_cache_ra_order.filemap_fault.__do_fault.do_read_fault.do_fault
     78.37 ± 44%     -77.4        0.95 ±223%  perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
     72.38 ± 44%     -72.4        0.00        perf-profile.calltrace.cycles-pp.folio_alloc_noprof.page_cache_ra_order.filemap_fault.__do_fault.do_read_fault
     72.37 ± 44%     -72.4        0.00        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_order.filemap_fault.__do_fault
     72.37 ± 44%     -72.4        0.00        perf-profile.calltrace.cycles-pp.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_order.filemap_fault
     65.68 ± 44%     -65.7        0.00        perf-profile.calltrace.cycles-pp.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_order
     34.14 ± 44%     -34.1        0.00        perf-profile.calltrace.cycles-pp.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
     27.35 ± 44%     -27.4        0.00        perf-profile.calltrace.cycles-pp.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
     27.32 ± 44%     -27.3        0.00        perf-profile.calltrace.cycles-pp.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
     27.31 ± 44%     -27.3        0.00        perf-profile.calltrace.cycles-pp.compact_zone.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact.__alloc_pages_slowpath
     26.91 ± 44%     -26.9        0.00        perf-profile.calltrace.cycles-pp.isolate_migratepages.compact_zone.compact_zone_order.try_to_compact_pages.__alloc_pages_direct_compact
     26.48 ± 45%     -26.5        0.00        perf-profile.calltrace.cycles-pp.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
     26.26 ± 45%     -26.3        0.00        perf-profile.calltrace.cycles-pp.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
     26.23 ± 45%     -26.2        0.00        perf-profile.calltrace.cycles-pp.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
     26.20 ± 45%     -26.2        0.00        perf-profile.calltrace.cycles-pp.shrink_many.shrink_node.do_try_to_free_pages.try_to_free_pages.__alloc_pages_slowpath
     26.20 ± 45%     -26.2        0.00        perf-profile.calltrace.cycles-pp.shrink_one.shrink_many.shrink_node.do_try_to_free_pages.try_to_free_pages
     24.74 ± 45%     -24.7        0.00        perf-profile.calltrace.cycles-pp.evict_folios.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node
     23.32 ± 45%     -23.3        0.00        perf-profile.calltrace.cycles-pp.try_to_shrink_lruvec.shrink_one.shrink_many.shrink_node.do_try_to_free_pages
     15.16 ± 45%     -15.2        0.00        perf-profile.calltrace.cycles-pp.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one.shrink_many
     12.58 ± 45%     -12.6        0.00        perf-profile.calltrace.cycles-pp.fast_find_migrateblock.isolate_migratepages.compact_zone.compact_zone_order.try_to_compact_pages
     12.24 ± 45%     -12.2        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.fast_find_migrateblock.isolate_migratepages.compact_zone.compact_zone_order
     12.20 ± 45%     -12.2        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.fast_find_migrateblock.isolate_migratepages.compact_zone
      9.21 ± 45%      -9.2        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.evict_folios.try_to_shrink_lruvec.shrink_one.shrink_many
      9.19 ± 45%      -9.2        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.evict_folios.try_to_shrink_lruvec.shrink_one
      6.78 ± 45%      -6.8        0.00        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
      6.73 ± 45%      -6.7        0.00        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
      6.68 ± 45%      -6.7        0.00        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.page_cache_ra_order
      6.66 ± 45%      -6.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact.__alloc_pages_slowpath
      6.65 ± 45%      -6.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_direct_compact
      6.60 ± 45%      -6.6        0.00        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
      6.53 ± 45%      -6.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof.alloc_pages_mpol
      6.52 ± 45%      -6.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_frozen_pages_noprof
      6.42 ± 45%      -6.4        0.00        perf-profile.calltrace.cycles-pp.free_unref_folios.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      6.38 ± 45%      -6.4        0.00        perf-profile.calltrace.cycles-pp.free_one_page.free_unref_folios.shrink_folio_list.evict_folios.try_to_shrink_lruvec
      6.33 ± 45%      -6.3        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.free_one_page.free_unref_folios.shrink_folio_list.evict_folios
      6.31 ± 45%      -6.3        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.free_one_page.free_unref_folios.shrink_folio_list
      4.69 ± 45%      -4.7        0.00        perf-profile.calltrace.cycles-pp.get_page_from_freelist.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof
      4.61 ± 45%      -4.6        0.00        perf-profile.calltrace.cycles-pp.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios.try_to_shrink_lruvec
      4.61 ± 45%      -4.6        0.00        perf-profile.calltrace.cycles-pp.try_to_unmap_flush.shrink_folio_list.evict_folios.try_to_shrink_lruvec.shrink_one
      4.61 ± 45%      -4.6        0.00        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list.evict_folios
      4.61 ± 45%      -4.6        0.00        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.arch_tlbbatch_flush.try_to_unmap_flush.shrink_folio_list
      4.58 ± 45%      -4.6        0.00        perf-profile.calltrace.cycles-pp.rmqueue.get_page_from_freelist.__alloc_pages_slowpath.__alloc_frozen_pages_noprof.alloc_pages_mpol
      4.54 ± 45%      -4.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.__folio_batch_add_and_move
      4.53 ± 45%      -4.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_slowpath.__alloc_frozen_pages_noprof
      4.52 ± 45%      -4.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.rmqueue.get_page_from_freelist.__alloc_pages_slowpath
      0.00            +4.4        4.42 ± 28%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist
      0.00            +4.4        4.42 ± 28%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record
      0.00            +4.4        4.42 ± 28%  perf-profile.calltrace.cycles-pp.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record.run_builtin
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.cmd_record.run_builtin.handle_internal_command.main
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.main
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.perf_mmap__push.record__mmap_read_evlist.cmd_record.run_builtin.handle_internal_command
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.record__mmap_read_evlist.cmd_record.run_builtin.handle_internal_command.main
      0.00            +6.2        6.21 ± 32%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
      0.00            +6.4        6.38 ± 53%  perf-profile.calltrace.cycles-pp.show_interrupts.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read
      0.00            +7.4        7.43 ± 52%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +7.4        7.43 ± 52%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
      0.00            +8.7        8.69 ± 38%  perf-profile.calltrace.cycles-pp.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +8.7        8.69 ± 38%  perf-profile.calltrace.cycles-pp.seq_read_iter.proc_reg_read_iter.vfs_read.ksys_read.do_syscall_64
      0.00           +11.4       11.36 ± 26%  perf-profile.calltrace.cycles-pp.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00           +11.4       11.36 ± 26%  perf-profile.calltrace.cycles-pp.vfs_read.ksys_read.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00           +22.0       21.97 ± 30%  perf-profile.calltrace.cycles-pp.asm_sysvec_reschedule_ipi.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter
      0.00           +27.6       27.59 ± 10%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00           +27.6       27.59 ± 10%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
     79.86 ± 44%     -79.9        0.00        perf-profile.children.cycles-pp.do_access
     78.44 ± 44%     -78.0        0.48 ±223%  perf-profile.children.cycles-pp.do_read_fault
     78.12 ± 44%     -77.6        0.48 ±223%  perf-profile.children.cycles-pp.__do_fault
     78.12 ± 44%     -77.6        0.48 ±223%  perf-profile.children.cycles-pp.filemap_fault
     77.57 ± 44%     -77.6        0.00        perf-profile.children.cycles-pp.page_cache_ra_order
     78.50 ± 44%     -77.5        0.95 ±223%  perf-profile.children.cycles-pp.do_fault
     72.78 ± 44%     -72.8        0.00        perf-profile.children.cycles-pp.folio_alloc_noprof
     73.00 ± 44%     -72.0        1.00 ±141%  perf-profile.children.cycles-pp.alloc_pages_mpol
     73.00 ± 44%     -72.0        1.00 ±141%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
     65.79 ± 44%     -65.8        0.00        perf-profile.children.cycles-pp.__alloc_pages_slowpath
     54.72 ± 44%     -54.7        0.00        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     42.63 ± 43%     -42.6        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     34.20 ± 44%     -34.2        0.00        perf-profile.children.cycles-pp.__alloc_pages_direct_compact
     28.64 ± 35%     -28.6        0.00        perf-profile.children.cycles-pp.compact_zone
     27.73 ± 45%     -27.7        0.00        perf-profile.children.cycles-pp.shrink_node
     27.71 ± 45%     -27.7        0.00        perf-profile.children.cycles-pp.shrink_many
     27.70 ± 45%     -27.7        0.00        perf-profile.children.cycles-pp.shrink_one
     27.40 ± 44%     -27.4        0.00        perf-profile.children.cycles-pp.try_to_compact_pages
     27.37 ± 44%     -27.4        0.00        perf-profile.children.cycles-pp.compact_zone_order
     27.26 ± 44%     -27.3        0.00        perf-profile.children.cycles-pp.isolate_migratepages
     26.53 ± 45%     -26.5        0.00        perf-profile.children.cycles-pp.try_to_free_pages
     26.30 ± 45%     -26.3        0.00        perf-profile.children.cycles-pp.do_try_to_free_pages
     24.81 ± 45%     -24.8        0.00        perf-profile.children.cycles-pp.try_to_shrink_lruvec
     24.78 ± 45%     -24.8        0.00        perf-profile.children.cycles-pp.evict_folios
     18.39 ± 45%     -17.9        0.52 ±223%  perf-profile.children.cycles-pp.rmqueue
     18.68 ± 45%     -17.7        1.00 ±141%  perf-profile.children.cycles-pp.get_page_from_freelist
     15.18 ± 45%     -15.2        0.00        perf-profile.children.cycles-pp.shrink_folio_list
     12.63 ± 45%     -12.6        0.00        perf-profile.children.cycles-pp.fast_find_migrateblock
     11.99 ± 47%     -12.0        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irq
      7.54 ± 14%      -7.1        0.41 ±223%  perf-profile.children.cycles-pp.free_unref_folios
      6.69 ± 41%      -6.7        0.00        perf-profile.children.cycles-pp.free_one_page
      4.97 ± 43%      -5.0        0.00        perf-profile.children.cycles-pp.folio_batch_move_lru
      4.87 ± 43%      -4.9        0.00        perf-profile.children.cycles-pp.__folio_batch_add_and_move
      4.81 ± 45%      -4.8        0.00        perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
      4.68 ± 45%      -4.7        0.00        perf-profile.children.cycles-pp.arch_tlbbatch_flush
      4.68 ± 45%      -4.7        0.00        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
      4.68 ± 45%      -4.7        0.00        perf-profile.children.cycles-pp.smp_call_function_many_cond
      4.68 ± 45%      -4.7        0.00        perf-profile.children.cycles-pp.try_to_unmap_flush
      0.04 ± 73%      +4.4        4.42 ± 28%  perf-profile.children.cycles-pp.record__pushfn
      0.09 ± 20%      +6.1        6.21 ± 32%  perf-profile.children.cycles-pp.handle_internal_command
      0.09 ± 20%      +6.1        6.21 ± 32%  perf-profile.children.cycles-pp.main
      0.09 ± 20%      +6.1        6.21 ± 32%  perf-profile.children.cycles-pp.run_builtin
      0.06 ± 50%      +6.2        6.21 ± 32%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.06 ± 48%      +6.2        6.21 ± 32%  perf-profile.children.cycles-pp.perf_mmap__push
      0.00            +6.4        6.38 ± 53%  perf-profile.children.cycles-pp.show_interrupts
      0.00            +7.4        7.43 ± 52%  perf-profile.children.cycles-pp.do_filp_open
      0.00            +7.4        7.43 ± 52%  perf-profile.children.cycles-pp.do_sys_openat2
      0.00            +7.4        7.43 ± 52%  perf-profile.children.cycles-pp.path_openat
      0.00            +8.0        7.95 ± 49%  perf-profile.children.cycles-pp.__x64_sys_openat
      0.00            +8.7        8.69 ± 38%  perf-profile.children.cycles-pp.proc_reg_read_iter
      0.07 ± 49%     +10.6       10.72 ± 80%  perf-profile.children.cycles-pp.cmd_record
      0.01 ±223%     +11.3       11.36 ± 26%  perf-profile.children.cycles-pp.ksys_read
      0.01 ±223%     +11.3       11.36 ± 26%  perf-profile.children.cycles-pp.vfs_read
      0.00           +11.4       11.36 ± 26%  perf-profile.children.cycles-pp.seq_read_iter
      0.00           +13.9       13.90 ± 41%  perf-profile.children.cycles-pp.arch_do_signal_or_restart
      0.00           +13.9       13.90 ± 41%  perf-profile.children.cycles-pp.get_signal
      0.00           +14.3       14.34 ± 40%  perf-profile.children.cycles-pp.do_exit
      0.00           +14.3       14.34 ± 40%  perf-profile.children.cycles-pp.do_group_exit
      0.00           +15.1       15.05 ± 60%  perf-profile.children.cycles-pp.asm_sysvec_reschedule_ipi
      4.28 ±219%     +45.9       50.21 ± 16%  perf-profile.children.cycles-pp.do_syscall_64
      4.28 ±219%     +45.9       50.21 ± 16%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     54.72 ± 44%     -54.7        0.00        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      9.86 ± 45%      -9.9        0.00        perf-profile.self.cycles-pp.isolate_migratepages
      4.64 ± 45%      -4.6        0.00        perf-profile.self.cycles-pp.smp_call_function_many_cond
      0.00            +5.6        5.62 ± 33%  perf-profile.self.cycles-pp.show_interrupts
      4.64 ±209%     +28.6       33.27 ± 18%  perf-profile.self.cycles-pp.pv_native_safe_halt



***************************************************************************************************

=========================================================================================
compiler/cpufreq_governor/kconfig/rootfs/runtime/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/300s/lkp-emr-2sp1/lru-file-readonce/vm-scalability

commit: 
  d17f02417a ("mm/rmap: separate out fork-only logic on anon_vma_clone()")
  6698721815 ("mm/page_alloc: ignore the exact initial compaction result")

d17f02417a337de0 66987218154918a6341a3e3eeee 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    426746 ±  2%     +17.3%     500442 ±  2%  vm-scalability.median
      1166 ± 28%   +1053.6        2219 ± 15%  vm-scalability.stddev%
  1.11e+08 ±  2%     +16.9%  1.297e+08        vm-scalability.throughput
     54.43           -10.4%      48.78        vm-scalability.time.elapsed_time
     54.43           -10.4%      48.78        vm-scalability.time.elapsed_time.max
    103326 ±  4%     -15.5%      87260 ±  3%  vm-scalability.time.involuntary_context_switches
     17909            -3.9%      17205        vm-scalability.time.percent_of_cpu_this_job_got
      9605 ±  2%     -14.1%       8252        vm-scalability.time.system_time
      2.07 ±201%    +213.6%       6.50 ± 96%  vmstat.memory.buff
     30.09 ±  3%      +2.8       32.89 ±  3%  mpstat.cpu.all.idle%
      0.15 ±  3%      +0.0        0.16 ±  3%  mpstat.cpu.all.irq%
      1.10            +0.1        1.21        mpstat.cpu.all.usr%
     29.13 ±  4%      +2.7       31.84 ±  2%  turbostat.C6%
  10961264           -12.1%    9635977        turbostat.IRQ
     39.55            +6.9%      42.27        turbostat.RAMWatt
    881807 ± 13%     -19.1%     713350 ±  4%  numa-meminfo.node0.KReclaimable
    881807 ± 13%     -19.1%     713350 ±  4%  numa-meminfo.node0.SReclaimable
   1055803 ± 11%     -15.9%     888061 ±  4%  numa-meminfo.node0.Slab
    702201 ±  7%     +18.8%     833965 ± 11%  numa-meminfo.node2.KReclaimable
    702201 ±  7%     +18.8%     833965 ± 11%  numa-meminfo.node2.SReclaimable
    837079 ±  6%     +16.2%     973054 ± 10%  numa-meminfo.node2.Slab
      1.17 ± 24%      -0.6        0.58 ± 82%  perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.17 ± 24%      -0.6        0.58 ± 82%  perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.97 ± 37%      -0.6        0.40 ± 57%  perf-profile.children.cycles-pp.rcu_pending
      0.03 ±223%      +0.2        0.24 ± 33%  perf-profile.children.cycles-pp.__get_user_pages
      0.03 ±223%      +0.2        0.24 ± 33%  perf-profile.children.cycles-pp.get_user_pages_remote
      0.27 ± 52%      +0.2        0.50 ± 20%  perf-profile.children.cycles-pp.load_elf_interp
      0.08 ±101%      +0.2        0.33 ± 46%  perf-profile.children.cycles-pp.get_arg_page
      0.59 ± 37%      -0.4        0.21 ±102%  perf-profile.self.cycles-pp.__percpu_counter_sum
      0.03 ±223%      +0.2        0.21 ± 30%  perf-profile.self.cycles-pp.sched_setaffinity
      7.31 ±  2%     +19.9%       8.77 ±  4%  perf-stat.i.MPKI
     58.30            +2.2       60.49        perf-stat.i.cache-miss-rate%
 7.426e+08           +17.5%  8.722e+08        perf-stat.i.cache-misses
 1.228e+09           +12.0%  1.376e+09        perf-stat.i.cache-references
    580.71 ±  7%     -16.7%     483.74 ±  3%  perf-stat.i.cycles-between-cache-misses
      7.41           +18.3%       8.76 ±  5%  perf-stat.overall.MPKI
     60.61            +3.0       63.61        perf-stat.overall.cache-miss-rate%
    704.31           -17.1%     583.78        perf-stat.overall.cycles-between-cache-misses
      1296 ±  2%     -11.5%       1147 ±  5%  perf-stat.overall.path-length
 7.497e+08           +16.2%  8.715e+08        perf-stat.ps.cache-misses
 1.237e+09           +10.8%   1.37e+09        perf-stat.ps.cache-references
 5.281e+11 ±  2%      -3.7%  5.086e+11        perf-stat.ps.cpu-cycles
 5.569e+12 ±  2%     -11.5%  4.928e+12 ±  5%  perf-stat.total.instructions
   3008740 ±  2%     +33.6%    4020245 ±  3%  proc-vmstat.allocstall_movable
    482140 ± 81%     +81.6%     875667 ± 51%  proc-vmstat.compact_stall
    313239 ± 60%    +108.2%     652063 ± 45%  proc-vmstat.compact_success
      8065            -2.8%       7836        proc-vmstat.nr_page_table_pages
  39936876 ±  2%     -59.1%   16330199        proc-vmstat.numa_foreign
  95893347           -76.7%   22371986        proc-vmstat.numa_hit
  95488037           -77.0%   21972039        proc-vmstat.numa_local
  39916786 ±  2%     -59.1%   16315472        proc-vmstat.numa_miss
  40314192 ±  2%     -58.5%   16714902        proc-vmstat.numa_other
    687855            -2.2%     672475        proc-vmstat.pgfault
     37269            -2.4%      36389        proc-vmstat.pgreuse
 7.849e+08            -8.8%  7.158e+08 ±  3%  proc-vmstat.pgscan_direct
 2.277e+08 ±  5%     +29.8%  2.956e+08 ±  9%  proc-vmstat.pgscan_kswapd
 7.849e+08            -8.8%  7.158e+08 ±  3%  proc-vmstat.pgsteal_direct
 2.277e+08 ±  5%     +29.8%  2.956e+08 ±  9%  proc-vmstat.pgsteal_kswapd
  23897099           -77.3%    5427738 ±  5%  numa-numastat.node0.local_node
   9808674 ±  3%     -65.9%    3340632 ±  3%  numa-numastat.node0.numa_foreign
  23996306           -76.9%    5539552 ±  4%  numa-numastat.node0.numa_hit
   9935480 ±  3%     -48.6%    5104083 ±  2%  numa-numastat.node0.numa_miss
  10033238 ±  3%     -48.0%    5215298 ±  3%  numa-numastat.node0.other_node
  23818598 ±  2%     -77.6%    5336433 ±  3%  numa-numastat.node1.local_node
  10422599 ±  4%     -60.6%    4107508 ±  5%  numa-numastat.node1.numa_foreign
  23903690 ±  2%     -77.3%    5425282 ±  3%  numa-numastat.node1.numa_hit
   9568102 ±  3%     -62.3%    3606134 ±  2%  numa-numastat.node1.numa_miss
   9650828 ±  3%     -61.7%    3694897 ±  2%  numa-numastat.node1.other_node
  23244424           -76.6%    5433322 ±  3%  numa-numastat.node2.local_node
  10157128 ±  2%     -58.5%    4212315 ±  3%  numa-numastat.node2.numa_foreign
  23367486           -76.3%    5531118 ±  3%  numa-numastat.node2.numa_hit
   9655573 ±  4%     -59.5%    3909187 ±  3%  numa-numastat.node2.numa_miss
   9778660 ±  4%     -59.0%    4007790 ±  2%  numa-numastat.node2.other_node
  24517225 ±  2%     -76.5%    5765127 ±  3%  numa-numastat.node3.local_node
   9548474 ±  4%     -51.1%    4669743 ±  4%  numa-numastat.node3.numa_foreign
  24615123 ±  2%     -76.2%    5866615 ±  3%  numa-numastat.node3.numa_hit
  10757630 ±  2%     -65.6%    3696067 ±  3%  numa-numastat.node3.numa_miss
  10851465           -65.0%    3796917 ±  2%  numa-numastat.node3.other_node
   1363284 ±  6%     +12.5%    1533491 ±  7%  numa-vmstat.node0.nr_free_pages_blocks
    219953 ± 13%     -19.0%     178205 ±  4%  numa-vmstat.node0.nr_slab_reclaimable
   9808674 ±  3%     -65.9%    3340632 ±  3%  numa-vmstat.node0.numa_foreign
  23996706           -76.9%    5539212 ±  4%  numa-vmstat.node0.numa_hit
  23897500           -77.3%    5427399 ±  5%  numa-vmstat.node0.numa_local
   9935480 ±  3%     -48.6%    5104083 ±  2%  numa-vmstat.node0.numa_miss
  10033238 ±  3%     -48.0%    5215298 ±  3%  numa-vmstat.node0.numa_other
   1470383 ± 20%     -82.6%     255546 ± 73%  numa-vmstat.node0.workingset_nodereclaim
  10422599 ±  4%     -60.6%    4107508 ±  5%  numa-vmstat.node1.numa_foreign
  23903980 ±  2%     -77.3%    5425155 ±  3%  numa-vmstat.node1.numa_hit
  23818888 ±  2%     -77.6%    5336306 ±  3%  numa-vmstat.node1.numa_local
   9568102 ±  3%     -62.3%    3606134 ±  2%  numa-vmstat.node1.numa_miss
   9650828 ±  3%     -61.7%    3694897 ±  2%  numa-vmstat.node1.numa_other
   1342994 ±  6%     +14.2%    1533478 ±  9%  numa-vmstat.node2.nr_free_pages_blocks
    175084 ±  7%     +19.0%     208437 ± 10%  numa-vmstat.node2.nr_slab_reclaimable
  10157128 ±  2%     -58.5%    4212315 ±  3%  numa-vmstat.node2.numa_foreign
  23367487           -76.3%    5530880 ±  3%  numa-vmstat.node2.numa_hit
  23244424           -76.6%    5433084 ±  3%  numa-vmstat.node2.numa_local
   9655573 ±  4%     -59.5%    3909187 ±  3%  numa-vmstat.node2.numa_miss
   9778660 ±  4%     -59.0%    4007790 ±  2%  numa-vmstat.node2.numa_other
   9548474 ±  4%     -51.1%    4669743 ±  4%  numa-vmstat.node3.numa_foreign
  24615201 ±  2%     -76.2%    5866947 ±  3%  numa-vmstat.node3.numa_hit
  24517303 ±  2%     -76.5%    5765459 ±  3%  numa-vmstat.node3.numa_local
  10757630 ±  2%     -65.6%    3696067 ±  3%  numa-vmstat.node3.numa_miss
  10851465           -65.0%    3796917 ±  2%  numa-vmstat.node3.numa_other





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


