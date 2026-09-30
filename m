Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14DE2CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED016B008C; Wed, 30 Sep 2026 08:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5126B0092; Wed, 30 Sep 2026 08:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4386B0096; Wed, 30 Sep 2026 08:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF0BC6B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:07:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F3141207C1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:07:48 +0000 (UTC)
X-FDA: 85270304616.04.4B2EF48
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFCC440008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:07:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BbkGfO+C;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790770065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsywyyffG4q1NIRnHQi8EB2aSrTnpwVjGXq8b/DCV8A=;
	b=v116vH+n6rNMymvNswsK2l0iCOciQsm7njl6KVf4lN/cBrW9ttqycXsf1uaas7OUYxRF3q
	HXV2xJ++9d3hKVKr9gqtDfXYgajJkSwjSD+VnuaYXWgUz5caHH5iFfIX3hUUmHYK1ZY0Hp
	au1kl6hOwn7M7LCLQhksy135fIHx3HA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BbkGfO+C;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf12.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=philip.li@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790770065;
	b=Zg1326EUd7rq96pRBPcAT2Pph+qrht4Yt3gtMJ97KxtY/YXyP+bJrdFp99jD6HQB1g+MDL
	oEF+4pAzQIwlCWRkVHRleESmocqrrl+JPRtd1GT7pP4bfbYpFWWL7jFzHJeC7n5LCcNfI0
	+f47V1842Ga4auHhasIobf7gZzurqmM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790770064; x=1822306064;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OOgpiqKWpIg46xmlwlckN/5oX4CsvqMDjAuzmLSrLCU=;
  b=BbkGfO+CgXeMAEwonVYWAdK7ThXsmJHtQjzzKnHSUTVbXAdZMeai3lwv
   ltz357Is3QT9UzwaGunuk3zC5+viFFqa/Oosh1MX5ZQwo0yquelWC1eB/
   2MO2T5xuuMyUlia8HCex+49emYWNI34VsqFogGdqF4OtnG9Q6J5naO1iQ
   B9boW8pNZENXVTu6Ck4kBKBkUdcxXPGF472Ao1ZE4ob3HLQCE8gWuC1Gx
   09TPgI9jfaioSviHM6CkxXhkTE9Sfc23qV4vLOsPWgDHowdifA8TNfCXI
   jUDmv0rl1IvIKdFBx4hx/Mp6fZpIbnVqwLHX2BJ+5BOjmUincEtMHi/kf
   A==;
X-CSE-ConnectionGUID: IbFBpAVmQMqI/ovMOgZlzQ==
X-CSE-MsgGUID: e/x+DUh/R8OvsgUTpWEaGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="102076923"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="102076923"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 05:07:43 -0700
X-CSE-ConnectionGUID: tYkqbIDHR+WDlhcj9lVsGw==
X-CSE-MsgGUID: DGzKVbuCQs2qX52tkEBDPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="272132910"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 05:07:42 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 05:07:42 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 30 Sep 2026 05:07:42 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.9) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 30 Sep 2026 05:07:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dzBJOrTAG0JJktKqIvcHnXvKmCQqaCD1PafN4WmnJ7t+Masmsj4PVW0NDdOueb6lg8Auxw74IWNGkeua6PG+IJdf5U0RMI3CsvddlGZQzQKTcagcqKeEOP7RQi/gGvJnUVO7CoqjL5B2VPUzLMKN4yvLljVoM0OZflHLVLg+Q43cDHSHrOYBE7v94vFS/tlJn6tNqJ87P3pZ+F44j+HQmoocptntubqSRl00m0oOyVB9KEYlectyJuUTL2M1kVTTksTb1b2eF7ZVaZZFr7D9YxPumLTTtkgD1aEUedW1izSUOO5ptiKxLU3Lg3j44JhkRSuoDYKIuW7iGQKnFQXIhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsywyyffG4q1NIRnHQi8EB2aSrTnpwVjGXq8b/DCV8A=;
 b=PqUSQxgw3JGD0gz61m7iJFqgPWjCB6Zu8BTAB1VDSIZCAalCuZYe0QCxBGiVSACYUc4grcufN3h8PnjTCYHnv6dkuO8ledlmGuk95T4zU1QNwonAinE/AcdbrGHhikN+bVVGzbS5FOpQcM6W9w9iFI49CRUwK8ovJaSkgRF1wTzpYVlWWM+pouPB3p49P7pGscZaIeRdf7iHCQJ434NvERFgDJw+Od6N7e7SLy2XMXSqSU5EnGBHC1BE5/lKbZRsmWW4YCiNNm6hL0t3yVIkRtnZJcZLaOUhUg41rOdHW5ScbR+Wz6afFUyca/nzX5BSGDGHRKCRgKjXypCG31hh6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS6PR11MB362586.namprd11.prod.outlook.com (2603:10b6:8:4c4::14)
 by MW5PR11MB5907.namprd11.prod.outlook.com (2603:10b6:303:1a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 12:07:39 +0000
Received: from DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a]) by DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a%6]) with mapi id 15.21.0451.026; Wed, 30 Sep 2026
 12:07:39 +0000
Date: Wed, 30 Sep 2026 20:07:31 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, Linux Memory Management List
	<linux-mm@kvack.org>, Mark Brown <broonie@kernel.org>,
	<dri-devel@lists.freedesktop.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 6375e61c01e93e35ee7acd336a689ac1fae4b509
Message-ID: <arz7g8MbwpU5XImO@rli9-mobl>
References: <202609300341.XNENLUI0-lkp@intel.com>
 <20260929144213.94ba64f93121887c2a599d9f@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260929144213.94ba64f93121887c2a599d9f@linux-foundation.org>
X-ClientProxiedBy: TY6P301CA0013.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3be::11) To DS6PR11MB362586.namprd11.prod.outlook.com
 (2603:10b6:8:4c4::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS6PR11MB362586:EE_|MW5PR11MB5907:EE_
X-MS-Office365-Filtering-Correlation-Id: e5e07e81-5d94-433d-8c80-08df1eeb6c53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: N2BTtAa0nonWyD9BFSC1W0VeLyOgM9oj5wVRol3zSwpk9hr130GbiNdPspJfICbSCK4tKjhgQCzTc1XZo2u8Wjw41oFwPokaVIhmr3TQLYhk+cqQodAM6Cdfb5s2kmXgHwkihhllQWvzx+9b6yN7JXqksUoem58BqZrKsEziXAaC8EiWhC2udZeITGTdGvrQ4zHbXQx0MQWEscghbkvP/AqB53vUDDonIaw1+qrkmVGeqY4K6a8nwUyRjcUirgfz1tj4WwgRnL7lVy2X/4lwVyCudK95M1b4SoKOMZx9ZKFCBIyVmrUPSdKdBhZjRHwDmbaKq5Y9yIH1Kzc0mGOnr2cCC1dqtCailTZJ4T3Xn7t0Dins5QOfKbz2+F0oOS045GaKj3+AenAwz0DjUlRVc19Dkdh44bqItSEMKpVJjTvmxl6haYmkbhTamHChp1YstB1HHpYy3zkdGOic9R104Fs90hAxwt3dizdPC4XkI/nwiItUbH0IOUVtdOI2U51QAuc3CoGGUL3bS8svcfdKOy3ppEEmo35EiDi7madav9wnx6p15p39ToBeVNSL3eOu13LJmjGEtn+PseqC/Ri9GC3oYy3lxnH3NNw/hffKTEbRVtD2ASOn0V3AMn/0rua3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR11MB362586.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?82BmIBX9p4TcwFmHVxOTuEiWRhpxfGwu752Z60Zpr6DfbFk+9FNb0a1UOJbr?=
 =?us-ascii?Q?ZZnnAO8Sv+26o5+eho/XL4ZOmXrFDNcBSAgUb1oN8OREv15459Cc6uMVAYg5?=
 =?us-ascii?Q?scDa42n1DBUssbUba0xlfqhrBskLs1I2/9gg0mEBW9tg9T/eTJsBjaHxkNdi?=
 =?us-ascii?Q?xUrXQMPRfoDVpDA5vTkUHXz931nNTmCeyy79hbeVqW3PfIhogeJ5el209uq5?=
 =?us-ascii?Q?y1Xg6M6UuY+mDtUtqEoe0FmBvplGo+Bl0CoZhY7AbStKk3JDeTKW2oNix75H?=
 =?us-ascii?Q?93IiTQlORBBvB/F5K/eVmuJVeiMfLH6jnOCenIsDLt2+OQt9pyMIdv8cGCmJ?=
 =?us-ascii?Q?SEL8/fGnv47mvyrPoRVu5qoshyx7TJSdLdIjRqLDRKUr5BQxm+/H+aK49MON?=
 =?us-ascii?Q?EEL4FpoqXgtvViZm783j0Ql98PqOXabAzPSqXv1E9CMF10et17pCyJDYTaQw?=
 =?us-ascii?Q?+aYWbJO5Z1fuRQC/cAxWJoN8QlhV0LwiPF9Bwwj3OAkmS28eMfaxwHz4cvZV?=
 =?us-ascii?Q?ND/NLv6ATdTE4ZtADFX4UrSX54QBesilddFU+lQFuLu/zgIbZj4I4aYX4TI/?=
 =?us-ascii?Q?dsAco6KrcbJHzLkCpMZJxnO0M65oZT0kGVkQO23VRLZSxhF3mZN3R/MBH9uw?=
 =?us-ascii?Q?b1WtcqOShAPWUyyjBVAlC68agnsTqOm6D2eIZr3cSZ7w10608N5UrTENMOv3?=
 =?us-ascii?Q?6sEHE5AniL3s1TK+VjHj9gtB8tUKp1gk+5sKMDWjQw/wqykf3mAk5yu8KbnX?=
 =?us-ascii?Q?hAJ7NWxGYhMig2hpMd71u7QZzWOFeOlSC9S8s0ub9XslJb9iaNC5DiN8Cmzk?=
 =?us-ascii?Q?/oolEIiW3ly4dSfJm5C4CxQDh3v+j96PJicpdN8qN6ZNt79iToxAzlvlsSgh?=
 =?us-ascii?Q?y637C+dJGkfAlscxC4KdvEDjik5b5wDWPegkLhtAkRk8fOjk3flagsloGYiK?=
 =?us-ascii?Q?g0gCLXwb3y8Ut6BCTi9jeLL1AZ64hIiXoOR6BW5PEDeeAFviIaNm+U3fe7aW?=
 =?us-ascii?Q?5NI87Ax6jaBSx/7RKhJ9u5VxsfSVR3KCGleO2vnXiMJ81g1xmJ/zFsCollXD?=
 =?us-ascii?Q?Hg4ec4c08BE73Y2fOFawlxV7BO84cLYRGtjMgZ7Rho0H40eZIcAdzfTFs6gs?=
 =?us-ascii?Q?O7eNSRzgnuRc4BdKcZGOC3iBpgryW/oWAZLorZA7I/xHHsdijzntUgyFQxso?=
 =?us-ascii?Q?j8rz0c8fHc4+1Vn+2E4m+Sng+XVq4q3CmfNCXasU+BTAM0R4ql1FYZZabnUn?=
 =?us-ascii?Q?dkxNXoOlY8iJnMUYaVJthLg5CjjURPox2jRnhLVrhHRGFPawxPPPUogFMAFO?=
 =?us-ascii?Q?GOJd86XKBi4dlfxtQvNJxi/i6nT+xVAAJLuBY4hqyrKp+dQRwFqrJibaPYix?=
 =?us-ascii?Q?uyJKhkLlVF7B3JYD3oG/YnIvWFaOAAqDW2G4kp6mP+wenrd3ctYeAh3Kt4j9?=
 =?us-ascii?Q?jVG9L+NX6rJpmaYe8joD9BRAxUSuosPKnSPV4dTQXZPlxVhifgTHtIABBqZO?=
 =?us-ascii?Q?MY4KAa3henTKhmnf5Iaa41IGf5qr/Tz8+0IpBD6t9rfkB4K73B82jL11Lg2o?=
 =?us-ascii?Q?m9+AXJ2JjvBERWP1CWUwj+NcSsjLUngSlt5gSBXZrxY2WNtSDfK4kYpLHlC0?=
 =?us-ascii?Q?cCEH6IrRK+jxPgEXeIIFW9cZputKp/xacCv/BT/MLcJYCOwOJJE2s+Hasg1u?=
 =?us-ascii?Q?jxTOQsbrFxzFdTNe/RXm3SsIFn6OP0gQpG8t7vpIFZ85Bp94EKKIzcA+DIm1?=
 =?us-ascii?Q?GR+7qI7wSw=3D=3D?=
X-Exchange-RoutingPolicyChecked: OWOye91UEFk+hZlbVlrTBEUsGzeDwASoeNLZKDu0N2/hworSwJBc54Fgx65jCwxAdE9saPOFPk7EzdbJ8nfg4CcbYCXiziPjUhtX3SNInKBYBiFEmI2RiA0X/GEnfZervBB5GtgBEYuWGfzMaUBixJBGxirLT4V0IkN6lnra/rpZLIQRvV9pH3llzmKkEHV1IHUptHdJLxa/V3RLwwWc+80pGb53hVN/Yz+8cRfbPG7n5xQmfe7VdfiO3AQzo1KGsn5eCn54kiTBJFiDmfBLluDAKvxmoMIsAt9VRESwgrg3MAQqDq5vbfd+ztJWeXSJT0hG/mvxlZYug2yHgNt9Cw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e5e07e81-5d94-433d-8c80-08df1eeb6c53
X-MS-Exchange-CrossTenant-AuthSource: DS6PR11MB362586.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:07:39.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xw4cPT2sruMGRhsotUIZ/blVeI5EKG6+qqHDr18cHhTHXm0DfvEHFF7I7sSAFdI660EDG25DN/TKTE05hN+SYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5907
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: s5uyamy1yjz5as1k5y6cgmm1p9kmerzn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFCC440008
X-HE-Tag: 1790770063-464254
X-HE-Meta: U2FsdGVkX19l34hGLuk9pmzV8NFRIz6fB6TH5+1FnOFtSUn7S/CTPnVXKgBy/ZvtGMTnma++zmQrCBw2WWsEiqd5YggzxbaUgsXZNAiBN17VXHfSa3oOP/5OG0Vz1I1cjhfbjFgVdOxSHHUChD1SLlKJrFeu6KwV03tGIApW/Oif2QzqFh2SqZd5oc5lA4AOyEm51HDBXRJatuzar1ZGtjBj4dpZU5mi2usL7PiVEFPPVAFdxgE80wQw7mnLamJYmhJf+1IGtuQf1+AqVbccozTB0/JJzwORGLHz0NFMNREM8BZu1nZ/WU3N2od5rDfSb72o2PAx8V+Z4v+stdNZWHcgT3+dE4Ibws9RW6avlORPWG1OPJjZqeibcz6tloxadqFqazPyEj1fq6G/Mp7QFqLRGc7pgcCY/MXXDXr7dnZ3htZm+SFxu19Sonce6mgV2ov0RWMIzGIvboORA/sJ5DmFoG9PbCt+YkYBLe0/R8TynMcFfpb8rDrMnORxz1CE2PdT//7Ja0K6zzyIU3Hu6QSxsiQcv2kqw+mkM4+9iiNEfyrsyNnz1V/G3AliIqlR9S23k4k6+LpXQeZPOXBiSED9KwP9maw1ciBt6l+SqOkfMNXE/me1LtfqMntCDC1y5q2/2salhXJjyy9aWbPJiQjR6X3VYiC1qAkMZJzii5htUVg2zG6lFHhuewNhyCMrU/IzYBE1wK3wQkQa241L3O1erQ7efJIbUa23bwstjXS8H96vuiHQ1Er2QgQC/Yzap2OralE9Rm3+CmjEXTimQAmYIY6TnqjPiTj9+4TTvkEYgx4coyI9xqs9yEx7lTfobRhBomhzQnGTIzW4IlNJTCNRxUQe+6OK3NZlF9GZRjqVX6bBZfhbJr0whDeorBSAMkvxrsneI3VgOpdnoqmBUAJmkY19iK/uQwPeK3a3IS/GxVpHaxZ/ZYZ1e3yH7YkZhhwZ213Z+dtOyWVgdHM
 wsIrKg1u
 C4rBOVEAz+ezmPnX4e1qOth5bsYYEYBjP9Qx7c8bJ7/qo7p1aMvqEIJhv/RbvgHyEejEj+t8Z0aHE2Of6fq8JFjORTi6LQT1767FRzAKG+Rx8quMjB74DUaLaMIFKkZI5QwglrDjgAp09bUrHLYhVCz70koK3D2bU2j9eAT+k8MCCv+SEMcKb8ep/GYUaJ+nyxK/EWDzjo3nxfYiKppE+Ru3AURdyD7fFH9KfkNoTg2C31liycsLBHXRc1VIS5YoHiPhlOBm4bXPzzp+xLD2tEDLHDL769gPntotLmMzCxK1G4L5B9RnIOI9sY1An/oz/SciMslSawA1uBHMX4ZolHnyKmGJZ/eGMoweGX5k7qFgTUwXZ4epEf7McZgCCVT2pMJfl5VbGcNQ6VmpUrgBbBdYeqWYmpq3qbg6x//J7A4Fk5QSTyLpjfsvPzYljeA539BipnffQL73fFl4bO7/Xpd8htUPFt+2VhfAuKlugQE6iIE0xKptuw3KqeQg8/8mCk85CqhWws3/GtgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 02:42:13PM -0700, Andrew Morton wrote:
> On Wed, 30 Sep 2026 03:09:45 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > branch HEAD: 6375e61c01e93e35ee7acd336a689ac1fae4b509  Add linux-next specific files for 20260928
> > 
> > Error/Warning (recently discovered and may have been fixed):
> > 
> >     https://lore.kernel.org/oe-kbuild-all/202609290155.PQiaOalK-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild-all/202609290349.4ad3d90o-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild-all/202609290408.BOs7sk55-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild-all/202609291109.9RGna4XZ-lkp@intel.com
> >     https://lore.kernel.org/oe-kbuild-all/202609291109.OIsGTysr-lkp@intel.com
> > 
> >     Documentation/filesystems/api-summary:20: ./fs/dcache.c:2010: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
> >     arch/arm64/boot/dts/qcom/sdm670-google-bonito-tianma.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
> >     arch/arm64/boot/dts/qcom/sdm670-google-sargo.dtb: clock-controller@100000 (qcom,gcc-sdm670): 'power-domains' is a required property
> >     drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:11: error: call to undeclared function 'devm_drm_of_get_bridge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >     drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:16: error: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
> >     drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:18: error: implicit declaration of function 'devm_drm_of_get_bridge'; did you mean 'devm_drm_put_bridge'? [-Wimplicit-function-declaration]
> >     drivers/gpu/drm/bridge/synopsys/dw-mipi-dsi.c:336:9: error: incompatible integer to pointer conversion assigning to 'struct drm_bridge *' from 'int' [-Wint-conversion]
> >     drivers/gpu/drm/verisilicon/vs_bridge.c:306:14: error: assignment to 'struct drm_bridge *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
> >     drivers/gpu/drm/verisilicon/vs_bridge.c:306:16: error: implicit declaration of function 'devm_drm_of_get_bridge'; did you mean 'devm_drm_put_bridge'? [-Wimplicit-function-declaration]
> >     drivers/gpu/drm/verisilicon/vs_bridge.c:306:7: error: incompatible integer to pointer conversion assigning to 'struct drm_bridge *' from 'int' [-Wint-conversion]
> >     drivers/gpu/drm/verisilicon/vs_bridge.c:306:9: error: call to undeclared function 'devm_drm_of_get_bridge'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> 
> (cc dri-devel for the above)
> 
> > Unverified Error/Warning (likely false positive, kindly check if interested):
> > 
> >     drivers/gpu/drm/xe/xe_guc_pc.c:1400:17: sparse: sparse: Trying to use reserved word 'break' as identifier
> >     drivers/gpu/drm/xe/xe_guc_pc.c:1400:17: sparse: sparse: Trying to use reserved word 'switch' as identifier
> 
> I can't find any code in there which could cause this.  Using the correct HEAD.

Sorry for confusion, the initial unverifed report is at [1], and it should be a false
positive from sparse. But this report fails to include the link of [1] and causes
confusion.

[1] https://lore.kernel.org/oe-kbuild/202609250044.R601n2jg-lkp@intel.com/

Thanks

