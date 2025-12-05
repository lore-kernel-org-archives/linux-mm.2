Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49C3D2CE1A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 03:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396186B00F8; Thu,  4 Dec 2025 22:41:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D706B00F9; Thu,  4 Dec 2025 22:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CED6B00FA; Thu,  4 Dec 2025 22:41:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166C06B00F8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:41:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0BD113ACCC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:41:04 +0000 (UTC)
X-FDA: 84184016448.13.C415A60
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id 07BC4C0009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 03:41:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lzUB9ExL;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764906061;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IkZDkZPXE4R7V/QdpwDtq3/AEuM3heHudG2ghuMrtM=;
	b=EJSTZohUD7k7Jc/dCrDWt67sl35n9hpk6QEMgG64Jipa/i0FL0hP1WQD7ojMKzGkMu8FuY
	bBZrIAf0kWOJSXb/P4VZ35oTGZtZQhkmjDUg+7urTZ8JB6Hi31oBKYCjR18HP/Zvw88UP8
	AILRA9uF+a0KwGhR5gPnOhag5NjJvYc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lzUB9ExL;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764906061; a=rsa-sha256;
	cv=fail;
	b=KEOTqjfGW4AP9fPYKwtsjoiC43HXgXZSw2X1VDX8KWDgryJKLJLvll7I8Dd6RWqUKEUQGM
	VVNXHyEEEH/ihIT4rLFwyaDKhkCh/A0J6ynw9MjW+dOWzN6fYLI55G3bEWGup/cTHHbb9o
	F+1mQJ3ma5RbmBVO53U6T9rP4L7/wKg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764906061; x=1796442061;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=IZ/Tbf7yq4YcTHPamy+Mn3rUu/mFwlcaWhrrG7wz918=;
  b=lzUB9ExLMvmkpjQDc17g+q0IhBgMRn8PFM2KNoDw4b9/nUwgA9CaFlem
   0R+v6ikKCRnMd6I+Y/PcFs0DSScj5B8L++l4fJrXW3tyzCBifz22oqEnM
   b2dUNSryGqNz+oryBUrTbiN+j4AHI8zN+zmQba6/EOZ3gTiJqzxDx7QSH
   RjF6ATwZ41hLepavD5eAyG8edkaUXHo5ez4aroNnyp2wWCgJSt046QDkE
   uiMd/hKcBtWgtWy5yPNM3ahTHD/cNiEgeFZWNAD+nlUYn7km2ZimOXk8+
   oaDZQr6x28yTi9cj+XMDdrBnB3GJUSl4XVM+qPxf1Ynk0peD8ysu8P+GB
   A==;
X-CSE-ConnectionGUID: /UpsXI5RQSSDUtLAMq9hZA==
X-CSE-MsgGUID: L7BS9pnuRB2z8Dx0NmFDrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="54487892"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="54487892"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:40:59 -0800
X-CSE-ConnectionGUID: nIIImVFfSTqo9196Klm2XA==
X-CSE-MsgGUID: nu+j8vLsQpqsRaNhTqfpsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="225839574"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 19:40:58 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 19:40:58 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 19:40:58 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.71) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 19:40:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vc4deECySPKSqhHaw27ONyWm5Kc+27FqcBCChVK69uH+mVI/9Te895reH3Mob6RMen6nA3Wm2bc9N8ZJJ3Ba6PSk129fEHgeaGNDyBOUMfG7GwFvTPpkMzlteC19BUd3ULMCCCKTBdBi7xs/WrrJtOYxVw2Z6y+NTvSr8Uw9t2nzmIuF6pppMDLp/zO9+d6AHW1Hme8IMxZCcIr+FSsny1bYa8BGPEaRgsyscHcKqtpoWgXn8eAnne2O+Anr7K99Tf3sWpgQVWIs4kfxOmvybiXiCXHZJsrbutlRzDwni9fSHOOWoNXrfZE3Ook/t1JC+y06uwkGFKyz6sOzUUXLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IkZDkZPXE4R7V/QdpwDtq3/AEuM3heHudG2ghuMrtM=;
 b=Spt/mglOZBFgi4Z/PFUcwu2BC2rypeCu70NZPVOa83JQy3IHos1nWek8S8pAceCddCNCN+E0sTP/M1s7DEP/7hedB9GzZiT+uQLKH358fMNkLSZABZKAdBFbZGnPouzcJQU0vNao+vqS8IF37GiypkeJ4zc2SEy4hP6rNrUHiCWq9nTF0rtIzH/UbFloUI5JDJk730Jv/vpdKy8fY/WDtx5f1ekAsThMR2HnR5nBq8+hEFIIXz1VIurbxx8LNAhZDuxuJ9TQQoJYLjTkV2+utauo879Gypg+Z7o1vhECClImoFoSvV6dcxc1Z/6t+ykEGG4E9J4s3vgC9WTRmX1HOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.9; Fri, 5 Dec 2025 03:40:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9388.009; Fri, 5 Dec 2025
 03:40:55 +0000
Date: Fri, 5 Dec 2025 11:38:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"david@redhat.com" <david@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"aik@amd.com" <aik@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aTJTvbiXRg/DJlke@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <20251201221355.wvsm6qxwxax46v4t@amd.com>
 <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
 <20251203142648.trx6sslxvxr26yzd@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251203142648.trx6sslxvxr26yzd@amd.com>
X-ClientProxiedBy: KU1PR03CA0048.apcprd03.prod.outlook.com
 (2603:1096:802:19::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: 236cb937-028e-42c0-03d3-08de33b018c3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TgN60BZjKFZwvDKn1iBSRnJd5lUbnv22OtrlNpt0eLTbM+B0ZPqvpaB1FFgM?=
 =?us-ascii?Q?OpAZKiAA1cEtu4CXcBasodZhgAZX884ygTEE9c/3QNnbSndbCnF+KlSCyfKE?=
 =?us-ascii?Q?fjXjVpdftgxf0O97329RVzuuJsvDrSu3VRtbJV9g9wmE48Ki/FvfwhF33BSH?=
 =?us-ascii?Q?RvvnSmPoFuBZoAzUBx+NadNJLfp4OKNXNz0AvGJEnLCcGVzSMcVpoIVW0he6?=
 =?us-ascii?Q?r3GKJy0orgUeaykHNhdgvlwjGKizx8qRMTCfCkLD5xurpkY9AAfnKvQsDwE+?=
 =?us-ascii?Q?KAMlb2dAqy15BCLJGp8fDMswYN/XF6rKW6omaR8bLcpbuATjVyORBmIZ5MYA?=
 =?us-ascii?Q?t9dLJKKZwZxSpAcXYNk/sUO7HbiVulaw5IhD4Xjb1OFPL82wFjIzP7EEMKfD?=
 =?us-ascii?Q?AoYTTa1zP5UmoyKdBA4I3x3TvzQe9+47KBQ1rs1xV88GUKfo5g54WPSWx7ys?=
 =?us-ascii?Q?v3TuB301629qY63BWhAmIaLpCy3XTDAnCvf97FxNp8j7koGCp9Fo7gu1t6uv?=
 =?us-ascii?Q?z5wewRO/tyjFujDbIWxmg7grDrYDieT4dv4cgbft6yl1Es2Hd+gq0V1CbhPU?=
 =?us-ascii?Q?hc4/SJU8mH1G063H07Pb6fO3icunovIMrnTNuDotlhSzzBQjH1RHMviM6td1?=
 =?us-ascii?Q?Bng1ki3oRJN6ibwFFthuTXXBwfrf1q+ffIsPaTJ4B1UvFaqu23JZMMz/h1oP?=
 =?us-ascii?Q?wWwTWyG+zYHITFwlg09Yf7rqJ87DdxO4aAJ3lZJpm+dl+dnkK4D34oaEHCpw?=
 =?us-ascii?Q?1yrVt7+nG0Df0yTBY6mZ3/3vlI7dhHD/foO27nYQ9ivj0rujg+p/KEoCNQHQ?=
 =?us-ascii?Q?Zf8LxigT6HW5fFVi75QKfP6+HBUJ+6Fy7Q6/xnHM6RX/q6tNphEd85/B2JUB?=
 =?us-ascii?Q?Ef4VjBRWgNUrIihQEP9LvgK7g4eqLWsCQ5MHNJWUEGQJpm/XhkmMqmWMNY9C?=
 =?us-ascii?Q?N3X0xlrMu1ch4amqkL8w8x6VQF+1xGwz4PF5OOyJXZFnnKkJ5PcMqB9LvUCO?=
 =?us-ascii?Q?z2H09xMdDWl9VsNuHoZTjz5KxKWagF0YZs2SJJPJejkzH0SWRngjRQeRWf6N?=
 =?us-ascii?Q?Rp0Ebh+OiQyr98c1SYeEQHf8sYAwO42C2Qfq0fnf30ynAWWWzMBZYkdFsg58?=
 =?us-ascii?Q?4Vc4gI/cjAm0SqPTVN9025iqFUatAaZGVU/m1cbmYnfp3rGqefD23tK3DAnI?=
 =?us-ascii?Q?EVIDyshD86wfwPLbYDDCZRuVdTQ7kW11n9j0f2YP4y8FhcI/Xe2u43nicNBa?=
 =?us-ascii?Q?uAxrv4/njY54FsbO47fXayYLXObxxX8fu+w3kVA82fSsHOnqI03lETUxDbk+?=
 =?us-ascii?Q?Cy7Veh5z8+NnUdfGA//AU3gKWHghUEcMkAKXphetrh27GqIHH2Lpwm2yDeep?=
 =?us-ascii?Q?4SsYkOtlcIphinCEY+31KUaJjjtvKVYZiK6TXx6TofBEU8wVgHdanbwDBVou?=
 =?us-ascii?Q?gMBnZlq6bvMBS1aFInE1l+DjfMOymkGu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ButHlKWj2fnjsERpsBGwC6Z5cRBUSR5C3y78pTb2nfsF/++u1j81SvRjtk60?=
 =?us-ascii?Q?Q3auRuSTsWMNFKLcj2LouTeu4IegOrb2L2Qzk4FmsZJbgtV5FaGovBoLzJmn?=
 =?us-ascii?Q?gEsXzgtvO+nFWVy1JBe95DG2NfmkyoePnnLWXArWTap94R5qYvw5lpGCljxs?=
 =?us-ascii?Q?5FBwQyvD3KR/qO7SK3Sk6cb99ajoSoFs82g+QCb9DXCosNah+ZA4oRUrTgni?=
 =?us-ascii?Q?gMO7qAkdEDfm+7prkJHEIXYwjEO91oJUOtA+pBuFIesDpCfaCeGqsJqGGmHS?=
 =?us-ascii?Q?bTUCpcZdKmMS+OUdk4jfmVg5UJQrm2FnI1NZbMX6nsRfurvKThTSxelvNZ8U?=
 =?us-ascii?Q?ZO6+X2miOhBeTPMMiay9786F7FOcnEFopboIYC130gR4CH4HEcJTa+yU8qSm?=
 =?us-ascii?Q?uotLrzMxRoYG7gxzsG9xKWTODfH/C7ZI1LL5EI3TO2B1MJ2Y9rw6jPtzuPTB?=
 =?us-ascii?Q?GSKKaQwtAdtf+pDjgqfC00twClD0rznn8GlzT6O2fwCfNfk+WLXML/nVBafm?=
 =?us-ascii?Q?HeTmnMN0J1+UBogoPQojIUbALsEOW6Sh4sk/p1v6XYniPW06Djh6ebVbBesU?=
 =?us-ascii?Q?qIVrvg4i2wvpKdCwvnObEdi1xO9+UePb4KY7d1VA84NimT9nmdxm1U4mt3vE?=
 =?us-ascii?Q?+TVYytfk5d+v33kod0B5435eoZMr87NBKgNZXr1yMemGjD3PeaHT9je7xjls?=
 =?us-ascii?Q?apl2FiE3M8EIAy3mvMAS1msop0SXq9O5J24ovPU13CB3tva55H/0GOoUNQXp?=
 =?us-ascii?Q?LgNK3ZR4Lc5lQZ3rYsAtc5xRxS+us6077w4JK79PgF3FHtgXm9e6si02VtMr?=
 =?us-ascii?Q?483n9qKps/ZMPO8u1SMGBxQIcaSlp2Ua51LCasX3M1X1peVyOR9dGSMrNcEZ?=
 =?us-ascii?Q?9bdsvrGPtXj42PRmBpIyn9ZzWpBXA60txqFEHJA38Ba3aZBgYtFdgWEeosyX?=
 =?us-ascii?Q?1eX6cnTs/Ws5fRIRCsWpEW1uMlDQMSqFpHrqZeaZkzR61X7VwJ5BOaOkXIK8?=
 =?us-ascii?Q?Vr8WmJWgJ0K3Z4j3wH4SLMfG9y2znC1M1Lk7OXp1FuJJE0rcd1nm2rEed5pt?=
 =?us-ascii?Q?JFPaJMwpIJIMEaf/d6egLsa5Kz1u44mWjfCk/bhpDPrgnj1Iph2zu8bmU2nN?=
 =?us-ascii?Q?HBw2HdkGg+RzxwT5jdin3zNZkBm7MUesUPsBA6DLqlNf7U+/KfmG6cacMGJz?=
 =?us-ascii?Q?6/H+/wGo+3Mw+JbsiSozvqawUUgqdSgjQ67p/oV/l2a8z5XFhaN9fNRWwGd+?=
 =?us-ascii?Q?F8Ow/ZvePVsbcAjL0RbmGcSOUTtD3LsEEYAfeuQGaIFNeZbejs+nrv5eM9+x?=
 =?us-ascii?Q?SLU/1nuFgaydvm9+gpeD0wp00VW8dA6yT1umPiBbTBXnaYess4+sMvf6Lk2R?=
 =?us-ascii?Q?QMZdZRDPz4Lgf7IhWQVH26qSC7JV0U19Tx3wtwsnmBTMqYrdvICVcIiV3dLp?=
 =?us-ascii?Q?ZXMGrpKr1cp2eQCfO7Gthuj/JNsqDz8JAsJ2rCnRiG0D+1QaIYjbzfeq+JN3?=
 =?us-ascii?Q?cDGJLvFFm5o460X5wX1O/ClAcyp3ELlOtj1jOhTgLzvctd3UOfNQuwYsyhAS?=
 =?us-ascii?Q?n6Lu+QvOxmhnmADoDDUu3ZCJZhVpxXTJ2FYj1mVK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 236cb937-028e-42c0-03d3-08de33b018c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 03:40:55.7571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EjDQgfWvguLKz5jIoXgGpycuALcdEyPFp8HHoG9PdA2slA5ToxVKrFXfamDakMKFkpeT7U8lSN3AHdrcH31zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 07BC4C0009
X-Rspamd-Server: rspam11
X-Stat-Signature: wuzs8eghixw8zn4a8ogis4gnjmzhgscz
X-HE-Tag: 1764906060-564875
X-HE-Meta: U2FsdGVkX1/kPmkTQx5Uj411H84G+odBjMk39HnfoDduwMunek2C7TiOrQi1jgG/BMbw4hy3bid1MgOsomPjP5mBM5dgralLcG/n88FbBWTVDEwDAXiqZ5cY8wZFQKqj5xQQNKp0F/HR0HFCGg73VL3zGe1MsM3ahDn96XCqxAHN12j9Mb3FUdy7DRzGErbRHO9+GCuk9uDljic6Lse1EGR+HI5OemdzVxXzuw+FBruqkyPmCb82IM8aYuXp/VrT6LfiOM/kYLgEpN8+NKp1YYVf2TVz/MgF4hdAcSFOzVy4bUiKTvf6NZDahVUcsgKlSiEJvm3pjK2Km/W7Qtzocwqg7s3mUjpQwn0vQiaWW53qebYsXrY4Tst4TVdgyFYMQQJOHzasW3yvYAiYLw36BuPQ601tyB9GXFJEy8sPvLlHHsekDcDmqhl9muWyxLC1YSWwbdQ/SJxFOzBDqQnG5E8bhY0nm7Rdfj60pz8A6vW1hQZz2XRTmWAND3DkAHhS8CglIvhWqQy+zCwGxmVgflcAKVq5mDPoEni27tw56uPswHUzO3RkzZr1Weg2zmrdPXnHt0zxFNSKYV1els5QeUfVQ3co69icYEHZM/bONT9XPyAQiQg+4tQa06hVKLerw/ukyuF5KoHOKAAgY6DnC7xHF2wQdIdkuu8ccsLEgFzZ+/1Zx3WJsWDG/FLSaZTMpMECTFNZYF46hNpvQ4XNJtn2uFWhyU2K5rJsCtJsuA4ofODPYIKCUxpwmL5T/jMgFQs4OJW3HNUV5qj1AEWsOcMGJQ5ua8L1+qGraB1zL6/nvIB3gFn+Lo4jZlLP1uPI6/G1mX1d/RSq8XqLIu4lMiArvBHzYwDYEPvJZ4a7PNk97O63fSRVbmsjc1Eli7flx4yiIuceWYMANPmDVP+x0lGHrH0RqtHOLp1Thmo0i9V77ViwWfz+Ikb8E/JjSH69q3rtl8NayQ4cD3SG+UV
 hxHW0olA
 lQG23QrCKzvbVHM+079KDoYOf/mQRLlZ5vQMDq3zUG0zkR031bzL6DtF5nFcBXDiTudJ4JpQoUw+mQHHNjVEQq1YulQRJytG/Ipdz5FWkWng+G/P2fqqanfcfh1KFvqIlWdOgwIfvnWXrOu9YuUnTBaDcWx4W77o16GOAwENg5GLKZM3hEX+Lxrc73Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 10:26:48PM +0800, Michael Roth wrote:
> Look at your
> changelog for the change above, for instance: it has no relevance in the
> context of this series. What do I put in its place? Bug reports about
> my experimental tree? It's just not the right place to try to justify
> these changes.

The following diff is reasonable to this series(if npages is up to 2MB), 

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
                }

                folio_unlock(folio);
-               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-                       (npages - i) < (1 << max_order));

                ret = -EINVAL;
-               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
+               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
+                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE,
                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
                        if (!max_order)


because:

1. kmalloc_array() + GUP 2MB src pages + returning -ENOMEM in "Hunk 1" is a
   waste if max_order is always 0.
   
2. If we allow max_order > 0, then we must remove the WARN_ON().

3. When start_gfn is not 2MB aligned, just allocating 4KB src page each round is
   enough (as in Sean's sketch patch).


Hunk 1: -------------------------------------------------------------------
      src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;

      src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
      if (!src_pages)
          return -ENOMEM;

      ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
      if (ret < 0)
          return ret;

      if (ret != src_npages)
          return -ENOMEM;

Hunk 2: -------------------------------------------------------------------
      for (i = 0; i < npages; i += (1 << max_order)) {
         ...

         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);

	 WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
                 (npages - i) < (1 << max_order));

         ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
                             src_offset, max_order, opaque);
         ...
      }

