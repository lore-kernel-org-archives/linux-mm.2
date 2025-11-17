Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A672CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D918E0005; Mon, 17 Nov 2025 08:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6518E0002; Mon, 17 Nov 2025 08:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6873D8E0005; Mon, 17 Nov 2025 08:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48E088E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:48:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDDAF1DBD38
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:48:50 +0000 (UTC)
X-FDA: 84120229620.28.E3EF291
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE252C0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:48:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bdR9ETH2;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763387327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=eqGlmup1TRCuGuKppNULB1KS71yX/ivjMOrk//c0ckg=;
	b=yc0wxADV/vtPoSn48XmOyaSspXuiDH3pBeleP/xqaSRQKxJqhYp6IPEWQpvkb72I03QaNv
	pRVmbrB6rfBIa111sXodQaN2h4tEaoUdV6vVkeLWUXG73Zc6WoWx7H1blk6MFi4MwAsCat
	p2VTFj07YS5vdUtGb4gr6vGKZ2HCkas=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763387327; a=rsa-sha256;
	cv=fail;
	b=2YT/88e8wry7BWbuAkDVdQgFzDbWguwpN9zZl7i5zNDeXnmwk5YO2xhgeI1cXcVyZzajnV
	IhXYj3PrR2ateUQytnM+u6SsxotP9bR0vEKGE8Lj9mVV/kY/Ag6zTfngTlTnO5jZsBZxdx
	q1+TWNP/k2j9tmy8oQ6W2XZ9Vlo2OqM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bdR9ETH2;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf28.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763387327; x=1794923327;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=oqG2tZl2660n+vwZ3qvbLFzPiAu76LMWGuhoj5H4zwM=;
  b=bdR9ETH2yY35g9RvWC9+APfspQklBEeHzPWLQuxMc8xoSgCMLQ/AnPgm
   1N11CIsgHxuIYfOEZA4bLpTTjRqMA3IbBgOPcoOCo8eYtIAn1UTmPui4V
   H5n8uoTAqNEC4ODDYFWyQg+AKJqDdSm9aHKruHdd7KjH/1r6WpclXFl9U
   eKrNZQrNZsOFTEszmQqJQEscpgaxrUAktrpRLSpyDZXFVlYJEd4Ce8Vsr
   /wk09Q7K3iLasQnEepihMuHkCNoAUY4NFRUUmsSFoqgagRH28WE1OmUP3
   GW8X8mlFBKYuu5IfG0dRER1A67v5EtH6aiEUJ5J27Q2kYDHht0qkS7Y2w
   A==;
X-CSE-ConnectionGUID: AghvgxyySeOP1PyM0Ilzfw==
X-CSE-MsgGUID: AV+WfOHuR6Wisd7tDQyO4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65419139"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="65419139"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 05:48:45 -0800
X-CSE-ConnectionGUID: tE0LV+FMTr2hyJz5Lx9gkg==
X-CSE-MsgGUID: cskmjbgzQ4GK1dyuSbTyYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="194774189"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 05:48:45 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 05:48:44 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 05:48:44 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.57) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 05:48:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tU4XMwS80tMLkHy9BxiPzJ/A6YgmkExdiXnbPovmJH9JTsTULJeU9RbMNsaku63XlHTmmcIPniVfqfiOj3EZMgTcKCtDblgrXTH0/1KXXYQD2I1cZHOjn/EnBedJPdVEBdsPEA/cmeQirpu0SAmGPLpP71mGX9saq7nd8HPztFvSViLYuEs/UGyUQkmkWh80nKYJ9P0MN/w+wt2ZrZjk9SHBJdQO9tHAJlGeV63TpoP+lwUJfyUTO6QGIB5SeahTxe9TqMzQIb/ulqwlMtZO/dv7hgOVXAUkeCDbbjJb1p0QEEfAC6Gj3wixK5F6Q+oyGqBvqW0Fqm6HHi5Ki4SoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqGlmup1TRCuGuKppNULB1KS71yX/ivjMOrk//c0ckg=;
 b=Pt07Hr+RoayPKktqvIKF/ARvA45aJZ+OpM6lHxRMy2PnXC969YdNkjarLYmzZgGn3Ssvo2QQqsxG1J6Po/qJDTd4p9mSA+72OMX1cZ6sBzm3pRlePFpUmm0W8zyC+4x725IFJzHDgPkcZwWS2r//yaAyYmHkIUUUC/j0R71HVvcW4Qjm/KYAEoIzeDig365P61Rs6+6JGCkV2vM3qU67i/wbxifJvSOYAA8xxOQZEgDfXKAtlAgwhBv6e3wxQLxNflbhY/DmosR6K2TLaHstr9yawsy6HbmU1/3cwQeyVLsqwCPkPdTWPUKRidh/LbY6Ua7ezXk6+hrJReFPWr1CoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA4PR11MB9322.namprd11.prod.outlook.com (2603:10b6:208:562::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Mon, 17 Nov
 2025 13:48:41 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 13:48:41 +0000
Date: Mon, 17 Nov 2025 21:48:30 +0800
From: kernel test robot <oliver.sang@intel.com>
To: <peng8420.li@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <osalvador@suse.de>,
	<jgg@ziepe.ca>, <jhubbard@nvidia.com>, <peterx@redhat.com>,
	<linux-kernel@vger.kernel.org>, <dan.j.williams@intel.com>, peng8420.li
	<peng8420.li@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH] mm/gup: fix handling of zero page in follow_page_pte()
Message-ID: <202511172111.32f89804-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251112072424.125514-1-peng8420.li@gmail.com>
X-ClientProxiedBy: SI2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:196::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA4PR11MB9322:EE_
X-MS-Office365-Filtering-Correlation-Id: b1fc16f1-34cf-4f03-5bf7-08de25e0046a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uXAVdb+o9ov/aQjOO1UEypw9JgOmZMXafbMY3JXaiiap1CI5I0uygSBuny7U?=
 =?us-ascii?Q?qD7q18f5VE0Ffs0FAF/IM+l14ANoYGcqAAzaP7WQLVZtCsePHiILWyVAW/Fs?=
 =?us-ascii?Q?e7vFMsZFeyEFHF6HWPW3QzIwtXlfxjTj3aLzBchgjNH2XDOJBd6PKRzZsGia?=
 =?us-ascii?Q?NV/PpvqysLReD0wD5BpiliyrCDGRk4+sBVYRMY/I9ct/ziOdtPxXC9YJl/Xb?=
 =?us-ascii?Q?+ijDi3QQvnZVbR9RMOKBW6qifMtDXGYDlHUgqMGC9o7SgUmoF8BMXpd5odwo?=
 =?us-ascii?Q?kFuwem4LEtzcgbrQkOkT9PolDPA+6KsEzmLMinAQtmPYIZW4NXp38/c2z9sN?=
 =?us-ascii?Q?VWkqavwgvugCSmT7h9T3Sg2gO+kiBjVpQqSZST+TNcknBlRiXgpXb9mjm4Wx?=
 =?us-ascii?Q?9xcJp912bhA95By0euhSCMxYgIUaV2wRY7HuaefE05fv7z9YGIdnwHUzDbif?=
 =?us-ascii?Q?12N57/8ZAuUDXmiBVJTr0NdVx5XOsTS0mqePt9BZ6+CYFQl6AIgO1Mdqm+fQ?=
 =?us-ascii?Q?ACo3KGBFz1UHiT35zBYnT8ccYX3/JuBDEpmEFssO4K8vYimVhpnvsl8DFDgA?=
 =?us-ascii?Q?59ZdLdd4vGT3GKmAmCQoGfOT8xfUHD2YifBZuysoeZttcojD9vsQIRs1n2h3?=
 =?us-ascii?Q?CrIm/JGs6v8JiM7XCKzKbDF1E/oD+QWag00ClPDHSb3QunNKw1bFwjiHTSve?=
 =?us-ascii?Q?Q858opBehvleUqUMxqwZx7cFE85elV0AnDrcJdxUHJNeAoH3rVpdTl6Mv0QZ?=
 =?us-ascii?Q?IzZnfTa+JGYSGG6Ujsib3uy4wYCzgnd38cN6LRHtcc6SAaEdmdLF8lG32xYc?=
 =?us-ascii?Q?eXpFGarjD6YQK0nbp2PAs+Cx/WIcwjKTP2w8alp8fxmrbYS8sbggA2NJyc+B?=
 =?us-ascii?Q?FXFhscPwvh5FMAOIgwyaAdjpXZPHNKc7i21gONHoGmo35v/R33w9QMEeS1B1?=
 =?us-ascii?Q?fcxAhXkGsSS7e7pnGo/roFiEepUoVrot0wdcFzQAk5cv4a+FCm8r8FyTon3w?=
 =?us-ascii?Q?HDewWOaROybSRbI9bfHE0KeMUU2Z+j4VLWs81LAMn8wHXcn1LzKdWCvLD64J?=
 =?us-ascii?Q?Nt5ctvz36sm+WLeVXDfEZldeL5ULb/K4PtIR+6lWPghSOnyPnpgFl687brEV?=
 =?us-ascii?Q?Iyj5LBLJs8Fzqlq8sT4qex+1n+M9soMf3sua9kk9xjDwInKM+CwNDQoeYzWO?=
 =?us-ascii?Q?FvIX0QVlZb4L5cHamkY9GABb7ghB3N7RGMY1VXhM8mR0hS1CS7gnbVdSxRG3?=
 =?us-ascii?Q?M9n66JhXrEYM9GsyDKQRDOt/GnZbuCGa/eyuMAFd40HISrQb2v4vJf4oVyVI?=
 =?us-ascii?Q?3qZzetfRGjn3oGFfgLGv1xdunt3f18Ds3iP8DTbYNm2DI8K6hChT7LajM3HQ?=
 =?us-ascii?Q?QKoM85+CzDlJVtjvKrGSVLLmHBqfYiRWvdmOsEUvzNjPc3MDnaW+j0dReWDN?=
 =?us-ascii?Q?eajiAbd8DeC2+ZxajcHBt7epTeVfrp6/IVeV+V8IE0mBWhIQtR4cTQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YRrQdQsmzU8owaF7gMvKPOqiMFxLBoQl1N0jc/YxDpaLl+4DejB8y4EUbjTJ?=
 =?us-ascii?Q?E4JgHufkQAXMOf1XdGyd1kCA/smGWwZoqVUMuzKY7qa3dFxqTVQ3rXiSJyoS?=
 =?us-ascii?Q?XgKVDR+No68hRnD0js43SixJlnpR/ugQpwhXxIJXLsQp+3lR98OW9Wqi3gp0?=
 =?us-ascii?Q?F3h30vNaOMPgnItrLDaaNehG43xGf5CfWk93f28w1InxvowgnZ2qFlrDpau2?=
 =?us-ascii?Q?oENgfs5/7/yQZN191wf+uw9/B6ki+nmv/kgJyEDb92LFNQJQsjWcyGu2xhCU?=
 =?us-ascii?Q?4Vvvq5zhtFkNJ7J/4p9HakgIBSz4aO/w6lKD8+KQCWPVr8CKWq4z04ruCtFh?=
 =?us-ascii?Q?RCAGSGpNmbRUyavqVkoaLqxhaVh6za+NSL0H0NwlHLVyzwEcx4wSBd4ZKB27?=
 =?us-ascii?Q?ExHNqeXKFSCVpUV7inVZi1S0nn+i3/gMR+j0txbcaRHOV559avIQSca4wsll?=
 =?us-ascii?Q?TxnViys1XkHkN6KChnotbD8y5HQkarygQWdm81e/b+fNng2LW+PU6q3y+qkr?=
 =?us-ascii?Q?l+yCh3T2YrgggwoVKj+h9/l0CWkDIbQ2ImCfvLQMTiQhfm6KPIktSRbvr8HN?=
 =?us-ascii?Q?1d+4c6fmTuJ9ODlNCbEI861I/4JTkaL1oQ9vNKtUujzjVmfJdSVlfl8J2cnI?=
 =?us-ascii?Q?337Ril+IzFbD/xG2yMViT2BWlxcL/DNDvlMTquuCQ308X/F+3tOBUoyeR6Bn?=
 =?us-ascii?Q?X86dQSHAB0gMXQ4TAHysbweCdU5fVo0Ri0ox8FSJa9Ums7Z2SMXS7e0EV0Yo?=
 =?us-ascii?Q?zSeUpVivc6ywqisKStfltGKROjM0/DQ8FJUQJBTM6q8nBF0hCFd8tFLCmECU?=
 =?us-ascii?Q?Q0XQ9yd7iPtkPjKqWbsZEEMgfYBnlLTN9DTaE4ZfJMHq6HdZoQ4iPKsqmT88?=
 =?us-ascii?Q?l4MS1GgAIvS1+SEqZ0Kc6aie04CkK1besfzA29YedsCFJj4onZiB5nbSTBp5?=
 =?us-ascii?Q?FVZZvXpyMJkzXAjHEUwtf/VDtnDFbexWU7pfzcL2Jx1JKgZgVL//QRcN45QR?=
 =?us-ascii?Q?bS+KFK3upRyZ4GjeuHcgSeQ3u9WhBa3BLrg3+07xl1UcZZ3xu1DRdu4lGadn?=
 =?us-ascii?Q?m6ZXDNNTXlfQ5B9rzmijW5xHbyqX7V0PHGpv/yMl/13iSAhy873maNoL3TBV?=
 =?us-ascii?Q?IX+DQ2HE3WtOe6Yc2Dc696w8SgTS8doABolXMDXNCaDrCWnck7W4PZaLHlzc?=
 =?us-ascii?Q?6Zgse3lhdYypTnpPkbr9K/7ROJLyKiOVNTX9yJNUSNBCpQxM2Ak1/JflQOOV?=
 =?us-ascii?Q?jOdTmwYhvH2nGjH+mkHFL5XfF09EuC4X/27nKLXpXvfOZ3oMNl6m9TvgXFWc?=
 =?us-ascii?Q?/pIrFlKn8Iz4bNbZf31u3pnEk1hxjqfphaJTva2j4Ibpq44F3NinMetg83fk?=
 =?us-ascii?Q?ZHygTnxvjEaXAuPtyicfzeHEPJQjM/GqboT/rPdGaUCW4Lif6SvIklzLk4RP?=
 =?us-ascii?Q?FwCn7buRepWGBx5QUD9GcFOyUPWAT7YogWMCWEmYeRFEGQKAC193RhOfuLGp?=
 =?us-ascii?Q?M2ojwtWC6B+D2JxQJPEsKyioxE56iqSq+icKQhz8XwthtNiTonktTSabN/ho?=
 =?us-ascii?Q?nQ8SfLWpDFCvgPq0cAcRh8stpTRU7XsIZQcbWGuKvkp/18ns01sRHLVDFl7v?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fc16f1-34cf-4f03-5bf7-08de25e0046a
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 13:48:41.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 15agfFMihgYKxGnNcFnH1B/n4NKKpEIkY8TMP3wBdyn1srmqPUse00yk+jyWZdvz9F8pGwWzzsz9Ez0pyZNlFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9322
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CE252C0012
X-Stat-Signature: edw6fctdzf4cixk8qaoesu6dt3ydpydt
X-Rspam-User: 
X-HE-Tag: 1763387326-609154
X-HE-Meta: U2FsdGVkX18Ify9K1QgF7UudM8eKMmrtc+ocZudTS9Jz34idPAR86Ix6jeVP8rS2znTnYl1lA/OeuJtRXhPCt7+uzAv++0IA6uFnxDS6uB7N61jbzpAjv5a6aYV72H/sUhBL0akHZe7ozCvEZYMpsLLr1pom1VYReAD9C4PiIHYkfZhNoga07kJhZt9yOV0PwVi5a3ZrXp0Ce3f6g29bJ+H9KNUNCCS7EsqYIG6IbTXo8ccT37486hFDWrz+dNCbbteKqP/SjK+JvYEi//m1p3ZS1t2J3KJMDX2Pf+d3f0Aa2YHEOYTmHVuCVoBaQov73fvER5za2m3aegQoH8C8Hpz1teD8DV24raS88RB9LiGN8IxhugJfJ1PHyWY1FnUnnt13Ikque4aAU3rhDWZ7MJDsclynbqeipajWrBAir3FsHwa2KpVVgzABi9TlxNz6Cq2j8SVKrEnGl6B2gsAEJhwsFc8mtkylpQP7Iw0iV7j28seJ++TTRE0VdMvqHILMpCR2lFyJeTys0o0LlSjnmPXaqe48w4OH4eX68hm9cweFMKO5qPnsmXPxLunbroaj5lti+58+XjyfBPFBQTR20MLWBFrZkp95AwJKveqzOcu7n3AVJqPPRHQv9wlMfqk5nkXs1U7LyDDfZIrhFHJBpi9H1Jn6BtHSWm7qKIg7n8ahfPr0ajLJRXXAYLQkOhfgOsICqVbPyKmSPnisQ7AgbmBis2bTYLQBfTs8EPvptudkOJhtlYr4mSBNJN2Y6Kk78NUEUHOO+2m8YQnLXxGIiH02huLRHHWt1FVSkw82O0PV+BUoCMg4f2oD8TyZ0e3Al3d2Vv3L1cpJEHmn11/WPeT5jpdb4/XkLTaj0IEUqHcyTDkO7UMo6ScETPtSDg2+UFELE7rBnmxIxOyxGUu5EKEYSnTSgmJDNmPcEz3kw7Cxu/yLasUTJJhDKg2TIB7IwWqmBuHKCRk5F+R/bXE
 WSKaHATh
 IVA0WxGTA5w4eSZGfTZqnqf/0pxr268Dj3thpH6zc+DjAL/8EqR01GXAebgV1L89mbDJwke8AzEfM1q0TQ2AFJj+JuyioKWQgFf3SUK2EW8bU68oMm+1w/QhfxVdNQ/+Jv58RFEIKvOSSm9mmicB0c/Z/rpIc7HDV7BoLb6y9SBg5RutllatuDgQQGHfAscYeWAGRql6plDgw7/vO+8hV8d3yrAxOdumsNl99+sriyMUO8KWRvcfvh0+JQOWGpuobsTrDGNUBi7qzvaNeQou7XsGYjXvV2bavo64aVa2vZSfEdixeM69/oHqiFKo/G6fBjqYGiU0XGFd8LH65rx0gO5J38jmUSdVGMnFCEbUzBa3diJw5rvM8j933Ud8ZvE3m9AjGbPhzZtKlE66k6dOEnfnqjr/QYYgiZOK10ADGuu6AAkLhHGtpN28cVYhR1QDIkhEJRMWccPcp8lDV9SEFG4xcmrKd1cDOLL8lKKZl4+pJSNI5ljVAb8QYgCPu3OONgDq4+JdI2v4ltr5Tsei5lvE/5EIQU+OPofS7y1fYoeQ/tItjgi6+fOxMZfsIA8NkGqzvnCgTcwOvdnC3bnq8AGL/rk2VJE+/4VHQlgKVKSLek6QvfMl84Be86RHSBBsiH56NNlxRRZ14b77t6tEGXX2OwDQvEXDFVIUbdqHDBEiOOShI3rePA0f8Yel1hbOrQn/2sThqBc0NBE3xmZctSagXkq22WVbMjwJjqvTzi4Cku9O9sg71Mmrlpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:Bad_page_state_in_process" on:

commit: 4e691413bed009d7bd6198eb8fcebd4559a9e017 ("[PATCH] mm/gup: fix handling of zero page in follow_page_pte()")
url: https://github.com/intel-lab-lkp/linux/commits/peng8420-li-gmail-com/mm-gup-fix-handling-of-zero-page-in-follow_page_pte/20251112-152851
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything
patch link: https://lore.kernel.org/all/20251112072424.125514-1-peng8420.li@gmail.com/
patch subject: [PATCH] mm/gup: fix handling of zero page in follow_page_pte()

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-04
	nr_groups: 5



config: x86_64-randconfig-001-20251114
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511172111.32f89804-lkp@intel.com


[  271.087528][ T5904] BUG: Bad page state in process trinity-c1  pfn:05d00
[  271.088206][ T5904] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5d00
[  271.088949][ T5904] flags: 0x2000000000002000(reserved|zone=1)
[  271.089455][ T5904] raw: 2000000000002000 ffffea0000174008 ffffea0000174008 0000000000000000
[  271.090260][ T5904] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[  271.090973][ T5904] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[  271.091567][ T5904] Modules linked in: uvesafb input_leds pcspkr
[  271.092115][ T5904] CPU: 0 UID: 16384 PID: 5904 Comm: trinity-c1 Tainted: G                T   6.18.0-rc5-00409-g4e691413bed0 #1 PREEMPT(none)
[  271.093592][ T5904] Tainted: [T]=RANDSTRUCT
[  271.094176][ T5904] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  271.095412][ T5904] Call Trace:
[  271.095916][ T5904]  <TASK>
[  271.096360][ T5904]  __dump_stack (lib/dump_stack.c:95)
[  271.096928][ T5904]  dump_stack_lvl (lib/dump_stack.c:123)
[  271.097534][ T5904]  dump_stack (lib/dump_stack.c:130)
[  271.098105][ T5904]  bad_page (mm/page_alloc.c:?)
[  271.098668][ T5904]  __free_frozen_pages (mm/page_alloc.c:?)
[  271.099331][ T5904]  free_frozen_pages (mm/page_alloc.c:2987)
[  271.099969][ T5904]  __folio_put (mm/swap.c:?)
[  271.100495][ T5904]  page_cache_pipe_buf_release (fs/splice.c:112)
[  271.100975][ T5904]  __se_sys_vmsplice (include/linux/pipe_fs_i.h:? fs/splice.c:261 fs/splice.c:1475 fs/splice.c:1555 fs/splice.c:1610 fs/splice.c:1580)
[  271.101425][ T5904]  ? _raw_spin_unlock_irq (arch/x86/include/asm/preempt.h:104 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:202)
[  271.101869][ T5904]  ? do_setitimer (include/linux/spinlock.h:?)
[  271.102283][ T5904]  ? trace_preempt_on (kernel/trace/trace_preemptirq.c:122)
[  271.102730][ T5904]  __x64_sys_vmsplice (fs/splice.c:1580)
[  271.103151][ T5904]  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[  271.103653][ T5904]  x64_sys_call (kbuild/obj/consumer/x86_64-randconfig-001-20251114/./arch/x86/include/generated/asm/syscalls_64.h:470)
[  271.104064][ T5904]  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
[  271.104467][ T5904]  ? irqentry_exit (kernel/entry/common.c:224)
[  271.104869][ T5904]  ? exc_page_fault (arch/x86/mm/fault.c:?)
[  271.105286][ T5904]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
[  271.105781][ T5904] RIP: 0033:0x463519
[  271.106141][ T5904] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 59 00 00 c3 66 2e 0f 1f 84 00 00 00 00
All code
========
   0:	00 f3                	add    %dh,%bl
   2:	c3                   	ret
   3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   a:	00 00 00 
   d:	0f 1f 40 00          	nopl   0x0(%rax)
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	0f 83 db 59 00 00    	jae    0x5a11
  36:	c3                   	ret
  37:	66                   	data16
  38:	2e                   	cs
  39:	0f                   	.byte 0xf
  3a:	1f                   	(bad)
  3b:	84 00                	test   %al,(%rax)
  3d:	00 00                	add    %al,(%rax)
	...

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	0f 83 db 59 00 00    	jae    0x59e7
   c:	c3                   	ret
   d:	66                   	data16
   e:	2e                   	cs
   f:	0f                   	.byte 0xf
  10:	1f                   	(bad)
  11:	84 00                	test   %al,(%rax)
  13:	00 00                	add    %al,(%rax)
	...
[  271.107601][ T5904] RSP: 002b:00007ffffa2365e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000116
[  271.108301][ T5904] RAX: ffffffffffffffda RBX: 0000000000000116 RCX: 0000000000463519
[  271.108967][ T5904] RDX: 00000000000000d4 RSI: 000000002d4190c0 RDI: 0000000000000126
[  271.109624][ T5904] RBP: 00007f2836c7b000 R08: 0000000000000000 R09: fffffffffffffffb
[  271.110286][ T5904] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[  271.110942][ T5904] R13: 00007f2836c7b058 R14: 000000002d15b850 R15: 00007f2836c7b000
[  271.111621][ T5904]  </TASK>
[  271.111949][ T5904] Disabling lock debugging due to kernel taint



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251117/202511172111.32f89804-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


