Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A38E7AD7A
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F5A6B0088; Thu, 25 Dec 2025 21:51:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C0D6B0089; Thu, 25 Dec 2025 21:51:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6FC6B008A; Thu, 25 Dec 2025 21:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2156B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:51:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 207051605A7
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:51:07 +0000 (UTC)
X-FDA: 84260095374.27.3BA9DF6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 098B7140003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:51:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ejha0M7R;
	spf=pass (imf23.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766717463;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuBHmbHVDwlft0EZQprress5iwjNSKCUU//k/6UkZBk=;
	b=qevWi/PFQK8Yvu7DYcr4gKHNyVj0hNqgYO5S5k9tQhTsZikFcVlRSJSM4ReJ4y1f/13hlj
	XVAeeO5IX5ZSgDeYzZs2ZDVohNprr78aXURVPj461k5SrGQCt7tjbyw6AcacwHrHodsKqT
	rjXA9vWzWGJnG7swhbvuEuLHmU7+B+g=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ejha0M7R;
	spf=pass (imf23.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766717463; a=rsa-sha256;
	cv=fail;
	b=7WrgKsYWJ+Io0A+3HWRb+xc4RiME4CUnCMYVtjkMO1W5HNvsxyhokGoYV+Lah/9qg9IPht
	g93rtDiVytW8ZJStzw4aVhMDECvdVn2H1fyPEsSAyxmMNETn11dipe5JPhpzHstxohfiQn
	4SPmx7RKlDIm8Nx8zR+Zg/QsWYxR66w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766717463; x=1798253463;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Szbzv09GOFEA+1x2iRRKHb+EMchWdb5TySxif9c5BI0=;
  b=Ejha0M7RAFH+NnebhzeGx8e1iURFVJDU3UwrpGlPkXUdpMo4+PhDPBDS
   1VRZh2IelQgxZfeKMhoOxpm1RUY9LW4mpzNMqFThU9XH7E1GOpWCHRt5N
   Hzbq8niqX4Vg4Wfm0pTYlHF+mgg8GcVU81WEhEAFHe5WKtWrfwDJ0rxei
   7RQBRVCYa7bRNYv9Yha8co30caoRcT0iZ3Rn36jyG8gX0vBMl6ISsMAgD
   6CQ8te4sWRCtE2f8LEheie2sHdnjqXGJ3E/mCa50cNLqTXW1mA7+8mbVD
   vJY4r9HusHItTh43h6F1vBySaC2gPc+tXXh+x9ANc9AHvlviwZUvhTrQN
   g==;
X-CSE-ConnectionGUID: FabnLkkWTLqnKNXYaDEf6Q==
X-CSE-MsgGUID: MootlYeGRnWD4ZZ/XxZ1gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79855058"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="79855058"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:51:01 -0800
X-CSE-ConnectionGUID: eJmkdJcZQNycmm40JMjYeA==
X-CSE-MsgGUID: fl61pYP6Rruk3Jkl8x25AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="200611185"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 18:50:36 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:50:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 25 Dec 2025 18:50:35 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.62) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 25 Dec 2025 18:50:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSVotPJqvTgHOgLTwnCzThZcttfUuojLRMhHkzv1ZohtduGDCgm74qVdg+n0TY+xhDHSoV9bcsWwIWY7LQ1BEwDrwK6yxOPUcLTHnv1gq8bcKu4OVOE8YEHSSfYerwMca/kiKI8Vd4hPCnnOMaHVv7IUrv7gbBFm1wXnFaJrbg+gdT8z/66YHvDivb+4SjhoOOr9R0cm69Boiool01bg4NszxCEQYi947qqWMT/WDk/QNCFT5RG8wjioVPD0sjadjuFkQTWTvgDCRzml11rlIMGBopPQOUbh4XdM6rowOKNpD4yuc53n9dc/DWTDsZyGhonfyYzCm4bLn0S0vnbSZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VuBHmbHVDwlft0EZQprress5iwjNSKCUU//k/6UkZBk=;
 b=GvAsoo/CC7uP612OrS5WBrqWBCjZ7L/qMUHhoJErcZdX/mJ7zhnXbbZsZG0/+4Q3J5n+/Ltum3FLKl4UAxpH1V5Xd88IL1T40QqFb33HLycnjbWt7B9vla5ds6yLoqMm5UzI04dfE1iPb5fIg/VFWzGx2Fvm9TB92dxu6x/4yvnagPrnZyZumuYNZbN1Hb64Q+Q5sbafilQgwzhSkFrfb0I7oXXH5npcT4+rewGz7XdiEWjbM/Au41WhHOFIhuBaWEou6gXzcQEtnmMkZiZVjqZVGZ/0wxm3m+/xKEVUnqRdEKPGMhQWYqKvdCMxaHzbSe9cmBxhCsQ2TPoQEmQVMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9456.11; Fri, 26 Dec 2025 02:50:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9456.008; Fri, 26 Dec 2025
 02:50:32 +0000
Date: Fri, 26 Dec 2025 10:48:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH v2 5/5] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aU33Y56qBXgrL5/3@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
 <20251215153411.3613928-6-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251215153411.3613928-6-michael.roth@amd.com>
X-ClientProxiedBy: SG2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:3:17::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MN2PR11MB4598:EE_
X-MS-Office365-Filtering-Correlation-Id: 234e46d3-da8c-4849-7c20-08de4429894e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NwE2RWWkyos/IRz731u1QOkMzdTOZq68sa2Zp7e3YXzg6LbU99Wk3A4shPHP?=
 =?us-ascii?Q?egnPHn59Kl7q/D8kumqwVp8LMd37h/NBWVnGLRcRisEt+1H2+89bSltY5UoB?=
 =?us-ascii?Q?qu6WldHgt5lRhf9kr78VRfO/bc1BMH0x1nlWcDZlJP4kqdSLQP+os0Gr0GSs?=
 =?us-ascii?Q?1XUyP+4MM0FfCYDLUUHb3J9HHxkCi87yxFNzjtseyYIAdv1GvXxaeyF0Zpra?=
 =?us-ascii?Q?JP9KTBJVa3FpcOw/14tfEtrAtggf5ZAYqM3kP+2JmNWqYW5/vUptFmm6bOlN?=
 =?us-ascii?Q?X8ln1bGZYISM6KDRTPJwr7YZRAfsy6qq3At9fZvrVReR1O/+B4M/s0PSPLnP?=
 =?us-ascii?Q?gkWa2CkX/swfxH6E8jldMlNK2nj+Ym4S6XS3/mI7AOn360qbK7HJ/AATRuX2?=
 =?us-ascii?Q?6SNDPIRsIYijWaWaTk2/jHh2xveDOj6rBONi1GKocDMKjJsIwN0cLWxSZhjE?=
 =?us-ascii?Q?hxZBqD9Httma1SpDWvRNe7bT2znmovJVwB+i7vppEl8V7frwiis18L84lOq7?=
 =?us-ascii?Q?zT5sLxUEe9PL719rgkyMeF5OCEYXi4kV8fJTXQw+SUCg/H1LteV6KxkZWlLU?=
 =?us-ascii?Q?pYBOmUNe9EnMfm9/sqG9R4ZkH3nH+HUn613/5SX33vx80I7yETcLZBg3GB3m?=
 =?us-ascii?Q?/TGlH70IjaqId1ciTtlx66s2zwDrHyA8uFLTGfRrP0bMGjEMmvue68NvmGGe?=
 =?us-ascii?Q?8vVu4DrtQ5HskHtzEUwEA7pZeIPczXUGCrVRi/JFb5atokNmIbz5BgKXYgmh?=
 =?us-ascii?Q?UGXiwqg5jyjNIEgy+G+m1fQGzt/PNJouAzs+4rzKQ0Nxj+1aQYo/CEX/0maI?=
 =?us-ascii?Q?nc8XaG6K6cfmvt0jA0xr/7O6IRvL3tsEFbdWSokKYy8tgeRBSxA2aaNbG0Me?=
 =?us-ascii?Q?sT8sQIGQnNVxcP0KhEWn4/04aQtES4zfohAyCWtLr6Gi6i/VmV5abxtNJnoQ?=
 =?us-ascii?Q?9gBPAZ4TTBJOlqajWtY7YZcXiQ9rJpM1wo6kFHlZB/2jW4JMtVBlZksPydeg?=
 =?us-ascii?Q?V0kKjyQfeC7OzQMCkEszuAdzO1eoc1kDW/gInG1gzc8P8ORAXWyOweqf88CF?=
 =?us-ascii?Q?6agPKSP3BNoRYG2vQ/JOdcAQ7R+3cticBuUAW7xrDX6zU2bSQ2AAFnwoIrjs?=
 =?us-ascii?Q?mSMTE2qoih0O73qMVrpUcmWNrLOHrjbV/70iNd8QHCYfjCTIwp/gLUS6ezU8?=
 =?us-ascii?Q?fZWy6ickpntH7obMr+8FkHoazkZ5gK3YMN7c4T6VTO2j/MM/i9GqNwbhFarZ?=
 =?us-ascii?Q?CqMNw4P10YRO6RT0xSxQyuPIRLiNAY7SmDD8yFd1vatfttEIKy8QoWFTNr7A?=
 =?us-ascii?Q?2xYvh7z5CXW3sbmje65Jhih3HmUQ6bZmwJj291ATKj2W4l3+wzHBwmzys6aD?=
 =?us-ascii?Q?kYe5S47JilmRk9J1nsu8qEK3CPZFDgtZf+IIbsbm1EoKk/m/dRZB5ie24aca?=
 =?us-ascii?Q?s7dxI3C8raNn9ota56i/ceTt/6pjwbpC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Bv7qTPUKOXU3cN3RECBeCy/wuIgr8YL/F04gNiS682CrqZZwty4x6YUI2Mn?=
 =?us-ascii?Q?dKbMYCvxJhLG9hlI59JerW/0AnTVDqus0jbKoMhyZ6EHjnB8m7s/g+PF79if?=
 =?us-ascii?Q?Z5TLtPF71WFtXoXEEUqzLR2UMNXO4X9r8m3wGmEHD+zJKHJLamcjNXS9lS/R?=
 =?us-ascii?Q?FUUmRQClNWpyZvxq7INcAMPlZtBlTOGaW6kJn8kJoK9/+xOZ7Wl1eeN0k8vb?=
 =?us-ascii?Q?AFCmu8PCyF54g9KQJENr93WQiXE4QREaWfgkAyeHBSeuXmb7E0K0GP+egzDF?=
 =?us-ascii?Q?271yOTdAzJlx76G0gAaw5d5UrWn1rzzfl5tvu3YZ7Tbz1UxXG7RC0lcT/HAE?=
 =?us-ascii?Q?8CFv6DUjnXR181RgBqa3Tg1ngQos1G9HvbL+invIUPa8GnDC47JTBPbXiI/H?=
 =?us-ascii?Q?GHdbSgVTl31CNHfwHmjfPJFmb1ysjHIUhcBiipuvGMsJHmGZ7uCJKiMJsUyA?=
 =?us-ascii?Q?SqaVZB4X8r5vudivRuO592Q6kYApi5LGxxYDYA32+OAoPe0Aj82On347tbV6?=
 =?us-ascii?Q?CimjbfDo9fkQifO319We4FWV68CfsQjjHifxd8oePnL1hNBk/sDKxiSWx45h?=
 =?us-ascii?Q?tw/MT4mBTpLrsltUotGj22a7gW9uvoZ3ViF/nnAZqwkruWdfGqGYGDDQWYsA?=
 =?us-ascii?Q?WEbbt9WIi62XdB7pjdl6dSj6q4B5yrepb5LizzQb71jjMzF09TP7axjZB8vn?=
 =?us-ascii?Q?FQ1s8FjOlC/A/LCT/ovYJ1Sdvdx02HM83xbr7uEoqMuUKUiUuC3Srxc9e43v?=
 =?us-ascii?Q?eWkkKgX6e24kHs7UQrChjObLgfDvSahcOifPg/JgGIwKDZlIMiN5xlOFvywT?=
 =?us-ascii?Q?fiVolbYOht8F6+FbEneH2pQ29Ne/uU4VY77+xPVM86mstucy16nJKNHK1rOh?=
 =?us-ascii?Q?ZB/PkbCkOc8Ani9mlp5NBtV6w6Z9pWXJVvV7gFFBA40WvD+AonN+nJzPZvTG?=
 =?us-ascii?Q?opmzGwwMkvsKQ1Dw/9GSoZoLAQTRqRpJGsXmdHlQSjM242ks5aUvQmW9JpnM?=
 =?us-ascii?Q?a+wi9IX/R42h0RfGUDyAICQ5LIEdrAfYT9WrvwBkhBTSnuzamZJ+/TYREaMZ?=
 =?us-ascii?Q?o5tRuhTjjsFU6GL7EbgnVZ2d+kHsJ0ARh//vZ+pgGi41cuDtJAQ5MxlpO3oE?=
 =?us-ascii?Q?UGygj5OJLPnqDKKut3seuj+5nBKF1PIARYUQrg88Tiy++twMZt7MzetjDPfb?=
 =?us-ascii?Q?wtx6zWjv5v8VFI4nsZFnSO6ph5NAF+k8A0PFU7AlggHMvhFy573mxp3eG9Z8?=
 =?us-ascii?Q?bC2ZPAF9a69LC/QMWfLrDbVLIHiiofZiDjf+52weNMF61NmRnzPYmbYHraBS?=
 =?us-ascii?Q?xFzvKdNi+nY2mMT8SSNcStUjO6W7BrFV11plus005t30SBStu6g80kIZb1od?=
 =?us-ascii?Q?qxhLIfGEkm4/CqdjFF5eevaHmWelbfJ3cA7gQA4/VB9PTin5gRldMULIAdur?=
 =?us-ascii?Q?TqVRPloJ0fNTdp9yt8UxefKrRP9zRzOlxm49QMrbot68+RiChyooxOggJ9B/?=
 =?us-ascii?Q?9r8LU6LX9R1Io9EswOycxDTH4yPbijHfz8M3L86wI5iAhkI/nA+vA4AyT4No?=
 =?us-ascii?Q?kJ6UFJuyG4wuS0q7g6y5qlVku0hJUgf8+rbEM1RI6/qJmTF1w/RYdrHy5DH6?=
 =?us-ascii?Q?lJ/tUWdoObBNbKLN5ROmpxhTAyB+czHOB57CSAHFnC+3CrjLHoThNzAc9vKJ?=
 =?us-ascii?Q?C7ku7sRsXqopYNDSFSfcogT7v0r22wNjVSJN7bT1o4F+wvdK7JADZjiWbWTa?=
 =?us-ascii?Q?03ROOMqIig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 234e46d3-da8c-4849-7c20-08de4429894e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Dec 2025 02:50:32.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaoDJjkHS1+32lUoo+oCmnwQUHZlNn5QhqfXrpmL5WaeBJUh2M/Gc5/Yy999vvQ57OwMYes4+KWmDKpzYejDjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Stat-Signature: cb5akm7g67neia1s4tznrkqgq3cranyz
X-Rspam-User: 
X-Rspamd-Queue-Id: 098B7140003
X-HE-Tag: 1766717462-697861
X-HE-Meta: U2FsdGVkX1+wNuM+lZcldMa70ZUPTxmR44MC1KGmq9Aq9lkABnPfzEH4Vkl7vr5keeMXWQ0fRJDA4qeDw7HzS+qAKjkYHOANoG+alDNOeC1eUmtSgYtqq8AXXwRdzd7+Pea0X4zp67/BL5lQ0BxOx2ltuAQGhBy3Ii7Ax+l1vBsAoFHSwM3/REG0JxOaq6lfxLCdmkOf9emA0RuxXwdq4IKyTqVfyves2uESIY5k5IAOXIGg5NsnvYaSaZ9zheYk8CAA+TAnpOm/4jde9EqRvwTdcm4Y6luYJ/C5SHYGmCBSllKTDpJOQqVLz9ut8L5LVP4LUyZeXBN3VUXgB8IFQQzTNiuUgbWbb4uL43XWvOAUlQ6YXjH0l4mIV4czN/pxtBfriAlS2SvzWtfvppLRP073C7X9qnLTz3iMnHxDcwsEGtjDjKIrIK06L8r6kWnc7ZeUgxXRZteqKAy1dldhaNXS8BxGUdbeIRYelQR6B28v+mCxiWdkGdvgo5Fsigpeyq3mxwqdOxBRvTqOUjEp4u1L1bhgKuw155GU9DYakwZzj4gLTS2kE5NLQ0gs2kox4d8eFGEalfOUHL1eWPIKRuT39hmw3kRfCJyTqLBmA2RpxtQktXn2H/WY5c42PR8EZ8iM29Kh4XmXGDp9i+4mBi7mPHEFoFe0AO6RW4m3JNPedJ5tedqFGF9ugLtS7gdEKCZ+7wcSuFDGPirtaGGifPFHdvy0hA7yAIp+9kVzXwzoj4lAasa7AoN+bOWuJ7rNzjBYJLj/tUI/cQ9RLPZ7XcemIeNBQax6gWCXXcZbS5mzZNNc+rbvh79veoZWP/JF/Uzc84Dbm35pyRTP+lcBu7IEtRNdJ/c7Xz1Vzv6rn7uCAOx4i5IQ0Jsa3vn7y5aYlxyOqUFfoQ91K48sqpFedjfkyvJt5QtfYh6Yre7xZRw6aNC5HjnRYrV5kU9zox5AEw8DD+qlp0LWHdtkrUZ
 V3TltKjm
 vOmKYo8EHZ7HDgFEX8fTGv9aKQHbkMoBxt5SQUFNVJDTJZNXR0OhKKiWQPsxov/pZxKnL0aR/QPFLrWKjJoPXHi0Ybm6s3IYQGMtX/xpuKNm6t8pOkxnXJw4wl8fqktCaDKgwHG3KNNG0R6wMIfBH62W6wtG1tAKlbT1IGOsUqgCO1OOgFg1CfLqLlMU8+BZN5cVgYYXK9P4ikPZnuHhEUglNoHd+hmmAncGoyb4WPumdXjtNut8Sqb7OIcLAyqdrxsft7RQQ5/pkjQqCdsOk1NB7v3m9Tp7Pc3bucqpmWdLz8NxIFhdx/TiaGD/vRBQpPbELyUrjHBcdcGy2oJ4+PCN3+naMN8dNcty2QkCxQ+nXEclsO9cgn/ZL8SBYYr7nO4ZwD+HEApyjDE2lJmQ3fIZH7qeUAYoMQIDSyqK1mh4p9hbI8uyzAj1o8Tf5G7CmkwidYBJlGdIRMYtTk9z0t6ZsCFCAHX/6WSBFRiNWZ2t8e8YI5Jr5uHoNtQdLb1cCbU9g4nVimiURqA0eFzWW/Wj/ttlJT/8dcViAcwplB+w1nqUJFhysX5v9U9UwvdbjwurdtcqVESyomRa4aeGfbpjrOI+4hNns46ueX5vX03ombbS6jwHq1nBvuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 09:34:11AM -0600, Michael Roth wrote:
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4fb042ce8ed1..3eb597c0e79f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3118,34 +3118,21 @@ struct tdx_gmem_post_populate_arg {
>  };
>  
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				  void __user *src, void *_arg)
> +				  struct page *src_page, void *_arg)
>  {
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *src_page;
>  	int ret, i;
>  
>  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>  		return -EIO;
Check if src_page is NULL.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f9dc59a39eb8..98ff84bc83f2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3190,6 +3190,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
        if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
                return -EIO;
 
+       if (!src_page)
+               return -EOPNOTSUPP;
+
        kvm_tdx->page_add_src = src_page;
        ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
        kvm_tdx->page_add_src = NULL;

> -	/*
> -	 * Get the source page if it has been faulted in. Return failure if the
> -	 * source page has been swapped out or unmapped in primary memory.
> -	 */
> -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != 1)
> -		return -ENOMEM;
> -
>  	kvm_tdx->page_add_src = src_page;
>  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	kvm_tdx->page_add_src = NULL;
>  
> -	put_page(src_page);
> -
>  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
>  		return ret;
>  
...
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>  		       kvm_gmem_populate_cb post_populate, void *opaque)
>  {
>  	struct kvm_memory_slot *slot;
> -	void __user *p;
> -
>  	int ret = 0;
>  	long i;
>  
> @@ -834,6 +870,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (WARN_ON_ONCE(npages <= 0))
>  		return -EINVAL;
>  
> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(src)))
> +		return -EINVAL;
> +
>  	slot = gfn_to_memslot(kvm, start_gfn);
>  	if (!kvm_slot_has_gmem(slot))
>  		return -EINVAL;
> @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	if (!file)
>  		return -EFAULT;
>  
> -	filemap_invalidate_lock(file->f_mapping);
> -
>  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
>  	for (i = 0; i < npages; i++) {
> -		struct folio *folio;
> -		gfn_t gfn = start_gfn + i;
> -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		kvm_pfn_t pfn;
> +		struct page *src_page = NULL;
> +		void __user *p;
>  
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> -		if (IS_ERR(folio)) {
> -			ret = PTR_ERR(folio);
> -			break;
> -		}
> +		p = src ? src + i * PAGE_SIZE : NULL;
>  
> -		folio_unlock(folio);
> +		if (p) {
> +			ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
> +			if (ret < 0)
> +				break;
> +			if (ret != 1) {
Put pages in this case? e.g.,

--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1645,6 +1645,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
                        if (ret < 0)
                                break;
                        if (ret != 1) {
+                               while (ret--)
+                                       put_page(src_page++);
+
                                ret = -ENOMEM;
                                break;
                        }




> +				ret = -ENOMEM;
> +				break;
> +			}
> +		}
>  
> -		ret = -EINVAL;
> -		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
> -			goto put_folio_and_exit;
> +		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_page,
> +					  post_populate, opaque);
>  
> -		p = src ? src + i * PAGE_SIZE : NULL;
> -		ret = post_populate(kvm, gfn, pfn, p, opaque);
> -		if (!ret)
> -			folio_mark_uptodate(folio);
> +		if (src_page)
> +			put_page(src_page);
>  
> -put_folio_and_exit:
> -		folio_put(folio);
>  		if (ret)
>  			break;
>  	}
>  
> -	filemap_invalidate_unlock(file->f_mapping);
> -
>  	return ret && !i ? ret : i;
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> -- 
> 2.25.1
> 

