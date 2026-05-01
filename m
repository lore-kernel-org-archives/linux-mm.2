Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 261FACCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D75B6B009B; Fri,  1 May 2026 17:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688BA6B00AB; Fri,  1 May 2026 17:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5289C6B00AC; Fri,  1 May 2026 17:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE1D6B009B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:10:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6FBDA028B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:10:18 +0000 (UTC)
X-FDA: 84720094116.17.7113EC6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF746180008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:10:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hH3CPGnR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKpKmcjR4tPJ4gNESVUTnNA891/eMrTJDh85/+wRndA=;
	b=ILcRHz1c3dlkap7naNNhMQVveuwmvhuU+AN7wq1UhxgcniyUn17YhOSvxEQk2sZkwswnKt
	rMeGvhszcwUnvBMj6CEUQnPpyR4G7l7pjKZN9LKZGj9CT5qBuJy5nZz1WrdUcJSaBKquKS
	cHxX11lTwoj1bTVH+TU6l/cNITNiO08=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777669815; a=rsa-sha256;
	cv=fail;
	b=ufsWGxsH5AY+ZRaGTmk1ND+x2olZk7YqIlmHx7q1TZKyXFArdvTwYWQre576/HIU/Y2WfM
	3l8SE1ldoxQYyAqGMX7v2CsQZdz+ucChWQAB8EMgXfGXqX72CeMob+7tB2fNDlhq0+2ucJ
	YwyLwORhe06yXGhKQRB7HSNrwhp7ZOQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hH3CPGnR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777669814; x=1809205814;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gtqpakxv6G07vnkPPNI4dWUIXXXG8vKLe7HorqRzO8E=;
  b=hH3CPGnREBXAlnhQJvdoZPPQfSzxv6OuBDFQkqzMAFjgKNnlbks9ItMS
   4+RNtj/bSTHgn+Ztu3c2YH9BvMNKtNjqFGSbJP9ywdwAFyCy5ru0B6hRJ
   VjYg+GKjkt5pLel4GnumYkHFvFla/sTXNnOlcwOj8xTQe9J6Dfio3wKxv
   GXJLsoiC7AkBQigtmsApb1rlnL51utx6wwYAWIPYKsh9SFqA2GnnC9it2
   RASmhF3KNi9a0n2rw/Hgo/oF2forepnC0E8R6CS14HiYzszNPHy0eiq76
   nEEFnFZjZPTpypuTFsMtuHQN6djwv6pELQt9QxVVS7vnvKZubrhQdssMB
   g==;
X-CSE-ConnectionGUID: fYiMUmzuQqepPXRkiXcsug==
X-CSE-MsgGUID: BBlPYwneTDGK2nAdi9Xe4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="89732441"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="89732441"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 14:10:13 -0700
X-CSE-ConnectionGUID: yp7XeejmSa+SOGUjaoydFg==
X-CSE-MsgGUID: 1STZXJFlTeC5esCpghKSUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="258569365"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 14:10:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 14:10:12 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 14:10:12 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 14:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DC4C9c0IanxkEwgEYZPEEqn6hvoeauoak7AqQn9GsU0xQKMP2byKip3dxqxDFmU8VLKjmUUkao6FacIl61PEbKsEWrxBMvb14m2qJPRfAODeacNep4ktZT8uJMAjTebQ8tGmbGBDqL8ig9hDqaIfbsVqvx0xQbLf9gQ6dkBd3Ph8500SBAcJjrfry3Ge/DJjdNes9BSH8L/oEwKLP7TXpP2Ra8D63NBBrUAjhBFVA0OMwldEUAhXh04MFbNqYbIyOag9pklz895j2xohY7jI8Te9E7qBDgmZIwU2J1eJAk5C22zWUeYJTRtjqfb657YlyKKiv20axbxUGLc9tNvEPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HKpKmcjR4tPJ4gNESVUTnNA891/eMrTJDh85/+wRndA=;
 b=Hgbkr3znQMfaX5BWHyWDH6I2/y4tceNGMfEF8uJtY8aOC1h7HV479wAdm1Nahizge28Ipw6Ck75NcbyL0geMCHYg0YLxRnXH8kVz2Efp5O0jzEdEPR/2eTa7M/WeBRZPPrc3KoQ06gFmSZ0m2sJD75or9UC8/X/ZCXpWZqPnYjwrQ2776VT+6KUZax3HUhgFmtH4uuId2L7FL/iE0MRGrM0e2BSmoTrX/7xDmjtyfhiaIzG6kBpNWV7MlDZkjqJUtSER32rAJQkXqpj0td+YpSFZpR4/UDYUefALGPe+zg+7QstLU2NrUAAmFeSU/tA/KjFMpNnbUIhi4W5vqBLuSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CY5PR11MB6511.namprd11.prod.outlook.com (2603:10b6:930:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Fri, 1 May
 2026 21:10:09 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 21:10:09 +0000
Date: Fri, 1 May 2026 14:10:07 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Kenneth Crudup <kenny@panix.com>
CC: <airlied@gmail.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afUWr74J1OVdcwGZ@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430191809.2142544-3-matthew.brost@intel.com>
 <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
 <afUGSmS+jNPP8O5v@gsse-cloud1.jf.intel.com>
 <1bc0b1a7-a01f-4dc2-ad7a-3a05f975331e@panix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1bc0b1a7-a01f-4dc2-ad7a-3a05f975331e@panix.com>
X-ClientProxiedBy: BY3PR10CA0018.namprd10.prod.outlook.com
 (2603:10b6:a03:255::23) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CY5PR11MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 78da9797-24e1-48b4-3629-08dea7c606d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: E9GQcxnU6oFVe6g3o3iuuF5GajeSf2tPUpopGflyT60H9eMEqZoynAZqu+RftqnMn10aKh+VM5/tsQX3kzQPagIuOOVeX8PiHnTQvdI1wzZjkdk8ZmBO9W+ncmw5WSK4MjQeuulDoaWoyFHzPafDFQsyiZrKISIKCIzdkXZCDbI8g2Q1x5LZRyCwfrXwDBzgfKpQbjnnmZsmXMFHp4tbPBI0cJAAwwOjEWr+nm+vP/4tB/SaY1cHvtkVTI71RK95b/CC3sfnDO0rpUZMN7GvXAOZGejKAlRkr4qVe40zwAT0m5NfbviFrw/2jp1Epz4JCR8bvw7jhhDRtyenaHdp6kdKNaF4UsCnrnlbu+gcDmSst3O6jSoiTDhfNeVuuS36bSaHyBSD7TlFReifxfCZ6tN0t21tdxPkftUG6Zn8TfA/W/kh6TT469xI1h+rDnt9H+CleS6KKCFW5O4tXZLwMPGV4zwPQlFC7NIMnktUKDesQWRaax7A5z/j3o8KJ7KiuZ6iln19OZig/22vxHCQrG41zhIMdalvNidtN2fzAB+Tiqr3ktiv9Ch3g1DsD+f3TgS9dE7F+rPAl3w41WX7sYOV89EeW44I1GC5//5dUJLZc0Jtqp5xIYNf5fjdfKCuOxKMNSUh1HmepUtdMAuSEC1i3TPbt3fItI58phrl8TL0TNPrA/g/WrA++DN+HOCq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zA4wSdRB7RJ6mufqO2SVvawFWJiTBUQzIjp//8BQCAr2xQf3AMMD4GGuNlG7?=
 =?us-ascii?Q?Z4Iq2yLpTN0vzB1fnEniY+XeZtanq8XBEIHdBw/llQ179Use4bhrVVjvpuZU?=
 =?us-ascii?Q?TudCtvHE4ZaIarXToZbf2iS5Ooj4VxT6xE6QF2mtneepUNH+/2SDWxVx8GU1?=
 =?us-ascii?Q?GTpOYwRbYFkxGTyC49Z41i6SIVoZeUsn2gOjs3kzTo+utbEN6TOlS/pw6Rle?=
 =?us-ascii?Q?H9q9h1S9BY63uc4xCic1cl7UL4922v8+R7krFgEXioeolV+hlKbB826rJJzG?=
 =?us-ascii?Q?8GEuock7tQn55lRKncveHxnOWvwOQihOscz+gYqpf2n1GPjqqkJDyX530Mhy?=
 =?us-ascii?Q?qHLU08jDBXBcYbRUbmWuUxmHvgENPHPHG3txUYpHxq1kPBP37hUxRTEaJrhm?=
 =?us-ascii?Q?Y2YenHnZzRHi5k14CMntbWLoIAW3yUS/9RK+DUNQ1twN8LA/cg/e3Z2fWvd7?=
 =?us-ascii?Q?NcaZ2KHFIXvZrIngFq9nHUG+QfGmmbxGDAMjJ0i8sanaq2w5kkB3Sz0bkbUC?=
 =?us-ascii?Q?X2ANKAXzDpYXvhdowYnUeP8jxUmb61alUbE+O6kWzgczqzgH8lxeemH3QLCv?=
 =?us-ascii?Q?gMUqwfQ0VxNagOcCDbFnpk3AFOB+rOQ5OMLY8OcTDiFF4rmqF+jcNjX95b4/?=
 =?us-ascii?Q?14KAr8OzzG3/8UW8MZ2Q3kF9DmX1Qrkt8oaOHqB8p0aTSB6zbPfz2M0ySxTL?=
 =?us-ascii?Q?uHHeaMKhfOic3hzIKZ0i4WHfVOyZqEjW5J6R9Yrmw5gFcRjaPeoOW5AmMfDD?=
 =?us-ascii?Q?EFmzd9yadm0SsSIP37EBOfhv8JbY8qReGf6v5ZXUzC0FFpH9Y90X6mqIhVpz?=
 =?us-ascii?Q?Q5XSP0Jg3SHZAKWmaxBMHlL0WSzzOsnHD0zGdgtDuq+qsiza2H7toH5bX515?=
 =?us-ascii?Q?OowSTnSFLl5zN0BRZuAqgzS/r4htEj5RkyHQB/WIvgeJQWHjSaQ57oswRLtd?=
 =?us-ascii?Q?IvsrIF8aMYdwEyAsxss+brLzYZFIR7zjjpmhajX+meBW5DbhTJOhdT+N8xcn?=
 =?us-ascii?Q?1GeH51fw5Iy+znc4f9+I/mQX3utwLZvc6G3NJ/qVEcFGWIRTngH2lXnlDtRH?=
 =?us-ascii?Q?LNTmlhanN4Wf8YvYZ8A/IYlz9T7L+vEfGp6+pVo8ACfiUoewhEGvJ7eDWTB/?=
 =?us-ascii?Q?ExIPTiFm1eIi4sClYP9AwrBrv+nOC0no4O2kvfAqatieJsOgtYHDCzHlopaw?=
 =?us-ascii?Q?AadwmjK2fTvO8Kc+PFDv/mliAVxJ9d/nIIokYdMHvWP4/tu06uwwpsg8Pc29?=
 =?us-ascii?Q?SdbPqDbtRumSodwNEW/0WpsV/G/Tgf0UizdGJWNdzlqpt4S+9w6ugvXDZJit?=
 =?us-ascii?Q?FXu3s+qDfOrZ+fl1g3ponkp0TG1oRSJOEt20zVyPhwvjsOGjMwzGbeITRtj6?=
 =?us-ascii?Q?tOOFnSCBFNRpr5vw7oWZk2Mr/upHs86x9lo3gVOR338t9zOScKHPdBn073CS?=
 =?us-ascii?Q?J9nKuIBqUQg0Xnc3WW+h5BlwC3V6bRMgOHDjCptJNRQ5WZnsrzd3QIwg+3Nn?=
 =?us-ascii?Q?sxWyKg2Y9yLdbs7umC3s0Aqmne5kpMavgn7e1rj9/nErF64OaDllyLi3YWOp?=
 =?us-ascii?Q?9oYmvcjy3tzRMqqCW8wxPw0ZIl5KLc9kLSnuMnQ5WL1VczyZn7GR5K5Tgkrd?=
 =?us-ascii?Q?Jnze6TAzHZ2MBwZoGllF7VyOT5xtfXSVBtTTFebFmC86B6hw2vieZUmeZ26P?=
 =?us-ascii?Q?XLUfkK9eszyXX5au5Isu7nhmxgv1nOPX/410BYN4spwcma9Y6gaHdTrjNk0n?=
 =?us-ascii?Q?k3LXiFeJcBVlnaafzEfrZuWNfSMrbyo=3D?=
X-Exchange-RoutingPolicyChecked: O6hNqBMgJBG3w1sterp32S1V0xcUHEbtHjj4Rhic9wYWj5ywixiipjTc+wCWzSN3muxOof6Iz0Ez7xn6cUbRSVufTbNWVxxZg5UYQJTw4WI38TjglI4fX3v64CrNMX5pYMA7rMGlVYgSkKdq3DBopoiVqc//BoDgts971/CGlD+Znmk9v4jytRmUG3c3N6a/Rjk9gCmkcjtiNSZv/Uk1KRkRFU29IsjXPqmorDnKwDGRr2H/zU0yZURunYxdRreuzoutXmfVwU0mc7BJ0awAMVxPitBK9JL7J9cITiUY4d2X9YUWcG1sqlPAx+k7SSoR+tA+ZhFWU5DkrihXxAprgA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 78da9797-24e1-48b4-3629-08dea7c606d6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 21:10:09.4776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zCYJzZ2sIGcHskauCD6onlc9aRnMWcAzyyl1G8W0E7AiXI1CYyBz+lR9imkBuLF2kstGbdMdEaUC5fKL5zEE0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6511
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF746180008
X-Stat-Signature: dwm4pu8iznsdyybimeijcm4aujafefu5
X-Rspam-User: 
X-HE-Tag: 1777669814-781512
X-HE-Meta: U2FsdGVkX1/7vsE4VQc0CTZq134lmHsttBCU6ycbd0ZD7V93rlmKD5u3IvgHgkbhHPEJLLe8pCKwxpzeqeLNF5pHjJ3O/2Wz2xShWigs0EAETz5l0FUQfs4FBnO8Ax8AfOc+0Gqz/7qe4q4dNHZPd3GVNoyOO/R8bHMQaoNILPVEHwsvmabnN/LSPolw14QoGBhfI0AGCe771m0Fsv+2HggzfQj7/cpPEmVDTEIMZPmXE3bMoY7MLG2R9mX5/hkB7R563qo/xJNSMMtzaRhwhjWRwkcmDXl3H2F5hamYBwM09VdRwfjenQ3BbKEea7kacNZCloXHm8UFZmmA0i1CoGkJnQ0fb/VNQlx+I3bWgjHKJuHqwd+bJQ04h1VcBH9StLkl7NBVCDp4GcQK8BxC3HnxSSeNqgRvOuxWzSrElzY/Za40r7GTng2mnfHLc0xel/S4xoqqk2Bck4bxQBfZ+tTZ0nWxQb3ZSlIkXGUMqe3Qhj37hHh6jw9xTDgMdjA3gN7riTGA0TKav6rHWTYgKG3S3hj21rOgZqu1UBwvmdsnK2d5N5lF/VCYXRmkPk37k1VZJvbFeuo9DujX4rTjlKTHUo2xU2Z3vlrlwRKFva2IHPFMMArDCNr1o/IjjwaL5rOQZrKfxQsTiEXX0YhdKwU6OxBc4qCXYnI7PGbmBmjhC+d3VojjpB+N71AjW5wbCnEVK28ijZ1m40umAf1lsU7ReTnm4jBdk1T7s83yyNS7myZuCmS1vaiYuYbooNx8WoAMfUIBC/tC4x0cNvCT59wH94wbw0z4h+JoZQQPZDtuXoBvY/dAnG9GsHutSfqr09ky3+N8SMEP6zRNaLTMXGy78Tt1DQirh3XS2xx7Dv70y1ANtCMNdnN/NP9o/105TN6913sL/XKkyZhPRTaOHv6G3OUVfifl3QCnrltQes86e829wVvQUoqdPGPDob1iKtVr5oSdkIxrcP5P4gH
 WD8iTyXi
 fm8ksKUoD3JzFv8dlJz34UCJvOGjnzpB4R8LRfTGiIkzCKnBPN+Ist8DcvN/cNv34FVyo/S7rN359Hb1+glLVdJ5zGbqqcQmzVAZ2ipl9RnJSkINedOpAnfXp6WLU8Pv0Gf047DZkCLaHqdJOdF4SnD5w8awkdVlLlTInR8iNMoJutFnZde+zM1fnyh2owY9ujm4ZwKLhwQRliaWSnjXiC2f3ZtLyvQzd5X0dxzPdaw/mYFFG71CnZT3+mO1+G2loUqW0SgTJ3WjQY6Pfi/LnRKlULTi4TVCzf11+ZskaIK0eAZy4v0J6WaF8nsIyxqMqI5fjPSxtzedYLDMiemnLrLfA3dZTuHY5itWM0qpQjA0psevFd/Hng7gzwk2CIjH4X/jen/40UHE/2OyzC/l4JeHGR81eF9k+nLP3gITsx2AZImb7+iohsCqqSMQso9u7gXg3FnBJzx4//2RuR2FngbSwn7qnIhCcoUca
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 01:05:57PM -0700, Kenneth Crudup wrote:
> 
> On 5/1/26 13:00, Matthew Brost wrote:
> 
> > So is this 7.1-rc1? It looks like new feature to 7.1 added by Dave [1] and
> > something look off here. Thanks for pointing this out.
> 
> Yeah. I grab his master branch daily (as of 6fe0be6dc7fa RN).
> 
> Is this a "shoot the messenger" thing? IOW, is the reporting off, or is the

I don't think I'm firing any shots.

> memory usage really that high?

I've been able to recreate this. It looks like accounting is correct
until the Xe shrinker runs - every time it kicks in GPUActive grows and
will not reduce past some new floor value. It looks like an accounting
bug in TTM or Xe (?).

Here is my output on a 8G PTL where I have intentionally triggered
shrinker to evict at least 23875 BOs (most likey quite few more but this
what I easily see in dmesg) after closing everything on desktop.

cat /proc/meminfo | grep GPU; cat /proc/buddyinfo;
GPUActive:      13100036 kB
GPUReclaim:          152 kB
Node 0, zone      DMA      0      1      0      0      0      0      0      0      1      1      3
Node 0, zone    DMA32   2320   1882   1523   1238    980    740    482    275    114     88    205
Node 0, zone   Normal   9751   9343   6466   4237   2703   1162    805    420    191    145    289

Let me spend a bit of time here to see if I figure out where the
accounting goes wrong.

Matt

> 
> (BTW, those are in 30-second intervals)
> 
> > > ----
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUActive:        652640 kB
> > > GPUReclaim:       403988 kB
> > > 
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUActive:        651180 kB
> > > GPUReclaim:       406812 kB
> > > 
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUActive:        659004 kB
> > > GPUReclaim:       399396 kB
> > > 
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUActive:        666996 kB
> > > GPUReclaim:       392764 kB
> > > 
> > > <some hours later>
> > > GPUActive:      91832468 kB
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUReclaim:       488000 kB
> > > 
> > > GPUActive:      91832332 kB
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUReclaim:       487988 kB
> > > 
> > > GPUActive:      91869376 kB
> > > SwapTotal:      33554428 kB
> > > MemTotal:       32345672 kB
> > > GPUReclaim:       486504 kB
> > > ----
> 
> -K
> 
> -- 
> Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County
> CA
> 

