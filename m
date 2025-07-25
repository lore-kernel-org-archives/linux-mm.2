Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A557C87FCD
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 09:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9E16B007B; Fri, 25 Jul 2025 05:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879066B0088; Fri, 25 Jul 2025 05:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8C36B0089; Fri, 25 Jul 2025 05:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 174AF6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:12:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45E768065B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:12:02 +0000 (UTC)
X-FDA: 83702220084.30.5C8D4CB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 531E3C0006
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:11:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H9U5J58L;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753434718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQ+EIJN144UXi0hSfQaj8Z0Ef5UrYe0xV1nazsz4yzU=;
	b=Kdh2vw2tToJanC7TaxOO/W0i5JCUDH+uZ0W8D217+DMnTnJx+VlySSMEdzCzelKG6fzznv
	+2DGPfYIPUOnP5eBFcicCvDXv/mQaTWESYDU7uKuNLFhAKTvnIgOxvZPDcRMgJCFzfYNwk
	41KglkOpQRw2Z2XnVPZfKolfrQDtYEU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753434718; a=rsa-sha256;
	cv=fail;
	b=8lQU1xTXPLcHwr45mnVbcHQ1momlPV/c7UeisvZXrEESXUCHvhlvOgdl0HOuqFqBs0WBGy
	UfcTFtJ5HF4nsyuroMaW4T1rKMQBN/YW3JkTx4+20xW1s2WLEVJ55BZhmu9ekK1Oi5tZWe
	VoAjK3K/vHIEJVSlyH1ZbupwTZCTXRs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H9U5J58L;
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753434717; x=1784970717;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I3wzq75w07yh0vE2xABYJploQLpoitemTSKCSAqnTLs=;
  b=H9U5J58LAs+g903kCPHhKSn5ZXYEs1cUGsKkO3f8Rg7h388pxcPaLFO7
   i0cFsMz/5PnNzsUntlZBuNO0NckUnYqpUxrym29GXXKxTFbpT7XApHo0t
   rPqaiUds1dUGuzUGk/2PkpI4CdXzBFAtJBXeRNBMZKasRkjsw2XcPONy2
   ZeytkwGFiK2yYVk3ZJZWfF4qpWRTxgI2wLM/7MxzPxPjptRuDTpHw0Que
   rOTXCmWYK2gilI2dgbGZH+tA8JX2z3sMbX0l86nPFKqTRWNJ3JU9chSE5
   nufgozXbi0gw+TkKouh7xR5ItSqDNPvmCJG9RPc27iXQwrcqPEcKOewuE
   A==;
X-CSE-ConnectionGUID: qUE8XlczT52gLIb+ZPKrxA==
X-CSE-MsgGUID: nAHGVTpwQJ2uK5O/oQGaaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55622634"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="xz'341?scan'341,208,341";a="55622634"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 02:11:49 -0700
X-CSE-ConnectionGUID: IuRFNZzwSOOibtZtINyIMA==
X-CSE-MsgGUID: +05Cs1IgRq6LbkfL7rVi+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="xz'341?scan'341,208,341";a="164855401"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 02:11:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 02:11:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 02:11:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 02:11:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhgpqrmS1MV0pw300knuD8vroJeNpj9QPxjbJyK/cCf1uU95nTkAhGWXBQ2CjhxF2/+WPCQ/hZ8ppQCW67dheMdl2LkzaRSNz909anOMximajK/X6jOliC5Poj570jZ00J75vKN5zP2e686vbIy+4NkZbCqE8u4ML3rpeGCO5dzcE7HmVm+M53pIRNDiAhleCEdhKd1hMhoNDu+dol0VgxK8PrCOa9ZKVdISYbOKOs+x7gxHglPScZfC6XUQWv2btttZyWsTm2kbzt6NPmVXChu5JtHRf/G2rMars+Bf5EZRUfThoPoWAaHm7oYQzxCbtyK2NKz495Gyg++nmNzx4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YveAyAniH4syO+DjsPnf+JHDpHGCSsDGOQHcFZIf/fo=;
 b=ePVx8TZg5REwpBw3rxjP7wkJNzYCk7WVZenHSZIrtOio0liGItrq0FWROgZcTU1dwrvxsKBQqs1jD5l2pbXRd7sBW/A8X/QsxI5NXeeBgksSNVkfJ+W78JSxnG8eoLtGZTSfMI8E7PPpjY/zFRPaUUvipIRe88tHRgBEGLI9FTW9QLKN2CsUAwK5kHRJ/PEsIUA14kVdfuP5//C7/CUBUOyKKdtxPkA1ngnWXqjvXHQzAdAms1GU4ThurlEzgdPtiJG3n5DWV2KNt/NO9s6ftyM94LMU2GVmX1eVxKkfgGnVMHzhMyNCMHXoOFWnX4Mrhq6gziLVHtq1huX3jgwiXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB6403.namprd11.prod.outlook.com (2603:10b6:510:1f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Fri, 25 Jul
 2025 09:10:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8943.029; Fri, 25 Jul 2025
 09:10:37 +0000
Date: Fri, 25 Jul 2025 17:10:25 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>, <linux-mm@kvack.org>,
	<ltp@lists.linux.it>, <oliver.sang@intel.com>
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
Message-ID: <aINKAQt3qcj2s38N@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com>
 <87a54usty4.ffs@tglx>
Content-Type: multipart/mixed; boundary="HSMJNboiLersl0nZ"
Content-Disposition: inline
In-Reply-To: <87a54usty4.ffs@tglx>
X-ClientProxiedBy: SG2P153CA0046.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::15)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB6403:EE_
X-MS-Office365-Filtering-Correlation-Id: edaaf9da-5a60-4b4e-214a-08ddcb5b1db4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|4053099003;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?A6jbhy7hU9oPYv0V3QHszjOn6VQE+SeQHAolAyVFbwVHf1cN25PPTxyVG1VN?=
 =?us-ascii?Q?Bli2tDN/zR8l7kj8RmReCT/RzSnMMg7M6N0cpCU8lAux+w1jKrDt+xMkTpaQ?=
 =?us-ascii?Q?qn0x5jIxgDfC2donRksdl/BBbEIS/HHWFyQbOHBMYPD1C9/1O538F8rbNvTk?=
 =?us-ascii?Q?KxBAHrjhzVcO29NeSK8caUKOvE4v1vWlU3rrAM3MBZsHiuGTasEuzRyneM7I?=
 =?us-ascii?Q?DuV8gnlW1zvN5IUzjKYQuyNS8R4Dm2UafR5iCevv1WABxRWtdD1GBPvGM2kK?=
 =?us-ascii?Q?7NAt2trn4Qyfmn5j7q/uhARObKxV0p63iXro3cF5A7JVwoAYb0zE+e3LLbsA?=
 =?us-ascii?Q?ivsPtEs/p6yRIPObrYLaMKJ/iOsQtCj3k/KkK2whawykRmH/9jGygAKCcudc?=
 =?us-ascii?Q?VVHMJgrKYNizL9Sb4UOvXqmzcF6TCb+88xUe7U+je/i8NVsOpe2iDrAO513P?=
 =?us-ascii?Q?hSf+mP6coJ8xvQfl44x0aZ9uVUnAeai2kL9J0P0R0QqUP6igOnjQOcoLwqON?=
 =?us-ascii?Q?MP/vQqTV9ENIzdQDTghoWEvD7W8bYTFwzNZVTpt8n4O8Y72ImqXXeBbUeU3u?=
 =?us-ascii?Q?M13bafYzRHTdme+2Goz8ldL/e1mhWlny+u4fBfiJevuw/CtmZpBE0mkglnbl?=
 =?us-ascii?Q?x7Ql8bmMZykAhk5JrafgAa3SBfPYmeha74RWXsL3xYEEYEC2Srgm/Hkh7ChL?=
 =?us-ascii?Q?s6xbJRz/ByeaHJ6rm4a9+JCUG81qzY8cFNjcDHIApRL52jyt7Xgq8OMx+a/Q?=
 =?us-ascii?Q?hf6fS5P/1nm3BwCAI5yQMLy1VuDuE9q3ALKVXnE7QIPkLrZUe6CEyHGl7zGU?=
 =?us-ascii?Q?B7vgWULl9Vx3V89e2d8vl1LXy21yV8hEofZ4TZHZTZi8WJ9iez0Z30KnsBMN?=
 =?us-ascii?Q?xpsrBZuTztD8PFPe3yHN5PC5UbLSiNsOSCSPZfWKOsUH8TftDO96V9Gd6zsu?=
 =?us-ascii?Q?hsY1AZiszfcK4xZPR7YuYpVR6AqCF1mKUdZKLPl21A56l2uYB9hjcrcQROkI?=
 =?us-ascii?Q?qpUesdGc3yj6iN/5nANaiJxs9OGZmGl+zlyWvT5p5EaEZ3Y38lbgTpR5Uuv8?=
 =?us-ascii?Q?1qzyLjhcQx+bjCk4cFQOpwWg6HPEUvL5zntJXZAV0Aj9TXvP1JivXlYznwyw?=
 =?us-ascii?Q?v8+3qEO4iSEN148AkBbyHUUTbQbAYHZd2qBiaTifOkbo/Ysu0MfJ5HFaq2I6?=
 =?us-ascii?Q?RSS+CjzFU+jpZBoezPFmeCe4gmOiG1xc5WggVZpo9m9zO3RgEVTI9Wo8r5hq?=
 =?us-ascii?Q?ZxUetYWCcDIbCNHdTUyUk9DhBjbYULRzNPD01Bm/EGh893ggUV/+QY4SwX4Q?=
 =?us-ascii?Q?R3q2fxF9lW7sIbPZpWrhX0CmVE+rBRVEFfOYBWd6d+RlrRrMBElICEaNJq9k?=
 =?us-ascii?Q?hKNTcrgQZZQBYVm7oIwwamlFElGBxG9nyJoIwoXtBRn49wfL0geLEQDlvXi9?=
 =?us-ascii?Q?Eb+IGf6AHRfvgjtgyugJ2az143qWHmWU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Lmd8uigzPlLheULtMg+iOOFyr5AumRfJyjirboElYoZdutcbHrpzp8iApFV?=
 =?us-ascii?Q?YFrYTh7+vLH6vIpLD/LtnD2CXibzSeE4n0ZmvEsC/CaDrl7ZceIkJZ0EDV+8?=
 =?us-ascii?Q?2sXIrJZUqBUAFKGpxbN3UOUB5nNiZUayP/84Aosf9/BSpYEv6Bbi7uks48Qk?=
 =?us-ascii?Q?ZFs1r14DAimWmKbN40iCj0LSGkq494Mw4/CxbJjmK7pbGKzquX8E1LWF+C4s?=
 =?us-ascii?Q?vFc5URjh8vOXULavBMaBtC0phm3XOOOh6LEuFaMd3tvBCvBT11roQWDTX0pD?=
 =?us-ascii?Q?ZiNhGOxDRlFmZ/tWgz8R9FqumWvMGPTjJ+Hx6YSmdolvm9QAf7Z4wEV7FCJb?=
 =?us-ascii?Q?eoyHX731wSuZd7oaSBELDs3NVEDvP/7g/T6uQ42sFEUVqyj1nSR7HKnAvIFJ?=
 =?us-ascii?Q?QaeiqL/hQTIvDehJmQXy4njnZfh3PwSP0eIYmBd8xHUpLXaH1HyJzujrU3+K?=
 =?us-ascii?Q?W7OPPPEKoz13U3r/CI5QK9hjpyEiKXnzThsicku/JjYV5k50XTK3VmnWeORt?=
 =?us-ascii?Q?haRFk/0eRtaiCbnn0817+GudFrmiwAlcgA2QwjOZ1+L7883Np1bzALsp68+F?=
 =?us-ascii?Q?G8rFe42qnWUy59qxotMVmzdognbUaizKz44GpzhJIQw183RBXirAyVPkK/2H?=
 =?us-ascii?Q?risFMzBALJPpKsiYwOZajH0p0Pchdzuw+ju5iyRXS47ytxFG/iVg8V6J2kBz?=
 =?us-ascii?Q?xoeqkAJ0t0MfAvYuDZFLDopVD5WITRLrStWhcDdkhZjOUVcBt2rWtzZyqoqU?=
 =?us-ascii?Q?71tx+jtFhTsaNKwVxzjYoiBCHpA2pVsrUsJxcfS0E/it5aUM866rtDkdh7K9?=
 =?us-ascii?Q?LGnP6kHhioNfZGaJPi495tXwnaZnTGjAbPspXkf3GJwChVoWp/+6SDCWzIHB?=
 =?us-ascii?Q?TpDRILJI3Ndw6vaM5UnssjCtPNpDoxllkwB6KprrEuCwkvLnFTXrnhVOMKCa?=
 =?us-ascii?Q?odmr8b7P9KZD2LDzhKZQB9nOi90hM7VW3Dcz08tvaFMrknZkaZBcdJ5qgofe?=
 =?us-ascii?Q?zdMIDTjC+vBx8A1nQKONLcLJKEpQc7bxKRH4fxPximay0Miv2QaZ+rt0sfM5?=
 =?us-ascii?Q?p3DMr+lSG711+f6glJARpf3mHlPQln3pif3AMgEOer6DPGMpQa6gmlKOtwb5?=
 =?us-ascii?Q?oAyVWlpx91dK03oADPTcQaMGima7rLt6zynu0hZt5BKF9os/nn+KTjOmW+j2?=
 =?us-ascii?Q?htiQWQQd1KxiH0vqsKfd4nDnlz33GVfZCj82Q1LYrCckEJpeQR2T1LK3vl00?=
 =?us-ascii?Q?rfGoAID50DKMLmT5Wtb3WhHuS/ZB6/MAouxrjhpe6uU+LLDI+PY7xWnycSOi?=
 =?us-ascii?Q?MgIaP+dN61xTDMyzDzf3QCjA7cNio9xLlJSZQs2PRolf5tuZXdG51ZwwyORy?=
 =?us-ascii?Q?lck9ZH4NzbElKU0BWcruorIlgfjwSWJWKHa+81PnXvsnDxtqk+exetFAhaMW?=
 =?us-ascii?Q?/61Cqs/BJii+yr0E1In62LIMRvCmZ5+PmxuP+kwrojPljObNPLxvGMIaR3Rb?=
 =?us-ascii?Q?3TTQf8NrIkU839pTmQdigrr6ng85AYG88SH+TcChHgTSuDzqDbSSgZQgyy8h?=
 =?us-ascii?Q?eVX3TpmNA8uEHrfBcDfiwv/zlUX0tTSXTg0kyCiYUgHhQuw5pZJ38fo/4teO?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edaaf9da-5a60-4b4e-214a-08ddcb5b1db4
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 09:10:37.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFJLP3mHA2nLnjum306MfxKScGY3nidfkgeHCYvP4sZxbHM6w81OG2LVTGDznVjXMnegzw92rNYGwMzwmUuWww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6403
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 531E3C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: abzcub79i3y4m1dr4bc6zd6pinj6wgam
X-HE-Tag: 1753434716-531267
X-HE-Meta: U2FsdGVkX1/ifv14y0ycDPJd3XhSaNNHX7Po4ciXPNNBNx4yqqY+BSUmBmTyc9I0RifGUbb5udF6I9ztVsh7v8mwP0VmsgHVBfdxabxgoANPhRepattP67jvCQLuLWlPYLaRa88G1Xn4mBFkTls767SBNDvYuwgp7V2V1tRCPLxrvgDACRvhxnGPINcwVpJihb6SBTd0KkB7GLyt7tmpsz9mt/YoE1Mk7jDF5DK7AjY1rSelMnGjLcUAs6fZT1n+8M5JcDSIXlwe4VPCzUhf4a20jOL/+iQMlQrowjHGx6tQ5e6WnyF4Rlqtgs0YtpuRC9CvPeRhigBKe1UqcFTKOa7odYLy2o+QgR8b7/FCBIRct4KRY/m8EEjcAx8iwKWVS3PlxuqLaT1Bs9jfHc6DE57ui+HlC3ScsXc7J7if0SyyQ2G6Y7H2Spf4zVsQjoryFuwQ8DNZQ/SqY9hBrmXwOrqhgNQFBbu0updJL+wnunH09rSoLQDC8JEzBJdUq1YhNKbvkpenPMzWv+BM7q/n1qCcW9+0/wGrozBFxgom90w3/tLqV9+Fwi6QJAsjqx+wpPP90dKZOTWUm7eCrRQ7imWIeocgNhG8wBceLjtLj/kHo0Iai1v+SNzhhKwZi7GVHlvMltBtV/A2QtESEkJU24hiAJ+BVnQMtWUi63Ey6r4vpIELP0NoYoec2V5fVmLGs3bDX3PyUxEoghkpekTa7UbKRu3pSHIb7XUQeUAXeCJS3wwrd82EuLngO9gjdSJjO50VqT4zgSfFYmmk5aruixFQESiwWha1ZB1UwNL1H2lOWQADkVrcL1I/b31u2vMknQXglE45oTo5QOcyG2Iq3p4vUu0uwdsLRVOGMlmYyX6b+lO5CwTULrKJQRsFAeb99YcERtuf1aNg+afIfO83gFeGZG3DC5JrJ8hHnRETytvguTpQQq2ilsLDCbhPuYX0o0SFnKKTyWdwPGWcBLc
 0QbmbpdL
 KZrrYUHyt838p/Zn4y0YeLnF+wO3mW0y7AjuGCqKabb+bB9gXVCz+SqcYw+xgN6u8GdfVbz280N+wu4vihuv4+SIghFGxzlq92nj4vi7QsRz+WiaCh3nyzniRN/kQ8hkt64CEpwytsmSrorY2qFqN1QxCbkeq8WpxBq03iBDLfE7z2ReeT1lT5Qb6lBB/nt2RNiy37bZxyKexgPPVjNBxn4Fn5rfacif9jxdI1IXnT6tkI9uhJi6AOLngFwTLioonv6QLJybBWWUImSrTWP7MlJKBvHQ42MXxFLXjuYxU/IkCIZESGXhq4JFraSv5ctw2XGK+H4ruWdCjdoTr0CaElyPTVgj43vu6uaIb6grdnIf+4cyvSobxRBNakQecyfmccZka3E25+EUzBEKpE11piyMFijtMDO1Gvt/SRsWDMo2l04sOcPGATs70o6BUrI2xrT77k5YJ/YSsU8EyjT8dAECsTotQHDhr05PJ3AhHYNoqyAYJjLBZV23ElfJSwGRh/rWdhzgdK70+OwtV37eG5Dcw6JaKK4lk2TbRhTXGMIbaQhJ7rlMSVdKXKYPcx1pgR5pD1INWlx++6BZ98m6wi5uPp1aSgeAS3iVSspkieGfIJBQopWJVuyV5waIOqZW3E2o4vI26LJCrIIa6Axz+3TSvgz7qkOmTmqu1+m+i/3C86ceDUK9SJnQ82w7pc5PoaQ9sc0hFZSmx8mAPGMq5Q8W4dNdNfrWg6NyuFZHrDMEv4DDBfRgU9L4tU2HrtKpFZLxYzn02Qq34OnEYHF6PwA4K6bBr1vFmylzK5H5sagd/A4K2/17UCbsSpzTCUmKDFMCB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--HSMJNboiLersl0nZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

hi, Thomas Gleixner,

On Wed, Jul 23, 2025 at 07:22:43PM +0200, Thomas Gleixner wrote:
> On Wed, Jul 23 2025 at 16:46, kernel test robot wrote:
> > kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c" on:
> >
> > commit: 56180dd20c19e5b0fa34822997a9ac66b517e7b3 ("futex: Use RCU-based per-CPU reference counting instead of rcuref_t")
> > https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git locking/futex
> >
> > the issue (1)(2) happen randomly upon 56180dd20c.
> 
> Hmm.
> 
> > a255b78d14324f8a 56180dd20c19e5b0fa34822997a
> > ---------------- ---------------------------
> >        fail:runs  %reproduction    fail:runs
> >            |             |             |
> >            :50          48%          24:50    dmesg.BUG:scheduling_while_atomic    <---- (2)
> >            :50          48%          24:50    dmesg.BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c   <---- (1)
> >          50:50           0%          50:50    dmesg.Mem-Info
> >          50:50           0%          50:50    dmesg.invoked_oom-killer:gfp_mask=0x
> >
> >
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202507231021.dcf24373-lkp@intel.com
> >
> >
> > [  286.673775][   C97] BUG: sleeping function called from invalid context at kernel/nsproxy.c:233   <---- (1)
> > [  286.673784][   C97] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6748, name: oom03
> > [  286.673787][   C97] preempt_count: 7ffffffe, expected: 0
> 
> Ooops. That's a corrupted preempt counter, which has underflown twice.
> 
> Can you please enable CONFIG_DEBUG_PREEMPT, so we can see where this
> happens?

after enable CONFIG_DEBUG_PREEMPT, the config is as attached
config-6.16.0-rc5-00002-g56180dd20c19

the issue becomes random dmesg.WARNING:at_kernel/sched/core.c:#preempt_count_sub

=========================================================================================
compiler/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/x86_64-rhel-9.4-ltp_+CONFIG_DEBUG_PREEMPT/debian-12-x86_64-20240206.cgz/lkp-skl-fpga01/mm-oom/ltp

a255b78d14324f8a 56180dd20c19e5b0fa34822997a
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :20          65%          13:20    dmesg.RIP:preempt_count_sub
           :20          65%          13:20    dmesg.WARNING:at_kernel/sched/core.c:#preempt_count_sub


one dmesg is attached.


[  351.452869][ T7232] ------------[ cut here ]------------
[  351.452888][ T7232] DEBUG_LOCKS_WARN_ON(val > preempt_count())
[  351.452904][ T7232] WARNING: CPU: 23 PID: 7232 at kernel/sched/core.c:5903 preempt_count_sub+0xca/0x170
[  351.452933][ T7232] Modules linked in: intel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequency_common skx_edac skx_edac_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp btrfs coretemp blake2b_generic xor zstd_compress raid6_pq sd_mod sg kvm_intel kvm irdma irqbypass ghash_clmulni_intel snd_pcm ice rapl ast snd_timer ahci intel_cstate gnss ib_uverbs drm_client_lib snd nvme mei_me libahci drm_shmem_helper ipmi_ssif soundcore i2c_i801 intel_uncore ioatdma ib_core libata nvme_core acpi_power_meter pcspkr mei drm_kms_helper lpc_ich i2c_smbus intel_pch_thermal dca wmi ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad joydev binfmt_misc drm loop fuse dm_mod ip_tables
[  351.453245][ T7232] CPU: 23 UID: 0 PID: 7232 Comm: oom03 Not tainted 6.16.0-rc5-00002-g56180dd20c19 #1 PREEMPT(voluntary) 
[  351.453263][ T7232] RIP: 0010:preempt_count_sub+0xca/0x170
[  351.453279][ T7232] Code: 11 38 d0 7c 08 84 d2 0f 85 91 00 00 00 8b 15 1d 3c e3 04 85 d2 75 b5 48 c7 c6 60 12 2d 84 48 c7 c7 a0 12 2d 84 e8 76 91 f3 ff <0f> 0b eb 9e 84 c0 75 91 e8 a9 89 1a 01 85 c0 74 91 48 c7 c0 a0 76
[  351.453290][ T7232] RSP: 0018:ffffc9003564f8c0 EFLAGS: 00010286
[  351.453301][ T7232] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[  351.453309][ T7232] RDX: 0000000000000002 RSI: 0000000000000004 RDI: 0000000000000001
[  351.453316][ T7232] RBP: ffffc9003564f8c8 R08: 0000000000000001 R09: ffffed12f5375839
[  351.453325][ T7232] R10: ffff8897a9bac1cb R11: ffffffff874e19b0 R12: ffff88990174c380
[  351.453333][ T7232] R13: ffffc9003564fb50 R14: 00000000003d0f00 R15: 0000000000001c40
[  351.453341][ T7232] FS:  00007fbcae930740(0000) GS:ffff8898227f2000(0000) knlGS:0000000000000000
[  351.453352][ T7232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  351.453360][ T7232] CR2: 00007fa61b7ffd58 CR3: 00000030158d2004 CR4: 00000000007726f0
[  351.453368][ T7232] PKRU: 55555554
[  351.453375][ T7232] Call Trace:
[  351.453381][ T7232]  <TASK>
[  351.453388][ T7232]  _raw_spin_unlock+0x19/0x70
[  351.453402][ T7232]  copy_process+0x4244/0x4ab0
[  351.453416][ T7232]  ? mod_memcg_lruvec_state+0x362/0x5b0
[  351.453439][ T7232]  ? __pfx_copy_process+0x10/0x10
[  351.453451][ T7232]  ? _inline_copy_from_user+0x4f/0xb0
[  351.453470][ T7232]  ? copy_clone_args_from_user+0xff/0x670
[  351.453487][ T7232]  ? __pfx_folios_put_refs+0x10/0x10
[  351.453501][ T7232]  kernel_clone+0xb6/0x7b0
[  351.453514][ T7232]  ? __pfx_kernel_clone+0x10/0x10
[  351.453525][ T7232]  ? folio_batch_move_lru+0x231/0x370
[  351.453536][ T7232]  ? __pfx_lru_add+0x10/0x10
[  351.453556][ T7232]  __do_sys_clone3+0x150/0x1b0
[  351.453569][ T7232]  ? __pfx___do_sys_clone3+0x10/0x10
[  351.453590][ T7232]  ? __smp_call_single_queue+0x268/0x3f0
[  351.453609][ T7232]  ? __pfx___smp_call_single_queue+0x10/0x10
[  351.453623][ T7232]  ? select_task_rq_fair+0x395/0xcb0
[  351.453637][ T7232]  ? preempt_count_add+0xca/0x170
[  351.453651][ T7232]  ? _raw_spin_lock_irq+0x8b/0xf0
[  351.453661][ T7232]  ? __pfx__raw_spin_lock_irq+0x10/0x10
[  351.453671][ T7232]  ? ttwu_queue_wakelist+0x2be/0x4b0
[  351.453688][ T7232]  do_syscall_64+0x7f/0x2f0
[  351.453701][ T7232]  ? _raw_spin_unlock_irq+0x1a/0x70
[  351.453711][ T7232]  ? sigprocmask+0x1ea/0x330
[  351.453737][ T7232]  ? __pfx_sigprocmask+0x10/0x10
[  351.453742][ T7232]  ? _copy_to_user+0x5c/0x70
[  351.453746][ T7232]  ? __x64_sys_rt_sigprocmask+0x183/0x230
[  351.453751][ T7232]  ? __pfx___x64_sys_rt_sigprocmask+0x10/0x10
[  351.453756][ T7232]  ? __asan_memset+0x23/0x70
[  351.453763][ T7232]  ? rwsem_wake+0xca/0x130
[  351.453773][ T7232]  ? do_syscall_64+0x7f/0x2f0
[  351.453776][ T7232]  ? handle_mm_fault+0x3ff/0x6f0
[  351.453784][ T7232]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
[  351.453795][ T7232]  ? fpregs_restore_userregs+0xed/0x1f0
[  351.453803][ T7232]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  351.453808][ T7232] RIP: 0033:0x7fbcaea3c889
[  351.453813][ T7232] Code: 31 ed e9 44 ff ff ff e8 25 e9 00 00 0f 1f 44 00 00 b8 ea ff ff ff 48 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
[  351.453816][ T7232] RSP: 002b:00007fffcc117a48 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
[  351.453821][ T7232] RAX: ffffffffffffffda RBX: 00007fbcae9bbef0 RCX: 00007fbcaea3c889
[  351.453824][ T7232] RDX: 00007fbcae9bbef0 RSI: 0000000000000058 RDI: 00007fffcc117a90
[  351.453827][ T7232] RBP: 00007fa61b7ff6c0 R08: 00007fa61b7ff6c0 R09: 00007fffcc117b87
[  351.453830][ T7232] R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffff78
[  351.453832][ T7232] R13: 0000000000000000 R14: 00007fffcc117a90 R15: 00007fa61afff000
[  351.453838][ T7232]  </TASK>
[  351.453840][ T7232] ---[ end trace 0000000000000000 ]---


> 
> Thanks,
> 
>         tglx

--HSMJNboiLersl0nZ
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.16.0-rc5-00002-g56180dd20c19"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 6.16.0-rc5 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=120200
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=24000
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=24000
CONFIG_LLD_VERSION=0
CONFIG_RUSTC_VERSION=0
CONFIG_RUSTC_LLVM_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_GCC_ASM_GOTO_OUTPUT_BROKEN=y
CONFIG_TOOLS_SUPPORT_RELR=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_LD_CAN_USE_KEEP_IN_OVERLAY=y
CONFIG_PAHOLE_VERSION=130
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT="5.14.0-427.20.1.el9_4.x86_64"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST_IDLE=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING_USER=y
# CONFIG_CONTEXT_TRACKING_USER_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=125
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_BUILD=y
CONFIG_ARCH_HAS_PREEMPT_LAZY=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_LAZY is not set
# CONFIG_PREEMPT_RT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
CONFIG_SCHED_CORE=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_NEED_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_DEFAULT_ALL is not set
# CONFIG_RCU_LAZY is not set
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=m
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_INDEX=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC10_NO_ARRAY_BOUNDS=y
CONFIG_CC_NO_ARRAY_BOUNDS=y
CONFIG_GCC_NO_STRINGOP_OVERFLOW=y
CONFIG_CC_NO_STRINGOP_OVERFLOW=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_SLAB_OBJ_EXT=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
CONFIG_MEMCG=y
# CONFIG_MEMCG_V1 is not set
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_GROUP_SCHED_WEIGHT=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_SCHED_MM_CID=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
# CONFIG_CGROUP_DMEM is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_CPUSETS_V1 is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
CONFIG_CGROUP_MISC=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
# CONFIG_BOOT_CONFIG_FORCE is not set
# CONFIG_BOOT_CONFIG_EMBED is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_LD_ORPHAN_WARN_LEVEL="warn"
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_SMALL is not set
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_FUTEX_PRIVATE_HASH=y
CONFIG_FUTEX_MPOL=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_CACHESTAT_SYSCALL=y
# CONFIG_PC104 is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_SELFTEST is not set
CONFIG_KALLSYMS_ALL=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y

#
# Kexec and crash features
#
CONFIG_CRASH_RESERVE=y
CONFIG_VMCORE_INFO=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_IMA_KEXEC=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_SIG=y
# CONFIG_KEXEC_SIG_FORCE is not set
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_KEXEC_JUMP=y
# CONFIG_KEXEC_HANDOVER is not set
CONFIG_CRASH_DUMP=y
# CONFIG_CRASH_DM_CRYPT is not set
CONFIG_CRASH_HOTPLUG=y
CONFIG_CRASH_MAX_MEMORY_RANGES=8192
# end of Kexec and crash features
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_CSUM=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_POSTED_MSI=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_CPU_RESCTRL=y
# CONFIG_X86_FRED is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_INTEL_MID is not set
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
# CONFIG_XEN_PV is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_PVHVM_GUEST=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
CONFIG_PVH=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
CONFIG_INTEL_TDX_GUEST=y
CONFIG_CC_HAS_MARCH_NATIVE=y
# CONFIG_X86_NATIVE_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_HAVE_PAE=y
CONFIG_X86_CX8=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_BROADCAST_TLB_FLUSH=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_BOOT_VESA_SUPPORT=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_ACPI_MADT_WAKEUP=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
CONFIG_PERF_EVENTS_AMD_POWER=m
CONFIG_PERF_EVENTS_AMD_UNCORE=y
CONFIG_PERF_EVENTS_AMD_BRS=y
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_LATE_LOADING=y
# CONFIG_MICROCODE_LATE_FORCE_MINREV is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_X86_CPA_STATISTICS=y
CONFIG_X86_MEM_ENCRYPT=y
CONFIG_AMD_MEM_ENCRYPT=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
CONFIG_X86_CET=y
CONFIG_X86_KERNEL_IBT=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_ARCH_PKEY_BITS=4
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
# CONFIG_X86_USER_SHADOW_STACK is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_HANDOVER_PROTOCOL=y
CONFIG_EFI_MIXED=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_ARCH_SUPPORTS_KEXEC=y
CONFIG_ARCH_SUPPORTS_KEXEC_FILE=y
CONFIG_ARCH_SELECTS_KEXEC_FILE=y
CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_SIG_FORCE=y
CONFIG_ARCH_SUPPORTS_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_ARCH_SUPPORTS_KEXEC_JUMP=y
CONFIG_ARCH_SUPPORTS_KEXEC_HANDOVER=y
CONFIG_ARCH_SUPPORTS_CRASH_DUMP=y
CONFIG_ARCH_DEFAULT_CRASH_DUMP=y
CONFIG_ARCH_SUPPORTS_CRASH_HOTPLUG=y
CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_XONLY=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
CONFIG_X86_BUS_LOCK_DETECT=y
# end of Processor type and features

CONFIG_CC_HAS_NAMED_AS=y
CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_CC_HAS_ENTRY_PADDING=y
CONFIG_FUNCTION_PADDING_CFI=11
CONFIG_FUNCTION_PADDING_BYTES=16
CONFIG_CALL_PADDING=y
CONFIG_HAVE_CALL_THUNKS=y
CONFIG_CALL_THUNKS=y
CONFIG_PREFIX_SYMBOLS=y
CONFIG_CPU_MITIGATIONS=y
CONFIG_MITIGATION_PAGE_TABLE_ISOLATION=y
CONFIG_MITIGATION_RETPOLINE=y
CONFIG_MITIGATION_RETHUNK=y
CONFIG_MITIGATION_UNRET_ENTRY=y
CONFIG_MITIGATION_CALL_DEPTH_TRACKING=y
# CONFIG_CALL_THUNKS_DEBUG is not set
CONFIG_MITIGATION_IBPB_ENTRY=y
CONFIG_MITIGATION_IBRS_ENTRY=y
CONFIG_MITIGATION_SRSO=y
# CONFIG_MITIGATION_SLS is not set
CONFIG_MITIGATION_GDS=y
CONFIG_MITIGATION_RFDS=y
CONFIG_MITIGATION_SPECTRE_BHI=y
CONFIG_MITIGATION_MDS=y
CONFIG_MITIGATION_TAA=y
CONFIG_MITIGATION_MMIO_STALE_DATA=y
CONFIG_MITIGATION_L1TF=y
CONFIG_MITIGATION_RETBLEED=y
CONFIG_MITIGATION_SPECTRE_V1=y
CONFIG_MITIGATION_SPECTRE_V2=y
CONFIG_MITIGATION_SRBDS=y
CONFIG_MITIGATION_SSB=y
CONFIG_MITIGATION_ITS=y
CONFIG_ARCH_HAS_ADD_PAGES=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_HIBERNATION_COMP_LZO=y
CONFIG_HIBERNATION_DEF_COMP="lzo"
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_USERSPACE_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
CONFIG_PM_GENERIC_DOMAINS=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_PM_GENERIC_DOMAINS_SLEEP=y
CONFIG_ENERGY_MODEL=y
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_TABLE_LIB=y
CONFIG_ACPI_THERMAL_LIB=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NHLT=y
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_HMAT=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_EINJ_CXL=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_ACPI_DPTF=y
CONFIG_DPTF_POWER=m
CONFIG_DPTF_PCH_FIVR=m
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_ACPI_PFRUT=m
CONFIG_ACPI_PCC=y
CONFIG_ACPI_FFH=y
CONFIG_ACPI_MRRM=y
CONFIG_PMIC_OPREGION=y
CONFIG_ACPI_VIOT=y
CONFIG_ACPI_PRMT=y
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_AMD_PSTATE=y
CONFIG_X86_AMD_PSTATE_DEFAULT_MODE=3
CONFIG_X86_AMD_PSTATE_UT=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPUFREQ_ARCH_CUR_FREQ=y
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
CONFIG_CPU_IDLE_GOV_HALTPOLL=y
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_AMD_NODE=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_EMULATION_DEFAULT_DISABLED is not set
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
# end of Binary Emulations

CONFIG_KVM_COMMON=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_DIRTY_RING_TSO=y
CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_READONLY_MEM=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=m
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
CONFIG_KVM_GENERIC_MMU_NOTIFIER=y
CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG=y
CONFIG_KVM_MMU_LOCKLESS_AGING=y
CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y
CONFIG_KVM_PRIVATE_MEM=y
CONFIG_KVM_GENERIC_PRIVATE_MEM=y
CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE=y
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM_X86=m
CONFIG_KVM=m
# CONFIG_KVM_SW_PROTECTED_VM is not set
CONFIG_KVM_INTEL=m
# CONFIG_KVM_INTEL_PROVE_VE is not set
CONFIG_X86_SGX_KVM=y
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_SMM=y
CONFIG_KVM_HYPERV=y
# CONFIG_KVM_XEN is not set
# CONFIG_KVM_PROVE_MMU is not set
CONFIG_KVM_MAX_NR_VCPUS=4096
CONFIG_X86_REQUIRED_FEATURE_ALWAYS=y
CONFIG_X86_REQUIRED_FEATURE_NOPL=y
CONFIG_X86_REQUIRED_FEATURE_CX8=y
CONFIG_X86_REQUIRED_FEATURE_CMOV=y
CONFIG_X86_REQUIRED_FEATURE_CPUID=y
CONFIG_X86_REQUIRED_FEATURE_FPU=y
CONFIG_X86_REQUIRED_FEATURE_PAE=y
CONFIG_X86_REQUIRED_FEATURE_PSE=y
CONFIG_X86_REQUIRED_FEATURE_PGE=y
CONFIG_X86_REQUIRED_FEATURE_MSR=y
CONFIG_X86_REQUIRED_FEATURE_FXSR=y
CONFIG_X86_REQUIRED_FEATURE_XMM=y
CONFIG_X86_REQUIRED_FEATURE_XMM2=y
CONFIG_X86_REQUIRED_FEATURE_LM=y
CONFIG_X86_DISABLED_FEATURE_VME=y
CONFIG_X86_DISABLED_FEATURE_K6_MTRR=y
CONFIG_X86_DISABLED_FEATURE_CYRIX_ARR=y
CONFIG_X86_DISABLED_FEATURE_CENTAUR_MCR=y
CONFIG_X86_DISABLED_FEATURE_LAM=y
CONFIG_X86_DISABLED_FEATURE_XENPV=y
CONFIG_X86_DISABLED_FEATURE_USER_SHSTK=y
CONFIG_X86_DISABLED_FEATURE_FRED=y
CONFIG_AS_AVX512=y
CONFIG_AS_GFNI=y
CONFIG_AS_VAES=y
CONFIG_AS_VPCLMULQDQ=y
CONFIG_AS_WRUSS=y
CONFIG_ARCH_CONFIGURES_CPU_MITIGATIONS=y
CONFIG_ARCH_HAS_DMA_OPS=y

#
# General architecture-dependent options
#
CONFIG_HOTPLUG_SMT=y
CONFIG_HOTPLUG_CORE_SYNC=y
CONFIG_HOTPLUG_CORE_SYNC_DEAD=y
CONFIG_HOTPLUG_CORE_SYNC_FULL=y
CONFIG_HOTPLUG_SPLIT_STARTUP=y
CONFIG_HOTPLUG_PARALLEL=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_ARCH_HAS_CPU_FINALIZE_INIT=y
CONFIG_ARCH_HAS_CPU_PASID=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_RUST=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM=y
CONFIG_MMU_LAZY_TLB_REFCOUNT=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_HAVE_EXTRA_ELF_NOTES=y
CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_ARCH_SUPPORTS_AUTOFDO_CLANG=y
CONFIG_ARCH_SUPPORTS_PROPELLER_CLANG=y
CONFIG_ARCH_SUPPORTS_CFI_CLANG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING_USER=y
CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_PMD_MKWRITE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_EXECMEM_ROX=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_4KB=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_PAGE_SHIFT=12
CONFIG_HAVE_OBJTOOL=y
CONFIG_HAVE_JUMP_LABEL_HACK=y
CONFIG_HAVE_NOINSTR_HACK=y
CONFIG_HAVE_NOINSTR_VALIDATION=y
CONFIG_HAVE_UACCESS_VALIDATION=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_ARCH_SUPPORTS_RT=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_CPU_RESCTRL=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_CC_PLATFORM=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y
CONFIG_ARCH_HAS_HW_PTE_YOUNG=y
CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG=y
CONFIG_ARCH_HAS_KERNEL_FPU_SUPPORT=y
CONFIG_ARCH_VMLINUX_NEEDS_RELOCS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_FUNCTION_ALIGNMENT_4B=y
CONFIG_FUNCTION_ALIGNMENT_16B=y
CONFIG_FUNCTION_ALIGNMENT=16
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
# CONFIG_MODULE_DEBUG is not set
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
# CONFIG_MODULE_SIG_SHA3_256 is not set
# CONFIG_MODULE_SIG_SHA3_384 is not set
# CONFIG_MODULE_SIG_SHA3_512 is not set
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/usr/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_CGROUP_PUNT_BIO=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_WRITE_MOUNTED=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
CONFIG_BLK_CGROUP_IOLATENCY=y
CONFIG_BLK_CGROUP_FC_APPID=y
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_DEFAULT_ON is not set
# CONFIG_ZSWAP_SHRINKER_DEFAULT_ON is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC=y
CONFIG_ZSWAP_ZPOOL_DEFAULT="zsmalloc"
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_ZSMALLOC_CHAIN_SIZE=8

#
# Slab allocator options
#
CONFIG_SLUB=y
CONFIG_KVFREE_RCU_BATCHED=y
# CONFIG_SLUB_TINY is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLAB_BUCKETS=y
# CONFIG_SLUB_STATS is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_RANDOM_KMALLOC_CACHES is not set
# end of Slab allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_SPARSEMEM_VMEMMAP_PREINIT=y
CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=y
CONFIG_ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP=y
CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_PREINIT=y
CONFIG_HAVE_GUP_FAST=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE=y
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL is not set
# CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
CONFIG_SPLIT_PTE_PTLOCKS=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_SPLIT_PMD_PTLOCKS=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PCP_BATCH_SCALE_MAX=5
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_MM_ID=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set
CONFIG_THP_SWAP=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
# CONFIG_NO_PAGE_MAPCOUNT is not set
CONFIG_PAGE_MAPCOUNT=y
CONFIG_PGTABLE_HAS_HUGE_LEAVES=y
CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PMD_PFNMAP=y
CONFIG_ARCH_SUPPORTS_PUD_PFNMAP=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_PAGE_BLOCK_ORDER=10
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_GET_FREE_REGION=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
CONFIG_ARCH_USES_PG_ARCH_2=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
# CONFIG_DMAPOOL_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
CONFIG_MEMFD_CREATE=y
CONFIG_SECRETMEM=y
# CONFIG_ANON_VMA_NAME is not set
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_USERFAULTFD=y
# CONFIG_PTE_MARKER_UFFD_WP is not set
CONFIG_LRU_GEN=y
CONFIG_LRU_GEN_ENABLED=y
# CONFIG_LRU_GEN_STATS is not set
CONFIG_LRU_GEN_WALKS_MMU=y
CONFIG_ARCH_SUPPORTS_PER_VMA_LOCK=y
CONFIG_PER_VMA_LOCK=y
CONFIG_LOCK_MM_AND_FIND_VMA=y
CONFIG_IOMMU_MM_DATA=y
CONFIG_EXECMEM=y
CONFIG_NUMA_MEMBLKS=y
CONFIG_NUMA_EMU=y
CONFIG_ARCH_SUPPORTS_PT_RECLAIM=y
CONFIG_PT_RECLAIM=y

#
# Data Access Monitoring
#
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
CONFIG_DAMON_SYSFS=y
CONFIG_DAMON_RECLAIM=y
# CONFIG_DAMON_LRU_SORT is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_XGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_DECRYPTED=y
CONFIG_SKB_EXTENSIONS=y
CONFIG_NET_DEVMEM=y
CONFIG_NET_SHAPER=y
CONFIG_NET_CRC32C=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=y
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
CONFIG_XFRM_INTERFACE=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XFRM_IPTFS is not set
CONFIG_XFRM_ESPINTCP=y
# CONFIG_SMC is not set
CONFIG_XDP_SOCKETS=y
CONFIG_XDP_SOCKETS_DIAG=m
CONFIG_NET_HANDSHAKE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
CONFIG_INET_ESPINTCP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_TABLE_PERTURB_ORDER=16
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
CONFIG_INET_DIAG_DESTROY=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_NV=m
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_SIGPOOL=y
# CONFIG_TCP_AO is not set
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
CONFIG_INET6_ESPINTCP=y
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_FOU=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=y
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_BPF_LINK=y
CONFIG_NETFILTER_NETLINK_HOOK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CONNTRACK_OVS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NF_NAT_OVS=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
CONFIG_NFT_TUNNEL=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
CONFIG_NFT_XFRM=m
CONFIG_NFT_SOCKET=m
CONFIG_NFT_OSF=m
CONFIG_NFT_TPROXY=m
CONFIG_NFT_SYNPROXY=m
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
CONFIG_NFT_REJECT_NETDEV=m
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NF_FLOW_TABLE_PROCFS=y
CONFIG_NETFILTER_XTABLES=y
# CONFIG_NETFILTER_XTABLES_COMPAT is not set

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_MH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_IP_NF_IPTABLES_LEGACY=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_NFT_COMPAT_ARP=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_IPTABLES_LEGACY=m
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_NFT_BRIDGE_META=m
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_CONNTRACK_BRIDGE=m
CONFIG_BRIDGE_NF_EBTABLES_LEGACY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_IB=y
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_CBS=m
CONFIG_NET_SCH_ETF=m
CONFIG_NET_SCH_MQPRIO_LIB=m
CONFIG_NET_SCH_TAPRIO=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_CAKE=m
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
# CONFIG_NET_ACT_CONNMARK is not set
CONFIG_NET_ACT_CTINFO=m
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_TC_SKB_EXT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=y
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
CONFIG_HSR=m
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_QRTR=m
# CONFIG_QRTR_TUN is not set
CONFIG_QRTR_MHI=m
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_MAX_SKB_FRAGS=17
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
CONFIG_CAN_J1939=m
CONFIG_CAN_ISOTP=m
CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m
CONFIG_BT_LE=y
CONFIG_BT_LE_L2CAP_ECRED=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
# CONFIG_BT_AOSPEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_MTK=m
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTUSB_AUTOSUSPEND=y
CONFIG_BT_HCIBTUSB_POLL_SYNC=y
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_MTK=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
# CONFIG_BT_HCIBCM4377 is not set
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# CONFIG_BT_VIRTIO is not set
# CONFIG_BT_INTEL_PCIE is not set
# end of Bluetooth device drivers

CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_IPV6=y
# CONFIG_AF_RXRPC_INJECT_LOSS is not set
# CONFIG_AF_RXRPC_INJECT_RX_DELAY is not set
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
# CONFIG_RXGK is not set
CONFIG_RXPERF=m
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_PAGE_POOL_STATS=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_PCI=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEAER_CXL=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
CONFIG_PCIE_PTM=y
CONFIG_PCIE_EDR=y
CONFIG_PCI_MSI=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_DOE=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_NPEM is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCIE_TPH is not set
CONFIG_PCI_P2PDMA=y
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_OCTEONEP is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# Cadence-based PCIe controllers
#
# end of Cadence-based PCIe controllers

#
# DesignWare-based PCIe controllers
#
# CONFIG_PCI_MESON is not set
# CONFIG_PCIE_DW_PLAT_HOST is not set
# end of DesignWare-based PCIe controllers

#
# Mobiveil-based PCIe controllers
#
# end of Mobiveil-based PCIe controllers

#
# PLDA-based PCIe controllers
#
# end of PLDA-based PCIe controllers
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_PCI_PWRCTRL_SLOT is not set
CONFIG_CXL_BUS=m
CONFIG_CXL_PCI=m
# CONFIG_CXL_MEM_RAW_COMMANDS is not set
CONFIG_CXL_ACPI=m
CONFIG_CXL_PMEM=m
CONFIG_CXL_MEM=m
# CONFIG_CXL_FEATURES is not set
CONFIG_CXL_PORT=m
CONFIG_CXL_SUSPEND=y
CONFIG_CXL_REGION=y
# CONFIG_CXL_REGION_INVALIDATION_TEST is not set
CONFIG_CXL_MCE=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_DEVTMPFS_SAFE=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_DEBUG=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_FW_LOADER_COMPRESS=y
CONFIG_FW_LOADER_COMPRESS_XZ=y
CONFIG_FW_LOADER_COMPRESS_ZSTD=y
CONFIG_FW_CACHE=y
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
CONFIG_HMEM_REPORTING=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_DEVICES=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SOUNDWIRE=m
CONFIG_REGMAP_SOUNDWIRE_MBQ=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# CONFIG_FW_DEVLINK_SYNC_STATE_TIMEOUT is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=m
# CONFIG_MHI_BUS_DEBUG is not set
CONFIG_MHI_BUS_PCI_GENERIC=m
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

#
# Cache Drivers
#
# end of Cache Drivers

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
CONFIG_FW_CS_DSP=m
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_SOFT_RESERVE=y
CONFIG_EFI_DXE_MEM_ATTRIBUTES=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
CONFIG_EFI_RCI2_TABLE=y
# CONFIG_EFI_DISABLE_PCI_DMA is not set
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y
# CONFIG_EFI_DISABLE_RUNTIME is not set
CONFIG_EFI_COCO_SECRET=y
CONFIG_UNACCEPTED_MEMORY=y
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y

#
# Qualcomm firmware drivers
#
# end of Qualcomm firmware drivers

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_FWCTL is not set
CONFIG_GNSS=m
# CONFIG_GNSS_USB is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set

#
# Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
#
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_MCHP48L640 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# ECC engine support
#
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# CONFIG_MTD_NAND_ECC_MXIC is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_UBI_NVMEM is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
# CONFIG_ZRAM_BACKEND_LZ4 is not set
# CONFIG_ZRAM_BACKEND_LZ4HC is not set
# CONFIG_ZRAM_BACKEND_ZSTD is not set
# CONFIG_ZRAM_BACKEND_DEFLATE is not set
# CONFIG_ZRAM_BACKEND_842 is not set
CONFIG_ZRAM_BACKEND_FORCE_LZO=y
CONFIG_ZRAM_BACKEND_LZO=y
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_TRACK_ENTRY_ACTIME is not set
# CONFIG_ZRAM_MEMORY_TRACKING is not set
# CONFIG_ZRAM_MULTI_COMP is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_UBLK is not set
# CONFIG_BLK_DEV_ZONED_LOOP is not set

#
# NVME Support
#
CONFIG_NVME_AUTH=m
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_VERBOSE_ERRORS=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_RDMA=m
CONFIG_NVME_FC=m
CONFIG_NVME_TCP=m
# CONFIG_NVME_TCP_TLS is not set
# CONFIG_NVME_HOST_AUTH is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_DEBUGFS is not set
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_RDMA=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
CONFIG_NVME_TARGET_TCP=m
# CONFIG_NVME_TARGET_TCP_TLS is not set
CONFIG_NVME_TARGET_AUTH=y
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_RPMB is not set
# CONFIG_TI_FPC202 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_NTSYNC is not set
# CONFIG_NSM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_INTEL_MEI_GSC=m
# CONFIG_INTEL_MEI_VSC_HW is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_INTEL_MEI_GSC_PROXY=m
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
CONFIG_MISC_RTSX_USB=m
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
CONFIG_PVPANIC_MMIO=m
# CONFIG_PVPANIC_PCI is not set
# CONFIG_GP_PCI1XXXX is not set
# CONFIG_KEBA_CP500 is not set
# CONFIG_AMD_SBRMI_I2C is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPI3MR=m
CONFIG_SCSI_SMARTPQI=m
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_TCM_QLA2XXX is not set
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_QEDI=m
CONFIG_QEDF=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
CONFIG_SCSI_CHELSIO_FCOE=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_AHCI_DWC is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_PARPORT is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_BITMAP_FILE=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_MULTIPATH_HST=m
CONFIG_DM_MULTIPATH_IOA=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING is not set
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING is not set
CONFIG_DM_VERITY_FEC=y
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
# CONFIG_DM_ZONED is not set
CONFIG_DM_AUDIT=y
# CONFIG_DM_VDO is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_REMOTE_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
CONFIG_WIREGUARD=m
# CONFIG_WIREGUARD_DEBUG is not set
# CONFIG_OVPN is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_IPVLAN_L3S=y
CONFIG_IPVLAN=m
CONFIG_IPVTAP=m
CONFIG_VXLAN=m
CONFIG_GENEVE=m
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
# CONFIG_PFCP is not set
# CONFIG_AMT is not set
CONFIG_MACSEC=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
# CONFIG_NETCONSOLE_EXTENDED_LOG is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
# CONFIG_NETKIT is not set
CONFIG_NET_VRF=m
CONFIG_VSOCKMON=m
CONFIG_MHI_NET=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=m
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_AGERE is not set
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
# CONFIG_PDS_CORE is not set
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BCMGENET=m
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=m
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
# CONFIG_BNXT_HWMON is not set
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_CHELSIO_INLINE_CRYPTO=y
CONFIG_CHELSIO_IPSEC_INLINE=m
CONFIG_CHELSIO_TLS_DEVICE=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
# CONFIG_NET_VENDOR_CORTINA is not set
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=m
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
# CONFIG_BE2NET_BE2 is not set
# CONFIG_BE2NET_BE3 is not set
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
# CONFIG_NET_VENDOR_EZCHIP is not set
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_GVE=m
CONFIG_NET_VENDOR_HISILICON=y
# CONFIG_HIBMCGE is not set
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_HINIC=m
# CONFIG_HINIC3 is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_LIBETH=y
CONFIG_LIBIE=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
CONFIG_IXGBE=m
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBE_IPSEC=y
CONFIG_IXGBEVF=m
CONFIG_IXGBEVF_IPSEC=y
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
CONFIG_ICE=m
CONFIG_ICE_HWMON=y
CONFIG_ICE_SWITCHDEV=y
CONFIG_ICE_HWTS=y
CONFIG_FM10K=m
CONFIG_IGC=y
CONFIG_IDPF=m
# CONFIG_IDPF_SINGLEQ is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
# CONFIG_ADIN1110 is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_OCTEON_EP=m
# CONFIG_OCTEON_EP_VF is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
# CONFIG_MLX4_CORE_GEN2 is not set
CONFIG_MLX5_CORE=m
CONFIG_MLX5_FPGA=y
CONFIG_MLX5_CORE_EN=y
CONFIG_MLX5_EN_ARFS=y
CONFIG_MLX5_EN_RXNFC=y
CONFIG_MLX5_MPFS=y
CONFIG_MLX5_ESWITCH=y
CONFIG_MLX5_BRIDGE=y
CONFIG_MLX5_CLS_ACT=y
CONFIG_MLX5_TC_CT=y
CONFIG_MLX5_TC_SAMPLE=y
CONFIG_MLX5_CORE_EN_DCB=y
CONFIG_MLX5_CORE_IPOIB=y
# CONFIG_MLX5_MACSEC is not set
CONFIG_MLX5_EN_IPSEC=y
CONFIG_MLX5_EN_TLS=y
CONFIG_MLX5_SW_STEERING=y
CONFIG_MLX5_HW_STEERING=y
CONFIG_MLX5_SF=y
CONFIG_MLX5_SF_MANAGER=y
# CONFIG_MLX5_DPLL is not set
CONFIG_MLXSW_CORE=m
CONFIG_MLXSW_CORE_HWMON=y
CONFIG_MLXSW_CORE_THERMAL=y
CONFIG_MLXSW_PCI=m
CONFIG_MLXSW_I2C=m
CONFIG_MLXSW_SPECTRUM=m
CONFIG_MLXSW_SPECTRUM_DCB=y
CONFIG_MLXSW_MINIMAL=m
CONFIG_MLXFW=m
CONFIG_NET_VENDOR_META=y
# CONFIG_FBNIC is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_MICROSOFT_MANA=m
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NETERION is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
CONFIG_NFP_NET_IPSEC=y
# CONFIG_NFP_DEBUG is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_PACKET_ENGINES is not set
CONFIG_NET_VENDOR_PENSANDO=y
CONFIG_IONIC=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
# CONFIG_QLCNIC is not set
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_LL2=y
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_QED_RDMA=y
CONFIG_QED_ISCSI=y
CONFIG_QED_FCOE=y
CONFIG_QED_OOO=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_RTASE is not set
# CONFIG_NET_VENDOR_RENESAS is not set
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
# CONFIG_SFC_FALCON is not set
CONFIG_SFC_SIENA=m
CONFIG_SFC_SIENA_MTD=y
CONFIG_SFC_SIENA_MCDI_MON=y
CONFIG_SFC_SIENA_SRIOV=y
CONFIG_SFC_SIENA_MCDI_LOGGING=y
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_SOCIONEXT is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_SELFTESTS is not set
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_DWMAC_INTEL=m
# CONFIG_STMMAC_PCI is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XILINX is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PHYLINK=y
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
CONFIG_LED_TRIGGER_PHY=y
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
# CONFIG_AS21XXX_PHY is not set
# CONFIG_AIR_EN8811H_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_ADIN_PHY is not set
# CONFIG_ADIN1100_PHY is not set
CONFIG_AQUANTIA_PHY=m
CONFIG_AX88796B_PHY=y
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM54140_PHY is not set
CONFIG_BCM7XXX_PHY=m
# CONFIG_BCM84881_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BCM_NET_PHYPTP=m
CONFIG_CICADA_PHY=m
CONFIG_CORTINA_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_LXT_PHY=m
CONFIG_INTEL_XWAY_PHY=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_MARVELL_10G_PHY=m
CONFIG_MARVELL_88Q2XXX_PHY=m
# CONFIG_MARVELL_88X2222_PHY is not set
CONFIG_MAXLINEAR_GPHY=m
# CONFIG_MAXLINEAR_86110_PHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_T1S_PHY is not set
CONFIG_MICROCHIP_PHY=m
CONFIG_MICROCHIP_T1_PHY=m
CONFIG_MICROCHIP_PHY_RDS_PTP=m
CONFIG_MICROSEMI_PHY=m
# CONFIG_MOTORCOMM_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_CBTX_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_NCN26000_PHY is not set
# CONFIG_QCA83XX_PHY is not set
# CONFIG_QCA808X_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_REALTEK_PHY_HWMON is not set
CONFIG_RENESAS_PHY=m
CONFIG_ROCKCHIP_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
CONFIG_TERANETICS_PHY=m
CONFIG_DP83822_PHY=m
CONFIG_DP83TC811_PHY=m
CONFIG_DP83848_PHY=m
CONFIG_DP83867_PHY=m
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_DP83TG720_PHY is not set
CONFIG_VITESSE_PHY=m
CONFIG_XILINX_GMII2RGMII=m
CONFIG_MICREL_KS8995MA=m
CONFIG_CAN_DEV=m
CONFIG_CAN_VCAN=m
CONFIG_CAN_VXCAN=m
CONFIG_CAN_NETLINK=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_RX_OFFLOAD=y
# CONFIG_CAN_CAN327 is not set
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_CTUCANFD_PCI is not set
# CONFIG_CAN_ESD_402_PCI is not set
# CONFIG_CAN_IFI_CANFD is not set
CONFIG_CAN_M_CAN=m
CONFIG_CAN_M_CAN_PCI=m
# CONFIG_CAN_M_CAN_PLATFORM is not set
# CONFIG_CAN_M_CAN_TCAN4X5X is not set
CONFIG_CAN_PEAK_PCIEFD=m
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_SOFTING is not set

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
CONFIG_CAN_MCP251X=m
CONFIG_CAN_MCP251XFD=m
# CONFIG_CAN_MCP251XFD_SANITY is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
# CONFIG_CAN_ESD_USB is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_F81604 is not set
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_BCM_UNIMAC=m
CONFIG_MDIO_CAVIUM=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MVUSB is not set
CONFIG_MDIO_THUNDER=m

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
CONFIG_PCS_XPCS=m
# end of PCS device drivers

# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
# CONFIG_PPPOE_HASH_BITS_1 is not set
# CONFIG_PPPOE_HASH_BITS_2 is not set
CONFIG_PPPOE_HASH_BITS_4=y
# CONFIG_PPPOE_HASH_BITS_8 is not set
CONFIG_PPPOE_HASH_BITS=4
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=m
CONFIG_USB_LAN78XX=m
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET_ENABLE=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_USB_NET_CH9200=m
# CONFIG_USB_NET_AQC111 is not set
CONFIG_USB_RTL8153_ECM=m
CONFIG_WLAN=y
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
CONFIG_ATH9K=m
CONFIG_ATH9K_PCI=y
CONFIG_ATH9K_AHB=y
# CONFIG_ATH9K_DYNACK is not set
CONFIG_ATH9K_WOW=y
CONFIG_ATH9K_RFKILL=y
# CONFIG_ATH9K_CHANNEL_CONTEXT is not set
CONFIG_ATH9K_PCOEM=y
# CONFIG_ATH9K_PCI_NO_EEPROM is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_ATH9K_HWRNG is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
CONFIG_ATH10K=m
CONFIG_ATH10K_CE=y
CONFIG_ATH10K_PCI=m
# CONFIG_ATH10K_SDIO is not set
# CONFIG_ATH10K_USB is not set
# CONFIG_ATH10K_DEBUG is not set
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_LEDS=y
# CONFIG_ATH10K_SPECTRAL is not set
# CONFIG_ATH10K_TRACING is not set
# CONFIG_WCN36XX is not set
CONFIG_ATH11K=m
CONFIG_ATH11K_PCI=m
# CONFIG_ATH11K_DEBUG is not set
# CONFIG_ATH11K_TRACING is not set
# CONFIG_ATH12K is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
CONFIG_BRCMSMAC_LEDS=y
CONFIG_BRCMFMAC=m
CONFIG_BRCMFMAC_PROTO_BCDC=y
CONFIG_BRCMFMAC_PROTO_MSGBUF=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCMFMAC_USB=y
CONFIG_BRCMFMAC_PCIE=y
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
# CONFIG_IWLMLD is not set
CONFIG_IWLWIFI_OPMODE_MODULAR=y

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

# CONFIG_WLAN_VENDOR_INTERSIL is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
CONFIG_MWIFIEX_PCIE=m
CONFIG_MWIFIEX_USB=m
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_MT7601U=m
CONFIG_MT76_CORE=m
CONFIG_MT76_LEDS=y
CONFIG_MT76_USB=m
CONFIG_MT76x02_LIB=m
CONFIG_MT76x02_USB=m
CONFIG_MT76_CONNAC_LIB=m
CONFIG_MT792x_LIB=m
CONFIG_MT76x0_COMMON=m
CONFIG_MT76x0U=m
CONFIG_MT76x0E=m
CONFIG_MT76x2_COMMON=m
CONFIG_MT76x2E=m
CONFIG_MT76x2U=m
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
CONFIG_MT7921_COMMON=m
CONFIG_MT7921E=m
# CONFIG_MT7921S is not set
# CONFIG_MT7921U is not set
# CONFIG_MT7996E is not set
CONFIG_MT7925_COMMON=m
CONFIG_MT7925E=m
# CONFIG_MT7925U is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
CONFIG_RT2X00=m
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT3573=y
CONFIG_RT2800USB_RT53XX=y
CONFIG_RT2800USB_RT55XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2800_LIB_MMIO=m
CONFIG_RT2X00_LIB_MMIO=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
CONFIG_RTL8192CE=m
CONFIG_RTL8192SE=m
CONFIG_RTL8192DE=m
CONFIG_RTL8723AE=m
CONFIG_RTL8723BE=m
CONFIG_RTL8188EE=m
CONFIG_RTL8192EE=m
CONFIG_RTL8821AE=m
CONFIG_RTL8192CU=m
# CONFIG_RTL8192DU is not set
CONFIG_RTLWIFI=m
CONFIG_RTLWIFI_PCI=m
CONFIG_RTLWIFI_USB=m
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=m
CONFIG_RTL8192D_COMMON=m
CONFIG_RTL8723_COMMON=m
CONFIG_RTLBTCOEXIST=m
CONFIG_RTL8XXXU=m
# CONFIG_RTL8XXXU_UNTESTED is not set
CONFIG_RTW88=m
CONFIG_RTW88_CORE=m
CONFIG_RTW88_PCI=m
CONFIG_RTW88_8822B=m
CONFIG_RTW88_8822C=m
CONFIG_RTW88_8723X=m
CONFIG_RTW88_8723D=m
CONFIG_RTW88_8821C=m
CONFIG_RTW88_8822BE=m
# CONFIG_RTW88_8822BS is not set
# CONFIG_RTW88_8822BU is not set
CONFIG_RTW88_8822CE=m
# CONFIG_RTW88_8822CS is not set
# CONFIG_RTW88_8822CU is not set
CONFIG_RTW88_8723DE=m
# CONFIG_RTW88_8723DS is not set
# CONFIG_RTW88_8723CS is not set
# CONFIG_RTW88_8723DU is not set
CONFIG_RTW88_8821CE=m
# CONFIG_RTW88_8821CS is not set
# CONFIG_RTW88_8821CU is not set
# CONFIG_RTW88_8821AU is not set
# CONFIG_RTW88_8812AU is not set
# CONFIG_RTW88_8814AE is not set
# CONFIG_RTW88_8814AU is not set
# CONFIG_RTW88_DEBUG is not set
# CONFIG_RTW88_DEBUGFS is not set
CONFIG_RTW88_LEDS=y
CONFIG_RTW89=m
CONFIG_RTW89_CORE=m
CONFIG_RTW89_PCI=m
CONFIG_RTW89_8852A=m
CONFIG_RTW89_8852B_COMMON=m
CONFIG_RTW89_8852B=m
CONFIG_RTW89_8852C=m
# CONFIG_RTW89_8851BE is not set
CONFIG_RTW89_8852AE=m
CONFIG_RTW89_8852BE=m
# CONFIG_RTW89_8852BTE is not set
CONFIG_RTW89_8852CE=m
# CONFIG_RTW89_8922AE is not set
# CONFIG_RTW89_DEBUGMSG is not set
# CONFIG_WLAN_VENDOR_RSI is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_VIRT_WIFI is not set
CONFIG_WAN=y
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_FRAMER is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
CONFIG_WWAN=y
CONFIG_WWAN_DEBUGFS=y
CONFIG_WWAN_HWSIM=m
CONFIG_MHI_WWAN_CTRL=m
CONFIG_MHI_WWAN_MBIM=m
CONFIG_IOSM=m
CONFIG_MTK_T7XX=m
# end of Wireless WAN

CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_USB4_NET=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
CONFIG_TABLET_SERIAL_WACOM4=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMA140 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP5 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_I2C is not set
# CONFIG_TOUCHSCREEN_GOODIX_BERLIN_SPI is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_HYCON_HY46XX is not set
# CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_ILITEK is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MSG2638 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS is not set
# CONFIG_TOUCHSCREEN_IMAGIS is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_COLIBRI_VF50 is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
# CONFIG_TOUCHSCREEN_IQS7211 is not set
# CONFIG_TOUCHSCREEN_ZINITIX is not set
# CONFIG_TOUCHSCREEN_HIMAX_HX83112B is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_DA7280_HAPTICS is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_IQS626A is not set
# CONFIG_INPUT_IQS7222 is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F3A=y
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LEGACY_TIOCSTI=y
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCILIB=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_PCI1XXXX is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=m
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
# CONFIG_SERIAL_8250_NI is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TPM2_HMAC=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
# CONFIG_TCG_TIS_SPI_CR50 is not set
# CONFIG_TCG_TIS_I2C is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
CONFIG_TCG_VTPM_PROXY=m
# CONFIG_TCG_SVSM is not set
# CONFIG_TCG_TIS_ST33ZP24_I2C is not set
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_AMD_ASF is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
# CONFIG_I2C_ZHAOXIN is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_CH341 is not set
CONFIG_SPI_CS42L43=m
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_MICROCHIP_CORE_QSPI is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PCI1XXXX is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m
# CONFIG_PPS_GENERATOR is not set

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
CONFIG_PTP_1588_CLOCK_VMCLOCK=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_FC3W is not set
# CONFIG_PTP_1588_CLOCK_MOCK is not set
CONFIG_PTP_1588_CLOCK_VMW=m
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=y
# CONFIG_PINCTRL_CY8C95X0 is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_CS42L43=m

#
# Intel pinctrl drivers
#
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_INTEL_PLATFORM is not set
CONFIG_PINCTRL_ALDERLAKE=m
CONFIG_PINCTRL_BROXTON=m
CONFIG_PINCTRL_CANNONLAKE=m
CONFIG_PINCTRL_CEDARFORK=m
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_ELKHARTLAKE=m
CONFIG_PINCTRL_EMMITSBURG=m
CONFIG_PINCTRL_GEMINILAKE=m
CONFIG_PINCTRL_ICELAKE=m
CONFIG_PINCTRL_JASPERLAKE=m
CONFIG_PINCTRL_LAKEFIELD=m
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_METEORLAKE=m
# CONFIG_PINCTRL_METEORPOINT is not set
CONFIG_PINCTRL_SUNRISEPOINT=m
CONFIG_PINCTRL_TIGERLAKE=m
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_SWNODE_UNDEFINED=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_ALTERA is not set
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_GRANITERAPIDS is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_POLARFIRE_SOC is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_FXL6408 is not set
# CONFIG_GPIO_DS4520 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# CONFIG_GPIO_ELKHARTLAKE is not set
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_74X164 is not set
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# CONFIG_GPIO_MPSSE is not set
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
# CONFIG_GPIO_LATCH is not set
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

#
# GPIO Debugging utilities
#
# CONFIG_GPIO_SLOPPY_LOGIC_ANALYZER is not set
# CONFIG_GPIO_VIRTUSER is not set
# end of GPIO Debugging utilities

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
# CONFIG_POWER_RESET_TORADEX_EC is not set
# CONFIG_POWER_SEQUENCING is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CHAGALL is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_BATTERY_MAX1720X is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_MAX8971 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_FUEL_GAUGE_STC3117 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
# CONFIG_FUEL_GAUGE_MM8013 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_ASUS_ROG_RYUJIN is not set
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CHIPCAP2 is not set
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
# CONFIG_I8K is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
# CONFIG_SENSORS_GIGABYTE_WATERFORCE is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HS3001 is not set
# CONFIG_SENSORS_HTU31 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_ISL28022 is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWERZ is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LENOVO_EC is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2991 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LTC4282 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX31760 is not set
# CONFIG_MAX31827 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MC34VR500 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_MLXREG_FAN=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775_CORE=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7363 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_KRAKEN3 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ACBEL_FSG032 is not set
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_ADP1050 is not set
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_CRPS is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INA233 is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LT3074 is not set
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_LTC4286 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2856 is not set
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2891 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP2993 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_MP5920 is not set
# CONFIG_SENSORS_MP5990 is not set
# CONFIG_SENSORS_MP9941 is not set
# CONFIG_SENSORS_MPQ7932 is not set
# CONFIG_SENSORS_MPQ8785 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TDA38640 is not set
# CONFIG_SENSORS_TPS25990 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
# CONFIG_SENSORS_TPS546D24 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDP710 is not set
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_PT5161L is not set
# CONFIG_SENSORS_PWM_FAN is not set
# CONFIG_SENSORS_SBTSI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC2305 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_SPD5118 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_EC is not set
# CONFIG_SENSORS_HP_WMI is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_NETLINK=y
# CONFIG_THERMAL_STATISTICS is not set
# CONFIG_THERMAL_DEBUGFS is not set
# CONFIG_THERMAL_CORE_TESTING is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_PCIE_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_INTEL_TCC=y
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=m
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
CONFIG_INTEL_HFI_THERMAL=y
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_LENOVO_SE10_WDT is not set
# CONFIG_LENOVO_SE30_WDT is not set
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
CONFIG_MLX_WDT=m
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ADVANTECH_EC_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_EBC_C384_WDT is not set
# CONFIG_EXAR_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_INTEL_OC_WATCHDOG is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
# CONFIG_XEN_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_SMPRO is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CGBC is not set
CONFIG_MFD_CS42L43=m
# CONFIG_MFD_CS42L43_I2C is not set
CONFIG_MFD_CS42L43_SDW=m
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=m
CONFIG_MFD_INTEL_LPSS_ACPI=m
CONFIG_MFD_INTEL_LPSS_PCI=m
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77541 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77705 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6370 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_OCELOT is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RT5120 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS6594_I2C is not set
# CONFIG_MFD_TPS6594_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_CS40L50_I2C is not set
# CONFIG_MFD_CS40L50_SPI is not set
# CONFIG_MFD_INTEL_M10_BMC_SPI is not set
# CONFIG_MFD_UPBOARD_FPGA is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set
CONFIG_CEC_CORE=m
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# CONFIG_CEC_NXP_TDA9950 is not set
# CONFIG_CEC_GPIO is not set
# CONFIG_CEC_SECO is not set
# CONFIG_USB_EXTRON_DA_HD_4K_PLUS_CEC is not set
CONFIG_USB_PULSE8_CEC=m
CONFIG_USB_RAINSHADOW_CEC=m
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2_I2C=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_FWNODE=m
CONFIG_V4L2_ASYNC=m
# end of Video4Linux options

#
# Media controller options
#
# end of Media controller options

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_GSPCA=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_GL860=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MGB4 is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_IPU3_CIO2 is not set
# CONFIG_VIDEO_INTEL_IPU6 is not set
# CONFIG_INTEL_VSC is not set
# CONFIG_IPU_BRIDGE is not set
CONFIG_UVC_COMMON=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_VIDEO_CAMERA_SENSOR=y
# CONFIG_VIDEO_ALVIUM_CSI2 is not set
# CONFIG_VIDEO_AR0521 is not set
# CONFIG_VIDEO_GC0308 is not set
# CONFIG_VIDEO_GC05A2 is not set
# CONFIG_VIDEO_GC08A3 is not set
# CONFIG_VIDEO_GC2145 is not set
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_HI846 is not set
# CONFIG_VIDEO_HI847 is not set
# CONFIG_VIDEO_IMX208 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX283 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX296 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9M114 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_OG01A1B is not set
# CONFIG_VIDEO_OV01A10 is not set
# CONFIG_VIDEO_OV02A10 is not set
# CONFIG_VIDEO_OV02E10 is not set
# CONFIG_VIDEO_OV02C10 is not set
# CONFIG_VIDEO_OV08D10 is not set
# CONFIG_VIDEO_OV08X40 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_OV13B10 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV4689 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV5648 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5693 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV64A40 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV8858 is not set
# CONFIG_VIDEO_OV8865 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV9734 is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RDACM21 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_VD55G1 is not set
# CONFIG_VIDEO_VD56G3 is not set
# CONFIG_VIDEO_CCS is not set
# CONFIG_VIDEO_ET8EK8 is not set

#
# Camera ISPs
#
# CONFIG_VIDEO_THP7312 is not set
# end of Camera ISPs

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9719 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_CS3308 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# CONFIG_VIDEO_TDA1997X is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_WM8775 is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_LT6911UXE is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TC358746 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9900 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set
# end of Video decoders

#
# Video encoders
#
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# end of Video improvement chips

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_M52790 is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# CONFIG_VIDEO_THS7303 is not set
# end of Miscellaneous helper chips

#
# Video serializers and deserializers
#
# end of Video serializers and deserializers

#
# Media SPI Adapters
#
# CONFIG_VIDEO_GS1662 is not set
# end of Media SPI Adapters
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_APERTURE_HELPERS=y
CONFIG_SCREEN_INFO=y
CONFIG_VIDEO=y
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m

#
# DRM debugging options
#
# CONFIG_DRM_WERROR is not set
# CONFIG_DRM_DEBUG_MM is not set
# end of DRM debugging options

CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_PANIC is not set
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
# CONFIG_DRM_DEBUG_MODESET_LOCK is not set
CONFIG_DRM_CLIENT=y
CONFIG_DRM_CLIENT_LIB=m
CONFIG_DRM_CLIENT_SELECTION=m
CONFIG_DRM_CLIENT_SETUP=y

#
# Supported DRM clients
#
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
# CONFIG_DRM_CLIENT_LOG is not set
CONFIG_DRM_CLIENT_DEFAULT_FBDEV=y
CONFIG_DRM_CLIENT_DEFAULT="fbdev"
# end of Supported DRM clients

CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DISPLAY_HELPER=m
# CONFIG_DRM_DISPLAY_DP_AUX_CEC is not set
# CONFIG_DRM_DISPLAY_DP_AUX_CHARDEV is not set
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_DP_TUNNEL=y
CONFIG_DRM_DISPLAY_DSC_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
CONFIG_DRM_TTM=m
CONFIG_DRM_EXEC=m
CONFIG_DRM_GPUVM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=m
CONFIG_DRM_SUBALLOC_HELPER=m
CONFIG_DRM_SCHED=m

#
# Drivers for system framebuffers
#
# CONFIG_DRM_EFIDRM is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_DRM_VESADRM is not set
# end of Drivers for system framebuffers

#
# ARM devices
#
# end of ARM devices

CONFIG_DRM_RADEON=m
CONFIG_DRM_RADEON_USERPTR=y
CONFIG_DRM_AMDGPU=m
# CONFIG_DRM_AMDGPU_SI is not set
# CONFIG_DRM_AMDGPU_CIK is not set
CONFIG_DRM_AMDGPU_USERPTR=y
# CONFIG_DRM_AMD_ISP is not set
# CONFIG_DRM_AMDGPU_WERROR is not set

#
# ACP (Audio CoProcessor) Configuration
#
CONFIG_DRM_AMD_ACP=y
# end of ACP (Audio CoProcessor) Configuration

#
# Display Engine Configuration
#
CONFIG_DRM_AMD_DC=y
CONFIG_DRM_AMD_DC_FP=y
# CONFIG_DRM_AMD_SECURE_DISPLAY is not set
# end of Display Engine Configuration

CONFIG_HSA_AMD=y
CONFIG_HSA_AMD_SVM=y
# CONFIG_HSA_AMD_P2P is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_NOUVEAU_DEBUG_MMU is not set
# CONFIG_NOUVEAU_DEBUG_PUSH is not set
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_NOUVEAU_GSP_DEFAULT is not set
CONFIG_DRM_NOUVEAU_CH7006=m
CONFIG_DRM_NOUVEAU_SIL164=m
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
# CONFIG_DRM_I915_GVT_KVMGT is not set
CONFIG_DRM_I915_DP_TUNNEL=y

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_REPLAY_GPU_HANGS_API is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# CONFIG_DRM_I915_DEBUG_WAKEREF is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

# CONFIG_DRM_XE is not set
# CONFIG_DRM_VGEM is not set
CONFIG_DRM_VKMS=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_MKSSTATS is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_VIRTIO_GPU_KMS=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_AUO_A030JTN01 is not set
# CONFIG_DRM_PANEL_ILITEK_ILI9341 is not set
# CONFIG_DRM_PANEL_ORISETECH_OTA5601A is not set
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_APPLETBDRM is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_GM12U320=m
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_SHARP_MEMORY is not set
# CONFIG_DRM_XEN_FRONTEND is not set
# CONFIG_DRM_VBOXVIDEO is not set
CONFIG_DRM_GUD=m
# CONFIG_DRM_ST7571_I2C is not set
# CONFIG_DRM_ST7586 is not set
# CONFIG_DRM_ST7735R is not set
# CONFIG_DRM_SSD130X is not set
CONFIG_DRM_HYPERV=m
CONFIG_DRM_PANEL_BACKLIGHT_QUIRKS=m
CONFIG_DRM_PRIVACY_SCREEN=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_HYPERV is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
CONFIG_FB_CORE=y
CONFIG_FB_NOTIFY=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DEVICE=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYSMEM_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_IOMEM_FOPS=y
CONFIG_FB_IOMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS=y
CONFIG_FB_SYSMEM_HELPERS_DEFERRED=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_KTD2801 is not set
# CONFIG_BACKLIGHT_KTZ8866 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3509 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_MP3309C is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_DRM_ACCEL is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_UMP=m
CONFIG_SND_UMP_LEGACY_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_CTL_FAST_LOOKUP=y
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
# CONFIG_SND_UTIMER is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_CTL_LED=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_SEQ_UMP=y
CONFIG_SND_SEQ_UMP_CLIENT=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_PCMTEST is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_GENERIC_LEDS=y
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_ACPI is not set
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CIRRUS_SCODEC=m
CONFIG_SND_HDA_SCODEC_CS35L41=m
CONFIG_SND_HDA_SCODEC_COMPONENT=m
CONFIG_SND_HDA_SCODEC_CS35L41_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L41_SPI=m
CONFIG_SND_HDA_SCODEC_CS35L56=m
CONFIG_SND_HDA_SCODEC_CS35L56_I2C=m
CONFIG_SND_HDA_SCODEC_CS35L56_SPI=m
CONFIG_SND_HDA_SCODEC_TAS2781=m
CONFIG_SND_HDA_SCODEC_TAS2781_I2C=m
# CONFIG_SND_HDA_SCODEC_TAS2781_SPI is not set
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CS8409=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
# CONFIG_SND_HDA_CODEC_SENARYTECH is not set
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=1
CONFIG_SND_HDA_INTEL_HDMI_SILENT_STREAM=y
# CONFIG_SND_HDA_CTL_DEV_ID is not set
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
CONFIG_SND_INTEL_SOUNDWIRE_ACPI=m
# CONFIG_SND_INTEL_BYT_PREFER_SOF is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_MIDI_V2=y
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_USB is not set
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
CONFIG_SND_SOC_AMD_RENOIR=m
CONFIG_SND_SOC_AMD_RENOIR_MACH=m
CONFIG_SND_SOC_AMD_ACP5x=m
CONFIG_SND_SOC_AMD_VANGOGH_MACH=m
CONFIG_SND_SOC_AMD_ACP6x=m
CONFIG_SND_SOC_AMD_YC_MACH=m
CONFIG_SND_AMD_ACP_CONFIG=m
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
CONFIG_SND_SOC_ACPI_AMD_MATCH=m
CONFIG_SND_AMD_SOUNDWIRE_ACPI=m
# CONFIG_SND_SOC_AMD_RPL_ACP6x is not set
CONFIG_SND_SOC_AMD_ACP63_TOPLEVEL=m
CONFIG_SND_SOC_AMD_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_AMD_SOUNDWIRE=m
CONFIG_SND_SOC_AMD_PS=m
CONFIG_SND_SOC_AMD_PS_MACH=m
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_BCM63XX_I2S_WHISTLER is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_FSL_XCVR is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_SOC_CHV3_I2S is not set
# CONFIG_SND_I2S_HI6210_I2S is not set

#
# SoC Audio for Loongson CPUs
#
# end of SoC Audio for Loongson CPUs

# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SOC_INTEL_CATPT=m
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_ACPI_INTEL_SDCA_QUIRKS=m
CONFIG_SND_SOC_INTEL_AVS=m

#
# Intel AVS Machine drivers
#

#
# Available DSP configurations
#
# CONFIG_SND_SOC_INTEL_AVS_CARDNAME_OBSOLETE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DA7219 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_DMIC is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_ES8336 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_HDAUDIO is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_I2S_TEST is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98927 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98357A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_MAX98373 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_NAU8825 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PCM3168A is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_PROBE is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT274 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT286 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT298 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5514 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5663 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_RT5682 is not set
# CONFIG_SND_SOC_INTEL_AVS_MACH_SSM4567 is not set
# end of Intel AVS Machine drivers

CONFIG_SND_SOC_INTEL_MACH=y
CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES=y
CONFIG_SND_SOC_INTEL_HDA_DSP_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_MAXIM_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_REALTEK_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_CIRRUS_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_NUVOTON_COMMON=m
CONFIG_SND_SOC_INTEL_SOF_BOARD_HELPERS=m
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5650_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_WM8804_MACH=m
CONFIG_SND_SOC_INTEL_GLK_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_GLK_RT5682_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SKL_HDA_DSP_GENERIC_MACH=m
CONFIG_SND_SOC_INTEL_SOF_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CS42L42_MACH=m
CONFIG_SND_SOC_INTEL_SOF_PCM512x_MACH=m
CONFIG_SND_SOC_INTEL_SOF_ES8336_MACH=m
CONFIG_SND_SOC_INTEL_SOF_NAU8825_MACH=m
CONFIG_SND_SOC_INTEL_CML_LP_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_SOF_CML_RT1011_RT5682_MACH=m
CONFIG_SND_SOC_INTEL_SOF_DA7219_MACH=m
CONFIG_SND_SOC_INTEL_SOF_SSP_AMP_MACH=m
CONFIG_SND_SOC_INTEL_EHL_RT5660_MACH=m
CONFIG_SND_SOC_INTEL_SOUNDWIRE_SOF_MACH=m
# CONFIG_SND_SOC_MTK_BTCVSD is not set
CONFIG_SND_SOC_SDCA=m
CONFIG_SND_SOC_SDCA_OPTIONAL=m
CONFIG_SND_SOC_SOF_TOPLEVEL=y
CONFIG_SND_SOC_SOF_PCI_DEV=m
CONFIG_SND_SOC_SOF_PCI=m
CONFIG_SND_SOC_SOF_ACPI=m
CONFIG_SND_SOC_SOF_ACPI_DEV=m
CONFIG_SND_SOC_SOF_DEBUG_PROBES=m
CONFIG_SND_SOC_SOF_CLIENT=m
# CONFIG_SND_SOC_SOF_DEVELOPER_SUPPORT is not set
CONFIG_SND_SOC_SOF=m
CONFIG_SND_SOC_SOF_PROBE_WORK_QUEUE=y
CONFIG_SND_SOC_SOF_IPC3=y
CONFIG_SND_SOC_SOF_IPC4=y
CONFIG_SND_SOC_SOF_AMD_TOPLEVEL=m
CONFIG_SND_SOC_SOF_AMD_COMMON=m
CONFIG_SND_SOC_SOF_AMD_RENOIR=m
CONFIG_SND_SOC_SOF_AMD_VANGOGH=m
CONFIG_SND_SOC_SOF_AMD_REMBRANDT=m
CONFIG_SND_SOC_SOF_ACP_PROBES=m
# CONFIG_SND_SOC_SOF_AMD_ACP63 is not set
# CONFIG_SND_SOC_SOF_AMD_ACP70 is not set
CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL=y
CONFIG_SND_SOC_SOF_INTEL_HIFI_EP_IPC=m
CONFIG_SND_SOC_SOF_INTEL_ATOM_HIFI_EP=m
CONFIG_SND_SOC_SOF_INTEL_COMMON=m
CONFIG_SND_SOC_SOF_BAYTRAIL=m
CONFIG_SND_SOC_SOF_BROADWELL=m
CONFIG_SND_SOC_SOF_MERRIFIELD=m
# CONFIG_SND_SOC_SOF_SKYLAKE is not set
# CONFIG_SND_SOC_SOF_KABYLAKE is not set
CONFIG_SND_SOC_SOF_INTEL_APL=m
CONFIG_SND_SOC_SOF_APOLLOLAKE=m
CONFIG_SND_SOC_SOF_GEMINILAKE=m
CONFIG_SND_SOC_SOF_INTEL_CNL=m
CONFIG_SND_SOC_SOF_CANNONLAKE=m
CONFIG_SND_SOC_SOF_COFFEELAKE=m
CONFIG_SND_SOC_SOF_COMETLAKE=m
CONFIG_SND_SOC_SOF_INTEL_ICL=m
CONFIG_SND_SOC_SOF_ICELAKE=m
CONFIG_SND_SOC_SOF_JASPERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_TGL=m
CONFIG_SND_SOC_SOF_TIGERLAKE=m
CONFIG_SND_SOC_SOF_ELKHARTLAKE=m
CONFIG_SND_SOC_SOF_ALDERLAKE=m
CONFIG_SND_SOC_SOF_INTEL_MTL=m
CONFIG_SND_SOC_SOF_METEORLAKE=m
CONFIG_SND_SOC_SOF_INTEL_LNL=m
CONFIG_SND_SOC_SOF_LUNARLAKE=m
CONFIG_SND_SOC_SOF_INTEL_PTL=m
CONFIG_SND_SOC_SOF_PANTHERLAKE=m
CONFIG_SND_SOC_SOF_HDA_COMMON=m
CONFIG_SND_SOC_SOF_HDA_GENERIC=m
CONFIG_SND_SOC_SOF_HDA_MLINK=m
CONFIG_SND_SOC_SOF_HDA_LINK=y
CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC=y
CONFIG_SND_SOF_SOF_HDA_SDW_BPT=m
CONFIG_SND_SOC_SOF_HDA_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_HDA=m
CONFIG_SND_SOC_SOF_HDA_PROBES=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE=m
CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE=m
CONFIG_SND_SOC_SOF_XTENSA=m

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
CONFIG_SND_SOC_WM_ADSP=m
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1372_I2C is not set
# CONFIG_SND_SOC_ADAU1372_SPI is not set
# CONFIG_SND_SOC_ADAU1373 is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4375 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4619 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_AUDIO_IIO_AUX is not set
# CONFIG_SND_SOC_AW8738 is not set
# CONFIG_SND_SOC_AW88395 is not set
# CONFIG_SND_SOC_AW88166 is not set
# CONFIG_SND_SOC_AW88261 is not set
# CONFIG_SND_SOC_AW88081 is not set
# CONFIG_SND_SOC_AW87390 is not set
# CONFIG_SND_SOC_AW88399 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CHV3_CODEC is not set
CONFIG_SND_SOC_CS_AMP_LIB=m
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
CONFIG_SND_SOC_CS35L41_LIB=m
CONFIG_SND_SOC_CS35L41=m
CONFIG_SND_SOC_CS35L41_SPI=m
CONFIG_SND_SOC_CS35L41_I2C=m
# CONFIG_SND_SOC_CS35L45_SPI is not set
# CONFIG_SND_SOC_CS35L45_I2C is not set
CONFIG_SND_SOC_CS35L56=m
CONFIG_SND_SOC_CS35L56_SHARED=m
# CONFIG_SND_SOC_CS35L56_I2C is not set
CONFIG_SND_SOC_CS35L56_SPI=m
CONFIG_SND_SOC_CS35L56_SDW=m
CONFIG_SND_SOC_CS42L42_CORE=m
CONFIG_SND_SOC_CS42L42=m
CONFIG_SND_SOC_CS42L42_SDW=m
CONFIG_SND_SOC_CS42L43=m
CONFIG_SND_SOC_CS42L43_SDW=m
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS42L83 is not set
# CONFIG_SND_SOC_CS42L84 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS48L32 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CS530X_I2C is not set
CONFIG_SND_SOC_CX2072X=m
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES83XX_DSM_COMMON=m
# CONFIG_SND_SOC_ES8311 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8323 is not set
CONFIG_SND_SOC_ES8326=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_ES8375 is not set
# CONFIG_SND_SOC_ES8389 is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDA=m
CONFIG_SND_SOC_HDA=m
# CONFIG_SND_SOC_ICS43432 is not set
# CONFIG_SND_SOC_IDT821034 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98520 is not set
CONFIG_SND_SOC_MAX98363=m
CONFIG_SND_SOC_MAX98373=m
CONFIG_SND_SOC_MAX98373_I2C=m
CONFIG_SND_SOC_MAX98373_SDW=m
CONFIG_SND_SOC_MAX98388=m
CONFIG_SND_SOC_MAX98390=m
# CONFIG_SND_SOC_MAX98396 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM5102A is not set
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_PCM6240 is not set
# CONFIG_SND_SOC_PEB2466 is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RT_SDW_COMMON=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT1011=m
CONFIG_SND_SOC_RT1015=m
CONFIG_SND_SOC_RT1015P=m
# CONFIG_SND_SOC_RT1017_SDCA_SDW is not set
CONFIG_SND_SOC_RT1308=m
CONFIG_SND_SOC_RT1308_SDW=m
CONFIG_SND_SOC_RT1316_SDW=m
CONFIG_SND_SOC_RT1318_SDW=m
CONFIG_SND_SOC_RT1320_SDW=m
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
# CONFIG_SND_SOC_RT5659 is not set
CONFIG_SND_SOC_RT5660=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
CONFIG_SND_SOC_RT5682=m
CONFIG_SND_SOC_RT5682_I2C=m
CONFIG_SND_SOC_RT5682_SDW=m
CONFIG_SND_SOC_RT5682S=m
CONFIG_SND_SOC_RT700=m
CONFIG_SND_SOC_RT700_SDW=m
CONFIG_SND_SOC_RT711=m
CONFIG_SND_SOC_RT711_SDW=m
CONFIG_SND_SOC_RT711_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_SDW=m
CONFIG_SND_SOC_RT712_SDCA_DMIC_SDW=m
CONFIG_SND_SOC_RT721_SDCA_SDW=m
CONFIG_SND_SOC_RT722_SDCA_SDW=m
CONFIG_SND_SOC_RT715=m
CONFIG_SND_SOC_RT715_SDW=m
CONFIG_SND_SOC_RT715_SDCA_SDW=m
# CONFIG_SND_SOC_RT9120 is not set
# CONFIG_SND_SOC_RT9123 is not set
# CONFIG_SND_SOC_RT9123P is not set
# CONFIG_SND_SOC_RTQ9128 is not set
# CONFIG_SND_SOC_SDW_MOCKUP is not set
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIMPLE_MUX is not set
# CONFIG_SND_SOC_SMA1303 is not set
# CONFIG_SND_SOC_SMA1307 is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SRC4XXX_I2C is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2518 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2764 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS2780 is not set
CONFIG_SND_SOC_TAS2781_COMLIB=m
CONFIG_SND_SOC_TAS2781_COMLIB_I2C=m
CONFIG_SND_SOC_TAS2781_FMWLIB=m
# CONFIG_SND_SOC_TAS2781_I2C is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS5805M is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TFA989X is not set
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
# CONFIG_SND_SOC_TLV320AIC3X_SPI is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_UDA1342 is not set
# CONFIG_SND_SOC_WCD937X_SDW is not set
# CONFIG_SND_SOC_WCD938X_SDW is not set
# CONFIG_SND_SOC_WCD939X_SDW is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8731_SPI is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8804_I2C=m
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8940 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8961 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_WSA881X is not set
# CONFIG_SND_SOC_WSA883X is not set
# CONFIG_SND_SOC_WSA884X is not set
# CONFIG_SND_SOC_ZL38060 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6357 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
CONFIG_SND_SOC_NAU8315=m
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
CONFIG_SND_SOC_NAU8821=m
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_NTP8918 is not set
# CONFIG_SND_SOC_NTP8835 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
# CONFIG_SND_SOC_LPASS_WSA_MACRO is not set
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
# CONFIG_SND_SOC_LPASS_TX_MACRO is not set
# end of CODEC drivers

CONFIG_SND_SOC_SDW_UTILS=m
# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
CONFIG_SND_XEN_FRONTEND=m
CONFIG_SND_VIRTIO=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_APPLEIR=m
# CONFIG_HID_APPLETB_BL is not set
# CONFIG_HID_APPLETB_KBD is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BETOP_FF=m
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CORSAIR=m
CONFIG_HID_COUGAR=m
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELAN=m
CONFIG_HID_ELECOM=m
CONFIG_HID_ELO=m
CONFIG_HID_EVISION=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GOODIX_SPI is not set
# CONFIG_HID_GOOGLE_STADIA_FF is not set
# CONFIG_HID_VIVALDI is not set
CONFIG_HID_GT683R=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_KYSONA is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
CONFIG_HID_XIAOMI=m
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LETSKETCH=m
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_MEGAWORLD_FF is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
CONFIG_HID_NTRIG=y
# CONFIG_HID_NVIDIA_SHIELD is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PENMOUNT=m
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SEMITEK=m
CONFIG_HID_SIGMAMICRO=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_TOPRE is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_UNIVERSAL_PIDFF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_WINWING is not set
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2200 is not set
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# HID-BPF support
#
CONFIG_HID_BPF=y
# end of HID-BPF support

CONFIG_I2C_HID=y
CONFIG_I2C_HID_ACPI=m
# CONFIG_I2C_HID_OF is not set
CONFIG_I2C_HID_CORE=m

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
CONFIG_AMD_SFH_HID=m
# end of AMD SFH HID Support

#
# Intel THC HID Support
#
# CONFIG_INTEL_THC_HID is not set
# end of Intel THC HID Support

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_PCI_AMD=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_DEFAULT_AUTHORIZATION_MODE=1
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_DBGCAP=y
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
CONFIG_USB_XHCI_PLATFORM=m
# CONFIG_USB_XHCI_SIDEBAND is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set
# CONFIG_USB_XEN_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
# CONFIG_USBIP_CORE is not set

#
# USB dual-mode controller drivers
#
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
CONFIG_USB_SERIAL_F8153X=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_UPD78F0730=m
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_LJCA is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
# CONFIG_TYPEC_RT1711H is not set
# CONFIG_TYPEC_TCPCI_MAXIM is not set
CONFIG_TYPEC_FUSB302=m
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_UCSI_STM32G0 is not set
CONFIG_TYPEC_TPS6598X=m
# CONFIG_TYPEC_ANX7411 is not set
CONFIG_TYPEC_RT1719=m
# CONFIG_TYPEC_HD3SS3220 is not set
# CONFIG_TYPEC_STUSB160X is not set
CONFIG_TYPEC_WUSB3801=m

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
CONFIG_TYPEC_MUX_FSA4480=m
# CONFIG_TYPEC_MUX_GPIO_SBU is not set
CONFIG_TYPEC_MUX_PI3USB30532=m
# CONFIG_TYPEC_MUX_IT5205 is not set
# CONFIG_TYPEC_MUX_NB7VPQ904M is not set
# CONFIG_TYPEC_MUX_PS883X is not set
# CONFIG_TYPEC_MUX_PTN36502 is not set
# CONFIG_TYPEC_MUX_TUSB1046 is not set
# CONFIG_TYPEC_MUX_WCD939X_USBSS is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
CONFIG_TYPEC_DP_ALTMODE=m
# CONFIG_TYPEC_NVIDIA_ALTMODE is not set
# CONFIG_TYPEC_TBT_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
CONFIG_USB_ROLES_INTEL_XHCI=m
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_UHS2=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_REALTEK_USB=m
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_USB=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_AW200XX is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA995X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2606MVV is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_IS31FL319X is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
CONFIG_LEDS_MLXREG=m
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_SPI_BYTE is not set

#
# Flash and Torch LED drivers
#

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_DISK=y
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
# CONFIG_LEDS_TRIGGER_TTY is not set
# CONFIG_LEDS_TRIGGER_INPUT_EVENTS is not set

#
# Simatic LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
CONFIG_INFINIBAND_VIRT_DMA=y
CONFIG_INFINIBAND_BNXT_RE=m
CONFIG_INFINIBAND_CXGB4=m
CONFIG_INFINIBAND_EFA=m
# CONFIG_INFINIBAND_ERDMA is not set
CONFIG_INFINIBAND_HFI1=m
# CONFIG_HFI1_DEBUG_SDMA_ORDER is not set
# CONFIG_SDMA_VERBOSITY is not set
CONFIG_INFINIBAND_IRDMA=m
CONFIG_MANA_INFINIBAND=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_MLX5_INFINIBAND=m
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_QEDR=m
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_USNIC=m
CONFIG_INFINIBAND_VMWARE_PVRDMA=m
CONFIG_INFINIBAND_RDMAVT=m
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_INFINIBAND_ISER=m
CONFIG_INFINIBAND_ISERT=m
# CONFIG_INFINIBAND_RTRS_CLIENT is not set
# CONFIG_INFINIBAND_RTRS_SERVER is not set
CONFIG_INFINIBAND_OPA_VNIC=m
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
# CONFIG_EDAC_SCRUB is not set
# CONFIG_EDAC_ECS is not set
# CONFIG_EDAC_MEM_REPAIR is not set
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
CONFIG_EDAC_I10NM=m
CONFIG_EDAC_PND2=m
CONFIG_EDAC_IGEN6=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_MAX31335 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8111 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
CONFIG_RTC_DRV_RV8803=m
# CONFIG_RTC_DRV_SD2405AL is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_RP5C01=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
CONFIG_INTEL_IDXD_BUS=m
CONFIG_INTEL_IDXD=m
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IDXD_SVM=y
CONFIG_INTEL_IDXD_PERFMON=y
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_DMA is not set
# CONFIG_XILINX_XDMA is not set
# CONFIG_AMD_AE4DMA is not set
CONFIG_AMD_PTDMA=m
# CONFIG_AMD_QDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
CONFIG_DMABUF_MOVE_NOTIFY=y
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO=m
CONFIG_VFIO_DEVICE_CDEV=y
CONFIG_VFIO_GROUP=y
CONFIG_VFIO_CONTAINER=y
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_VIRQFD=y
# CONFIG_VFIO_DEBUGFS is not set

#
# VFIO support for PCI devices
#
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_MLX5_VFIO_PCI=m
# CONFIG_VIRTIO_VFIO_PCI is not set
# CONFIG_QAT_VFIO_PCI is not set
# end of VFIO support for PCI devices

CONFIG_IRQ_BYPASS_MANAGER=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VMGENID=y
# CONFIG_VBOXGUEST is not set
CONFIG_NITRO_ENCLAVES=m
CONFIG_EFI_SECRET=m
CONFIG_SEV_GUEST=m
CONFIG_TDX_GUEST_DRIVER=m
CONFIG_TSM_GUEST=y
CONFIG_TSM_REPORTS=m
CONFIG_TSM_MEASUREMENTS=y
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_ADMIN_LEGACY=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_VDPA=m
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VIRTIO_DEBUG is not set
# CONFIG_VIRTIO_RTC is not set
CONFIG_VDPA=m
# CONFIG_VDPA_USER is not set
CONFIG_IFCVF=m
CONFIG_MLX5_VDPA=y
CONFIG_MLX5_VDPA_NET=m
# CONFIG_MLX5_VDPA_STEERING_DEBUG is not set
CONFIG_VP_VDPA=m
# CONFIG_ALIBABA_ENI_VDPA is not set
# CONFIG_SNET_VDPA is not set
# CONFIG_OCTEONEP_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST_RING=m
CONFIG_VHOST_TASK=y
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST_VDPA=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
# CONFIG_HYPERV_VTL_MODE is not set
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# CONFIG_MSHV_ROOT is not set
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_FRONT_PGDIR_SHBUF=m
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# CONFIG_XEN_VIRTIO is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
# CONFIG_GOLDFISH is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLX_PLATFORM=m
# CONFIG_MLXREG_DPU is not set
CONFIG_MLXREG_HOTPLUG=m
CONFIG_MLXREG_IO=m
CONFIG_MLXREG_LC=m
CONFIG_NVSW_SN2201=m
# CONFIG_SURFACE_PLATFORMS is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
CONFIG_UV_SYSFS=m
CONFIG_MXM_WMI=m
CONFIG_NVIDIA_WMI_EC_BACKLIGHT=m
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK is not set
# CONFIG_ACERHDF is not set
CONFIG_ACER_WIRELESS=m
CONFIG_ACER_WMI=m

#
# AMD HSMP Driver
#
# CONFIG_AMD_HSMP_ACPI is not set
# CONFIG_AMD_HSMP_PLAT is not set
# end of AMD HSMP Driver

CONFIG_AMD_PMC=m
CONFIG_AMD_MP2_STB=y
# CONFIG_AMD_3D_VCACHE is not set
# CONFIG_AMD_WBRF is not set
# CONFIG_AMD_ISP_PLATFORM is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_X86_PLATFORM_DRIVERS_DELL=y
# CONFIG_ALIENWARE_WMI is not set
CONFIG_DCDBAS=m
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBU=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_PC=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
# CONFIG_DELL_SMBIOS_SMM is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_PRIVACY=y
CONFIG_DELL_WMI_AIO=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_DDV=m
CONFIG_DELL_WMI_LED=m
CONFIG_DELL_WMI_SYSMAN=m
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_X86_PLATFORM_DRIVERS_HP is not set
CONFIG_WIRELESS_HOTKEY=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_LENOVO_WMI_HOTKEY_UTILITIES is not set
# CONFIG_LENOVO_YMC is not set
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_THINKPAD_LMI=m
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_IFS=m
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m
CONFIG_INTEL_PMC_SSRAM_TELEMETRY=m
CONFIG_INTEL_PMT_CLASS=m
CONFIG_INTEL_PMT_TELEMETRY=m
CONFIG_INTEL_PMT_CRASHLOG=m

#
# Intel Speed Select Technology interface support
#
CONFIG_INTEL_SPEED_SELECT_TPMI=m
CONFIG_INTEL_SPEED_SELECT_INTERFACE=m
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
CONFIG_INTEL_UNCORE_FREQ_CONTROL_TPMI=m
CONFIG_INTEL_UNCORE_FREQ_CONTROL=m
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_ISHTP_ECLITE=m
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SDSI=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TPMI_POWER_DOMAINS=m
CONFIG_INTEL_TPMI=m
# CONFIG_INTEL_PLR_TPMI is not set
CONFIG_INTEL_TURBO_MAX_3=y
CONFIG_INTEL_VSEC=m
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_MEEGOPAD_ANX7428 is not set
# CONFIG_MSI_EC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_MSI_WMI_PLATFORM is not set
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_PORTWELL_EC is not set
# CONFIG_BARCO_P50_GPIO is not set
# CONFIG_SAMSUNG_GALAXYBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_SERIAL_MULTI_INSTANTIATE=m
# CONFIG_INSPUR_PLATFORM_PROFILE is not set
# CONFIG_LENOVO_WMI_CAMERA is not set
# CONFIG_DASHARO_ACPI is not set
CONFIG_FW_ATTR_CLASS=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
# CONFIG_WINMATE_FM07_KEYS is not set
# CONFIG_SEL3350_PLATFORM is not set
# CONFIG_OXP_EC is not set
# CONFIG_TUXEDO_NB04_WMI_AB is not set
CONFIG_P2SB=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMUFD_DRIVER=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IO_PGTABLE=y
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_IOMMU_SVA=y
CONFIG_IOMMU_IOPF=y
CONFIG_AMD_IOMMU=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_PERF_EVENTS=y
CONFIG_IOMMUFD_DRIVER_CORE=y
CONFIG_IOMMUFD=m
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y
CONFIG_VIRTIO_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=m

#
# SoundWire Devices
#
CONFIG_SOUNDWIRE_AMD=m
CONFIG_SOUNDWIRE_CADENCE=m
CONFIG_SOUNDWIRE_INTEL=m
# CONFIG_SOUNDWIRE_QCOM is not set
CONFIG_SOUNDWIRE_GENERIC_ALLOCATION=m

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

# CONFIG_WPCM450_SOC is not set

#
# Qualcomm SoC drivers
#
CONFIG_QCOM_QMI_HELPERS=m
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

#
# PM Domains
#

#
# Amlogic PM Domains
#
# end of Amlogic PM Domains

#
# Broadcom PM Domains
#
# end of Broadcom PM Domains

#
# i.MX PM Domains
#
# end of i.MX PM Domains

#
# Qualcomm PM Domains
#
# end of Qualcomm PM Domains
# end of PM Domains

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
# CONFIG_IIO_BUFFER_DMA is not set
# CONFIG_IIO_BUFFER_DMAENGINE is not set
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL313_I2C is not set
# CONFIG_ADXL313_SPI is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL355_I2C is not set
# CONFIG_ADXL355_SPI is not set
# CONFIG_ADXL367_SPI is not set
# CONFIG_ADXL367_I2C is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_ADXL380_SPI is not set
# CONFIG_ADXL380_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_BMI088_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD06 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
# CONFIG_FXLS8962AF_I2C is not set
# CONFIG_FXLS8962AF_SPI is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_IIO_KX022A_SPI is not set
# CONFIG_IIO_KX022A_I2C is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MSA311 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_SCA3300 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD4000 is not set
# CONFIG_AD4030 is not set
# CONFIG_AD4130 is not set
# CONFIG_AD4695 is not set
# CONFIG_AD4851 is not set
# CONFIG_AD7091R5 is not set
# CONFIG_AD7091R8 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7173 is not set
# CONFIG_AD7191 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7280 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7380 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7625 is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7779 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7944 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_AD9467 is not set
# CONFIG_ENVELOPE_DETECTOR is not set
# CONFIG_GEHC_PMC_ADC is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2309 is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX11205 is not set
# CONFIG_MAX11410 is not set
# CONFIG_MAX1241 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX34408 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3564 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_NCT7201 is not set
# CONFIG_PAC1921 is not set
# CONFIG_PAC1934 is not set
# CONFIG_ROHM_BD79124 is not set
# CONFIG_RICHTEK_RTQ6056 is not set
# CONFIG_SD_ADC_MODULATOR is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS1100 is not set
# CONFIG_TI_ADS1119 is not set
# CONFIG_TI_ADS124S08 is not set
# CONFIG_TI_ADS1298 is not set
# CONFIG_TI_ADS131E08 is not set
# CONFIG_TI_ADS7138 is not set
# CONFIG_TI_ADS7924 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_ADS8344 is not set
# CONFIG_TI_ADS8688 is not set
# CONFIG_TI_LMP92064 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_TI_TSC2046 is not set
# CONFIG_VF610_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# CONFIG_AD74115 is not set
# CONFIG_AD74413R is not set
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
# CONFIG_IIO_RESCALE is not set
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# CONFIG_ADA4250 is not set
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Chemical Sensors
#
# CONFIG_AOSONG_AGS02MA is not set
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_ENS160 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
# CONFIG_SCD4X is not set
# CONFIG_SEN0322 is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SENSIRION_SGP40 is not set
# CONFIG_SPS30_I2C is not set
# CONFIG_SENSEAIR_SUNRISE_CO2 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD3530R is not set
# CONFIG_AD3552R_HS is not set
# CONFIG_AD3552R is not set
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD9739A is not set
# CONFIG_LTC2688 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5766 is not set
# CONFIG_AD5770R is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7293 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8460 is not set
# CONFIG_AD8801 is not set
# CONFIG_BD79703 is not set
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_LTC2664 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MAX5522 is not set
# CONFIG_MAX5821 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4728 is not set
# CONFIG_MCP4821 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# CONFIG_VF610_DAC is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Filters
#
# CONFIG_ADMV8818 is not set
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# CONFIG_ADF4377 is not set
# CONFIG_ADMFM2000 is not set
# CONFIG_ADMV1013 is not set
# CONFIG_ADMV1014 is not set
# CONFIG_ADMV4420 is not set
# CONFIG_ADRF6780 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS290 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_ENS210 is not set
# CONFIG_HDC100X is not set
# CONFIG_HDC2010 is not set
# CONFIG_HDC3020 is not set
CONFIG_HID_SENSOR_HUMIDITY=m
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16475 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_ADIS16550 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_BMI270_I2C is not set
# CONFIG_BMI270_SPI is not set
# CONFIG_BMI323_I2C is not set
# CONFIG_BMI323_SPI is not set
# CONFIG_BOSCH_BNO055_I2C is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
# CONFIG_INV_ICM42600_SPI is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_SMI240 is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3000A is not set
# CONFIG_AL3010 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9160 is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9306 is not set
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1745 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM3605 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
# CONFIG_ISL76682 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_ROHM_BU27034 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR390 is not set
# CONFIG_LTR501 is not set
# CONFIG_LTRF216A is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_OPT4001 is not set
# CONFIG_OPT4060 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2591 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML3235 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6040 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VEML6075 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8974 is not set
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_ALS31300 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# CONFIG_SI7210 is not set
# CONFIG_TI_TMAG5273 is not set
# CONFIG_YAMAHA_YAS530 is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# CONFIG_HID_SENSOR_CUSTOM_INTEL_HINGE is not set
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5110 is not set
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# CONFIG_X9250 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_ROHM_BM1390 is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_HSC030PA is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MPRLS0025PA is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_SDP500 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_HX9023S is not set
# CONFIG_IRSD200 is not set
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9310 is not set
# CONFIG_SX9324 is not set
# CONFIG_SX9360 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
# CONFIG_VL53L0X_I2C is not set
# CONFIG_AW96103 is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
CONFIG_HID_SENSOR_TEMP=m
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_MLX90635 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TMP117 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX30208 is not set
# CONFIG_MAX31856 is not set
# CONFIG_MAX31865 is not set
# CONFIG_MCP9600 is not set
# end of Temperature sensors

CONFIG_NTB=m
CONFIG_NTB_MSI=y
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
CONFIG_NTB_INTEL=m
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
CONFIG_NTB_PINGPONG=m
CONFIG_NTB_TOOL=m
CONFIG_NTB_PERF=m
CONFIG_NTB_MSI_TEST=m
CONFIG_NTB_TRANSPORT=m
CONFIG_PWM=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_CLK is not set
# CONFIG_PWM_DWC is not set
# CONFIG_PWM_GPIO is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_GPIO is not set
# CONFIG_RESET_SIMPLE is not set
# CONFIG_RESET_TI_SYSCON is not set
# CONFIG_RESET_TI_TPS380X is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
CONFIG_INTEL_RAPL_TPMI=m
CONFIG_IDLE_INJECT=y
# CONFIG_MCB is not set

#
# Performance monitor support
#
# CONFIG_DWC_PCIE_PMU is not set
# CONFIG_CXL_PMU is not set
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
CONFIG_AMD_ATL=m
CONFIG_AMD_ATL_PRM=y
CONFIG_RAS_FMPM=m
CONFIG_USB4=y
# CONFIG_USB4_DEBUGFS_WRITE is not set
# CONFIG_USB4_DMA_TEST is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
# CONFIG_NVDIMM_SECURITY_TEST is not set
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_HMEM=m
CONFIG_DEV_DAX_CXL=m
CONFIG_DEV_DAX_HMEM_DEVICES=y
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_LAYOUTS is not set
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_PROTO_BASIC=m
CONFIG_STM_PROTO_SYS_T=m
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
CONFIG_TEE=m
# CONFIG_AMDTEE is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
CONFIG_COUNTER=m
CONFIG_INTEL_QEP=m
# CONFIG_INTERRUPT_CNT is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
CONFIG_DPLL=y
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
CONFIG_FS_STACK=y
CONFIG_BUFFER_HEAD=y
CONFIG_LEGACY_DIRECT_IO=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_SUPPORT_ASCII_CI=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DRAIN_INTENTS=y
CONFIG_XFS_LIVE_HOOKS=y
CONFIG_XFS_MEMORY_BUFS=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_SCRUB_STATS=y
# CONFIG_XFS_ONLINE_REPAIR is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_EXPERIMENTAL is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
# CONFIG_BCACHEFS_FS is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FS_VERITY=y
# CONFIG_FS_VERITY_BUILTIN_SIGNATURES is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_VIRTIO_FS=m
CONFIG_FUSE_DAX=y
CONFIG_FUSE_PASSTHROUGH=y
CONFIG_FUSE_IO_URING=y
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set
# CONFIG_OVERLAY_FS_DEBUG is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
# CONFIG_NETFS_DEBUG is not set
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# CONFIG_CACHEFILES_ONDEMAND is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
CONFIG_EXFAT_FS=m
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
# CONFIG_NTFS3_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_TMPFS_INODE64=y
# CONFIG_TMPFS_QUOTA is not set
CONFIG_HUGETLBFS=y
# CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_CHOICE_DECOMP_BY_MOUNT is not set
CONFIG_SQUASHFS_COMPILE_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_COMPILE_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_COMP_CACHE_FULL is not set
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_ZSTD=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_RESCTRL_FS=y
CONFIG_RESCTRL_FS_PSEUDO_LOCK=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_COMPRESS=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_PMSG is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_UFS_FS is not set
CONFIG_EROFS_FS=m
# CONFIG_EROFS_FS_DEBUG is not set
CONFIG_EROFS_FS_XATTR=y
CONFIG_EROFS_FS_POSIX_ACL=y
CONFIG_EROFS_FS_SECURITY=y
CONFIG_EROFS_FS_BACKED_BY_FILE=y
# CONFIG_EROFS_FS_ZIP is not set
# CONFIG_EROFS_FS_ONDEMAND is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V2 is not set
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_2_INTER_SSC=y
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_LEGACY_CLIENT_TRACKING is not set
# CONFIG_NFSD_V4_DELEG_TIMESTAMPS is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
# CONFIG_NFS_LOCALIO is not set
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA1=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_CAMELLIA=y
CONFIG_RPCSEC_GSS_KRB5_ENCTYPES_AES_SHA2=y
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
CONFIG_CEPH_FSCACHE=y
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CEPH_FS_SECURITY_LABEL=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
CONFIG_CIFS_SMB_DIRECT=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CIFS_COMPRESSION is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS=m
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
# CONFIG_AFS_DEBUG_CURSOR is not set
CONFIG_9P_FS=y
# CONFIG_9P_FSCACHE is not set
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_NLS_UCS2_UTILS=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_HAVE_TRUSTED_KEYS=y
CONFIG_TRUSTED_KEYS_TPM=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_PROC_MEM_ALWAYS_FORCE=y
# CONFIG_PROC_MEM_FORCE_PTRACE is not set
# CONFIG_PROC_MEM_NO_FORCE is not set
CONFIG_SECURITY=y
CONFIG_HAS_SECURITY_AUDIT=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_INFINIBAND=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SELINUX_DEBUG is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
CONFIG_SECURITY_LOCKDOWN_LSM=y
CONFIG_SECURITY_LOCKDOWN_LSM_EARLY=y
CONFIG_LOCK_DOWN_KERNEL_FORCE_NONE=y
# CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY is not set
# CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY is not set
# CONFIG_SECURITY_LANDLOCK is not set
# CONFIG_SECURITY_IPE is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
CONFIG_INTEGRITY_PLATFORM_KEYRING=y
CONFIG_INTEGRITY_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING=y
CONFIG_INTEGRITY_CA_MACHINE_KEYRING_MAX=y
CONFIG_LOAD_UEFI_KEYS=y
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
# CONFIG_IMA_KEXEC is not set
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_APPRAISE_MODSIG=y
CONFIG_IMA_KEYRINGS_PERMIT_SIGNED_BY_BUILTIN_OR_SECONDARY=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,integrity,selinux,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_STACK_ALL_PATTERN is not set
# CONFIG_INIT_STACK_ALL_ZERO is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

#
# Bounds checking
#
CONFIG_FORTIFY_SOURCE=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_DEFAULT_ON=y
# end of Bounds checking

#
# Hardening of kernel data structures
#
CONFIG_LIST_HARDENED=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Hardening of kernel data structures

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SIG=y
CONFIG_CRYPTO_SIG2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_HKDF=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_SELFTESTS is not set
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_KRB5ENC=m
# CONFIG_CRYPTO_BENCHMARK is not set
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
# CONFIG_CRYPTO_ECRDSA is not set
CONFIG_CRYPTO_CURVE25519=m
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SM4=m
CONFIG_CRYPTO_SM4_GENERIC=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_NHPOLY1305=m
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
# CONFIG_CRYPTO_AEGIS128 is not set
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_GENIV=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_ESSIV=m
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=m
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3_GENERIC=m
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_XXHASH=m
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=m
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=m
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKS=64
CONFIG_CRYPTO_JITTERENTROPY_MEMORY_BLOCKSIZE=32
CONFIG_CRYPTO_JITTERENTROPY_OSR=1
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
# CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
CONFIG_CRYPTO_CURVE25519_X86=m
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m
# CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_ARIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_ARIA_GFNI_AVX512_X86_64 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_NHPOLY1305_SSE2=m
CONFIG_CRYPTO_NHPOLY1305_AVX2=m
# CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_4XXX=m
# CONFIG_CRYPTO_DEV_QAT_420XX is not set
# CONFIG_CRYPTO_DEV_QAT_6XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_QAT_ERROR_INJECTION is not set
CONFIG_CRYPTO_DEV_IAA_CRYPTO=m
# CONFIG_CRYPTO_DEV_IAA_CRYPTO_STATS is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_FIPS_SIGNATURE_SELFTEST=y
CONFIG_FIPS_SIGNATURE_SELFTEST_RSA=y
CONFIG_FIPS_SIGNATURE_SELFTEST_ECDSA=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SECONDARY_TRUSTED_KEYRING_SIGNED_BY_BUILTIN is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# CONFIG_SYSTEM_BLACKLIST_AUTH_UPDATE is not set
# end of Certificates for signature checking

CONFIG_CRYPTO_KRB5=m
# CONFIG_CRYPTO_KRB5_SELFTESTS is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
# CONFIG_RAID6_PQ_BENCHMARK is not set
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_AESCFB=y
CONFIG_CRYPTO_LIB_AESGCM=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_GF128MUL=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=m
CONFIG_CRYPTO_LIB_CURVE25519_INTERNAL=m
CONFIG_CRYPTO_LIB_CURVE25519=m
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256_SIMD=y
CONFIG_CRYPTO_LIB_SHA256_GENERIC=y
CONFIG_CRYPTO_LIB_SM3=m
CONFIG_CRYPTO_BLAKE2S_X86=y
CONFIG_CRYPTO_CHACHA20_X86_64=y
CONFIG_CRYPTO_POLY1305_X86_64=y
CONFIG_CRYPTO_SHA256_X86_64=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_ARCH_HAS_CRC_T10DIF=y
CONFIG_CRC_T10DIF_ARCH=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_ARCH_HAS_CRC32=y
CONFIG_CRC32_ARCH=y
CONFIG_CRC64=y
CONFIG_ARCH_HAS_CRC64=y
CONFIG_CRC64_ARCH=y
CONFIG_CRC8=m
CONFIG_CRC_OPTIMIZATIONS=y
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_ARM64=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_RISCV=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_INTERVAL_TREE_SPAN_ITER=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS_HELPERS=y
CONFIG_NEED_SG_DMA_FLAGS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
# CONFIG_SWIOTLB_DYNAMIC is not set
CONFIG_DMA_NEED_SYNC=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_NUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_GENERIC_VDSO_OVERFLOW_PROTECT=y
CONFIG_VDSO_GETRANDOM=y
CONFIG_GENERIC_VDSO_DATA_STORE=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_STACKDEPOT_MAX_FRAMES=64
CONFIG_SBITMAP=y
CONFIG_PARMAN=m
CONFIG_OBJAGG=m
# CONFIG_LWQ_TEST is not set
# end of Library routines

CONFIG_PLDMFW=y
CONFIG_ASN1_ENCODER=y
CONFIG_POLYNOMIAL=m
CONFIG_FIRMWARE_TABLE=y
CONFIG_UNION_FIND=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_ULEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_INFO_COMPRESSED_NONE=y
# CONFIG_DEBUG_INFO_COMPRESSED_ZLIB is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_LANG_EXCLUDE=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_OBJTOOL=y
# CONFIG_OBJTOOL_WERROR is not set
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# CONFIG_DEBUG_NET_SMALL_RTNL is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_RCU_DEBUG=y
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
CONFIG_PAGE_POISONING=y
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
CONFIG_DEBUG_WX=y
CONFIG_ARCH_HAS_PTDUMP=y
CONFIG_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_PER_VMA_LOCK_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VFS is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_MEM_ALLOC_PROFILING is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_EXTRA_INFO is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
CONFIG_HAVE_ARCH_KMSAN=y
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_SOFTLOCKUP_DETECTOR_INTR_STORM is not set
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_HAVE_HARDLOCKUP_DETECTOR_BUDDY=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_HARDLOCKUP_DETECTOR_PREFER_BUDDY is not set
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
# CONFIG_HARDLOCKUP_DETECTOR_BUDDY is not set
# CONFIG_HARDLOCKUP_DETECTOR_ARCH is not set
CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_DETECT_HUNG_TASK_BLOCKER=y
CONFIG_WQ_WATCHDOG=y
# CONFIG_WQ_CPU_INTENSIVE_REPORT is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

# CONFIG_NMI_CHECK_CPU is not set
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
# CONFIG_RCU_SCALE_TEST is not set
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST_CHK_RDR_STATE is not set
# CONFIG_RCU_TORTURE_TEST_LOG_CPU is not set
# CONFIG_RCU_TORTURE_TEST_LOG_GP is not set
CONFIG_RCU_REF_SCALE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
# CONFIG_RCU_CPU_STALL_CPUTIME is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_CGROUP_REF is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FREGS=y
CONFIG_HAVE_FTRACE_GRAPH_FUNC=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_REGS_HAVING_PT_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_OBJTOOL_NOP_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BOOTTIME_TRACING=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_FUNCTION_GRAPH_RETVAL is not set
# CONFIG_FUNCTION_GRAPH_RETADDR is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_FPROBE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_OSNOISE_TRACER=y
CONFIG_TIMERLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_FPROBE_EVENTS=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
# CONFIG_USER_EVENTS is not set
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_VALIDATE_RCU_IS_WATCHING is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_DA_MON_EVENTS=y
CONFIG_DA_MON_EVENTS_ID=y
CONFIG_RV=y
CONFIG_RV_MON_WWNR=y
# CONFIG_RV_MON_SCHED is not set
CONFIG_RV_REACTORS=y
CONFIG_RV_REACT_PRINTK=y
CONFIG_RV_REACT_PANIC=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
# CONFIG_KCOV is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

CONFIG_IO_URING_ZCRX=y

--HSMJNboiLersl0nZ
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--HSMJNboiLersl0nZ--

