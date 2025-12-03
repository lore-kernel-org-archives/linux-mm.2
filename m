Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C51CD1BDE0
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 20:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2916B0023; Wed,  3 Dec 2025 15:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289E46B0024; Wed,  3 Dec 2025 15:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153516B0026; Wed,  3 Dec 2025 15:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0EC26B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:59:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECAB5160748
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:58:59 +0000 (UTC)
X-FDA: 84179374398.05.65DD1E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2DFF180008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:58:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fDyKmi/f";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764795536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp/pekM0x6Xs8EAoCO2G60nb3blia+4A/M+kwW3yCH4=;
	b=LODeBL3dSlpf7bI06n4T7UXSUSATxPowyQn5qlLs1+8QaMAQuunFgtTkyP5h2BODcnFGZr
	4f2yuupFom/HII/46iLaksdSiAut5ABDammH2aORXjvPmt+DZw6Hg4eGqyKV5EGPOZof1j
	2R6TaV/AH/I3AcYoYAY94tQDVih7zPo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fDyKmi/f";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of ira.weiny@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=ira.weiny@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764795536; a=rsa-sha256;
	cv=fail;
	b=Ki9+hAL7twyR2a4DOhirPiI+OWXUsQhf00L9Q4ox5OkcfdP4TTorNwAAG//RtHOuzfSxUQ
	VqNMGVcRWlck95Wnw+ncPEy+AzTyMrG3+TgAe7Hns58uBdaEyvc/n37mIXNdRW4UyfTMki
	fd/SvvPPdIJbLu29rfaogBfeg/AAlok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764795536; x=1796331536;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wfk0c9tswmuKC0LiwxEo7OQdn/OXxno9vTWuf/U6t+c=;
  b=fDyKmi/fwGIqMGgJV++Fq7Xw87+ry4+9M7azPil/jXVyNYo4ayATfq9M
   57rsv4EizfYbLLfEtfhRUqrfw7DyK38aZi5x4LlrsR3tQ7Cn8wUh5OPY1
   j0+v5TXcGcTZ56EOOBG81oUdxYQIgVtUz0t29Zy6BnXwDuUmrTvq3Fl8q
   l3HlX1kl0H/n9/G5YwLLnYH1LGWq8IGaw6sqR6pkMEi2GUcV1vbbxdITi
   xD30ADm52vvV/46HXd+D2sCY3F6witkOnDcYqrGuvlu83M2ft+DsIdP4+
   MLnVkgXuU+wdctVS/YJjVjAfw2cJaXkv4OUrcflKLy6NLrR4Fejh9qKQT
   g==;
X-CSE-ConnectionGUID: 04BFWghRTGSJfC0Qa+j5aQ==
X-CSE-MsgGUID: 700noK/wSbSicrCKmjB67A==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="54354696"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="54354696"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 12:58:54 -0800
X-CSE-ConnectionGUID: pc11bhVQSSmOHj5Dte7czw==
X-CSE-MsgGUID: jygrvcq5RY2lW6N6n30MAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="194068547"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 12:58:53 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 12:58:53 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 12:58:53 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 12:58:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IF/XoWl79k1dpEghdbdBQfsbVdNQJzO7yaJ4K95MBChnSsjiVZlEPWDktzqvL9R1ohl55WKeCHVyyyooBSxrtyAmVgj4mX2AdVso+7+F7M6XhfFCDvWqb/cEFll6NUw40X4UFgzjjx80VFKSP7j9XNQ4y1Zcv5vBmw9zehRuqnzzWPPSZ44sLdKKSrNAxld/eukjliihDMpNbWOPwjDxNgKHUHVSfxtEDaMokTlYPIRcPpSVGkXzANYNvb0onWXZyihgJ4eph1Bnr/JB6l2ifCb3qUX+gIdM+4w63jLU3pwQDZmlLaRMaMhvcP7lhifcP+Jgu/UoVAE0gsQnA+cpsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bp/pekM0x6Xs8EAoCO2G60nb3blia+4A/M+kwW3yCH4=;
 b=XgIvXzb5rP0E4n2gNtRYjyHl2LmiW3LJyFd14P5JC1s1sJ7tfsrBiiMmkutPl4M+I2RhwZZSK25K3KAdjSaxnHCh4rub25ohfR5j8yyvUcBgyCjdpWXRKQyHuPkpkcpYwgQRe8LWHGrTszI5T7/ZGNf8LZlwqRhhPtlcNmukmusPTkSdKCBLNc5AHQ2lxvdaw6NSG+kHH4dmmiWHsLUaysWfitxUBGJo9IEq7vKN47Y1H2imM4DEEzBMf0aVG1C3vRgmGku/AiRWo7OU+/FEYsxAyt2/3YfIsCOewFLDMs/eoY8N4cYaYiEg4tCs6fmSRwBP8fyB6FaK1wzkuVYddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH0PR11MB7586.namprd11.prod.outlook.com
 (2603:10b6:510:26e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 20:58:48 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::8289:cecc:ea5b:f0c%8]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 20:58:48 +0000
Date: Wed, 3 Dec 2025 15:01:24 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <6930a5242dd1b_307bf1002@iweiny-mobl.notmuch>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <20251201221355.wvsm6qxwxax46v4t@amd.com>
 <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
 <20251203142648.trx6sslxvxr26yzd@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251203142648.trx6sslxvxr26yzd@amd.com>
X-ClientProxiedBy: SJ0PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::13) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH0PR11MB7586:EE_
X-MS-Office365-Filtering-Correlation-Id: 014b294f-7431-44b7-3a2b-08de32aec14f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?awTrrZhzPm8d3Bwtq/MkTNw4Lq8hslEDj7K45Re0OyLq96y09CHw8LWxwAD1?=
 =?us-ascii?Q?/9zysxYKyE0SKDN/qTiSaXJTw2DgbL8ZrH4RBIdU2OYTR7QElFFqGQRoEgL8?=
 =?us-ascii?Q?3YNHX8zOQjXZt58Vg5+lY6+O20e6lFOP2vu8U7Nrf39oYh94QhozDZKiCgLK?=
 =?us-ascii?Q?/zbLQanYfW6rJfDNvJWVgXI8agPTeiGkNfNnr3C5fbW9O/bLx56ZMNDBtIWp?=
 =?us-ascii?Q?YfmRHs/AJPgJTtIsem1/QeD5YGCrEqNa9wbyUUc1hv/nu1a2hkV06NCBSpOo?=
 =?us-ascii?Q?4MtE8Sn/Q3utwK/2/XRh3XWTQ/K8Ff2+ZveHPbANkSRN5IZz5H9Kx4/SeTVZ?=
 =?us-ascii?Q?X+EjmU9/lBijpWVkLzFQA/KOHNE2wEbI8eVHw9Oltd20Z2mF8RxRWsTjQJXM?=
 =?us-ascii?Q?2JLR3oVTdj3QCtRdf7LTOa4AriYxmjyXnnKCZ4/WzrAsWmDkK9IXrVoqPJP4?=
 =?us-ascii?Q?L/2ce1RE3k2RdM0/99/sZH5TlDO5YGDA/d/M+SVY6/sVjEbQbvBU82kdjSYA?=
 =?us-ascii?Q?8af4Kn6aVy51W5WDKjk6DWDPS3zu1TtgaurtqMnhtERQDtkbWqU+3ZhKgUiL?=
 =?us-ascii?Q?JTya0oOMBJ0xgnYHuO3S6y39QAjO72LzNgdVroWXXp3jZeddEF10IU3YtxnS?=
 =?us-ascii?Q?d9wy363CbkCX7he0p4WGg04rPczf+HRqNB7WKK9x3CUe3nSriplpKLOZ1X/Y?=
 =?us-ascii?Q?tnVluaDhrSD/DtEJjfFvKbxH4asvxJcwboC5mR15W3eP1kZkRDIpPbEsF5I9?=
 =?us-ascii?Q?u8U/QhkeGwG7sYs1u+35vp6ObhEaZfrCNXhJf+QvpjKuM7ZmGeRiAFNngfeL?=
 =?us-ascii?Q?VM6SgCltJho341x3ZqrIarPF+JDNJFO+Tz6sKJUZ/TnGnDuzmsc2jAJJ4j1f?=
 =?us-ascii?Q?s/msF1EQS0aJBN3NxNy7jvweQUcbIsKJlNuv70xL7Y0IGXt9YpLHAmQk53WA?=
 =?us-ascii?Q?NMGbBG+Nwd2JEGI08iJs8OIxYQfDBkzi+w/AzxHEDPuxIo1DzzGYVRmhWj2t?=
 =?us-ascii?Q?KY0UvhZatNE5Qfxm3eBIdtNBSneI7D4eWvQd+rmKuwIRBHSuyi9LTlyS6B/H?=
 =?us-ascii?Q?1qkDrKONkEYfX28MjqNDdFyuSke9SAY92+m+cumEgAAp64tt+rPZYeGKmbO9?=
 =?us-ascii?Q?Vi9VxKPyzV1QUECqTJxuBgjKPuggUe3U/WhAWS+LicNoJF+51TaAXt1Slbga?=
 =?us-ascii?Q?4yv7p/H3qBK340sMvxpzbu28Q7T6MIz/UiKCF/B6FFX9p/leWCz/sItqJkL0?=
 =?us-ascii?Q?jadh2KztA5L/TYp/Pmmv2k+hfRjxi8mLq74jHXg2e9w1CW9rk6y3epU6TIqb?=
 =?us-ascii?Q?dgX7kJ9p/169+Wa787m5UHSqiXYcsZjBzeXBYl4wWH8gIG7+6g/DdbLnmvZf?=
 =?us-ascii?Q?8RTWn9dvG6+1KsyBKaty0JhhorNsSyCcSXRkg9Wx66vwo1y8JJl4TYw5uIo5?=
 =?us-ascii?Q?OYcfT7wXdt586KW6Q7BJ81sP80cTbC6X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?77g7ZZ6RU4P1+ETHODOjDBcsWSAJBqPkhDV13H1/QG8M67ySL5F3WkC7m+hX?=
 =?us-ascii?Q?Py+bFE9Cw52Ff2Pj83CWVt0Lbz2beX4JQzIZTf35v+Mwy//Kkg43Ptp5SvLz?=
 =?us-ascii?Q?He7qorRdULkUCXVMdF4GgkfUkRXIWpUseKjAUsFuqcLZtFS2AM6yG6Ew50ut?=
 =?us-ascii?Q?Uy+VIfPBGPgj1lNtALsYwjBaZa1AccK/xrwrA7GH4lQifZkP/LtuYdyiE1WH?=
 =?us-ascii?Q?xxmK8mcVh3RUM3+tSGUOgHRZL1lWXfKhRfNOwlRYWglIZbPA2zHS5Lb+RGas?=
 =?us-ascii?Q?j1+rJG8VeMp8lSiigZO4dycvEdd+zl38uxZw103FJjeGzu4k5XKk5Ide01NE?=
 =?us-ascii?Q?ifIHCfLuCvTsPXMEi5XGyQfPAq4KhzE8ICWMAWTiaHrE72NkWki1Z/iJNXDB?=
 =?us-ascii?Q?VmVCxt8kQpRPiGiIYWb6CsNojz56C8yUJCVXZnC5dQgSF329pg0ArA5RfnSr?=
 =?us-ascii?Q?IHrHklx4HRYAo9nmpxZbrE6njzE+CGGW1q9VVkI4JbaVMDWJLzQCWI/FDmNB?=
 =?us-ascii?Q?5GaC1jKoakqQ76KCHJ6siFz2cKOSsDE6H968bKOJ9VZkW1dMkd1mkchky8QR?=
 =?us-ascii?Q?zjLVvgdaiUZm1xpQXJ+QXlLe2hT69/WxKWYEZV8RJGvhUzlB7vwNmmcZqq2j?=
 =?us-ascii?Q?HzO1qpUnMRTgkyCqyUiZICyv4IHckPa0KiSQSrYStmKcOjbLMv8OAHpwUDbX?=
 =?us-ascii?Q?4tYWpvwUe3OrVLLEuN9orqHCc+iJgtmcCnQG7/c3KpEHdx8A/C/+kDrq7kx2?=
 =?us-ascii?Q?njeZhmV/xdxrF9pl6URFGMVjzqe21RFp512kmYwXYHEzJKVdf6zxWXuCQdcw?=
 =?us-ascii?Q?4os1sVDJfA3EEfW4DDDf4eZQjIJVyXJWOWQyud4Vxl0okYkR4EcAsp+9g0kS?=
 =?us-ascii?Q?arxlZZA+6pUQ3mdq1GbC9/Q0pfs9kkbDy5v1CPNloXCk3wvB7GUqrEw2nvc+?=
 =?us-ascii?Q?ShBtUmKnorZej/ibxkkByPeeVkMvS2o4RxjupEXavWp5AGZ+WCElp2Xzckx4?=
 =?us-ascii?Q?b1JCdw2FTL6ZNJoWJygstRWtvJRTya9n83YtBPHGFsOH25Q2BVOumkkCqtvk?=
 =?us-ascii?Q?sb3uzR0rj+9tQOIb/A8QcV/4VTaUCHciyyd4wh9kSaK183wbQ7hgb0AUnnsv?=
 =?us-ascii?Q?1aTWVm9C65DaxhtM2oCNy0EL+XNCnMtFjJh0PE7d6Up8FENstVZg9t05Oyit?=
 =?us-ascii?Q?TAwHJUgDfaSJX+7eW8vK0z+FxzyR0+n0Dj27JOtY9iJxPm2txz2nX7DPQpok?=
 =?us-ascii?Q?ShrfziYhSnUkwCtCJih0PWGe/EBot8HThn5ec5to879rIkLikbsKPvm9x/+Y?=
 =?us-ascii?Q?jsjPbBXnj1LVkGC2OpDq53qc81J05TK1T1bbY/AgLbeknde68imxQxQUhDD0?=
 =?us-ascii?Q?ei/XqQtOjeCINCoL1zdpAl3kDEpp2YUOJHGdn+pSFT5AOG3tkHS7OkgNroXM?=
 =?us-ascii?Q?F1tUqiL8Jv9eqLS+0KZKSpxpSijNcdsO7ToxWppHllYA5HJzWlF/6glOGGEA?=
 =?us-ascii?Q?fTMC5QMPqWL7pmhRLMZ19Qhubohio+j7bpaCxrpn9erQOWqzDS1grTxh3qhx?=
 =?us-ascii?Q?5hgxPyVhYytg4CiSrYCvWA3sX166fY5wE0+cseUM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 014b294f-7431-44b7-3a2b-08de32aec14f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 20:58:48.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45bFXxMvtL02PQqkKRURk8b5fY9bRuLAPN79iKNrsbsHxcQ9vTDJP69qqInNfxrHEqZSxCAFZ8ESqQlmu3o73A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7586
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2DFF180008
X-Stat-Signature: ottye5nucqs1wznyofobdcwgwanbkiw8
X-Rspam-User: 
X-HE-Tag: 1764795535-783930
X-HE-Meta: U2FsdGVkX19fmI0jqDTd2ccrC3QgWjTKCGhkGuGC2z/zrYFa344fD0PKbOeQevJODaJSwaA5r/Mp0bnAVTHROp0HImx+9lu+wNk2TifEDmu56Pzg/lY6wBRdP19sRV9BrQb1qdKKITBFTGb49hxS4LfOS4yczmpIbo13MQiEOXhmPtPIYvysDU00UL91TOoXP84jpOerVBJ5QLpjIiV2GD6928xx95Heaa47w3v7w11LbTH8dDINkXbqXZiPYWjpXUDKWykNaF78S+A6267OWKWv8zmxLrek/Fma82VQigqvV2LsJvoNMlwl7R5K+ZPBz9Mebtbt3+Osu6aguHjTq/uVPJNNGKO/Usvv7baR1Z5FM5boWcKoTmybczFFvfuUD4wAuY+7LfYMAGv5Erypdm4VKgPyQcBfC/S5PWQZ6pw8hhiTuPT0b5QTy6ypq6Wk8AeuR0iVLdvPTbZKTWRlZJpKC5K/E+DKdXDR3i1iylowwjqkWb/mTYtEZ/lajTcpWDlVDHFEkfosdGPtddYcTWlJwN+f14/qhz7wPL+x7d5MKATIndXvpsMqgH/9yPenbdFtGMAIFZ1yN9xnQhvuu4adxB+T2VtaBk8sz6urKZjHwOqhN+vV57YmEsAewON7SiH/QLUfl8GMlGBDhPxcKXiClOkf1rKOOaYQjC0x6xzI35Ga7wAkHKM+P2+ITgIwUGuLfetimUfRu4L4optYrQm+gC7mb6zMagciLTZF1/ibtTn9qEDerKQ6o6MjqcxWKv8RHr2Q2FekzGiXdnFqAYzOPSPuI5sxB8M7yZUuBVlLqIOfB2eWSciiXvK9uPQUTzi9qynerLsc2VA5VBP//UE6XYS5P4uf9adNYK44QP9X0gq1nBilNN60y/1Gg2oNX6fwAOxiofRhv2YXDxUXYkCgEJ+ZpKrBuTWqdLfuzGhct7TaiP3ax/HJZ+Aaqw+M5DoRGzOJHgQPD14oDk+
 FDIrtsKC
 z4CTFS3MKUOtgyGtptj4E56n5w449rMqRjVqGpb22RnRWwM8prFGPTwTFDsCg0asuZSvP54PRNLWQs1k//6D1ti99apdiXre1xBO5lrPzFVGNRuKpqqVPIwEWLAncdNvA1ONe8KwZhRy9xC5T6JKOsML0KYmhBLPYxQMZjOTRZleIbmrXZ5qHApxWQsya1fLSnOJCGp8OvqJocVNBxYhEqV8UFtyB3sW/qs6LRqGMbhofHZ8TFQAs+egIkJqzM+A3ut9I+oN7sw4Ss3VAsFWgqvoE3RoeKseP9cindYa4zZ9H1A5TR1H1iC30RLA9WgLC+cG8OOIV8mo00ev4BKd0ocwe6cjfTzuIOWrC9Qn6Atwt3LqN5Mjah8HEux1SHOTedSMh+oftoVpcOj8QWX652VLm65jGH22jBY1MIN2y0TwFRRQHqshJ7xt36HCsqUXS/D2GfBjb8tXOxQpn+MazU/5el23IQu7+GAPnrrblrEMlrZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth wrote:
> On Wed, Dec 03, 2025 at 10:46:27AM +0800, Yan Zhao wrote:
> > On Mon, Dec 01, 2025 at 04:13:55PM -0600, Michael Roth wrote:
> > > On Mon, Nov 24, 2025 at 05:31:46PM +0800, Yan Zhao wrote:
> > > > On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > > > > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > > > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:

[snip]

> > > > > > > ---
> > > > > > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > > > > > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > > > > > >  include/linux/kvm_host.h |  3 ++-
> > > > > > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > > > > > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > index 0835c664fbfd..d0ac710697a2 100644
> > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > > > > > >  };
> > > > > > >  
> > > > > > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > > > > > -				  void __user *src, int order, void *opaque)
> > > > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > > > +				  int order, void *opaque)
> > > > > > >  {
> > > > > > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > > > > > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > > > > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > > >  	int npages = (1 << order);
> > > > > > >  	gfn_t gfn;
> > > > > > >  
> > > > > > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > > > > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > > > > > >  		return -EINVAL;
> > > > > > >  
> > > > > > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > > > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > > > >  			goto err;
> > > > > > >  		}
> > > > > > >  
> > > > > > > -		if (src) {
> > > > > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > > > > +		if (src_pages) {
> > > > > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > > > >  
> > > > > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > > > > -				ret = -EFAULT;
> > > > > > > -				goto err;
> > > > > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > > > > +			kunmap_local(src_vaddr);
> > > > > > > +
> > > > > > > +			if (src_offset) {
> > > > > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > > > +
> > > > > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > > > +				kunmap_local(src_vaddr);
> > > > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > > > > 
> > > > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > > > > 
> > > > > src_offset ends up being the offset into the pair of src pages that we
> > > > > are using to fully populate a single dest page with each iteration. So
> > > > > if we start at src_offset, read a page worth of data, then we are now at
> > > > > src_offset in the next src page and the loop continues that way even if
> > > > > npages > 1.
> > > > > 
> > > > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > > > the 2nd memcpy is skipped on every iteration.
> > > > > 
> > > > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > > > missed?
> > > > Oh, I got you. SNP expects a single src_offset applies for each src page.
> > > > 
> > > > So if npages = 2, there're 4 memcpy() calls.
> > > > 
> > > > src:  |---------|---------|---------|  (VA contiguous)
> > > >           ^         ^         ^
> > > >           |         |         |
> > > > dst:      |---------|---------|   (PA contiguous)
> > > > 
> > > > 
> > > > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > > > as 0 for the 2nd src page.
> > > > 
> > > > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > > > snp_launch_update() to simplify the design?
> > > 
> > > This was an option mentioned in the cover letter and during PUCK. I am
> > > not opposed if that's the direction we decide, but I also don't think
> > > it makes big difference since:
> > > 
> > >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > >                                struct page **src_pages, loff_t src_offset,
> > >                                int order, void *opaque);
> > > 
> > > basically reduces to Sean's originally proposed:
> > > 
> > >    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > >                                struct page *src_pages, int order,
> > >                                void *opaque);
> > 
> > Hmm, the requirement of having each copy to dst_page account for src_offset
> > (which actually results in 2 copies) is quite confusing. I initially thought the
> > src_offset only applied to the first dst_page.
> 
> What I'm wondering though is if I'd done a better job of documenting
> this aspect, e.g. with the following comment added above
> kvm_gmem_populate_cb:
> 
>   /*
>    * ...
>    * 'src_pages': array of GUP'd struct page pointers corresponding to
>    *              the pages that store the data that is to be copied
>    *              into the HPA corresponding to 'pfn'
>    * 'src_offset': byte offset, relative to the first page in the array
>    *               of pages pointed to by 'src_pages', to begin copying
>    *               the data from.
>    *
>    * NOTE: if the caller of kvm_gmem_populate() enforces that 'src' is
>    * page-aligned, then 'src_offset' will always be zero, and src_pages
>    * will contain only 1 page to copy from, beginning at byte offset 0.
>    * In this case, callers can assume src_offset is 0.
>    */
>   int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                               struct page **src_pages, loff_t src_offset,
>                               int order, void *opaque);
> 
> could the confusion have been avoided, or is it still unwieldly?
> 
> I don't mind that users like SNP need to deal with the extra bits, but
> I'm hoping for users like TDX it isn't too cludgy.

FWIW I don't think the TDX code was a problem.  I was trying to review the
SNP code for correctness and it was confusing enough that I was concerned
the investment is not worth the cost.

I'll re-iterate that the in-place conversion _use_ _case_ requires user
space to keep the 'source' (ie the page) aligned because it is all getting
converted anyway.  So I'm not seeing a good use case for supporting this.
But Vishal seemed to think there was so...

Given this potential use case; the above comment is more clear.

FWIW, I think this is going to get even more complex if the src/dest page
sizes are miss-matched.  But that algorithm can be reviewed at that time,
not now.

> > 
> > This will also cause kvm_gmem_populate() to allocate 1 more src_npages than
> > npages for dst pages.
> 
> That's more of a decision on the part of userspace deciding to use
> non-page-aligned 'src' pointer to begin with.

IIRC this is where I think there might be an issue with the code.  The
code used PAGE_SIZE for the memcpy's.  Is it clear that user space must
have a buffer >= PAGE_SIZE when src_offset != 0?

I did not see that check; and/or I was not clear how that works.

[snip]

> > > > > 
> > > > > This was necessarily chosen in prep for hugepages, but more about my
> > > > > unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> > > > > happens to align with 2MB hugepages while seeming like a reasonable
> > > > > batching value so that's why I chose it.
> > > > >
> > > > > Even with 1GB support, I wasn't really planning to increase it. SNP
> > > > > doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> > > > > handles promotion in a completely different path. So atm I'm leaning
> > > > > toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> > > > > support for kvm_gmem_populate() path and not bothering to change it
> > > > > until a solid use-case arises.
> > > > The problem is that with hugetlb-based guest_memfd, the folio itself could be
> > > > of 1GB, though SNP and TDX can force mapping at only 4KB.
> > > 
> > > If TDX wants to unload handling of page-clearing to its per-page
> > > post-populate callback and tie that its shared/private tracking that's
> > > perfectly fine by me.
> > > 
> > > *How* TDX tells gmem it wants this different behavior is a topic for a
> > > follow-up patchset, Vishal suggested kernel-internal flags to
> > > kvm_gmem_create(), which seemed reasonable to me. In that case, uptodate
> > Not sure which flag you are referring to with "Vishal suggested kernel-internal
> > flags to kvm_gmem_create()".
> > 
> > However, my point is that when the backend folio is 1GB in size (leading to
> > max_order being PUD_ORDER), even if SNP only maps at 2MB to RMP, it may hit the
> > warning of "!IS_ALIGNED(gfn, 1 << max_order)".
> 
> I think I've had to remove that warning every time I start working on
> some new spin of THP/hugetlbfs-based SNP. I'm not objecting to that. But it's
> obvious there, in those contexts, and I can explain exactly why it's being
> removed.
> 
> It's not obvious in this series, where all we have are hand-wavy thoughts
> about what hugepages will look like. For all we know we might decide that
> kvm_gmem_populate() path should just pre-split hugepages to make all the
> logic easier, or we decide to lock it in at 4K-only and just strip all the
> hugepage stuff out.

Yea don't do that.

> I don't really know, and this doesn't seem like the place
> to try to hash all that out when nothing in this series will cause this
> existing WARN_ON to be tripped.

Agreed.


[snip]

> 
> > 
> > > but it makes a lot more sense to make those restrictions and changes in
> > > the context of hugepage support, rather than this series which is trying
> > > very hard to not do hugepage enablement, but simply keep what's partially
> > > there intact while reworking other things that have proven to be
> > > continued impediments to both in-place conversion and hugepage
> > > enablement.
> > Not sure how fixing the warning in this series could impede hugepage enabling :)
> > 
> > But if you prefer, I don't mind keeping it locally for longer.
> 
> It's the whole burden of needing to anticipate hugepage design, while it
> is in a state of potentially massive flux just before LPC, in order to
> make tiny incremental progress toward enabling in-place conversion,
> which is something I think we can get upstream much sooner. Look at your
> changelog for the change above, for instance: it has no relevance in the
> context of this series. What do I put in its place? Bug reports about
> my experimental tree? It's just not the right place to try to justify
> these changes.
> 
> And most of this weirdness stems from the fact that we prematurely added
> partial hugepage enablement to begin with. Let's not repeat these mistakes,
> and address changes in the proper context where we know they make sense.
> 
> I considered stripping out the existing hugepage support as a pre-patch
> to avoid leaving these uncertainties in place while we are reworking
> things, but it felt like needless churn. But that's where I'm coming
> from with this series: let's get in-place conversion landed, get the API
> fleshed out, get it working, and then re-assess hugepages with all these
> common/intersecting bits out of the way. If we can remove some obstacles
> for hugepages as part of that, great, but that is not the main intent
> here.

I'd like to second what Mike is saying here.  The entire discussion about
hugepage support is premature for this series.

Ira

[snip]

