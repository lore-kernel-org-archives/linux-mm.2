Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A27FFD2594A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 06:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061F66B0089; Tue, 27 Jan 2026 01:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022996B008A; Tue, 27 Jan 2026 01:13:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FFB6B008C; Tue, 27 Jan 2026 01:13:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9FEB6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:13:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FA431A0ABB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:13:31 +0000 (UTC)
X-FDA: 84376727022.22.1AFF260
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf11.hostedemail.com (Postfix) with ESMTP id 803DB4000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 06:13:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFLaPqpV;
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769494408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jThVnY3d3Nx4aEx/SnN+Zo7LyGP+bw19VzlYkYbQm0U=;
	b=IS79eDSv83Q+MQDGlCi/f5ah/c8wAE0QmdvFqEQhtXtLb2hCIRfKUarUj8JKRfvV14x7uY
	CI1GYCsKsc99ryLYilZbwjToDdc6cPCM6Ibqkp/t+hjoqTWNGNZK5d/GW6rdc0U0JlX3mn
	qKQEqHpiYHPZBAGl51pCNq3iXl+leRk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CFLaPqpV;
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769494408; a=rsa-sha256;
	cv=fail;
	b=ej3kMpBEJxQpIlGP9TzputMdp8+1YUasg0soa4QhusHeCqDcwXWpCdTiscLqWhRGm4fa7r
	nuonqHDttRRMq508hHZhl592jdJljYKJDcC++oR6siyCNUqfa9F0lUQZI20/fAa6JTS32D
	hrKzPezzQe50YLymMzMTFJd8KU9hUJY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769494408; x=1801030408;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=UYX8j1/6GMXbYzEKXW14ZovkY2dyhLAK+IHFNlSf6dA=;
  b=CFLaPqpVEOxcXzt9hkp66qq7j9X/pQke/ZTPqhn5FfaNlvu+FlGiDJEQ
   +pYH5plvO3YbkRNezulnoEDDFm1wKFqAQ1qjLTciKpsTAcKNH25C9k0ZB
   EkF1ccYeooET/zW6trWNb/7NYG7X5blipnq82Tnlutf4rQM1ey61smslQ
   jHmBMCEdoa31IoeDsoP3KH9qv0CR4q9/yveIMoDeFv6lAKutlEF3x7dOM
   Gm71hu/AwfroN3VH6S0aNmjmXyyCo/VrGdQNMK4eXR9QuXpjE5uyIMsgc
   6Km7zuY2DwdqCMuPZNM0ZARkMNeoHut8cKfvbi/1WRlPW5wQMMA7BbvqK
   w==;
X-CSE-ConnectionGUID: wkqpKAsMRxmjtbs8l39HoA==
X-CSE-MsgGUID: 9tqJp6VBRn6SsKvYOWu/Fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70583074"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70583074"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:13:26 -0800
X-CSE-ConnectionGUID: 6DFLrsnoQ3moutIWRS9OIA==
X-CSE-MsgGUID: 3y2d7F7iQMa+Sh2rEOrLnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207121670"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:13:26 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:13:25 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 22:13:25 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.27)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:13:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mE5sjocgHngrWoMAmPF8wDVFKxaH7RekEyKfn4iZAf46OUmHEshr4Kjhzn5Rm+sFnjle4e0YTu04n6pC21ww9QBoJuqeENa7ra4ugaBY8BGXHnlyBDHsrd9nclpE4snNFCvgvhF8TF8IRPuC/jS7iIE1Iwt8Nb6InJEl77AvQ5OcRV/ZjAx5b05QYFXRnG4miaw9O3ZDtZzEp4dWj81ZwwQviU3JF+fjfB9dXWfHNQSPLbrddwYuS0ryrswyxW3kmO4E1otLhbq91/iNgcWwGlMmnyaLDBL3xFvm3tE+AosoPm97gtKS+Z1aunjCF/OwuvlZMo3er+OCVCtqkd/IRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jThVnY3d3Nx4aEx/SnN+Zo7LyGP+bw19VzlYkYbQm0U=;
 b=R/txTrUVTMjYXbgLprAkaxwRWkNPBu0VmZ4jTZMXugoFSX7rRiBp2MysXksEdF1AWIh51gyJxGX1ym1CcxRpgebYKwzEpv37qJhXFBOTmPCFwQKHU9bqD7OtpyRYu/658unJs9zp9lc/+aHMav/q46VVnVComQfjTnkv3w3j29QSeFnOUfbaGIf81UznE/XJ3mhMBrf5fiID2wClambM8SDob1gftriRvWt3A2R8KM1wBm8JHHHJ8NRVYVaqz7vGeSYuyS5OGU8ocDuxtQoCEYmsj/E/kgmzReH2GcYPLNXj2ySNS+wCU6xYLaFOjOCcNDpVxPfVo+V8M+GwBakAkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SA3PR11MB9509.namprd11.prod.outlook.com (2603:10b6:806:47e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 27 Jan
 2026 06:13:23 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 06:13:23 +0000
Date: Tue, 27 Jan 2026 14:13:11 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>, "Dev
 Jain" <dev.jain@arm.com>, Jason Gunthorpe <jgg@nvidia.com>, Liam Howlett
	<liam.howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, "Vlastimil
 Babka" <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Damien Le Moal
	<dlemoal@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [tools/testing/vma]  28d7ff9930:
 ktools.vma.make.fail
Message-ID: <202601271308.b8d3fcb6-lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2P153CA0035.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::22)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SA3PR11MB9509:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf63d36-f727-4b46-6680-08de5d6b2d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UGFRb25kc1RlblRIZDRWaUhTcFk3MGpjUHY1YlI3K29GNllUUGhGWndlYk9S?=
 =?utf-8?B?VkVJTENsaDZQV05sTExTUEJqQWMzTElOQ2JNSCt0cndHd3lSSXFVc2N2a1FS?=
 =?utf-8?B?SDdHLzNpNXVXWThQOFJXSjB4VE1YNDhVMmJjRndSYzIrcHQxZjJlL052UnV5?=
 =?utf-8?B?Ry8zcnBua2ZzRkEyNThJQXkzNzl2V3BKR1Z6clFDalNXNGxZdGd4MlIrYUZY?=
 =?utf-8?B?T1lVc0VBV0RPdlU3WFNvL2NQZnlPTnVDK1ErcmFKSWJ5MjRLaGRGQ1pWa0NO?=
 =?utf-8?B?aXRPclA5VzA5OW93NkN3dkFydTFiYkxsQmtsNkcwcFdLdFVxWmRHbWNtNWdy?=
 =?utf-8?B?U281YVhWZ2VQYVE4ODhaaWtld0hTT0ZBb2g2Y0NWQUNTbS9GOHRNNk9EUEJs?=
 =?utf-8?B?aDJhMzhaVkM0MTJBak9ESTBYMTA2SzhEVWpSUks0amtiOFUvMUZzRWMxOENM?=
 =?utf-8?B?c1ZodThGNFh6aGhNTDdmMmJzNFMrK29VRHVKZnFZYzZQTTgxK0V2K3pqTHZ3?=
 =?utf-8?B?MmplaXhEeW5peEFCbDhHTmg2VHFpZ3NxVzN2d1BXbHcwbnBOMnp2S1pOakVI?=
 =?utf-8?B?aXg4ZEg5TG0wSVhzbXBkVU8ycTRNUWcya01LeWdsakZiK0s4ZVBFM25jNm1Z?=
 =?utf-8?B?MlN2VUw4U09DTWNtWGhWdWdMRGZSNjJZcDBzNEhBNXFoY1hQaDJzWnE4UjB2?=
 =?utf-8?B?TXFzYTZFZER4NTVrdUtZN2Z6ZDNQS0t5ZXhVTzhpejY1MFhFZE9nVXVwMExC?=
 =?utf-8?B?QVFiaUtTMG9LWkN1cXhYaW8vY2JYcG1ETE1WbmwvUkI3ZVU2RTVlTHBWOU5J?=
 =?utf-8?B?VW9PdE9mMXdweGc0QjRnUXFVWlprWDVCMmRoV3p3R1VlakhGWHdBMHhFbFVQ?=
 =?utf-8?B?ZzJWbmdpOVRyYms1UXJHajNkcmlZZDZPYk5teW10MnZtQnZRV1pOdmt3OHBL?=
 =?utf-8?B?YlZscE9iSXlvTnlvNVB4SjlMd3BoQ2paRDhJZW9SeFEyaGk1c1dIelVMdERa?=
 =?utf-8?B?bzY5TDMyMzJFdm9veFFXSHNBVW1oMlUxUXFVcXA4RzFFVXloVGhHNzdoSHFX?=
 =?utf-8?B?OEozUDNVWEpVQ0xYT3hycllxOUZBOFpCeW0vWkxsTXlURGQ2WkRMaUQwc2hQ?=
 =?utf-8?B?SlU2Y3VCME9nMm1CRVNLZlJ5anlxQmhFMmloZ2RYRjNWcG5VVXo3Nnp4aHZt?=
 =?utf-8?B?aWxKVEV5bDZGUlNqZU9JeUZXWkxjK2dTaTRiWHREbFZ5TWRxKzR2RUpMSUx5?=
 =?utf-8?B?UitvTXJpbDdnS2JCOE1FWnVad0srcThRTUNqT2ZDMzRIWDFFa2NCUS9ZUW5v?=
 =?utf-8?B?aGhtRWQzbVRkM2krYUNIYnUyTzROaTJINERDSEpnVTFtT1ZNUnZpUEYrb3dK?=
 =?utf-8?B?L3BMQ2NlN0VFcUFFKy84bzdGazB6SkIzOFdkS29jeEp5eUNmMUxEcm5hYm5F?=
 =?utf-8?B?UC9leURxejZWRGJ1dVpWWU0wbFQwbTNHQWYwMkdhTDlVV0Zrbkh2RWxzOVhW?=
 =?utf-8?B?dERmVE85V0hXcFB1MnBlL29DcUVWT0RXN3laSTNXWUdzd0o1azNCMjh2OVNH?=
 =?utf-8?B?czdyREJkUGsxSzJBbHVXZUdwc0RxR1A5d0lRSVU5V0NNZmR4cmNQQnZDbFl2?=
 =?utf-8?B?dS9hZDdLeTdVQmF2bzVZUTJILzFENHdVOVRLOEs3Z1ZhdEF1dGZuOEVQQkxN?=
 =?utf-8?B?Wk1GYzlrdXAzS1M5UElOY1ZzZGV5WFJTT3VBN1BmcDErVGxYQjJ6Rk5MeVdP?=
 =?utf-8?B?ejBBcHorMndQRjBxeWR2T294NWFkVFRNQXN2NnFSNUtSUlJOc3VpSHVlZHdJ?=
 =?utf-8?B?dU5OUzJMWXJDSnkzRkFCRmd2SjVSdHhYN1VMUmh2ejQ5WVliZzBGVzBnR2o4?=
 =?utf-8?B?NUZVVUdUWVhHWUZhcVJsOHQ3TWptNElHbDlEdi9DcUlyN3RRc3AxZmY3M0dF?=
 =?utf-8?B?cVg5aEVTcURUdTltRjl0akF6S1ROK3pFbEJ5RzBHb2tjVU5IQVUvc0hKMHYv?=
 =?utf-8?B?VGFBbVgyOXltdEQ4ei9HZ0w3c0ZnU3pQMm9TS2MwZytSNElBNGJ5Sk1leXRJ?=
 =?utf-8?B?YU9udTVRNnhLYUpwREgvZTFtUy9IT2FEVkVHbzIranpiUW9DVzkyN3lFdm11?=
 =?utf-8?Q?1yWsObYW+puuyXGyGiBt3e57Z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clVScjQ0c1BFYzlmbGhMa0g1TnUvSDNqRytINnIzSGlvOFpzQ1FRblY2S2Zk?=
 =?utf-8?B?anhvUm1STFpETDcxSVJDbnBuaWVYQVRrMFVDWmp5UklBYzVvY2FNZiszd0s1?=
 =?utf-8?B?MTVSeE5qZmNiSFlSeHk0cUxxNS9oOC9WYSt5b21WZmpEWmo0NEFBK1BSTERH?=
 =?utf-8?B?dTkzMzJCQkpxbjJINGxiRzZ0QWJaL0JQN0t0Ulp5VmVsL1R0S2ZSSkN3RUNy?=
 =?utf-8?B?b3FwenUvTWJvbXN3M2hsQnJNODRiY3FtTjcvVEd6WHd0NzN3UjRRSDBkeU1w?=
 =?utf-8?B?Uk1YZzhqbHl3MjdSYWlwNXkwOUJhWlh3MFFMZ2d1ZE5tZ0ZFWFU0TGlMWjJI?=
 =?utf-8?B?WERJcUFsWi9STTlLcW16UUpGSldLcE9jYmVrT0ZCSFNPK2NiMlhqbzB5MktW?=
 =?utf-8?B?MjlXN2NLOS9WSDh4dHQ2WVlMQVFSZ1RXcE9Bd2I4SUw0bVI1elpzVnVVcjNJ?=
 =?utf-8?B?a3FIWmpUMTRBL3Vsa21VZXRUQlNTTEdTbGRsS2xkUHlBZ29haTlSeTlOK3Av?=
 =?utf-8?B?TDBkdEF1SG8rUGVaWHh4NXR2YTNIRUNSLzREZ0ZGSzE1UXBVTnExT3JqNCtV?=
 =?utf-8?B?WUJ6R1c4cEFUdlNxaTBSeGZFUXR4SFFtdXphOVNBSnVtVFBIZ3ZNaVZUSmw2?=
 =?utf-8?B?cVgwR21OMzBQWUNYTXhCc2Q5T25XbkxrQzBGbkh4YXdqdWVhVm11a0NrbDhE?=
 =?utf-8?B?OVpIc1E5NCs0QXFPZHQ4UmM3Q25PaEhJcE1KTjEyam81UlQ0VVJ6eGFQMjMw?=
 =?utf-8?B?SmsyUHdkNzVJYVJIcHdTU2k1dTJZclV2bzZ3dDFIejBuUjlHMGg1R1Iycnk1?=
 =?utf-8?B?b0dYczAwM0NDczdnS29pQVJROGdiL2puYithUUkyQzJrQURaVGdmVVFSeU55?=
 =?utf-8?B?OG5jbEpGeWNHQnk1bkxoeXRYL1BKNnlFZWFiOEZIRk1nMFB0VHF5YWlWVkRU?=
 =?utf-8?B?Y2JGOTdKYmlQVGk3TFFxOVpXS1FncnhSSmFwL2dzcjRLV0JrRWllNVV3c1U4?=
 =?utf-8?B?TU0rN1RJVU1wVHdlekFKeDNvY3VIRmVhWnBhVXQ3MnBoZllrTlRiUUR5UzBn?=
 =?utf-8?B?NUV5V0ZvWDZGSUhvb1g2Y3RGWTg1Q2FVMkl1R1JyNUpQaXNTeExFeDU3SnF6?=
 =?utf-8?B?cUJpb29RMEFBN2hNWkFGQ09LNDJFMGhSVVF6VjJBbSs5VE53UVZkRkZLeUxm?=
 =?utf-8?B?dEs3SWZudGI5RjVrUDIvU1hvOFlXeklzODRLanlpZDdnVU1pOHNiZW5oN050?=
 =?utf-8?B?R0RIbk5UR1ZXNVZ4ZEZUNEp2cTlqdVpYbmdUeEpUbzRLZ0VuakRPc3p5TUJI?=
 =?utf-8?B?U2ZUclo0YUlrOC85STBhY2huRUJpaTEyZzhYTURqWUhTbjIvc3REMm1YZjF4?=
 =?utf-8?B?c05heTZwSDFML0x3eCtFNFZ3aWRKbFlad0Y5ZFQwYW5NamNSUkFoV3BoRFJ0?=
 =?utf-8?B?NCtkWXBrZTNXcThEQWxYVkRPNXFwNGlmbUFISU9JMGk0a3hzYXZ2WFczTFZU?=
 =?utf-8?B?ZnFnaG0ya2JhcWlhTWFJUUpTR29COW4yanVxUW51MzUvb2FHaXlBT2Urd21m?=
 =?utf-8?B?Mm03RnhXeFJobkRGTEZsUnlZUVVuZlBhL1RQV00xV1NWSVBnWUZ6NUxkVXhu?=
 =?utf-8?B?d3lyeXYwRG9NeDU2MFd5RWU3T0RCYXZ2WEJSNWdaMHAzdktVTjFHWWlyWmRm?=
 =?utf-8?B?WFMrdmdoT0h0T3B2a044ZHdxVWtkLzlNS1Rmc21QaWh2djlnTWptTUVzU1Jh?=
 =?utf-8?B?K0VPbVJPSjBFbGE5Y1RZVmJOc2VPSjhNUVRTYmd0bnc4dnBRYVpqcW1pQ1J3?=
 =?utf-8?B?YnMzekZMdjRwZ3BTazFnV2RnOUZaWlNqUWZDS1hhUmxNMWZjdi9HUzRpM0Yw?=
 =?utf-8?B?KzluNFlxUkdnYXNyUGFKUE5iRTh4ZjRWcGFWcUFnR2k3cnJheGh5cytkYUl0?=
 =?utf-8?B?SUVVS2FhUnFxOVRHdVE4emlKZUZaeDE4b2NKb0VyUVFZdFU2QlpDamh5YzZj?=
 =?utf-8?B?NExQd2R6SnZtY3ZXUTFtd1RySm5JS2dqaXlkZWZEeURBY205akpkYnVzWFRM?=
 =?utf-8?B?QU4yVmZ4cFRNYmh1OWJ6QzZDeHlZSG5tTHp2NEUzbGd0dFNGbjZZN3lNdWFz?=
 =?utf-8?B?aTZ5NGlvMFc1SmU0OXVXRW1TcG1uZVVycjhwMHdsTzZhVWVZNkcza05MUnQr?=
 =?utf-8?B?djhteGx0WWM1emFSVEg0MFBpZHg4NjdFWG5LNDVtWUJJUkg3R1NaQWZHUGQv?=
 =?utf-8?B?KzA0bGRjSVIzaDgwZGUrYk5hd2dXcjFoS0g3MkcrQUkzTHF0K0ZVN0lXTWZN?=
 =?utf-8?B?TXB5azVSSzlsMThRcXROSGhBejVRVU9nY0Y2NVdqWXAycWRMZ3BzUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf63d36-f727-4b46-6680-08de5d6b2d48
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 06:13:23.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3OhHa5zvYEcol8Ma519kd+zZmdka6M+M48IYE9g49onB2fNF/zyvSeY0yK1R8IuW/s6YxN0Y4yjw2mSaEjTdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9509
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 803DB4000B
X-Stat-Signature: ac1onbuzmm1s8kno3a7m8q1yk99faaof
X-Rspam-User: 
X-HE-Tag: 1769494407-331269
X-HE-Meta: U2FsdGVkX18vVco8vILV22WvcX+wy6SXpMd3A4MtUncMMNUNEhPkwYVnV6J4R49lBF1U8kFisAG3W9BYjdYrD/9n2uod3BTW5snf8FUssT2IaJscPlxXMYhZ/2fJjRR3JFBAJvvIetW9/Ghhlb5Op0MK/iFShYeZ8kimw/0gaUUnL+Lj6L9dGWWJKDDTkndQ6lSmWdzKDgLrl4gJ9RmVkg3owPkLQ1k4U4LlxpJkqtqpkSC6seGcxufb/M62pn+88lZ5hwHSJVTdZqNowKSP9hSTVOyFOc0RSCxBwmd0borHe/GnXj7IKnhbZxCPY6vjqosl2rxeytjnbARU7u2RjuJq5JJqA+SrlA1nG/6DoT4Afodg0Tr/LXXaB/lFYQiwiJbNb837iKxt1CvBaa3QbuUyCCN8MXvFcgC5rv9UR9VZVNN2pbE8lfyNzUjqlLb6cLr0Xym0Wdw94QMHVLyIqkOvr0l8HdwC8Obtm0iev4Yd2viibdmkZG751a25khdNypb0/dUcxVBz4xJZ6JT7WkLdmCy3BfqkXEbLImOG4HloXIyqoGOIbvBTRFJ6xABAIzJIWBHM+lRSFAtLsdX57HfnSiuhdSsmvVTjJoaIHEL8nhhe7sHxwCmE0B/BFzFDcz78Zm2yKPlSMFbvYrmhb8A6SrveTxowYk1uhLG4QzzTGAqyfwHyOFTn3FhpD4DMUrJk8zWJxTA2GWsoJkiwX21OvSW2zVnhzXDbtHLNfxJLo4Qkj84oh93tmI62qjz0I2AVDcw+fKOeu//s2ti88tghDQEz/sbo5P1dA6OriuLm/+CjvhXtf3F2/e0qq6MAo64tYiOVm/RK9+a6Pl7zxfwCpRcLUlOBbsXcwICejdakRn7qdlI+LBPT3zWJqwSs9bQYfQZtnuE9QR9Hjx0lI0qJmENVthNdt5mAex9g33E9xfd+Yn0bxn/CnZVYrLbnx2LDanXI07bWt3fKj7s
 tqpnXave
 xyspOXieEcb0gveA8fCsCqLTrHzMhr/k54ggwWNcsfaxoZozOk/pqABQuur4PWyYhKzIGBtEMEzo4CkpRw54H4oJ9o9eVQd11tcgeaq6D+ZPtmhF8b/WbP31gWSQDxhks8HgGzHkHk0w4Wmug+vSiiaP0O6jqptCQ9HbIdptGCLtt6ycDK0v9z4tTg7iCeipYbeBoqtJbTaEE0KirHdYbqgb/FuE0ZWJGxNtmU8h05ZS3AWnzPDGY1jh7h3A6pMtQejM3voipH2DE3Ac9t/ohDSUC9GoKQCaO+2ay9U2hyw4bCEAlGV/YgAmIKNXWU82H/JzmUb8jpkG288VBtqFF1FxXN2Yp7vfoWOATBuASyQBHVsQ0cQQsOvKhjZnKxi66CRKOkDrjRi7U6PQyGcgqQTbifK3m+XkmBpECrlB9pPJcjpODEtZqgmp3iPhsI8Y3Wao+Mvl8xZQmQ71PzpkftUTHu13WBvLLDc4B1ayXmkFOqgzFvMRo5dP4kpPryHh+xMrEdnbxQbhnqo8XGSskmrCgxkNBdSEQzHSvsDHalRP4G4JMH03YLUjSUq5eczIqqXIOHkEsbQL8pjWEk6c8N8qtGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "ktools.vma.make.fail" on:

commit: 28d7ff99300f3a897eb6419efafdbcf96978f637 ("tools/testing/vma: separate out vma_internal.h into logical headers")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: ktools
version: 
with following parameters:

	test: vma



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 36 threads 1 sockets Intel(R) Core(TM) i9-9980XE CPU @ 3.00GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601271308.b8d3fcb6-lkp@intel.com


KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-9.4-func-28d7ff99300f3a897eb6419efafdbcf96978f637

Generating generated/map-shift.h
Generating generated/bit-length.h
cp ../shared/autoconf.h generated/autoconf.h
cc -c -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  ../shared/xarray-shared.c -o xarray-shared.o
sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/radix-tree.c > radix-tree.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o radix-tree.o radix-tree.c
sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < ../../../lib/idr.c > idr.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o idr.o idr.c
cc -c -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  ../shared/linux.c -o linux.o
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o slab.o ../../lib/slab.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o find_bit.o ../../lib/find_bit.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o bitmap.o ../../lib/bitmap.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o hweight.o ../../lib/hweight.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o vsprintf.o ../../lib/vsprintf.c
cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined    -c -o main.o main.c
In file included from shared.h:12,
                 from main.c:3:
../../../mm/vma.h:158:8: error: redefinition of ‘struct unmap_desc’
  158 | struct unmap_desc {
      |        ^~~~~~~~~~
In file included from vma_internal.h:55,
                 from shared.h:11:
include/dup.h:1331:8: note: originally defined here
 1331 | struct unmap_desc {
      |        ^~~~~~~~~~
In file included from main.c:10:
../../../mm/vma.c: In function ‘unmap_region’:
../../../mm/vma.c:485:26: error: passing argument 2 of ‘unmap_vmas’ from incompatible pointer type [-Wincompatible-pointer-types]
  485 |         unmap_vmas(&tlb, unmap);
      |                          ^~~~~
      |                          |
      |                          struct unmap_desc *
In file included from vma_internal.h:54:
include/stubs.h:391:74: note: expected ‘struct unmap_desc *’ but argument is of type ‘struct unmap_desc *’
  391 | static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
      |                                                       ~~~~~~~~~~~~~~~~~~~^~~~~
../../../mm/vma.c:487:29: error: passing argument 2 of ‘free_pgtables’ from incompatible pointer type [-Wincompatible-pointer-types]
  487 |         free_pgtables(&tlb, unmap);
      |                             ^~~~~
      |                             |
      |                             struct unmap_desc *
include/stubs.h:395:77: note: expected ‘struct unmap_desc *’ but argument is of type ‘struct unmap_desc *’
  395 | static inline void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
      |                                                          ~~~~~~~~~~~~~~~~~~~^~~~~
make: *** [<builtin>: main.o] Error 1
make vma failed



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260127/202601271308.b8d3fcb6-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


