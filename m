Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72AB7CAC592
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FAA8E0005; Tue, 16 Sep 2025 22:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FA18E0001; Tue, 16 Sep 2025 22:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AE28E0005; Tue, 16 Sep 2025 22:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 520588E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:40:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0BF458D56
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:40:31 +0000 (UTC)
X-FDA: 83897188662.21.D31C9CD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CC701C000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:40:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CqRTf//7";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758076828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PIw+S+AJM/6zkhdHbJ0V01H4ety931xsqwjqWuka2cA=;
	b=Gj6TM658sYPyq82B+eafM0Mem4yFxCrByNFthbwCj6I5aWGBvLU8tXAL4589oxltsKlK92
	KJBtBYZ4yRioJvfqE/COWcmBCPiI0KDHA2ZmigSK6HKjjzR9SM6qmZEcPONr1fR8V7zuvq
	EG+YxtdUIni2D4Po1995jc4BoDrqhMo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CqRTf//7";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf18.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758076828; a=rsa-sha256;
	cv=fail;
	b=eOXimAxH6b0o7uQGO12uWa42hUzIVJpWEMTaHHQ3KLWx7UvVeGJ/Voy7xwiFG1/IuAfyVZ
	faClnPZEwJlI3yY6v3hlqTQY68zxPXbrH/j+2DvsPUvnSM+AG/wb3REzdssu4zUK2LEyPU
	UxPXR1fyi8Rw2eFQJu1zUsAqt9mj36o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758076827; x=1789612827;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=ny7To/9nAuDKd48gJ+RwpADxtmlT86f/cv9FlDhCWas=;
  b=CqRTf//7CmXtl0lEjd0RXHZf9iUmJnlA+eJf1Ba2NxOYAUlwJKEArkr8
   mFhy4XJB38MvteWt5D6BaXC80zNvmdgJjIyvrI/SS/GCJ3y7MbDJrUEM9
   OFoe1gIzVp2Bv2aDmIbAR7Tvw43YKtvJP6MlokEUetNVOm1JWwGAihi1c
   uvfA6+TOr90tYzEkeinE8NowOZEyoyl6Vc/a+7i9Y74mUTW0rN+SsST++
   46zg40fTNYzmr0Gwsry6eYUcp1SFmDAOv0VtUxcEuNOEPY3Y2+WNLfhXl
   A7Jf72/wVaSp8uxUqrN0p6fZ4cZZwl4pn3sxKaMq4q+Qd3HAmdykFujRf
   w==;
X-CSE-ConnectionGUID: P5Vy5pjjSOakdc/dyOlmcQ==
X-CSE-MsgGUID: 9byqq1hVTJqn7aR6vJV2yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71476333"
X-IronPort-AV: E=Sophos;i="6.18,270,1751266800"; 
   d="scan'208";a="71476333"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 19:40:25 -0700
X-CSE-ConnectionGUID: UkYvsmcLT1u0BEj6AwgIYg==
X-CSE-MsgGUID: pg4xLG8SQB2Vpcg/dGJE9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,270,1751266800"; 
   d="scan'208";a="175888049"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 19:40:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 19:40:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 19:40:23 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 19:40:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGT9tU7sonvQTcCJXtAHwUwrczueLJn9vobRHsIVq2cX4zNG4qVlwexn62qqtO4DMQFiWy89jR61cDiqNHK26gWbe0uAaHEhGieSQevJT8cKaNAjKojZf7KKjB1cUedTwrUTTyR4SW30bK5XGbwfczNjb9CdukHH5B3crAbeLgUX8YJTrt8DRbEOwYj+n0Oc8+KDEx2TiXJxu1L+4x4j9YbWSFes2qAbg8CE6SRxc+6O/Oa+gjjBcsw0j8kQA5m6RdoPpeVx7WKEv2mGQrin9hi3l4mP1PNfXLeg6PPhkFnQgOErI6psvFDn7eN6BYXC9lNE3MTZ/Q2yazUQuTz0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfrkhh1YhZubGcKn2Yp+vHsKdJKUVxYRbs3eLwPYfGE=;
 b=xU72svGv1/DYpyD7rk4k/W89CZjO/bvfwJOHlHqRo3I9Q1Q1slDkZ9v3lX8Vlsb4FieDd0wlNFblqObbioOimJif++fwdkYNM1gbWWmMgVsTyxrbbUT3E1DhmJahD8yc3pMIMOatUvAkthWdSI+4iEObcJnvS9Kz1IIPeuA1xf7Sm4L6/+C2CHZ9yafFyHji3UOCTYw0S7BoEdL8EkQCOrppF3jieLZ6jfB27DmjqRvNK/nntOrisdCjIWD5+sK1a/4mQAUN9mV6uY3a7E4BenpKpA1Sc1fl3LZu+VfiqoOrtRmAKHsjxh1jhteX3g49cZisUVnob+kzPeTPxjP0xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB8383.namprd11.prod.outlook.com (2603:10b6:610:171::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Wed, 17 Sep
 2025 02:40:15 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 02:40:15 +0000
Date: Wed, 17 Sep 2025 10:40:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Suren Baghdasaryan
	<surenb@google.com>, <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:slub-percpu-sheaves-v6r3] [maple_tree]  71a82407f1:
 will-it-scale.per_process_ops 18.7% regression
Message-ID: <202509170457.d1421a5-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB8383:EE_
X-MS-Office365-Filtering-Correlation-Id: bee1e715-60c3-4370-9635-08ddf5938732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?/XnXBZZVsE40iStLijyTlRyn+V/MjpTqXzJGpH1/DqzZYqwe0Jh1GFtImU?=
 =?iso-8859-1?Q?RpLGrk2+u3TMDi8nA7xci/Xdx6mTiMurdJo63ZyLpL3vTLvLNtuCm39Xdg?=
 =?iso-8859-1?Q?EXbBOV2TWC38Y3qW3PEoddDDX2KlAxoCOWB3f8y1tRW4QpDVrCBUURNHtL?=
 =?iso-8859-1?Q?V18EDMGGY/owrnqQt1NVVO6em5WFDqCkrj/DtpsByP8B/CTZQ1cv37z7kD?=
 =?iso-8859-1?Q?rAa2qk+nKxRLfqPufhFWnsAgEkMefrFn0gMe2WNQQBIkFBQhun13B1NbMm?=
 =?iso-8859-1?Q?ZZ/YlZABJ4PE4DrMJluT6qr1iSWD6crkSTg0Vt0LFDCx1bLR+43zXH+cjV?=
 =?iso-8859-1?Q?JIql/dGvC7LycSVRdBsKBjUsz/oG4WKVNHtbmhxlcaTIyCwxsu1eH7InQK?=
 =?iso-8859-1?Q?YzMCShZ8YBR18XEGXpE/2aGvwTMZ0QTC3+c5wgpsZrUDLY8q6aQX3+ET55?=
 =?iso-8859-1?Q?hFYQxKs4geY7TecZV/VXViQWXFxoUB394utrCfgZv32Kj4vPX6sX7Onp2S?=
 =?iso-8859-1?Q?0hewLnqu3GaNeP6GPgnKIGSP0YEzREvoH7S4e2dwG04zeMNFd3vHapZMGS?=
 =?iso-8859-1?Q?+h+M0iS6L2KumSNrgkjJaHowloU2y3dmrLAHmwweJxsSkAoZ9TZI1uID2y?=
 =?iso-8859-1?Q?yxzqLBRmmcYEyUnmsLRwCxBKMvCiiybXsKhDfjpvOvRp/+Llgb0Cv3XDx1?=
 =?iso-8859-1?Q?JF8GJFDnPxnrOOpTEdl9csprYKQfvdCUA8oUdSyjc/9ihRXnRTMXyoQWmM?=
 =?iso-8859-1?Q?+aOUF8rj3VT7KPTOxofBoFyrdf2HCZdSXjzvcJHYjzNlrAfC7rN7h6kFJL?=
 =?iso-8859-1?Q?C4nVez3+G+nqZPGmVfsgDL4l8JZZvnkHgv+bv2SrR7mI4uRBHt8cg7edA7?=
 =?iso-8859-1?Q?wTJQgk3Aa/F7rHMUOndBdD6ug+8QEZf03wD/Vh0r/kmZuUVCVu78fnoBoZ?=
 =?iso-8859-1?Q?gegezz5cn/e8nYy3RnT20zy4OXKbPBijBAAJuIb88VWJRcaOyKCUzPs3Rp?=
 =?iso-8859-1?Q?WCD7atnaxtmVqX2qiGJJqeqsafpGWTN3tmbofZNS8AzqFWAwe4rcgc8BOz?=
 =?iso-8859-1?Q?r14sSCx5Qf4oL9ONByo0XuJlQk8csCqoWd7mu+G862ppUPb1csWnB174HI?=
 =?iso-8859-1?Q?8ijUYLIu3G0eP/NGAQ77q3Ny8swZSYKKBmtrimkfW0WBX+rRHpu+14HV7a?=
 =?iso-8859-1?Q?gw9wlEo9f1rpmX68NG2vq+6WVr/Kn2J304dhiIpyOGPOGqBR9naj3Hm/xQ?=
 =?iso-8859-1?Q?a6z0IG6RWy7dpD99HMAagOwrnUfss5Flru6ZrN+cbT49lPyV1OTjmG3K2Q?=
 =?iso-8859-1?Q?r72tBl3j51uXfnRmDTEUgqL7J+uH6AaSsznqWec04SyKLloG/ypHhSmRDq?=
 =?iso-8859-1?Q?UNcJbaqad+Nhth9xM/u4EgLyahfcR/vp0IbGzhz72sSHVOFPJE/sJeV8qR?=
 =?iso-8859-1?Q?8aXhosrlcBsXCPlv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Ci8fD1y3P4QxQf3a7nCB/nzs6X8q9qOcYFnN1Bc3GsEzodPLDvBwZ0NcvH?=
 =?iso-8859-1?Q?EAPdfxgHobeB97CBPZQme03+QNuL7KWjyPYA5Bnyd8XIhc7DOFvr3m9p23?=
 =?iso-8859-1?Q?ZubhH2pyHwZ3jnO9QkCI9vnRsiPEbJ7yXYWtM963xFw6wZMJwQqEp0PlQC?=
 =?iso-8859-1?Q?9fRV7ZGWmcO2SOcy1XvxaL+mlzgpO4Q3YqE2ML74+/0sCCKjDWkM1WknUq?=
 =?iso-8859-1?Q?PH5RFl5T55BrN1ESIbWKdKldNBtf3eEOv3pjzr0J6Wntzo4QiRLjeaH3Gt?=
 =?iso-8859-1?Q?A5wqHh1jmY8RwDiaN7DEcEbdlBuxn+4PclpPG3JQW2QbiJnMXUBnOup2ju?=
 =?iso-8859-1?Q?xDWm+hA14+PUdZIq6L7pS9Ppfy4OOfdITG42miho4e29oYFgz7eY5EmfXB?=
 =?iso-8859-1?Q?az30W/vsCRFjo98IEoGKU2E5YRcVfWbZVW+vF9dAws6naH/4Ns1+KSyhRR?=
 =?iso-8859-1?Q?sFyHtXOr+AaXVHAXYHXXWm1TEHn2Qqa4pcGHAw+ACW9zSchiA7N8YNuFwF?=
 =?iso-8859-1?Q?P93UcCuqnXyvWD2o0vLQ4ZBTtZZ6O4fWVq5G4+rzbaG+iUjfIG9esGSFtc?=
 =?iso-8859-1?Q?CAbv+d+PpYqBl8gELGByORwOx5aDE7nyahPG7D4Z55UUqzm/omsYqIK77Z?=
 =?iso-8859-1?Q?q3+dLkk2LyN0qupm6304jgXXPc6rzvoZFERdlDOOVCOTzC/JnRmEnnl1cZ?=
 =?iso-8859-1?Q?8Idou8ZJ9R/q+qZDADiRosUgxuS82sbA01pPQbcxu7xkxP44hXOt7FyWd5?=
 =?iso-8859-1?Q?RjkRs6n6xl+WyB+3nFWD2q13Gi5CCxZSXk5fmYVMszzMgIt/ZTKIhXZ/7o?=
 =?iso-8859-1?Q?2qeX++1wSP5ZvLShUbwqRTpcnHkVHvMFwxPb8G3/fR8XhuhPxohXBgmLKp?=
 =?iso-8859-1?Q?5FwmNwW9rQdJLqz6ql3xQVejKj8G/uU2QZllPI1wSoYFR5PZbaaStpVzJm?=
 =?iso-8859-1?Q?zfahXO3SvXXG+YoUqX/vIb2E1+LxZWVG1xvBL+RJRSwJQx5iwoIdmBYJbD?=
 =?iso-8859-1?Q?tukxRNus8F3RClqyFZTh4IByUPZdGPQ2qDMhpvVYNvUqP16bRXK2ORm5jO?=
 =?iso-8859-1?Q?paMwDsgcgu17YCSg4mTZkbXAm8+FCxS9ppb5xHvh4O/Fwx2kp4lzIjZsET?=
 =?iso-8859-1?Q?Z1qNzE+YQ/a/Ofbb6FW45Pajxu+SnKe7pmgkg5Tdh6J1pMKV9WlqbHTxr8?=
 =?iso-8859-1?Q?Fxo4TWcPxfI1vtIs6/7kjmf2hsMb5Ma6XYGnCSY3xkjf4nym558a3rLZp/?=
 =?iso-8859-1?Q?k/Od3bXu+tH+bNaA3gtbIjOfqOOXrzFVRjnO0c2Zi2s+XjGCr+c3tkBNGm?=
 =?iso-8859-1?Q?noR3VgDeAkP4900EEP1h7nsvT3ECaOnuCwV8bOyaoXSnCuzqjND6oMFaDd?=
 =?iso-8859-1?Q?XRD+snY3Fv+2uP+6hq9GCqkInfaBM5jELetroGEZyHBMshD5+AVjr9Et/J?=
 =?iso-8859-1?Q?wh20KSKZdAl8k2vGeTkqJWMcOuN8lWvuI9YYF3hznDYbBVe8EAxA9El4+m?=
 =?iso-8859-1?Q?2vyRVDN8iDHBSj/CwctN70stFmYnlqamMkEME/F76WvBFwCzH/+4DeiW6e?=
 =?iso-8859-1?Q?MRNEwPpznkJgPjvFTtAYCW+ZN96UOkrnaglnVRffIV2l7ImPuX1Ib6c0am?=
 =?iso-8859-1?Q?Nt2rnIEjevmfktaZyIO8E7BDWt2GozeLlfLPl8pVN6ByaU1HMuQyaHfw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bee1e715-60c3-4370-9635-08ddf5938732
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 02:40:15.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Iy3eCzEHTTkJcP5WXgYwVzHblDIoRgMKfOU7+i1Aqos9L/aoh4yL5kJRlQrTM+SI67ERYV6GXVKWKVAouskMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8383
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1CC701C000D
X-Rspamd-Server: rspam05
X-Stat-Signature: ujn1o59cpxp4qocghc3y3n6c9r7hiqzw
X-Rspam-User: 
X-HE-Tag: 1758076826-424391
X-HE-Meta: U2FsdGVkX1/aECp4ZmDjwf+yuuQHhMmx8cf5uNfHbSjz4AGUcbtrneNIj3bfNkKzBGEBvZQAZZpB3b4zFrJisecfkRW3UR9bSGf+P6RyX8fUM2nB+G6/79fBbciMqwvMcCIc2jqsERXk9vjQD6C5tXYyWEOxjZBZHq8tPQB9pWrUIpLRG5LcvHWYBcLmO1k7wkSFfk36MmvY4oU41RX4E8uQOsiqEcdmoMdDVQ4agV1/K7LQLG2xKBwi6gJ3fuw7clZadNPs6IZOUqNFeGjFGaJsLtZ1rnJefzFvxcI37SqJ/49kRlckUiLl6AMh9b3NqLTwWug/bmFb/7iSNDDusnxynvksOfIEa9A7sjJ5u98gum/8I1f1wjmbkwNAz/GKLmOsnfwumF5QswfzONGpxY7ChRR+qCCedHKO+gd0dSTRj5P8yHb14JgOQpcx/IF33nG6/vdrHvYEhhJDmNGkMUDhNF57w93rKTCeqt+oVy5zvDYNx6g6w1c3tw+C04/+gDt4E2etNK5AeW/CM+PpK2SXG3ZOOPtTiy1bfr8Vdjv9jQIfmt7NhcE102WD1aStDJGUgS8nGEmVxk1TyO2C5odjPucIMrBeJ36g0bY4sAXEJrOx5+hltEcHj9EQh7muQQB+HCeAn30w3LF6YA4pyvOdjRppSktyglttbLfXNoA6hsWjxB7KymSki2kSyjWIZNYdirw6N/5O10ByoJrVcc1LpX3eWHpogvRA3qZ7mLtKpgJqUuC63x1SyKYUUYX1Qb4JMxw+tiKoDOd+le8KVfpQkJ5YKacUgXHMTM9tTGQx8usowerwMLs1nL1TI3IiqP3QuGnQAAXpfcqgNhFpVEbfflCCtIQdV0H+zyb5PDyUAhVcDfyJjpmFttKYVyOI7ch+mBGK41OxSBNhUjUFVm3oXI9sK0Auxq8Z/gCEDKMn/PXJmPdvAuqMUolovsZbe1AnIuMFD43krfeeS7v
 IBLfKDZq
 6WX7g9verbNGyelIhIeC9BGGJ4Fva2+1k0VBEpC0GS068GRmuCT+qbN5Xe7p6muXzLYOroj7kDlKjA5QnYvuPk5uNEzM7gee73J+QLHqvIYwJiBkrkJpsAnETqXKEwPus6SRtzUXdKUZSxdB+95QEN9VwZyq6oJGI2LGoTmVnS8f3TDAaICBUEPlHyftD6sbC0Zq1+jqTC3bFZMsN1VMMPcnBRqPgIXhPdLt5Mm8cJ/IcLrH9bxvAqu/dP7Gde1k1Dh4vK8bZaXQ2pfr6OOMQD7SCEFUQ2fjXDn+Uhcvw0sdoqgmIe/uP+s7VQeQuKqbeWezcj4kUzvUOfkrpFkZ8rCB6K8iBteBjLKe+bA0sBgMVEcMrE4VLt1+srzrdLS261otnsDiQEh2Wg70DUDEDE/wesEVpHxeuciDmLmJDncp3wsJ/ysOec8C5aufP1aQD/3rWVWOebHV283pTmXZ9O5ArJ1z6/kHLL0IScUpNxA83k+LwmRpATdVQLQRCNe28kUix8XwSeeDmrJl6AQLz4Q1NmgXJNvX9wJ8vKIIO+zr+3Wgnw/DGEoZNqahSnzZEW/s1NwLRMyK8V+ZkLxDIAOfaj+RIIu+AiszwKHlgd3DHmwwnw6PE4v38LcHsEPamAovqrJTcvEqQQj2pLAffFTI3M3kRUOqSvNx9Txjpt+sS9hcryIfB9hFuv1Mu/IYa4gookabXrOZ3ayJYzVqM702y+xXiBS5ytA/Ua7HvIo61XVrvEQTtWuxwap5iDwmeBt2iUyvyIOrQ0H0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 18.7% regression of will-it-scale.per_process_ops on:


commit: 71a82407f1c94903b3835b4c9351a0d4c2d5a58c ("maple_tree: use percpu sheaves for maple_node_cache")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git slub-percpu-sheaves-v6r3

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap2
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+--------------------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops  21.9% regression                                         |
| test machine     | 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory |
| test parameters  | cpufreq_governor=performance                                                                           |
|                  | mode=process                                                                                           |
|                  | nr_task=100%                                                                                           |
|                  | test=mmap1                                                                                             |
+------------------+--------------------------------------------------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_process_ops  28.9% regression                                         |
| test machine     | 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory |
| test parameters  | cpufreq_governor=performance                                                                           |
|                  | mode=process                                                                                           |
|                  | nr_task=100%                                                                                           |
|                  | test=brk2                                                                                              |
+------------------+--------------------------------------------------------------------------------------------------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509170457.d1421a5-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250917/202509170457.d1421a5-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/process/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp2/mmap2/will-it-scale

commit: 
  7c1ca28747 ("tools/testing: Add testing support for slab caches with sheaves")
  71a82407f1 ("maple_tree: use percpu sheaves for maple_node_cache")

7c1ca28747078885 71a82407f1c94903b3835b4c935 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     11432           -17.7%       9408        vmstat.system.cs
  39366220           -18.7%   32021343        will-it-scale.192.processes
    205031           -18.7%     166777        will-it-scale.per_process_ops
  39366220           -18.7%   32021343        will-it-scale.workload
      0.70 ±  3%      -0.2        0.52 ±  2%  mpstat.cpu.all.irq%
     28.01            -9.4       18.61 ±  2%  mpstat.cpu.all.soft%
     68.05           +10.0       78.09        mpstat.cpu.all.sys%
      2.75            -0.5        2.29        mpstat.cpu.all.usr%
 1.431e+08           -40.9%   84522354 ±  2%  numa-numastat.node0.local_node
 1.432e+08           -40.9%   84641286 ±  2%  numa-numastat.node0.numa_hit
 1.428e+08           -40.2%   85421617 ±  2%  numa-numastat.node1.local_node
 1.429e+08           -40.2%   85491246 ±  2%  numa-numastat.node1.numa_hit
   3426536 ±  7%     +19.5%    4096012 ±  4%  meminfo.Active
   3426536 ±  7%     +19.5%    4096012 ±  4%  meminfo.Active(anon)
   6147555 ±  4%     +10.5%    6796087 ±  2%  meminfo.Cached
   1003875 ±  2%     +10.2%    1106188        meminfo.SUnreclaim
   2608589 ±  9%     +24.9%    3257121 ±  5%  meminfo.Shmem
     17.88 ± 34%    +478.3%     103.38 ± 17%  perf-c2c.DRAM.local
      5772 ± 12%    +130.2%      13287 ± 12%  perf-c2c.DRAM.remote
      2298 ± 15%    +353.2%      10416 ±  7%  perf-c2c.HITM.local
     83.50 ± 20%    +191.5%     243.38 ± 10%  perf-c2c.HITM.remote
      2381 ± 15%    +347.6%      10660 ±  7%  perf-c2c.HITM.total
   2792669 ±  7%     +29.4%    3615082 ±  7%  numa-meminfo.node1.Active
   2792669 ±  7%     +29.4%    3615082 ±  7%  numa-meminfo.node1.Active(anon)
    681909 ± 36%     +84.3%    1256571 ± 16%  numa-meminfo.node1.Mapped
    500148 ±  3%     +10.1%     550550        numa-meminfo.node1.SUnreclaim
   2473979 ±  9%     +25.8%    3113467 ±  4%  numa-meminfo.node1.Shmem
    596345 ±  6%      +9.6%     653761 ±  3%  numa-meminfo.node1.Slab
 1.433e+08           -40.9%   84639245 ±  2%  numa-vmstat.node0.numa_hit
 1.432e+08           -41.0%   84520313 ±  2%  numa-vmstat.node0.numa_local
    698292 ±  7%     +29.5%     904000 ±  7%  numa-vmstat.node1.nr_active_anon
    169921 ± 36%     +84.8%     313947 ± 16%  numa-vmstat.node1.nr_mapped
    618687 ±  9%     +25.9%     778630 ±  4%  numa-vmstat.node1.nr_shmem
    698291 ±  7%     +29.5%     904000 ±  7%  numa-vmstat.node1.nr_zone_active_anon
 1.429e+08           -40.2%   85488783 ±  2%  numa-vmstat.node1.numa_hit
 1.428e+08           -40.2%   85419154 ±  2%  numa-vmstat.node1.numa_local
    856589 ±  7%     +19.5%    1023830 ±  4%  proc-vmstat.nr_active_anon
   1536878 ±  4%     +10.5%    1698853 ±  2%  proc-vmstat.nr_file_pages
    652135 ±  9%     +24.8%     814111 ±  5%  proc-vmstat.nr_shmem
    255146 ±  3%      +8.4%     276482        proc-vmstat.nr_slab_unreclaimable
    856589 ±  7%     +19.5%    1023830 ±  4%  proc-vmstat.nr_zone_active_anon
 2.861e+08           -40.6%  1.701e+08 ±  2%  proc-vmstat.numa_hit
 2.859e+08           -40.6%  1.699e+08 ±  2%  proc-vmstat.numa_local
 1.138e+09           -40.8%  6.735e+08 ±  2%  proc-vmstat.pgalloc_normal
 1.137e+09           -40.9%  6.723e+08 ±  2%  proc-vmstat.pgfree
  1.27e+11           -15.8%  1.069e+11        perf-stat.i.branch-instructions
      0.09            +0.0        0.11        perf-stat.i.branch-miss-rate%
  99260313            +9.5%  1.087e+08        perf-stat.i.branch-misses
     67.33           -10.1       57.21        perf-stat.i.cache-miss-rate%
 5.165e+08           -14.9%  4.396e+08        perf-stat.i.cache-misses
     11452           -18.1%       9379        perf-stat.i.context-switches
      0.93           +19.5%       1.11        perf-stat.i.cpi
    497.86           -10.4%     446.33        perf-stat.i.cpu-migrations
      1066           +18.1%       1259        perf-stat.i.cycles-between-cache-misses
 5.916e+11           -15.9%  4.978e+11        perf-stat.i.instructions
      1.07           -16.2%       0.90        perf-stat.i.ipc
      0.08 ±  2%      +0.0        0.10        perf-stat.overall.branch-miss-rate%
     67.48           -10.2       57.26        perf-stat.overall.cache-miss-rate%
      0.93           +19.5%       1.11        perf-stat.overall.cpi
      1068           +18.0%       1260        perf-stat.overall.cycles-between-cache-misses
      1.07           -16.3%       0.90        perf-stat.overall.ipc
   4534964            +3.4%    4689735        perf-stat.overall.path-length
 1.265e+11           -15.8%  1.065e+11        perf-stat.ps.branch-instructions
  97925258            +9.9%  1.077e+08        perf-stat.ps.branch-misses
 5.149e+08           -14.8%  4.386e+08        perf-stat.ps.cache-misses
     11330           -17.6%       9332        perf-stat.ps.context-switches
    480.69            -9.3%     436.17        perf-stat.ps.cpu-migrations
 5.894e+11           -15.9%  4.959e+11        perf-stat.ps.instructions
 1.785e+14           -15.9%  1.502e+14        perf-stat.total.instructions
  21438331           +13.3%   24296162        sched_debug.cfs_rq:/.avg_vruntime.avg
  21903017           +12.4%   24610237        sched_debug.cfs_rq:/.avg_vruntime.max
  14885563 ±  3%     +27.3%   18943306 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.min
    578444 ±  7%     -14.7%     493667 ±  9%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.37 ±  6%     -22.1%       0.29 ±  7%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.37 ±  6%     -22.2%       0.28 ±  8%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   3275315 ± 10%     -49.9%    1642318 ± 31%  sched_debug.cfs_rq:/.left_deadline.avg
  21746330           +12.5%   24470456        sched_debug.cfs_rq:/.left_deadline.max
   7528183 ±  5%     -24.7%    5668652 ± 19%  sched_debug.cfs_rq:/.left_deadline.stddev
   3275271 ± 10%     -49.9%    1642299 ± 31%  sched_debug.cfs_rq:/.left_vruntime.avg
  21746042           +12.5%   24470158        sched_debug.cfs_rq:/.left_vruntime.max
   7528083 ±  5%     -24.7%    5668586 ± 19%  sched_debug.cfs_rq:/.left_vruntime.stddev
    136400 ± 13%     -52.3%      65063 ± 23%  sched_debug.cfs_rq:/.load.avg
    310764 ±  9%     -31.8%     212026 ± 14%  sched_debug.cfs_rq:/.load.stddev
    217.41 ±  6%     -43.5%     122.80 ± 10%  sched_debug.cfs_rq:/.load_avg.avg
     59.25 ± 17%     -49.3%      30.04 ± 33%  sched_debug.cfs_rq:/.load_avg.min
  21438356           +13.3%   24296174        sched_debug.cfs_rq:/.min_vruntime.avg
  21903027           +12.4%   24610242        sched_debug.cfs_rq:/.min_vruntime.max
  14885570 ±  3%     +27.3%   18943335 ±  2%  sched_debug.cfs_rq:/.min_vruntime.min
    578447 ±  7%     -14.7%     493665 ±  9%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.33 ±  7%     -28.0%       0.24 ± 13%  sched_debug.cfs_rq:/.nr_queued.stddev
   3275271 ± 10%     -49.9%    1642299 ± 31%  sched_debug.cfs_rq:/.right_vruntime.avg
  21746042           +12.5%   24470158        sched_debug.cfs_rq:/.right_vruntime.max
   7528083 ±  5%     -24.7%    5668586 ± 19%  sched_debug.cfs_rq:/.right_vruntime.stddev
      1094            -8.7%     998.91        sched_debug.cfs_rq:/.runnable_avg.avg
    170.03 ±  8%     -15.8%     143.13 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
     34.12 ±  7%     -16.9%      28.34 ± 10%  sched_debug.cpu.clock.stddev
    156.83 ± 38%    +104.5%     320.77 ± 31%  sched_debug.cpu.curr->pid.min
      1825 ±  6%     -27.7%       1320 ± 11%  sched_debug.cpu.curr->pid.stddev
      0.00 ± 34%     -37.1%       0.00 ± 12%  sched_debug.cpu.next_balance.stddev
      0.36 ±  6%     -21.0%       0.29 ±  9%  sched_debug.cpu.nr_running.stddev
     10049           -14.9%       8556        sched_debug.cpu.nr_switches.avg
      7617           -20.1%       6084        sched_debug.cpu.nr_switches.min
      7.21 ± 10%     -23.0%       5.55 ± 10%  perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      7.89 ±  5%     -22.6%       6.10 ±  7%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      7.40 ±  6%     -23.5%       5.66 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes
      7.53 ±  9%     -21.8%       5.89 ±  8%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      7.46 ±  6%     -22.4%       5.79 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      7.45 ±  6%     -24.1%       5.66 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      7.38 ±  6%     -22.9%       5.69 ±  8%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      7.51 ±  8%     -23.3%       5.76 ±  7%  perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      7.72 ±  7%     -27.0%       5.64 ±  5%  perf-sched.sch_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      7.51 ±  6%     -23.2%       5.77 ±  7%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      7.73 ± 10%     -24.5%       5.84 ± 18%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      5.60 ±  7%     -24.7%       4.22 ±  9%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      5.51 ±  9%     -29.7%       3.87 ±  9%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.22 ±  9%     -22.9%       0.17 ± 16%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.14 ± 10%     -20.4%       0.11 ±  9%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.82 ±  9%     -37.8%       0.51 ± 16%  perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     24.24 ± 38%     -43.4%      13.72 ± 49%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
     21.21 ± 34%     -34.5%      13.89 ± 17%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      3.56 ±  5%     -21.9%       2.79 ±  6%  perf-sched.total_sch_delay.average.ms
     51.64 ±  3%     +16.8%      60.30 ±  2%  perf-sched.total_wait_and_delay.average.ms
     57112 ±  3%     -16.6%      47640 ±  2%  perf-sched.total_wait_and_delay.count.ms
     48.07 ±  3%     +19.6%      57.51 ±  2%  perf-sched.total_wait_time.average.ms
     14.42 ± 10%     -23.0%      11.11 ± 10%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
     15.77 ±  5%     -22.6%      12.20 ±  7%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
     14.81 ±  6%     -90.2%       1.45 ±264%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes
     15.06 ±  9%     -21.8%      11.78 ±  8%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
     14.93 ±  6%     -22.4%      11.59 ± 12%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     14.90 ±  6%     -24.1%      11.31 ±  9%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     14.77 ±  6%     -22.9%      11.38 ±  8%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
     15.02 ±  8%     -23.3%      11.52 ±  7%  perf-sched.wait_and_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     40.79 ±  3%     +36.8%      55.78 ±  4%  perf-sched.wait_and_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     15.44 ±  7%     -27.0%      11.27 ±  5%  perf-sched.wait_and_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
     15.01 ±  6%     -23.2%      11.53 ±  7%  perf-sched.wait_and_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
     15.47 ± 10%     -24.5%      11.68 ± 18%  perf-sched.wait_and_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
     12.78 ±  6%     -13.0%      11.12 ±  9%  perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     11.01 ±  9%     -29.7%       7.74 ±  9%  perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
     74.48 ±  2%     +28.1%      95.43        perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    467.88 ± 10%     -40.1%     280.12 ±  5%  perf-sched.wait_and_delay.count.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      3471 ±  3%    +149.0%       8644 ±  3%  perf-sched.wait_and_delay.count.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
    373.88 ±  5%     -91.9%      30.25 ±264%  perf-sched.wait_and_delay.count.__cond_resched.down_write.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes
    459.38 ±  5%     -41.4%     269.25 ±  7%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
    663.88 ±  3%     -41.2%     390.50 ±  8%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
    917.62 ±  5%     -40.0%     550.25 ±  4%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      3824 ±  5%     -37.6%       2387 ±  3%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      1342 ±  5%     -43.6%     757.50 ±  2%  perf-sched.wait_and_delay.count.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1156 ±  7%     -32.6%     779.12 ±  9%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      5403 ±  4%     -46.2%       2906 ±  3%  perf-sched.wait_and_delay.count.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      3395 ±  4%     -44.0%       1900 ±  4%  perf-sched.wait_and_delay.count.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
    569.38 ±  8%     -37.8%     354.25 ± 14%  perf-sched.wait_and_delay.count.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      5495 ±  5%     -39.5%       3324 ±  8%  perf-sched.wait_and_delay.count.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     21359 ±  2%     -18.7%      17370        perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     75.30 ± 14%     -89.2%       8.11 ±264%  perf-sched.wait_and_delay.max.ms.__cond_resched.down_write.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes
      7.21 ± 10%     -23.0%       5.55 ± 10%  perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      7.89 ±  5%     -22.6%       6.10 ±  7%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      7.40 ±  6%     -23.5%       5.66 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes
      7.53 ±  9%     -21.8%       5.89 ±  8%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      7.46 ±  6%     -22.4%       5.79 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      7.45 ±  6%     -24.1%       5.66 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      7.38 ±  6%     -22.9%       5.69 ±  8%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      7.51 ±  8%     -23.3%       5.76 ±  7%  perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     40.71 ±  3%     +36.9%      55.71 ±  4%  perf-sched.wait_time.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      7.72 ±  7%     -27.0%       5.64 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      7.51 ±  6%     -23.2%       5.77 ±  7%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      7.73 ± 10%     -24.5%       5.84 ± 18%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      5.51 ±  9%     -29.7%       3.87 ±  9%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
     74.34 ±  2%     +28.2%      95.32        perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     40.52           -13.5       27.01        perf-profile.calltrace.cycles-pp.__munmap
     13.38           -13.4        0.00        perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     39.07           -13.2       25.91        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     38.95           -13.1       25.82        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     38.31           -12.9       25.37        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     38.25           -12.9       25.33        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     37.41           -12.7       24.72        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     36.40           -12.4       24.00        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     10.51           -10.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core
     19.56           -10.5        9.06 ±  6%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     10.39           -10.4        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch
     21.92            -9.0       12.93 ±  5%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     21.92            -9.0       12.93 ±  5%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     21.92            -9.0       12.93 ±  5%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     21.91            -9.0       12.92 ±  5%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     21.90            -9.0       12.91 ±  5%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     21.90            -9.0       12.91 ±  5%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     21.89            -9.0       12.91 ±  5%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     21.85            -9.0       12.88 ±  5%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     22.75            -7.2       15.60        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     19.39            -6.1       13.26        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      5.79            -5.8        0.00        perf-profile.calltrace.cycles-pp.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      5.55            -5.6        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core
      5.50 ±  2%      -5.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch
     12.39            -4.3        8.08        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
     13.65            -4.3        9.37        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     13.07            -4.1        8.99        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      8.62            -3.8        4.84        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      3.42            -2.7        0.68 ±  2%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      3.22 ±  2%      -2.7        0.54 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      5.53            -2.6        2.90        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      5.88            -1.7        4.16        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      5.49            -1.6        3.87        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      4.88            -1.5        3.34        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      4.96            -1.4        3.60        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      4.68            -1.3        3.39        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.14            -1.2        2.92        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      3.72            -1.1        2.58        perf-profile.calltrace.cycles-pp.rcu_all_qs.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas
      3.89            -1.1        2.76        perf-profile.calltrace.cycles-pp.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.16            -1.1        3.05        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      3.18            -1.0        2.16        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      3.14            -1.0        2.14        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      2.95            -0.9        2.00        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      3.42            -0.9        2.48        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
      3.35            -0.9        2.42        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
      2.68            -0.9        1.82        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      4.13            -0.8        3.31        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.23            -0.7        0.52        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      1.22            -0.7        0.52        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      1.97            -0.6        1.32        perf-profile.calltrace.cycles-pp.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      3.64            -0.6        3.09        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.80 ±  5%      -0.5        0.26 ±100%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      3.27            -0.5        2.74        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      1.68            -0.5        1.17        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.75            -0.4        1.31        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
      1.33            -0.4        0.88        perf-profile.calltrace.cycles-pp.prepend_path.d_path.perf_event_mmap_event.perf_event_mmap.__mmap_region
      1.39            -0.4        0.95        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.34            -0.4        0.94        perf-profile.calltrace.cycles-pp.mas_find.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      1.22 ±  3%      -0.4        0.82 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.72            -0.3        0.38 ± 57%  perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_prepare.__mmap_region.do_mmap
      0.93            -0.3        0.64        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_process.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.19            -0.3        0.90        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.86            -0.3        0.59        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      0.86            -0.3        0.60        perf-profile.calltrace.cycles-pp.shmem_mmap.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.81            -0.3        0.56        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.02            -0.2        0.78        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.76            -0.2        0.53        perf-profile.calltrace.cycles-pp.touch_atime.shmem_mmap.__mmap_new_vma.__mmap_region.do_mmap
      0.82            -0.2        0.59        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.75            -0.2        0.53        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.78            -0.2        0.56        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.72            -0.2        0.52        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.76            -0.2        0.58        perf-profile.calltrace.cycles-pp.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      0.68            -0.1        0.54        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      0.62 ±  4%      -0.1        0.56 ±  2%  perf-profile.calltrace.cycles-pp.mas_put_in_tree.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.98            +0.1        1.05 ±  2%  perf-profile.calltrace.cycles-pp.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.02            +0.1        1.11        perf-profile.calltrace.cycles-pp.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.56 ±  2%      +0.1        0.68 ±  2%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      0.46 ± 37%      +0.2        0.62 ±  2%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      0.00            +0.6        0.63 ±  7%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +0.6        0.63 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.6        0.64 ±  7%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.6        0.64 ±  7%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf
      0.00            +0.6        0.64 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.6        0.64 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main
      0.00            +0.7        0.66 ±  2%  perf-profile.calltrace.cycles-pp.shuffle_freelist.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.7        0.69 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.7        0.69 ±  7%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.7        0.69 ±  7%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.7        0.70 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +0.7        0.72 ± 10%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.8        0.75 ±  9%  perf-profile.calltrace.cycles-pp.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.8        0.81 ±  6%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.8        0.81 ±  6%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf
      0.00            +0.8        0.82 ±  6%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.8        0.82 ±  7%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.9        0.86 ±  6%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.9        0.94 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.0        0.99 ± 52%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +1.1        1.14 ±  7%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free
      0.00            +1.2        1.17 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +1.2        1.20 ±  7%  perf-profile.calltrace.cycles-pp.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      2.19 ±  8%      +1.6        3.75 ±  3%  perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.00            +2.0        2.03 ± 10%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +2.1        2.06 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +2.1        2.08 ±  5%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      0.00            +2.1        2.09 ±  4%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +2.1        2.14 ±  9%  perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +2.7        2.66 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +2.7        2.68 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +2.8        2.84 ±  3%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +3.7        3.70 ±  6%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +3.7        3.71 ± 11%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +3.8        3.83 ±  3%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +3.8        3.84 ± 11%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +4.9        4.85 ±  9%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +7.3        7.34 ±  9%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      0.00            +8.6        8.60 ±  6%  perf-profile.calltrace.cycles-pp.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      0.00           +12.1       12.10        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +12.2       12.24        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +12.4       12.38        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00           +12.5       12.53        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +12.6       12.57        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +13.5       13.53        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     36.77           +22.6       59.36        perf-profile.calltrace.cycles-pp.__mmap
     35.27           +22.9       58.22        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     35.15           +23.0       58.13        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     34.37           +23.2       57.54        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     33.51           +23.5       56.96        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     32.28           +23.8       56.07        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     26.14           +25.3       51.48        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
     13.59           +28.9       42.44        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      4.76           +30.9       35.66        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      3.54           +31.2       34.77        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      3.31           +31.3       34.59        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
      0.00           +34.2       34.16        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     41.12           -13.6       27.48        perf-profile.children.cycles-pp.__munmap
     27.76           -13.3       14.50 ±  3%  perf-profile.children.cycles-pp.kmem_cache_free
     38.33           -12.9       25.38        perf-profile.children.cycles-pp.__x64_sys_munmap
     38.30           -12.9       25.36        perf-profile.children.cycles-pp.__vm_munmap
     37.45           -12.7       24.75        perf-profile.children.cycles-pp.do_vmi_munmap
     36.45           -12.4       24.03        perf-profile.children.cycles-pp.do_vmi_align_munmap
     17.84           -10.8        7.05 ±  6%  perf-profile.children.cycles-pp.__slab_free
     29.63           -10.0       19.58 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
     29.61           -10.0       19.57 ±  2%  perf-profile.children.cycles-pp.rcu_core
     29.60           -10.0       19.56 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
     21.92            -9.0       12.93 ±  5%  perf-profile.children.cycles-pp.kthread
     21.92            -9.0       12.93 ±  5%  perf-profile.children.cycles-pp.ret_from_fork
     21.92            -9.0       12.93 ±  5%  perf-profile.children.cycles-pp.ret_from_fork_asm
     21.91            -9.0       12.92 ±  5%  perf-profile.children.cycles-pp.smpboot_thread_fn
     21.90            -9.0       12.91 ±  5%  perf-profile.children.cycles-pp.run_ksoftirqd
     22.94            -7.2       15.74        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     19.44            -6.1       13.30        perf-profile.children.cycles-pp.vms_clear_ptes
      8.10            -4.6        3.53 ±  6%  perf-profile.children.cycles-pp.__put_partials
     13.71            -4.3        9.40        perf-profile.children.cycles-pp.unmap_vmas
     13.11            -4.1        9.01        perf-profile.children.cycles-pp.unmap_page_range
      9.50            -4.0        5.46        perf-profile.children.cycles-pp.mas_store_gfp
     12.41            -3.9        8.52        perf-profile.children.cycles-pp.zap_pmd_range
      5.42 ±  2%      -2.6        2.84 ±  3%  perf-profile.children.cycles-pp.___slab_alloc
      7.14            -2.2        4.92        perf-profile.children.cycles-pp.__cond_resched
      5.91            -1.7        4.18        perf-profile.children.cycles-pp.perf_event_mmap
      5.56            -1.6        3.92        perf-profile.children.cycles-pp.perf_event_mmap_event
      4.98            -1.6        3.41        perf-profile.children.cycles-pp.free_pgtables
      5.00            -1.4        3.63        perf-profile.children.cycles-pp.__get_unmapped_area
      8.46            -1.3        7.15 ±  3%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      8.43            -1.3        7.12 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      4.71            -1.3        3.41        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      4.22            -1.3        2.95        perf-profile.children.cycles-pp.mas_find
      4.29            -1.3        3.02        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.80 ±  4%      -1.2        1.58 ±  7%  perf-profile.children.cycles-pp.get_partial_node
      3.78            -1.2        2.60        perf-profile.children.cycles-pp.rcu_all_qs
      3.99            -1.2        2.84        perf-profile.children.cycles-pp.__mmap_prepare
      7.14            -1.1        6.00        perf-profile.children.cycles-pp.mas_wr_node_store
      4.24            -1.1        3.10        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      7.73            -1.1        6.68 ±  3%  perf-profile.children.cycles-pp.__irq_exit_rcu
      3.20            -1.0        2.18        perf-profile.children.cycles-pp.free_pgd_range
      3.18            -1.0        2.17        perf-profile.children.cycles-pp.zap_pte_range
      3.46            -1.0        2.50        perf-profile.children.cycles-pp.vm_unmapped_area
      2.97            -1.0        2.02        perf-profile.children.cycles-pp.free_p4d_range
      3.41            -0.9        2.46        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.85            -0.9        0.95 ±  2%  perf-profile.children.cycles-pp.allocate_slab
      2.70            -0.9        1.83        perf-profile.children.cycles-pp.free_pud_range
      4.17            -0.8        3.34        perf-profile.children.cycles-pp.mas_store_prealloc
      1.67            -0.8        0.86 ±  2%  perf-profile.children.cycles-pp.shuffle_freelist
      2.02            -0.7        1.36        perf-profile.children.cycles-pp.d_path
      1.71            -0.5        1.18        perf-profile.children.cycles-pp.vm_area_alloc
      1.76            -0.5        1.25        perf-profile.children.cycles-pp.mas_walk
      1.84            -0.5        1.36        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.55            -0.5        1.07        perf-profile.children.cycles-pp.mas_next_slot
      1.36            -0.5        0.90        perf-profile.children.cycles-pp.prepend_path
      1.47            -0.4        1.03        perf-profile.children.cycles-pp.mas_prev_slot
      1.31            -0.4        0.91        perf-profile.children.cycles-pp.mas_wr_store_type
      1.13            -0.3        0.79        perf-profile.children.cycles-pp.__pi_memcpy
      1.44            -0.3        1.11        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.61            -0.3        0.30 ±  2%  perf-profile.children.cycles-pp.setup_object
      0.83 ±  5%      -0.3        0.52 ±  4%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.98            -0.3        0.67        perf-profile.children.cycles-pp.unlink_file_vma_batch_process
      1.23            -0.3        0.93        perf-profile.children.cycles-pp.mas_rev_awalk
      0.89            -0.3        0.61        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.88            -0.3        0.62        perf-profile.children.cycles-pp.prepend_copy
      0.88            -0.3        0.62        perf-profile.children.cycles-pp.shmem_mmap
      1.08            -0.3        0.82        perf-profile.children.cycles-pp.perf_iterate_sb
      1.04            -0.3        0.79        perf-profile.children.cycles-pp.mas_update_gap
      0.70 ±  3%      -0.3        0.45 ±  3%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.71 ±  3%      -0.2        0.46 ±  3%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.88            -0.2        0.63        perf-profile.children.cycles-pp.__vma_start_write
      0.78            -0.2        0.55        perf-profile.children.cycles-pp.touch_atime
      0.59 ±  3%      -0.2        0.36 ±  5%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.58 ±  3%      -0.2        0.35 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.74            -0.2        0.52        perf-profile.children.cycles-pp.copy_from_kernel_nofault
      0.74            -0.2        0.51        perf-profile.children.cycles-pp.down_write_killable
      0.55 ±  3%      -0.2        0.33 ±  5%  perf-profile.children.cycles-pp.update_process_times
      0.73            -0.2        0.51        perf-profile.children.cycles-pp.atime_needs_update
      0.67 ±  2%      -0.2        0.46 ±  3%  perf-profile.children.cycles-pp.kfree
      0.85 ±  2%      -0.2        0.64        perf-profile.children.cycles-pp.mas_pop_node
      0.68            -0.2        0.47        perf-profile.children.cycles-pp.up_write
      0.79            -0.2        0.60        perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.60            -0.2        0.42        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.65            -0.2        0.47        perf-profile.children.cycles-pp.down_write
      0.65            -0.2        0.48        perf-profile.children.cycles-pp.mas_prev
      0.72            -0.2        0.56        perf-profile.children.cycles-pp.mas_leaf_max_gap
      0.79            -0.2        0.62        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.51 ±  2%      -0.2        0.36 ±  2%  perf-profile.children.cycles-pp.strlen
      0.44 ±  2%      -0.1        0.30        perf-profile.children.cycles-pp.fget
      0.65            -0.1        0.50        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.47            -0.1        0.32        perf-profile.children.cycles-pp.remove_vma
      0.46            -0.1        0.32        perf-profile.children.cycles-pp.fput
      0.36 ±  3%      -0.1        0.24 ±  7%  perf-profile.children.cycles-pp.sched_tick
      0.83 ±  3%      -0.1        0.71        perf-profile.children.cycles-pp.mas_put_in_tree
      0.43            -0.1        0.31        perf-profile.children.cycles-pp.up_read
      0.35 ±  2%      -0.1        0.24 ±  2%  perf-profile.children.cycles-pp.mas_wr_store_entry
      0.40            -0.1        0.29        perf-profile.children.cycles-pp.mas_prev_setup
      0.39 ±  3%      -0.1        0.28 ±  2%  perf-profile.children.cycles-pp.current_time
      0.36 ±  2%      -0.1        0.26 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.30            -0.1        0.20        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.37            -0.1        0.26        perf-profile.children.cycles-pp.mas_data_end
      0.33            -0.1        0.23        perf-profile.children.cycles-pp.vma_merge_new_range
      0.26            -0.1        0.17        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.35            -0.1        0.26 ±  2%  perf-profile.children.cycles-pp.vma_set_page_prot
      0.30            -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.refill_obj_stock
      0.32 ±  2%      -0.1        0.23 ±  2%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.32            -0.1        0.23        perf-profile.children.cycles-pp.static_key_count
      0.16 ±  2%      -0.1        0.07 ±  4%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.15 ±  2%      -0.1        0.07 ±  7%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.25            -0.1        0.17        perf-profile.children.cycles-pp.__vm_enough_memory
      0.14 ±  3%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.26            -0.1        0.19 ±  2%  perf-profile.children.cycles-pp._raw_spin_lock
      0.25            -0.1        0.17        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.29 ±  2%      -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.26            -0.1        0.18        perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
      0.20            -0.1        0.13        perf-profile.children.cycles-pp.unmap_single_vma
      0.23 ±  2%      -0.1        0.16        perf-profile.children.cycles-pp.vm_get_page_prot
      0.25            -0.1        0.18        perf-profile.children.cycles-pp.__account_obj_stock
      0.27            -0.1        0.20        perf-profile.children.cycles-pp.security_mmap_file
      0.21 ±  5%      -0.1        0.14 ±  4%  perf-profile.children.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.19 ±  2%      -0.1        0.12 ±  3%  perf-profile.children.cycles-pp.mas_prev_range
      0.23 ±  2%      -0.1        0.17        perf-profile.children.cycles-pp.mas_destroy
      0.20            -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.15 ±  4%      -0.1        0.09 ±  6%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.25            -0.1        0.19 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.41            -0.1        0.35        perf-profile.children.cycles-pp.testcase
      0.19            -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.12 ±  5%      -0.1        0.06 ±  7%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.18            -0.1        0.12 ±  4%  perf-profile.children.cycles-pp.prepend
      0.19 ±  2%      -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.vma_interval_tree_remove
      0.16 ±  2%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.___pte_offset_map
      0.18            -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.may_expand_vm
      0.22            -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.vma_mark_detached
      0.21 ±  2%      -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.x64_sys_call
      0.10 ±  4%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.18 ±  2%      -0.0        0.13        perf-profile.children.cycles-pp.vm_area_free
      0.14            -0.0        0.10 ±  5%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.13 ±  5%      -0.0        0.09 ±  9%  perf-profile.children.cycles-pp.task_tick_fair
      0.13            -0.0        0.09        perf-profile.children.cycles-pp.can_vma_merge_right
      0.14            -0.0        0.10        perf-profile.children.cycles-pp.ima_file_mmap
      0.12 ±  3%      -0.0        0.08 ±  8%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.13 ±  3%      -0.0        0.09        perf-profile.children.cycles-pp.uprobe_mmap
      0.28            -0.0        0.25        perf-profile.children.cycles-pp.downgrade_write
      0.12 ±  2%      -0.0        0.09 ±  3%  perf-profile.children.cycles-pp.get_align_mask
      0.08 ± 15%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.perf_mmap__push
      0.09 ±  7%      -0.0        0.06 ± 11%  perf-profile.children.cycles-pp.update_curr
      0.09 ± 16%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.10 ±  3%      -0.0        0.07        perf-profile.children.cycles-pp.get_mmap_base
      0.10 ±  9%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.ktime_get
      0.10            -0.0        0.07        perf-profile.children.cycles-pp.mas_node_count_gfp
      0.13 ±  3%      -0.0        0.10 ±  4%  perf-profile.children.cycles-pp.security_mmap_addr
      0.09            -0.0        0.06        perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.09            -0.0        0.06        perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.10 ± 10%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.clockevents_program_event
      0.09 ± 14%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.cmd_record
      0.10 ± 13%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.handle_internal_command
      0.10 ± 13%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.main
      0.13 ±  5%      -0.0        0.10 ±  6%  perf-profile.children.cycles-pp.memfd_check_seals_mmap
      0.10 ± 13%      -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.run_builtin
      0.09 ±  4%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.shmem_mapping
      0.09            -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.vm_stat_account
      0.08 ±  6%      -0.0        0.05        perf-profile.children.cycles-pp.mas_nomem
      0.09            -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.mas_next_setup
      0.07            -0.0        0.05        perf-profile.children.cycles-pp.vma_interval_tree_insert
      0.06 ±  5%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.__mt_destroy
      0.06 ±  5%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.ksm_vma_flags
      0.07            -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.06            -0.0        0.05        perf-profile.children.cycles-pp.mt_free_rcu
      2.05            +0.2        2.21        perf-profile.children.cycles-pp.__call_rcu_common
      1.12            +0.2        1.33 ±  2%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.48 ±  7%      +0.3        0.75 ±  9%  perf-profile.children.cycles-pp.get_any_partial
      0.00            +0.4        0.36 ±  4%  perf-profile.children.cycles-pp.build_detached_freelist
      0.00            +2.0        1.97 ±  7%  perf-profile.children.cycles-pp.barn_replace_full_sheaf
      2.94 ±  7%      +2.8        5.77        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +3.8        3.83 ±  3%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.00            +4.0        3.95 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.00            +9.2        9.23 ±  7%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     74.44            +9.8       84.21        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     74.22            +9.8       84.04        perf-profile.children.cycles-pp.do_syscall_64
      0.00           +11.3       11.30 ±  4%  perf-profile.children.cycles-pp.__pcs_replace_full_main
      0.00           +12.4       12.38        perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00           +13.6       13.56        perf-profile.children.cycles-pp.barn_get_empty_sheaf
     23.24           +15.5       38.70        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     23.51           +15.7       39.18        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     37.39           +22.4       59.83        perf-profile.children.cycles-pp.__mmap
     34.41           +23.2       57.58        perf-profile.children.cycles-pp.ksys_mmap_pgoff
     33.59           +23.4       57.02        perf-profile.children.cycles-pp.vm_mmap_pgoff
     32.35           +23.8       56.12        perf-profile.children.cycles-pp.do_mmap
     26.35           +25.3       51.63        perf-profile.children.cycles-pp.__mmap_region
      8.00           +28.2       36.15        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      7.00           +28.5       35.48        perf-profile.children.cycles-pp.mas_alloc_nodes
     13.70           +28.8       42.52        perf-profile.children.cycles-pp.__mmap_new_vma
      4.80           +30.9       35.69        perf-profile.children.cycles-pp.mas_preallocate
      0.00           +34.4       34.41        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      3.92 ±  4%      -1.9        2.06        perf-profile.self.cycles-pp.__slab_free
      3.62            -1.1        2.56        perf-profile.self.cycles-pp.__cond_resched
      3.36            -1.0        2.40        perf-profile.self.cycles-pp.zap_pmd_range
      2.43            -0.7        1.69        perf-profile.self.cycles-pp.free_pud_range
      2.26            -0.7        1.57        perf-profile.self.cycles-pp.zap_pte_range
      2.20            -0.7        1.52        perf-profile.self.cycles-pp.rcu_all_qs
      1.36            -0.6        0.74 ±  2%  perf-profile.self.cycles-pp.shuffle_freelist
      1.54            -0.4        1.11        perf-profile.self.cycles-pp.mas_walk
      1.30            -0.4        0.88        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      1.32            -0.4        0.94        perf-profile.self.cycles-pp.mas_next_slot
      1.28            -0.4        0.91        perf-profile.self.cycles-pp.mas_prev_slot
      1.24            -0.4        0.87        perf-profile.self.cycles-pp.mas_wr_node_store
      1.14            -0.3        0.81        perf-profile.self.cycles-pp.mas_wr_store_type
      0.60            -0.3        0.27        perf-profile.self.cycles-pp.___slab_alloc
      1.03            -0.3        0.72        perf-profile.self.cycles-pp.mas_find
      1.04            -0.3        0.73        perf-profile.self.cycles-pp.mas_store_gfp
      1.53            -0.3        1.24        perf-profile.self.cycles-pp.__mmap_region
      0.93            -0.3        0.67        perf-profile.self.cycles-pp.__pi_memcpy
      0.92            -0.2        0.68        perf-profile.self.cycles-pp.do_syscall_64
      1.34 ±  4%      -0.2        1.13        perf-profile.self.cycles-pp.__mmap_new_vma
      0.92            -0.2        0.72        perf-profile.self.cycles-pp.mas_rev_awalk
      0.59            -0.2        0.39 ±  2%  perf-profile.self.cycles-pp.prepend_path
      0.57            -0.2        0.38        perf-profile.self.cycles-pp.mas_store_prealloc
      0.47 ±  8%      -0.2        0.28 ±  8%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.74 ±  2%      -0.2        0.55        perf-profile.self.cycles-pp.mas_pop_node
      0.60 ±  3%      -0.2        0.41 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_event
      0.71            -0.2        0.53        perf-profile.self.cycles-pp.__vma_start_write
      0.75            -0.2        0.57        perf-profile.self.cycles-pp.__call_rcu_common
      0.55            -0.2        0.38        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.57 ±  2%      -0.2        0.40 ±  3%  perf-profile.self.cycles-pp.kfree
      0.52            -0.2        0.35        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.56            -0.2        0.40        perf-profile.self.cycles-pp.up_write
      0.54            -0.2        0.37        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      1.00            -0.2        0.84        perf-profile.self.cycles-pp.kmem_cache_free
      0.68            -0.2        0.52        perf-profile.self.cycles-pp.__mmap
      0.57            -0.2        0.41        perf-profile.self.cycles-pp.unmap_page_range
      0.65            -0.2        0.49        perf-profile.self.cycles-pp.__munmap
      0.55            -0.1        0.40        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.65            -0.1        0.51        perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.64            -0.1        0.50        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.46 ±  3%      -0.1        0.33 ±  2%  perf-profile.self.cycles-pp.strlen
      0.58 ±  2%      -0.1        0.45        perf-profile.self.cycles-pp.mas_preallocate
      0.39 ±  3%      -0.1        0.25 ±  5%  perf-profile.self.cycles-pp.shmem_get_unmapped_area
      0.44            -0.1        0.31        perf-profile.self.cycles-pp.copy_from_kernel_nofault
      0.44            -0.1        0.31        perf-profile.self.cycles-pp.down_write_killable
      0.65 ±  2%      -0.1        0.52 ±  2%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.60            -0.1        0.48        perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.38            -0.1        0.26        perf-profile.self.cycles-pp.fget
      0.44            -0.1        0.32        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.20 ±  2%      -0.1        0.09 ±  3%  perf-profile.self.cycles-pp.setup_object
      0.39            -0.1        0.28        perf-profile.self.cycles-pp.fput
      0.39            -0.1        0.28        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.39            -0.1        0.28        perf-profile.self.cycles-pp.down_write
      0.36            -0.1        0.26        perf-profile.self.cycles-pp.__mmap_prepare
      0.31            -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.d_path
      0.54            -0.1        0.44        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.37            -0.1        0.27        perf-profile.self.cycles-pp.up_read
      0.72 ±  4%      -0.1        0.62        perf-profile.self.cycles-pp.mas_put_in_tree
      0.33            -0.1        0.24        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.37            -0.1        0.28        perf-profile.self.cycles-pp.__vm_munmap
      0.38            -0.1        0.29        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.32            -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.mas_prev
      0.28            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.mas_wr_store_entry
      0.25            -0.1        0.17        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.24 ±  2%      -0.1        0.16        perf-profile.self.cycles-pp.atime_needs_update
      0.34            -0.1        0.26        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.30 ±  2%      -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.29            -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.mas_prev_setup
      0.25            -0.1        0.17        perf-profile.self.cycles-pp.free_pgtables
      0.23            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
      0.29 ±  2%      -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.30            -0.1        0.23 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap
      0.22            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.21            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.28 ±  2%      -0.1        0.21        perf-profile.self.cycles-pp.mas_data_end
      0.30            -0.1        0.23        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.23 ±  2%      -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.free_p4d_range
      0.28            -0.1        0.21        perf-profile.self.cycles-pp.mas_update_gap
      0.26            -0.1        0.19        perf-profile.self.cycles-pp.vm_area_alloc
      0.20 ±  2%      -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.unlink_file_vma_batch_process
      0.21 ±  2%      -0.1        0.15 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock
      0.21            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
      0.24            -0.1        0.18        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.19 ±  6%      -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.ktime_get_coarse_real_ts64_mg
      0.22            -0.1        0.16        perf-profile.self.cycles-pp.free_pgd_range
      0.20 ±  2%      -0.1        0.14        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.58            -0.1        0.53 ±  2%  perf-profile.self.cycles-pp.do_mmap
      0.19            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.18 ±  2%      -0.1        0.13        perf-profile.self.cycles-pp.vm_get_page_prot
      0.20            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.__account_obj_stock
      0.20            -0.1        0.15        perf-profile.self.cycles-pp.static_key_count
      0.13            -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.__put_partials
      0.16 ±  2%      -0.0        0.11 ±  2%  perf-profile.self.cycles-pp.refill_obj_stock
      0.16 ±  2%      -0.0        0.12 ±  4%  perf-profile.self.cycles-pp.do_vmi_munmap
      0.15 ±  2%      -0.0        0.11 ±  4%  perf-profile.self.cycles-pp.may_expand_vm
      0.16            -0.0        0.12 ±  2%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.17            -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.mas_destroy
      0.16            -0.0        0.12        perf-profile.self.cycles-pp.__get_unmapped_area
      0.14 ±  2%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.prepend
      0.13            -0.0        0.09        perf-profile.self.cycles-pp.unmap_single_vma
      0.17            -0.0        0.13        perf-profile.self.cycles-pp.x64_sys_call
      0.15 ±  2%      -0.0        0.11 ±  4%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.18            -0.0        0.14        perf-profile.self.cycles-pp.vma_mark_detached
      0.13 ±  2%      -0.0        0.09        perf-profile.self.cycles-pp.___pte_offset_map
      0.14            -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.11            -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.unlink_anon_vmas
      0.15 ±  2%      -0.0        0.11        perf-profile.self.cycles-pp.vma_set_page_prot
      0.11            -0.0        0.07 ±  5%  perf-profile.self.cycles-pp.mas_next_range
      0.11 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.__vm_enough_memory
      0.12 ±  4%      -0.0        0.08 ±  9%  perf-profile.self.cycles-pp.update_rq_clock_task
      0.14 ±  3%      -0.0        0.11        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.16 ±  3%      -0.0        0.13        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.13            -0.0        0.10 ±  5%  perf-profile.self.cycles-pp.prepend_copy
      0.16 ±  3%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.current_time
      0.11 ±  3%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.can_vma_merge_right
      0.10 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.remove_vma
      0.13 ±  2%      -0.0        0.10        perf-profile.self.cycles-pp.vma_interval_tree_remove
      0.08            -0.0        0.05        perf-profile.self.cycles-pp.get_mmap_base
      0.12            -0.0        0.09        perf-profile.self.cycles-pp.security_mmap_file
      0.06            -0.0        0.03 ± 77%  perf-profile.self.cycles-pp.mas_next_setup
      0.09 ± 10%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.ktime_get
      0.09 ±  5%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.mas_prev_range
      0.24 ±  2%      -0.0        0.21        perf-profile.self.cycles-pp.downgrade_write
      0.07 ±  4%      -0.0        0.05        perf-profile.self.cycles-pp.get_partial_node
      0.08            -0.0        0.06        perf-profile.self.cycles-pp.ima_file_mmap
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.mas_node_count_gfp
      0.08            -0.0        0.06        perf-profile.self.cycles-pp.shmem_mmap
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.09            -0.0        0.07        perf-profile.self.cycles-pp.uprobe_mmap
      0.08 ±  4%      -0.0        0.06        perf-profile.self.cycles-pp.security_mmap_addr
      0.07 ±  6%      -0.0        0.06 ±  8%  perf-profile.self.cycles-pp.get_align_mask
      0.07 ±  5%      -0.0        0.06 ±  7%  perf-profile.self.cycles-pp.memfd_check_seals_mmap
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.vm_area_free
      0.00            +0.1        0.05 ±  9%  perf-profile.self.cycles-pp.munmap@plt
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.barn_replace_full_sheaf
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.__pcs_replace_full_main
      0.00            +0.1        0.14 ±  2%  perf-profile.self.cycles-pp.barn_put_empty_sheaf
      0.27 ±  2%      +0.2        0.48        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.2        0.22 ±  3%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      1.08 ±  2%      +0.2        1.30 ±  2%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.3        0.27        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.00            +0.4        0.36 ±  3%  perf-profile.self.cycles-pp.build_detached_freelist
      0.00            +0.9        0.92 ±  3%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      2.91 ±  7%      +2.8        5.73        perf-profile.self.cycles-pp.rcu_cblist_dequeue
     23.24           +15.5       38.70        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath


***************************************************************************************************
igk-spr-2sp2: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/process/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp2/mmap1/will-it-scale

commit: 
  7c1ca28747 ("tools/testing: Add testing support for slab caches with sheaves")
  71a82407f1 ("maple_tree: use percpu sheaves for maple_node_cache")

7c1ca28747078885 71a82407f1c94903b3835b4c935 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     12753 ±  2%     -24.2%       9672        vmstat.system.cs
     42.77            +1.3%      43.34        boot-time.boot
      7514            +1.5%       7624        boot-time.idle
    504934 ±  3%     +12.8%     569558 ±  2%  numa-meminfo.node0.SUnreclaim
    579032 ±  5%     +13.3%     656147 ±  6%  numa-meminfo.node0.Slab
  43196901           -21.9%   33720164        will-it-scale.192.processes
    224983           -21.9%     175625        will-it-scale.per_process_ops
  43196901           -21.9%   33720164        will-it-scale.workload
      0.66 ±  2%      -0.2        0.45 ±  2%  mpstat.cpu.all.irq%
     30.27           -10.8       19.47 ±  2%  mpstat.cpu.all.soft%
     65.69           +11.6       77.25        mpstat.cpu.all.sys%
      2.91            -0.6        2.26        mpstat.cpu.all.usr%
  1.54e+08           -41.5%   90063139 ±  2%  numa-numastat.node0.local_node
 1.541e+08           -41.5%   90167487 ±  2%  numa-numastat.node0.numa_hit
 1.505e+08 ±  2%     -39.6%   90890723 ±  2%  numa-numastat.node1.local_node
 1.507e+08 ±  2%     -39.6%   90989037 ±  2%  numa-numastat.node1.numa_hit
 1.541e+08           -41.5%   90154776 ±  2%  numa-vmstat.node0.numa_hit
  1.54e+08           -41.5%   90050433 ±  2%  numa-vmstat.node0.numa_local
 1.507e+08 ±  2%     -39.6%   90975360 ±  2%  numa-vmstat.node1.numa_hit
 1.506e+08 ±  2%     -39.6%   90877046 ±  2%  numa-vmstat.node1.numa_local
     27.38 ± 21%    +304.1%     110.62 ± 19%  perf-c2c.DRAM.local
      6940 ± 14%    +109.3%      14525 ± 11%  perf-c2c.DRAM.remote
      3065 ±  9%    +326.8%      13081 ± 12%  perf-c2c.HITM.local
    114.00 ±  9%    +149.9%     284.88 ± 16%  perf-c2c.HITM.remote
      3179 ±  9%    +320.5%      13366 ± 12%  perf-c2c.HITM.total
   3406339 ±  4%     +18.2%    4026112 ±  7%  meminfo.Active
   3406339 ±  4%     +18.2%    4026112 ±  7%  meminfo.Active(anon)
   6098973 ±  2%     +10.0%    6710127 ±  4%  meminfo.Cached
  30032595           +10.5%   33186524        meminfo.Committed_AS
   1011475 ±  2%     +12.2%    1134788 ±  3%  meminfo.SUnreclaim
   2560004 ±  6%     +23.9%    3171161 ±  8%  meminfo.Shmem
   1181332           +10.6%    1306100 ±  3%  meminfo.Slab
    851570 ±  4%     +18.2%    1006576 ±  7%  proc-vmstat.nr_active_anon
   1524757 ±  2%     +10.0%    1677652 ±  4%  proc-vmstat.nr_file_pages
    640014 ±  6%     +23.9%     792909 ±  8%  proc-vmstat.nr_shmem
    258590 ±  2%      +9.2%     282356        proc-vmstat.nr_slab_unreclaimable
    851570 ±  4%     +18.2%    1006576 ±  7%  proc-vmstat.nr_zone_active_anon
 3.048e+08           -40.6%  1.812e+08 ±  2%  proc-vmstat.numa_hit
 3.046e+08           -40.6%   1.81e+08 ±  2%  proc-vmstat.numa_local
 1.213e+09           -40.8%   7.18e+08 ±  2%  proc-vmstat.pgalloc_normal
 1.212e+09           -40.9%  7.169e+08 ±  2%  proc-vmstat.pgfree
      1.00            +2.1%       1.02        perf-stat.i.MPKI
 1.205e+11           -19.9%  9.651e+10        perf-stat.i.branch-instructions
      0.10            +0.0        0.13        perf-stat.i.branch-miss-rate%
 1.041e+08            +7.3%  1.117e+08        perf-stat.i.branch-misses
     67.15            -9.2       58.00        perf-stat.i.cache-miss-rate%
 5.616e+08           -18.5%  4.579e+08        perf-stat.i.cache-misses
 8.353e+08            -5.6%  7.889e+08        perf-stat.i.cache-references
     12735 ±  2%     -24.3%       9645        perf-stat.i.context-switches
      0.98           +25.7%       1.23        perf-stat.i.cpi
    568.41 ±  2%     -24.5%     429.39        perf-stat.i.cpu-migrations
    982.40           +23.1%       1209        perf-stat.i.cycles-between-cache-misses
  5.66e+11           -20.2%  4.518e+11        perf-stat.i.instructions
      1.03           -20.4%       0.82        perf-stat.i.ipc
      0.99            +2.1%       1.02        perf-stat.overall.MPKI
      0.09            +0.0        0.12        perf-stat.overall.branch-miss-rate%
     67.31            -9.3       58.05        perf-stat.overall.cache-miss-rate%
      0.98           +25.7%       1.23        perf-stat.overall.cpi
    982.46           +23.2%       1209        perf-stat.overall.cycles-between-cache-misses
      1.02           -20.5%       0.81        perf-stat.overall.ipc
   3952600            +2.2%    4040369        perf-stat.overall.path-length
 1.201e+11           -19.9%  9.614e+10        perf-stat.ps.branch-instructions
 1.029e+08            +7.6%  1.107e+08        perf-stat.ps.branch-misses
 5.608e+08           -18.5%   4.57e+08        perf-stat.ps.cache-misses
 8.332e+08            -5.5%  7.873e+08        perf-stat.ps.cache-references
     12643 ±  2%     -24.2%       9588        perf-stat.ps.context-switches
    554.75 ±  2%     -24.3%     419.88        perf-stat.ps.cpu-migrations
 5.637e+11           -20.2%  4.501e+11        perf-stat.ps.instructions
 1.707e+14           -20.2%  1.362e+14        perf-stat.total.instructions
  20670046           +16.4%   24055419        sched_debug.cfs_rq:/.avg_vruntime.avg
  21034792           +15.8%   24354538        sched_debug.cfs_rq:/.avg_vruntime.max
  14918360 ±  2%     +25.7%   18758523 ±  3%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.37 ±  2%     -21.8%       0.29 ±  6%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.37 ±  2%     -21.8%       0.29 ±  5%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   3188415 ± 13%     -54.4%    1453374 ± 28%  sched_debug.cfs_rq:/.left_deadline.avg
  20941830           +15.8%   24260743        sched_debug.cfs_rq:/.left_deadline.max
   7405402 ±  5%     -26.1%    5473882 ± 16%  sched_debug.cfs_rq:/.left_deadline.stddev
   3188370 ± 13%     -54.4%    1453356 ± 28%  sched_debug.cfs_rq:/.left_vruntime.avg
  20941509           +15.8%   24260483        sched_debug.cfs_rq:/.left_vruntime.max
   7405297 ±  5%     -26.1%    5473817 ± 16%  sched_debug.cfs_rq:/.left_vruntime.stddev
    138019 ±  9%     -56.1%      60630 ± 17%  sched_debug.cfs_rq:/.load.avg
    313107 ±  4%     -33.0%     209813 ± 12%  sched_debug.cfs_rq:/.load.stddev
    219.64 ±  5%     -40.9%     129.85 ± 17%  sched_debug.cfs_rq:/.load_avg.avg
     74.52 ± 22%     -61.8%      28.48 ± 11%  sched_debug.cfs_rq:/.load_avg.min
  20670074           +16.4%   24055432        sched_debug.cfs_rq:/.min_vruntime.avg
  21034799           +15.8%   24354550        sched_debug.cfs_rq:/.min_vruntime.max
  14918366 ±  2%     +25.7%   18758541 ±  3%  sched_debug.cfs_rq:/.min_vruntime.min
      0.34 ±  4%     -29.2%       0.24 ± 10%  sched_debug.cfs_rq:/.nr_queued.stddev
   3188371 ± 13%     -54.4%    1453357 ± 28%  sched_debug.cfs_rq:/.right_vruntime.avg
  20941509           +15.8%   24260486        sched_debug.cfs_rq:/.right_vruntime.max
   7405298 ±  5%     -26.1%    5473818 ± 16%  sched_debug.cfs_rq:/.right_vruntime.stddev
    103.28 ± 10%     -25.9%      76.56 ± 15%  sched_debug.cfs_rq:/.util_avg.stddev
    410551 ±  8%     +14.9%     471821 ±  7%  sched_debug.cpu.avg_idle.stddev
      1368 ±  6%     -21.8%       1070        sched_debug.cpu.clock_task.stddev
    169.54 ± 26%     +78.8%     303.17 ± 23%  sched_debug.cpu.curr->pid.min
      1871 ±  3%     -30.6%       1298 ±  8%  sched_debug.cpu.curr->pid.stddev
      0.37 ±  2%     -22.1%       0.29 ±  6%  sched_debug.cpu.nr_running.stddev
     11054 ±  2%     -21.2%       8711        sched_debug.cpu.nr_switches.avg
     65701 ±  6%     -23.2%      50488 ± 18%  sched_debug.cpu.nr_switches.max
      8399           -26.1%       6210        sched_debug.cpu.nr_switches.min
      5964 ±  8%     -26.2%       4402 ± 14%  sched_debug.cpu.nr_switches.stddev
      6.81 ±  6%     -16.1%       5.72 ±  8%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      6.79 ±  6%     -18.4%       5.54 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.69 ±  6%     -15.2%       5.67 ±  5%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      6.86 ±  7%     -19.0%       5.56 ±  5%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      6.90 ±  8%     -18.8%       5.60 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      5.58 ± 29%     -51.7%       2.70 ± 28%  perf-sched.sch_delay.avg.ms.__cond_resched.stop_one_cpu.sched_exec.bprm_execve.part
      7.14 ±  7%     -22.8%       5.52 ±  6%  perf-sched.sch_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      6.83 ±  6%     -16.8%       5.68 ±  7%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.06 ± 42%     -64.1%       0.02 ± 43%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      6.72 ±  7%     -17.5%       5.55 ±  7%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.23 ± 17%     -37.0%       0.15 ± 22%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
     60.90 ± 36%     -42.8%      34.83 ± 38%  perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.32 ±  6%     -20.1%       2.66 ±  6%  perf-sched.total_sch_delay.average.ms
     46.22 ±  3%     +24.5%      57.55 ±  2%  perf-sched.total_wait_and_delay.average.ms
     64361 ±  3%     -22.5%      49858 ±  2%  perf-sched.total_wait_and_delay.count.ms
     42.90 ±  3%     +28.0%      54.89 ±  2%  perf-sched.total_wait_time.average.ms
     13.63 ±  6%     -16.1%      11.43 ±  8%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
     13.58 ±  6%     -18.4%      11.08 ±  9%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.39 ±  6%     -15.2%      11.35 ±  5%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     13.73 ±  7%     -19.0%      11.12 ±  5%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
     13.80 ±  8%     -18.8%      11.21 ±  9%  perf-sched.wait_and_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     35.08 ±  7%     +47.8%      51.83 ±  5%  perf-sched.wait_and_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     14.28 ±  7%     -22.8%      11.03 ±  6%  perf-sched.wait_and_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
     13.66 ±  6%     -16.8%      11.36 ±  7%  perf-sched.wait_and_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
     64.08 ±  3%     +39.7%      89.53 ±  2%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    592.25 ±  4%     -48.5%     305.00 ±  5%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
    683.62 ±  6%     -48.1%     355.12 ±  6%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1123 ±  2%     -51.0%     550.75 ±  6%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      4737 ±  3%     -47.0%       2509 ±  2%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      2064 ±  4%     -52.2%     986.62 ±  2%  perf-sched.wait_and_delay.count.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1323 ±  7%     -44.5%     734.50 ± 13%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      7292 ±  3%     -55.1%       3273 ±  3%  perf-sched.wait_and_delay.count.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      3604 ±  4%     -52.2%       1724 ±  4%  perf-sched.wait_and_delay.count.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      9502 ±  4%     +39.4%      13249 ±  4%  perf-sched.wait_and_delay.count.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1129 ±  6%     -46.7%     601.50 ±  2%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
     24865 ±  3%     -25.6%      18503        perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    121.79 ± 36%     -42.8%      69.65 ± 38%  perf-sched.wait_and_delay.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.81 ±  6%     -16.1%       5.72 ±  8%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      6.79 ±  6%     -18.4%       5.54 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.69 ±  6%     -15.2%       5.67 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      6.86 ±  7%     -19.0%       5.56 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      6.90 ±  8%     -18.8%       5.60 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     35.01 ±  7%     +47.9%      51.79 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      7.14 ±  7%     -22.8%       5.52 ±  6%  perf-sched.wait_time.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      6.83 ±  6%     -16.8%       5.68 ±  7%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      6.99 ±  6%     -16.9%       5.81 ±  8%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     63.95 ±  3%     +39.8%      89.43 ±  2%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     60.90 ± 36%     -42.8%      34.83 ± 38%  perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     41.87           -16.2       25.66        perf-profile.calltrace.cycles-pp.__munmap
     40.22           -15.7       24.49        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
     40.08           -15.7       24.39        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     39.34           -15.4       23.92        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     39.27           -15.4       23.88        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
     38.32           -15.1       23.25        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
     37.00           -14.7       22.32        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
     14.06           -13.9        0.13 ±173%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     20.66           -11.7        8.93 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     10.94           -10.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core
     10.81           -10.8        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch
     23.30           -10.0       13.30 ±  5%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     23.30           -10.0       13.30 ±  5%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     23.30           -10.0       13.30 ±  5%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     23.29           -10.0       13.29 ±  5%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     23.28           -10.0       13.28 ±  5%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     23.28           -10.0       13.28 ±  5%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     23.28           -10.0       13.28 ±  5%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     23.23           -10.0       13.25 ±  5%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     20.58            -7.4       13.20        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      6.16            -6.2        0.00        perf-profile.calltrace.cycles-pp.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     17.09            -6.1       10.95        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      5.91            -5.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core
      5.86            -5.9        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch
     10.06            -5.1        4.99        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     11.53            -4.1        7.40        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      9.99            -4.1        5.93        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
     10.85            -3.9        6.94        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      4.22 ±  2%      -3.6        0.67 ±  3%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      4.02 ±  3%      -3.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      6.10            -3.1        2.96        perf-profile.calltrace.cycles-pp.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      5.33            -1.9        3.44        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.29            -1.8        3.53        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      4.91            -1.6        3.27        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      4.60            -1.6        2.98        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      4.54            -1.5        3.03        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      4.48            -1.5        3.02        perf-profile.calltrace.cycles-pp.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      4.08            -1.5        2.63        perf-profile.calltrace.cycles-pp.rcu_all_qs.__cond_resched.zap_pmd_range.unmap_page_range.unmap_vmas
      3.72            -1.3        2.42        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      3.76            -1.3        2.46        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      3.67            -1.3        2.40        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      3.38            -1.2        2.20        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas
      5.26            -1.1        4.13 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      3.07            -1.1        2.00        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.vms_clear_ptes
      2.89            -1.1        1.82        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      2.41            -0.9        1.52        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
      4.03            -0.9        3.17 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.36            -0.8        0.54        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      1.35            -0.8        0.54        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      4.18            -0.8        3.43 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      1.89            -0.7        1.22        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.92            -0.6        1.30        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
      1.54            -0.6        0.99        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.52            -0.5        1.00        perf-profile.calltrace.cycles-pp.mas_find.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      1.38 ±  2%      -0.5        0.89 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.28            -0.5        0.83        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
      0.86 ±  4%      -0.4        0.47 ± 38%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.08            -0.4        0.70        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.03            -0.4        0.65        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.96            -0.4        0.60 ±  2%  perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      1.09            -0.4        0.74        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap
      1.10            -0.3        0.79        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.85            -0.3        0.55        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.81            -0.3        0.52        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.84            -0.3        0.55        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.81            -0.3        0.53        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_prepare.__mmap_region.do_mmap
      0.99            -0.3        0.72        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      0.90            -0.2        0.68        perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.__mmap_prepare.__mmap_region.do_mmap.vm_mmap_pgoff
      1.06 ±  3%      -0.2        0.89 ±  3%  perf-profile.calltrace.cycles-pp.mas_pop_node.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.69 ±  4%      -0.1        0.56 ±  3%  perf-profile.calltrace.cycles-pp.mas_put_in_tree.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.55 ±  3%      +0.1        0.66 ±  5%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      1.04            +0.1        1.17 ±  3%  perf-profile.calltrace.cycles-pp.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.52 ±  3%      +0.2        0.71 ±  4%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      0.00            +0.7        0.66 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc
      0.00            +0.7        0.66 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +0.7        0.68 ±  3%  perf-profile.calltrace.cycles-pp.shuffle_freelist.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.7        0.74 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +0.8        0.75 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.8        0.79 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main
      0.00            +0.8        0.80 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.8        0.80 ±  4%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf
      0.00            +0.8        0.80 ±  4%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.8        0.84 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.8        0.85 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +0.9        0.85 ±  4%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.9        0.86 ±  4%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +0.9        0.86 ±  9%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +0.9        0.90 ±  9%  perf-profile.calltrace.cycles-pp.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.96 ± 38%      +0.9        1.88 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.9        0.93 ±  8%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.9        0.93 ±  8%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf
      0.00            +0.9        0.93 ±  8%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.9        0.94 ±  8%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +1.0        0.97 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.0        1.02 ±  9%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.2        1.22 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free
      0.00            +1.2        1.24 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +1.3        1.28 ±  8%  perf-profile.calltrace.cycles-pp.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      1.18 ±  5%      +1.3        2.51 ±  5%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      1.18 ±  5%      +1.3        2.52 ±  5%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      2.46 ±  6%      +1.8        4.25 ±  6%  perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.00            +1.9        1.90 ±  9%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +1.9        1.93 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +2.0        2.01 ±  9%  perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +3.1        3.12 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +3.1        3.14 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +3.2        3.19 ±  4%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +3.4        3.44 ± 11%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +3.6        3.59 ± 10%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +4.2        4.25 ±  4%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +4.3        4.28 ±  6%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +4.7        4.71 ±  8%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +7.1        7.10 ±  8%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      0.00            +8.4        8.45 ±  5%  perf-profile.calltrace.cycles-pp.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      0.00           +14.1       14.13        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +14.3       14.26        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +14.4       14.36 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +14.4       14.39 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +14.4       14.41        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00           +15.5       15.52 ±  2%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     34.15           +26.3       60.47        perf-profile.calltrace.cycles-pp.__mmap
     32.51           +26.8       59.34        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
     32.37           +26.9       59.24        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     31.31           +27.2       58.52        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     29.98           +27.6       57.63        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
     23.73           +29.7       53.40        perf-profile.calltrace.cycles-pp.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.35           +33.1       46.47        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      5.65 ±  2%     +35.1       40.75        perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      4.34 ±  2%     +35.6       39.91        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
      4.11 ±  3%     +35.7       39.77        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma.__mmap_region
      0.00           +39.3       39.34        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
     42.51           -16.4       26.11        perf-profile.children.cycles-pp.__munmap
     30.23           -15.6       14.63 ±  3%  perf-profile.children.cycles-pp.kmem_cache_free
     39.36           -15.4       23.93        perf-profile.children.cycles-pp.__x64_sys_munmap
     39.31           -15.4       23.91        perf-profile.children.cycles-pp.__vm_munmap
     38.36           -15.1       23.28        perf-profile.children.cycles-pp.do_vmi_munmap
     37.05           -14.7       22.35        perf-profile.children.cycles-pp.do_vmi_align_munmap
     19.26           -12.2        7.04 ±  5%  perf-profile.children.cycles-pp.__slab_free
     32.35           -12.0       20.33 ±  2%  perf-profile.children.cycles-pp.handle_softirqs
     32.33           -12.0       20.32 ±  2%  perf-profile.children.cycles-pp.rcu_core
     32.32           -12.0       20.31 ±  2%  perf-profile.children.cycles-pp.rcu_do_batch
     23.30           -10.0       13.30 ±  5%  perf-profile.children.cycles-pp.kthread
     23.30           -10.0       13.30 ±  5%  perf-profile.children.cycles-pp.ret_from_fork
     23.30           -10.0       13.30 ±  5%  perf-profile.children.cycles-pp.ret_from_fork_asm
     23.29           -10.0       13.29 ±  5%  perf-profile.children.cycles-pp.smpboot_thread_fn
     23.28           -10.0       13.28 ±  5%  perf-profile.children.cycles-pp.run_ksoftirqd
     20.80            -7.5       13.34        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
     17.15            -6.2       10.98        perf-profile.children.cycles-pp.vms_clear_ptes
      8.92 ±  2%      -5.5        3.45 ±  6%  perf-profile.children.cycles-pp.__put_partials
     11.04            -5.4        5.64        perf-profile.children.cycles-pp.mas_store_gfp
     11.60            -4.2        7.44        perf-profile.children.cycles-pp.unmap_vmas
     10.90            -3.9        6.97        perf-profile.children.cycles-pp.unmap_page_range
      6.84 ±  3%      -3.6        3.19 ±  4%  perf-profile.children.cycles-pp.___slab_alloc
     10.02            -3.6        6.39        perf-profile.children.cycles-pp.zap_pmd_range
      7.52            -2.7        4.80        perf-profile.children.cycles-pp.__cond_resched
      9.72 ±  2%      -2.3        7.46 ±  3%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      9.68 ±  2%      -2.3        7.43 ±  3%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      3.94 ±  6%      -2.1        1.88 ±  9%  perf-profile.children.cycles-pp.get_partial_node
      9.06 ±  2%      -2.0        7.05 ±  3%  perf-profile.children.cycles-pp.__irq_exit_rcu
      5.51            -2.0        3.55        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      5.34            -1.8        3.56        perf-profile.children.cycles-pp.__get_unmapped_area
      5.11            -1.7        3.37        perf-profile.children.cycles-pp.mas_find
      8.47            -1.7        6.78 ±  2%  perf-profile.children.cycles-pp.mas_wr_node_store
      4.70            -1.7        3.04        perf-profile.children.cycles-pp.free_pgtables
      4.94            -1.7        3.28        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      4.59            -1.5        3.07        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      4.59            -1.5        3.09        perf-profile.children.cycles-pp.__mmap_prepare
      3.95            -1.4        2.53        perf-profile.children.cycles-pp.rcu_all_qs
      3.76            -1.3        2.44        perf-profile.children.cycles-pp.free_pgd_range
      3.79            -1.3        2.49        perf-profile.children.cycles-pp.vm_unmapped_area
      3.73            -1.3        2.44        perf-profile.children.cycles-pp.unmapped_area_topdown
      3.40            -1.2        2.21        perf-profile.children.cycles-pp.free_p4d_range
      5.31            -1.1        4.16 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      2.92            -1.1        1.84        perf-profile.children.cycles-pp.perf_event_mmap
      3.08            -1.1        2.00        perf-profile.children.cycles-pp.free_pud_range
      2.02 ±  2%      -1.1        0.97 ±  3%  perf-profile.children.cycles-pp.allocate_slab
      1.83 ±  2%      -0.9        0.89 ±  3%  perf-profile.children.cycles-pp.shuffle_freelist
      2.53            -0.9        1.59        perf-profile.children.cycles-pp.perf_event_mmap_event
      1.99            -0.7        1.27        perf-profile.children.cycles-pp.mas_prev_slot
      2.17            -0.7        1.49        perf-profile.children.cycles-pp.mas_walk
      1.92            -0.7        1.24        perf-profile.children.cycles-pp.vm_area_alloc
      1.85            -0.7        1.18        perf-profile.children.cycles-pp.mas_next_slot
      2.02            -0.7        1.36        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.47            -0.5        0.94        perf-profile.children.cycles-pp.mas_wr_store_type
      1.33            -0.5        0.86        perf-profile.children.cycles-pp.mas_rev_awalk
      1.59            -0.4        1.14        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.25            -0.4        0.82        perf-profile.children.cycles-pp.__pi_memcpy
      1.19            -0.4        0.79        perf-profile.children.cycles-pp.mas_update_gap
      1.15            -0.4        0.77        perf-profile.children.cycles-pp.perf_iterate_sb
      0.99            -0.4        0.62 ±  2%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.66 ±  2%      -0.4        0.31 ±  3%  perf-profile.children.cycles-pp.setup_object
      0.90 ±  4%      -0.3        0.55 ±  5%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.96            -0.3        0.64        perf-profile.children.cycles-pp.__vma_start_write
      1.54 ±  3%      -0.3        1.22 ±  3%  perf-profile.children.cycles-pp.mas_pop_node
      0.82 ±  3%      -0.3        0.54 ±  2%  perf-profile.children.cycles-pp.down_write_killable
      0.84            -0.3        0.56        perf-profile.children.cycles-pp.mas_leaf_max_gap
      1.02            -0.3        0.76        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.72            -0.2        0.47        perf-profile.children.cycles-pp.mas_prev
      0.64 ±  3%      -0.2        0.40 ±  4%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.63 ±  3%      -0.2        0.40 ±  5%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.75            -0.2        0.54        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.91 ±  3%      -0.2        0.70 ±  3%  perf-profile.children.cycles-pp.mas_put_in_tree
      0.53 ±  3%      -0.2        0.32 ±  7%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.52 ±  4%      -0.2        0.31 ±  6%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.50 ±  3%      -0.2        0.29 ±  7%  perf-profile.children.cycles-pp.update_process_times
      0.54            -0.2        0.36        perf-profile.children.cycles-pp.mas_prev_setup
      0.42            -0.2        0.26        perf-profile.children.cycles-pp.mas_prev_range
      0.49            -0.2        0.33        perf-profile.children.cycles-pp.up_read
      0.43            -0.1        0.29 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.41            -0.1        0.26        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.41 ±  2%      -0.1        0.26        perf-profile.children.cycles-pp.mas_data_end
      0.34            -0.1        0.21        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.36 ±  3%      -0.1        0.23 ±  4%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.31            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.sized_strscpy
      0.34            -0.1        0.22 ±  3%  perf-profile.children.cycles-pp.refill_obj_stock
      0.29            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.39            -0.1        0.26 ±  2%  perf-profile.children.cycles-pp.static_key_count
      0.47            -0.1        0.36        perf-profile.children.cycles-pp.vma_set_page_prot
      0.33            -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.vma_merge_new_range
      0.32 ±  3%      -0.1        0.21 ±  8%  perf-profile.children.cycles-pp.sched_tick
      0.30            -0.1        0.19        perf-profile.children.cycles-pp.kfree
      0.28            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.__account_obj_stock
      0.28            -0.1        0.18        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.28            -0.1        0.18 ±  2%  perf-profile.children.cycles-pp.up_write
      0.17            -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.16 ±  2%      -0.1        0.07 ±  4%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.15 ±  2%      -0.1        0.06 ±  6%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.26 ±  2%      -0.1        0.17 ±  3%  perf-profile.children.cycles-pp.vm_get_page_prot
      0.29            -0.1        0.20        perf-profile.children.cycles-pp.__vm_enough_memory
      0.29            -0.1        0.21 ±  2%  perf-profile.children.cycles-pp.downgrade_write
      0.28            -0.1        0.19        perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.22 ±  2%      -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.mas_next_range
      0.18            -0.1        0.10        perf-profile.children.cycles-pp.strnlen
      0.25            -0.1        0.17        perf-profile.children.cycles-pp.mas_destroy
      0.22            -0.1        0.14 ±  2%  perf-profile.children.cycles-pp.remove_vma
      0.23            -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.x64_sys_call
      0.27            -0.1        0.19 ±  2%  perf-profile.children.cycles-pp.security_mmap_file
      0.25            -0.1        0.17        perf-profile.children.cycles-pp.vma_mark_detached
      0.22 ±  2%      -0.1        0.15        perf-profile.children.cycles-pp.vm_area_free
      0.27            -0.1        0.20        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.21            -0.1        0.14        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.15 ±  3%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.27            -0.1        0.20 ±  2%  perf-profile.children.cycles-pp.testcase
      0.20            -0.1        0.14 ±  4%  perf-profile.children.cycles-pp.may_expand_vm
      0.16 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.strlen
      0.17            -0.1        0.11        perf-profile.children.cycles-pp.security_mmap_addr
      0.16 ±  2%      -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.12 ±  4%      -0.1        0.06 ±  5%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.13 ±  3%      -0.0        0.08 ±  5%  perf-profile.children.cycles-pp.mmap_region
      0.11 ±  9%      -0.0        0.06 ± 10%  perf-profile.children.cycles-pp.cmd_record
      0.10 ±  7%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.12 ±  5%      -0.0        0.08 ±  7%  perf-profile.children.cycles-pp.task_tick_fair
      0.10 ±  9%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.10 ±  4%      -0.0        0.06        perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.15 ±  2%      -0.0        0.11 ±  3%  perf-profile.children.cycles-pp.get_mmap_base
      0.10 ± 10%      -0.0        0.06 ±  7%  perf-profile.children.cycles-pp.perf_mmap__push
      0.13            -0.0        0.09 ±  3%  perf-profile.children.cycles-pp.ksys_mmap_pgoff
      0.11 ±  9%      -0.0        0.07 ±  8%  perf-profile.children.cycles-pp.handle_internal_command
      0.11 ±  9%      -0.0        0.07 ±  8%  perf-profile.children.cycles-pp.main
      0.11 ±  9%      -0.0        0.07 ±  8%  perf-profile.children.cycles-pp.run_builtin
      0.10            -0.0        0.06        perf-profile.children.cycles-pp.can_vma_merge_right
      0.09 ± 11%      -0.0        0.05 ± 39%  perf-profile.children.cycles-pp.update_curr
      0.11            -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.mas_node_count_gfp
      0.06 ±  5%      -0.0        0.02 ±100%  perf-profile.children.cycles-pp.__x64_sys_mmap
      0.14 ±  3%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.cap_capable
      0.19 ±  2%      -0.0        0.15 ±  2%  perf-profile.children.cycles-pp.unmap_single_vma
      0.10            -0.0        0.07 ±  7%  perf-profile.children.cycles-pp.mas_next_setup
      0.10 ±  3%      -0.0        0.07        perf-profile.children.cycles-pp.ima_file_mmap
      0.11 ±  4%      -0.0        0.08 ± 11%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.08 ±  5%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.08 ±  5%      -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.mas_nomem
      0.07 ±  8%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.ktime_get
      0.07            -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.cap_mmap_addr
      0.07            -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.finish_rcuwait
      0.13 ±  2%      -0.0        0.11 ±  4%  perf-profile.children.cycles-pp.vm_stat_account
      0.16 ±  2%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.cap_vm_enough_memory
      0.16            -0.0        0.14 ±  4%  perf-profile.children.cycles-pp.munmap@plt
      0.07            -0.0        0.05        perf-profile.children.cycles-pp.__mt_destroy
      0.07            -0.0        0.05        perf-profile.children.cycles-pp.ksm_vma_flags
      0.06 ±  7%      -0.0        0.04 ± 37%  perf-profile.children.cycles-pp.clockevents_program_event
      0.06 ±  7%      -0.0        0.05        perf-profile.children.cycles-pp.mt_free_rcu
      0.71 ± 10%      +0.2        0.90 ±  9%  perf-profile.children.cycles-pp.get_any_partial
      1.12 ±  3%      +0.3        1.39 ±  4%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.4        0.39 ±  5%  perf-profile.children.cycles-pp.build_detached_freelist
      0.00            +2.1        2.06 ±  8%  perf-profile.children.cycles-pp.barn_replace_full_sheaf
      3.33 ±  5%      +3.1        6.46 ±  4%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +4.3        4.25 ±  4%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.00            +4.5        4.54 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      0.00            +8.9        8.87 ±  7%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00           +11.0       11.03 ±  4%  perf-profile.children.cycles-pp.__pcs_replace_full_main
     72.83           +11.1       83.90        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     72.59           +11.1       83.73        perf-profile.children.cycles-pp.do_syscall_64
      0.00           +14.4       14.41        perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00           +15.6       15.55 ±  2%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
     25.77 ±  2%     +17.2       42.94        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     26.07           +17.4       43.44        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     34.78           +26.1       60.93        perf-profile.children.cycles-pp.__mmap
     31.40           +27.2       58.58        perf-profile.children.cycles-pp.vm_mmap_pgoff
     30.03           +27.6       57.66        perf-profile.children.cycles-pp.do_mmap
     23.91           +29.6       53.53        perf-profile.children.cycles-pp.__mmap_region
      9.76 ±  2%     +31.6       41.36        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      8.62 ±  2%     +32.0       40.62        perf-profile.children.cycles-pp.mas_alloc_nodes
     13.42           +33.1       46.52        perf-profile.children.cycles-pp.__mmap_new_vma
      5.70 ±  2%     +35.1       40.79        perf-profile.children.cycles-pp.mas_preallocate
      0.00           +39.6       39.60        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      4.32 ±  5%      -2.0        2.33 ±  4%  perf-profile.self.cycles-pp.__slab_free
      3.76            -1.3        2.50        perf-profile.self.cycles-pp.__cond_resched
      3.53            -1.2        2.36        perf-profile.self.cycles-pp.zap_pmd_range
      2.73            -0.9        1.84        perf-profile.self.cycles-pp.free_pud_range
      2.26            -0.8        1.46        perf-profile.self.cycles-pp.rcu_all_qs
      1.47 ±  2%      -0.7        0.77 ±  3%  perf-profile.self.cycles-pp.shuffle_freelist
      1.71            -0.6        1.12        perf-profile.self.cycles-pp.mas_prev_slot
      1.47            -0.6        0.89        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      1.55            -0.5        1.02        perf-profile.self.cycles-pp.mas_next_slot
      1.85            -0.5        1.33        perf-profile.self.cycles-pp.mas_walk
      1.66            -0.5        1.18        perf-profile.self.cycles-pp.__mmap_region
      1.36 ±  2%      -0.4        0.93 ±  2%  perf-profile.self.cycles-pp.mas_wr_node_store
      1.26            -0.4        0.83        perf-profile.self.cycles-pp.mas_wr_store_type
      1.17            -0.4        0.78        perf-profile.self.cycles-pp.mas_find
      1.16            -0.4        0.77        perf-profile.self.cycles-pp.mas_store_gfp
      0.67            -0.4        0.28 ±  3%  perf-profile.self.cycles-pp.___slab_alloc
      1.01            -0.3        0.68 ±  2%  perf-profile.self.cycles-pp.__pi_memcpy
      0.98            -0.3        0.66        perf-profile.self.cycles-pp.mas_rev_awalk
      1.05            -0.3        0.73        perf-profile.self.cycles-pp.do_syscall_64
      1.34 ±  3%      -0.3        1.08 ±  3%  perf-profile.self.cycles-pp.mas_pop_node
      1.17            -0.3        0.91        perf-profile.self.cycles-pp.kmem_cache_free
      0.83            -0.2        0.58        perf-profile.self.cycles-pp.__call_rcu_common
      0.72            -0.2        0.48        perf-profile.self.cycles-pp.mas_store_prealloc
      0.75            -0.2        0.52        perf-profile.self.cycles-pp.__vma_start_write
      0.75            -0.2        0.52        perf-profile.self.cycles-pp.mas_leaf_max_gap
      0.63            -0.2        0.41        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.56            -0.2        0.35        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.74            -0.2        0.52        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.69            -0.2        0.48        perf-profile.self.cycles-pp.unmap_page_range
      0.59            -0.2        0.39        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.69            -0.2        0.48        perf-profile.self.cycles-pp.__mmap
      0.63            -0.2        0.43        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.65            -0.2        0.45 ±  2%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.56            -0.2        0.36        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.68            -0.2        0.48        perf-profile.self.cycles-pp.__munmap
      0.62 ±  2%      -0.2        0.42        perf-profile.self.cycles-pp.mas_preallocate
      0.48 ±  7%      -0.2        0.30 ±  5%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.78 ±  4%      -0.2        0.62 ±  3%  perf-profile.self.cycles-pp.mas_put_in_tree
      0.49 ±  4%      -0.2        0.33 ±  2%  perf-profile.self.cycles-pp.down_write_killable
      0.42            -0.1        0.28        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.40            -0.1        0.25        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.58            -0.1        0.44        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.60            -0.1        0.46        perf-profile.self.cycles-pp.do_mmap
      0.22 ±  3%      -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.setup_object
      0.39            -0.1        0.26 ±  2%  perf-profile.self.cycles-pp.mas_prev_setup
      0.40            -0.1        0.27 ±  2%  perf-profile.self.cycles-pp.__mmap_new_vma
      0.38            -0.1        0.26        perf-profile.self.cycles-pp.__mmap_prepare
      0.41            -0.1        0.29        perf-profile.self.cycles-pp.__vm_munmap
      0.41            -0.1        0.29        perf-profile.self.cycles-pp.up_read
      0.33            -0.1        0.22        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.33            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
      0.35            -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.mas_prev
      0.49            -0.1        0.38 ±  2%  perf-profile.self.cycles-pp.mas_empty_area_rev
      0.33            -0.1        0.22        perf-profile.self.cycles-pp.perf_event_mmap
      0.35            -0.1        0.24 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.33            -0.1        0.22 ±  2%  perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.37            -0.1        0.26        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.26            -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.sized_strscpy
      0.28            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.31            -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.mas_update_gap
      0.30            -0.1        0.20 ±  2%  perf-profile.self.cycles-pp.mas_data_end
      0.29            -0.1        0.19        perf-profile.self.cycles-pp.unmap_vmas
      0.29            -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.free_pgtables
      0.23            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.28            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.free_p4d_range
      0.29            -0.1        0.20        perf-profile.self.cycles-pp.vm_area_alloc
      0.39            -0.1        0.30        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.23 ±  2%      -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.27            -0.1        0.19        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.24            -0.1        0.16        perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
      0.23            -0.1        0.15        perf-profile.self.cycles-pp.__account_obj_stock
      0.23            -0.1        0.15 ±  3%  perf-profile.self.cycles-pp.up_write
      0.26            -0.1        0.19        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.21            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.mas_prev_range
      0.22 ±  2%      -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.kfree
      0.21            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.21 ±  2%      -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.vm_get_page_prot
      0.24            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.static_key_count
      0.24            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.14 ±  2%      -0.1        0.08        perf-profile.self.cycles-pp.strnlen
      0.19            -0.1        0.13 ±  2%  perf-profile.self.cycles-pp.x64_sys_call
      0.18 ±  2%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.refill_obj_stock
      0.14 ±  3%      -0.1        0.09 ±  5%  perf-profile.self.cycles-pp.__put_partials
      0.16 ±  3%      -0.1        0.11 ±  3%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.22            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.__get_unmapped_area
      0.18 ±  2%      -0.1        0.12 ±  2%  perf-profile.self.cycles-pp.do_vmi_munmap
      0.16 ±  2%      -0.1        0.11        perf-profile.self.cycles-pp.vma_merge_new_range
      0.20 ±  2%      -0.1        0.15 ±  3%  perf-profile.self.cycles-pp.vma_mark_detached
      0.18            -0.1        0.13        perf-profile.self.cycles-pp.mas_destroy
      0.16 ±  3%      -0.1        0.12 ±  4%  perf-profile.self.cycles-pp.may_expand_vm
      0.13            -0.1        0.08        perf-profile.self.cycles-pp.strlen
      0.16            -0.1        0.11        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.18            -0.0        0.13        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.12 ±  2%      -0.0        0.08        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.15 ±  2%      -0.0        0.11 ±  2%  perf-profile.self.cycles-pp.security_mmap_file
      0.20 ±  5%      -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.testcase
      0.12 ±  4%      -0.0        0.08 ±  5%  perf-profile.self.cycles-pp.mas_next_range
      0.11 ±  4%      -0.0        0.07        perf-profile.self.cycles-pp.security_mmap_addr
      0.09 ±  5%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.get_partial_node
      0.11 ±  4%      -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.ksys_mmap_pgoff
      0.10 ±  4%      -0.0        0.07 ± 13%  perf-profile.self.cycles-pp.update_rq_clock_task
      0.10 ±  3%      -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.mmap_region
      0.12            -0.0        0.09        perf-profile.self.cycles-pp.__vm_enough_memory
      0.11 ±  4%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.cap_capable
      0.08            -0.0        0.05 ±  8%  perf-profile.self.cycles-pp.mas_node_count_gfp
      0.08 ±  5%      -0.0        0.05        perf-profile.self.cycles-pp.remove_vma
      0.15 ±  3%      -0.0        0.12        perf-profile.self.cycles-pp.unmap_single_vma
      0.22            -0.0        0.20 ±  3%  perf-profile.self.cycles-pp.vma_set_page_prot
      0.07 ±  5%      -0.0        0.05        perf-profile.self.cycles-pp.can_vma_merge_right
      0.11            -0.0        0.09 ±  4%  perf-profile.self.cycles-pp.get_mmap_base
      0.15 ±  2%      -0.0        0.13 ±  2%  perf-profile.self.cycles-pp.rcu_do_batch
      0.08            -0.0        0.06        perf-profile.self.cycles-pp.ima_file_mmap
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.mas_next_setup
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.vm_area_free
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.vm_unmapped_area
      0.09            -0.0        0.08 ±  4%  perf-profile.self.cycles-pp.vm_stat_account
      0.00            +0.1        0.06 ±  9%  perf-profile.self.cycles-pp.barn_replace_full_sheaf
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.__pcs_replace_full_main
      0.00            +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.barn_put_empty_sheaf
      0.30 ±  2%      +0.2        0.49 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.2        0.22 ±  3%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.00            +0.3        0.27 ±  2%  perf-profile.self.cycles-pp.barn_get_empty_sheaf
      1.08 ±  3%      +0.3        1.36 ±  4%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.4        0.39 ±  5%  perf-profile.self.cycles-pp.build_detached_freelist
      0.00            +1.0        0.99 ±  5%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      3.30 ±  5%      +3.1        6.41 ±  4%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
     25.77 ±  2%     +17.2       42.94        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath



***************************************************************************************************
igk-spr-2sp1: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/process/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/brk2/will-it-scale

commit: 
  7c1ca28747 ("tools/testing: Add testing support for slab caches with sheaves")
  71a82407f1 ("maple_tree: use percpu sheaves for maple_node_cache")

7c1ca28747078885 71a82407f1c94903b3835b4c935 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     13420           -25.7%       9973        vmstat.system.cs
    253541            -1.3%     250326        vmstat.system.in
   3308095 ±  6%     +15.6%    3823642 ±  6%  meminfo.Active
   3308095 ±  6%     +15.6%    3823642 ±  6%  meminfo.Active(anon)
   2460051 ±  8%     +20.5%    2964917 ±  7%  meminfo.Shmem
   2801930 ± 11%     +22.2%    3423369 ± 11%  numa-meminfo.node1.Active
   2801930 ± 11%     +22.2%    3423369 ± 11%  numa-meminfo.node1.Active(anon)
   2353564 ±  9%     +24.1%    2921574 ±  8%  numa-meminfo.node1.Shmem
  91930871           -28.9%   65361342        will-it-scale.192.processes
    478806           -28.9%     340423        will-it-scale.per_process_ops
  91930871           -28.9%   65361342        will-it-scale.workload
      0.66 ±  2%      -0.2        0.46        mpstat.cpu.all.irq%
     36.37           -12.4       23.94        mpstat.cpu.all.soft%
     59.20           +13.7       72.89        mpstat.cpu.all.sys%
      3.25            -1.0        2.21        mpstat.cpu.all.usr%
 1.661e+08           -45.2%   90952422        numa-numastat.node0.local_node
 1.662e+08           -45.2%   91048208        numa-numastat.node0.numa_hit
 1.662e+08           -46.5%   88857357        numa-numastat.node1.local_node
 1.663e+08           -46.5%   88958022        numa-numastat.node1.numa_hit
     32.62 ± 27%    +431.0%     173.25 ± 31%  perf-c2c.DRAM.local
      6874 ± 12%     +92.5%      13233 ± 15%  perf-c2c.DRAM.remote
      3150 ± 14%    +249.4%      11008 ±  9%  perf-c2c.HITM.local
    141.25 ± 23%    +113.8%     302.00 ± 28%  perf-c2c.HITM.remote
      3291 ± 14%    +243.6%      11310 ± 10%  perf-c2c.HITM.total
 1.662e+08           -45.2%   91042741        numa-vmstat.node0.numa_hit
 1.661e+08           -45.2%   90946955        numa-vmstat.node0.numa_local
    700525 ± 11%     +22.2%     856047 ± 11%  numa-vmstat.node1.nr_active_anon
    588447 ±  9%     +24.2%     730599 ±  8%  numa-vmstat.node1.nr_shmem
    700525 ± 11%     +22.2%     856046 ± 11%  numa-vmstat.node1.nr_zone_active_anon
 1.663e+08           -46.5%   88953076        numa-vmstat.node1.numa_hit
 1.662e+08           -46.5%   88852412        numa-vmstat.node1.numa_local
    827002 ±  6%     +15.6%     955859 ±  6%  proc-vmstat.nr_active_anon
   1499751 ±  3%      +8.4%    1625915 ±  3%  proc-vmstat.nr_file_pages
    615013 ±  8%     +20.5%     741176 ±  7%  proc-vmstat.nr_shmem
    827002 ±  6%     +15.6%     955859 ±  6%  proc-vmstat.nr_zone_active_anon
 3.326e+08           -45.9%    1.8e+08        proc-vmstat.numa_hit
 3.324e+08           -45.9%  1.798e+08        proc-vmstat.numa_local
 1.324e+09           -46.1%  7.134e+08        proc-vmstat.pgalloc_normal
 1.323e+09           -46.2%  7.123e+08        proc-vmstat.pgfree
      1.56           +11.9%       1.75        perf-stat.i.MPKI
 8.852e+10           -25.3%  6.616e+10        perf-stat.i.branch-instructions
      0.10 ±  2%      +0.0        0.14        perf-stat.i.branch-miss-rate%
  80781336           +10.1%   88960612        perf-stat.i.branch-misses
     70.44            -9.5       60.99        perf-stat.i.cache-miss-rate%
 6.728e+08           -17.0%  5.585e+08        perf-stat.i.cache-misses
  9.54e+08            -4.1%  9.153e+08        perf-stat.i.cache-references
     13425           -26.0%       9936        perf-stat.i.context-switches
      1.28           +35.6%       1.73        perf-stat.i.cpi
    606.05           -21.9%     473.24        perf-stat.i.cpu-migrations
    818.41           +21.2%     991.61        perf-stat.i.cycles-between-cache-misses
 4.318e+11           -25.8%  3.202e+11        perf-stat.i.instructions
      0.78           -26.2%       0.58        perf-stat.i.ipc
      1.56           +11.8%       1.75        perf-stat.overall.MPKI
      0.09            +0.0        0.13        perf-stat.overall.branch-miss-rate%
     70.65            -9.6       61.03        perf-stat.overall.cache-miss-rate%
      1.28           +35.6%       1.73        perf-stat.overall.cpi
    817.89           +21.3%     992.40        perf-stat.overall.cycles-between-cache-misses
      0.78           -26.3%       0.58        perf-stat.overall.ipc
   1417447            +4.2%    1476964        perf-stat.overall.path-length
 8.811e+10           -25.3%  6.586e+10        perf-stat.ps.branch-instructions
  79203636           +11.0%   87942785        perf-stat.ps.branch-misses
 6.723e+08           -17.1%  5.573e+08        perf-stat.ps.cache-misses
 9.515e+08            -4.0%   9.13e+08        perf-stat.ps.cache-references
     13283           -25.6%       9881        perf-stat.ps.context-switches
    588.01           -21.3%     462.55        perf-stat.ps.cpu-migrations
 4.298e+11           -25.8%  3.187e+11        perf-stat.ps.instructions
 1.303e+14           -25.9%  9.654e+13        perf-stat.total.instructions
  18763712           +20.8%   22665007        sched_debug.cfs_rq:/.avg_vruntime.avg
  19177877           +20.6%   23132509        sched_debug.cfs_rq:/.avg_vruntime.max
  12561346 ±  4%     +38.8%   17432101 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.min
      0.41           -23.4%       0.31 ±  9%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.41           -23.5%       0.31 ±  9%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   3756224 ± 10%     -49.2%    1907836 ± 24%  sched_debug.cfs_rq:/.left_deadline.avg
  19102630           +20.2%   22961855        sched_debug.cfs_rq:/.left_deadline.max
   7394146 ±  4%     -19.1%    5981443 ± 13%  sched_debug.cfs_rq:/.left_deadline.stddev
   3756166 ± 10%     -49.2%    1907812 ± 24%  sched_debug.cfs_rq:/.left_vruntime.avg
  19102358           +20.2%   22961566        sched_debug.cfs_rq:/.left_vruntime.max
   7394032 ±  4%     -19.1%    5981369 ± 13%  sched_debug.cfs_rq:/.left_vruntime.stddev
    183320 ±  9%     -55.7%      81133 ± 22%  sched_debug.cfs_rq:/.load.avg
    349269 ±  4%     -31.7%     238535 ± 14%  sched_debug.cfs_rq:/.load.stddev
    285.14 ±  2%     -36.9%     179.94 ±  8%  sched_debug.cfs_rq:/.load_avg.avg
    735.94 ± 16%     -25.1%     551.17 ± 14%  sched_debug.cfs_rq:/.load_avg.max
     97.19 ± 20%     -49.5%      49.10 ± 29%  sched_debug.cfs_rq:/.load_avg.min
  18763745           +20.8%   22665021        sched_debug.cfs_rq:/.min_vruntime.avg
  19177908           +20.6%   23132531        sched_debug.cfs_rq:/.min_vruntime.max
  12561401 ±  4%     +38.8%   17432110 ±  4%  sched_debug.cfs_rq:/.min_vruntime.min
      1.01            -9.6%       0.92        sched_debug.cfs_rq:/.nr_queued.avg
      0.37 ±  4%     -28.2%       0.27 ± 11%  sched_debug.cfs_rq:/.nr_queued.stddev
   3756166 ± 10%     -49.2%    1907812 ± 24%  sched_debug.cfs_rq:/.right_vruntime.avg
  19102358           +20.2%   22961566        sched_debug.cfs_rq:/.right_vruntime.max
   7394033 ±  4%     -19.1%    5981369 ± 13%  sched_debug.cfs_rq:/.right_vruntime.stddev
      1161            -8.9%       1058        sched_debug.cfs_rq:/.runnable_avg.avg
    186.73 ±  6%     -15.0%     158.66 ±  7%  sched_debug.cfs_rq:/.runnable_avg.stddev
    106.71 ±  6%     -25.2%      79.79 ± 14%  sched_debug.cfs_rq:/.util_avg.stddev
     35.71 ±  8%     -21.6%      28.01 ± 14%  sched_debug.cpu.clock.stddev
      1284 ±  7%     -11.2%       1140        sched_debug.cpu.clock_task.stddev
      4431 ±  2%     +12.4%       4979        sched_debug.cpu.curr->pid.avg
    170.56 ± 36%     +88.2%     320.94 ± 21%  sched_debug.cpu.curr->pid.min
      2055 ±  4%     -28.7%       1465 ±  9%  sched_debug.cpu.curr->pid.stddev
      0.40 ±  2%     -23.5%       0.31 ±  9%  sched_debug.cpu.nr_running.stddev
     11614           -22.8%       8967        sched_debug.cpu.nr_switches.avg
      9169           -27.3%       6668        sched_debug.cpu.nr_switches.min
      0.00           -50.0%       0.00        sched_debug.rt_rq:.rt_nr_running.avg
      0.33           -50.0%       0.17        sched_debug.rt_rq:.rt_nr_running.max
      0.02           -50.0%       0.01        sched_debug.rt_rq:.rt_nr_running.stddev
      0.23 ± 18%     -32.0%       0.16 ± 18%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      8.07 ±  4%     -17.4%       6.67 ± 13%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.11 ±  6%     -17.7%       6.67 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      8.20 ±  4%     -17.8%       6.74 ± 11%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      8.47 ±  5%     -20.1%       6.77 ± 11%  perf-sched.sch_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      7.23 ±  5%     -27.4%       5.25 ± 12%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.18 ± 66%     -59.3%       0.48 ± 53%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.35 ± 12%     -17.4%       0.29 ±  8%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3.97 ±  4%     -19.3%       3.21 ± 10%  perf-sched.total_sch_delay.average.ms
     44.41 ±  2%     +24.3%      55.21 ±  4%  perf-sched.total_wait_and_delay.average.ms
     68566 ±  2%     -21.4%      53890 ±  4%  perf-sched.total_wait_and_delay.count.ms
     40.44 ±  2%     +28.6%      52.00 ±  4%  perf-sched.total_wait_time.average.ms
     16.15 ±  4%     -17.4%      13.34 ± 13%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
     16.23 ±  6%     -17.7%      13.35 ± 12%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
     16.40 ±  4%     -17.8%      13.48 ± 11%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
     29.14 ±  6%     +50.5%      43.86 ± 10%  perf-sched.wait_and_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     16.95 ±  5%     -20.1%      13.54 ± 11%  perf-sched.wait_and_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
     15.28 ±  5%     -22.0%      11.93 ± 11%  perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     56.71 ±  3%     +46.8%      83.27 ±  3%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1275 ±  4%     -50.3%     633.38 ±  6%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1472 ±  5%     -45.4%     803.12 ±  6%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      1108 ±  5%     -53.8%     512.50 ±  3%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
    963.00 ±  6%     -56.6%     417.75 ±  2%  perf-sched.wait_and_delay.count.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1648 ±  9%     -36.0%       1054 ± 12%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     14703 ±  3%      +9.8%      16150 ±  4%  perf-sched.wait_and_delay.count.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
    981.62 ±  7%     -59.1%     401.75 ± 12%  perf-sched.wait_and_delay.count.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
     10834 ±  3%     -43.1%       6168 ±  7%  perf-sched.wait_and_delay.count.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1849 ±  9%     -44.2%       1031 ± 28%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
     27173 ±  3%     -26.2%      20048 ±  4%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      8.07 ±  4%     -17.4%       6.67 ± 13%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.11 ±  6%     -17.7%       6.67 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      8.20 ±  4%     -17.8%       6.74 ± 11%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
     29.08 ±  6%     +50.5%      43.77 ± 10%  perf-sched.wait_time.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      8.47 ±  5%     -20.1%       6.77 ± 11%  perf-sched.wait_time.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.20 ±  7%     +70.5%       0.34 ± 52%  perf-sched.wait_time.avg.ms.ipmi_thread.kthread.ret_from_fork.ret_from_fork_asm
      6.87 ± 64%     -43.0%       3.92 ± 15%  perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     56.55 ±  3%     +47.0%      83.13 ±  3%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2244 ± 68%     -90.2%     220.55 ±222%  perf-sched.wait_time.max.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.20          +128.0%       0.47 ± 74%  perf-sched.wait_time.max.ms.ipmi_thread.kthread.ret_from_fork.ret_from_fork_asm
     20.21 ±  2%     -18.7        1.50 ± 31%  perf-profile.calltrace.cycles-pp.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     25.94           -14.7       11.25 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
     28.93           -11.2       17.70 ±  3%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
     29.02           -11.2       17.82 ±  3%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
     29.02           -11.2       17.82 ±  3%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
     29.02           -11.2       17.82 ±  3%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
     29.00           -11.2       17.80 ±  3%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     28.98           -11.2       17.79 ±  3%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
     28.98           -11.2       17.79 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
     28.98           -11.2       17.79 ±  3%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      9.79 ±  2%      -9.8        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch.rcu_core
      9.58 ±  2%      -9.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.kmem_cache_free.rcu_do_batch
     12.03            -7.3        4.71        perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.76 ±  2%      -5.8        0.00        perf-profile.calltrace.cycles-pp.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
      5.60 ±  2%      -5.6        0.00        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      5.79 ±  2%      -5.4        0.38 ± 57%  perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      5.40 ±  2%      -5.4        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch.rcu_core
      5.33 ±  2%      -5.3        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.rcu_do_batch
      5.00 ±  2%      -5.0        0.00        perf-profile.calltrace.cycles-pp.___slab_alloc.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_store_gfp.do_vmi_align_munmap
     12.46            -4.9        7.56        perf-profile.calltrace.cycles-pp.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      9.07            -4.3        4.80        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.59            -2.7        3.86        perf-profile.calltrace.cycles-pp.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.14            -2.5        2.65        perf-profile.calltrace.cycles-pp.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      5.90            -2.4        3.49        perf-profile.calltrace.cycles-pp.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk.do_syscall_64
      4.67            -1.9        2.80        perf-profile.calltrace.cycles-pp.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      3.03            -1.5        1.57        perf-profile.calltrace.cycles-pp.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      3.18            -1.4        1.80        perf-profile.calltrace.cycles-pp.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.32            -1.4        3.97        perf-profile.calltrace.cycles-pp.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      5.03            -1.2        3.80        perf-profile.calltrace.cycles-pp.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      4.41            -1.2        3.21        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      2.38            -1.2        1.23        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.58            -1.1        1.47        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk.do_syscall_64
      2.84            -1.1        1.77        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.brk
      2.15            -1.0        1.14        perf-profile.calltrace.cycles-pp.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      2.17            -0.9        1.23        perf-profile.calltrace.cycles-pp.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      2.24            -0.8        1.40        perf-profile.calltrace.cycles-pp.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      1.88            -0.8        1.08        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      4.07            -0.8        3.28        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma.vms_gather_munmap_vmas
      1.65            -0.8        0.87        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.54            -0.8        0.78        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes.vms_complete_munmap_vmas
      1.64 ±  4%      -0.7        0.90 ±  3%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.87 ±  2%      -0.7        1.19        perf-profile.calltrace.cycles-pp.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.05 ±  7%      -0.6        0.48 ± 37%  perf-profile.calltrace.cycles-pp.__memcg_slab_free_hook.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.11            -0.6        0.56        perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.unmap_vmas.vms_clear_ptes
      1.20            -0.5        0.65        perf-profile.calltrace.cycles-pp.mas_preallocate.commit_merge.vma_expand.vma_merge_new_range.do_brk_flags
      1.24            -0.5        0.72        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      1.29            -0.5        0.78        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      1.05            -0.5        0.54        perf-profile.calltrace.cycles-pp.free_pgtables.vms_clear_ptes.vms_complete_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      1.10            -0.5        0.64        perf-profile.calltrace.cycles-pp.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      1.13            -0.5        0.67 ±  2%  perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.do_brk_flags.__do_sys_brk
      0.98            -0.4        0.56        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      0.96            -0.4        0.55        perf-profile.calltrace.cycles-pp.__get_unmapped_area.check_brk_limits.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.93            -0.4        0.52        perf-profile.calltrace.cycles-pp.__vma_start_write.vma_expand.vma_merge_new_range.do_brk_flags.__do_sys_brk
      0.97            -0.4        0.58 ±  2%  perf-profile.calltrace.cycles-pp.security_vm_enough_memory_mm.do_brk_flags.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.76 ±  4%      -0.3        0.46 ± 37%  perf-profile.calltrace.cycles-pp.mas_put_in_tree.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      0.79            -0.2        0.55        perf-profile.calltrace.cycles-pp.mas_update_gap.mas_store_prealloc.commit_merge.vma_expand.vma_merge_new_range
      1.19 ±  2%      +0.1        1.26 ±  2%  perf-profile.calltrace.cycles-pp.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.__do_sys_brk
      0.63 ±  3%      +0.2        0.84 ±  3%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      1.19            +0.2        1.42 ±  2%  perf-profile.calltrace.cycles-pp.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.vma_complete.__split_vma
      0.58 ±  2%      +0.4        0.95 ±  3%  perf-profile.calltrace.cycles-pp.rcu_segcblist_enqueue.__call_rcu_common.mas_wr_node_store.mas_store_prealloc.vma_complete
      0.00            +0.6        0.60 ±  7%  perf-profile.calltrace.cycles-pp.build_detached_freelist.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +0.7        0.66 ±  3%  perf-profile.calltrace.cycles-pp.shuffle_freelist.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      1.05 ± 38%      +0.8        1.90 ± 10%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc
      0.00            +0.9        0.85 ±  7%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.9        0.85 ±  7%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf
      0.00            +0.9        0.86 ±  7%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.9        0.86 ±  7%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.48 ±  4%      +0.9        2.38 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      0.00            +0.9        0.94 ±  3%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main
      0.00            +0.9        0.94 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +0.9        0.94 ±  4%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main
      0.00            +0.9        0.94 ±  4%  perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf
      0.00            +1.0        0.97 ±  3%  perf-profile.calltrace.cycles-pp.allocate_slab.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.0        0.99 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +1.0        0.99 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +1.0        0.99 ±  4%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +1.0        1.00 ±  4%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      1.56 ±  4%      +1.2        2.72 ±  4%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
      1.56 ±  4%      +1.2        2.73 ±  4%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +1.3        1.26 ±  5%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free
      0.00            +1.3        1.32 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +1.4        1.35 ±  5%  perf-profile.calltrace.cycles-pp.barn_replace_full_sheaf.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      0.00            +1.8        1.80 ±  8%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +1.8        1.81 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +1.9        1.91 ±  6%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +1.9        1.91 ± 11%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk
      0.00            +1.9        1.94 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +2.0        2.04 ±  6%  perf-profile.calltrace.cycles-pp.__put_partials.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +2.2        2.19 ±  9%  perf-profile.calltrace.cycles-pp.get_partial_node.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +2.2        2.25 ± 11%  perf-profile.calltrace.cycles-pp.get_partial_node.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main
      0.00            +2.3        2.29 ± 11%  perf-profile.calltrace.cycles-pp.get_any_partial.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +2.9        2.86 ±  3%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main
      0.00            +3.0        3.05 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free
      0.00            +3.2        3.18 ±  4%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00            +3.2        3.20 ±  4%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      2.85 ±  4%      +3.4        6.24 ±  7%  perf-profile.calltrace.cycles-pp.rcu_cblist_dequeue.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.00            +4.2        4.25 ±  4%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +4.3        4.33 ±  4%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch
      0.00            +5.7        5.74 ±  7%  perf-profile.calltrace.cycles-pp.___slab_alloc.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00            +6.6        6.61 ±  7%  perf-profile.calltrace.cycles-pp.__kmem_cache_alloc_bulk.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00            +7.2        7.17 ±  3%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core
      0.00            +8.6        8.59 ±  2%  perf-profile.calltrace.cycles-pp.__pcs_replace_full_main.kmem_cache_free.rcu_do_batch.rcu_core.handle_softirqs
     69.96           +11.0       80.97        perf-profile.calltrace.cycles-pp.brk
     66.66           +12.8       79.49        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.brk
     66.38           +12.9       79.32        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     64.51           +13.8       78.28        perf-profile.calltrace.cycles-pp.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
      0.00           +15.7       15.74        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +15.9       15.86        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +16.0       15.98        perf-profile.calltrace.cycles-pp.barn_put_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
      0.00           +16.5       16.48        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      0.00           +16.5       16.52        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes
      0.00           +17.8       17.76        perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate
     45.44           +21.7       67.10        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe.brk
     23.17           +33.8       56.96        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64.entry_SYSCALL_64_after_hwframe
     18.02           +36.0       54.00        perf-profile.calltrace.cycles-pp.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk.do_syscall_64
      7.17           +39.7       46.84        perf-profile.calltrace.cycles-pp.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap.__do_sys_brk
      5.87 ±  2%     +40.3       46.15        perf-profile.calltrace.cycles-pp.mas_alloc_nodes.mas_preallocate.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      5.63 ±  2%     +40.4       45.99        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma.vms_gather_munmap_vmas
      0.00           +45.6       45.62        perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
     36.48           -19.1       17.36        perf-profile.children.cycles-pp.kmem_cache_free
     25.78           -18.5        7.23        perf-profile.children.cycles-pp.__slab_free
     38.44           -13.7       24.73        perf-profile.children.cycles-pp.handle_softirqs
     38.42           -13.7       24.72        perf-profile.children.cycles-pp.rcu_core
     38.40           -13.7       24.71        perf-profile.children.cycles-pp.rcu_do_batch
     29.02           -11.2       17.82 ±  3%  perf-profile.children.cycles-pp.kthread
     29.02           -11.2       17.82 ±  3%  perf-profile.children.cycles-pp.ret_from_fork
     29.02           -11.2       17.82 ±  3%  perf-profile.children.cycles-pp.ret_from_fork_asm
     29.00           -11.2       17.80 ±  3%  perf-profile.children.cycles-pp.smpboot_thread_fn
     28.98           -11.2       17.79 ±  3%  perf-profile.children.cycles-pp.run_ksoftirqd
     13.47            -7.9        5.58        perf-profile.children.cycles-pp.mas_store_gfp
     12.59            -5.0        7.61        perf-profile.children.cycles-pp.do_brk_flags
      8.38 ±  2%      -4.7        3.63 ±  8%  perf-profile.children.cycles-pp.__put_partials
      9.16            -4.3        4.86        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      9.89 ±  2%      -4.2        5.74 ±  7%  perf-profile.children.cycles-pp.___slab_alloc
     10.12 ±  2%      -2.8        7.33 ±  4%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     10.08 ±  2%      -2.8        7.29 ±  4%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      6.65            -2.8        3.89        perf-profile.children.cycles-pp.vma_merge_new_range
      5.20            -2.5        2.69        perf-profile.children.cycles-pp.vms_clear_ptes
      9.44 ±  2%      -2.5        6.94 ±  4%  perf-profile.children.cycles-pp.__irq_exit_rcu
      5.93            -2.4        3.51        perf-profile.children.cycles-pp.vma_expand
      4.49            -2.1        2.37        perf-profile.children.cycles-pp.mas_find
      7.36            -2.1        5.26        perf-profile.children.cycles-pp.mas_store_prealloc
      8.74            -2.1        6.65        perf-profile.children.cycles-pp.mas_wr_node_store
      4.82            -1.9        2.88        perf-profile.children.cycles-pp.commit_merge
      6.30 ±  4%      -1.9        4.44 ± 10%  perf-profile.children.cycles-pp.get_partial_node
      2.46 ±  2%      -1.5        0.97 ±  3%  perf-profile.children.cycles-pp.allocate_slab
      3.10            -1.5        1.61        perf-profile.children.cycles-pp.unmap_vmas
      5.63            -1.4        4.20        perf-profile.children.cycles-pp.vma_complete
      3.21            -1.4        1.82        perf-profile.children.cycles-pp.perf_event_mmap
      2.18 ±  2%      -1.3        0.86 ±  3%  perf-profile.children.cycles-pp.shuffle_freelist
      2.43            -1.2        1.26        perf-profile.children.cycles-pp.unmap_page_range
      2.71            -1.2        1.54        perf-profile.children.cycles-pp.perf_event_mmap_event
      2.85            -1.1        1.75        perf-profile.children.cycles-pp.__vma_start_write
      2.03            -1.0        1.07        perf-profile.children.cycles-pp.mas_walk
      2.22            -1.0        1.26        perf-profile.children.cycles-pp.vm_area_dup
      2.09            -0.9        1.15        perf-profile.children.cycles-pp.mas_wr_store_type
      2.09            -0.8        1.29        perf-profile.children.cycles-pp.mas_update_gap
      1.58            -0.8        0.80        perf-profile.children.cycles-pp.zap_pmd_range
      1.67            -0.6        1.05        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.35            -0.6        0.75        perf-profile.children.cycles-pp.mas_prev_slot
      1.37            -0.6        0.78 ±  3%  perf-profile.children.cycles-pp.__pi_memcpy
      1.16            -0.6        0.58        perf-profile.children.cycles-pp.zap_pte_range
      1.18            -0.6        0.61        perf-profile.children.cycles-pp.mas_next_slot
      1.15            -0.6        0.60        perf-profile.children.cycles-pp.free_pgtables
      1.27            -0.5        0.74        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      1.48            -0.5        0.95        perf-profile.children.cycles-pp.mas_leaf_max_gap
      1.08 ±  7%      -0.5        0.56 ±  5%  perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.81 ±  2%      -0.5        0.30 ±  3%  perf-profile.children.cycles-pp.setup_object
      1.19            -0.5        0.70 ±  2%  perf-profile.children.cycles-pp.perf_iterate_sb
      1.07            -0.5        0.59        perf-profile.children.cycles-pp.__cond_resched
      1.14            -0.5        0.66        perf-profile.children.cycles-pp.check_brk_limits
      1.09            -0.4        0.66        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.99            -0.4        0.57        perf-profile.children.cycles-pp.__get_unmapped_area
      0.93            -0.4        0.52        perf-profile.children.cycles-pp.down_write_killable
      1.12 ±  2%      -0.3        0.80        perf-profile.children.cycles-pp.mas_pop_node
      1.05 ±  3%      -0.3        0.73        perf-profile.children.cycles-pp.mas_put_in_tree
      0.70            -0.3        0.38        perf-profile.children.cycles-pp.init_multi_vma_prep
      0.77            -0.3        0.47        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.58            -0.3        0.29        perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.66 ±  5%      -0.3        0.37 ±  4%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.65 ±  4%      -0.3        0.37 ±  4%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.56            -0.3        0.30        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.55 ±  4%      -0.3        0.30 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.54 ±  4%      -0.3        0.29 ±  3%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.56            -0.2        0.31        perf-profile.children.cycles-pp.rcu_all_qs
      0.48            -0.2        0.24 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.52 ±  4%      -0.2        0.28 ±  3%  perf-profile.children.cycles-pp.update_process_times
      0.52            -0.2        0.30        perf-profile.children.cycles-pp.up_read
      0.52            -0.2        0.30 ±  2%  perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.45            -0.2        0.24        perf-profile.children.cycles-pp.mas_prev_setup
      0.39            -0.2        0.20        perf-profile.children.cycles-pp.can_vma_merge_left
      0.51            -0.2        0.32 ±  2%  perf-profile.children.cycles-pp.mas_destroy
      0.44            -0.2        0.25 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_output
      0.39            -0.2        0.22        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.36            -0.2        0.20 ±  2%  perf-profile.children.cycles-pp.sized_strscpy
      0.34            -0.2        0.18 ±  2%  perf-profile.children.cycles-pp.vma_adjust_trans_huge
      0.37 ±  2%      -0.2        0.21 ±  2%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.30            -0.2        0.14 ±  3%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.26            -0.2        0.10 ±  5%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.35            -0.2        0.20        perf-profile.children.cycles-pp.refill_obj_stock
      0.37 ±  3%      -0.2        0.22 ±  4%  perf-profile.children.cycles-pp.sched_tick
      0.24 ±  2%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.24 ±  2%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.47            -0.1        0.32        perf-profile.children.cycles-pp.static_key_count
      0.32            -0.1        0.17        perf-profile.children.cycles-pp.kfree
      0.31 ±  2%      -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.__vm_enough_memory
      0.30            -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.vma_mark_detached
      0.30            -0.1        0.16 ±  3%  perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.30            -0.1        0.17        perf-profile.children.cycles-pp.__account_obj_stock
      0.24 ±  4%      -0.1        0.12 ±  2%  perf-profile.children.cycles-pp.__free_frozen_pages
      0.28            -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.x64_sys_call
      0.29            -0.1        0.17        perf-profile.children.cycles-pp.up_write
      0.30            -0.1        0.18        perf-profile.children.cycles-pp.downgrade_write
      0.46            -0.1        0.34        perf-profile.children.cycles-pp.mas_prev_range
      0.28            -0.1        0.17 ±  2%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.25            -0.1        0.13 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock
      0.26            -0.1        0.15 ±  2%  perf-profile.children.cycles-pp.mas_wr_slot_store
      0.24            -0.1        0.13 ±  2%  perf-profile.children.cycles-pp.vm_area_free
      0.24            -0.1        0.13 ±  3%  perf-profile.children.cycles-pp.remove_vma
      0.28            -0.1        0.18        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.28 ±  2%      -0.1        0.18 ±  3%  perf-profile.children.cycles-pp.may_expand_vm
      0.23 ±  2%      -0.1        0.13        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.18 ±  5%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.free_frozen_page_commit
      0.15 ±  2%      -0.1        0.06 ±  5%  perf-profile.children.cycles-pp.rmqueue
      0.16 ±  6%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.19            -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.vm_area_init_from
      0.19 ±  2%      -0.1        0.10 ±  3%  perf-profile.children.cycles-pp.strnlen
      0.16 ±  3%      -0.1        0.08 ±  5%  perf-profile.children.cycles-pp.unlink_anon_vmas
      0.17            -0.1        0.09        perf-profile.children.cycles-pp.unmap_single_vma
      0.15 ±  2%      -0.1        0.07        perf-profile.children.cycles-pp.___pte_offset_map
      0.16            -0.1        0.08        perf-profile.children.cycles-pp.security_mmap_addr
      0.17            -0.1        0.09        perf-profile.children.cycles-pp.free_pgd_range
      0.17            -0.1        0.09        perf-profile.children.cycles-pp.vma_prepare
      0.13 ±  2%      -0.1        0.05        perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.17 ±  2%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.strlen
      0.12 ±  2%      -0.1        0.04 ± 37%  perf-profile.children.cycles-pp.rmqueue_bulk
      0.14 ±  3%      -0.1        0.07 ±  5%  perf-profile.children.cycles-pp.anon_vma_clone
      0.14            -0.1        0.07 ±  4%  perf-profile.children.cycles-pp.brk@plt
      0.16 ±  2%      -0.1        0.09 ±  3%  perf-profile.children.cycles-pp.finish_rcuwait
      0.14            -0.1        0.07 ±  6%  perf-profile.children.cycles-pp.is_mergeable_anon_vma
      0.15 ±  5%      -0.1        0.08 ±  7%  perf-profile.children.cycles-pp.cap_capable
      0.16 ±  4%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.task_tick_fair
      0.13 ±  3%      -0.1        0.08 ±  7%  perf-profile.children.cycles-pp.update_rq_clock_task
      0.12            -0.0        0.07        perf-profile.children.cycles-pp.userfaultfd_unmap_prep
      0.10 ±  3%      -0.0        0.05        perf-profile.children.cycles-pp.mas_nomem
      0.14 ±  3%      -0.0        0.09        perf-profile.children.cycles-pp.mas_node_count_gfp
      0.11 ±  3%      -0.0        0.06 ±  6%  perf-profile.children.cycles-pp.khugepaged_enter_vma
      0.11 ±  4%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.update_curr
      0.12            -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.testcase
      0.07 ±  9%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.07            -0.0        0.05        perf-profile.children.cycles-pp.cap_vm_enough_memory
      0.08 ±  9%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.cmd_record
      0.08 ±  9%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.handle_internal_command
      0.08 ±  9%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.main
      0.08 ±  9%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.run_builtin
      0.07 ± 12%      -0.0        0.05 ±  8%  perf-profile.children.cycles-pp.perf_mmap__push
      0.08 ±  5%      -0.0        0.06 ±  5%  perf-profile.children.cycles-pp.call_rcu
      0.06            +0.1        0.11 ±  3%  perf-profile.children.cycles-pp.mt_free_rcu
      0.14 ±  3%      +0.2        0.31 ±  2%  perf-profile.children.cycles-pp.ksm_vma_flags
      2.45            +0.3        2.73 ±  2%  perf-profile.children.cycles-pp.__call_rcu_common
      1.77 ±  8%      +0.5        2.29 ± 11%  perf-profile.children.cycles-pp.get_any_partial
      1.25 ±  2%      +0.6        1.81 ±  2%  perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.7        0.70 ±  6%  perf-profile.children.cycles-pp.build_detached_freelist
      0.00            +1.9        1.92 ±  5%  perf-profile.children.cycles-pp.barn_replace_full_sheaf
      0.00            +4.4        4.40 ±  4%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      3.42 ±  3%      +4.5        7.92 ±  5%  perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.00            +6.6        6.61 ±  7%  perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.00            +8.6        8.60 ±  3%  perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.00           +10.6       10.63        perf-profile.children.cycles-pp.__pcs_replace_full_main
     70.52           +11.3       81.78        perf-profile.children.cycles-pp.brk
     66.77           +12.8       79.57        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     66.50           +12.9       79.41        perf-profile.children.cycles-pp.do_syscall_64
     64.72           +13.7       78.40        perf-profile.children.cycles-pp.__do_sys_brk
      0.00           +16.0       15.98        perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00           +17.8       17.78        perf-profile.children.cycles-pp.barn_get_empty_sheaf
     45.49           +21.6       67.13        perf-profile.children.cycles-pp.do_vmi_align_munmap
     25.36 ±  2%     +23.0       48.39        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     25.79 ±  2%     +23.2       48.98        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     23.37           +33.7       57.07        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
     13.20           +34.3       47.52        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     11.72 ±  2%     +35.0       46.69        perf-profile.children.cycles-pp.mas_alloc_nodes
     18.22           +35.9       54.12        perf-profile.children.cycles-pp.__split_vma
      8.45           +39.1       47.55        perf-profile.children.cycles-pp.mas_preallocate
      0.00           +45.8       45.78        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     12.21 ±  2%      -9.2        3.06 ±  2%  perf-profile.self.cycles-pp.__slab_free
      1.69 ±  2%      -1.0        0.74 ±  3%  perf-profile.self.cycles-pp.shuffle_freelist
      2.32            -0.8        1.47        perf-profile.self.cycles-pp.__vma_start_write
      1.72            -0.8        0.94        perf-profile.self.cycles-pp.mas_walk
      1.52            -0.8        0.76        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      1.75            -0.8        1.00        perf-profile.self.cycles-pp.mas_wr_store_type
      1.75            -0.7        1.07        perf-profile.self.cycles-pp.brk
      1.39            -0.6        0.81        perf-profile.self.cycles-pp.mas_store_prealloc
      0.84 ±  2%      -0.6        0.27 ±  3%  perf-profile.self.cycles-pp.___slab_alloc
      1.49            -0.6        0.91        perf-profile.self.cycles-pp.mas_store_gfp
      1.40 ±  2%      -0.6        0.84 ±  2%  perf-profile.self.cycles-pp.mas_wr_node_store
      1.24            -0.5        0.72        perf-profile.self.cycles-pp.__do_sys_brk
      1.12 ±  2%      -0.5        0.62        perf-profile.self.cycles-pp.mas_preallocate
      1.11            -0.5        0.62        perf-profile.self.cycles-pp.mas_find
      1.13            -0.5        0.64        perf-profile.self.cycles-pp.mas_prev_slot
      1.11            -0.5        0.65 ±  2%  perf-profile.self.cycles-pp.__pi_memcpy
      0.96            -0.4        0.52        perf-profile.self.cycles-pp.mas_next_slot
      1.29            -0.4        0.85        perf-profile.self.cycles-pp.mas_leaf_max_gap
      1.05            -0.4        0.62        perf-profile.self.cycles-pp.do_syscall_64
      0.93            -0.4        0.57        perf-profile.self.cycles-pp.__call_rcu_common
      0.75            -0.3        0.41        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.90            -0.3        0.56        perf-profile.self.cycles-pp.do_brk_flags
      0.79            -0.3        0.46        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.70            -0.3        0.38        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.63 ± 12%      -0.3        0.32 ±  8%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.76            -0.3        0.46        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.66            -0.3        0.37        perf-profile.self.cycles-pp.unmap_page_range
      0.93 ±  2%      -0.3        0.66        perf-profile.self.cycles-pp.mas_pop_node
      0.60            -0.3        0.34        perf-profile.self.cycles-pp.init_multi_vma_prep
      0.61            -0.3        0.36        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.68 ±  2%      -0.3        0.42 ±  3%  perf-profile.self.cycles-pp.perf_iterate_sb
      0.56            -0.2        0.31        perf-profile.self.cycles-pp.down_write_killable
      0.88 ±  4%      -0.2        0.64 ±  2%  perf-profile.self.cycles-pp.mas_put_in_tree
      0.54            -0.2        0.30        perf-profile.self.cycles-pp.__split_vma
      0.52            -0.2        0.30        perf-profile.self.cycles-pp.__cond_resched
      0.53            -0.2        0.32        perf-profile.self.cycles-pp.mas_update_gap
      0.43            -0.2        0.22        perf-profile.self.cycles-pp.zap_pte_range
      0.45            -0.2        0.25        perf-profile.self.cycles-pp.mas_wr_store_entry
      0.44            -0.2        0.25        perf-profile.self.cycles-pp.perf_event_mmap
      0.27 ±  2%      -0.2        0.08 ±  5%  perf-profile.self.cycles-pp.setup_object
      0.44            -0.2        0.25        perf-profile.self.cycles-pp.commit_merge
      0.44            -0.2        0.27        perf-profile.self.cycles-pp.up_read
      0.41            -0.2        0.24 ±  2%  perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.39            -0.2        0.23        perf-profile.self.cycles-pp.mas_alloc_nodes
      0.42            -0.2        0.26        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.40            -0.2        0.25        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.32            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.mas_prev_setup
      0.27            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.vms_clear_ptes
      0.32            -0.1        0.18        perf-profile.self.cycles-pp.rcu_all_qs
      0.35            -0.1        0.21 ±  2%  perf-profile.self.cycles-pp.perf_event_mmap_output
      0.34            -0.1        0.20        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.32            -0.1        0.18 ±  2%  perf-profile.self.cycles-pp.free_pgtables
      0.44            -0.1        0.31        perf-profile.self.cycles-pp.vma_complete
      0.32            -0.1        0.19 ±  2%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.28            -0.1        0.15        perf-profile.self.cycles-pp.vma_adjust_trans_huge
      0.29            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.sized_strscpy
      0.24            -0.1        0.12        perf-profile.self.cycles-pp.tlb_gather_mmu
      0.26            -0.1        0.14 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
      0.37            -0.1        0.25 ±  2%  perf-profile.self.cycles-pp.mas_destroy
      0.29            -0.1        0.17        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.26            -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.zap_pmd_range
      0.23            -0.1        0.12        perf-profile.self.cycles-pp.mas_prev
      0.27            -0.1        0.16 ±  2%  perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.22 ±  2%      -0.1        0.11        perf-profile.self.cycles-pp.can_vma_merge_left
      0.23 ±  2%      -0.1        0.13        perf-profile.self.cycles-pp.x64_sys_call
      0.24            -0.1        0.14 ±  2%  perf-profile.self.cycles-pp.kfree
      0.19            -0.1        0.09 ±  3%  perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.24            -0.1        0.14        perf-profile.self.cycles-pp.up_write
      0.24 ±  2%      -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.vma_mark_detached
      0.22            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.vma_merge_new_range
      0.23 ±  2%      -0.1        0.14 ±  2%  perf-profile.self.cycles-pp.__account_obj_stock
      0.24 ±  2%      -0.1        0.15 ±  2%  perf-profile.self.cycles-pp.downgrade_write
      0.22            -0.1        0.13 ±  3%  perf-profile.self.cycles-pp.mas_wr_slot_store
      0.22            -0.1        0.13        perf-profile.self.cycles-pp.percpu_counter_add_batch
      0.23 ±  2%      -0.1        0.14        perf-profile.self.cycles-pp.__get_unmapped_area
      0.19            -0.1        0.11 ±  3%  perf-profile.self.cycles-pp._raw_spin_lock
      0.16            -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.__put_partials
      0.22 ±  2%      -0.1        0.14 ±  3%  perf-profile.self.cycles-pp.may_expand_vm
      0.18 ±  2%      -0.1        0.10 ±  4%  perf-profile.self.cycles-pp.refill_obj_stock
      0.18 ±  2%      -0.1        0.10 ±  3%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.17 ±  2%      -0.1        0.10        perf-profile.self.cycles-pp.obj_cgroup_charge_account
      0.19            -0.1        0.12        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.15            -0.1        0.08 ±  5%  perf-profile.self.cycles-pp.strnlen
      0.14            -0.1        0.08 ±  6%  perf-profile.self.cycles-pp.free_pgd_range
      0.15            -0.1        0.09 ±  4%  perf-profile.self.cycles-pp.vm_area_init_from
      0.12 ±  2%      -0.1        0.06        perf-profile.self.cycles-pp.unlink_anon_vmas
      0.30            -0.1        0.24        perf-profile.self.cycles-pp.static_key_count
      0.14            -0.1        0.08        perf-profile.self.cycles-pp.strlen
      0.12            -0.1        0.06        perf-profile.self.cycles-pp.___pte_offset_map
      0.15            -0.1        0.09        perf-profile.self.cycles-pp.vma_expand
      0.13            -0.1        0.07 ±  4%  perf-profile.self.cycles-pp.unmap_single_vma
      0.12 ±  4%      -0.1        0.07        perf-profile.self.cycles-pp.__vm_enough_memory
      0.11 ±  4%      -0.1        0.06        perf-profile.self.cycles-pp.anon_vma_clone
      0.13 ±  3%      -0.1        0.08 ±  4%  perf-profile.self.cycles-pp.update_rq_clock_task
      0.12 ±  3%      -0.1        0.07 ±  5%  perf-profile.self.cycles-pp.finish_rcuwait
      0.11            -0.1        0.06        perf-profile.self.cycles-pp.is_mergeable_anon_vma
      0.11            -0.1        0.06        perf-profile.self.cycles-pp.vma_prepare
      0.13 ±  2%      -0.0        0.08        perf-profile.self.cycles-pp.check_brk_limits
      0.12 ±  4%      -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.cap_capable
      0.11            -0.0        0.07 ±  6%  perf-profile.self.cycles-pp.vm_area_dup
      0.11 ±  3%      -0.0        0.07 ±  8%  perf-profile.self.cycles-pp.get_partial_node
      0.09            -0.0        0.05        perf-profile.self.cycles-pp.security_mmap_addr
      0.09 ±  5%      -0.0        0.06 ±  5%  perf-profile.self.cycles-pp.testcase
      0.10            -0.0        0.07 ±  4%  perf-profile.self.cycles-pp.mas_node_count_gfp
      0.08 ±  4%      -0.0        0.05        perf-profile.self.cycles-pp.remove_vma
      0.08 ±  4%      -0.0        0.05        perf-profile.self.cycles-pp.userfaultfd_unmap_prep
      0.22            -0.0        0.21        perf-profile.self.cycles-pp.mas_prev_range
      0.00            +0.1        0.08 ±  8%  perf-profile.self.cycles-pp.__pcs_replace_full_main
      0.00            +0.1        0.12        perf-profile.self.cycles-pp.barn_put_empty_sheaf
      0.11            +0.1        0.24 ±  2%  perf-profile.self.cycles-pp.ksm_vma_flags
      0.43 ±  2%      +0.2        0.59 ±  2%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.00            +0.2        0.16 ±  7%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
      0.16 ±  2%      +0.2        0.32 ±  3%  perf-profile.self.cycles-pp.rcu_do_batch
      0.00            +0.2        0.19 ±  4%  perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.00            +0.2        0.25        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      1.20 ±  2%      +0.6        1.79 ±  2%  perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.00            +0.7        0.70 ±  6%  perf-profile.self.cycles-pp.build_detached_freelist
      0.00            +0.8        0.82 ±  4%  perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      1.27            +1.7        2.93 ±  3%  perf-profile.self.cycles-pp.kmem_cache_free
      3.38 ±  3%      +4.5        7.87 ±  5%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
     25.36 ±  2%     +23.0       48.39        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


