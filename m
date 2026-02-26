Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2159DFC5908
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF196B008A; Thu, 26 Feb 2026 02:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5524F6B008C; Thu, 26 Feb 2026 02:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCEA6B0092; Thu, 26 Feb 2026 02:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0606B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:26:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8E758C95B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:26:42 +0000 (UTC)
X-FDA: 84485775444.17.31F9713
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0309620002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:26:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bFvpl9Ce;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772090799; a=rsa-sha256;
	cv=fail;
	b=JGNybZWSgWlEerdPAVMTutabV7WLc5c2nWpNogmILRzHtoqqqqz1gN9KP2sn/1tihXotEB
	BsKQmozH/wbvI+TuKHkaM4qKZE054ys/YB9rQ+p96R17gVJ808zgV/O46gGfsXC1wsj/6U
	r3Gs3P0g5xsziu66qWCc5frkuGWRTGY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bFvpl9Ce;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf03.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772090799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2IqnSdp0GlCGR0BU9EH1XetnmOjBjvD24J/a4cpuhOk=;
	b=jb3tW0zB0l1dSURtx1ak2W+jsrMSSyKxgUDwo0PhvJZ3yXxwBw925OonVfCKBtyOTCFb64
	SvX7o64pZhzKysQ0vGyJDSaDUBshGJ94HCsMvE+U0P8153B/dIH+8fW8PUOv+wDqf2bSqX
	FHHIHJ2udo1X4/ugw92hGsLyGJCvjrc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772090799; x=1803626799;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=hPIL4SqAzy5hYxPg9PjZH/h+07z4hM9ZjAPW5HfxZLo=;
  b=bFvpl9CeyaLtQ/bpqU1/KQgQlFwr83LiEIXjfF0XY2gyjaPyFlAwUIqq
   ikYyhw32Ymg2VKAZqu+J25Vl3/f3KqTyUjXduz/EPes6otbNs7tDLJDC4
   a0H97fNc39FF7hyoLsMUUFxPKzd7q6SWNlZXh1zQHR9S7hjed6lowdhZw
   hVoHAYKBo9zsNAYHWyCxDXEVbSRU8mo7LFMRRRn82gEHdN+4TTip7D4fR
   zYWK9SuDLI4aPRsTPbn04X0UFnH8BcQU9NzOoEfmUs4HkqczRg13qRja1
   brPw2wguucnNftB1A/5ygkfj1pYj/Ry69kzlr0+sES7VsKTVq86uKKfF+
   A==;
X-CSE-ConnectionGUID: pU06FuXJQgybjnjH0SAt/w==
X-CSE-MsgGUID: JeJxykGQQc+YTM+xnMKVQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="84500742"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="84500742"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 23:26:35 -0800
X-CSE-ConnectionGUID: nLE2Y9B4QKqItZsUp2alRw==
X-CSE-MsgGUID: /493rF4zRkqyEVc8hWkA3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="221462891"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 23:26:34 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 25 Feb 2026 23:26:33 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 25 Feb 2026 23:26:33 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 25 Feb 2026 23:26:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WgKdP+9wMzMbeyXwmjTco71SYIeP7IUIn280aTmd5Uhobj8KH6t6Z68c0JsQA++7ncFI8sB1THzxPzn26z3sJY/oz1s5+xwF0EHN7XDFNFhmQxgPwJQYA78lvkPf3aA6sz14HsTCq7EPruVGS1TpVi1xqdqaHI2LxBEOOAU1tN3VYknqYj6+gZYwPJdbWsK96olhW5Sjf4FrISRqdcODD+knBFRHZTK4dUavlYeb1Xz7Pko3EYla8swQpTxM0PNX4eS+HpttmpnQBbv9pCSjrCh+1SRgdqxhc3SHh5SqDx6YfAQLIgIfkHm5DontT2js8ZnWlA//kv8kTN3oQMm5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aH17W20esjCWDSGIfY36znyukH7m1GW4RTpNNyMXLNI=;
 b=WgryYX/ijal3grpZkaB4zypUbs/k/Xa9ekwG/19XBAtnaqBVlShNLa2jBe8KcVCFzyuEKJRvCgv48I7RHQGjkFiHpiYduc8MfDafz9oR91X82ET4VrI0UWdFom17AX+zx8sUaowDzR9zk/gCGWi5nVlPBGYil6/CKr4B2MXoYkgyBQLicWKpDC0w5xGKLDX9k6nPfhW7qOKBBI3VlMRUj7KibKlLhNXGUyFQrJuYzpcAiYcAf4DeqCfwIqE0NsAVobKEXmF0E+tZ/iOBF5tREiBVeiK5T6uKJaRRuVFFs2YC4AQFYJwRzT6X8RP70TEMMi95IN/YpfVfGIDJhyT5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS4PPF10012BF96.namprd11.prod.outlook.com (2603:10b6:f:fc02::a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Thu, 26 Feb
 2026 07:26:26 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9632.017; Thu, 26 Feb 2026
 07:26:26 +0000
Date: Thu, 26 Feb 2026 15:26:16 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, "Suren
 Baghdasaryan" <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [slab]  17c38c8829: will-it-scale.per_process_ops
 60.5% regression
Message-ID: <202602261526.dc2fdec-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS4PPF10012BF96:EE_
X-MS-Office365-Filtering-Correlation-Id: 634ea035-4f2c-4ac7-601b-08de750859fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: YZRUJGjkaPPWZEQSAm8iKD7gCzcRE/55fAqenS8HGq57ATjKho6IYmqaf725bKWZ0rMVNfDNw+uqNm81rNMQbeur0UD8RD79XKAC491LPsfbZxiRky88A54FNF5+VleUhFbBX6fixiZ1zUbzUDEjzvJHJN/twChyGvbfmNpnLGRG4P4GLJWJiHRZZaWeSQjqvYRyEC76P/0peB7zib0SSs4LLyDZpTfYzDU8N2XSDd7bX+zIm3hVssne3io3z7vYhM7F3nS7Q1bISfF9N0OrCYlRAFv5LkYU1jSIpa2QbmAfolFVX9jygfTdrXK4fE0cguk745Z54aAA8i3vueVhb3o8SShQfsrrehppmdWy8ZXhgzr2pDk3JcOz8cdWU6HeMIpRdnA7WaZbkIpgPd1wreQ3GWmDY7JMG6KkwEAbRl6UmaeF6R8xp1TmJ7C2M97kRf4igqEgLoQaF1I95rSH4Po/kXhGp2R7iuD3itZ5yzzwQvW1CGtaq7WyoKc6QHkwBSZOUwDt5mkzZUlGsje/toaqA5JxIws5QjMy3hD9Wqp9WqjDTDrzgWRhYABLbxbiuPnpmXAp+EHQnbsh+5m+WkgacyY6oDfFglfl2JV+EMHkhlL6m0mRpj1MWYAR5c+LBCW1EZmb1jWWDGya4SxfdeficWlo1vRTxTGJkXu8L5HfBay6R6f40u91hVIQC8JOUBZUMr7SRqYLF5ljxF7AJOlfkasK80owVN1JhHwptsdzkDAytSktzHSYN6NwgJ6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?YnbfVBYWP/cGHs1NZTlZdYszUqYhqlxhGfMwp8TUxi+V0G2aWl0AD0ry3H?=
 =?iso-8859-1?Q?CTD32BWv9ndjnvrN4EZVTgGlwR3ugBvU3P7garETMDQp1u/eAJHExG8k7s?=
 =?iso-8859-1?Q?CXgxFnm0x/2Tjt+CfZQWXNSOLz3KtyxSkDRmtgRY3EX9b0tzmFHvAJwBu2?=
 =?iso-8859-1?Q?VDFD9O8Sj9Qzqy/NN0np4L0ydGHL/HvVRnr5BwpVdhsRSohTFXRLLdRJrD?=
 =?iso-8859-1?Q?XwLtvLEJ7ARoJ1Gd+U8ZXcAHwAwxnpagc+Akx3Rwoq/nZccLsFesXJcUtC?=
 =?iso-8859-1?Q?WUtBecntW/O3UDIP38vPGeMp58oLnm4wO2wLtrktbxzNQscocgDPo/2i1U?=
 =?iso-8859-1?Q?skapTM7BuDo9rq2mSDIWnOrbROE7Cyds1pPnjd1+6PrNtvmtVTeElHUWbk?=
 =?iso-8859-1?Q?ToDa/O+vJSmmT+auuHiqRH3OGMqKB79dTydLq44KyRRILVgunykCMdzcPX?=
 =?iso-8859-1?Q?m1lUuCiv35gb74qPTZU0GYOCQPmgPTK0ZNtObbyQzyrdKE+FHV4Vm3d9X7?=
 =?iso-8859-1?Q?iRqsl1y+DVzttMjPGM9K2UqjDYHZWAsIJyslS+/WEiwZfDu9I0PKDWh3wK?=
 =?iso-8859-1?Q?hGxRoM00jIlHjABdBycLda/sPbbQNBNNOBcU5hUCwMwWdXgtp73394fbCl?=
 =?iso-8859-1?Q?tGetf381TUpYuHDQj6twu2TfOpw1L/eLQ8a3eL5Jr9du1I037N5WSJx3nQ?=
 =?iso-8859-1?Q?Qt+4JAAZyKaQwFK807DYPSnqF6l0J34NARPMH9BFjmKsHt9r2+ZmZM13tq?=
 =?iso-8859-1?Q?/LEL2yM7yDS97wwh8VnVw1omCk0pvq+SiAZeJjOMGOGKcoP2ZvjdIyiRFw?=
 =?iso-8859-1?Q?2+MNz2zu5kQ7CoAuVyoA7u1kcRO8kfRacl69tUeS3JUFa05s0ZndgdJHNy?=
 =?iso-8859-1?Q?5V4SJ/T0Knhx0Sq+dF9iaSwqG1es9sEsmbe19E1p6ELTyDcha30AqqY0/A?=
 =?iso-8859-1?Q?3HbEdUVz6Pjy6Km6/32SjjcBrTfnk0OSd9eT/TciAm8m37P44Gm2Nxh+ey?=
 =?iso-8859-1?Q?KSdLyV3mV4qH3JO4Pd2j0niUhGfgweDmeHgrYM9AvrSN9vnUM6kH7qo8m5?=
 =?iso-8859-1?Q?OZxjlibTVJsO8sJXIPMLnDBlzNp0+1iikhsxIBHomJg7ZtMWQec9g2P3bI?=
 =?iso-8859-1?Q?uq5APDbdL/CkXNAIPLFXCW6CReRgAEQMmpKt6W86YhDFVij/zZbu4Ndxvn?=
 =?iso-8859-1?Q?DgMW56JlR3QNA4H2AFGr4OZPpaaDh4UB3tfVVKuUq/+uvlhgv6CuYpfI8G?=
 =?iso-8859-1?Q?bHMVWMQ9Bsn++oGsISONalSjID148C8NFnbcwXO5S8550bjd3gIckyj0d0?=
 =?iso-8859-1?Q?aJFPiYrSMLim0Sl+8GBoKx1JWjfEfgn+wyRTqLmYd9zvqscC774kRAWyh6?=
 =?iso-8859-1?Q?Aaayl0Z+L309pLD2Wgjw4E8oBGfuad5GqUl1Qiy+r1Mpntnp2Xu7cubPQ/?=
 =?iso-8859-1?Q?0hz1JYe6CD8zjvxLCkKy305TvFMiA9fmJ25Pa5DRKcjQhFPEE6OrEQYcLP?=
 =?iso-8859-1?Q?D5afAGm0jBkrKORNmvEgr5Lzgx18vR+QDr0UA1SM+CQPnTfhLQdOfFhynJ?=
 =?iso-8859-1?Q?c9NmQRDc/Avv7uDotuDuY9uj8yv39NMRcgax6Rv87hYPiAaLjV8JSQbn1k?=
 =?iso-8859-1?Q?A43NNiIyqNW1ktH0S6Hgj3TORTyh9131kB69zVUuw7EgIDl5C+pY0WkVsq?=
 =?iso-8859-1?Q?XkKBUEbMG3acBaR6C9B6xP+FM3pWj6E5vU/sr3emiE2Y+d0pvnhH3F8+bX?=
 =?iso-8859-1?Q?UE642cbhCq8eHKvn27Cpub0y3tJsQZMPx3Uy9at6gjQs1mm5peTC6/mcJD?=
 =?iso-8859-1?Q?hsQYajsagQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 634ea035-4f2c-4ac7-601b-08de750859fc
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 07:26:26.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrdtrDd3KtrPGW6x+rnBs3NA97epAwPNDGXrpUz0CSdQaT/OAeED3Zl8lSZ1c8weJ3IxT12cYCKj4p/Id3M2sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF10012BF96
X-OriginatorOrg: intel.com
X-Stat-Signature: s8m8h94di9sskcmjuwdw5zexfy9mb336
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0309620002
X-HE-Tag: 1772090798-555591
X-HE-Meta: U2FsdGVkX1/p3431wzn1i46LAnoQ5xKemfkJNgA2d7+kN5zQRlDHDAsiaHeReuv0oV044zBnlZt1Ewn8Fm6BtgcJmznJO41pSvVL7fTyPPoLFVeRE7KCSyedx8YV2GJcbOqG7s1srPJHgVbSXxhLV3EuLcgmHKOdhAO5Akyp+w8KnPcAHAaCT6hMWSR8EUUd7yzzlEje1fQZT2pE3xpqin54HeUqq6jC80mRPV1E/B98xqzobRSUF/c/Q0UpToQykvpmzYmyIi+Ya1TsUIPfmvfsRw6F9L/7Wuei3wYcdmGaGZlP3dSkY8UPBHj+rsLRXj/+fflD+RFOhXwt/YnLKpVSaJgXWU/OPIkjEbhl8gNgOXxlzJtbF8dv4fWmNSP0apO0iOg6gsqlBEpVFZbKWPAc/aHH/jK0MLXkkQW3eg3a0gug60kw92wi9RyaIcwVqLM7D9iBN34x71QsGkHvomrzEK3yhr9+hB0FyxjaXBapmrEffhkkBGwC5zflBvGFsW+yUq38IYhpOFJeDnPe+gFTJi2xzAhvm+Z/VwzbI+soEmTI3ZJ9RAYqwUPDMK0Ktoir2mIIKZYWgFUs9MtTphqXXtoP+CqQlx+OPDKdXs6l0+E0iiVw4ziwggDk0t3KyPRyRtp7+jYhfFHK1xCpfne1iQ3tDdHP4nYTS7U4L69BOHJ2TUPUZ8sv9+phXno/lRgavESDaDmO1YmNoBJmH7CYwljm6FdRCFl5PQYFy+srTgi7nwfg7U78kv9+bDNu01aIFXg4xW5GLeQjpONDaCY72F6NA3fHo4D8yxEaSjcfex9E+Sztfui258D809lozAk6+VJnTL1qKj7XadqH7CGT0W96p0StYJ1xOswjjU9yqV0YV7L43godZWTvrwG9rG3EcMSxDay7omCMwGXjPhrNk6DMVQ0suuqfKgR6bZvJCgDR+wiGxHAz7Ws/9Ys4KddrTcTZJz2kHQmv/Z8
 zqaKrfXX
 ibjaqFT4BZGxXIyt6UCtGM1oGcTY6I+2W6nD0uXdYpoqYAj3/jKh0MBIdh6wiDrPk+WSiSCWD26+KTqXfsxHmDuVqLh3DqTUEZNQ1M6RSfeFwP+4J6GepMt3hXRmWX72qp39wromqSm9VfA+Egug+r6r2FU6MzXqXTIgiBlKhlf3rPGR8OgiwzUwLfsnKNQxhqhDVvAOVs0q7xAhyy5HH1ZAJoDIgvL0kZ2dA3HCK5SsBNNmDWMc/fSQC4ckbqqSeMmZ8qX+FpawVEoW05D2Ev1NGxz1XBubgbRrvInYodO1aBf7vWgUWRJAF7E7qJDU0qT4l4N02e42OZJgVZwu4LytRUYVuuNVcwLzmb0uSZjh/5Jw+H1Y9giq7iril0Ej5YbZcemcezJsfDDJXsCv37Yiv5x1yCFPpYAzt2RfXYn+GkB6ChT06jOvkKfDUxmg5rklttKfWDdRQLYED5Di/IT9N8qKH4IMd1y7ifX2vRdmJCtdKO9Qh4iwLEThsDhrKeNK1DmRlWpTBhMCstldwjHMw9HwUaWjxGSHHxoI6XR9Cg5ylunRebDSB2Qnj67wgC7QO2SQ81IZeVFCEohX/02GE3aTULg1A3sJgthUa9YF24Sb85mLbebhHXrVP2/b6MK2/03N4cVgDR9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 60.5% regression of will-it-scale.per_process_ops on:


commit: 17c38c88294d75506c67cae378c9e940d1ce55e3 ("slab: remove cpu (partial) slabs usage from allocation paths")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      8bf22c33e7a172fbc72464f4cc484d23a6b412ba]
[still regression on linux-next/master 44982d352c33767cd8d19f8044e7e1161a587ff7]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
parameters:

	nr_task: 100%
	mode: process
	test: brk1
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202602261526.dc2fdec-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260226/202602261526.dc2fdec-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/brk1/will-it-scale

commit: 
  ed30c4adfc ("slab: add optimized sheaf refill from partial list")
  17c38c8829 ("slab: remove cpu (partial) slabs usage from allocation paths")

ed30c4adfc2b5690 17c38c88294d75506c67cae378c 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  22625956           -60.5%    8947026        will-it-scale.48.processes
    471373           -60.5%     186395        will-it-scale.per_process_ops
  22625956           -60.5%    8947026        will-it-scale.workload
     20.65           -74.9%       5.19        vmstat.cpu.us
     10502 ±  3%     -87.0%       1366 ±  9%  vmstat.system.cs
      1.31            -0.1        1.20        mpstat.cpu.all.irq%
      4.13            -1.9        2.21        mpstat.cpu.all.soft%
     73.24           +17.4       90.61        mpstat.cpu.all.sys%
     20.67           -15.3        5.36        mpstat.cpu.all.usr%
    179.60            -4.1%     172.24        turbostat.CorWatt
      0.39           -40.0%       0.23 ±  2%  turbostat.IPC
    211.17            -4.4%     201.86        turbostat.PkgWatt
     21.36           -45.0%      11.76        turbostat.RAMWatt
      0.07 ±  6%     -38.7%       0.04 ±  9%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.07 ±  6%     -38.7%       0.04 ±  9%  perf-sched.total_sch_delay.average.ms
     18.17 ±  3%    +262.0%      65.77 ±  8%  perf-sched.total_wait_and_delay.average.ms
     47429 ±  4%     -84.9%       7139 ± 10%  perf-sched.total_wait_and_delay.count.ms
     18.10 ±  3%    +263.2%      65.72 ±  8%  perf-sched.total_wait_time.average.ms
     18.17 ±  3%    +262.0%      65.77 ±  8%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     47429 ±  4%     -84.9%       7139 ± 10%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     18.10 ±  3%    +263.2%      65.72 ±  8%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.68           -83.8%       0.11 ±  6%  perf-stat.i.MPKI
 1.657e+10           -35.2%  1.073e+10        perf-stat.i.branch-instructions
      0.27 ±  2%      +0.1        0.34 ±  2%  perf-stat.i.branch-miss-rate%
  43387409           -17.1%   35980500 ±  2%  perf-stat.i.branch-misses
     38.35           -35.8        2.53 ±  6%  perf-stat.i.cache-miss-rate%
  56795946           -90.4%    5475678 ±  6%  perf-stat.i.cache-misses
  1.48e+08           +48.5%  2.198e+08        perf-stat.i.cache-references
     10520 ±  3%     -87.4%       1322 ±  9%  perf-stat.i.context-switches
      1.70           +65.9%       2.81        perf-stat.i.cpi
      2499         +1000.8%      27508 ±  6%  perf-stat.i.cycles-between-cache-misses
 8.369e+10           -39.7%  5.048e+10        perf-stat.i.instructions
      0.59           -39.7%       0.36        perf-stat.i.ipc
      0.68           -84.0%       0.11 ±  6%  perf-stat.overall.MPKI
      0.26            +0.1        0.34 ±  2%  perf-stat.overall.branch-miss-rate%
     38.37           -35.9        2.49 ±  6%  perf-stat.overall.cache-miss-rate%
      1.70           +65.9%       2.81        perf-stat.overall.cpi
      2500          +942.6%      26067 ±  6%  perf-stat.overall.cycles-between-cache-misses
      0.59           -39.7%       0.36        perf-stat.overall.ipc
   1117006           +52.3%    1700887        perf-stat.overall.path-length
 1.651e+10           -35.2%  1.069e+10        perf-stat.ps.branch-instructions
  43243442           -17.1%   35861582 ±  2%  perf-stat.ps.branch-misses
  56607711           -90.4%    5457714 ±  6%  perf-stat.ps.cache-misses
 1.475e+08           +48.5%  2.191e+08        perf-stat.ps.cache-references
     10485 ±  3%     -87.4%       1318 ±  9%  perf-stat.ps.context-switches
 8.341e+10           -39.7%  5.031e+10        perf-stat.ps.instructions
 2.527e+13           -39.8%  1.522e+13        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


