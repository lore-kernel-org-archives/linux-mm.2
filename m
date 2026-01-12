Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD24CF45D8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D366B0005; Mon, 12 Jan 2026 16:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBF86B0088; Mon, 12 Jan 2026 16:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A966B008A; Mon, 12 Jan 2026 16:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C15B36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:49:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E91D13C4F8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:49:25 +0000 (UTC)
X-FDA: 84324653490.05.5A065D4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41AC1160006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:49:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yc1tp3mM;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768254562; a=rsa-sha256;
	cv=fail;
	b=CcFS7Nf7VA5gvlFJO3NWm1WHjsU11Fmupt5CnTzRaiJxXx43H5lLARSZwVidJ/+q875QT6
	K4Jnt9wdoeA1SHwwgR79omimNWdrho/o+fPqrmzHL86mhhppeVExkW/wJB4JEMmboG7/oZ
	4pthyWXK5mKMEcNbyhJZ45xwWcn+pww=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yc1tp3mM;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf08.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768254562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gf7gS8MN78DTwNkidfk8NCAjqjq7LgpocC4fEYsTWE=;
	b=JSpqi/xh4WqZwU3lXh2Jpi7gjmbtKOiRpnwGsknInJs4hOBQDtzgtpl743c/t8wyNKLKN8
	IYSpnyibw5USZDbi4LvnfP4K5WNBbkXWVRZ5PdhaVxyQ65OQInvPiHsedA5TAuSUnYonaB
	1qvFj2MvKYEQw23mJXT1sksKywRG2Iw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768254562; x=1799790562;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lJUDYuifFDOp0nTavawJ9jkmIRDNWv73e2nvefKaNIQ=;
  b=Yc1tp3mMlqyIVambNuMUBVUvCddEhyjp6LMsv78BxrsZG+sC7MEhUWtB
   oSRQPTnbENZlDAk/q8s82mIzd6FwXTyxsQFeR/cmGkM3zwjkUYZ5F1jlb
   cOwrrLuyM+HWkjxltv2eMaUXl62OLVpLFe+29Asa2aUqShE3SW0PRsR/7
   E+xUIiiwEqxj1a0ZlNskMheEYzMJXVwU0/EZmXhEWGlSgEcy2lvF/VPMC
   thIc08ZhI4/PK39SZUY/kMWjlJOExBgn6yWoN7+6hSKgopLUrO75P5hmx
   cyzwZ0PlxkpWyEN8ITaB91lXK9mpu2+7K9xOnGiKXjMwYBaQPvPKspaQw
   Q==;
X-CSE-ConnectionGUID: 8CrvMn/9Rdu0d4lZ/H6vDQ==
X-CSE-MsgGUID: 5XG3cRjXSkaS2NoYCJTreg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80644256"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80644256"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 13:49:20 -0800
X-CSE-ConnectionGUID: gWGb4r7gTDahwTxss8fvAQ==
X-CSE-MsgGUID: j/CkvE4JQSO44HS5oDl9Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204488313"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 13:49:19 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 13:49:18 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 13:49:18 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.44)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 13:49:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U/LByUaV83xF8WwvZ6BIn1nP3YADMEVr8YI+N7rQj0zXklN5XhjvxX39L0Y0qkPUEO5zBhUnIaX4rQWpXxHx4cVGvJdjKRTuHddeaAKiKgaLeNTlbG6nDMB9I6XqGFeuP1N966IU4S9e0HQzJLelCVdKk0qcvgDgLI3e4JsuovAlNAes1mF6qEkK2T//pmBo5jbYPFnTKcKzutkp42FiWlaBuiO7k9FBeIbYkltpozkm9fwLC2Spm4R+kUMav2kbqWy/2bG5RkR7q8/DsYjwbZpXfncxcLGBpymuz7U/OR+l826c9zTfgOLWZE2TGP/DGmCbOflUSggAVi8DIMScLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gf7gS8MN78DTwNkidfk8NCAjqjq7LgpocC4fEYsTWE=;
 b=i0ZNDuBzSTFOmyIT46lFMcWiodgttThGIrrE5ZjRXQ2ki31rfB8ORE2spTEaVtq+SB9WOIDM/Z4xjrByYcaMMoMV3SrcGMDXWvolh8dKaLEIyyRWGWUhp0QgTGWtxnG5cLNTmtq/2hnDyQhHjZZWj310yekPw+Yp3HeaVgmhELE4CYIcKJ5tHn8YyF3hDD7WoGJS4yx+pUKAWkvDh8oTDyzGJkrSksRNBhqvgogGhlynMLYI7uTg9v0Np0iUpNotBeLdzMjBg2noDoLMvVOp/BGCBFP35fuoaBD7Q/fL0gnwfZkt2GsZWnWLcg9Y+HChioUgQjLUfljqBXZKEEXd7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by SJ0PR11MB5056.namprd11.prod.outlook.com (2603:10b6:a03:2d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Mon, 12 Jan
 2026 21:49:10 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Mon, 12 Jan 2026
 21:49:10 +0000
Date: Mon, 12 Jan 2026 13:49:06 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>, "Balbir
 Singh" <balbirs@nvidia.com>, Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	"Madhavan Srinivasan" <maddy@linux.ibm.com>, Nicholas Piggin
	<npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy
 (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, "David
 Hildenbrand" <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>, Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Alistair Popple <apopple@nvidia.com>,
	<linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<nouveau@lists.freedesktop.org>, <linux-pci@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <aWVsUu1RBKgn0VFH@lstrano-desk.jf.intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260112134510.GC745888@ziepe.ca>
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|SJ0PR11MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: e49691ec-661c-4b70-be61-08de52246b00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|19052099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cU8vb1U2SFlHUk84RG12TUZHM3BUKzdkNUh1dnZEbVZZT01CNzVNZXQreFFY?=
 =?utf-8?B?UmZNbXhsWm01dVpNYmdSbWprOE1RYlZaYlR2NlFiNWJKSWt4ZlY5cjRjOStY?=
 =?utf-8?B?QzJ0MTZVOHpSUmEvWEE5Ri82QkJmbVhqSXN5Vy9xOWV1eEtqOURicGFVS1B4?=
 =?utf-8?B?OVJFb2VETm1FZXQyOUs2Tjc2YkRoU3ZnSkdVeUZzRlR1cnQ0bFIrVjg5aEZw?=
 =?utf-8?B?NGlXdUQ5U2NLd2NpKzlwVmZISjA5bUhOa3ZJa1pZQzBGYlpuUmFBbXZUdW84?=
 =?utf-8?B?QkdwdFNLUkRZUnJBN3ZMbzJ4cy9qMWhWN1hXQSsxb2FlcTBMbXRhNWU0WE5p?=
 =?utf-8?B?MlJmc0w0N2syVWRQU2k3bzNwU2lWZEY0Q0xLYnNIM3U4S2FDTlRVVmprK3R5?=
 =?utf-8?B?a2crMlRyQkZkcEFNOVlOVU44c0dGREdVbHVPVkRMZUpmVG5XdkNtWkNyaHpS?=
 =?utf-8?B?c2wyRDVFclhqbU1yVFJKNVVXY3ZtcWVLcllvSmZwSERDM1poYy9NWm9nSXQy?=
 =?utf-8?B?RFNiMUlaOU1CMjJpMzNUOE5kS1lvN0xxeUZ3VUJIZVJwTTl5Mm80SloxNnc5?=
 =?utf-8?B?VUhZeWMzWmlDV2pTeTVldGMxcVlQbllmakVDYUlSaFhyTndkUVkvWDloSlFJ?=
 =?utf-8?B?bHFteGN4ZnNEaEZwN3FaK3c5NXZJQ1JBVS8yYjhmTnFValNMNXg5aTRrOUQx?=
 =?utf-8?B?MVRWVGRMa2tYeEZiaytrUzFuNzZhbnMzQnlJaDZTcWF4a25RVWYzTVZnRVAy?=
 =?utf-8?B?dFpJOTRGblVmZ21QcitNL0JnTE1mcysydS9Vd1MzSW54S1g1SG1CTGs0aFcw?=
 =?utf-8?B?Z1d4cmdiN0d5ZHVET3VodTRoMVVYWkpMRlJqbTcrcjlCRFJXTEpmUGNER0JP?=
 =?utf-8?B?UTJrSHBuclNrL2h4ZkUwMGtDMi9kcTF0QWwrNGg4MmFCZjNtejBHK3R2ckZ2?=
 =?utf-8?B?ODBTL1JhYVFoMTBVQjl3R1BlYkJObTFNL2FJSXF1aVhpWHQ4OUg2SVRBVlZ3?=
 =?utf-8?B?eS9RYXEyL1MyMXRBYy9VSEpkY0xKOWQwaFRVVnlwZVJUOWszT1hIdnAvdUNX?=
 =?utf-8?B?R0lYS1hPUXM0c0VXUTQwcDRjVlNheXNlR3pJdmZMRGxjT1JFNHV6K3JQMFRv?=
 =?utf-8?B?c3VLRGlJRFAwU1BURUpXZ28yWW9UL3QwWW5mVVBsbElNR2o4T1pFMEVGc2xJ?=
 =?utf-8?B?YXlEQnpDZ3lxY2UxbGlNZHVLSVdubmhyK1BENXB2SFhZZHl1eHk3OXUrcm1Q?=
 =?utf-8?B?NjEvRldjSTdpVmM2UmFVbUExYndwc1g3aHhnakZlZmZjSmdmaXlsRm5laHpt?=
 =?utf-8?B?MUtBbm5aSFBtdXErWnpvL2RwOTZpbFJkU1NDR3poWmRlTExBd3llUk5LaVZ0?=
 =?utf-8?B?QUsxRWlXeTB4RWJEejZ0bzZKYW5IUmhhQk1kM2VYRkx2c3hQNDB2T0NnRVpF?=
 =?utf-8?B?NmNnaldpMFhOZnV0MVNpQ202cTl6K3dVZHVnaWZTNFdubzNWYkExQmtBcDhJ?=
 =?utf-8?B?SVJWWHE0dkxWZmRPd2NGbXM3bUk0QlRUN3NQU2JRNEo3dm1zT1dSbG9qcXZn?=
 =?utf-8?B?MVVOVlNDaFlMZ0toTU95UUl0ZDhLN1hnQW14VXJObStlNXc4d25lN01EYW1o?=
 =?utf-8?B?OEcrOUlvTVJMdzFjdWpZbFdUZmxXMmtQaEJnK041NEcwM3RtK01vZnZoLzNC?=
 =?utf-8?B?SGdQL1hlMDUrQWRpVTJsS2ltYkNnR2dCZTZFRVY3dUFHL3gzN2VwcFBhUW5X?=
 =?utf-8?B?alBqUWFNbFNONGVuRW5zbmFiR1EzakxNbEdLc0NEdnlaalYyWHdXYVdaQlRX?=
 =?utf-8?B?a2xJQk5DRnMvL2szK3J4TkpkNzN3MFkycjBvcjhEZEV2ZTR0enJqRzFSeFNa?=
 =?utf-8?B?NWtyeFVmbHdZTGZEVTdySmhtT2k2M3ZUNWRvZ3Zyc21Qbnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(19052099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWpLczUxNzh0Q1llQm16c1BYdGd6alhia3RxbldyY21vMjU2Z1pIaUxCdmtZ?=
 =?utf-8?B?QjJlcW54L0VmWkNoMDBEcTFZdllYUm16bDQzeDErazR3UGx2c04xTVRqckhD?=
 =?utf-8?B?ODdUcExBRnN5U3NkcEJlODlXVjJISktrODVnblhMS05iM2h1SDFTckZ5dnkx?=
 =?utf-8?B?a1BwWFJ5OTNoeHI0aVo1LzJxMWhkb0FqNEpLMENpbFY3cy94MDlsclptM1Rw?=
 =?utf-8?B?OWJNWmhlMXk5UmpWdTRNVldyQ0tvc2N1bThOZUxjSkRhc1M3K09DTjd5MXpB?=
 =?utf-8?B?ZmZoSUMzQjlJa2YxUG10Q1FTTm5mYTNvMXhaWE1YK05GSjRiZDlUODhCMllh?=
 =?utf-8?B?alN5QmdTbE9veFFIWlpPam96dDZvUlF6bEd4ZXVJRlZDRDFYQTMxa1FBMUpx?=
 =?utf-8?B?MDM4ZHVRMWFRWmdydFRYd1lOYUJ2cFZHWnRYWHR6Um44aDFEQzhDODdLcFFR?=
 =?utf-8?B?MkdYL2ZQZU9jQWNKRU40SDNnektqeWhWbUVaWmdWV3JidE5lUUp2S2ZNcG9x?=
 =?utf-8?B?UElDRzk2V093dmtiSmx2MGpVZWI0VmNlN3RJN2x5Uy9Ob1ZUcGZjektPcXRK?=
 =?utf-8?B?SWw5bUVWTVJBeHkzbXRmNGRUb3RYcVgrR3FMY3N5K09hREFhUElpb1JGd296?=
 =?utf-8?B?YlA5RFZxcjRwLzBYbHRVRFFoUjd4TXZINnNQUDBCTi9LR0xGczg1c1YvTFoy?=
 =?utf-8?B?OVpHckM1RUEwbHBBTytkdGpQWno3UWxGdzJwY3Fya0hENE9xSnBNSmFxcFBU?=
 =?utf-8?B?MERINjVWbE9renZQSmdYc1FIZ3NWUXhpTGR2TUp4QzM1VDdJZDJjU3VLMytq?=
 =?utf-8?B?b2l4SkdSNVZnYitha0tXZi91Y1VTc1V4V0NNcEwvMDM4Qk5ZRWdoZElLWXF6?=
 =?utf-8?B?RlMvc2FSRkRWbUl6TEhyY0wwYzVPRDZ3eTMxSVBlN29YUkYydThpbzFyaXky?=
 =?utf-8?B?SkFVMWlXU21EMkVObjdmbUw5Y01KR1VsdnZJZGNJS1J5V1kwTU5GTC9KS21X?=
 =?utf-8?B?b1ByQnBaRHNGSVFieWZxLzI0UFd2UitWTkE2dXNKdXVGbndlSHdEVGZvWjBm?=
 =?utf-8?B?c3pqc0FwQzFQdmN1akIyNTQvbWFCOWdzdVhpMkorWHNaZmZkb2tBZURnVDda?=
 =?utf-8?B?SWZ6amx4emswdzFwT1hqTTZMdC9GOW90b1dJU2F5L2FVclljR0czRkV3Q1RQ?=
 =?utf-8?B?U2lFamUzYzVqZE9ibGdzQzVvU0VvZnp1amhQWkV3L1NPZ2EvYk1jTkFodmZa?=
 =?utf-8?B?OWkwdzErYnFwSk1nUnl3OUtiMXJORWcvL0o4cHkvTERCQXNkTVIvWW1OUkVP?=
 =?utf-8?B?MVF4d0NqM0NBdVM5QzRZVVA2eUI1MmoxdHBUOFB5aU5WLy9TdlVBRnlTUDR3?=
 =?utf-8?B?b1RVQmIrbTVDWUlKZjR4aDdUU1UyUWFCNitwcGxpUGl4NmNtNFlhU3RvTC9p?=
 =?utf-8?B?RjFOeHVIWklCWTFyN1pOU25RYkNWdVBjenVxbG5ieGg0cnNDRFh6Q0VjcTg4?=
 =?utf-8?B?MSt6dTNMOHBnZWxPemhtbkxtbCszR1NwYjhzTlZwSXZCdWV4ZTBQaDhXa29B?=
 =?utf-8?B?WG1zVW93MXhGV1pvTXZ5MDZNZS9JZDJpaUxRdnh3bkVLeGsxMUR0WHJZbkRY?=
 =?utf-8?B?NXV2SDlyZUVJZ1E0WFZZUndRWlRCdWZkbmJzRVlDTzB5Vk9RSWV1Skt2bDdX?=
 =?utf-8?B?ekc5WkpYOWhXcUZUVWx5UklkaGRLbFVnWWltVkI2TG85ZUUwNWphTGRUUlBE?=
 =?utf-8?B?N2xZYkNqQ0pKUmFxOVNwcUQ5VVhwQldyd2VVRlpvRlhCdkNNeFV4UktzV1N6?=
 =?utf-8?B?K3NNYnQySVhrY3lFTndocWVrb0lUZ1oyNE5kMHJxZFJWV0R4SUxYbVVrTC92?=
 =?utf-8?B?ZnQwQXplQ3hKNENMdE91VlMvVi81NSs2QUdwT0lTRkovVDB2Q1hpQ2V4OXBj?=
 =?utf-8?B?OFdZOXhOdDM2ZUdXV1VobXgvb3Z0YTNiTjE3UFdOKy90a29yeVR4SnIxVVdk?=
 =?utf-8?B?SjFRV1ZmajBSMUFMR1gyT3Q1L2tNSWI4aVZnZGNvbHIvQXN6VkdqT1hQVmNo?=
 =?utf-8?B?VHp6Uk5PTVplMUJPcjJyOWVYc25wK1dQei9HRVhpV3dPUHlBMHdzN2NmYlBt?=
 =?utf-8?B?U0dNMk4vZmhyL0Q1ekV0Z1F3MHFnVEVRNlZKVFBVdU1zTk5LdzhlMkd6bDJE?=
 =?utf-8?B?cUI5L2FPU3l6eWZsL0FUeTVlQzhvWTh4amFFSXBBd2xVeDBPaDJMcjIxMlRr?=
 =?utf-8?B?QkhJY1FraDBjd0l4WE5wK3VaYi9aQjEvSjRUb3ZuZjY3b09VSndFWnRmK0Qy?=
 =?utf-8?B?VWdLazRGTmk1L28ySkJLV0Iza3dodlVZOGJmV0dlVXNYM095TEdrQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e49691ec-661c-4b70-be61-08de52246b00
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 21:49:10.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDQvTYLPJYofYPPZOUw7s423yNg5zgwKhyJVMa1HYyhimEfbahqrW3USfvDyHV3hhuIQLgWCqowgPvkRPGLl4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5056
X-OriginatorOrg: intel.com
X-Stat-Signature: n14z1d7isaqk8y33xop51hmjpt7dgrn7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41AC1160006
X-Rspam-User: 
X-HE-Tag: 1768254560-266481
X-HE-Meta: U2FsdGVkX1894xXqL4/L+7T5AIPhjBrBN9nUs9mvH1I9qSThJpcGhVGqUv7Is4VZpTPbMojYx6okArGYBESHTJUfM3cndjeJWUDX0Ow9COZOGHa6t69pcSKiucOrkyX9+G+1OFzDhPyY4QheUfnSgVWlw+QoGaMgN9RjJpPfLTzpr1cGFuvWKltBOyvBDN+DANkG/gvGDhkTQ6HmRp7Uw7tI1PPDzzYo3d35TyzMJbL07l/7J35PqJULgNpdnvA/sq8Taz90tISkXwYY087Y7p1BHMouH805qIBZ5kmax06ARhGDjT2oGOueXK7TAAlQA7aftYq/1ZTkniuYKMglkSStDur7kdigoOnP6uSrlroDOgGsVTtJCd2R3WS/19iX/R+5YuImfMHI2rTYePth/lotOlB2WANc0nXo2RI2N4mkWQvWGUGtD+QupvrBASeyWlAuhuJHMJ2L/ccdgR0g9EVvgXxyH/rxSLY3LGg+0zDtlFqm9HDDRlPvG6bhw4Fi8yjHYxI4foiL4pmjfU++YOOEuCwslUDkhxjjEduWGwDp/VGz/gd1phID1A/LI5p0bGm8I5al/sihSCVaKzuYH9gCoPnj877540sdDDm5FqVHICokRhQAxumZC5/JB9C/LwkNTQehjHwWn5Blmd2ouTF2XriRxumIhyObyLCyWiFWKZb3G8Jmmov4NbxLufkMYuuMFYDEgIhvCqW6nyncPciwtheLZuLMlZLywvPXOaMffzmuFkVhjJmN7xVJJzTQlUv53Bgx4MyRAdwUTnu8/ckTqG5Utxrha7wywFsr/7oGpLpi1gsL/nsVQhS8KV4K9Ps7G4gvVTMcu3FUqKyDmm3LIZ5dqeOlJeYH38huvefJWCYE8HiL+dWN5Y84Q6QWXYRIvoqbrBFpy7dRDcJnoouTQ3A34ccw408gwvHBR/2qIDShTDQoMzVneLMqZJEKcsqSiJ4s5DPPE2QL9Ad
 oD59uMnM
 Nmp6pAUnL2K+CQHylcxJtYTUx2xZHL2QydtOq/5hCMb6NypFsXhliiGXP/xbtgacns6qeylHYLFkXYluVeeBZZRyxgIEWFR+8tEsm6D3+CgR5oLAIsUTihU4B+n49gGOWwIjGsgRIWcmrSi7tlP2uVV2npRXw82cmTlTFKkgVrLtqNhAcpJ4++FxxXCj78VG4B9Ph4DpqdKwRH6IQ+5qNr9KV96s89UZkLFLo5H5D7nanfnL1K8s+UMJITHq7cKsjTc/yHCDJi8Wbrj8CzFd1lEg5Dv1LyhnSagPOjR76T1tmG2+E6Jf6NjoH6exTQzrkM+eUZnHAqfA8m6vWw9fwylkwgQxPUtaTitsJbTPfIgYC/6eRKXCmv6Lp4wnJdTrQJOKkgxFKVAUfGMBC7bNjNpfFGvOKv9GFF5mfzdxr1oG9yf0QO2+eEsnNMsHpYqpn2p9bt1k4oNPHnFU4+r2pIf2LP45FwfUl+Fo6jsw5Bkvh3iab5+wGK+y5wRzEf7NckZo3pZMlvr59w/roX4Qa2ytIXTOy8nWbT+dF4LU33La0L73uU4la1jvOC0fiowMYsinL0r4lVdPwpx1fhrw4K5omyb/vYCvoFt1mPY1xhD0zdaI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 09:45:10AM -0400, Jason Gunthorpe wrote:

Hi, catching up here.

> On Sun, Jan 11, 2026 at 07:51:01PM -0500, Zi Yan wrote:
> > On 11 Jan 2026, at 19:19, Balbir Singh wrote:
> > 
> > > On 1/12/26 08:35, Matthew Wilcox wrote:
> > >> On Sun, Jan 11, 2026 at 09:55:40PM +0100, Francois Dugast wrote:
> > >>> The core MM splits the folio before calling folio_free, restoring the
> > >>> zone pages associated with the folio to an initialized state (e.g.,
> > >>> non-compound, pgmap valid, etc...). The order argument represents the
> > >>> folio’s order prior to the split which can be used driver side to know
> > >>> how many pages are being freed.
> > >>
> > >> This really feels like the wrong way to fix this problem.
> > >>
> > 
> > Hi Matthew,
> > 
> > I think the wording is confusing, since the actual issue is that:
> > 
> > 1. zone_device_page_init() calls prep_compound_page() to form a large folio,
> > 2. but free_zone_device_folio() never reverse the course,
> > 3. the undo of prep_compound_page() in free_zone_device_folio() needs to
> >    be done before driver callback ->folio_free(), since once ->folio_free()
> >    is called, the folio can be reallocated immediately,
> > 4. after the undo of prep_compound_page(), folio_order() can no longer provide
> >    the original order information, thus, folio_free() needs that for proper
> >    device side ref manipulation.
> 
> There is something wrong with the driver if the "folio can be
> reallocated immediately".
> 
> The flow generally expects there to be a driver allocator linked to
> folio_free()
> 
> 1) Allocator finds free memory
> 2) zone_device_page_init() allocates the memory and makes refcount=1
> 3) __folio_put() knows the recount 0.
> 4) free_zone_device_folio() calls folio_free(), but it doesn't
>    actually need to undo prep_compound_page() because *NOTHING* can
>    use the page pointer at this point.

Correct—nothing can use the folio prior to calling folio_free(). Once
folio_free() returns, the driver side is free to immediately reallocate
the folio (or a subset of its pages).

> 5) Driver puts the memory back into the allocator and now #1 can
>    happen. It knows how much memory to put back because folio->order
>    is valid from #2
> 6) #1 happens again, then #2 happens again and the folio is in the
>    right state for use. The successor #2 fully undoes the work of the
>    predecessor #2.
> 
> If you have races where #1 can happen immediately after #3 then the
> driver design is fundamentally broken and passing around order isn't
> going to help anything.
>

The above race does not exist; if it did, I agree we’d be solving
nothing here.
 
> If the allocator is using the struct page memory then step #5 should
> also clean up the struct page with the allocator data before returning
> it to the allocator.
> 

We could move the call to free_zone_device_folio_prepare() [1] into the
driver-side implementation of ->folio_free() and drop the order argument
here. Zi didn’t particularly like that; he preferred calling
free_zone_device_folio_prepare() [2] before invoking ->folio_free(),
which is why this patch exists.

FWIW, I do not have a strong opinion here—either way works. Xe doesn’t
actually need the order regardless of where
free_zone_device_folio_prepare() is called, but Nouveau does need the
order if free_zone_device_folio_prepare() is called before
->folio_free().

[1] https://patchwork.freedesktop.org/patch/697877/?series=159120&rev=4
[2] https://patchwork.freedesktop.org/patch/697709/?series=159120&rev=3#comment_1282405

> I vaugely remember talking about this before in the context of the Xe
> driver.. You can't just take an existing VRAM allocator and layer it
> on top of the folios and have it broadly ignore the folio_free
> callback.
> 

We are definitely not ignoring the ->folio_free callback—that is the
point at which we tell our VRAM allocator (DRM buddy) it is okay to
release the allocation and make it available for reuse.

Matt

> Jsaon

