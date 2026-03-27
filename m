Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72ECA10BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35C86B00A2; Fri, 27 Mar 2026 03:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6496B00A3; Fri, 27 Mar 2026 03:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE796B00A7; Fri, 27 Mar 2026 03:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5F026B00A2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:40:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E2031B96E1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:40:00 +0000 (UTC)
X-FDA: 84591044160.04.EF046C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id CE7A14000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:39:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRhvnhLs;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EelweBvFbYDTJIJ+lh7mTRiVeou7DrcBEh1Gwu8U1/M=;
	b=0sDLbD7+Dc/NKBk7JA2UZ50vykhJ5ru8z1Ll1dsmspI4IVcjvMcbvhR/3bUPZ/SVFcaOqY
	oaCcWk6/l8cbzAOedrjsjJW4R4vZuIhaY2QIRsGnoqDDHxoJfuPVPhvrfUPRqsB69jEdTG
	MAYK+y9NptI5MGIDhx77wHrsyvfhi9E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774597196; a=rsa-sha256;
	cv=fail;
	b=vLwCvEJFc26V8MHkBc/kVzGsINTRc3Kv6bHjGUUQtZX9YY3NfEJnonQvw+E50E/kP5OcM1
	H//A9efoBjZj1IFhmB9fkFQ71f8ncp/Pxt9r0ZdxMuLYNOFUucnXdwgfGKpk4gU+iZzr4q
	qx1qZvk4EECGLAW5fhKwmQc+ap+g+Oo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRhvnhLs;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774597196; x=1806133196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EelweBvFbYDTJIJ+lh7mTRiVeou7DrcBEh1Gwu8U1/M=;
  b=VRhvnhLsdYi8inGSPcF8e3Tq8h7d47+ZubKTdc8lSI/lpnWDqUJxWFeN
   nWxyMfXGuQkzyC/a903vcCyd1s2EMCIieV3/V29sstSHrz5wYKOY7zAmj
   YiHRejBBo+WZSci7RNBasImFmOtRm7cjA700BgbRcBqe2ZEZhgURYcrKl
   VsKUZ4rSJXMrUVVmDbWRuSoMBp1GJbQxjZ8nM4sJGwCQf2/xct+2u0txn
   D7UK0fFXRJAJ+cJoRi3Es09tg+0K6kBMqneSItA9csO1e/0ZnkHRv5SmO
   AoIZ8+XHuq8vgReWvxMNHjEhTilkLvouGfuj8GQBEBDOg+/plDdgASpYf
   Q==;
X-CSE-ConnectionGUID: M2u9GZ4cQ1GvVc2d2eSE4Q==
X-CSE-MsgGUID: 3XNYXe9gQzS97juEboeE/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75780750"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="75780750"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 00:39:54 -0700
X-CSE-ConnectionGUID: e6Rb+ohESFWj5VwBHT7gYA==
X-CSE-MsgGUID: qRgxKFH7RjS5x1nOpKwoBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="220392312"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 00:39:54 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 00:39:54 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 00:39:53 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 00:39:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DSaoppC9CLqc2PBc9Mvu87wBjvIwWHuLXPqynqFSSC868axv5wljToUkpNu7KX9j/qxQxC7xdclwvoOZWx7f/k0k1zkZg3QOo4ctUtiWrvyXdX8Rz0OZWhNUV0g8oKFq1RE8fuyLKHFx9++/JryD0EGrUeQTdX+vCNcY1o+1BFjzeJQiMY4W2Yqzs+ha76PYf+Kh6pBFJ6IHAypZ9PQUp+zEM4sX1nL4PisGLWhmrtJCV6iiA7bUherjniQ0N5+F/9iC5+I3wK/VdjuCv1+3o2EZMHyEPZOMdQ46O0/oBNwNfT+ZXCUdeS99Nli7etA26BlbxltTNtSeCfIpqgq2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EelweBvFbYDTJIJ+lh7mTRiVeou7DrcBEh1Gwu8U1/M=;
 b=nqwh0e0fRQYUd6w5xgmZWR3wHDHDAt4S5lcdXaGu6/GdFY8ohuvdmMh+iC2haOw0Mw0dOfVAY7sHlIQh0D2oGexFKFS1r7h06wiaUmJI1cPkHHbd4AzPeYHli6QhhU4Vz++LxY6FImndKM+Gymz28LOUibBuhhSlMIiaWcnjqQapDGv9zitG6Bl4bpRuFgWwZk8sxkRoAHX9+TVe5MQVjyGHyFgDK/4F2oaTwbhN+3TS+DahTNzSLo+zxCcJs4RXydturzL3Bagg61emFM3MM46b8LnP+1E1fEPAk7VPLFDTJH2lxLxGJP5TJ9EfTqhEtmz/11+bVE+pvoRPKZjmeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 07:39:51 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%7]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 07:39:51 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHct4abryaKSRoUW0qNNchDaIVkzLW7+GGAgAQdHGCAAH/WgIABc7zQ
Date: Fri, 27 Mar 2026 07:39:51 +0000
Message-ID: <IA4PR11MB9009451AC94B6624C3C078C3A357A@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <IA4PR11MB9009A2A582EF16AECE1828D8A356A@IA4PR11MB9009.namprd11.prod.outlook.com>
 <b86f559b-6726-43b0-8270-4f041735b7d5@kernel.org>
In-Reply-To: <b86f559b-6726-43b0-8270-4f041735b7d5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|DM4PR11MB6359:EE_
x-ms-office365-filtering-correlation-id: 6eb6cfb0-1996-4847-a028-08de8bd407c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: br4V5tm9g9CLlVTPaL9oXgpnYWoiv2MdBMWZn1S4WN1FB33StLcE8tevj5bOh/3WpfwbSurjsRIMHX3/HF6wRUF2Hn2kM6/9qZ7+Zm6f08ImpOoBe3F/7RLV1sMsL0oLc+LPbXQdHHXTuXGX59L7MKW6xSlGw6S+/q+oPJiTONv+9P7ZcHMLkGy1UYKxn/MvchSExy7Z6zOHBDshMk9ox/Cn1PVNdSnf+nhbbThRWJnKqLvYTyX0c+w2W25Dn62DoGKJaJ2JU/Z3+s+GC9X6co4JSGu3EyIwzvhw4gcBoVPB8P7Se79zMlWI4rr19xyewWncxit3bEXy1Ny/Y/VK+R/z7gJlzRCHeajb9VHhMEbOW3IvcB7Siw1aNxeYKcGNcjoW54XDTwcNERoqOUhprVqQyGTddhmfVce33tacozdYzX14EaCNWrrlQ0Lkf3shPqNPW4gEPv5dm8ESIi7D6oGjCv1rlgy/eZidG8vYGVfnDwyZfLECTI34F9G2T669GAKvSHEYzmF4GxkMV2JkEMobKToe70SPSLUie7ktxbYoVFmV1AHRkPV8uCz7gK8iGvidui0dB3WyDlKKv0f0NFsl0DGUQrFmW2icrUoEyBERQlcQH/qZB5C5ngOxXHcMyG113HsXlJyqWLR5Yu6boCOzAU/T29NQwC+yU2uMvDU+b4XbWH8W0GGqZ3PGGux+zUpLsxuYN0Nz066rLm6PbDKAVTH5KoV/eJeHPNHRWlsB/4hT/ICY+d2heuID2tb/TcPxaPfESVrwt+mYh0Wu4R3D0hrUkBFpSAS1MBHLqmU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?84AxGqwudn7RLE8baOC4DNiB/hDUnmtM0k5PobPoFubP7cUXxsT0GfWNdl9P?=
 =?us-ascii?Q?obxzjExChizQHG3prXOVxByxYtNqc0i3NP0nucmpxNK0Y8k2CNU0sVwumtXN?=
 =?us-ascii?Q?XgE+cBYYMPLWOKzMI19p3cpUA1VgFWHHqkbX9je42/RBUTdC6Ev1C5Y0qx/p?=
 =?us-ascii?Q?ji71n8cX5QPDy76c895t7VDiJBUR+Ng+pF3PK7o2qHxobk3uBrRCx3BZc7to?=
 =?us-ascii?Q?ZIGhS/kuI0WShcfB7gH1OLJk3uGra2MSqvjzKkKT05cJzBtfLH5zs7mAeZCK?=
 =?us-ascii?Q?IxrwfCIsmFOZtb7tnR2TVrObb5r0fRR3GU5mNvtputH3ZWoYZmLEtKOJ5ONc?=
 =?us-ascii?Q?fuV3nUwmRmHDSbfaSfjn5YQxs1ZuYt8OYBQihljYqvDZjMHTMU/h3W8V6FyX?=
 =?us-ascii?Q?93af1F1Px5kVI7Rb3ZWeF/mo5e9SeXTXr+6YKGBNzml58II0vfv5BAgDsfkR?=
 =?us-ascii?Q?KmAHjBISreDLcSfyYME5OVZ5QlKI/mVGULJfJauVQltuwgOS2w3cA/wp+3ka?=
 =?us-ascii?Q?Zu3wTBHVdxVJt6VEu4Du7XPlDI8DLOnLSvj2+w4tel7QQsXJ040rBj34A11B?=
 =?us-ascii?Q?2ygskVDKxVlL8oDVDLj6nu2ecaTxPNj1ovEpaqOrMbCfLNifPpfiIrYm9Ddb?=
 =?us-ascii?Q?RV7kf7t0K3klqqcgcG0lPhqJr17hFGIAaEzR5QAbv/Da86FjCrgpHHrUbmza?=
 =?us-ascii?Q?upj9z4UMNTZQiFhbjGi+/4wW896VoBob8NvbZ8z/J3NQVcH6pxqm3SimFyPo?=
 =?us-ascii?Q?hm1D0V5wLfQ1aBm0c4DScPk1W8eAdZxvQQ5bB6piR9GlcuWUCQixTrpP//GB?=
 =?us-ascii?Q?MTNpQJpRf6vZpnY7jzTfOkfMVmzouovD1iXsSF5sSNHR8QzA6LIuvEfJN7sh?=
 =?us-ascii?Q?nXxWNSgPDLF/1o7COej0bS9XpuYawNoDRdvICaGJuvP812ipFgUaFly5WyAI?=
 =?us-ascii?Q?AInJXSE0ra/0aXJu0kyAMxUmYLI1wKLjbr3yA47kHRb+CUG8HLGA+3j2UsMf?=
 =?us-ascii?Q?NFFFnGGfZvJz0hU+VSl8PrzwPi4tuWhGX0vgydPlk0hSNxuUynmcpROh3MZO?=
 =?us-ascii?Q?z/B+KKcNGbRphuAzrsNB2YU3wcWLErre9jd3Awav4Igv0d3mmzzenulNDHe2?=
 =?us-ascii?Q?zuQ7tiBuKqjUIORQKQRtMqiNyTWc6tQHDY1lscRuh2CkmHxgbBX0R2qXOHYz?=
 =?us-ascii?Q?jvtpNWA/3GI8/lNIhLErsAevP6JzInh/jkAAf7fRH0m/2ORLt4tTMB/bFCjS?=
 =?us-ascii?Q?8sfi7MwgeltBwC4iODfQsgVXROvReqX2lldNErG+Nr2E879Dxaw1XJ+jFA+L?=
 =?us-ascii?Q?KmnUJRe2rPSP1OkLDljOv3x+658Ih5BfepqjPuodb9l1IomLEwXZcMN8iAgy?=
 =?us-ascii?Q?ty3DgFDmUMktW0F14bE00R/Bi/IPImT2sA0j0M+C0oPxjd8ejad9+LtTTHuG?=
 =?us-ascii?Q?TBIXhTn4P0PxEeiiMYjZAtwRsdtxv9bHrJby3LlGtqEw06mqwYrMcCNwFyLL?=
 =?us-ascii?Q?JV2X1V98LiQ4vdlwHQWw8iYmEpa47cWRNsMW+faYZjvjJHOLX0m0QYonywPY?=
 =?us-ascii?Q?XoMTkRjb1Yvl+MqDwg4T7cW/+0j+lY1vvatE9vEo2tDLDJ1RRCnuC6vMZLRz?=
 =?us-ascii?Q?cediWrqwCJzktjePmCUznXbhkyVyuyjiVU9ertmvnohMm1LpUutookdKsT8Y?=
 =?us-ascii?Q?RZ0DaWETH3Hm3T0FctFUEyNgH6lXgq8WAwvIO7OcUN52XRCbT5BL9xnNXQPy?=
 =?us-ascii?Q?pSqoMKKhJw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CCSYPtG5l8LKvxhr/7mCnMrVtih0OkHVjo1f3l/MErs3D0PWqny8aFq5ZQzPAh+uIYjeFj2rA4tr6xHcQyTC2UEp4mdnv+hgV+l111gZ/wJhnFPo87E3KHmKYwFewjdytTvVsB1u57F02M0YfJpGR4VZPXV3xj8uS/DET0ccK8UL33B6D7KHPenHoq12fNJQw7m8tmk92eQ5ZcermVQD/13N0PpJr6fHPYRuwPq57V8MAXRvkFGt/m5WiUKasFBtzSkw9O2s0M1aRRa/k4h47YjIUESrd8VILl3ssd1ayY30XNWcaxwDZnQkSD3VSHR48P+dDpUoqR387mFcOj9QEA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb6cfb0-1996-4847-a028-08de8bd407c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2026 07:39:51.2630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XcqF4JKGxuqlZB4GRYzRqAySOoFZUrRhONhSdpLtOowM3h/Cv5VYV///k/xtShKtuuoLWCsqe/w7lyDb/L9btA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Stat-Signature: y3amuumh375ac7h3zj76j5roquuqqwyu
X-Rspamd-Queue-Id: CE7A14000A
X-Rspam-User: 
X-HE-Tag: 1774597195-365073
X-HE-Meta: U2FsdGVkX1/157bLo/ZE2Q6oPELXi1FXI6wpo0wH6AkcwD/NBa3dAD+pqrsnXw6vsUb7DOM7VF8LQOSzRaFdzHu0JXkc4++X1dxyhXhVC9Oo1TvgZ5JhqwESGPZhUe4sKnj0gsggq6g/IDMed6mVMfQyaJVdzu01lEnH8O2CEXPBsnvDkMRENNAYDSEMiP0cR5c33+hn6DxWCRVrEs+DNxAoyDDGYsJ1XI8RXK5oyU7/b/basopGc16uXgiEKRmbHxlZJOJQwnlLXOhLcEX0CboX5DGSek/XfRgNEzQYi6HLd2KTUDZWwD05KorhcAPtLEb1B2MW0oU1u2eEdiOUZK++E1fizGLJkIsK56M1EFI8MK2KtWFvbbel5XSAxxdglPVQPhxmxrAGVxDPdQJtEvrGsJJXFbHjxt7ZtQ8gaKT6glog7NEvBj4WlLahtHuIk99y3Ad3ugYtlWSokGr6J/pNdcEe1krhe1WBA70NbAdeI0vDCzWL9vkhhPqeLuFKcMV6MNm0b6Utt1u0h9gbxlLXZnxoaNr5RPSYoeTfeU1b1u13Mprv0G86UtCTUGhiCg4CC4ivq3Ieb+Ge40kcHmkLIfwS2SlFVvIH6QEO1MrAsMUSWGp+0XJC+gwzR4/o/CkNlPDfwyqswY5Q2K+A1smkl+9WWTkHXgY5JU+U3qPrIzNBWIQ+cNoABL+hgSMvBePE99hGfkyVjYHtSNPbuECW9wTz0sz1g79iPqAMfVokuJCfPwd1XS+A12sqXLmgHjWB0y8wrjd+mujbnZL/cxrG4RkQwoHd4wUx1H5pyM+6pSiWw7RJBXRpnXIu1MYGbgr/gcYi0C7mTQmRgw/57uRHO4oPigDAHugCnDFJNjab9V+4XHc4buVArjC9ySy94wyoQsor8FGWw4ESK7pTFV+hzDLstSklXD8AMaPWlkBiI4WjxBD5485Gz4iYX9S2Gy4gL7n1/w3ajX4C7gP
 60rODUSj
 OB2y9xUT2c2DBKFadsHhj5HkWDA42JxLYBy/ZSRTnibkivLE8LGG5+Yp0j/2IUteYIe+GxxKNJa8lToEZUyQN7wkXfJwYHnZVLNjgV/GzHm423nrtywQPqAn5XJ8z228KEiek19mLD5BBCQS+VKPNtYcfwFPTUpi0rbeykpyhHdEyT3nopURfVPMyNu55JYpCrRXT8Ge31XykhjbGZ3wRuGpAQIU/opOmp1TzEEguwa2SzDIPe5T/jQDHR56Ig1k2mXkTe3IZq3DtbD2TuDXokdnxt68KqIw/A6cVmXMWhRPkpOuwAkGaGj/0L6r4sLYTD/NgH5j8jZt+Ez/KRdZmxEk5U/YNw+O0BKEGlTAzPuUyqI2aLe57yMseS0k9vsiQJw0qoDb3PjNbonhZ/SlEPxs4/BdlKOtWsiCh0T4P9R8myzZShyrpH6j3kN6/3ghvkDdSUWEBxWS66ZEAku2FlUBnOWtj9wOmt8o/B2yX4Ae3dLAHQmqKamBcY7IJuB/RJY8h2HCzzEtfjpaD1dqVF2sog+elfIvHrVJEjpDbKqBAaXPpNEebJiJjHEw4HtkgnQ2wp8KOYlfbycAvejC0HGEtwAvzi2Lro4Ft+tmrZ2xO7t6N2OgXRBRVOgKOKynYANiRThzsl30Xwe9V29V9rL+9q6F4CGrPNCZ3FptQyrP/bgDFg+rUhwfvWetMYhh3PNgmLUQM8Qg5KXspmG5c5pB3bhdK9pYu7dYs6FZkQyDweHaXXWUK+n92uVo+CKYrX0fEMr8FFX8ctuVz/plyX+zuTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: David Hildenbrand (Arm) <david@kernel.org>
> Sent: Thursday, March 26, 2026 5:23 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
> Cc: linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
> <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Zhuo, Qiux=
u
> <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous
> check when changing pfn range
>=20
>=20
> > About AI feedback below
> >
> > init_unavailable_range() uses for_each_valid_pfn() and skips unmapped
> > sections that lack a mem_map. If the full hole size is added anyway,
> > pages_with_online_memmap could artificially match spanned_pages for
> > zones with missing sections.
> >
> > Could this make zone_is_contiguous() incorrectly return true, bypassing
> > pfn_valid() checks and potentially dereferencing missing sections?
> > unsinged long zone_hole_pages
> >
> > I think if I can update the pages_with_online_memmap in the
> > init_unavailable_range directly.
>=20
> See how I handled it: I simply return the number of initialized pages
> from the function. I think that should do.

Yes, I will follow that and thanks for your comments.

> --
> Cheers,
>=20
> David

