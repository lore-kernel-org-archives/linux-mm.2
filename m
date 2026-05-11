Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C19CCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CC96B00A4; Mon, 11 May 2026 10:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20426B00B8; Mon, 11 May 2026 10:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F7A6B00C9; Mon, 11 May 2026 10:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD0936B00A4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:45:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78697C04E6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:45:30 +0000 (UTC)
X-FDA: 84755412420.12.CA320E6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8AA7340012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:45:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cVyTlamM;
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tNzcUBk+Frkae5GoXl/jaE50XeMXNhApbPrGOpZ9JOQ=;
	b=bM0hW+DGog5FEhIz/yreYsApf6qsofPDLz4yRnrniVVK3kPAy1yn18bmfImDX9v3xAXo10
	DsWz5bsI1jysPWydYqr/BoSLzW1GvhT4A8GCRG+3DVN20fhsl/y6cJWeB0vP7AGk4ULa6C
	s85y28kqezvGgLTGmMr2JKab4Sln8i0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778510727; a=rsa-sha256;
	cv=fail;
	b=yOYeNfedVbKuptLFUyku2SMhHFdDcy2oIU0YfhhZBwIDPfGWVz5B9u3PNs5eZTEvnr1aC+
	gpz2L0HMJBitvTgeBhZZH8sJMVvhRtM42gZ6T/OF+ORIFd/2gMZL32+GHwBAvKEtib0UVm
	W0Eaijbf3Wmep8hfCUT3BLISi1lgBqU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cVyTlamM;
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778510727; x=1810046727;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=XsRY4dCWKTGLsysOI3eteLieAiEe8PGpUmIzXySUOo4=;
  b=cVyTlamMPSd+iQ2fpLI+dWcpeuhCiCt1bQ+saotMwYnNxlO+QcMzegP6
   JNJ9ULkWKtbUgcK9oVRvmFDzqoLaeneolpiqDhlT3KiXCama00ztrf+ed
   KhhUnxPReiyuyQaVvLTZ3GuQY8OoPI4YfiRLpujcUGkrkTgpqr2IBNivS
   E8ZPchoSOyWz1MQzwMT5Jtp4IhlhvAjmrCe9O3HNzGKhHHrVFFfUfsTsv
   norq1DxKpyvnz33i/16YxMmT9ysvL4h7H4dkeaTrwkxWo0m2tXRS47DSt
   +h1FdZZVHuSuEYyXEXlpyZDkY0ySFKqDjb5McksGLkSBsB4I5G7CgZo/g
   w==;
X-CSE-ConnectionGUID: XYT7qlULTvaVGROMAfYBZQ==
X-CSE-MsgGUID: ru9QR1yUQMulthoAVoMnCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="79381871"
X-IronPort-AV: E=Sophos;i="6.23,229,1770624000"; 
   d="scan'208";a="79381871"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 07:45:25 -0700
X-CSE-ConnectionGUID: 2BtLcAvIS7GQ+U9JEh4EYQ==
X-CSE-MsgGUID: LaBcOFx5S4G48Hz6lciKhA==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 07:45:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 07:45:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 11 May 2026 07:45:23 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 07:45:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRGC+6BkkKOrFyfkgFjnEzLMP0bo3J37RxJSDeIML+SC79N9pGNaZ30MvePIrpD4EP1bm+ooNkrXbQq1jUm13NEQ7m+eOZLm6DSPWfORTd0L+U7GUjQCMOVmJszFFF/epeaNl1sLIVzjOF0yMbrMcjHWduS3dWkW7od7CqHGdNI7xk9vQtTc5jCwOvChhaz5HMvScaUGNm7qbrsKNfGc+XAnKqy+bIoWKPJ3TYlQZ9CvIDAENHp53uXbVrj/LFTFM5LeYkm6o0EAbX1+/XOEj2qaZ5umy1hoH4gDtLAHquVOIW/ljFAh3UYmqw/gwx69DfOdmZlTY1ln5YpmctNN1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e0NSxd5g9Dpjc1WH8Uk9lqCYgUvi9Yk5tukS+QtiTb0=;
 b=TSqxYBah0IquQNNksXeKvKgSboTHEmqgGvBrMLdRxxNqR6evj79RG4QF4qP7C+ZNueIz0k/1J4VeOwF/+oKliTGTRZyPtqDqt7K4gt7F9yLjzWUT38tuYtwRCN1c97Jj3MBVhrvS7v3IcJ7B4xUPwyhpELlRUiMcm/P5iPqrJn2vqPh0ItC7FlOJbF3jYVm0xhb2Sm99OM4xa43AVEKo+KkAM5JtTNydbdkM446sC3TTa9NhFQ4sihzROeFMlZq9SshprplOc/WUBu+68qauaa3i3Cr6lpH88Xl9Nr7SMxS1Xx3I36FOyPYnWk7wi57c1685OxA6mYj0ragueJ0xkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by SA3PR11MB8117.namprd11.prod.outlook.com (2603:10b6:806:2f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Mon, 11 May
 2026 14:45:20 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9891.019; Mon, 11 May 2026
 14:45:20 +0000
Date: Mon, 11 May 2026 22:45:12 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Hao Li <hao.li@linux.dev>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm, slab]  298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Message-ID: <202605112204.9382cecf-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|SA3PR11MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba67f10-83c2-4731-54bb-08deaf6bec94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|3023799003|11063799003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: hRLdzEmrFkXZcLLy3txntDy9qdidU9Z7YE0MKL4y/izkVnQM6oOeXJki8RUFLZcffQSIF/+bGU/vMPMxQhbGTTHZ8vIazTDFBDjMZGRWNDDvPaO6abSkprWB1wXQgsQoy9GG2XJM0iN7WLMesN4UnjJeaFyMFjKol362WMZpVI4XU/g7najF78ndMm15ovHDD0lZDDtsqRHPZSTyACBmgVdkym+/YCMbBQjScNuJgl9V5+E9a5Pb/vLs4uYgZ3S3n+qMGv2qZ3G2jyVFAryBtJ9glnPe+yQHEYixioCL1FBXe7O/esM7Bmv9R2Lt4xshyVOT0l0WFHrIuqRokdNgSmKDS+BVdYI1YbG27i7ve9C8VpQdbYNXpQZdrEBLwiiPNJEBscr3WH1WvQsGx7hEuu9odBPa8VAMwC2Q6RZY5+vzUISFnIcU+6VObeZ2XQOKCXQburtmXXbWHsUxfB0KAzNMgEvtNkQEpB6evQzLIfcNM1rVaik3RRtUfCQJMXzxqu9a/tHxr8ZG6YU+CZq47mRmfbFMvS0r5Y7atYH4jmkcE+OpUPtYBtROU/QKh/J3kviPePX6Q452KkYhllJ5mm7J8vgeausmQ7nZfxpP8r/Vmhqsr6FAFwOQXnVoD2O1TZl1Ytz2IqiIkXxd4HR1RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(3023799003)(11063799003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?q82VrwstZZ0IhnGdm4QBBncBGa6unMhGPKDuFlwspuPmqmv8Xs0euZUakH?=
 =?iso-8859-1?Q?g8spua/IsZ45I6FkzmyRQ7S+UUSgVe7LLC+OtJUcduWM0j0IfB17QfnK6I?=
 =?iso-8859-1?Q?GMop8Ccnr6CG/o1UyPmVUA/ueltAvlTxKAvhJyDFtScX8vXvqOy3XbhWlf?=
 =?iso-8859-1?Q?zvFHE4b1g+P3V8TMfp4/9QhNGHFwlkWu9dkIiH8HIhVtUr6Rz+fHkQ0eEN?=
 =?iso-8859-1?Q?MLt7NDpGQUHzBCsylSsUYH4beKNwyUvUzbRVf9E6mgO/80HvP+LVd8OLJX?=
 =?iso-8859-1?Q?49CVEAl6SLVlraj7m5XxHVUiEC3ucxKk7CJM91t0o4YvXQATBFnpAsW/Wa?=
 =?iso-8859-1?Q?HLmDZuJ3ex8lWcEqcV/P75+KfJBaKg3ypoGFHTtDG3ASr4hXqZDuLFNfrp?=
 =?iso-8859-1?Q?ZsW1CdRFHB4RWfR4N3ZXIH4O4l8v4MazEjg2P9dMIYFEbEX1dU1iulFMR3?=
 =?iso-8859-1?Q?xM2q35DnksIPDMMU2RfJiiw/ahhqsfXnI+kJ9bxUR2/mBdRb1kZ8XIgURZ?=
 =?iso-8859-1?Q?EZIoL1n2+AAAgTM/m2ZYpiozvHfhUye9APvKPpq0qRrA0rE0rOk0ARrZ8r?=
 =?iso-8859-1?Q?KgfmGFEO51oeFzeRTg+xMEIblggTL51zpr+3TxnLe7Zr11SAT3TxJ6l7dx?=
 =?iso-8859-1?Q?bcr7HXYqhPfQiDII6TJV2Owlc7E3QE3Mj4uaEEgSibkcbMPN5QcJvHi66T?=
 =?iso-8859-1?Q?pH/2Ek7qJmL6KoPJE/Z6yoi1KuL4E+PAhNEzntC4wiPd2edabK62EbBZLw?=
 =?iso-8859-1?Q?871G79nCxDjiVo0KhItg1xsV9iLOGNXhOGCnrbFJT2+LomNRJ9YieLrlRv?=
 =?iso-8859-1?Q?Ih3McU0qLMm0bTePNB5UttDQnAIPTZdhvdRxzp6gmsAlg+d0fRkJsqow/b?=
 =?iso-8859-1?Q?z9ZzvNXiXY2UPEHQ2kwh0+kxIDtSntnzE59Ub2FmBSmr3gamskf4GhkHi5?=
 =?iso-8859-1?Q?PH5+/PoXPRQAuYaY67FxTDv9y11v7/wwhil1c1gAAhtldd3U4d+mDRN7/1?=
 =?iso-8859-1?Q?punaARwKb8gPRRA+1GgNX9sL+BwkEoHV2BluTGj3/48TOeFqkPElvoawdW?=
 =?iso-8859-1?Q?nY5G40N04CsOkkUi58q4fA5EaTCmTYj8zAKf6TueTM+ojpzkXaVcuFcVgF?=
 =?iso-8859-1?Q?w4KcZAN0gDn2Vx0GbMDADrvsqZaIqmplZhM050ap8KL0NMcd6tAAWzsJgS?=
 =?iso-8859-1?Q?UBEXYT1vo3T8eFxUjVKdOz8KIOEjgKf0+wP8oa65V2K03JZnK5w3AUBEGn?=
 =?iso-8859-1?Q?rb2Qu/Dpj6Xjpe7AcDhbNFJWUCZ4FnHabfdiR6msHHIH+DfNoVFWUsGPIX?=
 =?iso-8859-1?Q?LVPIXiW6pGdAAx04A3oo4ljRq23Crh3c8XjXdnmGEEdR+r0c1ZM3dd7UVM?=
 =?iso-8859-1?Q?Ls4ogKKDHapgaFVKDIIPh91Ehp19SsP612bp+LE7RbQo7leaLnwUliTYLh?=
 =?iso-8859-1?Q?wHZwAfGw7GXRiXp83Is0ToVtMf2gWXphOg4KX7ok76Tw3sjHPBFfeWgCBW?=
 =?iso-8859-1?Q?xe4Iwj+rqo9lKHl8Nb/lzapDbYYs+P+r91CMCeZ5N2kZLuAFrkaG1P9h0Y?=
 =?iso-8859-1?Q?yDs/oInN+PDEqpnebj+1RuuGPddcA8zSnGxLRmQFXpBoxUuqr0jM2NjA0b?=
 =?iso-8859-1?Q?5OQbsAG+xQik7Cl+ddvrdChMpemrxuqqoQ5w142aN8LCaZjtjt73Dtf2kP?=
 =?iso-8859-1?Q?gn6VZghTAhhVDdkCMeyDMugIB0GGYJfbEm8ANERqrokbYUtg/ITwaSaNPE?=
 =?iso-8859-1?Q?37MubAoCOWrK9jelqE0Z1NfWhSzma+pB6+KCgLNjAuzSWV+Kxim2VNgjct?=
 =?iso-8859-1?Q?+57xlR01Nw=3D=3D?=
X-Exchange-RoutingPolicyChecked: S6elpZ4Z3sbfzcBtgId+WOcKu7dacvonRLeNsxsDG3LAqQ0hWnNh6sp1DY9I0Ucn6GWEo9X9zSyj+hwLmlJXWl9bDOuUBhtQUpAFLGCe1SlNI1lJsbkKFww6vKV2gEKNF2QpX94LujIFzdZ2Wqo8o8JLWdCoHBLCgs6nAFYMqQlrn7M6mN8b+se/TIVB8+9a0cG9Rn1UVWgc+OH0pdHHeT8tmzwStmCPa68UmCT76QM2n/1ei8JnuTmZRTsO8EMsuQBOkmqKCFnuP0EhzLRXvjLXKT/Kf179rW4H1y3a709captHMrjKHSqqyqoQe72RST3poNea7/k83G5LD/gtuQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba67f10-83c2-4731-54bb-08deaf6bec94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2026 14:45:20.3171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: It6P9o0iBTQLDY5QClGDPM9+A2iAQJeZK0nYQhbZVv1j7/T0d+RWPPt0asE2QuwicBWHQRk6kGyQH5YGE3FTvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8117
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AA7340012
X-Rspam-User: 
X-Stat-Signature: hnndy97m5zt8jh1n4t4b31ewwz5e5ha9
X-HE-Tag: 1778510726-333845
X-HE-Meta: U2FsdGVkX19twCQ3aLJ19ICeNva+kV+yqErKuVfb/EJS2CWgXiNE6Zwn3G8hi+1W1ePRm/cWJY8D/14PYat3bnDA1UUF4Nd46XwU13evuiKKgEEaEE4QZe3iZDk1Qk3jPbFSIbjS4Mk+gMIQ/LVPwIvKlYxkSPVz7ApMtuUQvH97wu4nXDTwb+xcIDhFNT9pxk9eAKTsnOZ+RJY4VJ/VyH0VEKmbPwyk39UMS+vzcQkazd+1qDcrneo09myEKkFc+Kih2NR3FWk2sWzmE4XVvJTBmtpij0yAlOC+Sv7L1uKKAE1XIyq17CP9sR7qzR2YdE++Ooc+dp2u+Q1SklJlszQbOe4kcSEcwn61oX6VzoFMCn+O52ITIMQ/SES5bhbOAXmIcasQE/fTjablXQF9YtqGHQnNT6d2iKTmCHl4UgQJpgJAzdL+01yfvKCaQlztZ2EaqoQQtHKoWXoOLF7KRVmXMIKyykT7DCrCJdt0eDe8A1Zx4HguytogbCxW0rTorDPdSAj/KMBqBhErmz3GXVD3zrK+n3uKcMPqOFGaorJ108R/KA0JJrOeQIZgVkLzzEeDJroBdMDY9+7G/HOyoN45ssdMjfxz5GWq+rni8B0KTxGa7LMTP/C1ArWRYPWTatrw38o14cCp5Dv64iHrY39lAXO4fUpBU1OEkLLPxlBCVIaoM+7s5VvTMJDTQ8de3RVlzf0V4fe2ikXm5pfAMJQfWKZBUfY+/VxnOtHxmaWoPTO4Rq6NKeQF0KCjUjRWZEVaUwBmQtlNo6grjsK03X/DNoagAUxVeylUFRZYx5N4b3M5hQRDImuGd4iCHspMRBkfKQVpY6k6QBuPJCkSUGhVr0ZqKSM60wH18ku6/0+ujLEIzatAgI7m0TsCNNQ3dSVxLqukpEVGBaPB4fcOxCbSTuXwURYozzi8GP1E7YziQ7XCu6ToYPQrmOnMXme0kRfAPiiB+n6+G5IndSV
 hxD33DZc
 G+5xoIrodbrbx/oEhRLZBr8pAyudYiAh6d2/fSYVRLtSy0Mdlo9azfZpHoZEAL5GkberajrlpwiKQndtCEJEBEOTrMaGD+LMR9lHIo33H0SYKBP9hbpiCw1h2zk4PPsJw/KodlmEHegb4PBJLAlhA4RKBohZ8NquJGyRKj+9zmH7sq92A8jEK95BpaoO/0WPnubZaUA01GYylzHGoqm9IA3ExlqksOe0Q0BsRlbxlvd9UK2NZwuVxB0zZiJOhFOrpEXYBWsvjFonyp4KYVFKSa+j3JwFfnxC1l7Xzli60i0AHx1w1GdqGuM+ftbxE9FM+b2E6/+lvVfW2Rg6kP/842CMwY8qS4oaRSPYF5Mj09jmxx7yTTI4ksZt7J6RUIZx/G86TLGIeA3gLqutfHGCEls/MRcJx+ioDYKQ0UWS7wRLLTrYLerVT/SwEZTB75AbSZJvtCaRFVn9Gjwi4MuAOn8yjzafBUJw065YSfGDG9n8f1x5LvlqvwAGY1DL122yI00+JaRh3YKP3sj7WjXRa1Dee5pqTT8W9uHF1KcLbfHjjxkqw5cLtfDpPfdM1EuNyhymy5KEzSNV4vkz/uVu574GWot611QFNIeEhSgIvS8lmegaRBbIGt/1sZtuKZfNTli0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:


commit: 298cdbf5f7c9e19289f46710ed5ab3da4e711150 ("mm, slab: add an optimistic __slab_try_return_freelist()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master 4cd074ae20bbcc293bbbce9163abe99d68ae6ae0]

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap1
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202605112204.9382cecf-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260511/202605112204.9382cecf-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit: 
  1f7c8e1d52 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
  298cdbf5f7 ("mm, slab: add an optimistic __slab_try_return_freelist()")

1f7c8e1d52428cbf 298cdbf5f7c9e19289f46710ed5 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  35417967            -6.3%   33202379        will-it-scale.192.processes
    184468            -6.3%     172928        will-it-scale.per_process_ops
  35417967            -6.3%   33202379        will-it-scale.workload
     21873 ±  2%      +8.0%      23628        vmstat.system.cs
      3957 ± 19%     -64.8%       1392 ± 13%  perf-c2c.DRAM.local
      1016 ± 20%     -46.9%     540.33 ± 34%  perf-c2c.DRAM.remote
      0.71            -5.6%       0.67        turbostat.IPC
    430.37            -1.2%     425.33        turbostat.PkgWatt
      0.13            -0.0        0.12        mpstat.cpu.all.irq%
     18.38            +1.4       19.79        mpstat.cpu.all.soft%
      1.64            -0.1        1.54        mpstat.cpu.all.usr%
      7.06 ± 14%     +26.0%       8.89 ± 12%  sched_debug.cfs_rq:/.load_avg.min
     18788 ±  2%      +7.2%      20147        sched_debug.cpu.nr_switches.avg
     16273 ±  3%      +7.6%      17503        sched_debug.cpu.nr_switches.min
   3418653           +97.9%    6765264        numa-numastat.node0.local_node
   3479092           +96.6%    6839697        numa-numastat.node0.numa_hit
   4424809 ±  2%     +79.1%    7922798 ±  2%  numa-numastat.node1.local_node
   4564748 ±  2%     +76.3%    8048580 ±  2%  numa-numastat.node1.numa_hit
   3478940           +96.6%    6839185        numa-vmstat.node0.numa_hit
   3418501           +97.9%    6764752        numa-vmstat.node0.numa_local
   4565277 ±  2%     +76.3%    8048347 ±  2%  numa-vmstat.node1.numa_hit
   4425338 ±  2%     +79.0%    7922564 ±  2%  numa-vmstat.node1.numa_local
    189874            -2.4%     185345        proc-vmstat.nr_slab_unreclaimable
   8051058           +85.0%   14892463        proc-vmstat.numa_hit
   7850680           +87.1%   14692248        proc-vmstat.numa_local
  25073981          +109.6%   52554060        proc-vmstat.pgalloc_normal
  23597828          +116.6%   51111380        proc-vmstat.pgfree
      0.20            +8.9%       0.22 ±  2%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.20            +8.9%       0.22 ±  2%  perf-sched.total_sch_delay.average.ms
     26.54 ±  2%     -12.1%      23.32 ±  2%  perf-sched.total_wait_and_delay.average.ms
    108336 ±  3%      +9.0%     118099        perf-sched.total_wait_and_delay.count.ms
     26.34 ±  2%     -12.3%      23.11 ±  2%  perf-sched.total_wait_time.average.ms
     26.54 ±  2%     -12.1%      23.32 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    108336 ±  3%      +9.0%     118099        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     26.34 ±  2%     -12.3%      23.11 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
 9.213e+10            -5.7%  8.687e+10        perf-stat.i.branch-instructions
 1.098e+08            -6.7%  1.025e+08        perf-stat.i.branch-misses
     14.49 ±  2%      -1.4       13.11 ±  4%  perf-stat.i.cache-miss-rate%
 1.059e+08 ±  2%     -12.9%   92245846 ±  5%  perf-stat.i.cache-misses
 7.389e+08            -3.6%  7.123e+08        perf-stat.i.cache-references
     21981 ±  2%      +7.8%      23693        perf-stat.i.context-switches
      1.40            +6.2%       1.49        perf-stat.i.cpi
    256.41            +3.0%     263.99        perf-stat.i.cpu-migrations
      5815 ±  2%     +15.3%       6707 ±  4%  perf-stat.i.cycles-between-cache-misses
 4.341e+11            -5.8%  4.089e+11        perf-stat.i.instructions
      0.71            -5.8%       0.67        perf-stat.i.ipc
     14.34 ±  2%      -1.4       12.97 ±  4%  perf-stat.overall.cache-miss-rate%
      1.41            +6.2%       1.49        perf-stat.overall.cpi
      5764 ±  2%     +15.0%       6626 ±  4%  perf-stat.overall.cycles-between-cache-misses
      0.71            -5.9%       0.67        perf-stat.overall.ipc
 9.183e+10            -5.7%  8.659e+10        perf-stat.ps.branch-instructions
 1.095e+08            -6.7%  1.021e+08        perf-stat.ps.branch-misses
 1.056e+08 ±  2%     -12.8%   92081686 ±  5%  perf-stat.ps.cache-misses
 7.367e+08            -3.6%  7.102e+08        perf-stat.ps.cache-references
     21840 ±  2%      +8.1%      23604        perf-stat.ps.context-switches
    253.30            +3.0%     260.93        perf-stat.ps.cpu-migrations
 4.327e+11            -5.8%  4.076e+11        perf-stat.ps.instructions
 1.312e+14            -5.9%  1.235e+14        perf-stat.total.instructions
     12.77           -12.8        0.00        perf-profile.calltrace.cycles-pp.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.68           -12.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.60           -12.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__refill_objects_node.refill_objects
      4.81            -0.5        4.28        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.52            -0.4        2.09        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      7.46            -0.4        7.06        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      5.21 ±  2%      -0.4        4.86        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      3.50            -0.3        3.19        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      3.47            -0.3        3.16        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      5.90            -0.3        5.60        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.96            -0.3        1.70        perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      2.43 ±  4%      -0.3        2.17 ±  4%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      2.25 ±  4%      -0.2        2.00 ±  4%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      1.27 ± 10%      -0.2        1.03 ±  6%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.66 ±  4%      -0.2        2.44 ±  3%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      5.57 ±  2%      -0.2        5.37        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.46 ±  8%      -0.2        1.27 ±  4%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
      1.27 ±  8%      -0.2        1.08 ±  5%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      5.06 ±  2%      -0.2        4.88        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
      2.48            -0.2        2.32        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      2.51            -0.2        2.36        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.00            -0.1        1.86        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.24            -0.1        2.11        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.89            -0.1        2.76        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.26            -0.1        2.12        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.56            -0.1        2.43        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      2.13            -0.1        2.01        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.00            -0.1        1.88        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      2.74            -0.1        2.62        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      1.94            -0.1        1.82        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.67            -0.1        1.58        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      1.44            -0.1        1.36        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      1.50            -0.1        1.42        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      1.35            -0.1        1.28        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      1.58            -0.1        1.52        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.44            -0.1        1.39        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      0.62            -0.0        0.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.61            -0.0        0.57        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      1.06            -0.0        1.03        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      0.62            -0.0        0.59        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
      0.64            -0.0        0.62 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.64            -0.0        0.62        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      0.88            +0.1        0.98        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.55 ±  5%      +0.1        0.66 ±  2%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.51            +0.1        0.64        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.52 ±  5%      +0.3        1.84 ±  2%  perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.17 ±  5%      +0.4        2.60 ±  2%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      0.00            +0.6        0.60 ±  8%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      0.00            +0.6        0.62 ±  5%  perf-profile.calltrace.cycles-pp.alloc_from_new_slab.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
     12.88            +1.0       13.87        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.83            +1.0       13.82        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
     12.88            +1.0       13.87        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.81            +1.0       13.81        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     12.82            +1.0       13.82        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
     12.87            +1.0       13.87        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
     12.81            +1.0       13.82        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     10.64            +1.3       11.92        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
     11.72            +1.6       13.30        perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
     11.63            +1.6       13.23        perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     11.33            +1.6       12.94        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
     11.20            +1.6       12.82        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     22.90           +14.2       37.13        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     22.99           +14.3       37.26        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     27.87           -10.5       17.33        perf-profile.children.cycles-pp.__slab_free
      7.27            -0.8        6.48        perf-profile.children.cycles-pp.barn_get_empty_sheaf
      5.91            -0.6        5.32        perf-profile.children.cycles-pp.barn_replace_empty_sheaf
     10.36            -0.5        9.82        perf-profile.children.cycles-pp.mas_wr_node_store
      7.58            -0.4        7.18        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      3.98            -0.4        3.61        perf-profile.children.cycles-pp.barn_put_full_sheaf
      4.70            -0.4        4.34        perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      5.91            -0.3        5.60        perf-profile.children.cycles-pp.unmap_region
      5.19            -0.3        4.90        perf-profile.children.cycles-pp.kvfree_call_rcu
     94.66            -0.3       94.41        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     94.52            -0.2       94.27        perf-profile.children.cycles-pp.do_syscall_64
      5.57 ±  2%      -0.2        5.37        perf-profile.children.cycles-pp.mas_store_prealloc
      2.06            -0.2        1.89        perf-profile.children.cycles-pp.__get_unmapped_area
      2.96            -0.2        2.80        perf-profile.children.cycles-pp.__pi_memcpy
      2.55            -0.2        2.40        perf-profile.children.cycles-pp.free_pgtables
      2.25            -0.1        2.12        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.26            -0.1        2.13        perf-profile.children.cycles-pp.free_pgd_range
      2.58            -0.1        2.44        perf-profile.children.cycles-pp.zap_pmd_range
      2.90            -0.1        2.77        perf-profile.children.cycles-pp.unmap_vmas
      2.14            -0.1        2.02        perf-profile.children.cycles-pp.free_p4d_range
      2.75            -0.1        2.63        perf-profile.children.cycles-pp.__zap_vma_range
      2.01            -0.1        1.89        perf-profile.children.cycles-pp.free_pud_range
      1.94            -0.1        1.82        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      1.69            -0.1        1.59        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.26            -0.1        1.18        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.42            -0.1        1.34        perf-profile.children.cycles-pp.mas_find
      1.38            -0.1        1.30        perf-profile.children.cycles-pp.vm_unmapped_area
      1.36            -0.1        1.28        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.98            -0.1        0.92        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      1.58            -0.1        1.52        perf-profile.children.cycles-pp.__mmap_complete
      1.46            -0.1        1.40        perf-profile.children.cycles-pp.perf_event_mmap
      0.64            -0.0        0.60        perf-profile.children.cycles-pp.mas_prev_slot
      0.54            -0.0        0.50        perf-profile.children.cycles-pp.mas_wr_store_type
      1.08            -0.0        1.04        perf-profile.children.cycles-pp.perf_event_mmap_event
      0.63            -0.0        0.59        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.54            -0.0        0.50        perf-profile.children.cycles-pp.__vma_start_write
      0.54            -0.0        0.52        perf-profile.children.cycles-pp.mas_next_slot
      0.43            -0.0        0.41        perf-profile.children.cycles-pp.mas_rev_awalk
      0.53            -0.0        0.51        perf-profile.children.cycles-pp.mas_walk
      0.64            -0.0        0.62 ±  2%  perf-profile.children.cycles-pp.kmem_cache_free
      0.36            -0.0        0.33        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.29            -0.0        0.27        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.44            -0.0        0.42        perf-profile.children.cycles-pp.vma_merge_new_range
      0.65            -0.0        0.63        perf-profile.children.cycles-pp.perf_iterate_sb
      0.24            -0.0        0.22        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      0.07 ±  5%      -0.0        0.05        perf-profile.children.cycles-pp.mmap_region
      0.14            -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.mas_prev
      0.30            -0.0        0.28        perf-profile.children.cycles-pp.up_read
      0.30            -0.0        0.29        perf-profile.children.cycles-pp.vma_set_page_prot
      0.07            -0.0        0.06 ±  9%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
      0.08 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.__alloc_empty_sheaf
      0.08 ±  6%      -0.0        0.06        perf-profile.children.cycles-pp.remove_vma
      0.24            -0.0        0.22        perf-profile.children.cycles-pp.downgrade_write
      0.20 ±  3%      -0.0        0.18 ±  2%  perf-profile.children.cycles-pp.mas_wr_walk_descend
      0.28            -0.0        0.27        perf-profile.children.cycles-pp.down_write_killable
      0.18 ±  2%      -0.0        0.17 ±  2%  perf-profile.children.cycles-pp.vma_wants_writenotify
      0.07 ±  5%      -0.0        0.06        perf-profile.children.cycles-pp.__kmalloc_noprof
      0.20            -0.0        0.19        perf-profile.children.cycles-pp.tlb_gather_mmu
      0.07            -0.0        0.06        perf-profile.children.cycles-pp.__call_rcu_common
      0.16            -0.0        0.15        perf-profile.children.cycles-pp.may_expand_vm
      0.14            -0.0        0.13        perf-profile.children.cycles-pp.up_write
      0.12            -0.0        0.11        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.15            -0.0        0.14        perf-profile.children.cycles-pp.vma_is_shared_writable
      0.11            -0.0        0.10        perf-profile.children.cycles-pp.x64_sys_call
      0.88            +0.1        0.99        perf-profile.children.cycles-pp.vm_area_alloc
      0.36            +0.1        0.50        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      2.16 ±  5%      +0.4        2.59 ±  2%  perf-profile.children.cycles-pp.run_ksoftirqd
      2.17 ±  5%      +0.4        2.60 ±  2%  perf-profile.children.cycles-pp.smpboot_thread_fn
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.kthread
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.ret_from_fork
      2.17 ±  5%      +0.4        2.61 ±  2%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.69 ±  5%      +0.5        1.22 ±  4%  perf-profile.children.cycles-pp.alloc_from_new_slab
     15.26            +1.2       16.44        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
     18.16            +1.3       19.49        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
     18.14            +1.3       19.47        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     18.02            +1.3       19.36        perf-profile.children.cycles-pp.__irq_exit_rcu
     60.59            +1.5       62.05        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     61.51            +1.6       63.10        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     20.16            +1.8       21.94        perf-profile.children.cycles-pp.rcu_core
     20.18            +1.8       21.95        perf-profile.children.cycles-pp.handle_softirqs
     20.14            +1.8       21.92        perf-profile.children.cycles-pp.rcu_do_batch
     50.97            +2.0       52.95        perf-profile.children.cycles-pp.__refill_objects_node
     15.07            +2.2       17.25        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     15.67            +2.2       17.86        perf-profile.children.cycles-pp.rcu_free_sheaf
     65.82            +2.4       68.25        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     65.33            +2.5       67.80        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     51.67            +2.5       54.18        perf-profile.children.cycles-pp.refill_objects
      2.16            -0.5        1.66        perf-profile.self.cycles-pp.__refill_objects_node
      2.64            -0.2        2.48        perf-profile.self.cycles-pp.__pi_memcpy
      2.36            -0.1        2.22        perf-profile.self.cycles-pp.zap_pmd_range
      1.84            -0.1        1.71        perf-profile.self.cycles-pp.free_pud_range
      1.78            -0.1        1.66        perf-profile.self.cycles-pp.__mmap_region
      0.52            -0.1        0.40        perf-profile.self.cycles-pp.__slab_free
      1.44            -0.1        1.34        perf-profile.self.cycles-pp.mas_wr_node_store
      0.98            -0.1        0.92        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.84            -0.1        0.78        perf-profile.self.cycles-pp.mas_store_gfp
      0.55            -0.0        0.50        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.58            -0.0        0.54        perf-profile.self.cycles-pp.mas_prev_slot
      0.62            -0.0        0.58        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.17            -0.0        0.13        perf-profile.self.cycles-pp.do_mmap
      0.48            -0.0        0.44        perf-profile.self.cycles-pp.__mmap
      0.49            -0.0        0.45        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.35            -0.0        0.32        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.18            -0.0        0.15 ±  2%  perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
      0.42            -0.0        0.39        perf-profile.self.cycles-pp.__munmap
      0.49            -0.0        0.46        perf-profile.self.cycles-pp.mas_next_slot
      0.48            -0.0        0.45        perf-profile.self.cycles-pp.perf_iterate_sb
      0.10            -0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__get_unmapped_area
      0.40            -0.0        0.37        perf-profile.self.cycles-pp.mas_rev_awalk
      0.48            -0.0        0.45        perf-profile.self.cycles-pp.mas_walk
      0.31            -0.0        0.28        perf-profile.self.cycles-pp.kmem_cache_free
      0.37            -0.0        0.34        perf-profile.self.cycles-pp.__vm_munmap
      0.30            -0.0        0.28        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.31            -0.0        0.29        perf-profile.self.cycles-pp.mas_wr_store_type
      0.36            -0.0        0.34        perf-profile.self.cycles-pp.perf_event_mmap
      0.37            -0.0        0.35        perf-profile.self.cycles-pp.mas_preallocate
      0.68            -0.0        0.66        perf-profile.self.cycles-pp.mas_update_gap
      0.32            -0.0        0.30        perf-profile.self.cycles-pp.vma_merge_new_range
      0.29            -0.0        0.27        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.37            -0.0        0.35        perf-profile.self.cycles-pp.mas_find
      0.18            -0.0        0.16        perf-profile.self.cycles-pp.rcu_free_sheaf
      0.33            -0.0        0.31        perf-profile.self.cycles-pp.vm_area_alloc
      0.07            -0.0        0.05        perf-profile.self.cycles-pp.unlink_file_vma_batch_add
      0.38            -0.0        0.36        perf-profile.self.cycles-pp.mas_store_prealloc
      0.26            -0.0        0.24        perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
      0.25            -0.0        0.23 ±  2%  perf-profile.self.cycles-pp.up_read
      0.26            -0.0        0.24        perf-profile.self.cycles-pp.down_write_killable
      0.22 ±  2%      -0.0        0.20        perf-profile.self.cycles-pp.downgrade_write
      0.26            -0.0        0.25        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.20 ±  2%      -0.0        0.19        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.18 ±  2%      -0.0        0.16 ±  2%  perf-profile.self.cycles-pp.mas_wr_walk_descend
      0.19 ±  2%      -0.0        0.18        perf-profile.self.cycles-pp.do_syscall_64
      0.38            -0.0        0.37        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.17            -0.0        0.16        perf-profile.self.cycles-pp.__vma_start_write
      0.13            -0.0        0.12        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.10            -0.0        0.09        perf-profile.self.cycles-pp.free_pgd_range
      0.07            -0.0        0.06        perf-profile.self.cycles-pp.mas_prev
      0.17            -0.0        0.16        perf-profile.self.cycles-pp.tlb_finish_mmu
      0.12            -0.0        0.11        perf-profile.self.cycles-pp.security_vm_enough_memory_mm
      0.06            -0.0        0.05        perf-profile.self.cycles-pp.mmap_region
      0.43            +0.1        0.50        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.29            +0.1        0.41        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
     65.33            +2.5       67.80        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


