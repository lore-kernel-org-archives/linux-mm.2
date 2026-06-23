Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3FFCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 22:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943DF6B0088; Tue, 23 Jun 2026 18:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F58A6B008A; Tue, 23 Jun 2026 18:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7955E6B008C; Tue, 23 Jun 2026 18:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6CF6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F349C0727
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:01:39 +0000 (UTC)
X-FDA: 84912549918.02.D9DD0F6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F448120010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:01:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fMbqykhS;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782252096;
	b=XyD8JAjE7PnNIcaPucbBAvSYD30F9PkR3v7Mao0fosTB/R2vHqiy9ZlzA5HWGcI9D+d/C5
	Eyg4qV8Uwh5Nq2XghwnPYU2n+1gyz+gOmSgZrXeCQk2QaKLRu7EPf2K1ckGfeZKaqSRAhe
	p2YoH7d+s5TOgu0en2colilfPlY0Yus=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782252096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fP1Of4V5jy1IVJWH3iiXFbevbXf32Ihh18gJ6Ek2lw=;
	b=3TRL0vg6HFtvcAZB0I7ibZ5MoUxAEHjPddcSVt75onboN30dOz+B98PeSjEEpSVH+6nPcQ
	qsZvPyQeQSHy3cpj7gibjUqIJBJ8Lrb28ImxU6gD3ceoiAlynFWYmqlLKTAiLYuUNrvHFd
	Tsij1xLUH5jqW/C5uclo3Ts0DbCi4Gk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fMbqykhS;
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782252095; x=1813788095;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=SfOf8e6QeJjL3KY8KuN4+0PAnaWge6uLOT8rtG+sSts=;
  b=fMbqykhS4a+4hkN6ev0LrnexQ78hSO2dTqn8H3UYF9WsVvEw3uSztuDl
   eFCpznN5IfrASa0ExTH5yZCPIMVzcRaPgKmyUhuR0gC9jPliAZgLLp1zD
   vpyFeNBtvTiibrlX33Tsl8wv2Xg0iQ6NP39JRDfh5yL7E30v1xvYOwGRe
   UeHI7R5e8JgjOEawkkQDiwEhndYzy46emo3gGEbmNwcwLo3AY6LBqKzww
   aPAtDgmSNT/Ot0ODw5XEa0jXWKf47oJkPN9J2NxjJ3w4OXybFBPhBky2c
   OCpndBkteFaRp2QKdwBXhgbbE1idc/ltlit6hRfFULK7dqNigmOqEhHeI
   Q==;
X-CSE-ConnectionGUID: QvKT2+exTeaodJ0SBSFmOQ==
X-CSE-MsgGUID: 1U2jNCycTwmLSFN8ThwwPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="82114799"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="82114799"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 15:01:34 -0700
X-CSE-ConnectionGUID: u/gKTqbfQ96CA3DIIbl3kg==
X-CSE-MsgGUID: 2z8t9P+jTDOCUzzqgymd7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="273706469"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 15:01:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 15:01:32 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 23 Jun 2026 15:01:32 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.14) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 23 Jun 2026 15:01:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w8j90xAnI1Cj+sr4itKw4JTLgHWeFiLmQcAtSxHWcI02r38A64fu7qRj9+K3v0Yxv+KsHekDugOc9Or1F04iXqhwXzzIexymZeuezWdKGwZ1vgV/EGUJ43D9CMwTNVosFFnDYTh3ThjX5nhfUnHiQ3yPVhRtWu4T77r7uMroFdJMCw8UI8Kp14ynXGcb0hNlpTfZhIfOcIAJdfnjjyl7wqNiIaZ6mDavLau/snwp/uMYe9CigNli89tJuYlzaF39pPio6AlAEL7oy3xiZCR4UkW/OjTdylMqhAWEv6WwPE0exMRZJ/ocDdvQpE5/wZTp1tFLtqosMPaTAwHQwcirlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fP1Of4V5jy1IVJWH3iiXFbevbXf32Ihh18gJ6Ek2lw=;
 b=x54JoMik7aXkmjuk7L6sG+JwHdNlT5ZSZbXfA8HK1eq5RHSVY8niXRz9ayy0y6qh/4NSQDvyGXbtgMoJlJx+RLmZqc1e6XjFZU2NZvBr+w9MTXAMveAqeHPQqrxahH4FO+YiGuBnKGqQKraxLRebZwuUSQj1+xl1dGMFHOpI0ALA2NAh2ESFdavE11NivFUXSPgIEIlppMR8axh7ryeeZlLCB6tbz976MnowS8IcSBw5VBE2ASHel3MfCth35niu/i8MQ7W4pUbDfNQF7TwaTP0Z1SXLijKcEyBEj/XY6dYhYzmuEQkB9nYbAC3Jgfie8s0DoD6m1Z99pcF4moUebQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS0PR11MB7928.namprd11.prod.outlook.com (2603:10b6:8:fe::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.13; Tue, 23 Jun 2026 22:01:30 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0139.018; Tue, 23 Jun 2026
 22:01:30 +0000
Date: Tue, 23 Jun 2026 15:01:26 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Dave Chinner <dgc@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, "Qi
 Zheng" <zhengqi.arch@bytedance.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH v6 1/2] mm: Introduce opportunistic_compaction concept to
 vmscan and shrinkers
Message-ID: <ajsCNu8mCGVS7ZwB@gsse-cloud1.jf.intel.com>
References: <20260617032218.1165929-1-matthew.brost@intel.com>
 <20260617032218.1165929-2-matthew.brost@intel.com>
 <ajnA83DxAFqeJ-sv@dread>
 <ajnOvdbT5/J6q3IN@gsse-cloud1.jf.intel.com>
 <ajoaikDrKz7JGr5h@dread>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajoaikDrKz7JGr5h@dread>
X-ClientProxiedBy: SJ0PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::27) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS0PR11MB7928:EE_
X-MS-Office365-Filtering-Correlation-Id: 33d40bb0-519f-43c0-4971-08ded172fb01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|5023799004|56012099006|11063799006|6133799003|18002099003|22082099003|3023799007|4143699003;
X-Microsoft-Antispam-Message-Info: 8M4V6vPmC0aRS2QC0onLvzHG2gXIIqllfLmr0ysF3rQ9f/omEquLGNRCw+mA+TAKNvO3PIKVlO+7t0zY3FEQEg+c13/Qsi5XRGwxrfupOfpHlPiEoxHb1fNU+MX1NuSQsNRlZ0yPSe7FEiQSsEdGgmxaYqcgzW3elBynAGqJ3o8Y0mnG+Dzn1Qztevd1LdL7dZHU+8DwUYxFd0kUMa2MPL6wBYOnL2EuFk4NqMYHTfITAdukZXTQD+/+IXVBvaCNWundycnEkKsgJa/jw/eP5OEkwsJ0mlGn12cHSrIEwu8EWdB3eCEKsSHgDm3l8Gz4BSS7Ugx03MUnk1WhMXpqthORoZ+1oXIknK2NX7SwG3p8/RRCP9O6WXqmd53uxaItY4bfW45n14ecwfPehii3JTfwTiRkYHiO2mDGmkHSG1fLNZ4KVmLOjLltwKW//feOTxz0X8yBfBnsGXLRZ48LbtjMINGcP4dg+aaRGpgQ/o0z2BhIP5+4QYii1ECKQ/ZWA9gXC5yfbEc6CR8vMD5NVpdVPE/A604LDnDrzHZ4MSieDUjXymq661LE3WhTfbql0jysAGaiizUaRLBEL1N1Uu8YYmJmz1cizJbFa++31DUl2IuuKR/qhNFDD4kt30ol9iXehvuukdBfpKaqyvj9TOaTn0kwzrZXAOGVsNrZZ14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(5023799004)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003)(3023799007)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHhpaWdVZ2t2dkRReENmYjNWMjAxSDhUaGpwNnc2MTkxOHZHekZyN0g4ZWlp?=
 =?utf-8?B?akVXcjh2dXJiYU9NMFNDbUp1OFpRWEt3c0xQUTVmdXdtL3p5MDlYbGZhZ2p1?=
 =?utf-8?B?QzdzWnFGVWZrZ3Jrd1d2cnpXQkN2Y0RXR1RCUkk2eHM0SVo2ejJ6QllycW02?=
 =?utf-8?B?SVpiMSsybU40d3VoMEt0VFNvclVoUk9JNGNrRUkxaC9ZKzhvK2d6a2dwZ3dD?=
 =?utf-8?B?a24zM21pem55SkRQQWZWaWphTjFFOWZaaDlTOEoveCtOWXdYWlQwbkR0aHR2?=
 =?utf-8?B?R1VkMFJsdWFySHNYY0xoTTk0SmUxeUdpNGVET25id29JMjFzWldoZHd0VUpN?=
 =?utf-8?B?TlJoRHFHeGNOUTRzMDdMWC9CNmxlN2MrZjBXdjkwOUI1M0FlN1BhNkJ3M1Zv?=
 =?utf-8?B?bUZlRHVwdDBsaitRZEcweERPc0t5MzFzNm9YWDAyTWpQZTlCM25ULzZNeWFI?=
 =?utf-8?B?MldLUkt1bGY0MVNLamFxNGhpVTBMaVZuczFrSUsyYnRSWURqbVNYMUJWcHZ2?=
 =?utf-8?B?cStEZG1xcnI5SnUvUjh4Sk1ab1EwS2U2Y0cyTkFJSDlHU3BDdGFLRnV5TWo5?=
 =?utf-8?B?SXQyS2dGY3Era2lxYjJYa3FmWjRYUDlWM1pXMFdGZFE0MVRiNHEwNVZDVG9r?=
 =?utf-8?B?Qmoxd3U4WEhGZlo3ZTAzUHVLS2ZYT3pTaktXb2ZYVmQ2ZVU5Y1JTbS84K3hD?=
 =?utf-8?B?OG94MmtYblVwaUVqRW5ldzNjajNuYjNOOGpJU3VpWHFISWZQUWNZaTZER0FP?=
 =?utf-8?B?Qk9UMGo4ZnozZFQxd3F0K0R0Znk3KzdLaHJPb3hlK1pKNzFDaVVScndxTkh5?=
 =?utf-8?B?Tm9hb3M1UHJWYnpSMXhWMUsyREdIT0krNmM0d0k3WENDRzZqdld6TUlBV0dV?=
 =?utf-8?B?SXFkS1NCOEtyTkVqRUZUcWdzSFBBWnlYR0c3eGsrZTZKd0RuTnF4OHRjai9p?=
 =?utf-8?B?SWg2ZU4ySGdnK0ZRUVBSZUl6dWRRRTliTEpyeVMvY3NoZlJLeFpDZnBGc2N2?=
 =?utf-8?B?N1d1bTZKVGpnU3Z4dDNTa0w4SkZmRUIybEZTcUR1TkMzN2l1QktHekR5UHdt?=
 =?utf-8?B?RzhCaTkybG8xcVFlUWxlZkhjYUplUmNtR0tUN21zZ2ovMmp5bFpoMnB5dkZs?=
 =?utf-8?B?SzIrYmF1S2oxOHNlUkEybVgzVE1JTUwxcm9IbU1IcDZKK2VLUC8vU2QrdHpt?=
 =?utf-8?B?c3A4YndTQ2tmY1RGN0FyMHM4VUFOekIyQWxoaFFpTUpzaW5nY1Q0ZkYvNklt?=
 =?utf-8?B?Rjl4WHY0aWNiLzZDU09tYnlTRjNxNHRCd1A3emJoNUdGMnJ0Y1YwdlphR01S?=
 =?utf-8?B?Rkt3QVBNS2gxN25uY2ladjVkZUJUY0YySytTeU5PaHBzQUN3cHd5NXZUNnpn?=
 =?utf-8?B?OVBrdC9DMkF3MzBkdjl4WGlnMEVGVFpZK3hYejBEcnJodzlpaTI3NzNwU2w5?=
 =?utf-8?B?Z0I0Rm9nWTBzclMrL3ZTeGZHbGJRS0I5QVFmcEVGK3lpWkZUdHZQTkp3UXVD?=
 =?utf-8?B?RXk1QjVTSUp4TTNSRjU5ZzdnL0VHMitQNmJJcGtoaVQ4SWY0ZnM4aVpzcWNI?=
 =?utf-8?B?ckZCbTdTWElQOWdqZ1ljVlJxR2oxdTJ0amEvRGNsOEVBbVJTcW9hcy9jWE9M?=
 =?utf-8?B?YXpvREFTbFNpOFZESE8zOWFIa0ZhOWVqZFlXRG90akhyTTBuQXovT25JQ3Bt?=
 =?utf-8?B?cm9DOWIyeGJ4c01GMnp1Y0t2d05zdE1qQ1hjN1pEUkVydXRVRHE5Z2RzMkVu?=
 =?utf-8?B?MTR4bVlWZzVCa1V4bWRVYi9JSWZPYWRSc0FyM1JVTHhqNXlRbmtkTUMzdldY?=
 =?utf-8?B?NTZGWEZ3TGhzMlBLZUhrR3VVVmNLTDIzcVlpNDNNaEl6R2lYSU1XdmFKVVFN?=
 =?utf-8?B?UjlDcUlHaEI5eG9XRFBEUUZkY0VYVmlSMHo4NDFIUzZ4cXZZM1hzNWYwM1ZC?=
 =?utf-8?B?SThtdG5udzRzck84REpvYXVSdHlvUjRpOUx1Q0s0SXREV21XY0h5TDgrSXNo?=
 =?utf-8?B?RDFNUDJmaDNQdkdPRkJteUtFRHc2VXlyREY4ZXhPc3ZrU29QSVk2OG9KVHNn?=
 =?utf-8?B?c3dSOTNsVk9Ob0VFcmd1V29NL01ISWsxUVBrV1E5RERldTJKam9OMzM0aE5n?=
 =?utf-8?B?VDM3a21ONFg1cWtPcW1TaDlVeEl2elUycHRoT1MvZHh4MXFFZld1SUozenl1?=
 =?utf-8?B?MURjRUlFbTVUR1FGbDdhQUx0QmwrNXFwT1FFQnF6dDNDUXVPQmF3a3h3ekZl?=
 =?utf-8?B?UDhOMlcxamd1SVc2dzlIMk5nd2VCKzc0MHkyL0FaV2dQajNuZEdaU1VHcFVN?=
 =?utf-8?B?K1hUVVp0Sm9JVXlucGhReWNPbTZVOVFYRkt6bkdtbG0yZWxMWmwwUT09?=
X-Exchange-RoutingPolicyChecked: mJnhnHT1PDR9+ot3DLeTlpFgJ2tM7E/tEo88BvojdlyiJOlb/cGnoQRhbQNF2X6+JZPARUKzlaCFLEizI0Byy3PjxOwSBfwaGNQOrAfE6ymooWTzKZE7qIMzVOnzznMOLsMv3PQTi9rpytLoBF/lXpxiCX7DK7IXXUzHRdz4BE8X4srjx8RetHuoTZB+D3d1muu0gJRP8qK+30jgJ9cOV0Z1ihzqNhDVyusrrKlvJoklVaTnWEhhnDs0sa8f3tuVu/UJ1XIlwLh25LPqg3votLWE9mJlkhgFd4VZ0EqtxgdeqZYf1hRPcyP2kPIAA56dHr76A0apSMm2bLDinviCQQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d40bb0-519f-43c0-4971-08ded172fb01
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2026 22:01:30.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chEKiNCj83LrkKO/z1muKCT0EevQJaDEY5Ku/R7iMUhp7/8QylJ6p/RfeUOYi6Dewu2W+TcgBGAH+fEcuCiyiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7928
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: cwno8qju4dhh1ftauy4fnhkiiubdoog6
X-Rspamd-Queue-Id: 2F448120010
X-Rspamd-Server: rspam06
X-HE-Tag: 1782252094-265626
X-HE-Meta: U2FsdGVkX1/ldtc+5YpkBuGBjrpj1iiBiXuX+TMfdNF/+YHrLGxti+uIoMusw3TWXvj6a40agumaUAvwElMa+Ni5G81HwIleLAK7X8nsvOqAYjJYTKF8lCDsCdFxw8virIRFnfTRoxjEW16wZoZikJp9NqamsaWp6UgJ9uDxh3W5KrHPVl1NMWcpfZ7QQnbGioDzWGVo0lR0/hx69B/W5BKF1nigfmeXSZ6dX/nDm4Ip9TputAPaEtMOMmgvT0MX1+Ko1pKqrQyRVA7X/zigxuEU74ZeV0AuuufV9ohL2N2H70OKU+IULd9ff0/qLenaZH0dET2nKy0O+r+8vq6LR7pjdOyMX7cCsPkuZ/F3cvxmItfQpr0KkodoC/8CrR3WCZpb/cU73M5rJA0WxVhKPAcGUOkMXAaGs3/4Ok8xqOUnu7VhlWE8/SZkE5ja60iiIN4rNa7jRIxg3il/KQJ5XiuIPHVxEDowyqotM1wjUu9EJvDGv64wLDr5s00F1jgjVZU7DNK4UcZ35EZJDsgVu72v/7VvyaaUiLOxiyD9U3YcmUndAUuzIZnssroH10UYSns3WFiFuugG/NbYXvCssCfuId1omwB5e/B5dOM+d4W/4BPDIJRQLefaioK3aqjrPSKV4C7cbtgXqws649vyUlCpeZ1Ulh7Hh6oex7CRSsRztjiyGztP6FuYvVPX4bnj3QrfXnmeZgq8cfpcZhq2vIEwremJaRlnmDprOrUj2QpX0/WNo72JN7DHjJfCVQwKU/VetATTOqqTNWmI80bygfkrEre1Ip9C7h9SnndSUUbQ4XVr11mXhL1ezhJu/ZpgEcM5VXJ6xV+WBCvAa3vL3RAbNjYQLSn3YcI124k0T3YMYyx/OhrpiWmoMvp6ZrdvNL2aj8EI9fxzQGHqDDo0eOpu9Xnr90LFHz/xbnWuAjVp5CxgRCvT5/fw7MkvqzJhpWSigUVvz1Ww77MyPMB
 DJ7cs9pm
 7fV1jrxhruaXfH7g3PeSW/WlieFS1vdTyYIIXW2/Zh6KJe8kHGM56jux0gY2xJBEooOmHRF9JHCUuxhmri61uUDEE1szOnh0Uy/ZfXhjntVv7ERdl96yX0owSMwWdU+sj+5glCSl4Z6EYBQGUeEpSipihP3GdF7r/82GHItgrWsc1gNBHUDg9ljpZYt1HSFunBUZW7uIdVqCPV5ETaGDoP1C81c6O6OywxitBB9ZRLb5H1TOUX/1H1Y0wpcp9cAUeWdn04KNhugE9KSKhm97MyofDa5Is+x6xqJ9m7UhITSpGwaoBYVc37RRAYBXDAVHvURDuCM3aFWlouBxbNM5sOBag2iyQ5Mi2elTryBFEVz6MHnqRcEJinz8/CbYtOnOpXdvKNesIovzhkXiIEKtJKznlk6tXzm4hipmd6oMWEKnfcR6XwZJLkEhocArL4fvVtCflJUdEidUHDMhYvUKcKOt5t/nH44+yBh/d0sJAuMPHVXZS7Wr1TlqieNK4dC/kFKEk3OzY68gGtimJT3x+tKWdlHh9FFRerLKGol7VyAn+zlpxx6MU5HK29RXPp0gKSBTmr929SDOcibkX0nhRdRUFsqQFXGqEEpOQCl2yhNiUZrkOpidYkk36ar66PwsQMAZX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 03:32:58PM +1000, Dave Chinner wrote:
> On Mon, Jun 22, 2026 at 05:09:33PM -0700, Matthew Brost wrote:
> > On Tue, Jun 23, 2026 at 09:10:43AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 16, 2026 at 08:22:17PM -0700, Matthew Brost wrote:
> > > > High-order allocations using __GFP_NORETRY or __GFP_RETRY_MAYFAIL
> > > > are often opportunistic attempts to satisfy fragmentation-sensitive
> > > > allocations rather than indications of severe memory pressure. In these
> > > > cases, reclaim may invoke shrinkers that aggressively destroy working
> > > > sets even though reclaim is unlikely to materially improve the
> > > > allocation outcome.
> > > > 
> > > > Some shrinkers manage expensive backing or migration operations where
> > > > reclaim can result in substantial working set disruption despite the
> > > > system having sufficient free memory overall. This is particularly
> > > > visible in fragmentation-heavy workloads where reclaim repeatedly tears
> > > > down active state while kswapd attempts to satisfy higher-order
> > > > allocations.
> > > > 
> > > > Introduce an opportunistic_compaction hint in shrink_control that allows
> > > > kswapd to communicate when reclaim originates from a high-order
> > > > allocation context that may be fragmentation driven rather than true
> > > > memory pressure. Shrinkers may use this hint to avoid destructive
> > > > working set reclaim while still participating normally during order-0
> > > > or stronger reclaim conditions.
> > 
> > Thanks for the input - this is a tough problem.
> 
> Yes, that it is.
> 

This is part of what makes this fun.

There’s a lot to go through here—I’m going to start actively working on
a PoC, hopefully today. I’ll likely have more feedback as this gets
coded, but let’s continue to stay aligned.

> > > To be honest, this seems like another "push a hint through to the XE
> > > shrinker" mechanism under a different name. You seem so focused on
> > > fixing the XE reproducer that the -systemic problem- that -any-
> > > high-order folio demand causes is not being acknowleged.
> > > 
> > 
> > I'm not exactly sure I agree here. Communicating via __GFP_NORETRY or
> > __GFP_RETRY_MAYFAIL with a higher order implies that the caller can
> > handle higher-order allocation failures, so the shrinker shouldn’t try
> > too hard to obtain a large page (e.g., evict a working set). I agree
> > that Xe is currently the only shrinker making use of this, but other
> > shrinkers could also hook into it. This information simply isn’t
> > available today.
> 
> Right, but "we are doing compaction" isn't information that tells
> the subsystem shrinker what it needs to do. "memory compaction is
> occurring" isn't a well defined action like "count reclaimable
> objects" or "scan N objects and reclaim as many as you can without
> blocking".
> 
> Directed high order object reclaim should be much efficient that
> trying to use general memory pressure to age out enough objects to
> reform contiguous pages. We need to help memory compaction, and we
> can't really do that by layering heuristics over reclaim algorithms
> designed to maintain working sets efficiently.
> 
> > > e.g. we use high-order folios extensively in the page cache these
> > > days, and there are -many- cases where memory compaction driven by
> > > high-order demand cause significant performance regressions for page
> > > cache performance. To date, every single person who has wanted to
> > > fix the problem they are seeing has effectively attempted to -turn
> > > off compaction- via GFP flags.
> > 
> > So does that mean they clear __GFP_RECLAIM?
> 
> Usually __GFP_DIRECT_RECLAIM, as it's the overhead of direct
> compaction that causes the performance problems.
> 
> > That isn't really what in DRM or Xe. In former case we have pools of
> > lower order pages in TTM not in use that can be shrunk, potentially
> > freeing multiple lower orders pages so a higher order page formed, and
> > the later possible BOs (sets of pages) in Xe marked as purgable (not is
> > in working set) which can also be shrunk. Other DRM drivers have purging
> > concepts too.
> > 
> > I’m not very familiar with what other shrinkers or subsystems want, but
> > presumably other shrinkers have pools or caches that aren’t currently in
> > use, where they can say, “OK, I’ll give these pages up for opportunistic
> > compaction, but I won’t give up my working set.” Of course, as mentioned
> > above, if someone else explicitly requests large pages by avoiding
> > __GFP_NORETRY and __GFP_RETRY_MAYFAIL, the shrinker should then give up
> > its working set.
> 
> Most caches are slab-based, so there can be 10s of objects with
> different life cycles per page. There is no almost possiblity that
> shrinker reclaim will free pages without substantial
> amounts of the cache being reclaimed.


Yes, I agree most shrinkers are slab-based, but there are at least three
notable exceptions that I’m aware of—potentially more (let me know if
there are others which are aware of):

- The TTM (the most common memory allocator for DRM drivers) pool
  shrinker maintains pools of pages that are free (i.e., have no
  driver-side references).
- DRM driver-side shrinkers maintain both non-active pages (marked as
  purged by user space) and active pages that are either idle or
  short-term pinned via dma-fences.
- The deferred_split_shrinker, which holds pages in larger-order folios
  that have been partially unmapped.

All of these can free substantial amounts of memory—sometimes very
quickly, and sometimes with a delay (e.g., when waiting on short-term
pinned memory via dma-fences).

The deferred_split_shrinker in also seemingly has an issue where
it can worsen fragmentation in certain cases. For example, if we need an
order-9 folio and it shrinks a partially freed folio of the same or
smaller order, this doesn’t help and may actively make fragmentation
worse by shattering folios. While we’re here, this likely should be
addressed—unless I’m missing something.

> 
> > > I've even done that myself inside XFS to work around kvmalloc()
> > > issues with a lack of GFP_NOFAIL support and doing costly high order
> > > allocations that fail and trigger compaction before falling back to
> > > vmalloc().  However, these issues have since been fixed in the
> > > kvmalloc() code, such that it now does the right thing for most
> > > calling contexts (i.e. tries high-order kmalloc() without triggering
> > > compaction, then fall back to GFP_NOFAIL vmalloc()). This has made
> > > kvmalloc() more performant and better behaved for -all users-, not
> > > just XFS.
> > > 
> > > This is not sustainable - we need compaction to be robust and
> > > performant in the face of high-order folio demands, regardless of
> > > what subsystem is generating the demand.
> > > 
> > > So with that in mind, let me paraphrase the comment in the second
> > > patch in the Xe shrinker implementation:
> > > 
> > > "Shrinker reclaim is based on implementation specific object sizes
> > > so it is unlikely to ever acheive contiguous page reclaim in a
> > > manner that will measurably improve compaction rates."
> > > 
> > 
> > This might be slightly misworded—what I really mean is that I don’t want
> > to give up my working set for higher-order allocations that are allowed
> > to fail, but I do want to give up my cache.
> 
> Right, that's the core of the problem - compaction is the high-order
> reclaim trigger, the existing shrinker infrastructure reclaim is for
> the working-set maintenance reclaim algorithm the subsystem uses..
> 

Ok. We also need to consider how direct reclaim and compaction interact.
Shrinkers are currently invoked during direct reclaim, which I believe
is correct—this helps with compaction and is desirable. More on this
below.

> > > You also say:
> > > 
> > > > No functional changes are introduced for existing shrinkers.
> > > 
> > > Consider how many shrinkable caches the general statement above
> > > applies to, and then think about the fundamental impedence mismatch
> > > between the affected shrinkable caches and what this patch actually
> > > fixes.
> > > 
> > 
> > Yes, as mentioned above, I’m only addressing Xe here, and I agree that
> > this is likely an issue. Do you know of other shrinkers that have pools
> > or caches which can be shrunk under the conditions I’m introducing here,
> > but also have a working set they would prefer not to give up?
> 
> The first that comes to mind is the xfs_buf cache. This cache holds
> cached metadata buffers that have different sizes can each contain
> up 64kB of contiguous pages. The allocation algorithm uses
> optimisitic large folios allocation, but if that fails it falls back
> to vmalloc. The working set is maintained by a prioritised
> multi-scan LRU so that more frequently accessed metadata is held
> tighter by the cache than less frequently accessed (e.g. btree roots
> have higher retention priority than the lowest leaves).
> 
> It does not currently track buffer objects by size, by if there was
> a benefit to doing so then it could be implemented. I'd much prefer
> to have such tracking separate to the working set maintenance,
> especially as they will likely need some kind of balancing to
> prevent high-order buffers in the working set from being thrashed by
> compaction demand....
> 
> I know there are other caches that have variable sized objects, but
> I'd have to go look at the code to referesh my memory of which ones
> they are...
> 

I'll have to look more here to be able to respond intelligently.

> > If so, a
> > link on elixir.bootlin.com would be helpful so I can take a look. I’ll
> > also try to go through other shrinkers myself.
> 
> cscope is your friend.
> 
> fs/xfs/xfs_buf.c contains the XFS buffer cache and shrinker
> infrastructure, but looking at the code without any understanding of
> the filesystem structures or how it interacts with the other XFS
> shrinkable caches probably isn't as useful as you might think it
> will be.

Agree. Looked at some FS shrinkers and got lost quickly.

> 
> > > For example, what happens to slab-based caches if the XE cache is being
> > > excessively reclaimed under high-order page demand? e.g. the slab-based
> > > cache may have tens of objects per page and holds a system-level
> > > performance critical working set of objects. How do these caches
> > > handle the excessive reclaim demand being generated by compaction
> > > thrashing?
> > > 
> > > Yup, they don't.
> > > 
> > 
> > Agree.
> > 
> > > In the case of filesystem caches, the "reclaim and repopulate"
> > > pattern you describe causing the XE perf problems causes internal
> > > slab cache fragmentation. Not only does this not improve compaction
> > > rates, it also results in more memory fragmentation because slab
> > > pages get pinned by a small number of long lived objects and they
> > > won't get freed until the cache is largely emptied.  IOWs, things
> > > get -even worse- from a memory fragmentation POV when compaction
> > > thrashing causes the working set of a high-object-count-per-page
> > > slab cache to thrash....
> > > 
> > 
> > Got a link to the code which you are referring to?
> 
> Do a lore search for "dentry cache defragmentation". You should be
> able to find discussions that go back to around 2006 about
> discussions on identry cache fragmentation and approaches like
> slab-page based object reclaim to support internal defragmentation.
> 
> The fact that we don't have slab cache defragmentation despite many
> years of people wanting such functionality should tell you how
> complex the problem is.... :/
> 
> > That seems like a problem similar to another issue in DRM/Xe. We found
> > that the process of shrinking actually drove fragmentation by splitting
> > folios down to order-0 and then backing pages up one at a time. I have a
> > separate fix in flight for that.
> 
> Possibly, though the life cycle differences I'm talking about can be
> a few milliseconds (temporary file) vs weeks (long running database
> instance holding it's table files open the whole time it is
> running).
> 
> > Could the filesystem detect these hints and avoid shrinking in a way
> > that causes fragmentation?
> 
> Not really. The fragmentation problem is caused by physical object
> placement in the slab pages at allocation time, not the act of
> reclaiming the object.
> 
> i.e. we don't know what the expected cache life time of a dentry or
> an inode will be when we allocate it, so it just gets allocated in
> the next free slot in the current partial slab page. When you get a
> mix of dentries that are pinned by open files in long running
> applications and dentries for access-once files in the same page, we
> end up with reclaim freeing all the object slots that contained
> access-once files. However, the pages are still pinned by the
> objects for the open files that are in active use.
> 
> IOWs, LRU-based reclaim can free >90% of the objects in a cache that
> held millions of objects with mixed lifetimes and still not free any
> memory at all. There's nothing reclaim can do about it because the
> problem is created at allocation time when lifetime is a complete
> unknown.
> 
> > Alternatively, could it perform shrinking in
> > a way that doesn’t shatter folios, or detect long-lived objects so it
> > understands that shrinking isn’t going to help reduce fragmentation?
> 
> Referenced filesystem objects are not on the LRUs, so the shrinkers
> aren't even aware of such long lived objects. And, as per the
> "dentry cache defrag" comment above, we can't ask the slab to
> reclaim or move objects because we don't track the owners of
> external references to the objects themselves.
> 
> > 
> > > This isn't isolated to individual subsystem thrashing.  If we run a
> > > file-based workload that generates high-order folio demand and hence
> > 
> > What GFP flags are typical used for file-based workloads?
> 
> Mostly GFP_KERNEL, with a mix of GFP_NOFS. non-blocking paths also
> tend to add GFP_NOWAITS, and memory reclaim sensitive paths often
> use __GFP_MEMALLOC to prevent reclaim recursion. Some filesystems
> also make extensive use of GFP_NOFAIL (e.g. XFS).
> 
> > > compaction (e.g copy tens of GB of files between two XFS, ext4 or
> > > btrfs filesystems), that will -also- trash the Xe working set via
> > > the shrinker being hammered by memory compaction try to free up
> > > contiguous pages for the page cache.
> > >
> > 
> > I could see this.
> > 
> > > Similarly, if we run a Xe workload that generates sustained high
> > > order folio demand, that will trash the working set in the dentry
> > > and inode caches and any other shrinkable slab-based cache.
> > > 
> > 
> > I could also see this but DRM / Xe will set __GFP_NORETRY or
> > __GFP_RETRY_MAYFAIL on higer-orders so those caches should be able to
> > not trash its working set if looked for this hint. 
> 
> This relies on all the allocation code everywhere always doing
> exactly the right thing so that memory reclaim "behaves". That is

Yes and no. The original issue was a DRM/TTM self-feedback loop, where
we need some shrinking/reclaim, but not all. In general, this feedback
loop also occurs on CPU/GPU client paths, so running XPS alongside heavy
DRM/TTM with a client part is a very unlikely use case.

> what I've been saying is not a sustainable approach - all it takes
> is one allocation or one shrinker not to do the right thing, and
> we've got another mole to whack.  i.e. memory allocation should do
> the right/best thing for the system with default parameters.
> 

I agree that another allocation could shrink DRM/TTM buffers, but when
DRM/TTM reallocates, it won’t trigger the same feedback loop since it
uses the correct GFP flags. While it’s true that two conflicting
allocations can ping-pong, we are also working on a DRM/TTM reclaim
backoff mechanism and a defragmenter. However, if a self-feedback loop
exists, this effort becomes ineffective.

> > > Hence the abstracted case of the problem we need to solve is this:
> > > shrinker reclaim is based on x-byte objects is extremely unlikely to
> > > acheive contiguous page reclaim in a manner that will measurably
> > > improve compaction rates.
> > > 
> > > This is a problem that has to be addresses by the high level
> > > infrastructure level, not worked around by individual shrinkers.
> > > 
> > > IMO, compaction shouldn't trigger shrinkers unless the shrinkers are
> > > specifically flagged as being able to release contiguous pages of
> > > memory in short order. I don't think there's very many shrinkable
> > > caches that even hold a significant quantity of objects larger than
> > > a single page, so it's clearly questionable as to whether compaction
> > > based reclaim should run shrinker reclaim to begin with.
> > > 
> > 
> > Yes, sort of do this in Xe by changing '->count_objects' based on the
> > hint.
> 
> I know. That's the problem - it's relying on the infrastructure
> passing down a specific internal context hint in an existing
> interface so a specific subsystem can work around a specific
> problematic behaviour.
> 
> Indeed, for compaction we don't actually care about the count, what
> we largely care about is whether the subsystem has any objects the
> same size or larger than the current compaction demand. Efficient
> object reclaim for compaction has a different control variable set
> (e.g. find objects larger than, objects physically near to, etc),
> and this can't really be properly fitted into the existing
> count/scan shrinker reclaim algorithm.
> 
> Hence I think it needs new shrinker methods to implement
> effectively.

Looping back to direct reclaim above—would these new methods also be
called during direct reclaim? My thinking is yes.

> 
> > > i.e. a subsystem that can track high order folios in a shrinkable
> > > cache should probably have a "->compaction_scan()" method that is
> > > run directly from compaction context to try to free high order
> > 
> > When you say “compaction context,” which parts of the code are you
> > referring to? I’d like to explore this option, but I need a bit more
> > context.
> 
> kcompactd does background compaction, similar to how we have kswapd
> to do background memory reclaim.
> 

kcompactd doesn't call shrinkers - this is where we'd call compaction
shrinkers?

> Direct compaction (part of direct reclaim) via
> __alloc_pages_direct_compact() that will be called before direct
> memory reclaim in the case of a high-order allocation.
> 

So maybe this is where compaction shrinkers fits in in direct reclaim?

> > 
> > > folios. This provides a direct opt-in mechanism for a subsystem, and
> > > it allows subsystems that can track low- and high- order objects
> > > independently to efficiently free objects in a way that will help
> > > improve compaction rates without impacting the entire working set of
> > > objects in the cache.
> > 
> > 
> > Does this help if, for example, the cache is holding onto two order-8
> > folios that could be freed and merged, while the caller really wants an
> > order-9 folio? This seems like a possible scenario in caches and is
> > certainly true in TTM pools.
> 
> Depends on how the interface is implemented.
> 
> IIUC, the direct compaction code will return a right-sized page
> early if it creates one via compact_zone(). Hence if that path can
> call into shrinkers to do high-order scanning that results in two
> mergable order-8 objects being freed and merged into an order-9
> object that fulfils the compaction requirements, then it will result
> in compaction succeeding where it currently fails.
>

I think this answers my question above - call compaction shrinker here.

> And I think that kcompactd will run until certain watermarks are
> met, so again having a high-order shrinker that directly impacts the
> high order page watermarks would be much more efficient that trying
> to use general memory pressure to randomly shoot down enough objects
> to reform contiguous pages.
> 

I think this answers my question above - call compaction shrinker here.

> > > IOWs, this patch to inform kswapd about it's trigger (doesn't it
> > > already have a "reason" parameter, though?) is likely a necessary
> > > part of the solution - we don't want kswapd running shrinkers if it
> > > has been triggered to reclaim pages for compaction. This patch would
> > > allows kswapd to elide normal shrinker passes when it has been woken
> > > purely for compaction purposes. Given that the compaction code would
> > > be running the high-order reclaim capable shrinkers itself, this
> > > would avoid trashing the working set of most shrinkable caches -by
> > > default- under high order allocation demand....
> > >
> > 
> > I’m trying to parse this—are you suggesting that, one way or another, we
> > introduce a heuristic where shrinkers can act on a hint (whether it’s
> > what I have here or a new ->compaction_scan() vfunc), and then attempt
> > to fix all shrinkers in this series?
> 
> I don't want existing shrinkers to be touched at all.
> 
> What I want is for memory reclaim (both direct and kswapd) to elide
> the shrink_slab() calls into shrinkers when memory reclaim is being
> driven by high order allocation failure.
> 

I still think compaction shrinkers need a concept of “opportunistic”
versus “must free memory to compact” to avoid the self-feedback loop I
described. Without this, the DRM/TTM self-feedback loop would still
exist.

> i.e. high-order allocation failure should not generate shrinkable
> cache memory pressure because shrinkable caches in general cannot
> return contiguous memory that will allows compaction to make

Yes, I agree with “shrinkable caches in general,” aside from the
exceptions I outlined above (though perhaps I’m missing other
exceptions).

The risk of what you’re suggesting is that it would suddenly change the
entire shrinking model across Linux, and we don’t know what unforeseen
consequences this type of change might have. Nor could a single person
reasonably test a change of this scope. That’s why an incremental step,
like this series—which fixes DRM/TTM as opt-in—may make more sense. As
mentioned above, the deferred_split_shrinker is also a very likely
candidate for being fixed. That said, I’m going to look into your
suggestion as well.

> progress. The existing behaviour has more negative affects on system
> performance than positive, so we need a fix for "everyone".
> 
> I think we should provide a new opt-in ->compaction_scan() method for
> compaction aware subsystem shrinkers that is run from compact_zone()

compact_zone() appears to be called from both direct reclaim and
kcompactd(), so perhaps some of the questions above are already
answered.

> context. This allows subsystems that can manage high order objects
> to optimise the return of high order objects to the free space pool,
> thereby significantly improving the chance for compaction to
> succeed without adversely impacting the rest of the shrinkable
> caches in the system.
> 
> Further, we should not kick kswapd because of compaction failures
> because kcompactd will already be running ->compaction_scan()
> capable shrinkers from it's callouts to compact_zone() in the
> background that will do this work as efficiently as possible.
> 
> > I’m open to trying to fix other
> > shrinkers as well. Do you have any particular ones in mind? I count
> > around 45 shrinkers in Linux, so it’s unlikely I can fix every single
> > one, though or all shrinkers need to be fixed.
> 
> They'd all need to be fixed, which is why I suggested a new method
> to be added. Avoid calling the existing shrinkers in the adverse
> situation, call the new one from the right context where it actually
> benefits compaction and high-order memory allocation.
> 

OK, this seems fairly reasonable on its surface despite my concerns
above, but see my comment above regarding “opportunistic” vs. “must free
memory to compact.” Without that distinction, I don’t think my original
problem would be solved.

Given this scope / risks, can I ask for one of two things:

- We move ahead with this series as a stopgap fix, or
- Allow DRM/TTM/Xe to implement shrinker-side heuristics to break the
  feedback loop

while I work on this larger refactor. This is the type of work I enjoy
doing, and I typically have the flexibility to work on what I think is
most impactful.

> > On a side note, I just noticed that struct shrinker has count_objects
> > and scan_objects as individual vfuncs rather than using a const struct
> > shrinker_ops *ops. Should we change that? The latter seems cleaner and
> > is typically how things are done in Linux.
> 
> We probably should - the current structure is largely historical and
> there's only ever been two methods. If we are adding another method,
> then it would probably make sense to add an external ops structure
> to reduce the memory footprint a little.
> 

Let me look into this as well. I don’t know the exact merge flows for
tree-wide changes, but I can figure it out.

Matt

> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

