Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7108ACD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 22:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02126B00A1; Fri,  1 May 2026 18:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3186B00A2; Fri,  1 May 2026 18:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A3E6B00A3; Fri,  1 May 2026 18:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 866636B00A1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:33:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 267AC1C08E1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:33:39 +0000 (UTC)
X-FDA: 84720304158.08.E1F5E12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF9A42000F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:33:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DZeboide;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777674815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZBGbYQT8JSn3y0684BAiK9bIQSHeFmqBQCztECcf9o=;
	b=XAOXVhMKG5+g8Iu22WvZ5F2mKQoK82KBtzV3BFon7mrN20SY1dUBz03rPj5wnmCtGNgs7g
	w27rp4q+qcLFE4e1zITe0R0XHNqJwVMcqtxdXE0Jk89SlQscaap0J09jvQmfOi9YExWWzR
	bmxBwCJ4j8uYTwuCYFOy3tfMYe1LfHs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DZeboide;
	spf=pass (imf13.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777674815; a=rsa-sha256;
	cv=fail;
	b=LS81LG20pCAlVPVQIbx3GVH3fBYitFI2rGs3sabzt5EW1MW/y2fAY1+rd8Np3Aic/tnQYA
	TLcJw3ZP3t88NJSquA+2449tiDWxnLY0azpwKS8mtgY/9OVF1OFdRVwlxmqePRbtoophL6
	qnWeY1yYwqiteB9IoKRNXeqcm2WBzIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777674815; x=1809210815;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wG3Vu/Mfkafe4h8HPhbfZCvcO20uTbWc/S5aO1bOArI=;
  b=DZeboideOzMpD+gUf/odcnDVyHn0m8/enB8L0owJFZlW8/z+7tRF2dwH
   AU/J4U71foC3STYzfN0YcwMAZUQcJwnnWAGTaHJUCxMImZpFCPJJDHopL
   AEM0jz3JODD3Xoon+Arb/5onfcTqlxJKyG/rug3rR4kG0I3ZrVcSMaG6f
   9T7ktNUU15Dhz1gwU8ql5lNnVRcddz7XUhPRf4C+i8RP42uD4i/lwgh6I
   T0+JAxLEQUT2ccsu1u2teWPAqTS4GSPr6FheAcmKWaedLzGVx42O7xvYn
   cs3Z1lRXEvm6J/sWBu4TbIXzD5dJi4qPtFmFAd1zuxaK0klcdBSsP1JSH
   g==;
X-CSE-ConnectionGUID: Oc649bYAQMK4MObQjdb1UQ==
X-CSE-MsgGUID: 5lgOzfzMS6m02Zf9tCxzIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="82505884"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="82505884"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 15:33:34 -0700
X-CSE-ConnectionGUID: b0OCorSjQ+OprnnVgEa2Bg==
X-CSE-MsgGUID: 0BLBwLv6RaeBDLGEZunfaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="231838421"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 15:33:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 15:33:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 1 May 2026 15:33:20 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.17) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 1 May 2026 15:33:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqP9EZthtjfSePxWkxbwgBo0a34rdRXEzkL4Hxg9lLtqB81Ruh4FUGFsoJ2FuM7kAF2/bZkjVTko0J9jYLx1yJ8maDc8NLHXL+zFpyO6osK5rI62fCJKugHT8jlTyYGRnr36iY4uFf76DJ6ycfULCUnffiE/zVmvA30idHbdxTSI/+VEh2SdAtF9YqRDy8iCS1Vp7N4UsPuYK9GghbMjJJrzrO+6VzOmpTOyW/bO44qiVSohxOL8R1azlBp7dMECNTLlTNIl4DgECrHFpi8FiXC2cFdFaWdxrgSL3oTmdZo0h7mcFsREL1rbFo0N86ewtDAa/mN15etwEpewVg40hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZBGbYQT8JSn3y0684BAiK9bIQSHeFmqBQCztECcf9o=;
 b=Bshgb9oH00llLyLcaXFZ4G4blo7aAUE01BCAflQdLtAuYtOx/04uuyJkxhDzsDqDeaoL7+y+GG1g1W8yIHHDRz4TmAa7zMtnNxhCkzTSFYFybqHLDawCcKNlv9bCD/k6EuPSfIVxT2qhbu4xY8GGUhr5CVRI/09d+F2jx8oH1I9UgkcevOMRMdB205dyh0iZ80lVqb5bvavXOcx5jhWHcZd/Qm524KDKw6Wz6rMXNA3+drPvkDN94DT6Ph20gZptcQtyKDa3a0m0c9Pq3TnRzBBUAcAeKiATFaLgwLQlb53+PwvGQnhM+M9cbhVo0X9aDqHlJkjYmCgw38eSQcTPQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by CH3PR11MB8313.namprd11.prod.outlook.com (2603:10b6:610:17c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Fri, 1 May
 2026 22:33:17 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%7]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 22:33:17 +0000
Date: Fri, 1 May 2026 15:33:15 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Kenneth Crudup <kenny@panix.com>
CC: <airlied@gmail.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: PATCH v4 0/6] mm, drm/ttm, drm/xe: Avoid reclaim/eviction loops
 under fragmentation
Message-ID: <afUqKwUnyfz1WbPh@gsse-cloud1.jf.intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
 <20260430191809.2142544-3-matthew.brost@intel.com>
 <f25f27a1-bf09-44bd-9b37-49f159d82d6a@panix.com>
 <afUGSmS+jNPP8O5v@gsse-cloud1.jf.intel.com>
 <1bc0b1a7-a01f-4dc2-ad7a-3a05f975331e@panix.com>
 <afUWr74J1OVdcwGZ@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <afUWr74J1OVdcwGZ@gsse-cloud1.jf.intel.com>
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|CH3PR11MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: e5d9274d-59cd-4fa4-1c1a-08dea7d1a40d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: dDIMoWrqc/WZfsYU9S1aUPy2rEv+4ReGSHfboIXRJukefo2SuWldOZXH4Qxln9uMZUuycxBFmy8xegzSXpXIWSJ8EfpdMQS/J0YcXUK1rj+1eQk0R9XE6u2cNs/CSya+6nE7m9njQijBkUf6SL4xXjPY8jKr75co8fUPE9/BfnfvqNxwBsDOmpY8BvVEhUZ5ufeEw8LZvJ3eaOMp2xpep96x2Nrbppq5Jm1OT2pvv5vQvor82RrrWSkbirrj7s1RCGcRZA9h7yXaZ4tChUczerPRw7igIQO+3FNTyLYiFjh8wtngrr26IifSPhCs2gsroZ5kSHpyiY/KtkYSb/21xLLp/yHbJ9q/Scgl+Z+N5gAcbyY7CvpenTiTprNt2iT6Z82ZG71yOlWS+nx74EY1Ae7Odm3o9OunJMMJmsZHMHl9/QuSX8XjisBnPEPUofnTMvv9Q7NF5YqtfeV/hWNjt+AVwElz6/X+2atia9Gz9o0BHRQE0cqBrYY3S8EToNWBm67KInUB2R2Ee0pXw4mHtBh0LyDk3QEIPYoFwSgPs/yoCfZFeeQQ4YVrHzr9Ov3lVZRygrT5JsXEf2kCvzvBw8fjEvHFQOJiFkW5BAFtTWOJVfhdDKVJeCfJ+jdKvWpkZ2qpSvSJHjiFRMb9sqEmBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gKSLknK08wFL95qVn6IirB6Msnp8MdwJAlA9KPr4Npa2WEGTyFH6uNKpdcWT?=
 =?us-ascii?Q?u/SMEr0zw+IQw94fzNtx6iZa3StaC1SVr1e8a9orAWGzuevX2W6WVj+ogT0o?=
 =?us-ascii?Q?BTKu2MD4RpnE1lEdv5nuj+Pfw1ABLxmKuTD5YDQc8tshq4IZ+4SGVni8uuMj?=
 =?us-ascii?Q?zJ9lcSeUXxw2VpyGbxQkrUEtv7gjP6HoxzbHfFLeKw7UkhLmWzhzgxN69zZN?=
 =?us-ascii?Q?dhPLS420gd/gPsYSZ1K3Sl6gew7Dyb5AvYCkOFTwwG+VElqNz3krPKDIreNh?=
 =?us-ascii?Q?BEczs25PVoCYeywpAk554HJcz39UGA/1ffzVo+r5rk6OHmt/BPNjvVNo+jrt?=
 =?us-ascii?Q?i7LgAqoTtnBw8rXxGNDQIZHZfdQeA9t/Bvy5REZxAEaJUzsuq/609KtwzCwQ?=
 =?us-ascii?Q?kd62FpiKMszqeoJ7huIX4kz24YNnKIJJ43vD6MgMVLZVgsJlZQ+cTXb+CZ1x?=
 =?us-ascii?Q?acGivSdCGS/xikcPcbANUUdXwV1uPGbHu/DACowLS2VA/FNBk8dzYgxGSd6n?=
 =?us-ascii?Q?b+jmqioo8mTMBMZ4bozVeQKR6CebTjyIL4yxozbM3fLC7qcCn7mteE+yZlXq?=
 =?us-ascii?Q?tgZ/duTPGLDGtmStpYUkf8z3vOMKgzEymYBLbo8KYf7xbT3/77HGrKxx9gB9?=
 =?us-ascii?Q?9FWn1Kk5mF5WjXi8u147m0bwEeBiCi19QTlHbeic5kPWa1bB++Amlx9Z1y7x?=
 =?us-ascii?Q?JR2/TfCRw698dOBjhJlUkg6FMbJSEOdLn2kWqiL+DdgzHu7DhLIwCCu4Kk/0?=
 =?us-ascii?Q?1sKo7EYqAy2Vg66W2gCDgIx3CJdzLEalOmHL6qFAit9Vd1xBft2HNQDUpH7n?=
 =?us-ascii?Q?4Nc4sWupTjI/Res+MVZ4ZoWix0NOn/iogD9xnFyLRS19eFq+9TYEXAk5ipwO?=
 =?us-ascii?Q?oJnHDASwQ7loXqU2fRDOCIkhd3YxD/iTEB2BLRZCumwCEufPllQezwvI0vRb?=
 =?us-ascii?Q?kzssj4495BNdOho3CvQeyx6BFc2/w/0Z1+NC9HkA/aE0dqce3rKsEXBYhrV4?=
 =?us-ascii?Q?VgCzCJjMvIW0jSfg5/05sKb6HFf9ia/xcjSWtaGDaxg7mGBzn7cpOgco63LR?=
 =?us-ascii?Q?Unopit7Prn6euRGyL/5FICQ/nhLGNjYhz5v0scOWgnzxe/6xtKWT15NJAxgF?=
 =?us-ascii?Q?jFsqSK8gBVpPqglcg24UcYrTeYWJ4Xx+hTMelSUH+RdRQKFPnnZ7RbgmyXCZ?=
 =?us-ascii?Q?CN9AhqGAlKuoolb0QpZRx/wqNruX86CnFbuk7wCcmUQq9gXsEj9i0yMOPgM/?=
 =?us-ascii?Q?fk5SnV/5XlETgq4CnNkeMCeP01j8TJuKkUkikmeKrXPVBn3xg4MPbBoaEL8H?=
 =?us-ascii?Q?7NmG+iNW5kTvS0Er+Fg8KOrxm+YlvLzu1X2WXCKYNSz80kuNTTYneuKAFIs0?=
 =?us-ascii?Q?dsvmWJwI3Wj9/0idWPfOQF/fcIcSdw1/Z79DYcwA4beHQW7qjahsHbrXl/g8?=
 =?us-ascii?Q?lw2mn/tw0sfBmYIlUnP1ZLxQcI+CvzRdlfjUtkKAAaw692FIWjPEiRV0/Qoo?=
 =?us-ascii?Q?3LGw0piT2NhoNjPCT/V2S/55tRwBfhyE7a28FsIMwPUvQGdT8QeLQD/FhG6y?=
 =?us-ascii?Q?nav/hdNZ71YfHUon+ZL03O+lz8n8qucO38xuuBirQHkpj85Fg/kmZlyiw9Xu?=
 =?us-ascii?Q?K9gfkC0bBfsEKuabolNDr1/ifhN4JXd5RSsGSQFx8+iHOfLX/xUVUyhNlDGr?=
 =?us-ascii?Q?N+gx7Q5G69lPC0RTmlaFaqdC8Gpjy7h21E+fmx6yLvLugaTQPpv6nvWo+u50?=
 =?us-ascii?Q?QlZuRimb++Ge1Y/wNHELiW1FHWGdap4=3D?=
X-Exchange-RoutingPolicyChecked: IyHSTmXSjP8ORGADgc+jKWQiIc2EFF6/uM1R1k0TQKL9EyDMjfjIYMWE0Amf0xyBspbN692dgpVdV1mUGdqJmjGbGumrkIecwLvQgaiy6ADg1a+imtMGcfxhZQnIHNZb+RWmnV869/BklRf0fqOb2pyov2TXXY4frklkVKojGqfgmDS/sTKMGGo8/xuDMcR3phoSQ9yh/YLhXHa+KoKEr3K87HLEEM4V4D1MrSO1cDnw2fVi6T3MFfwUi6d7VgkzDq4kfRNcrFEgMeRvvTJibCdqvZHKhCjoMzJ6LHxFDRzW0i+aYf2TQRFJfkxoi1pjax4HVdWCMTkGCV4gtS23Aw==
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d9274d-59cd-4fa4-1c1a-08dea7d1a40d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 22:33:17.6997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtEUGNYOSiDk7YeHur2l7Ycy5LDx9axkoKL/hKFf4mb482VLKvdWI4h/YXCNlSXABltST0F+mh4I7QxyG6uWUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8313
X-OriginatorOrg: intel.com
X-Stat-Signature: i9g65btf67nbemonmizp99mof1sffrkr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EF9A42000F
X-Rspam-User: 
X-HE-Tag: 1777674814-92791
X-HE-Meta: U2FsdGVkX1+/CcAtQpthruExwvzCbXUhc95wkmoSS2CNkUu+T4eiaPTIgqvd1TbmntsEE1OMWebqmZlKR9pLW+Nc+K2Pq2XcbChtE5x5D8LCYWkve39D0Bw164iN5l8GSprmucj54iwBqy0s5yyXMghcDiLJreVVmDrJTWqpFWdOthVAZgukR6aGaZoKScN6IhuCdzcMtnSZ7MKD/P8ZFGl8PS7STtjIxyb4HcaOnYGq9ZbxEVQdWpTkSJj1JMEwxq/WBsNU0B8MWQUrng59besAqJAeABVENcPQJZGtytDsmuuF7focp/bTJ7wvtw6IyYc/wGxFEcSW8RroEfgYrfEPHBI56JLc+ufoninc1d48cIlIDmJGF2PJE6OH6MCBJRO2wpZr3Lpkwz5jg8lS9fGQ1maD129L06GNycloxAiOuromXolzRblVWxfBmx4ZndDGGAvoZsdtx6ZpxMH2SYIeSlS8qr5WMrBJrLzzq5VY6LedyraCqM9DMwXktApWRMdKnn792YHPV5ceKVdZKKAy/AraZmGgZLV43K6G0GJVhm7rOXhA8DkaB4NIFsBJ3SNVN4DfNdu6AButveq1nfvPlHYky07I8Eo9LdAV2rInWrF8IBMkQ0xmiOxaEWIc6XFU6YP2E232YF8eClOC+HjD6eSX0McnhpjvEfPIfdDkpOKxHfcrsUBl4GshFoGs768Y/mFdlxO8qshT3NziRQK7hz9CMUBiNd1BCTd2qFUORbesoeSYD53Tb+jdlcVKIQTTir5dX3WtoK8bRy9JUp8LvjJBdjKjcwJlres+1Aa6cMKbWNK9fYWsSZMlpO1nKNp5tDwKRmUfEBlF64+4VjDtUc+xYOv0a6me41FR67iPNtJSdEGiVKVWCCTthg03T0waiCEfM3v3LqAuA/C2Ieo48DQC/3gyiAHOBqobaSJsvPJPHNLB2lpM2Dg2oq4vqsBrHhNVUO6/9QmwA1v
 khsVu3KN
 YHTLrsWFtrFg5hS0ezeFEOmSYqJ5JX63MixXorIWUUTcN24j8wRJYRirf8pQ1Ryq2CJxoQ0WApeGDMFnJ5WxN9HIDkdrcOKIvEyZLQ4ZT7p3VLjNa/z4Q0Izr/1MZIaaxrOBmvvUDghrS/V6rZUSBbYlSASjqmP85U9KCsql2pREgs3hFGKEeqnXlJ55OrYZBRTFh866DOTRVvz5gB1iph1eo2a9xjRZAXkk76xVld9/22jlriUmjbeseJ6TV/GPSo4YWAVrMRv4hZ4AATVD1QLlnO6YR2hOpjRDdm+D7Q7I4KwHujaLDPAWGkFZV6N/OKY+fflv9LAQNs9iltALY85dVKGDJJRzIts+pFJ7UtkqjKpgjQeyPEIwsskV8jugqUkAJJBzYH3kHa5Ji7GnYs5L+YYgbNaX72SgHglUsadn8IsCMBk8CgXQVkgGU5OGea7u6fQFsMXTrppUYAsLqGm8gZUF9LSKWfUJqtSGWWcjggd7nOaXiOah0tmt36mJ+FPYU1/CjnhfQseU4uVAXueWg2Gp4RuX9EypK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 02:10:07PM -0700, Matthew Brost wrote:
> On Fri, May 01, 2026 at 01:05:57PM -0700, Kenneth Crudup wrote:
> > 
> > On 5/1/26 13:00, Matthew Brost wrote:
> > 
> > > So is this 7.1-rc1? It looks like new feature to 7.1 added by Dave [1] and
> > > something look off here. Thanks for pointing this out.
> > 
> > Yeah. I grab his master branch daily (as of 6fe0be6dc7fa RN).
> > 
> > Is this a "shoot the messenger" thing? IOW, is the reporting off, or is the
> 
> I don't think I'm firing any shots.
> 
> > memory usage really that high?
> 
> I've been able to recreate this. It looks like accounting is correct
> until the Xe shrinker runs - every time it kicks in GPUActive grows and
> will not reduce past some new floor value. It looks like an accounting
> bug in TTM or Xe (?).
> 
> Here is my output on a 8G PTL where I have intentionally triggered
> shrinker to evict at least 23875 BOs (most likey quite few more but this
> what I easily see in dmesg) after closing everything on desktop.
> 
> cat /proc/meminfo | grep GPU; cat /proc/buddyinfo;
> GPUActive:      13100036 kB
> GPUReclaim:          152 kB
> Node 0, zone      DMA      0      1      0      0      0      0      0      0      1      1      3
> Node 0, zone    DMA32   2320   1882   1523   1238    980    740    482    275    114     88    205
> Node 0, zone   Normal   9751   9343   6466   4237   2703   1162    805    420    191    145    289
> 
> Let me spend a bit of time here to see if I figure out where the
> accounting goes wrong.
> 

Looks like a simple accounting error in the shrinking path. Here is a fix
[1] that seems to work for me.

If you want to give a it try, that would be helpful.

Matt
 
[1] https://patchwork.freedesktop.org/series/165862/

> Matt
> 
> > 
> > (BTW, those are in 30-second intervals)
> > 
> > > > ----
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUActive:        652640 kB
> > > > GPUReclaim:       403988 kB
> > > > 
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUActive:        651180 kB
> > > > GPUReclaim:       406812 kB
> > > > 
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUActive:        659004 kB
> > > > GPUReclaim:       399396 kB
> > > > 
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUActive:        666996 kB
> > > > GPUReclaim:       392764 kB
> > > > 
> > > > <some hours later>
> > > > GPUActive:      91832468 kB
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUReclaim:       488000 kB
> > > > 
> > > > GPUActive:      91832332 kB
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUReclaim:       487988 kB
> > > > 
> > > > GPUActive:      91869376 kB
> > > > SwapTotal:      33554428 kB
> > > > MemTotal:       32345672 kB
> > > > GPUReclaim:       486504 kB
> > > > ----
> > 
> > -K
> > 
> > -- 
> > Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County
> > CA
> > 

