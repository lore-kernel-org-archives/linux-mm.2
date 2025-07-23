Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180F7C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 06:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5766B0093; Wed, 23 Jul 2025 02:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485FC6B0095; Wed, 23 Jul 2025 02:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325FB6B0096; Wed, 23 Jul 2025 02:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17CE46B0093
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:13:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8593CB9F1E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:13:01 +0000 (UTC)
X-FDA: 83694511362.22.7A075E7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A53B180007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:12:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SyoXjcjt;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753251178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=p0AK5XVi1f9rNaPidVf8WutGrpovO2W7C84f1vuqZYM=;
	b=iKdLOFXQcVlQoNgNLDWTGlO2NPg1ERCdbOGbj/gcqSDMfhDni+HsTTd3al2ATsQjdyqFxN
	DVKzMasIAUizb6WLBUfAtfCpFQApYR9msfF7HrD7P8ZZufERiU4S87CwotaTr8jOkfWyyK
	CNuZNpqUUWg0VitvcXQG9ZIOtTW6zbs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753251178; a=rsa-sha256;
	cv=fail;
	b=Tnj9mggZ7fB7CNBTtlWp00bzipPEZwvVMOVcBC1Rj0bREBUn1Tg/r9W8jqaFYYBC4qD6e3
	45LhoSIFj0WH2iHaN+B+uniVAXP4B5YSCP5lgGwZ1XQxBx2V2u+8h/23nXO/SY6mga+l+n
	MVPaEalVdTNzP47ZozGp9ZLSzyHUCNY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SyoXjcjt;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753251177; x=1784787177;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=wLJO4jTGY2JbzrFtNSdGzWdhYRCN8KSMK852bQdP4T0=;
  b=SyoXjcjt4Q7CnSFUFkIB2duiUmt4kXpmCU71hLZCs8lPRicRVw4vkTdx
   LMCD7MVQ8S0zoU9lQCVLRj8lHgYWso9BkoPCXxybQm7zyxoF4MfDX4zwL
   K9B/xEKRKPIcdVluINRW6RkxT7TgSsrhZjNkxWFliFdIwfIgv1/zobEAC
   kqKTJNXrL3Ii+osZ9nYx+STDNJ7qDbSwINfj5o5rKcrlqNAViqynL0qOf
   G2wXqczj2Q3p6VjxKSwqlZUeE7kW+gtEHvC3YHTso1o4zSTymLOfNtvpu
   uRFqcspy++muRB3fgujt5QRMnMfXuhjDcI3Qq+noeidZ56mcr4cMwLAM3
   A==;
X-CSE-ConnectionGUID: uBXniNruTL+UFsjBoWAONg==
X-CSE-MsgGUID: iiM3oEMISx+kcM8td0X8wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55618679"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55618679"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:12:54 -0700
X-CSE-ConnectionGUID: An7gzMVHR/eZIlbmVfe34g==
X-CSE-MsgGUID: qFvn4ocjSDivIZ6qA1ZBFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159443748"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:12:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 23:12:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 23:12:53 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 23:12:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2mpbcY4eHHGzuqNea+mKS4AERiDkq+xmIQLisDChJmOWq1wudP3M0xqpH84M3GhovuWD5jq0NwarCBRcoG2XSAWh9ePnLGL0tC4soqeUvB7oC6k4LtlohhpgyaM1B0t9p6JdIqA1WsdPJbboC3+mM/BJnCCQ50AIViK/8JM9V/TwVnR40BOh+duWwRdjguCYgWp0LW5fxdihSBj4kIDZz9FwDhHHD4LZraRot69orxvFDtHOs00KgC1HZmPF22B4SUtdUso8vRLYN1TsLBegf+8hTWfhi9xqd3LeD+MRRzuO77HZcvQpDvCH+OK3uCAgO28VzvnO9lWQ/4MkTG8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ih+W9Q2Tkbcvv/fmFTAVKExyWCDrQZC430umpbBpkj4=;
 b=XdAuhCZ0Z8+AWXFqXzhGRPqnbCf5r3wHJ5V1qn3xzn+NekTipBagXtdlcNRJFCSFULPXKS5dRapa4cQFxxByDEKvCTOA1ld6qbf1vFAK9+Le2k7xGFL1JvGEyr7MpivVIiwH5fu2QOiC4MNvmrFT6xS6WsLtvwYrw8uuOofPtfQ+w3ACdKGJAzmzjquXOH6bZTqgHLYdVhE67FuWzRHuuteU3Ic3iF7BAqVNQyigYKRjnaQcBICm96nLX8/QwfgsK9BQfzix+JkOQDtWsrBRMIrmHgdgNVm00dsOnP4JCadvYZw4JYtpA77qWIqhd21sezELjLeWWoR6DFjp7XwHWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 06:12:35 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 06:12:35 +0000
Date: Wed, 23 Jul 2025 14:12:23 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Barry Song <v-songbaohua@oppo.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Qi Zheng" <zhengqi.arch@bytedance.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, David Hildenbrand <david@redhat.com>, "Vlastimil
 Babka" <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Suren Baghdasaryan
	<surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>, Tangquan Zheng
	<zhengtangquan@oppo.com>, Lance Yang <ioworker0@gmail.com>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  a6fde7add7:  will-it-scale.per_thread_ops
 176.7% improvement
Message-ID: <202507230728.21b64efd-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DM4PR11MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 881f78fc-9559-4668-f970-08ddc9afea69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?KzcEdzqvZkU+8ug4dfDEvBSvwMrSc4vA82kfY1WB9YfpeBDAN2pEkrqjK6?=
 =?iso-8859-1?Q?vvQMd5EPnMpnWlGtDsLdSVPISGUhGxKxdF+TbuRfXZHTwwq7ejBL7Lr3oo?=
 =?iso-8859-1?Q?eJHQaqTgWVz3OmNLaSzXgHbRT7ugVQS5mciXY05KhTpk7qfCym1LmksXp8?=
 =?iso-8859-1?Q?vT2cpV/q2R+fKqaAbnGHfcb5Jxpj8RETrd7e47LhIbUon4d3578peEaCte?=
 =?iso-8859-1?Q?kr30VYzCZv1JvUSlgCgEg9g73bhu/Z267w99Y8WttQHCZbIuPF/i5F0Z/b?=
 =?iso-8859-1?Q?E+z+8PdimCWwmMHNxP103mFXXUxx7TZv8vyO9/p1Rf5ZehxLGGvmm3Pc54?=
 =?iso-8859-1?Q?PtN1DT/rpOOIptjR9vH46OjgAqqGfRwJbbuqbllYXSoR9hBW5QMg4A6ApB?=
 =?iso-8859-1?Q?0f+cm5VGGkRMeYMcHYapowAFB/wNkWorogN3xFc5FJRAXoBz4yPbnw8Czf?=
 =?iso-8859-1?Q?fuxUf5tJMgtYoV0BsMzL3kp2/RiVXlW0FvpTV7SeoBWXe9GIN65TJcq368?=
 =?iso-8859-1?Q?47502l1EiFPIAzj9VVT7QJBRfCmAoBxYnknN59JvTxvO/eM9D0x/PykQKH?=
 =?iso-8859-1?Q?c6VxqCFUO13vSDXYOddHtWOIue9wM0osL/qhZArXIm7YRsjGTGje0480f3?=
 =?iso-8859-1?Q?r1vcvf/DCVIgeveo80zJNinTZIoNF5INIG4RG4gUK1KLxRDKtKtfeaXRid?=
 =?iso-8859-1?Q?m9QETgqePsbwqc2mRbto4yQpElsABuoR7z2dn9Gn+hinCr74hEYyR7KuMR?=
 =?iso-8859-1?Q?wYsAwNp+n/o57BhequDu4B/Egc3iFqC4zZ4V6BT5/6woXoDdSu31Kna5cy?=
 =?iso-8859-1?Q?l96nm96VpCRUxIHUjfuKzEiigQV5k3JrjGYaRKV8t+/hIN5z2MVEkc16dR?=
 =?iso-8859-1?Q?aKfaNiYv5ldktzVrh2IToe6U9yzFbQHbVgLiml6nO04/B/ps1QtcWx4G1b?=
 =?iso-8859-1?Q?o81g5/H8TNsoSeJpmKMbsFypUcwf0V3WDOZis401VFF9QN4l8iee7JgDIH?=
 =?iso-8859-1?Q?p0M7Ysml9X/TWYp5kAt9S15GHm78lapAuCJqD3kaXXKqOf/kbA2TXGr8qB?=
 =?iso-8859-1?Q?kufDXfgZ5KQHBtiXNP2IhQLQfVqxQsN/mseuYQWNLNc4ThJco18EFDAe/q?=
 =?iso-8859-1?Q?hJjAgbGfwAXNYH4+H0tXTLMx4FFo2XOgS2KRsNm4pGZarKMUdbrJy8fs5A?=
 =?iso-8859-1?Q?vpaYJYKhZFVvmAyykJKw5JMP9Ct23P/b0ETYy5WqNTob+m/6q8DCJ05nbh?=
 =?iso-8859-1?Q?R8uZp4VX8rW2/whHaRjOkpDbEJLGtA+f1Lgt5bIZ8ZZYJVNjNtSjZPs90L?=
 =?iso-8859-1?Q?GfBqmwmtkJIy9txz5guehPIPvGrhFykX3xFf5vU54QhFB/XpQ5OsZDDW3S?=
 =?iso-8859-1?Q?o/56Z1msbhq0ffpUt3uB7TewpsL8QmEVBDRKcG7h7VnBmglfmX8pcO9Rmk?=
 =?iso-8859-1?Q?200efckHkricXDVI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ABj5DTuGu9mlccaH9v4uZ+USp7toLWgECCE1I94abOx9vbu+6ngG+/ankX?=
 =?iso-8859-1?Q?88boqCgUagCna7z9MbQBceRUzqFlAM/UIK5NGV1ibAuZ9kHrhTxMS2h6is?=
 =?iso-8859-1?Q?aIemfbRhTAMJkJcWlnsEWTQt0M0WjV5j0ByCGA7crSDmekbvJRaEqF6bgM?=
 =?iso-8859-1?Q?yZeR2b67V3T+aY71+jYpXpB/P5HrYKkQjH6YtA25lDs940ShC5dPQ5RWYL?=
 =?iso-8859-1?Q?DkYScgBzPTQvHegWSeC8DePLap8h6NJE3aL8hN09hh7efG9XL1yIZDad1Z?=
 =?iso-8859-1?Q?5vT/1YDUCVPgV+hBB+brmh8ufec219CQ8PHAdan2L+e5ziRjaWjC4zHk0p?=
 =?iso-8859-1?Q?ETgppX52SYjRmGglHZo+NpJmRFqm/NyhDZT51O9vGxq/yP7kn7hr5G28tC?=
 =?iso-8859-1?Q?BYBoyhoHXIH5GvTl5sYll9m3FpyXKZkfHbQpZmfZ+1wfsXx9T+mxsokeCj?=
 =?iso-8859-1?Q?hNIn0SXgzrxU9xw7T9wLg+ULRhl2vLU8yMOA7IiFiLutsjtU4fcX9qUj78?=
 =?iso-8859-1?Q?XLbBT8CuXFB5x+I80XZ8A2HI3+hXAyrb4zYH0QVE/MslpgzUCNrRWjSkuS?=
 =?iso-8859-1?Q?dsyuKACuhcYuT2V1+B2ZNRWwaz+MYatg28PuT2dRR6/nOB5ZTB1SSWP/Cb?=
 =?iso-8859-1?Q?lWqqIfcdwRrVwrJHAnGcHu2J5mkdkhlZIha2YV+4d4Ga2IYD/EdV1REcim?=
 =?iso-8859-1?Q?ylHqQo4ETjvzepFseilSnMZlM4K/bdT/vy3S9bOvpEHAJUM+P9D8l6sysD?=
 =?iso-8859-1?Q?BZt99RNKH0i3wG8FRB9qAUWHeXhfA8sppEGl5DQU+FkgJKSaWgjff39+Ex?=
 =?iso-8859-1?Q?v388089fB+Sg6dJyHXOkuPOE0fHRbrSCs0lHdNvx6XmC9pY/joH1FjGYyg?=
 =?iso-8859-1?Q?SUcdB49dleC6wfFuL3ha6E/tPq0+OB8G6bzKEUE6ajlMkTIwz6qMsjIaFz?=
 =?iso-8859-1?Q?+NUuzNMcY3X8+mo38ZYCVcLyBLoNOcK40vK3UG2KzjuyGQ+1dNA1Ppbzue?=
 =?iso-8859-1?Q?AX0j2JvPjw8wWzgVmalbvA0fRAHrS/sj5TFyTH/4m6KlfY8gxjOXJdAXWW?=
 =?iso-8859-1?Q?tfmqb8BLx5xPJedVzJCX3LPJkkHTLyITl9GmgsYrM7jB8WmJca1IpjYyKh?=
 =?iso-8859-1?Q?cp9PYdJwHzCnjRLSlH/FK6847UVCJ8XH1iPSVgu4Gzumy+MthDyOWu0Y28?=
 =?iso-8859-1?Q?fNdQuTROQ5fiP4bjXR6YYykx9VFtMOHsyPAuFGnykO/+kH14Enw7foYBx0?=
 =?iso-8859-1?Q?G6COn1PNaEre5cu8OpUeUuUltoJ02TSalv6HwmHm89OdgdMclvJU6+0yEJ?=
 =?iso-8859-1?Q?LwWxYNJy1jIHWlB1DdQCaEKfbSze7Z7ju6ES5qqa7EoTmgzz2II+4cxl8q?=
 =?iso-8859-1?Q?+9r5lArapEX4kExFD4ih3iF8e6ipgYHYdHP9swGOiPLM2R7WmRedMlfUZR?=
 =?iso-8859-1?Q?2BJAjmXd8rf3oY4/KD09LUQD5apusFCrg7CnXz/jX7ITg+pyWA57TeWgiZ?=
 =?iso-8859-1?Q?IdBVnyM67Pqo6xhqpbts9W8rjbOiiJodM96/ISY33U5Z63LBsNjaOM9oXC?=
 =?iso-8859-1?Q?5WYTxxCI0kyIbXfJp/3wqL484HwGfm6cuEOVh1j4ZOTzNtOROvyJ2IQrxp?=
 =?iso-8859-1?Q?z5kT+oBjAf/vJlUi6D4DTz2c9bAVfLorRuVJW74NdPOf5N254W86l+uA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 881f78fc-9559-4668-f970-08ddc9afea69
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 06:12:35.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ywvGzaq0Y+NM3rmhQOWu2NgNCaV/veCirtpA0TD+fhfasxnyxP5aTwkGLje6ru19COcX2Yn07IbT1Yz7nu/Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1A53B180007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: st66fyempqo5bbz5jgxak9tgwp566en3
X-HE-Tag: 1753251176-641935
X-HE-Meta: U2FsdGVkX1+WkQPGgA3rtbmEYvspb0Rqv4i07VaBCCxPu68ogienyzNulb1si08AvHcApkxFcc844QZaDDIoTyCKG4wcS/nHmoU/hFdd6SW6uP/yuDKKy8Ktg56RtRkkleaGFFGyY6BRSd9J3dKZQZNM1u7PIoRditdWFNlPURLOdXVkAxxbR3RMkYURg51H1LypD6RIgiBVWLoS6UP4Vbrv0wuIf3/+AyD157HOg6GXe3W1CdzNq8wcxG4Z2fKJQVpG6dF9Gp71RtAsyOtAcwFIwU4FYogAkdNjD3sTXIxfVly8F4OByvI36B06CaWK5yhMJb8zywPcCg647iEiPcNhSDp1i2gmBolpoQNh9/MyDecL0VrR2Lx4aYir0+TyjzvKRNAUNEeC7iNflQ87stftlGxVVG0TwePcQXEFq/WnuyVfGlkY2RQUbS/cCN/yMDBX48PjZekyTBQdwoxG1MgtYIjahiYMl9orhVa5c8TcfhRh3eBb1KkKI4mdyrBdNZ0zzVM9Edyiivd3YWG2r4t2YyZt0I8G0EQKNuOdmzvZpbDInAMVuhLr1hB0st1uh6MKAX0pCAK0dHoWy3GoLCva/xlJX58q6BGFxHs5ZZtoufcOGyehRa3mtCoApKIjif/OiWT6CVq4t8BfrPaixY3Zi3YkNDaUXNfbGnsMXdr50avombbLUZq3dCSjhTpY2Uje7a47Wc0bWcr+NArn12Pjud7YzaFeedRUmrxoHVuo08mNTf4xtQx6t4fRlb9K+RXGClDe5qROjnzX30ZCii1oKbRoM3ZUkDH4+PcfG8HgSB1rFZ8ISApsPHRDtLj+sXu15PKW5bgjsyJBWxQ5uiDFsh7nsPGPkAiw61PIIXQq9gjvZ+irhJR9xERkzkFLgUOQX5U5j62oeuSWDXWHW2M7ldByinvRDlD+NSrAuuwe7I8k52CFV8G6iKZtU5Tp4Ce3lCNK3T75EYoSHRM
 xkpQT1nH
 KfBOaYOOpHx7xWEKJVsYkCMLd5aO7fi7/IWtQbv49Jc8sFmUX2yWIoSDzmBnGa+YgDoqoPmu9ZFY2o94i8i12NzqVG5aV94vClkc0QGwXifH8DPK89dkzeVOdlzDpLHcXuXaCHjZjxLvxI5AID9hFrzqz/at8VNTX4vGqoKfI//ywBOX7lM9E6oFF7G+tChTgiGEPezh1UjQl7cT5/VsTkpNM4yls/2CJKQ2JOsh+OrVHuRnlAG/WKwDeCLrQWpWiqBPhX01ctH4Ph/gBY9v/zLe2fxmoaZBIpP+bL9pBtyQGgks7oOwggqG9WqSLBQ0uCZT9NGkSoIbtBG2wWNLhSJ1CDVPkILxzhXMnWJqcnGzuQZiWtYIORyqfkb/OXSzLAeCrfXt27IU10KhpG10uLbH0/cadAnanFvqOhrtDicBsO/f7SDAoW9XAGALhzUtl9tl1zpaXcvs+Huy4fzNOtdyLsEhlyPwleErgUbhfaLk3mOiyfrWDTegMSmlSC8oPb0hS0TURsa9zAfHEs8KvQjjsr1db66AZ5SVTXRbXynrEJOAPyIvDheI9jP04u4fwZ3rPY/Cw2p7q2H83Y1cg6KOP8aVnrQw9i5rIcDn1xmXaE27+yahI0Bjt2m58DREX6X9IuE5398/oi+VJAPjVMEo7ayfwpWmyILVTmRbO0uQvKnvTI/1y7kS+DUZoGEs7c74ybJSc/Bt8b4fRMQfRxVgZurljOPGFqI6i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 176.7% improvement of will-it-scale.per_thread_ops on:


commit: a6fde7add78d122f5e09cb6280f99c4b5ead7d56 ("mm: use per_vma lock for MADV_DONTNEED")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 192 threads 4 sockets Intel(R) Xeon(R) Platinum 9242 CPU @ 2.30GHz (Cascade Lake) with 176G memory
parameters:

	nr_task: 100%
	mode: thread
	test: tlb_flush2
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+----------------------------------------------------------------+
| testcase: change | will-it-scale: will-it-scale.per_thread_ops 112.4% improvement |
| test machine     | 104 threads 2 sockets (Skylake) with 192G memory               |
| test parameters  | cpufreq_governor=performance                                   |
|                  | mode=thread                                                    |
|                  | nr_task=100%                                                   |
|                  | test=tlb_flush2                                                |
+------------------+----------------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250723/202507230728.21b64efd-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/thread/100%/debian-12-x86_64-20240206.cgz/lkp-csl-2sp10/tlb_flush2/will-it-scale

commit: 
  5e00e31867 ("userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET")
  a6fde7add7 ("mm: use per_vma lock for MADV_DONTNEED")

5e00e31867d16e23 a6fde7add78d122f5e09cb6280f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     33172           -54.7%      15041 ±  6%  uptime.idle
 2.384e+10           -75.5%  5.852e+09 ±  7%  cpuidle..time
 2.244e+08           -88.1%   26677846 ±  3%  cpuidle..usage
    405945          +176.7%    1123225        will-it-scale.192.threads
     42.80           -78.0%       9.40 ±  7%  will-it-scale.192.threads_idle
      2114          +176.7%       5849        will-it-scale.per_thread_ops
    405945          +176.7%    1123225        will-it-scale.workload
    723.50 ±  8%     +34.0%     969.33 ±  3%  perf-c2c.DRAM.local
     25877 ±  3%    +227.3%      84694        perf-c2c.DRAM.remote
     13915          +154.7%      35449        perf-c2c.HITM.local
     20352 ±  3%    +256.9%      72638        perf-c2c.HITM.remote
     34268 ±  2%    +215.4%     108088        perf-c2c.HITM.total
     43.37           -75.8%      10.48 ±  7%  vmstat.cpu.id
     56.32           +58.2%      89.07        vmstat.cpu.sy
     66.58          +157.5%     171.45        vmstat.procs.r
    594362           -94.2%      34588 ±  2%  vmstat.system.cs
   3910919           +96.4%    7681576        vmstat.system.in
   2180450           -25.2%    1630420        meminfo.Active
   2180450           -25.2%    1630420        meminfo.Active(anon)
   4974053           -11.0%    4424807        meminfo.Cached
   4042704           -13.7%    3488169        meminfo.Committed_AS
    143355 ±  3%     -31.0%      98964        meminfo.Mapped
   1434003           -38.3%     884762        meminfo.Shmem
     43.08           -33.2        9.90 ±  7%  mpstat.cpu.all.idle%
     22.91            -4.5       18.40        mpstat.cpu.all.irq%
      0.16            -0.1        0.04 ±  3%  mpstat.cpu.all.soft%
     33.53           +37.7       71.22        mpstat.cpu.all.sys%
      0.31 ±  6%      +0.1        0.44 ±  8%  mpstat.cpu.all.usr%
     60.15           +55.5%      93.52        mpstat.max_utilization_pct
  30748625 ±  3%    +179.8%   86045170        numa-numastat.node0.local_node
  30788809 ±  3%    +179.7%   86123587        numa-numastat.node0.numa_hit
     40287 ± 46%     +95.1%      78587 ± 27%  numa-numastat.node0.other_node
  31393483          +173.9%   85988290        numa-numastat.node1.local_node
  31478477          +173.4%   86057228        numa-numastat.node1.numa_hit
  30878912 ±  4%    +174.0%   84617170        numa-numastat.node2.local_node
  30971736 ±  4%    +173.4%   84686594        numa-numastat.node2.numa_hit
  30733028 ±  4%    +169.6%   82850466        numa-numastat.node3.local_node
  30812231 ±  4%    +169.2%   82932327        numa-numastat.node3.numa_hit
    141120 ± 68%    +125.7%     318471 ± 47%  numa-meminfo.node0.Active
    141120 ± 68%    +125.7%     318471 ± 47%  numa-meminfo.node0.Active(anon)
    949762 ±124%     -87.4%     120012 ± 55%  numa-meminfo.node2.FilePages
     20871 ±121%     -94.9%       1054 ± 60%  numa-meminfo.node2.Mapped
   1367319 ± 21%     -54.2%     625556 ± 18%  numa-meminfo.node3.Active
   1367319 ± 21%     -54.2%     625556 ± 18%  numa-meminfo.node3.Active(anon)
    410132 ± 15%     -52.6%     194262 ± 52%  numa-meminfo.node3.AnonPages.max
     58276 ± 24%     -67.5%      18949 ± 22%  numa-meminfo.node3.Mapped
   1754799 ± 16%     -35.5%    1131778 ± 12%  numa-meminfo.node3.MemUsed
      2883 ± 16%     -25.6%       2146 ± 11%  numa-meminfo.node3.PageTables
   1041610 ± 27%     -53.8%     481729 ± 22%  numa-meminfo.node3.Shmem
    545056           -25.2%     407612        proc-vmstat.nr_active_anon
   1243447           -11.0%    1106212        proc-vmstat.nr_file_pages
     35661 ±  2%     -29.5%      25144        proc-vmstat.nr_mapped
    358434           -38.3%     221200        proc-vmstat.nr_shmem
    545056           -25.2%     407612        proc-vmstat.nr_zone_active_anon
     55961 ± 22%     -48.6%      28768 ± 31%  proc-vmstat.numa_hint_faults_local
 1.241e+08          +173.9%  3.398e+08        proc-vmstat.numa_hit
 1.238e+08          +174.3%  3.395e+08        proc-vmstat.numa_local
 1.242e+08          +173.8%  3.399e+08        proc-vmstat.pgalloc_normal
 2.459e+08          +175.6%  6.776e+08        proc-vmstat.pgfault
 1.237e+08          +174.5%  3.397e+08        proc-vmstat.pgfree
     35272 ± 68%    +125.7%      79623 ± 47%  numa-vmstat.node0.nr_active_anon
     35272 ± 68%    +125.7%      79623 ± 47%  numa-vmstat.node0.nr_zone_active_anon
  30789775 ±  3%    +179.7%   86130973        numa-vmstat.node0.numa_hit
  30749591 ±  3%    +179.8%   86052556        numa-vmstat.node0.numa_local
     40287 ± 46%     +95.1%      78587 ± 27%  numa-vmstat.node0.numa_other
  31478049          +173.4%   86064030        numa-vmstat.node1.numa_hit
  31393056          +173.9%   85995094        numa-vmstat.node1.numa_local
    237440 ±124%     -87.4%      30004 ± 55%  numa-vmstat.node2.nr_file_pages
      5286 ±122%     -95.8%     219.75 ± 66%  numa-vmstat.node2.nr_mapped
  30972241 ±  4%    +173.4%   84692041        numa-vmstat.node2.numa_hit
  30879418 ±  4%    +174.0%   84622618        numa-vmstat.node2.numa_local
    341715 ± 21%     -54.2%     156460 ± 18%  numa-vmstat.node3.nr_active_anon
     14749 ± 25%     -68.4%       4658 ± 24%  numa-vmstat.node3.nr_mapped
    721.34 ± 15%     -25.6%     536.53 ± 11%  numa-vmstat.node3.nr_page_table_pages
    260294 ± 27%     -53.7%     120499 ± 22%  numa-vmstat.node3.nr_shmem
    341714 ± 21%     -54.2%     156459 ± 18%  numa-vmstat.node3.nr_zone_active_anon
  30811721 ±  4%    +169.2%   82937335        numa-vmstat.node3.numa_hit
  30732518 ±  4%    +169.6%   82855474        numa-vmstat.node3.numa_local
      6.40 ±  2%     +58.3%      10.13        perf-stat.i.MPKI
 6.954e+09           +90.6%  1.326e+10        perf-stat.i.branch-instructions
      1.13            -0.2        0.95        perf-stat.i.branch-miss-rate%
  79915661           +55.9%  1.246e+08        perf-stat.i.branch-misses
     35.77            +5.8       41.57        perf-stat.i.cache-miss-rate%
 1.974e+08 ±  2%    +203.1%  5.984e+08        perf-stat.i.cache-misses
 5.655e+08 ±  2%    +154.4%  1.439e+09        perf-stat.i.cache-references
    598927           -94.2%      34813 ±  2%  perf-stat.i.context-switches
     11.43           -20.4%       9.10        perf-stat.i.cpi
 3.513e+11           +53.0%  5.375e+11        perf-stat.i.cpu-cycles
    592.83          +111.1%       1251        perf-stat.i.cpu-migrations
      1774 ±  2%     -49.4%     898.01        perf-stat.i.cycles-between-cache-misses
 3.103e+10           +90.1%  5.898e+10        perf-stat.i.instructions
      0.09           +20.3%       0.11        perf-stat.i.ipc
     11.60          +101.5%      23.37        perf-stat.i.metric.K/sec
    813942          +175.6%    2243400        perf-stat.i.minor-faults
    813942          +175.6%    2243400        perf-stat.i.page-faults
      6.36 ±  2%     +59.5%      10.15        perf-stat.overall.MPKI
      1.15            -0.2        0.94        perf-stat.overall.branch-miss-rate%
     34.89            +6.7       41.60        perf-stat.overall.cache-miss-rate%
     11.32           -19.5%       9.11        perf-stat.overall.cpi
      1780 ±  2%     -49.6%     898.26        perf-stat.overall.cycles-between-cache-misses
      0.09           +24.2%       0.11        perf-stat.overall.ipc
  23055469           -31.3%   15833441        perf-stat.overall.path-length
 6.931e+09           +90.5%  1.321e+10        perf-stat.ps.branch-instructions
  79657784           +55.9%  1.242e+08        perf-stat.ps.branch-misses
 1.967e+08 ±  2%    +203.1%  5.963e+08        perf-stat.ps.cache-misses
 5.639e+08 ±  2%    +154.2%  1.433e+09        perf-stat.ps.cache-references
    596817           -94.2%      34680 ±  2%  perf-stat.ps.context-switches
 3.501e+11           +53.0%  5.355e+11        perf-stat.ps.cpu-cycles
    590.65          +110.9%       1245        perf-stat.ps.cpu-migrations
 3.093e+10           +90.0%  5.877e+10        perf-stat.ps.instructions
    811027          +175.6%    2235532        perf-stat.ps.minor-faults
    811027          +175.6%    2235532        perf-stat.ps.page-faults
 9.359e+12           +90.0%  1.778e+13        perf-stat.total.instructions
   3568606          +373.7%   16903333        sched_debug.cfs_rq:/.avg_vruntime.avg
   4465189 ±  4%    +295.8%   17671644        sched_debug.cfs_rq:/.avg_vruntime.max
   3129343 ±  2%    +302.7%   12602026        sched_debug.cfs_rq:/.avg_vruntime.min
    250285 ±  9%    +258.8%     898123 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.32 ±  9%    +104.6%       0.66 ±  3%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.45 ±  3%     -11.8%       0.39 ±  4%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.32 ±  9%    +105.5%       0.66 ±  3%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      1.25 ± 14%     +28.9%       1.61 ±  7%  sched_debug.cfs_rq:/.h_nr_runnable.max
      0.44 ±  3%     -11.1%       0.39 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
      2.81 ± 11%     -80.2%       0.56 ± 87%  sched_debug.cfs_rq:/.load_avg.min
   3568606          +373.7%   16903333        sched_debug.cfs_rq:/.min_vruntime.avg
   4465189 ±  4%    +295.8%   17671644        sched_debug.cfs_rq:/.min_vruntime.max
   3129343 ±  2%    +302.7%   12602026        sched_debug.cfs_rq:/.min_vruntime.min
    250285 ±  9%    +258.8%     898123 ±  2%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.32 ±  9%    +105.2%       0.66 ±  3%  sched_debug.cfs_rq:/.nr_queued.avg
      0.44 ±  3%     -12.0%       0.39 ±  4%  sched_debug.cfs_rq:/.nr_queued.stddev
    328.85 ±  2%    +102.4%     665.73        sched_debug.cfs_rq:/.runnable_avg.avg
    859.00 ±  6%     +77.0%       1520 ±  6%  sched_debug.cfs_rq:/.runnable_avg.max
    162.67 ± 11%     -84.6%      24.97 ±144%  sched_debug.cfs_rq:/.runnable_avg.min
     83.72 ±  5%     +95.0%     163.23 ±  8%  sched_debug.cfs_rq:/.runnable_avg.stddev
    328.43 ±  2%    +102.2%     664.12        sched_debug.cfs_rq:/.util_avg.avg
    852.03 ±  5%     +73.1%       1474 ±  6%  sched_debug.cfs_rq:/.util_avg.max
    164.19 ± 10%     -85.4%      24.03 ±143%  sched_debug.cfs_rq:/.util_avg.min
     82.62 ±  5%     +92.9%     159.38 ±  8%  sched_debug.cfs_rq:/.util_avg.stddev
    113.06 ± 10%    +362.8%     523.26 ±  4%  sched_debug.cfs_rq:/.util_est.avg
    500.78 ±  8%    +141.7%       1210 ±  7%  sched_debug.cfs_rq:/.util_est.max
    159.89 ±  3%     +89.6%     303.23 ±  3%  sched_debug.cfs_rq:/.util_est.stddev
    483053 ±  3%     +77.1%     855327        sched_debug.cpu.avg_idle.avg
    751868 ± 10%     +40.4%    1055695        sched_debug.cpu.avg_idle.max
    134891 ±  7%    +107.8%     280294 ± 12%  sched_debug.cpu.avg_idle.min
     78767 ± 16%     +89.2%     149010        sched_debug.cpu.avg_idle.stddev
      6221 ±  9%     -21.2%       4900        sched_debug.cpu.clock_task.stddev
      2061 ±  8%     +94.2%       4005 ±  3%  sched_debug.cpu.curr->pid.avg
      2655 ±  2%     -13.8%       2288 ±  4%  sched_debug.cpu.curr->pid.stddev
      0.00 ± 41%     +87.6%       0.00 ± 13%  sched_debug.cpu.next_balance.stddev
      0.32 ±  9%    +104.2%       0.66 ±  3%  sched_debug.cpu.nr_running.avg
      0.45 ±  3%     -11.6%       0.40 ±  4%  sched_debug.cpu.nr_running.stddev
    463856           -94.0%      27685 ±  2%  sched_debug.cpu.nr_switches.avg
    505561 ±  2%     -90.2%      49365 ±  4%  sched_debug.cpu.nr_switches.max
    397023 ±  4%     -94.3%      22498 ±  3%  sched_debug.cpu.nr_switches.min
      7607 ± 15%     -45.5%       4149 ±  2%  sched_debug.cpu.nr_switches.stddev
      0.53 ±  5%     -68.4%       0.17 ± 12%  sched_debug.cpu.nr_uninterruptible.avg
    165.69 ± 21%   +2874.8%       4929        sched_debug.cpu.nr_uninterruptible.max
   -153.56         +3099.7%      -4913        sched_debug.cpu.nr_uninterruptible.min
     22.58 ± 10%   +6092.0%       1398        sched_debug.cpu.nr_uninterruptible.stddev
      0.02 ± 86%   +3043.1%       0.53 ± 53%  perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.03 ± 19%   +1647.7%       0.58 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.04 ± 89%    +455.3%       0.20 ±  2%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.00 ±223%   +7625.0%       0.10 ±124%  perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.00 ± 39%    +100.0%       0.01 ± 21%  perf-sched.sch_delay.avg.ms.__cond_resched.stop_one_cpu.sched_exec.bprm_execve.part
      0.08 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.03 ±155%   +2837.3%       0.77 ± 64%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.05 ±105%   +1070.2%       0.61 ± 30%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.00 ± 10%    +703.6%       0.04 ± 28%  perf-sched.sch_delay.avg.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.00 ± 10%    +410.7%       0.02 ± 23%  perf-sched.sch_delay.avg.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
      0.01 ± 24%    +604.9%       0.07 ±176%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ± 15%    +361.4%       0.03 ± 43%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.00 ± 28%    +150.0%       0.00 ± 21%  perf-sched.sch_delay.avg.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.01 ± 31%    +289.7%       0.04 ± 62%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.11 ± 35%    +304.0%       0.43 ± 45%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.04 ±114%   +1264.9%       0.52 ± 33%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.11 ± 52%    +650.6%       0.79 ±  4%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.02 ±135%   +1400.7%       0.34 ± 74%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.01 ± 45%    +703.2%       0.04 ± 39%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function.[unknown]
      0.16 ± 20%     +67.1%       0.26 ± 20%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.00 ± 28%   +9300.0%       0.16 ± 50%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.01          -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.01 ± 50%    +353.5%       0.05 ± 21%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      0.01 ±  8%    +752.9%       0.05 ± 12%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      0.01 ± 21%    +292.3%       0.03 ± 15%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.01 ± 20%   +1050.0%       0.08 ± 27%  perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.01 ±  9%    +206.8%       0.03 ± 69%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.01 ± 19%    +265.8%       0.04 ± 69%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.01 ± 23%   +1270.5%       0.10 ± 18%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.06 ±130%  +13233.7%       7.44 ± 91%  perf-sched.sch_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.77 ± 23%   +6200.8%      48.80 ± 96%  perf-sched.sch_delay.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.00 ±223%  +1.1e+05%       1.42 ±138%  perf-sched.sch_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.07 ± 83%    +116.5%       0.15 ± 23%  perf-sched.sch_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 52%     -64.2%       0.01 ± 83%  perf-sched.sch_delay.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.47 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.06 ±183%   +5567.6%       3.52 ± 45%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.15 ±107%   +5160.3%       7.81 ± 94%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.02 ± 12%  +1.6e+05%      25.23 ± 54%  perf-sched.sch_delay.max.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.02 ± 29%  +1.6e+05%      24.02 ± 62%  perf-sched.sch_delay.max.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
      0.35 ± 63%   +1071.6%       4.11 ±121%  perf-sched.sch_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.49 ± 57%    +197.1%       1.47 ± 69%  perf-sched.sch_delay.max.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.20 ± 98%    +842.6%       1.88 ± 76%  perf-sched.sch_delay.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.78 ± 24%    +721.1%       6.39 ± 44%  perf-sched.sch_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.23 ± 88%   +2103.1%       5.05 ±  9%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.61 ± 71%   +1074.1%       7.20 ± 72%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.03 ±144%   +2054.5%       0.69 ± 58%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.01 ± 45%   +6350.0%       0.34 ± 65%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function.[unknown]
      0.34 ± 26%    +424.4%       1.79 ± 43%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.61 ± 27%    +152.4%       1.54 ± 42%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
      0.08 ± 59%   +2324.9%       1.85 ± 82%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
     12.13 ± 10%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.37 ±118%   +9135.1%      33.91 ± 33%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      5.65 ± 45%    +960.4%      59.96 ± 70%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      4.13 ± 80%    +495.1%      24.59 ± 55%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.69 ±223%   +1343.9%       9.96 ± 87%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr
      0.12 ± 47%   +2736.5%       3.30 ± 13%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.04 ± 60%   +1121.5%       0.46 ±163%  perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      3.66 ± 93%   +1131.1%      45.04 ± 71%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ± 39%    +835.3%       0.08 ± 10%  perf-sched.total_sch_delay.average.ms
      2.24          +990.8%      24.40        perf-sched.total_wait_and_delay.average.ms
   1210914           -93.1%      83432 ±  2%  perf-sched.total_wait_and_delay.count.ms
      3800 ± 13%     +23.8%       4706 ±  6%  perf-sched.total_wait_and_delay.max.ms
      2.23          +991.2%      24.32        perf-sched.total_wait_time.average.ms
      3800 ± 13%     +23.8%       4706 ±  6%  perf-sched.total_wait_time.max.ms
      3.67 ±  8%     +70.0%       6.24 ± 36%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
    119.96 ±  2%     +17.3%     140.76 ±  3%  perf-sched.wait_and_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
     66.65 ±  5%    +697.3%     531.40 ± 13%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.71          -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.43          +449.0%       2.37 ±  4%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      3.30 ±  2%     +38.5%       4.57        perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    370.33 ±  3%     -10.3%     332.23 ±  4%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.00 ± 81%    +575.0%      13.50 ± 24%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    370.00 ±  2%     -12.7%     323.17 ±  3%  perf-sched.wait_and_delay.count.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
    235.67 ±  4%     -89.8%      24.00 ±  4%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
   1174293          -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
     21019           +31.3%      27603        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      1513 ±  2%     -27.0%       1105        perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      1000          +196.8%       2970 ± 66%  perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
    379.57 ±152%    +430.7%       2014 ± 58%  perf-sched.wait_and_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     21.98 ± 11%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
     11.88 ± 11%    +658.6%      90.10 ±107%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      6.17 ± 21%    +450.9%      34.00 ±105%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.73 ± 11%    +183.5%       2.07 ± 19%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.76 ± 12%    +167.2%       2.03 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      3.63 ±  8%     +66.2%       6.04 ± 37%  perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.00 ±223%  +71650.0%       1.91 ± 27%  perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.82 ± 11%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.67 ± 49%    +223.8%       2.16 ± 39%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.83 ± 27%    +152.0%       2.08 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.22 ± 20%    +912.6%       2.24 ±  5%  perf-sched.wait_time.avg.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.27 ± 24%    +625.8%       1.94 ±  6%  perf-sched.wait_time.avg.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
    119.96 ±  2%     +17.3%     140.73 ±  3%  perf-sched.wait_time.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.44 ±  2%    +261.4%       1.60 ±147%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.45 ± 37%    +164.6%       1.19 ± 41%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.75 ± 11%    +152.8%       1.90 ±  5%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.20 ± 36%    +323.6%       0.84 ±  4%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.17 ± 17%     +51.5%       0.26 ± 20%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
     66.65 ±  5%    +697.1%     531.24 ± 13%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.70          -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.60 ±  8%    +193.4%       1.77 ±  4%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      0.43          +445.2%       2.32 ±  4%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      0.29          +885.3%       2.85 ±  3%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.86           +26.1%       1.09 ±  6%  perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      3.29 ±  2%     +37.7%       4.53        perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    370.32 ±  3%     -10.3%     332.13 ±  4%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.94 ± 23%    +940.8%       9.82 ± 59%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      2.95 ± 87%   +1596.0%      49.96 ± 97%  perf-sched.wait_time.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      1000          +196.8%       2969 ± 66%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.00 ±223%  +2.4e+05%       6.47 ± 15%  perf-sched.wait_time.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
    379.54 ±152%    +430.8%       2014 ± 58%  perf-sched.wait_time.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1.41 ± 12%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.75 ± 55%    +642.4%       5.53 ± 26%  perf-sched.wait_time.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      1.18 ± 17%    +882.6%      11.63 ± 66%  perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      2.11 ± 58%   +1003.0%      23.25 ± 41%  perf-sched.wait_time.max.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      1.91 ± 76%   +1255.0%      25.84 ± 65%  perf-sched.wait_time.max.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
     23.98          +714.1%     195.25 ±184%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.50 ± 47%    +557.6%       9.90 ± 21%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.89 ± 28%    +765.6%       7.66 ± 65%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.43 ± 29%    +318.3%       1.79 ± 43%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.67 ± 32%    +287.2%       2.59 ± 60%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
     13.59 ± 23%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      1.57 ± 19%   +1798.2%      29.87 ± 53%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
     11.83 ± 11%    +357.4%      54.13 ± 85%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
     10.35 ± 25%    +179.6%      28.95 ± 56%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.69 ±223%   +5790.5%      40.64 ±144%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr
      2.95 ±  3%     +94.4%       5.74 ± 20%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     41.56           -37.5        4.04 ±  7%  perf-profile.calltrace.cycles-pp.common_startup_64
     41.34           -37.3        4.02 ±  7%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
     41.34           -37.3        4.02 ±  7%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     41.32           -37.3        4.02 ±  7%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     39.04           -35.1        3.97 ±  7%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     38.29           -34.3        3.96 ±  7%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
     38.19           -34.2        3.96 ±  7%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
     22.62           -22.6        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
     22.52           -22.5        0.00        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
     22.43           -22.4        0.00        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter
     22.29           -22.3        0.00        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state
     22.58           -19.9        2.72        perf-profile.calltrace.cycles-pp.flush_tlb_func.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      9.10 ±  4%      -9.1        0.00        perf-profile.calltrace.cycles-pp.madvise_lock.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      9.08 ±  4%      -9.1        0.00        perf-profile.calltrace.cycles-pp.down_read.madvise_lock.do_madvise.__x64_sys_madvise.do_syscall_64
     11.40            -8.9        2.49 ±  8%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      8.69 ±  4%      -8.7        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_read_slowpath.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      6.90 ±  5%      -6.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.madvise_lock.do_madvise
      6.77 ±  5%      -6.8        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.madvise_lock
      0.80 ±  8%      -0.5        0.30 ±100%  perf-profile.calltrace.cycles-pp.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.88            +0.3        1.19        perf-profile.calltrace.cycles-pp.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
      0.64 ±  7%      +0.6        1.24 ±  8%  perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      1.74 ±  7%      +0.6        2.36 ±  9%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      1.75 ±  7%      +0.6        2.37 ±  9%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
      0.73 ±  9%      +0.6        1.36 ±  9%  perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.80 ± 10%      +0.7        1.49 ± 10%  perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.00            +0.7        0.71 ±  5%  perf-profile.calltrace.cycles-pp.tlb_gather_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.88 ±  7%      +0.7        2.63 ±  8%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
      2.00 ±  7%      +0.9        2.86 ± 10%  perf-profile.calltrace.cycles-pp.testcase
      0.00            +0.9        0.86 ±  6%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free
      0.00            +0.9        0.87 ±  6%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior
      0.89 ± 12%      +0.9        1.80 ± 10%  perf-profile.calltrace.cycles-pp.madvise_do_behavior.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.9        0.91 ±  6%  perf-profile.calltrace.cycles-pp.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas
      0.00            +1.4        1.41 ± 10%  perf-profile.calltrace.cycles-pp.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior
      0.00            +1.4        1.44 ± 10%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.intel_idle_irq.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      0.00            +1.4        1.44 ± 10%  perf-profile.calltrace.cycles-pp.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior.do_madvise
      0.00            +1.4        1.45 ± 10%  perf-profile.calltrace.cycles-pp.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior.do_madvise.__x64_sys_madvise
      0.00            +1.8        1.78 ± 10%  perf-profile.calltrace.cycles-pp.madvise_walk_vmas.madvise_do_behavior.do_madvise.__x64_sys_madvise.do_syscall_64
      4.37            +7.7       12.10        perf-profile.calltrace.cycles-pp.llist_reverse_order.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      4.94           +12.0       16.94        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask
      4.84           +12.0       16.88        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond
      5.05           +12.1       17.16        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      6.42           +12.3       18.77        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
     55.56           +36.7       92.29        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     55.56           +36.7       92.30        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__madvise
     55.46           +36.8       92.25        perf-profile.calltrace.cycles-pp.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     55.46           +36.8       92.25        perf-profile.calltrace.cycles-pp.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     55.73           +36.8       92.56        perf-profile.calltrace.cycles-pp.__madvise
     43.09           +43.8       86.92        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise
     43.77           +44.0       87.76        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise
     44.35           +44.1       88.41        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64
     44.90           +44.8       89.67        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
     41.56           -37.5        4.04 ±  7%  perf-profile.children.cycles-pp.common_startup_64
     41.56           -37.5        4.04 ±  7%  perf-profile.children.cycles-pp.cpu_startup_entry
     41.56           -37.5        4.04 ±  7%  perf-profile.children.cycles-pp.do_idle
     41.34           -37.3        4.02 ±  7%  perf-profile.children.cycles-pp.start_secondary
     39.25           -35.3        4.00 ±  7%  perf-profile.children.cycles-pp.cpuidle_idle_call
     38.49           -34.5        3.98 ±  7%  perf-profile.children.cycles-pp.cpuidle_enter
     38.49           -34.5        3.98 ±  7%  perf-profile.children.cycles-pp.cpuidle_enter_state
     24.11           -20.8        3.27        perf-profile.children.cycles-pp.flush_tlb_func
     31.48           -12.6       18.93        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
     32.54           -12.3       20.20        perf-profile.children.cycles-pp.asm_sysvec_call_function
     30.92           -11.9       19.04        perf-profile.children.cycles-pp.sysvec_call_function
     30.66           -11.9       18.78        perf-profile.children.cycles-pp.__sysvec_call_function
      9.10 ±  4%      -9.1        0.00        perf-profile.children.cycles-pp.madvise_lock
      9.10 ±  4%      -9.1        0.00        perf-profile.children.cycles-pp.down_read
     11.48            -9.0        2.51 ±  8%  perf-profile.children.cycles-pp.intel_idle
      8.73 ±  4%      -8.7        0.00        perf-profile.children.cycles-pp.rwsem_down_read_slowpath
      6.99 ±  5%      -7.0        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irq
      6.91 ±  5%      -6.8        0.14 ±  4%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
      2.43 ±  3%      -2.3        0.10 ±  4%  perf-profile.children.cycles-pp.__schedule
      2.99 ±  7%      -1.7        1.32 ±  5%  perf-profile.children.cycles-pp.intel_idle_irq
      0.96 ±  4%      -0.9        0.06 ±  9%  perf-profile.children.cycles-pp.schedule_preempt_disabled
      0.97 ±  4%      -0.9        0.07        perf-profile.children.cycles-pp.schedule
      0.54 ±  8%      -0.5        0.05        perf-profile.children.cycles-pp.__pick_next_task
      0.96 ±  2%      -0.5        0.48        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.42 ± 11%      -0.4        0.04 ± 44%  perf-profile.children.cycles-pp.sched_balance_newidle
      0.43 ± 10%      -0.4        0.06        perf-profile.children.cycles-pp.sched_balance_rq
      0.53 ±  2%      -0.4        0.18        perf-profile.children.cycles-pp.__irq_exit_rcu
      0.34 ±  8%      -0.3        0.05 ±  7%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.34 ±  8%      -0.3        0.05        perf-profile.children.cycles-pp.update_sd_lb_stats
      0.32 ±  7%      -0.3        0.05        perf-profile.children.cycles-pp.update_sg_lb_stats
      0.58 ±  2%      -0.2        0.35        perf-profile.children.cycles-pp._raw_spin_lock
      0.25 ±  4%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
      0.53 ±  2%      -0.1        0.44 ±  2%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.52 ±  2%      -0.1        0.44        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.24 ±  5%      -0.1        0.15        perf-profile.children.cycles-pp.__sysvec_call_function_single
      0.24 ±  5%      -0.1        0.16 ±  2%  perf-profile.children.cycles-pp.sysvec_call_function_single
      0.38            -0.1        0.30        perf-profile.children.cycles-pp.__munmap
      0.14 ±  3%      -0.1        0.06        perf-profile.children.cycles-pp.update_load_avg
      0.38            -0.1        0.30        perf-profile.children.cycles-pp.__vm_munmap
      0.38            -0.1        0.30        perf-profile.children.cycles-pp.__x64_sys_munmap
      0.16 ±  2%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.native_sched_clock
      0.30            -0.1        0.24        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      0.11 ±  4%      -0.1        0.05 ±  7%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      0.12 ±  4%      -0.1        0.06 ±  8%  perf-profile.children.cycles-pp.down_write_killable
      0.31            -0.1        0.25        perf-profile.children.cycles-pp.do_vmi_align_munmap
      0.31            -0.1        0.25        perf-profile.children.cycles-pp.do_vmi_munmap
      0.45 ±  2%      -0.0        0.40        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.___perf_sw_event
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.rmqueue
      0.56            +0.0        0.58        perf-profile.children.cycles-pp._find_next_bit
      0.03 ± 70%      +0.0        0.06 ±  6%  perf-profile.children.cycles-pp.error_entry
      0.13 ±  2%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.irqtime_account_irq
      0.05            +0.0        0.08 ±  4%  perf-profile.children.cycles-pp.clear_page_erms
      0.06            +0.0        0.09 ±  4%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
      0.06 ±  7%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      0.11            +0.1        0.16 ±  2%  perf-profile.children.cycles-pp.get_page_from_freelist
      0.05 ±  8%      +0.1        0.11 ±  4%  perf-profile.children.cycles-pp.sync_regs
      0.00            +0.1        0.05 ± 13%  perf-profile.children.cycles-pp.try_charge_memcg
      0.14 ±  3%      +0.1        0.19        perf-profile.children.cycles-pp.native_flush_tlb_local
      0.31 ±  2%      +0.1        0.37 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.__page_cache_release
      0.00            +0.1        0.06 ±  9%  perf-profile.children.cycles-pp.charge_memcg
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.folio_add_new_anon_rmap
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.lru_add
      0.08 ± 24%      +0.1        0.14 ± 19%  perf-profile.children.cycles-pp.__mem_cgroup_charge
      0.12 ±  4%      +0.1        0.19 ±  2%  perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.27            +0.1        0.35        perf-profile.children.cycles-pp.update_process_times
      0.14 ±  3%      +0.1        0.21 ±  2%  perf-profile.children.cycles-pp.alloc_pages_mpol
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.__perf_sw_event
      0.15 ±  3%      +0.1        0.23 ±  2%  perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      0.11 ±  3%      +0.1        0.20 ±  2%  perf-profile.children.cycles-pp.folios_put_refs
      0.16 ±  4%      +0.1        0.27        perf-profile.children.cycles-pp.sched_tick
      0.11 ±  3%      +0.1        0.23        perf-profile.children.cycles-pp.vms_clear_ptes
      0.10            +0.1        0.23        perf-profile.children.cycles-pp.folio_batch_move_lru
      0.06            +0.1        0.19 ±  2%  perf-profile.children.cycles-pp.mm_needs_global_asid
      0.00            +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.update_cfs_group
      0.13            +0.1        0.28        perf-profile.children.cycles-pp.folio_add_lru
      0.22 ±  3%      +0.2        0.36 ±  2%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      0.24 ±  8%      +0.2        0.39 ±  6%  perf-profile.children.cycles-pp.alloc_anon_folio
      0.06            +0.2        0.23 ±  2%  perf-profile.children.cycles-pp.task_tick_fair
      0.42 ±  7%      +0.2        0.65 ±  7%  perf-profile.children.cycles-pp.native_irq_return_iret
      0.91            +0.3        1.21        perf-profile.children.cycles-pp.default_send_IPI_mask_sequence_phys
      0.12 ± 13%      +0.4        0.54 ±  7%  perf-profile.children.cycles-pp.flush_tlb_batched_pending
      0.26 ±  7%      +0.5        0.73 ±  6%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.43 ±  9%      +0.5        0.92 ±  6%  perf-profile.children.cycles-pp.unmap_page_range
      0.38 ±  6%      +0.5        0.87 ±  6%  perf-profile.children.cycles-pp.zap_pte_range
      0.39 ±  6%      +0.5        0.88 ±  6%  perf-profile.children.cycles-pp.zap_pmd_range
      0.64 ±  7%      +0.6        1.25 ±  8%  perf-profile.children.cycles-pp.do_anonymous_page
      1.75 ±  7%      +0.6        2.36 ±  9%  perf-profile.children.cycles-pp.do_user_addr_fault
      1.76 ±  7%      +0.6        2.38 ±  9%  perf-profile.children.cycles-pp.exc_page_fault
      0.73 ±  9%      +0.6        1.36 ±  9%  perf-profile.children.cycles-pp.__handle_mm_fault
      0.80 ± 10%      +0.7        1.50 ± 10%  perf-profile.children.cycles-pp.handle_mm_fault
      0.68 ± 12%      +0.8        1.45 ± 10%  perf-profile.children.cycles-pp.madvise_vma_behavior
      0.66 ± 13%      +0.8        1.44 ± 10%  perf-profile.children.cycles-pp.madvise_dontneed_free
      0.62 ± 13%      +0.8        1.42 ± 11%  perf-profile.children.cycles-pp.zap_page_range_single_batched
      1.98 ±  6%      +0.8        2.81 ±  8%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.90 ± 12%      +0.9        1.80 ± 10%  perf-profile.children.cycles-pp.madvise_do_behavior
      2.15 ±  7%      +1.0        3.16 ±  9%  perf-profile.children.cycles-pp.testcase
      0.00            +1.8        1.78 ± 10%  perf-profile.children.cycles-pp.madvise_walk_vmas
      5.40            +8.0       13.44        perf-profile.children.cycles-pp.llist_reverse_order
     56.17           +36.5       92.67        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     56.16           +36.5       92.66        perf-profile.children.cycles-pp.do_syscall_64
     55.46           +36.8       92.25        perf-profile.children.cycles-pp.do_madvise
     55.46           +36.8       92.25        perf-profile.children.cycles-pp.__x64_sys_madvise
     55.74           +36.8       92.59        perf-profile.children.cycles-pp.__madvise
     43.86           +44.1       87.98        perf-profile.children.cycles-pp.smp_call_function_many_cond
     43.86           +44.1       87.98        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
     44.45           +44.2       88.63        perf-profile.children.cycles-pp.flush_tlb_mm_range
     45.01           +44.9       89.91        perf-profile.children.cycles-pp.tlb_finish_mmu
     23.91           -21.0        2.89        perf-profile.self.cycles-pp.flush_tlb_func
     11.48            -9.0        2.51 ±  8%  perf-profile.self.cycles-pp.intel_idle
      6.91 ±  5%      -6.8        0.12 ±  3%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      1.63 ±  8%      -0.4        1.24 ±  5%  perf-profile.self.cycles-pp.intel_idle_irq
      0.49            -0.3        0.20        perf-profile.self.cycles-pp._raw_spin_lock
      0.64 ±  7%      -0.2        0.49 ± 11%  perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.16 ±  2%      -0.1        0.09 ±  5%  perf-profile.self.cycles-pp.native_sched_clock
      0.50 ±  2%      -0.1        0.44        perf-profile.self.cycles-pp._find_next_bit
      0.10 ±  4%      -0.0        0.08 ±  6%  perf-profile.self.cycles-pp.asm_sysvec_call_function
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.irqtime_account_irq
      0.01 ±223%      +0.1        0.06        perf-profile.self.cycles-pp.folios_put_refs
      0.05 ±  8%      +0.1        0.11 ±  4%  perf-profile.self.cycles-pp.sync_regs
      0.14 ±  3%      +0.1        0.19        perf-profile.self.cycles-pp.native_flush_tlb_local
      0.00            +0.1        0.06        perf-profile.self.cycles-pp.error_entry
      0.06 ±  6%      +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.do_user_addr_fault
      0.00            +0.1        0.07        perf-profile.self.cycles-pp.clear_page_erms
      0.00            +0.1        0.07        perf-profile.self.cycles-pp.madvise_walk_vmas
      0.03 ± 70%      +0.1        0.14 ±  2%  perf-profile.self.cycles-pp.mm_needs_global_asid
      0.00            +0.1        0.14 ±  3%  perf-profile.self.cycles-pp.update_cfs_group
      0.16 ±  3%      +0.2        0.34 ±  2%  perf-profile.self.cycles-pp.testcase
      0.76            +0.2        0.94        perf-profile.self.cycles-pp.default_send_IPI_mask_sequence_phys
      0.42 ±  7%      +0.2        0.65 ±  7%  perf-profile.self.cycles-pp.native_irq_return_iret
      0.17 ± 23%      +0.2        0.42 ± 20%  perf-profile.self.cycles-pp.zap_page_range_single_batched
      0.20 ± 14%      +0.3        0.48 ± 15%  perf-profile.self.cycles-pp.flush_tlb_mm_range
      0.10 ± 14%      +0.3        0.44 ±  7%  perf-profile.self.cycles-pp.flush_tlb_batched_pending
      0.22 ±  6%      +0.4        0.60 ±  6%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.42 ±  9%      +0.6        0.98 ±  6%  perf-profile.self.cycles-pp.tlb_finish_mmu
      1.63            +0.6        2.25        perf-profile.self.cycles-pp.__flush_smp_call_function_queue
      5.15            +8.3       13.44        perf-profile.self.cycles-pp.llist_reverse_order
     36.88           +31.1       67.98        perf-profile.self.cycles-pp.smp_call_function_many_cond


***************************************************************************************************
lkp-skl-fpga01: 104 threads 2 sockets (Skylake) with 192G memory
=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-12/performance/x86_64-rhel-9.4/thread/100%/debian-12-x86_64-20240206.cgz/lkp-skl-fpga01/tlb_flush2/will-it-scale

commit: 
  5e00e31867 ("userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET")
  a6fde7add7 ("mm: use per_vma lock for MADV_DONTNEED")

5e00e31867d16e23 a6fde7add78d122f5e09cb6280f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     14925           -61.7%       5717        uptime.idle
  1.16e+10           -81.0%  2.199e+09 ±  2%  cpuidle..time
 2.126e+08           -88.4%   24637059        cpuidle..usage
   3245191 ± 33%     -57.4%    1382593 ±116%  numa-meminfo.node0.FilePages
   7270056 ± 14%     -26.4%    5353286 ± 28%  numa-meminfo.node0.MemUsed
   1170266 ± 24%     -36.7%     741206 ± 24%  numa-meminfo.node1.Active
   1170266 ± 24%     -36.7%     741206 ± 24%  numa-meminfo.node1.Active(anon)
  98106610 ±  5%    +113.8%  2.098e+08        numa-numastat.node0.local_node
  98156371 ±  5%    +113.7%  2.098e+08        numa-numastat.node0.numa_hit
 1.017e+08 ±  4%    +109.5%  2.131e+08        numa-numastat.node1.local_node
 1.017e+08 ±  4%    +109.5%  2.132e+08        numa-numastat.node1.numa_hit
     20547           +44.6%      29711 ± 16%  perf-c2c.DRAM.remote
     25526           +34.9%      34429 ± 16%  perf-c2c.HITM.local
     16981           +50.6%      25574 ± 16%  perf-c2c.HITM.remote
     42507           +41.2%      60004 ± 16%  perf-c2c.HITM.total
    660348          +112.4%    1402275        will-it-scale.104.threads
     37.30           -83.1%       6.30 ±  2%  will-it-scale.104.threads_idle
      6348          +112.4%      13482        will-it-scale.per_thread_ops
    660348          +112.4%    1402275        will-it-scale.workload
     37.60           -31.0        6.63 ±  3%  mpstat.cpu.all.idle%
      0.14            -0.1        0.05        mpstat.cpu.all.soft%
     41.16           +28.9       70.06        mpstat.cpu.all.sys%
      2.18            +1.7        3.90        mpstat.cpu.all.usr%
     65.29           +49.2%      97.40        mpstat.max_utilization_pct
     37.91           -81.0%       7.19 ±  2%  vmstat.cpu.id
     59.91           +48.3%      88.87        vmstat.cpu.sy
     61.87 ±  2%     +56.4%      96.78        vmstat.procs.r
    648283           -91.5%      55326        vmstat.system.cs
   4410702           +75.1%    7721156        vmstat.system.in
   1751586           -29.4%    1236767 ±  2%  meminfo.Active
   1751586           -29.4%    1236767 ±  2%  meminfo.Active(anon)
   4605219           -11.1%    4094953        meminfo.Cached
   2806474           -18.3%    2293090        meminfo.Committed_AS
     96403           -16.6%      80363        meminfo.Mapped
   1065038           -47.9%     554780 ±  5%  meminfo.Shmem
    811327 ± 33%     -57.4%     345637 ±116%  numa-vmstat.node0.nr_file_pages
  98156076 ±  5%    +113.6%  2.097e+08        numa-vmstat.node0.numa_hit
  98106315 ±  5%    +113.7%  2.097e+08        numa-vmstat.node0.numa_local
    292557 ± 24%     -36.7%     185258 ± 24%  numa-vmstat.node1.nr_active_anon
    292557 ± 24%     -36.7%     185258 ± 24%  numa-vmstat.node1.nr_zone_active_anon
 1.017e+08 ±  4%    +109.4%  2.131e+08        numa-vmstat.node1.numa_hit
 1.017e+08 ±  4%    +109.5%   2.13e+08        numa-vmstat.node1.numa_local
    437965           -29.4%     309243 ±  2%  proc-vmstat.nr_active_anon
   1151373           -11.1%    1023774        proc-vmstat.nr_file_pages
     24519           -16.5%      20472        proc-vmstat.nr_mapped
    266326           -47.9%     138730 ±  5%  proc-vmstat.nr_shmem
    437965           -29.4%     309243 ±  2%  proc-vmstat.nr_zone_active_anon
 1.998e+08          +111.6%  4.228e+08        proc-vmstat.numa_hit
 1.997e+08          +111.6%  4.227e+08        proc-vmstat.numa_local
     17545 ± 59%     +89.3%      33209 ± 30%  proc-vmstat.numa_pages_migrated
    111435 ± 41%     +81.2%     201867 ± 17%  proc-vmstat.numa_pte_updates
 1.999e+08          +111.5%  4.229e+08        proc-vmstat.pgalloc_normal
 3.982e+08          +112.0%  8.443e+08        proc-vmstat.pgfault
 1.996e+08          +111.8%  4.227e+08        proc-vmstat.pgfree
     17545 ± 59%     +89.3%      33209 ± 30%  proc-vmstat.pgmigrate_success
      6.15           +19.6%       7.35        perf-stat.i.MPKI
 5.226e+09           +66.8%  8.718e+09        perf-stat.i.branch-instructions
      2.74            +0.1        2.87        perf-stat.i.branch-miss-rate%
 1.438e+08           +73.6%  2.496e+08        perf-stat.i.branch-misses
     25.66            +1.6       27.25        perf-stat.i.cache-miss-rate%
 1.537e+08           +99.1%   3.06e+08        perf-stat.i.cache-misses
 6.048e+08           +85.8%  1.124e+09        perf-stat.i.cache-references
    652603           -91.5%      55668        perf-stat.i.context-switches
      7.71           -15.2%       6.54        perf-stat.i.cpi
 1.923e+11           +41.5%  2.721e+11        perf-stat.i.cpu-cycles
    565.76           +18.9%     672.78        perf-stat.i.cpu-migrations
      1248           -28.8%     888.98        perf-stat.i.cycles-between-cache-misses
 2.522e+10           +64.7%  4.152e+10        perf-stat.i.instructions
      0.14           +14.3%       0.15        perf-stat.i.ipc
     31.63           +70.0%      53.78        perf-stat.i.metric.K/sec
   1318750          +112.1%    2796474        perf-stat.i.minor-faults
   1318750          +112.1%    2796474        perf-stat.i.page-faults
      6.09           +20.9%       7.37        perf-stat.overall.MPKI
      2.75            +0.1        2.86        perf-stat.overall.branch-miss-rate%
     25.40            +1.8       27.23        perf-stat.overall.cache-miss-rate%
      7.62           -14.0%       6.55        perf-stat.overall.cpi
      1251           -28.9%     889.43        perf-stat.overall.cycles-between-cache-misses
      0.13           +16.3%       0.15        perf-stat.overall.ipc
  11491863           -22.5%    8909088        perf-stat.overall.path-length
 5.209e+09           +66.7%  8.685e+09        perf-stat.ps.branch-instructions
 1.433e+08           +73.5%  2.487e+08        perf-stat.ps.branch-misses
 1.532e+08           +99.0%  3.048e+08        perf-stat.ps.cache-misses
  6.03e+08           +85.6%   1.12e+09        perf-stat.ps.cache-references
    650365           -91.5%      55448        perf-stat.ps.context-switches
 1.917e+11           +41.4%  2.711e+11        perf-stat.ps.cpu-cycles
    563.80           +18.8%     669.81        perf-stat.ps.cpu-migrations
 2.514e+10           +64.6%  4.137e+10        perf-stat.ps.instructions
   1314147          +112.0%    2786592        perf-stat.ps.minor-faults
   1314147          +112.0%    2786592        perf-stat.ps.page-faults
 7.588e+12           +64.6%  1.249e+13        perf-stat.total.instructions
   2697494          +219.7%    8623695        sched_debug.cfs_rq:/.avg_vruntime.avg
   3062060 ±  2%    +194.6%    9022225        sched_debug.cfs_rq:/.avg_vruntime.max
   2522627 ±  2%    +188.2%    7270351        sched_debug.cfs_rq:/.avg_vruntime.min
    112005 ± 14%    +229.0%     368480        sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.44 ±  3%     +36.5%       0.59 ±  3%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.43 ±  3%     +37.6%       0.59 ±  4%  sched_debug.cfs_rq:/.h_nr_runnable.avg
   2697494          +219.7%    8623696        sched_debug.cfs_rq:/.min_vruntime.avg
   3062060 ±  2%    +194.6%    9022225        sched_debug.cfs_rq:/.min_vruntime.max
   2522627 ±  2%    +188.2%    7270351        sched_debug.cfs_rq:/.min_vruntime.min
    112005 ± 14%    +229.0%     368480        sched_debug.cfs_rq:/.min_vruntime.stddev
      0.42 ±  3%     +37.8%       0.59 ±  3%  sched_debug.cfs_rq:/.nr_queued.avg
    400.27           +70.4%     682.01        sched_debug.cfs_rq:/.runnable_avg.avg
    962.64 ±  4%     +50.3%       1446 ±  8%  sched_debug.cfs_rq:/.runnable_avg.max
    109.90 ±  7%     +50.6%     165.52 ±  6%  sched_debug.cfs_rq:/.runnable_avg.stddev
    400.04           +70.2%     680.87        sched_debug.cfs_rq:/.util_avg.avg
    952.14 ±  4%     +50.9%       1437 ±  8%  sched_debug.cfs_rq:/.util_avg.max
    108.76 ±  7%     +50.6%     163.83 ±  6%  sched_debug.cfs_rq:/.util_avg.stddev
    174.98 ±  4%    +153.1%     442.92 ±  4%  sched_debug.cfs_rq:/.util_est.avg
    674.39 ± 12%     +72.8%       1165 ± 14%  sched_debug.cfs_rq:/.util_est.max
    199.68           +65.8%     330.97 ±  2%  sched_debug.cfs_rq:/.util_est.stddev
    285047 ±  2%     +43.0%     407743 ±  3%  sched_debug.cpu.avg_idle.avg
    425414 ±  8%    +136.3%    1005391 ±  2%  sched_debug.cpu.avg_idle.max
     90251 ±  5%     -46.5%      48283 ±  9%  sched_debug.cpu.avg_idle.min
     60514 ± 15%    +266.4%     221730 ±  6%  sched_debug.cpu.avg_idle.stddev
      3632 ± 14%     +23.9%       4501        sched_debug.cpu.clock_task.stddev
      1842 ±  4%     +28.7%       2370 ±  3%  sched_debug.cpu.curr->pid.avg
      0.00 ± 10%    +201.1%       0.00 ±  9%  sched_debug.cpu.next_balance.stddev
      0.43 ±  4%     +37.4%       0.59 ±  3%  sched_debug.cpu.nr_running.avg
    930519           -91.5%      79276        sched_debug.cpu.nr_switches.avg
    977386           -90.3%      95005        sched_debug.cpu.nr_switches.max
    859951 ±  2%     -91.2%      75446        sched_debug.cpu.nr_switches.min
     12012 ± 12%     -72.7%       3280 ±  5%  sched_debug.cpu.nr_switches.stddev
      0.44 ±  3%     -38.3%       0.27 ±  8%  sched_debug.cpu.nr_uninterruptible.avg
    183.69 ± 23%   +1850.6%       3583        sched_debug.cpu.nr_uninterruptible.max
   -179.94         +1889.2%      -3579        sched_debug.cpu.nr_uninterruptible.min
     35.08 ± 12%   +2354.3%     860.88        sched_debug.cpu.nr_uninterruptible.stddev
      0.02 ± 81%   +2385.8%       0.56 ± 20%  perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.01 ± 10%   +5908.5%       0.59 ±  6%  perf-sched.sch_delay.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.03 ± 24%    +532.8%       0.19 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      0.00 ±223%  +75533.3%       0.76 ±191%  perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.04 ± 40%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.01 ± 14%  +14584.2%       0.93 ± 73%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.01 ± 72%   +3310.7%       0.48 ± 51%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.01 ± 27%   +1037.7%       0.10 ±117%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.00 ± 20%    +209.1%       0.01 ± 31%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.00 ± 14%     +95.0%       0.01 ± 21%  perf-sched.sch_delay.avg.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.02 ± 10%     +26.7%       0.02 ± 11%  perf-sched.sch_delay.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.02 ± 54%   +1344.3%       0.26 ± 55%  perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.01 ± 25%    +165.6%       0.03 ± 39%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 46%   +1596.3%       0.30 ± 34%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ± 41%    +203.5%       0.03 ± 24%  perf-sched.sch_delay.avg.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 37%   +3505.2%       0.58 ± 17%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.02 ± 18%   +3951.6%       0.63 ± 16%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.09 ± 50%    +202.1%       0.27 ± 33%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function.[unknown]
      0.01 ± 52%   +2595.8%       0.22 ± 22%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.08 ± 56%    +254.6%       0.27 ± 29%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
      0.01 ± 21%    +334.9%       0.05 ± 72%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.00 ± 71%   +1931.6%       0.06 ± 22%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.01 ±  6%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.01 ± 17%    +456.5%       0.04 ± 10%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      0.01          +563.3%       0.03 ± 16%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      0.01 ± 15%    +180.9%       0.02 ± 11%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.01 ± 14%    +112.5%       0.02 ± 28%  perf-sched.sch_delay.avg.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.00 ± 71%  +12773.7%       0.41 ± 95%  perf-sched.sch_delay.avg.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      0.01 ± 26%    +198.2%       0.03 ± 24%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.01          +588.1%       0.05 ±106%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.03 ± 15%     +77.1%       0.05 ± 10%  perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.21 ± 97%   +1950.0%       4.29 ±  8%  perf-sched.sch_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.39 ± 58%   +3818.5%      15.18 ± 49%  perf-sched.sch_delay.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.02 ±102%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      0.00 ±223%  +1.3e+05%       1.29 ±140%  perf-sched.sch_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.02 ± 89%    +171.0%       0.06 ± 29%  perf-sched.sch_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.20 ± 42%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.01 ± 15%  +47829.3%       3.28 ± 47%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.07 ±120%   +5227.9%       3.78 ± 15%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.58 ±218%   +3359.0%      19.97 ± 38%  perf-sched.sch_delay.max.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      1.16 ±139%    +893.1%      11.53 ± 77%  perf-sched.sch_delay.max.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
      0.02 ± 75%   +2692.5%       0.43 ±138%  perf-sched.sch_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.23 ± 95%    +383.4%       1.11 ± 44%  perf-sched.sch_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.36 ± 29%    +199.6%       1.08 ± 35%  perf-sched.sch_delay.max.ms.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
      0.11 ± 85%   +1384.4%       1.70 ± 55%  perf-sched.sch_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.18 ±140%   +2046.1%       3.87 ± 15%  perf-sched.sch_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.03 ± 70%    +165.2%       0.07 ± 20%  perf-sched.sch_delay.max.ms.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.18 ± 52%   +2490.2%       4.73 ±  6%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.08 ± 22%   +7683.6%       5.84 ± 49%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.37 ± 62%    +619.2%       2.65 ± 24%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function.[unknown]
      0.01 ± 69%   +7073.2%       0.98 ± 53%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.41 ± 50%    +651.7%       3.05 ± 28%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
      0.03 ± 97%   +1278.5%       0.40 ±109%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.27 ± 80%    +878.6%       2.68 ± 44%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      8.22 ± 21%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.20 ± 58%  +12192.1%      25.12 ± 23%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      4.01 ± 20%    +539.5%      25.63 ± 34%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      4.17 ± 23%    +244.1%      14.35 ± 74%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      0.00 ± 71%  +12773.7%       0.41 ± 95%  perf-sched.sch_delay.max.ms.schedule_timeout.khugepaged_wait_work.khugepaged.kthread
      1.69 ±193%    +376.3%       8.03 ± 56%  perf-sched.sch_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.39 ± 70%   +7744.0%      30.77 ±171%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ±  6%    +721.6%       0.05 ±  7%  perf-sched.total_sch_delay.average.ms
      9.35 ± 15%    +418.9%      48.50 ± 92%  perf-sched.total_sch_delay.max.ms
      1.72          +486.2%      10.09 ±  2%  perf-sched.total_wait_and_delay.average.ms
    933796           -87.2%     119247        perf-sched.total_wait_and_delay.count.ms
      1.71          +485.4%      10.04 ±  2%  perf-sched.total_wait_time.average.ms
     61.83 ±  4%    +127.3%     140.56 ± 12%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.47          -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.21 ±  4%    +529.1%       1.29 ±  3%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      0.17 ±  6%    +516.8%       1.06 ±  5%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      3.75           +11.4%       4.18        perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    469.33 ±  5%      -9.9%     422.67 ±  8%  perf-sched.wait_and_delay.count.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      2200 ±  2%     -17.3%       1819 ±  7%  perf-sched.wait_and_delay.count.anon_pipe_read.vfs_read.ksys_read.do_syscall_64
    253.83 ±  4%     -64.0%      91.50 ± 12%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
    886768          -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      5766 ±  4%     +87.3%      10801        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      1330           -10.0%       1197        perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      1370 ±  2%     -22.4%       1062 ±  2%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      8.91 ± 11%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      6.57 ± 17%    +290.0%      25.63 ± 34%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      7.70 ±  4%    +135.8%      18.14 ± 42%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      5.94 ± 22%    +184.6%      16.92 ± 62%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3519 ± 12%     -45.8%       1909 ± 14%  perf-sched.wait_and_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.42 ±  9%    +154.1%       1.07 ± 14%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      0.44          +153.8%       1.12 ±  3%  perf-sched.wait_time.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.45 ±  4%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      0.00 ±223%  +68918.2%       1.27 ±103%  perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.49 ±  6%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.43 ± 11%    +294.3%       1.70 ± 47%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.36 ± 23%    +195.7%       1.08 ± 27%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.12 ± 17%    +655.8%       0.88 ±  4%  perf-sched.wait_time.avg.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      0.13 ± 34%    +528.4%       0.80 ±  8%  perf-sched.wait_time.avg.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
      4.18 ±201%   +1368.5%      61.40 ± 55%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.43 ±  4%    +332.3%       1.85 ± 98%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.34 ± 15%    +171.8%       0.94 ± 11%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.29 ± 32%     +58.8%       0.46 ± 31%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
     61.82 ±  4%    +127.2%     140.49 ± 12%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.47          -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      0.38 ±  4%    +106.3%       0.79 ±  6%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      0.20 ±  4%    +528.3%       1.26 ±  4%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      0.16 ±  7%    +532.3%       1.04 ±  5%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      1.02 ±  2%     +17.3%       1.20        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      3.74           +11.0%       4.15        perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.78 ± 13%    +596.9%       5.41 ± 17%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio
      2.03 ± 62%    +451.4%      11.19 ± 45%  perf-sched.wait_time.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.do_madvise.__x64_sys_madvise
      0.58 ± 20%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      0.00 ±223%  +1.4e+05%       2.50 ± 62%  perf-sched.wait_time.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.79 ± 20%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_do_behavior
      0.54 ± 22%    +738.7%       4.51 ± 19%  perf-sched.wait_time.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.55 ± 17%    +870.1%       5.33 ± 20%  perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      1.63 ± 71%    +626.3%      11.81 ± 20%  perf-sched.wait_time.max.ms.__vma_start_write.__split_vma.vms_gather_munmap_vmas.do_vmi_align_munmap
      1.92 ± 76%    +485.1%      11.26 ± 15%  perf-sched.wait_time.max.ms.__vma_start_write.vma_expand.vma_merge_new_range.__mmap_region
     38.18           +13.8%      43.45 ±  3%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
    169.52 ±219%    +392.5%     834.84 ± 44%  perf-sched.wait_time.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.04 ± 41%  +16368.0%     171.38 ±216%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.81 ± 10%    +674.5%       6.31 ± 13%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.69 ± 17%    +466.7%       3.90 ± 41%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function.[unknown]
      0.75 ± 20%    +378.5%       3.57 ± 24%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown]
      4.51 ±  2%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.madvise_lock
      1.89 ± 66%    +602.4%      13.28 ± 15%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read_killable.lock_mm_and_find_vma
      4.53 ±  3%    +200.4%      13.61 ± 20%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.__vm_munmap
      4.36 ±  2%    +187.3%      12.53 ± 14%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write_killable.vm_mmap_pgoff
      3.75 ±  3%     +34.3%       5.03 ±  7%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      5.17          +106.1%      10.66 ± 49%  perf-sched.wait_time.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3519 ± 12%     -45.8%       1909 ± 14%  perf-sched.wait_time.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     30.63           -27.7        2.97 ±  2%  perf-profile.calltrace.cycles-pp.common_startup_64
     30.33           -27.4        2.94 ±  2%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
     30.32           -27.4        2.94 ±  2%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
     30.31           -27.4        2.94 ±  2%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     27.76           -25.0        2.78 ±  2%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
     26.94           -24.2        2.75 ±  2%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
     26.80           -24.1        2.74 ±  2%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
     11.17 ±  2%     -11.2        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
     11.04 ±  2%     -11.0        0.00        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
     10.90 ±  2%     -10.9        0.00        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state.cpuidle_enter
     10.86 ±  2%     -10.9        0.00        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.cpuidle_enter_state
     13.30 ±  2%      -9.2        4.10        perf-profile.calltrace.cycles-pp.flush_tlb_func.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      9.07            -9.0        0.08 ±223%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      8.80 ±  3%      -8.8        0.00        perf-profile.calltrace.cycles-pp.madvise_lock.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.78 ±  3%      -8.8        0.00        perf-profile.calltrace.cycles-pp.down_read.madvise_lock.do_madvise.__x64_sys_madvise.do_syscall_64
      8.12 ±  3%      -8.1        0.00        perf-profile.calltrace.cycles-pp.rwsem_down_read_slowpath.down_read.madvise_lock.do_madvise.__x64_sys_madvise
      5.85 ±  4%      -5.9        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.madvise_lock.do_madvise
      5.72 ±  5%      -5.7        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irq.rwsem_down_read_slowpath.down_read.madvise_lock
      5.27 ±  2%      -4.7        0.59        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.intel_idle_irq.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      4.13 ±  3%      -2.7        1.40 ±  2%  perf-profile.calltrace.cycles-pp.intel_idle_irq.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      1.27 ±  5%      -0.2        1.11 ±  6%  perf-profile.calltrace.cycles-pp.lock_vma_under_rcu.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.59 ±  4%      +0.3        0.84 ±  3%  perf-profile.calltrace.cycles-pp.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.64 ±  6%      +0.4        1.02 ±  9%  perf-profile.calltrace.cycles-pp.zap_pte_range.zap_pmd_range.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free
      0.66 ±  5%      +0.4        1.06 ±  8%  perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior
      0.00            +0.5        0.52        perf-profile.calltrace.cycles-pp.error_entry.testcase
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.00            +0.5        0.53        perf-profile.calltrace.cycles-pp.alloc_pages_mpol.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.testcase
      0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.testcase
      0.00            +0.6        0.56 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      0.00            +0.6        0.57        perf-profile.calltrace.cycles-pp._raw_spin_lock.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.6        0.57        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      0.00            +0.6        0.58        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.testcase
      0.00            +0.6        0.59 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
      1.81            +0.6        2.40        perf-profile.calltrace.cycles-pp.default_send_IPI_mask_sequence_phys.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
      0.00            +0.6        0.60 ±  4%  perf-profile.calltrace.cycles-pp.tlb_gather_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00            +0.6        0.61        perf-profile.calltrace.cycles-pp.vma_alloc_folio_noprof.alloc_anon_folio.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.00            +0.6        0.64        perf-profile.calltrace.cycles-pp.__pte_offset_map_lock.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.7        0.66        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.testcase
      0.00            +0.7        0.68        perf-profile.calltrace.cycles-pp.folio_batch_move_lru.folio_add_lru.do_anonymous_page.__handle_mm_fault.handle_mm_fault
      1.28            +0.7        1.99        perf-profile.calltrace.cycles-pp.__irqentry_text_end.testcase
      0.00            +0.8        0.78        perf-profile.calltrace.cycles-pp.folio_add_lru.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.00            +0.8        0.82        perf-profile.calltrace.cycles-pp._find_next_bit.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
      1.75 ±  5%      +0.8        2.58 ±  7%  perf-profile.calltrace.cycles-pp.madvise_do_behavior.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.00 ±  3%      +1.0        3.05 ±  4%  perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      1.68 ±  4%      +1.0        2.73 ±  4%  perf-profile.calltrace.cycles-pp.do_anonymous_page.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      0.00            +1.2        1.16 ±  8%  perf-profile.calltrace.cycles-pp.unmap_page_range.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas
      2.24 ±  4%      +1.2        3.42 ±  4%  perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      4.14 ±  3%      +1.6        5.73 ±  4%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.testcase
      4.19 ±  3%      +1.6        5.80 ±  4%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.testcase
      0.00            +1.7        1.72 ±  8%  perf-profile.calltrace.cycles-pp.zap_page_range_single_batched.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior
      0.00            +1.8        1.79 ±  8%  perf-profile.calltrace.cycles-pp.madvise_dontneed_free.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior.do_madvise
      0.00            +1.8        1.81 ±  7%  perf-profile.calltrace.cycles-pp.madvise_vma_behavior.madvise_walk_vmas.madvise_do_behavior.do_madvise.__x64_sys_madvise
      4.60 ±  3%      +1.9        6.47 ±  3%  perf-profile.calltrace.cycles-pp.asm_exc_page_fault.testcase
      0.00            +2.5        2.53 ±  7%  perf-profile.calltrace.cycles-pp.madvise_walk_vmas.madvise_do_behavior.do_madvise.__x64_sys_madvise.do_syscall_64
      6.85 ±  2%      +3.2       10.04 ±  2%  perf-profile.calltrace.cycles-pp.testcase
      4.33            +4.0        8.32        perf-profile.calltrace.cycles-pp.llist_reverse_order.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function
      6.67            +8.0       14.63        perf-profile.calltrace.cycles-pp.__flush_smp_call_function_queue.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond
      6.78            +8.0       14.79        perf-profile.calltrace.cycles-pp.__sysvec_call_function.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask
      7.08            +8.2       15.29        perf-profile.calltrace.cycles-pp.sysvec_call_function.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range
      8.54            +9.2       17.76        perf-profile.calltrace.cycles-pp.asm_sysvec_call_function.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu
     59.46           +23.9       83.35        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     59.18           +23.9       83.10        perf-profile.calltrace.cycles-pp.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     59.20           +23.9       83.12        perf-profile.calltrace.cycles-pp.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe.__madvise
     59.65           +24.0       83.66        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__madvise
     61.21           +24.7       85.94        perf-profile.calltrace.cycles-pp.__madvise
     46.20           +31.8       77.95        perf-profile.calltrace.cycles-pp.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise
     45.45           +31.8       77.24        perf-profile.calltrace.cycles-pp.smp_call_function_many_cond.on_each_cpu_cond_mask.flush_tlb_mm_range.tlb_finish_mmu.do_madvise
     46.86           +31.8       78.69        perf-profile.calltrace.cycles-pp.flush_tlb_mm_range.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64
     47.79           +32.0       79.84        perf-profile.calltrace.cycles-pp.tlb_finish_mmu.do_madvise.__x64_sys_madvise.do_syscall_64.entry_SYSCALL_64_after_hwframe
     30.63           -27.7        2.97 ±  2%  perf-profile.children.cycles-pp.common_startup_64
     30.63           -27.7        2.97 ±  2%  perf-profile.children.cycles-pp.cpu_startup_entry
     30.62           -27.7        2.97 ±  2%  perf-profile.children.cycles-pp.do_idle
     30.33           -27.4        2.94 ±  2%  perf-profile.children.cycles-pp.start_secondary
     28.04           -25.2        2.80 ±  2%  perf-profile.children.cycles-pp.cpuidle_idle_call
     27.21           -24.4        2.78 ±  2%  perf-profile.children.cycles-pp.cpuidle_enter
     27.20           -24.4        2.78 ±  2%  perf-profile.children.cycles-pp.cpuidle_enter_state
     15.16 ±  2%      -9.6        5.60        perf-profile.children.cycles-pp.flush_tlb_func
      8.80 ±  3%      -8.8        0.00        perf-profile.children.cycles-pp.madvise_lock
      8.79 ±  3%      -8.8        0.01 ±223%  perf-profile.children.cycles-pp.down_read
      9.18            -8.7        0.48 ±  3%  perf-profile.children.cycles-pp.intel_idle
      8.17 ±  3%      -8.0        0.12 ±  4%  perf-profile.children.cycles-pp.rwsem_down_read_slowpath
      5.91 ±  4%      -5.9        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irq
      5.98 ±  4%      -5.5        0.43 ±  2%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     24.46            -5.3       19.20        perf-profile.children.cycles-pp.__flush_smp_call_function_queue
     26.95            -5.2       21.74        perf-profile.children.cycles-pp.asm_sysvec_call_function
     23.53            -4.6       18.93        perf-profile.children.cycles-pp.__sysvec_call_function
     24.21            -4.6       19.65        perf-profile.children.cycles-pp.sysvec_call_function
      5.83 ±  2%      -3.6        2.21 ±  2%  perf-profile.children.cycles-pp.intel_idle_irq
      2.93 ±  2%      -2.7        0.24 ±  3%  perf-profile.children.cycles-pp.__schedule
      1.56 ±  3%      -1.5        0.10        perf-profile.children.cycles-pp.schedule_idle
      1.40 ±  2%      -1.3        0.12 ±  4%  perf-profile.children.cycles-pp.schedule_preempt_disabled
      1.39 ±  2%      -1.2        0.14 ±  2%  perf-profile.children.cycles-pp.schedule
      0.83 ±  3%      -0.8        0.05        perf-profile.children.cycles-pp.flush_smp_call_function_queue
      0.67 ±  3%      -0.6        0.09 ±  4%  perf-profile.children.cycles-pp.__pick_next_task
      0.62 ±  3%      -0.5        0.08 ±  5%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.53 ±  3%      -0.5        0.07 ±  5%  perf-profile.children.cycles-pp.finish_task_switch
      0.47 ±  5%      -0.4        0.08 ±  6%  perf-profile.children.cycles-pp.sched_balance_newidle
      0.46 ±  5%      -0.4        0.09 ±  5%  perf-profile.children.cycles-pp.sched_balance_rq
      0.38 ±  4%      -0.3        0.07        perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.38 ±  4%      -0.3        0.07        perf-profile.children.cycles-pp.update_sd_lb_stats
      0.35 ±  5%      -0.3        0.06        perf-profile.children.cycles-pp.update_sg_lb_stats
      0.31            -0.2        0.09        perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.31            -0.2        0.10        perf-profile.children.cycles-pp.__mmap
      0.25            -0.2        0.08 ±  7%  perf-profile.children.cycles-pp.handle_softirqs
      0.30 ±  3%      -0.2        0.14 ±  3%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.60            -0.1        0.47        perf-profile.children.cycles-pp.__vm_munmap
      0.60            -0.1        0.47        perf-profile.children.cycles-pp.__x64_sys_munmap
      0.61            -0.1        0.48        perf-profile.children.cycles-pp.__munmap
      0.47            -0.1        0.36        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      0.20            -0.1        0.10 ±  4%  perf-profile.children.cycles-pp.down_write_killable
      0.19 ±  2%      -0.1        0.10 ±  5%  perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      0.18 ±  2%      -0.1        0.09 ±  4%  perf-profile.children.cycles-pp.update_load_avg
      0.49            -0.1        0.40        perf-profile.children.cycles-pp.do_vmi_align_munmap
      0.56            -0.1        0.47        perf-profile.children.cycles-pp.__irq_exit_rcu
      0.49            -0.1        0.40        perf-profile.children.cycles-pp.do_vmi_munmap
      0.20 ±  2%      -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.native_sched_clock
      0.08 ±  5%      -0.0        0.07 ±  5%  perf-profile.children.cycles-pp.irqentry_enter
      0.06            +0.0        0.07        perf-profile.children.cycles-pp.native_apic_mem_eoi
      0.23 ±  2%      +0.0        0.25        perf-profile.children.cycles-pp.sched_clock_cpu
      0.05 ±  7%      +0.0        0.09        perf-profile.children.cycles-pp.free_unref_folios
      0.09 ±  5%      +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.rmqueue
      0.07 ±  6%      +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.mod_memcg_lruvec_state
      0.02 ± 99%      +0.0        0.07 ±  7%  perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.06 ± 14%      +0.0        0.11 ± 11%  perf-profile.children.cycles-pp.__folio_mod_stat
      0.06 ±  9%      +0.0        0.10 ±  3%  perf-profile.children.cycles-pp.lru_gen_del_folio
      0.06 ±  8%      +0.0        0.10        perf-profile.children.cycles-pp.lru_gen_add_folio
      0.08 ± 14%      +0.0        0.12 ±  8%  perf-profile.children.cycles-pp.count_memcg_events
      0.12 ± 11%      +0.1        0.17 ±  9%  perf-profile.children.cycles-pp.__lruvec_stat_mod_folio
      0.00            +0.1        0.05        perf-profile.children.cycles-pp.___pte_offset_map
      0.00            +0.1        0.05        perf-profile.children.cycles-pp._raw_spin_trylock
      0.20 ±  2%      +0.1        0.25 ±  2%  perf-profile.children.cycles-pp.zap_present_ptes
      0.17 ±  4%      +0.1        0.22 ±  2%  perf-profile.children.cycles-pp.___perf_sw_event
      0.01 ±223%      +0.1        0.06        perf-profile.children.cycles-pp.irq_exit_rcu
      0.01 ±223%      +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.get_jiffies_update
      0.75            +0.1        0.81        perf-profile.children.cycles-pp._raw_spin_lock
      0.00            +0.1        0.06 ±  6%  perf-profile.children.cycles-pp.__rmqueue_pcplist
      0.00            +0.1        0.06 ± 11%  perf-profile.children.cycles-pp.try_charge_memcg
      0.10 ±  7%      +0.1        0.16 ±  8%  perf-profile.children.cycles-pp.folio_add_new_anon_rmap
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.00            +0.1        0.06        perf-profile.children.cycles-pp.get_vma_policy
      0.01 ±223%      +0.1        0.07 ± 10%  perf-profile.children.cycles-pp.charge_memcg
      0.71            +0.1        0.77        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.13 ±  3%      +0.1        0.19 ±  3%  perf-profile.children.cycles-pp.free_pages_and_swap_cache
      0.07 ±  5%      +0.1        0.13 ±  2%  perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
      0.01 ±223%      +0.1        0.07 ±  6%  perf-profile.children.cycles-pp.handle_pte_fault
      0.09 ±  4%      +0.1        0.16 ±  3%  perf-profile.children.cycles-pp.lru_add
      0.12 ±  3%      +0.1        0.19        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.00            +0.1        0.07        perf-profile.children.cycles-pp.unmap_vmas
      0.15 ±  3%      +0.1        0.23 ±  2%  perf-profile.children.cycles-pp.clear_page_erms
      0.14 ±  3%      +0.1        0.22 ±  3%  perf-profile.children.cycles-pp.__tlb_batch_free_encoded_pages
      0.30            +0.1        0.37        perf-profile.children.cycles-pp.irqtime_account_irq
      0.00            +0.1        0.08 ±  4%  perf-profile.children.cycles-pp.down_read_killable
      0.00            +0.1        0.09 ±  4%  perf-profile.children.cycles-pp.lock_mm_and_find_vma
      0.12 ±  4%      +0.1        0.21        perf-profile.children.cycles-pp.__page_cache_release
      0.17 ±  2%      +0.1        0.27 ±  3%  perf-profile.children.cycles-pp.__perf_sw_event
      0.00            +0.1        0.11 ±  6%  perf-profile.children.cycles-pp.update_cfs_group
      0.26            +0.1        0.39        perf-profile.children.cycles-pp.get_page_from_freelist
      0.22 ±  2%      +0.1        0.36        perf-profile.children.cycles-pp.sync_regs
      0.13 ±  3%      +0.1        0.26 ±  2%  perf-profile.children.cycles-pp.mm_needs_global_asid
      0.32            +0.2        0.48        perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.31 ±  2%      +0.2        0.48        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.34            +0.2        0.50        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.16 ±  2%      +0.2        0.32        perf-profile.children.cycles-pp.vms_clear_ptes
      0.37            +0.2        0.54        perf-profile.children.cycles-pp.native_flush_tlb_local
      0.36 ±  2%      +0.2        0.54        perf-profile.children.cycles-pp.alloc_pages_mpol
      0.05            +0.2        0.24 ±  4%  perf-profile.children.cycles-pp.task_tick_fair
      0.12 ±  3%      +0.2        0.31 ±  3%  perf-profile.children.cycles-pp.sched_tick
      0.41            +0.2        0.61        perf-profile.children.cycles-pp.vma_alloc_folio_noprof
      1.01            +0.2        1.21        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.77 ±  2%      +0.2        0.98        perf-profile.children.cycles-pp._find_next_bit
      0.41 ±  5%      +0.2        0.62 ±  4%  perf-profile.children.cycles-pp.tlb_gather_mmu
      0.30 ±  3%      +0.2        0.51        perf-profile.children.cycles-pp.folios_put_refs
      0.19 ± 11%      +0.2        0.40 ±  5%  perf-profile.children.cycles-pp.flush_tlb_batched_pending
      0.22 ±  3%      +0.2        0.46 ±  2%  perf-profile.children.cycles-pp.update_process_times
      0.35 ±  3%      +0.2        0.58 ±  2%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.26 ±  4%      +0.2        0.50 ±  2%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.42 ±  2%      +0.2        0.66        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.42 ±  2%      +0.2        0.66        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.59 ±  4%      +0.3        0.85 ±  2%  perf-profile.children.cycles-pp.alloc_anon_folio
      0.37            +0.3        0.68        perf-profile.children.cycles-pp.folio_batch_move_lru
      0.77            +0.3        1.08        perf-profile.children.cycles-pp.native_irq_return_iret
      0.53            +0.3        0.87 ±  2%  perf-profile.children.cycles-pp.__pte_offset_map_lock
      1.29 ±  5%      +0.3        1.63 ±  7%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.43 ±  2%      +0.4        0.79        perf-profile.children.cycles-pp.folio_add_lru
      0.74            +0.4        1.12        perf-profile.children.cycles-pp.error_entry
      0.68 ±  5%      +0.4        1.08 ±  9%  perf-profile.children.cycles-pp.zap_pte_range
      0.82 ±  4%      +0.4        1.23 ±  7%  perf-profile.children.cycles-pp.unmap_page_range
      0.70 ±  5%      +0.4        1.12 ±  7%  perf-profile.children.cycles-pp.zap_pmd_range
      1.24 ±  7%      +0.6        1.82 ±  7%  perf-profile.children.cycles-pp.madvise_vma_behavior
      1.22 ±  7%      +0.6        1.79 ±  8%  perf-profile.children.cycles-pp.madvise_dontneed_free
      1.88            +0.6        2.48        perf-profile.children.cycles-pp.default_send_IPI_mask_sequence_phys
      1.10 ±  7%      +0.6        1.73 ±  8%  perf-profile.children.cycles-pp.zap_page_range_single_batched
      1.34            +0.7        2.06        perf-profile.children.cycles-pp.__irqentry_text_end
      1.75 ±  5%      +0.8        2.58 ±  7%  perf-profile.children.cycles-pp.madvise_do_behavior
      2.02 ±  3%      +1.0        3.06 ±  4%  perf-profile.children.cycles-pp.__handle_mm_fault
      1.68 ±  4%      +1.1        2.74 ±  4%  perf-profile.children.cycles-pp.do_anonymous_page
      2.26 ±  4%      +1.2        3.44 ±  4%  perf-profile.children.cycles-pp.handle_mm_fault
      4.18 ±  3%      +1.6        5.78 ±  4%  perf-profile.children.cycles-pp.do_user_addr_fault
      4.20 ±  3%      +1.6        5.81 ±  4%  perf-profile.children.cycles-pp.exc_page_fault
      4.90 ±  3%      +2.0        6.95 ±  3%  perf-profile.children.cycles-pp.asm_exc_page_fault
      0.00            +2.5        2.54 ±  7%  perf-profile.children.cycles-pp.madvise_walk_vmas
      7.33 ±  2%      +3.5       10.82 ±  2%  perf-profile.children.cycles-pp.testcase
      6.34            +4.5       10.81        perf-profile.children.cycles-pp.llist_reverse_order
     60.44           +23.5       83.96        perf-profile.children.cycles-pp.do_syscall_64
     60.63           +23.6       84.27        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     59.18           +23.9       83.11        perf-profile.children.cycles-pp.do_madvise
     59.20           +23.9       83.12        perf-profile.children.cycles-pp.__x64_sys_madvise
     61.26           +24.8       86.01        perf-profile.children.cycles-pp.__madvise
     46.32           +31.9       78.20        perf-profile.children.cycles-pp.smp_call_function_many_cond
     46.32           +31.9       78.20        perf-profile.children.cycles-pp.on_each_cpu_cond_mask
     46.99           +32.0       78.95        perf-profile.children.cycles-pp.flush_tlb_mm_range
     47.93           +32.2       80.11        perf-profile.children.cycles-pp.tlb_finish_mmu
     14.64 ±  2%      -9.9        4.79        perf-profile.self.cycles-pp.flush_tlb_func
      9.18            -8.7        0.48 ±  3%  perf-profile.self.cycles-pp.intel_idle
      5.95 ±  4%      -5.6        0.37 ±  2%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      3.14 ±  3%      -1.2        1.96 ±  2%  perf-profile.self.cycles-pp.intel_idle_irq
      0.25 ±  5%      -0.2        0.05 ±  7%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.55 ±  2%      -0.1        0.41        perf-profile.self.cycles-pp._raw_spin_lock
      0.42 ±  7%      -0.1        0.36 ± 13%  perf-profile.self.cycles-pp.mas_walk
      0.23 ±  7%      -0.0        0.19 ± 14%  perf-profile.self.cycles-pp.__handle_mm_fault
      0.20 ±  2%      -0.0        0.18 ±  2%  perf-profile.self.cycles-pp.native_sched_clock
      0.08            -0.0        0.07        perf-profile.self.cycles-pp.sched_core_idle_cpu
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.do_syscall_64
      0.05            +0.0        0.06 ±  6%  perf-profile.self.cycles-pp.irqentry_enter
      0.05 ±  8%      +0.0        0.07 ±  7%  perf-profile.self.cycles-pp.native_apic_mem_eoi
      0.07 ±  7%      +0.0        0.08 ±  4%  perf-profile.self.cycles-pp.folios_put_refs
      0.06 ±  8%      +0.0        0.07 ±  6%  perf-profile.self.cycles-pp.mod_memcg_lruvec_state
      0.07            +0.0        0.09        perf-profile.self.cycles-pp.zap_present_ptes
      0.10 ±  4%      +0.0        0.12 ±  3%  perf-profile.self.cycles-pp.asm_sysvec_call_function
      0.06 ±  6%      +0.0        0.08        perf-profile.self.cycles-pp.__irq_exit_rcu
      0.12 ±  3%      +0.0        0.15 ±  2%  perf-profile.self.cycles-pp.sysvec_call_function
      0.12 ±  4%      +0.0        0.15 ±  4%  perf-profile.self.cycles-pp.___perf_sw_event
      0.05            +0.0        0.08        perf-profile.self.cycles-pp.__alloc_frozen_pages_noprof
      0.05 ±  7%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.folio_add_lru
      0.10 ±  3%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.irqtime_account_irq
      0.05 ± 45%      +0.0        0.08 ±  5%  perf-profile.self.cycles-pp.count_memcg_events
      0.08 ±  6%      +0.0        0.12        perf-profile.self.cycles-pp.__madvise
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__pte_offset_map_lock
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.asm_exc_page_fault
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.get_vma_policy
      0.01 ±223%      +0.1        0.06 ±  6%  perf-profile.self.cycles-pp.get_jiffies_update
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.lru_add
      0.00            +0.1        0.05 ±  8%  perf-profile.self.cycles-pp.zap_pte_range
      0.13 ±  2%      +0.1        0.18 ±  3%  perf-profile.self.cycles-pp.clear_page_erms
      0.11 ±  3%      +0.1        0.17        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.00            +0.1        0.07 ±  5%  perf-profile.self.cycles-pp.lru_gen_del_folio
      0.00            +0.1        0.07        perf-profile.self.cycles-pp.lru_gen_add_folio
      0.64 ±  3%      +0.1        0.74        perf-profile.self.cycles-pp._find_next_bit
      0.10 ±  4%      +0.1        0.20 ±  3%  perf-profile.self.cycles-pp.mm_needs_global_asid
      0.66 ±  7%      +0.1        0.76 ±  4%  perf-profile.self.cycles-pp.tlb_finish_mmu
      0.00            +0.1        0.11 ±  6%  perf-profile.self.cycles-pp.update_cfs_group
      0.20 ±  3%      +0.1        0.32        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.00            +0.1        0.13 ±  3%  perf-profile.self.cycles-pp.madvise_walk_vmas
      0.22 ±  2%      +0.1        0.35 ±  2%  perf-profile.self.cycles-pp.sync_regs
      0.34 ±  5%      +0.2        0.50 ±  4%  perf-profile.self.cycles-pp.tlb_gather_mmu
      0.80 ±  6%      +0.2        0.96 ±  5%  perf-profile.self.cycles-pp.lock_vma_under_rcu
      0.31 ±  2%      +0.2        0.47        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.19 ±  2%      +0.2        0.35        perf-profile.self.cycles-pp.do_user_addr_fault
      0.16 ± 10%      +0.2        0.32 ±  6%  perf-profile.self.cycles-pp.flush_tlb_batched_pending
      0.32            +0.2        0.48        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.36            +0.2        0.53        perf-profile.self.cycles-pp.native_flush_tlb_local
      0.27 ± 16%      +0.2        0.45 ±  9%  perf-profile.self.cycles-pp.zap_page_range_single_batched
      0.32 ±  4%      +0.2        0.53 ±  7%  perf-profile.self.cycles-pp.flush_tlb_mm_range
      0.77            +0.3        1.08        perf-profile.self.cycles-pp.native_irq_return_iret
      0.54            +0.3        0.88        perf-profile.self.cycles-pp.testcase
      0.73            +0.4        1.11        perf-profile.self.cycles-pp.error_entry
      1.49            +0.4        1.90        perf-profile.self.cycles-pp.default_send_IPI_mask_sequence_phys
      2.32            +0.6        2.93        perf-profile.self.cycles-pp.__flush_smp_call_function_queue
      1.34            +0.7        2.06        perf-profile.self.cycles-pp.__irqentry_text_end
      6.26            +4.5       10.76        perf-profile.self.cycles-pp.llist_reverse_order
     35.86           +21.9       57.76        perf-profile.self.cycles-pp.smp_call_function_many_cond





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


