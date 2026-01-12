Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A70CD232D7
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3386B0088; Mon, 12 Jan 2026 04:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F056B0089; Mon, 12 Jan 2026 04:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573B06B008A; Mon, 12 Jan 2026 04:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4485A6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:42:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 181B41AD6C1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:42:32 +0000 (UTC)
X-FDA: 84322821744.08.06F45BF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5107A180005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:42:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GLbAQX3g;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768210948;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8oYpTCB32W38JZO/ckhbaZJ+EuzJDlJstGkmv8313I=;
	b=jKnsM8auvp9ZI+DwW7Kt0Z/97jl8SJWM1eTtWf6kEhYFatbjo5DJY6Soj2WOMHxd32p/C2
	j2bHIXCUutPZnix9EVTraVFd69fAl/11ABHnAdmghso4La5gYcDmAteVCLO9CG/x0GxEVx
	RQeOMqzWOL86nVjUFtvnpamdMfnw+BU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768210948; a=rsa-sha256;
	cv=fail;
	b=FiaSAsvoyHw0Q0GItxj4iKTtRyxZslFJ1jfVvWM5quxtjBD7hS+IrS7MzC7PxoosSqQPjm
	LsCLImor888btr2xBuuFEhkX2uw6gEC7/3Id2nN0tUAiBGD8DXT7Hv+hwCxAjrFCKnacr3
	wzKxS6IFKN+TFKCQEFqm+GmGd7KG/T8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GLbAQX3g;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768210948; x=1799746948;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2Z+NEpSuyzSdWBsA87Bn7i395z6FNttSxtvyHCHw2sg=;
  b=GLbAQX3g2VrPTarXdMOs2jH2oHn61Z5wLJAWqUKrHoBTcBjulhDKn4e9
   4oKSWdxso6AguaB0zlBvTFG/Wvj2bpA0JZ/5QMh16HeoJ7nLQUGUwp6LR
   7dPkQR7gYdbs6ShWPd0y3g8k3YijIXauIxzv4pIk//WQ0c94+Ynb8p86N
   Zs8LLOt2jBurw/zUvm1lSuc+Dv3l7PJiN0MWRSDQJOSkwUmw1MI46aTza
   bZdON8r4swjB2c6TjYIbtS3boSqYrgsjZkSVuOt/W2xZRjsMJRmKocxcW
   opRvgnHdrjjLhWsyFz4KEnA6SZ9WRXceSoSjv5Kt9hTatMZDriN5wnbXn
   A==;
X-CSE-ConnectionGUID: YPU1azUpTIeqYMLePwHizw==
X-CSE-MsgGUID: FM/jLgTQTO+ghCflb3SuMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80848346"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80848346"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:42:27 -0800
X-CSE-ConnectionGUID: o+yPJDpkQjSif+k3ZzkenQ==
X-CSE-MsgGUID: cUFsp6dTSJmQT7w17gTRvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="204328691"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:42:27 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:42:26 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 01:42:26 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:42:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1FTywgmJJBP2cpaNgye+qoBZ46XmLq2z/wV2qlN9ZXZpdQrujktMh2zsEOpJmhFlxBRSqbexc5GmFda2cuIIGZ84/Uu2CXZpaxNWEm/EwsEhbA2iMH263ulomjBZfT/UttKcEpZ2pa4P//WXpdWuHo8npDdZCfH2E6MPbBGfzO+p/f7BD3vzUQu/DQUoOqq27EZ8iXLaTQnleQmmzglbI+mLbpn6vrKUNld+vCCvBKHWLQ/LYmfRL6nIliE/UUyKHr54+BjoQ3LCoDLWPPenrHxuAPFNahD0zlpd9b8ikmPkCOpaeqWSuUX2gaarjf142aTjaDF0OfEJwHrSGCi2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8oYpTCB32W38JZO/ckhbaZJ+EuzJDlJstGkmv8313I=;
 b=Sc1MVZX4wfuilPaZaCkNxyt1YbegQ3e66Wyzmkd+SYoQYMdn6TTu8GOe450/nZXQFfS+/poayj7PpKGZaCEegydvfskwQR0WBnAt+eUKNAPR4H0gRpdZ8Wib6irpnMHCRZF2l1qHExB0UmP3K3Gtsnk+tn7cAawMgkWNvgxCMHQTUQjiOjKhn/YKERhqKInIn29wHeUdKONdkSLSuRZsELzDfHwP4FMsuw6VqCCga4Hxmm190vw1UdH6t6n/k8/oQ+qXB2E16yXXuQlPYktMvYTGfcpXvj0AtnZ5bzlqbz+Sahjfpu4MUqx111Nmm2vyy9WsS0JfNHNYyOiZugceMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:42:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:42:23 +0000
Date: Mon, 12 Jan 2026 17:40:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 5/6] KVM: TDX: Document alignment requirements for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <aWTBfjVEHE5HC5gn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-6-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108214622.1084057-6-michael.roth@amd.com>
X-ClientProxiedBy: SI1PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8914:EE_
X-MS-Office365-Filtering-Correlation-Id: 1929acf2-6007-4dba-3015-08de51bee37e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?B/PMO5HLxVMWH2WGir7M27bmNSaWi2r6iSwzsiLMzeHXHYeRC4V8X1/6BGHe?=
 =?us-ascii?Q?tT3LKFh+2VL0+QbqnS01tA3N0OhIkAtRVeWgH/t33OHp6A35AIGM68e5R3kt?=
 =?us-ascii?Q?OHI7V3Q82YWW3QGm178QuYORzPYhOvSZByh9Rr6nJGegp9itch0m/C8Hta3H?=
 =?us-ascii?Q?Qc4zhejfBVI5wR9uzRe5ocCkdcBmP46V71pYkAl6wrc71xnlLfrmNhns16pv?=
 =?us-ascii?Q?j65s77Jv7gqxfT0SICjn1SCEBIYjN2qizjquYXxWwR/7SDoF+h3lIqzD/lxk?=
 =?us-ascii?Q?+82sofSM4NjHOokBmg8olnKg5s5gdUZSHY6kEGYXNKZid9Abc0RbisBStRdJ?=
 =?us-ascii?Q?MsOb71sZRtJmPem1rV9VHf0+7abvZS6PEFc66Ix/3liW+bLpBT72XOxTsKz0?=
 =?us-ascii?Q?OVbOfNTI7I6OoDc93XxGorGFsWr5xJ5B2zeXFWK+EedsOlF+IHbB+hHYn/sK?=
 =?us-ascii?Q?7Yn+rGFUZh38ZYncLcVTZ/yI+Bn+ff2NpZhA5PbdtbXGdmlgvzVYCWvTfwD3?=
 =?us-ascii?Q?+Ya29OOEWjBcy7emYzqOEdwMovE/hCq/hEVJ73Qgvi0/JUul2jnsw7lCOhGW?=
 =?us-ascii?Q?vIMy53+vArhO4qsUG+AEA97Bbu9NYvDo6j0I7tmsVTPapxbQYeTR+CMix5rD?=
 =?us-ascii?Q?Q1WB3SGakgyNn4UbVW6xr2mMaeAvPnxJDnxjquQSL/aYXF0RZIEmuugd0k7O?=
 =?us-ascii?Q?2kUmq+5bxjp2cB0x0SB55GDDOyVgHmzIwGVDjODGStcvTJHLhlDcMHthHNCg?=
 =?us-ascii?Q?lPXeqtRuLcJSJPyR8a/d+Q/hPz1YJ6bumRj1pJD1vmF05axXYZdBFtweTEpo?=
 =?us-ascii?Q?n+W6qIbiLGkJ3VsyQayI9DNQxrNEOT6Mg/iCnx212lf0jGuGcUBFA981cIpb?=
 =?us-ascii?Q?4UivC9odQ2pUPqV8jPHLRR6qmWcHfPufRt4HwgAnF5wbfmlJFn8FOvlHyr2W?=
 =?us-ascii?Q?46/5KVKqcY3ILGE0MMqiUHPMaLja6G6nSA/PqDLRyNMSBgntW3bRZl9mQWrv?=
 =?us-ascii?Q?CBUl4Hr4WjbI57z17ZceJ2XjR905El5Xsxr8bY2iA3zetvLVTdwcMK+XKoaz?=
 =?us-ascii?Q?D2ZD7UQVGEG+QdXU6+1Mypi09Kgn4Y+Z2fTla48TdeGFXN1lWe1A4m4pXn9L?=
 =?us-ascii?Q?emwcxdNT56Q3SUS4ZRyv/qrYXpjJvncC1gbXwPJhqiQihQtoX+NT4NYjVFF3?=
 =?us-ascii?Q?9JWJDkj0VS9QDue9jssY34ssRTGWL3fpmjPpLnafwmJVh6IlCuk3/wjKm0Hj?=
 =?us-ascii?Q?UzL/e9b1P7SOkAaSSmKHS1plH0d7d6GeuwDUbGhjkSGL+xoZIVPPETPurRLl?=
 =?us-ascii?Q?dbc4HEeYzOSpvT6EcyWJ418ZHWrlnxgJmlQh4iQu4CDhPmj+VpMXvRcnI/Zl?=
 =?us-ascii?Q?1LHHvQ8UT5qvAD2u04Hbqchz0rmDhFrLo2nG9ls/ILTuGYpP+Mqn+7KOs/yC?=
 =?us-ascii?Q?ZDBoBQpHJ07OdahmXTaenIKtiGfPUyhP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8rC27cAdFcq+al9xzX1xevNw+B/XKdf8/j78h+MOlUhUILCKovZJYwbuekJl?=
 =?us-ascii?Q?KFSGrhO/fLCytSZQlCiz8HntIN/xH3UqvFDP6dXJsX5APo6pz7/xj0OVoMW8?=
 =?us-ascii?Q?ZR37F/x7NVVghV/BgYNmm45hI087ugYirmgwrThjS18w2dMnDJbGKRxQwUUM?=
 =?us-ascii?Q?LXWMbZls+NCsnTMGxR3utR0qkDPhbtXdl8hTsfZ1iazSLEFgg+49XutMCfg8?=
 =?us-ascii?Q?zmKH/bXMM8JxNpkPbfyId5m6ixo8rclT86sVIwkozg3UEi27vPPRU9nqbRBV?=
 =?us-ascii?Q?DMkeP4Q1LwKXu0JTsVkfJYhG1wk9DwuoK4LOKedePW67sw9NT4iC6YQkC0IS?=
 =?us-ascii?Q?bWD5wwuFprVZmUBEydjTBU1liMhONMggqzcAzvfi/GKkjXRp5SSPXkrz3h5S?=
 =?us-ascii?Q?lbYYDf/1Baq7LAq+D+Of92ze2ksQWXRSXxdoPEm7w/4oZuAIzGv2JuQjos86?=
 =?us-ascii?Q?Kr1qnd5s0GRUYsB9L1VcEFK88rawQWMjRGG8Jf/SrfNhSNAL4Y5obq/H2d0N?=
 =?us-ascii?Q?d+WrSNUnNr1gcoZfaanI144NAJ5Sxqo1LC5vubMnJsYM7ATjzWbD/xKqZK0b?=
 =?us-ascii?Q?vXl0xsf3qxlv5GAqpT3m0CXEMw0EKWl9bbt8MfwsLQ+EwUsmyNRDUmoisMOP?=
 =?us-ascii?Q?SUJMN8YVj5w/QpAz7YXlrcaZg3ULYhRAe4FKckrEseQYBgzM4fZ4G6LQfXNp?=
 =?us-ascii?Q?nOb2NyOPSbu9hZiB2dwXet6/zpQXn9jKwaMpfgGNh2PAbHWF7DO+3XEUVBL1?=
 =?us-ascii?Q?3ZbtcnhnVuPXOs6BMugYaVNajiWjp6X6A3OY3v9UB+DDZK3dIVl0EWzEiqa5?=
 =?us-ascii?Q?z+6/ShezqIAiBgb1biNVhYFhd1f0gYs/Dey+N1jZzar7iB4IBwfaSlcy/uOY?=
 =?us-ascii?Q?xg7h7jw4W/+8q4DRMS6DZaUeuB3DmJBYb1d7H9WqumKdkecBdeGGzVFFyS3f?=
 =?us-ascii?Q?NhSRdGhVu3ncp7LMvbGoN5FF0W5icP+tOIqDq8pa4RmRB5hAMV5DeFnlVTRa?=
 =?us-ascii?Q?RkoWJnC8MBiqI3XEOSNidzrM767fadf2fZySVcnIaJdCQFnN/U/gN7JrrjBC?=
 =?us-ascii?Q?F5ad8ahxMiLLOUAAMSG/vTjmQd7qqM1cuKvECDiRz6tPRTAgDxupTq000/B8?=
 =?us-ascii?Q?/N9mpsuBiFTSLY98MYOb7q9Ycwlg7pb0JredsrHzzI0OCPYlLyF6ASaz4dyD?=
 =?us-ascii?Q?mCh3NoxLhahsPj9MARKUeU+Oiw3S5tD4qwS+TNtWxx+ETzzShpUTu3N8AF85?=
 =?us-ascii?Q?0Pmi7LYHlWdWHmiL7yZr5f5IDbumI33i66N35d/z7X/+SrruU6gBIvaT8y9y?=
 =?us-ascii?Q?Z+b5kDjSXivYLqxhDtC+D0hgsulQYqEhhlqbGcIddYTTtmTqjfYHOePo1h3a?=
 =?us-ascii?Q?qm6d19uDO/H+goNEKmPomFswEnSzL+Dg3Ww9goXtqw4EFSguNvLP9BK4lS9E?=
 =?us-ascii?Q?c/vyzeyUAMm25lV+2M3cpGHphWMSyUjpAv+AQyx43z5/et8MBFuEGlTK7vjp?=
 =?us-ascii?Q?oriPNikaWGmfQuY6uaWVEtgUojdg3iDQatRVbhp7F3yttjWyS164pehlZ2dZ?=
 =?us-ascii?Q?KGdm6pj1aH8coqi93LEIg8ru44wPSmqZIRfNKrsZhz3Ypz+KH594q+xXLeII?=
 =?us-ascii?Q?oKsXIWo01Ls84qBeIHBPC5LUZqw+vf1zo+hWotsQZnRe1TI6iHY14pAdeMl+?=
 =?us-ascii?Q?9u45ruoD0e9BJsnjhIxZXtKhweUo9fX9el0pxxJ9YtgJIpKB4Dj0EZoX5X4L?=
 =?us-ascii?Q?bYxlytzEtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1929acf2-6007-4dba-3015-08de51bee37e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 09:42:23.7182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAkLoEzt1DCz7du3X7L8P/G+hV8b6UCDLtJtUPAcTA849H29iQzX8j8/yrhOaws/Kw3npGKq0COfHDAa1EibHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5107A180005
X-Rspam-User: 
X-Stat-Signature: xibzioxuj8uhyau7jnie9g4abkt31muj
X-HE-Tag: 1768210948-692303
X-HE-Meta: U2FsdGVkX1+n6/tUYkaeq91IUY+SADxqjbrsGIYFpZAhEYRnv7uj6AxyEShn8lnMAFA/UjKFUWpqhN9C7mfNEXhZGJLgrb9QQILajGAtVHCB048u0lxKaeRI2xWlkT+ufDrxv9Re/AIB4gfIHsCMCRPvFv3+jN+39pEiNFWDvuUTWcsm2Zmw7Mrdc4NxQwQ8apstrszXqf/30iXmzsYN1e8nV3xrkNlBHkdeOhbxW9L0Y9GqiNLEJmmppJYNMsTGKM0bmsy0vUFo89KG5gFYKm1CnhmtGQADTyvXmZVA76AY90t1qWKFT7O8HwMCQzzEMltAKyCQDsWB6NyR9FbM2OrP5LTtysVmn+woaqDcWktfgwLPKEKUFBf/k91ml1/RB/XuxDqNwT9sUc4YI2VrjilDiechrJon/4Ee3r8xccNj0tK0Dn0QS1928wvVuvcdXjC3V3aoSP283NwZlM0/KvXgK8b6xLqJZ8yeIWRPV8ZEzUvhHJn9wxtsc7QYOtF+0anaDmbyFt+1iNSbS/7tIeOU5YP6raVubUhXeS5yTC/HK2o8qD6vLzTMGACYzMmp9+CTIjRGm0DVp1i/cj5n6Ln1FGNCQTjTBNGb3orJ3FryNXu4AXkF3ydW32HFRasNytCK7quvLXr6CHmAXKR5OhyOAUWEYu/NA6D0MUTrrtAxar6aWdoNJyk64vhybwgv9n/NxvZyTE2H6i1rL6uQ+ZPM5eByxuN/6Punoldn5z5CFZXHmN3sEYJDbFOVG0C9ut5jY6zLIxMkrLF/nb1RJzSu5qsyT2HM7+BPLhS9UKEeNhd9BDgWQU/gy6DJ9NIFQDmPeWj5cbUJDvxjnaKlbJZqgZdLkzfeAtgAZIpJSgaCgIvZq0ZCjUPgYjvYp7j0Q3xMPDi7Cyzige2aiGTqTeVzaQL75BiIy58c0dxniywduONcJMaDOCdqR3S2VpsaP3f0z3Cx1QQEr8Ft+Gs
 5H6p11B6
 MMNcZk+McQ7ZGQ1RgWUh8bxGVlxrSo4cD3bIrR/GvhiEx1tukZUxlvHsH9Du7OssxSd0CktFqDP6SKp0rQ94Mg+aHO/0iMd0oEiRGFnyXJxxwHdE+C0nWvyQRs8Wcob5o6viuRPBfwEEUgXZY8UlMtsgPuN/NGbOf8SyR1liAStZAfsQCmsQPUDLtmVP8ai6p7+NDK3FyUmbqBef4BWkqTrMWxZELQMSGGW8viEaAkVEp1qQwI6gxlACMrgixPe3WI/snqwjpEVPfyI/b/Wj6EHJ1OrqGXFppJQjqGNYK1Ql7ScA5Le3gg6Wtu4VV4DwHyG6dYYFzsxZ6BrVDiH7tP4x4uZRYAPp6teOWS2uwAbaHvAtjnJ84FCJRY9JBB2jYsrTSw7xiumTaYDevSfJYPxybL4Itq4QK5s4ioALkLBPgulX2eLa2wWVtd/j+gzk4jKQKscKWevGbFF8ID4kZEw5IMcM1e6jctkmhyBhXsw165pBlhN+ljj3izqeI5Dmxl3VFkZlwRQN0lMpxquq4YRmx9lx6j2Agv/M/P499z9CK9xZv9OR5Hio2DPUJnr6o5RwJY3Clppq5EIvhomH8iHpnMVxSxG6PSA4kgxxeG54e7G+b7XZzeiNZ7xOk6NbiXlWStEL2cOvR+D3hB1mp2OCj8y/k4oYHGfu0748pNosCFO/CLZ6H2dFEQuqBBdEidMeu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Thu, Jan 08, 2026 at 03:46:21PM -0600, Michael Roth wrote:
> Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
> go ahead and document this as a requirement. This is in preparation for
> enforcing page-aligned @source_addr for all architectures in
> guest_memfd.
> 
> Reviewed-by: Vishal Annapurve <vannapurve@google.com>
> Tested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 5efac62c92c7..6a222e9d0954 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
>  :Returns: 0 on success, <0 on error
>  
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> -provided data from @source_addr.
> +provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>  
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> -- 
> 2.25.1
> 

