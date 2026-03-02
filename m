Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6652EEB3631
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59836B0089; Mon,  2 Mar 2026 14:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCCE6B008A; Mon,  2 Mar 2026 14:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE106B0092; Mon,  2 Mar 2026 14:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 869F56B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:52:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1E8B8ADBE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:52:43 +0000 (UTC)
X-FDA: 84502170606.04.9E80709
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F70F40003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:52:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=intel.com header.s=Intel header.b=IWMNA123;
	spf=temperror (imf11.hostedemail.com: error in processing during lookup of matthew.brost@intel.com: DNS error) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=temperror reason="query timed out" header.from=intel.com (policy=temperror)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772481152; x=1804017152;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=J+mr/GKSRCO193qthYWBMQE1KJ4gSJs+0Co44XU8Kmk=;
  b=IWMNA123kv/9o9KRtYvh8TU/uL+JqVVB/EQw7x4RVoaDNXE77hQrMtJY
   vuLRbtigq1XaNQlyUa1ZDt7KlwS/oXf1mZ3aQgkVhbTzO2JcwixVcKABK
   aHcrF4DJX9gHyq9uInVnfVFAHnRqX51oTArEX+ZsJ/fWj9YlTNz3YZP1A
   NXfBuYJ9h+k/80M3hCckHpDFBvztCpy/fH3qhFYz5gN4IbTcVtWzxH7tR
   OaUXp08dzJ6oC2AdspK6xQx/4i+pvHUBxO78C6CTyQbVI+l6aNCRSDr/r
   RcjWDivFAdoMpEZJhpzY6OCTyG9QNpsimy3MmM6SECZNgaIF5zqlGuZfT
   A==;
X-CSE-ConnectionGUID: Ox1tLPisRS6+e93JPyPu0g==
X-CSE-MsgGUID: XijEQ3PnSKyIIDpM1aWnmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73407537"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73407537"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 11:48:27 -0800
X-CSE-ConnectionGUID: 0z6rJKVTTbCNqBVgNbYDHQ==
X-CSE-MsgGUID: Rl5eTqZkQkaJmrQI2+Almw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="215355262"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 11:48:27 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 11:48:26 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 11:48:26 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 11:48:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hAEBS/A7UqEgA5t9XUJVl81UKbIla9gVTQoyOjRO3kmd2Gskwk042ZVRgRP/ts94Be9ERueseUk67BuBsTbm0SavcrL6tNtD0orQev2odtQ492xgFpnBWH+cc+vFFAu7AGGU7W6NB0VDNKkAQB1jI1untqCFw+Wt3utGZgt7P6VuuDbtJAX+X2i1jxc+FkEDffmrEblctawKRwAeLa7HZ5ykEvzBgYV+nvnsu20Ds1TDFSLDQBZuNJ61TJu3YKe+X1eEnc3ku4xqBYE8VNWnq29nsfSWl+wa6IRwMYXDXDcN5WRL144AF1P7HFABIwQ6V0JPnM5V6q6Un/JH2/p3pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lt3C9Tn+dDNV0f8+/NGHfd8Xmainwq3yqLwmbqqDp9o=;
 b=CFHhDoQchzzq0Qzf0gq8/lVLNjTPN2QC5i5jZW/uFnWU0kayMCJ18lsrGKyCanO4ndR4osQ7rq7It43pkpEwwa4bhTyiJLJckHjo+xEszNDGlTVZSBmYJZoZ6wWowRRxGophk6i9Qj/PrdIw/+lgoixV1CW26DwhSal0Uee+QgOInfkh4W94LErGwvYo/lh2PgwDeZxY1hTX1wO07YK2skkOQMbFE3T6dxODLgQJJoUXMtF1E9FVfDY27VKjW2TGi28nfiQJsva3scOTpMrSUkbTeAazZRZQGYT1i6Vcwtep5A/fxIsdHnxVs30tEJmCWkgAgCtFgPFOqXtETH+U9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by IA1PR11MB7317.namprd11.prod.outlook.com (2603:10b6:208:427::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 19:48:20 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 19:48:19 +0000
Date: Mon, 2 Mar 2026 11:48:16 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: <intel-xe@lists.freedesktop.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Andrew
 Morton" <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>
Subject: Re: [PATCH v2 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
Message-ID: <aaXpgCUVXAKCfVCK@lstrano-desk.jf.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
 <20260302163248.105454-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302163248.105454-2-thomas.hellstrom@linux.intel.com>
X-ClientProxiedBy: MW4P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::30) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|IA1PR11MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c5e4cd-f9c2-40c3-3d21-08de7894a7af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: 7cUBLXk8Wy7cTaztZaOE7iVyV+godeA6TX1vdZce1QZUspR/ZQvbTq1wmrMY7QQwiHE5Qup24A16pXyfYcXGmXSY/jzvsZqi2pInO7XtUK+NnV9JIXz1UF7aweDjHyABNxKL7Q1ZhiyPBdshCBUSTM5BMSykbOJYrHchCULhXaMaQW9tkmeedpgYo9c26NIRil8OtkyL50EtDCHnnclg7Pmpzr5l2f2GryHLm9j6yXYsYow3lABnopOmqbpcq/6IMTtjfh0CpS0FtSJbT5gvDQCP8cDYEbBpb/PGDeLpNXq/yJQcLk9ufUmx4ojhyf6hnI9lAo54dTpnHOU9m5WBk1e+WSkYcFwYGqRhSup6hXcCUmJxNTW2s8LzURGENn3Mqmncu7W375QPN7d1wVUasB/tobbMGASqWW0Bg127dhb4Y8vYV6oTSiGBnLA8EVxqHFqbpq9KJxzCrEXQLHiwlQhtr7DWPhrEhkbF3yTUpktuav3vkZSwJzrwu2kCgIf4uWaYg2qBZdkNQttsz9muSWJ8mETdoJwRxMJiWGt2vuaoGkWEZNeHOCWGrwRtTxJjyeFtydspDGPX3ZMbAkpuhtDdNcBi98ewIoWHFVIGCz0CbaDYevgmm5kiHrSN1VkyRkcUdvLVJFyDSfih2Ygx5Ls2RHWSQsBajs7YnP/0Fwd5x2otMK+MrdpdiylMK4eH9BdffHAsOEC3IgMoOPO4QGOsRaIQvo+JXpDanFBbpU4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?CQEZ2F2avUehzyktrRe4bpQubAjXea3tB86MJQFhWEJqe12BkNIGjpfO2z?=
 =?iso-8859-1?Q?m0ehIVsqQeJ4HUSkjAWGHMhCbOC+8Cd2hiAZlVA0WR1trRywdI/OWzAw70?=
 =?iso-8859-1?Q?eFGo1ALgZ7si6Js2PMaiNygyu5Fr6JbvIudNcE4PE5g8HJkPpSh15Q3rkH?=
 =?iso-8859-1?Q?8NbSfTTHljcWaiMnzS/DZNqpI1SLKdSbZVPIsER6af8yShBoe+HIOV9Whq?=
 =?iso-8859-1?Q?daaWTy1YrmU6+jBAjir+sjgwydv0XDmvzyg4aCKnrJ9+xajamAbrM8990F?=
 =?iso-8859-1?Q?2GNhKMzEAn6Of+gqAkRVuPwl7nznio0B2cXMkH7v4GESoG+CRzfQD8Y+IZ?=
 =?iso-8859-1?Q?SP/ZC3x8w32BHnH6XWEIRN+9IcjBsek7wLNHXQn4h+/b0ngBLMa8p/3L94?=
 =?iso-8859-1?Q?3D009WEVSv5FKvhqjJw4WgX3uez56vMm7TswjZP8LrZeOaHIMeTAdL2Tl5?=
 =?iso-8859-1?Q?RIUVJ2tRuYRXYta78pCRM/c3ySa4eA/zYrSJaajkxSYJukc8sOcv6bc5Ye?=
 =?iso-8859-1?Q?nfDtUzTLYroy6EtCaxU4o0yr3+zUiihvGn6x2AR2VFzFV43qMX+JTsFE37?=
 =?iso-8859-1?Q?hCG9541jhgrD7LVfZltBrxo30/I68p07X4emxrMAk3RfxORD3Arq3ACxQJ?=
 =?iso-8859-1?Q?ARls4y5Va0fvNeRHD1CQBDdv7xVob7MqaxHsfV6pj/Qxc2GyyAshXH1jRT?=
 =?iso-8859-1?Q?hCJCxLpDjNv9rDU4AjvXbRuYFgfa2iMMgdMLZ2eKUYxb4yWhQJuXTt1k99?=
 =?iso-8859-1?Q?y0hnKykGRYnWq2h8n1Q+0RT1KSJjnjQiJOmQJ507cUQiO8806spG29gY43?=
 =?iso-8859-1?Q?T7XjWMlA6NaSdaW6QrDmnMu0ba8zbUCQOUt1d0aRlMEqnzwPYtHJLEHNF5?=
 =?iso-8859-1?Q?TbpjtSnqiXDT4Uc34mAApwrwQtJU21wztLX+DsXwbYusAEFbMZzz4K4T+8?=
 =?iso-8859-1?Q?hsfR1A5auWyY1Lv7WO92Qh/032yqtz+b3zYSevwzADy8L5dz3VDVklZw+d?=
 =?iso-8859-1?Q?sFdFe8IErjtpHRcx+Kwc+aBKDc3mCm74KbPfB4UdyYtNzqTz/2TjFvyBm4?=
 =?iso-8859-1?Q?R/oHgKsiYhiWTChPvtlUIpNNhClALFf1I+aSINnX42Aao2QP3Tf7rmoSXj?=
 =?iso-8859-1?Q?ynW3mWx9lw5vmkM23xXp85Bu8mSA6LYZyPdgCeESFQVRZRUPxQ8zE9fzRp?=
 =?iso-8859-1?Q?ktC9lZEL2GtP088qTEvUG6Mk9K5/ulgAsdyllkaSNd9NpM5Quo33RWbGKc?=
 =?iso-8859-1?Q?/lTU175u6Ms+J5CTCAy5KxTs09Ppwi89olIf2hFm3RxuqsbGOz22qYcNq2?=
 =?iso-8859-1?Q?l55qJwmjAyi5FPDWrGMZiagyyXEyjw/abQ7TiE7uqAFTL93mFm7jDkiznQ?=
 =?iso-8859-1?Q?rYZPTGlyZF1Li4k9VJzIFcvXk1CE1fe1lCE4aHs9EsjMC0T7y499AFQl51?=
 =?iso-8859-1?Q?53kGoiNy1xY8r/1r4PRiwIYL8956tL/duRikupxJkxagnfBX667odw9ltp?=
 =?iso-8859-1?Q?L9yvxnJczaE4zQl8jc/0OuweyDRm2s20gFFwuWki2m3u8NP+fMx+siHA8x?=
 =?iso-8859-1?Q?WssdqdgCWF2MvKfIkR4Pue8zQHrr761sBp3rogUGHJiIHAjxESzZ7mziHm?=
 =?iso-8859-1?Q?CrgQScvYftEUsj1I1+SmzB03I47opxU1s+fQnzj8uUk9vWyr6LqgxgHC4T?=
 =?iso-8859-1?Q?FTfarKH/3qardAbd0ZZtm1n+PuRK3xvg6UoCUalIfwBGJeyzHr30RUjKl6?=
 =?iso-8859-1?Q?knO3aeHt1l1F2KOexxcs1OL+uIaE9okqylmGsczoSh2KZnQOaAjHcjcwjb?=
 =?iso-8859-1?Q?u6kHA/PvGEFbh8Vfo7eDEsyij2VL2XY=3D?=
X-Exchange-RoutingPolicyChecked: zMgEjw7U9OEyWY0+5ayv173dUIUhomiWqrZ9EvyfneVEEymq1z8yD7VyuTLOxJE3/E+5AD+ikvFhgr1rJQfWC3bJvrdbobxCcSgHed5VQ3++WfZAVvdXH2CwuHsZz5hoJI5dQnEJaQjm1KsIh207LlvXG+RaB1cl2qPQssX+QcgklJdSpK7ajPFhvFIGV9SUJSH5fL4hi8Latmt34rPy/1yEjCg8Vy7y7Pj61rZA3t0BaH18U5Pym8Cl37eBpK6Jmwwl/qwzIbfNofCf4a6xjuGja2L5qtfMsw0LUDsmydxDUqaZiBrZoKdxqLjA9uKgdM6/WOjYTRGXDX7vQsxd8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c5e4cd-f9c2-40c3-3d21-08de7894a7af
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 19:48:19.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2DpLHeFf/2cjGs+JnnLYIbanzvteOQc0ew+4XNU8H+LqzMeMPh4yqo33MVvoE9erES4YK2Hls2ScZzqZaMmA/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7317
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5F70F40003
X-Stat-Signature: 6j4cziqcsmponiozahsjq1768t8ekq81
X-Rspam-User: 
X-HE-Tag: 1772481152-274169
X-HE-Meta: U2FsdGVkX19kzVUM5cJUyuFN6xqAsS4A1ak+VTQ2FZuR3ViUYcRPbMfC/Te9kp6hHdcMn/gnH2Z8DYyOA3UEFcgx9Z2+UlHXqq4ggbZgq8QqedVGXZfqWjX8wMqYzaQlFYnH+vvHR/HHwHaX381bODnKaf1eu4OIbtEawl2FS+70i8wW/xWQRf9BOweWf/T1Ob9cQJU09OCY/wBK2SnwkxNirjGgYD8GoRGqRBpvRpQ1tsuIEFfsGpHpW1T2v8sPVUtaCwmvwOqssbg/DNnfurpVg+a61Ahz7veKmIEzgdfg8AZ1HZSnHLEGP5ddWMZJ4AhmbJCAJb1vWJ36QG/C01VNuiBSLlXMCvnuQ3/D0M0OhM05yGwveWc61AFKRhxS3iOZKTCs9t8kuX1WGuheYDJL90l3pm62SfiDN6npsf389qXRmeHUNXxQjeyYtpTGmVHBg+ROQNQHCbwxKVYfuDrDk80iMouRA43Hlz1y/5Am06UXnOZqS72fcsct/0TmKq7Dqy0pxjPEGxVBskunh6hRG/ZaGgG3y5+WEPurkcrq+tiJ3oOqxUUqzZhGn2u/5u02ayv1bDWoqufdVXenpcbBEsrH0SXdmiS62NnBSwAgKVOx9+xmTfgYsKLUdsZ6WA5eh7/EwnkKQm5C+z+DWf52V23yFHDjLivt7TmuR4YzI/56akBspssdle4FNXnyCJAuevieGEUXsGcva5DE1yQr39TYd4InOClPJy4oWzWMA41lQkP6CEMpmQOYqW+QZGX93QGgyXWzReSfbO05vOWphA8qe0P9EfDj3VeThukCZT1EH6De+B/jEIgqLpO6Dihhp5vXLhvpiyNHH5b97Iaf0NzPT4NGgFqWpSH0xh0Vlm7XxBj4XPqti+0kF/w7W60W1XgkD4sUDHjGFAobPot2iDJqV3pfxPI+GkGZGEDz1k3oUiOdix1J2wz92HEZZKqrFB/n1gpX0vN7eXi
 k7OjdRbh
 9SYuYyzxun48FScxE3qgUfp1WldLirxS/qL4Jww9yt/R6feWOxj8Oz/9bYF/9EqrQI2BZ4Fj9B6Xmlf594sorSKlB3WVx9qgYbDol3AqssGuXg99IUCQyfxqNfRc0gv+8Fy3T2++MPkUQbcwP9CPBodccw5ib0+Mh9Fj06rze4ABjVG90eWr+g3oU1HUi4NJMmc+gR0pxCyESGdi9y5i0/zVPkvf2nh9CMRLi2f9u333WZ/o1ApcSDvEattyJFZhwHIPE6lOWiAtRuCdsbdDKee+T4A4cfdQCmfi+ODdS4d1GEtYNOHp7HdyWhWm0wowju2jZARqeLrXgd5rMkiKrF3eNIsB+ee1ZpKXPszxpw05qS8s/EAj+B1vNWOG5gLTyQm0XMNEHnEwNOZ9YtqZ0WqwzSNzgwAKGXDgCBdBT4mQd/LOKkV6lKtjv5XUqcDQSxpK5rOjHwmYGLQg8ZTvl7gFygsUKvl0Uj2/vW0RknhtX9jvqIXovIELjVPA4mTBNqZ54BkOxIdtsi0ECWGtt0LEsgfbFAxltzRKrDqfjeod277iuF9OkLp02qD1RW300pk1tILk+jG+ycRjuqpC/jnZs2nyDslDmXXkb8MzSMxQZvtjmGYp7F0QNsxZ4GFVGuJZ+ZNfBzN92CyCgMSKPKXuBoeAOEEQl6VS3e7hq4jiaiKBx+CMBoVa0XGF/DTFd1RNXasD8nY7G5tLkzd0Kg1K+dF3dwtlYOBf5Tlbm5E5KXqBc2FJNcXQFBqr+aqYyIY9OEpBp6tMaiXeoPTXS5yBPkChaD3oehFk6BuFyqXpTqdqsBtI+POjwAE4+gWfspevmKosUtakElKVQXLSZ97EOCI6nUVJZc12NJQAreC1ie8ATKPgkiAKPKnTfOkEwR8PpiEF67YajcwPtx6E07rbRWfT0TWV+ibrb+tOszwU6CICkuBHMvnRaVWHG7hsBa3MqIO4n/jFc7IX+KlLDvABKhEOn
 VUb8lDZu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 05:32:45PM +0100, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears to be the right choice.
> 
> Implement two-pass capability in the mmu_interval_notifier. Use a
> linked list for the final passes to minimize the impact for
> use-cases that don't need the multi-pass functionality by avoiding
> a second interval tree walk, and to be able to easily pass data
> between the two passes.
> 
> v1:
> - Restrict to two passes (Jason Gunthorpe)
> - Improve on documentation (Jason Gunthorpe)
> - Improve on function naming (Alistair Popple)
> v2:
> - Include the invalidate_finish() callback in the
>   struct mmu_interval_notifier_ops.
> - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> - Use lockless list for list management.
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>

I thought Jason had given a RB on previous revs - did you drop because
enough has changed?
 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simona Vetter <simona.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> ---
>  include/linux/mmu_notifier.h | 38 +++++++++++++++++++++
>  mm/mmu_notifier.c            | 64 +++++++++++++++++++++++++++++++-----
>  2 files changed, 93 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 07a2bbaf86e9..de0e742ea808 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -233,16 +233,54 @@ struct mmu_notifier {
>  	unsigned int users;
>  };
>  
> +/**
> + * struct mmu_interval_notifier_finish - mmu_interval_notifier two-pass abstraction
> + * @link: List link for the notifiers pending pass list

Lockless list?

> + * @notifier: The mmu_interval_notifier for which the finish pass is called.
> + *
> + * Allocate, typically using GFP_NOWAIT in the interval notifier's first pass.
> + * If allocation fails (which is not unlikely under memory pressure), fall back
> + * to single-pass operation. Note that with a large number of notifiers
> + * implementing two passes, allocation with GFP_NOWAIT will become increasingly
> + * likely to fail, so consider implementing a small pool instead of using
> + * kmalloc() allocations.
> + *
> + * If the implementation needs to pass data between the two passes,
> + * the recommended way is to embed struct mmu_interval_notifier_finish into a larger
> + * structure that also contains the data needed to be shared. Keep in mind that
> + * a notifier callback can be invoked in parallel, and each invocation needs its
> + * own struct mmu_interval_notifier_finish.
> + */
> +struct mmu_interval_notifier_finish {
> +	struct llist_node link;
> +	struct mmu_interval_notifier *notifier;
> +};
> +
>  /**
>   * struct mmu_interval_notifier_ops
>   * @invalidate: Upon return the caller must stop using any SPTEs within this
>   *              range. This function can sleep. Return false only if sleeping
>   *              was required but mmu_notifier_range_blockable(range) is false.
> + * @invalidate_start: Similar to @invalidate, but intended for two-pass notifier
> + *                    callbacks where the call to @invalidate_start is the first
> + *                    pass and any struct mmu_interval_notifier_finish pointer
> + *                    returned in the @finish parameter describes the final pass.
> + *                    If @finish is %NULL on return, then no final pass will be
> + *                    called.
> + * @invalidate_finish: Called as the second pass for any notifier that returned
> + *                     a non-NULL @finish from @invalidate_start. The @finish
> + *                     pointer passed here is the same one returned by
> + *                     @invalidate_start.
>   */
>  struct mmu_interval_notifier_ops {
>  	bool (*invalidate)(struct mmu_interval_notifier *interval_sub,
>  			   const struct mmu_notifier_range *range,
>  			   unsigned long cur_seq);
> +	bool (*invalidate_start)(struct mmu_interval_notifier *interval_sub,
> +				 const struct mmu_notifier_range *range,
> +				 unsigned long cur_seq,
> +				 struct mmu_interval_notifier_finish **finish);
> +	void (*invalidate_finish)(struct mmu_interval_notifier_finish *finish);

Should we complain somewhere if a caller registers a notifier with
invalidate_start set but not invalidate_finish?

Matt

>  };
>  
>  struct mmu_interval_notifier {
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index a6cdf3674bdc..38acd5ef8eb0 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -260,6 +260,15 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
>  }
>  EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
>  
> +static void mn_itree_finish_pass(struct llist_head *finish_passes)
> +{
> +	struct llist_node *first = llist_reverse_order(__llist_del_all(finish_passes));
> +	struct mmu_interval_notifier_finish *f, *next;
> +
> +	llist_for_each_entry_safe(f, next, first, link)
> +		f->notifier->ops->invalidate_finish(f);
> +}
> +
>  static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  			     struct mm_struct *mm)
>  {
> @@ -271,6 +280,7 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  		.end = ULONG_MAX,
>  	};
>  	struct mmu_interval_notifier *interval_sub;
> +	LLIST_HEAD(finish_passes);
>  	unsigned long cur_seq;
>  	bool ret;
>  
> @@ -278,11 +288,27 @@ static void mn_itree_release(struct mmu_notifier_subscriptions *subscriptions,
>  		     mn_itree_inv_start_range(subscriptions, &range, &cur_seq);
>  	     interval_sub;
>  	     interval_sub = mn_itree_inv_next(interval_sub, &range)) {
> -		ret = interval_sub->ops->invalidate(interval_sub, &range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_start) {
> +			struct mmu_interval_notifier_finish *finish = NULL;
> +
> +			ret = interval_sub->ops->invalidate_start(interval_sub,
> +								  &range,
> +								  cur_seq,
> +								  &finish);
> +			if (ret && finish) {
> +				finish->notifier = interval_sub;
> +				__llist_add(&finish->link, &finish_passes);
> +			}
> +
> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    &range,
> +							    cur_seq);
> +		}
>  		WARN_ON(!ret);
>  	}
>  
> +	mn_itree_finish_pass(&finish_passes);
>  	mn_itree_inv_end(subscriptions);
>  }
>  
> @@ -430,7 +456,9 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  			       const struct mmu_notifier_range *range)
>  {
>  	struct mmu_interval_notifier *interval_sub;
> +	LLIST_HEAD(finish_passes);
>  	unsigned long cur_seq;
> +	int err = 0;
>  
>  	for (interval_sub =
>  		     mn_itree_inv_start_range(subscriptions, range, &cur_seq);
> @@ -438,23 +466,41 @@ static int mn_itree_invalidate(struct mmu_notifier_subscriptions *subscriptions,
>  	     interval_sub = mn_itree_inv_next(interval_sub, range)) {
>  		bool ret;
>  
> -		ret = interval_sub->ops->invalidate(interval_sub, range,
> -						    cur_seq);
> +		if (interval_sub->ops->invalidate_start) {
> +			struct mmu_interval_notifier_finish *finish = NULL;
> +
> +			ret = interval_sub->ops->invalidate_start(interval_sub,
> +								  range,
> +								  cur_seq,
> +								  &finish);
> +			if (ret && finish) {
> +				finish->notifier = interval_sub;
> +				__llist_add(&finish->link, &finish_passes);
> +			}
> +
> +		} else {
> +			ret = interval_sub->ops->invalidate(interval_sub,
> +							    range,
> +							    cur_seq);
> +		}
>  		if (!ret) {
>  			if (WARN_ON(mmu_notifier_range_blockable(range)))
>  				continue;
> -			goto out_would_block;
> +			err = -EAGAIN;
> +			break;
>  		}
>  	}
> -	return 0;
>  
> -out_would_block:
> +	mn_itree_finish_pass(&finish_passes);
> +
>  	/*
>  	 * On -EAGAIN the non-blocking caller is not allowed to call
>  	 * invalidate_range_end()
>  	 */
> -	mn_itree_inv_end(subscriptions);
> -	return -EAGAIN;
> +	if (err)
> +		mn_itree_inv_end(subscriptions);
> +
> +	return err;
>  }
>  
>  static int mn_hlist_invalidate_range_start(
> -- 
> 2.53.0
> 

