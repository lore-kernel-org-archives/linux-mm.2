Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E77D625F7
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648A36B00FE; Thu, 22 Jan 2026 02:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6576B00FF; Thu, 22 Jan 2026 02:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4946B0100; Thu, 22 Jan 2026 02:19:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3583B6B00FE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:19:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D808D1A0161
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:19:58 +0000 (UTC)
X-FDA: 84358750476.16.0D1D0CF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF805A0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:19:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYFl6wGl;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769066395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vpp0BjdYaSjPEGTyUrlUM8/7+7yMaOLnIOsUBtvsURo=;
	b=EmYYsBJDjc60agb6HQY7SOfTEF7L/Z4gd5G8vUVWsjgGxeTpDVEroNkm38a0d/NqyO+R/z
	N1Z9daBKQprg1PlPTBi599oiI3tpOeP4kFDTwvLx7NrTUX1sDMPgECnV8hlEXvBn1uGzr+
	8m432vTTRIliwFCpGoy7d1/vOD8ciYc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hYFl6wGl;
	spf=pass (imf25.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769066395; a=rsa-sha256;
	cv=fail;
	b=pEUaqof6U6zwC6PovRgKx8PFM/pSzP2VarHgu5qIfMqTumg7coOb6biiXITJgRqKD8KdG8
	npzvkA2XgbFX5D2OYNfxwOnS5EQMnhrruLWd65hnQchZrFcUqQz5mNqNQPtPpYF5Iq01/H
	rqoFDD2FYWpv20ink874hlx9n+L1UoY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769066395; x=1800602395;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Z4QkvA6YaSEHgRxKpZoqYM/SfzsRr/RZN+7cnihz+mk=;
  b=hYFl6wGlQ8MGOUwUwL3CNvRbLu9/n0wi3QNS5D+ZWdQNn27kiL5tKOoV
   PnyhyAGNGBzqibJjpz2pmVPANY0knKzsRbe4h7RpBbSH0daakuxkkgL2f
   FbboMZmQCNUfBOsoxagqgLHPFKrGW6uAPtQW5ehNAPPu0E980J6SySYrH
   xJZ8UV6z+mgKeYHb8kqLyh4g2UAaqP2n48GfuiEEnZvzWTlVY5T0C5WM1
   23lVcEYJh+aKQGIMr4R/aNttHocZ3u2cbN5Skg0qy/akzqxAG2+aHHsW7
   ZeV2rLyGTPa2K/5//cLt7j5t/PKccVRU9jRr/XRkeWMzIsTh0+zx1rHrW
   A==;
X-CSE-ConnectionGUID: fynfuj3qTxGPTtPhWP8aTA==
X-CSE-MsgGUID: P5QSoFpMRD+LEo1gv+phGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70218622"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70218622"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:19:53 -0800
X-CSE-ConnectionGUID: hA7pCq19QASVCx1ifvFYBA==
X-CSE-MsgGUID: 4FN7r2WrSVKLSM0oDeU4pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="210814141"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:19:54 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:19:52 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:19:52 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.29) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:19:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6JVxiDpp0blTDAC8M7h8LD6Bxm7DZMQylLc+GaVZyevuE2udlAELr8SSeYqS3suJ0Y1lo7ErqK3y+0WMLsT6yHsqzoS+6jmhMoVR6TdUHgoSqZkghaJmB2+vgjkeBI29lBqcevrRZqxAKDGsbWZfmQ9uvhPT1TtDpOpC9fxtlzyIbB7BiiaWmyBgfjAZ28drQ7ZaC43obDWIZZ8GD9yq4Ls64Tb49lJsCcQ+5CDVA7VWmSsfLFPS7vmC0w7QiWEQdkcbNwZRS/smrlMgYs4yzKuvoXMjiT37FR4ureIY7ZvYqrS8Byo40mk5t909FSHd5CwfTUCR9O/FOCLiQjAwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vpp0BjdYaSjPEGTyUrlUM8/7+7yMaOLnIOsUBtvsURo=;
 b=dflqETHieaLEt/rm2cu9rFWdrEfrpr1q0QS+UmewTCjDzw4VglCuImX9A07dJ7X8HF2jidfd8GB402+Zpz3XU94uCuUyIkBlSU14jWfExHbQFMVMnjOAeopXYoBpCU4Y5mYpjNaVZ7to0Hsd1eIIrnEM8jpCSxi+5QLAY+gRLSecj5RVQCzyFxSAMZreTJ2WAb6qle19WmF1BNZOCVYbPJyn+HSnfQnKON4WCCRB55gXKwA1Ht5h6KkJc9h0dERcM+pOgB/gEEs+AIilXClwcHJbWdIpMT+A+rTA5dslZ1KBe8DRMDcjOvF2lJ8+4T8nUrJYidx5iC7Fyww3wKJkRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by MW4PR11MB6982.namprd11.prod.outlook.com (2603:10b6:303:228::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 07:19:49 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 22 Jan 2026
 07:19:49 +0000
Date: Wed, 21 Jan 2026 23:19:45 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Zi Yan <ziy@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>, Francois Dugast
	<francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
	<Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Christian
 =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
	<maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Leon Romanovsky <leon@kernel.org>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<nouveau@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-ID: <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
References: <eb94d115-18a6-455b-b020-f18f372e283a@nvidia.com>
 <aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
 <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|MW4PR11MB6982:EE_
X-MS-Office365-Filtering-Correlation-Id: e45038de-e53e-4b57-9ca0-08de5986a0f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?czB4ZjRQd1M3MUxTMkU4Y28yTWJ6djdHa3VaUXkxV05CL2VaS1ZDNVBwQXlw?=
 =?utf-8?B?RVRXWmtEYW5kTndza21lM2NRcFdpWExxUVNmWThFTW5WWmNYd25VVGdBRC9w?=
 =?utf-8?B?RDRCZnZoaHJ1RVErbmgwSVd4OWN6ekZGbmlVdzBWV3VRVlZmbW9lWmtRZlZR?=
 =?utf-8?B?L3JROE9ieitHMnF3dk9FOFk2b3BKQ3ZuTHMyYVRIYjFUMjN1em5NV2x4SHQr?=
 =?utf-8?B?QmdRRjdJV2lEK04vOXk5ZHIrd3pnV2lLRVJ2MVRKODFLZ1pVdzJLNE9uL00x?=
 =?utf-8?B?RFF3TVREaHYwQjViV3lWYjNEU2ZwVTJLWGVldCtoVk5JRngzenp5VkE4ZE5y?=
 =?utf-8?B?b0pOdXoxRE56MC8yemVZUDBpd0ZzbXB0YmoxZGxNa1pKTk8yd2lZZUFYd3hx?=
 =?utf-8?B?bmZDTmYxYk04aDVTb0d0MXkzZjBHVWhlNXozQmNlekcvYzhWVlF0Q0RwTVlT?=
 =?utf-8?B?MXUwY1FoaXNNY3BTUzZiaUcwcDgrTnhpR0pJVnJaVTBqL3p2LzVsQjdwOWNK?=
 =?utf-8?B?LzNWdHpUcERWZURGZ1pUZW56NUpQOUxCTTNFU0NmUVFTZU1BaWhjbllLZDBv?=
 =?utf-8?B?Z0hFa2NkZVFVNkd3ZlFzdGduMUFaL0thR3ppdjYvbmtiTGxHUHlkUWhEUXZm?=
 =?utf-8?B?UUZCOTM3MlJLcTR3RGZjNmVzY3B6K3pSd091akNIZFE4RWtIR0VYdmVzU0oz?=
 =?utf-8?B?czBoWW84eFdVSmE4UlRYYm5KS0p3bFd5OGpCOGpDKzhZV2N4SGlrVG1scENz?=
 =?utf-8?B?cVZWYkUxdDZuZExyOVRCc25COUIzVkF0N0o3b3IwN084azhPUXdrWW95QUFV?=
 =?utf-8?B?S2hScFlaOFdpcTVhWnVjVzN3VGpmdlhzRVBlMjNxcDZDV2hBRkJHSTZlTU5l?=
 =?utf-8?B?TVZyTkdkbHU4MmJMQkpvL3Z3YlNCbENWUWFOK2k5Qmx6dHg4eDV4UFl3OHhT?=
 =?utf-8?B?a0NrK2F6SkJSd2gxbTROZVpGTjk5TURxTWZoSk50MWZ3RzhENExxbXhxL3FD?=
 =?utf-8?B?Ny9GUFZEUU9PWFdZMW9oc3g0UXorcWl5eUFOQWxtMWhHN2xxeER4OTdsUy9R?=
 =?utf-8?B?SitRVjRMenErODN4SVEzdktjekNJZUNsVE5iWWFsL3JEVlcxcFAveDBpdHh4?=
 =?utf-8?B?QmkreTlLcDhQc1hGczczeFdTWFUvd2FhMkZFSk8vS1BrdFpDQTlOREpRYlZR?=
 =?utf-8?B?czFuRyt0eEdremQxMUMyRzUvUFJ1UGpVakQ5MHZIRTNaNHQ1cGxhMGhBakgw?=
 =?utf-8?B?SHBSR1I5d2haMkRkT29YdU5hZ2h5RzRoeElQbHpMSHUxS0ZHNXVvTHhsd3hX?=
 =?utf-8?B?eWJwNFUrV0VtejJLMURlcjZ1a25qV08yclRLMGlOczBhWmNjNHhjemtzVGNL?=
 =?utf-8?B?cUh3M3hUQXl6Rm9acmc2OGkyWVB3a1NiZ1c5K2pjRWRQMXlWczBwczN5V2tT?=
 =?utf-8?B?MStzNlVLbWZKbXN0SUwrRTVwYlc2MlZKUi9DWHQ3Z3VXSkhZTTdubjVjWGtu?=
 =?utf-8?B?aExNbHJHVXZTNjAxT3R1Tnh0dzNOdmdkc3RNUk12RmtyTHhlemdDUVJxUXVj?=
 =?utf-8?B?VzRUM252QzNXbC9WRVo1c2ZRSlZRa0VHdG5PcEg3WjU4WFdSbHVVMHJyYjZ1?=
 =?utf-8?B?UWhYNU9RZjdXeHJLVnJFa0drckhFWmpwMjRtaDdtRkpkaWZVUmRKODVxNUdN?=
 =?utf-8?B?ZFptcmFEY0VHTDNWdUNrc0ZuYm9hUTNpY3RzN000dCtLTVAxK3B4RWVkUjZW?=
 =?utf-8?B?d0RNNFJsWDBxV0J1YjRNSm9xU3lBWGd0Z1ZpTXN1Vldyek5NZG9LVmlOL3gx?=
 =?utf-8?B?OWcrcENrWVAvYUNKL1dRTWdOTEFKS283WHIrMHE3ZGRhVkFVd1p6Mk14bk5C?=
 =?utf-8?B?b25EbFZhZE5BZWJLc21URklSMjd3VlU4ZlFVRXdocG94QlVpbzVKTGJxY05v?=
 =?utf-8?B?bXVFUVlLekRpZ2lDUlluRERheG5GQm9MNlhuY0R4Qlc3YVNudXlhUFVjV3hy?=
 =?utf-8?B?bndERFZHaHVJSVZOVVhFTCtSNW45dlEyci9sOG5xeWRKRXFWL1YxeGNpeEZx?=
 =?utf-8?B?ckFFR3lvdzB1clJuNWVnalhVeG50V2JBaVFhVUY2ZjZkV3JJVldwMjF2akI2?=
 =?utf-8?Q?T1QY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjM5cXJubmhQRStXUzNhRk9HRlZ3TmhMMWM4UXNKd3V2V3hmQWZuSk90UU51?=
 =?utf-8?B?ZUNVMklXSk8yT1VZU3RRYTJaYndjQ2MzbE8vOUlQbUFvVjdoSmdiN25QQ3Y2?=
 =?utf-8?B?YWFzRE9FWDRXWmg3aDQ5dkZ0d1ZHY3g2Y2tBTXVqTlFmNFhFemhTMnlXN1pt?=
 =?utf-8?B?eGE2aGtYbFVpRm5LRThrK2hubmNPREVoK2h4WCtpME1wN0ZRVVdkL0NpdzVu?=
 =?utf-8?B?VjFSeDY2TWdYZnp1Z1htd3NuSzBpSGV4WWtpdm5XdHJrTWVvSEZRSCswQ1pp?=
 =?utf-8?B?WDNUck9LcVFOT3NuaXRvZDJzNWpWQVRCcXpxRXFBVE9NKzA3dUxzRWZsWDNC?=
 =?utf-8?B?Zk05VlRMSDZwR2tJVUhCRHdJQjk2c1FuZ3M2RnNCdTAwRCt0dUF2VXdIZUJz?=
 =?utf-8?B?d2F1UnFabTdmMHVPVWJCQkFaRFRySEJ2a3NoeEU0TnE0eitnN1NqdjdLeEt4?=
 =?utf-8?B?VjJXUzA3ZlRsTUFtQVp3NEdOc2hIQ3hsSGVyT2xhQ1UrZDVJKzBhbG1CV2Fr?=
 =?utf-8?B?TWZrbEVmQ2RqQW1DTUw3VXNKQ3lzcmg1TWZESm5rUGdLZFI3bFlETUZDQjhJ?=
 =?utf-8?B?UDhaS1BBTG55K3RuZEZ2NmhQNWhsT0d5S3M0K3pkNVZQNXR5WjllaHJPZGk1?=
 =?utf-8?B?NEZsd2N4bnRldThhb0FXZGtnc3c0S1V6dFpWcnY0dndvU2NQTEc4WFNkTm15?=
 =?utf-8?B?K2dwVFNGZCtobDRzZ081UzdVdE5wLzh0dEsxYnQrRmltZUxwaWVSUzliZHo4?=
 =?utf-8?B?MUc1TWFjRHdWcjUzNnBYNURWRTRRYVUrTnk1Q1VuTnR3VFByM3lOWE1KR0pK?=
 =?utf-8?B?MmJxa0NEbytibmlJU0cvTDNMWGxYK1VhUExjVnAxUlU3djVoL2ROZU9tVzlP?=
 =?utf-8?B?Y1F1WFNjMHpUY1R5aDBCbXhsZFlkWU14MFlBd1JoMnlNV0RrblNlQ3lkc2J6?=
 =?utf-8?B?a2pjNFkzaEhFWUhIekdML2dTcTJHaWpUT1J0VTBGMHJXVEJ6aGpBbFk1eHpy?=
 =?utf-8?B?aDZGdjF2TThMUjY4dENwdVNMdU1QZUdxbW0yOERxbXVTUDVPajZRaU5nNjFo?=
 =?utf-8?B?Nngwd09IWXY1aEF3c3JWRnVzR0JiRWNTVEdqWW82dG9uQUFmV250b1NJTEJK?=
 =?utf-8?B?WnZTeGY0SUlMMGFEOVNCclByTkxOZ3ozY3lBcmVUdTVUT0VkVnhteEhIdTE3?=
 =?utf-8?B?NFBBdnFTc09VWGpKOVlWNUxlVGlYaW5ldW85SlUvRkt0MTl0Zyt4ZVFNeTRv?=
 =?utf-8?B?TGYxK0xqRlRmZ0dtTWlGMHVZeTdsMzhzWWJkeVJ5RUEzWUZXTDN2cTlhTTFQ?=
 =?utf-8?B?ZVRoOUZ2RTRaaS81Q1ZEaUVNZlNKVHF6QTY5SG9xdTh2ZXIrWWdwbmsvSDA0?=
 =?utf-8?B?bVpOd3NLUkRJMW41MS9JaTBZYlh0WVU3bWVXZDZYMjkvdVUxam9LMytVQURq?=
 =?utf-8?B?NGJtVzJINE9vYm9vQWlvTXhJM0U0ejAzdnNHQ0lFWHM4MGZVakFOeWVKQ1d5?=
 =?utf-8?B?eE9OSFhUZWdueWdCWlRXaTM3RHNLWXp0NnVwTUJpZE9JdGIrVk5yaS9JSDl4?=
 =?utf-8?B?dkxwQ3N1QWlyR1ZMYzdXbkkrVWppb0JEZFFwaUk5M2haQ2NjU3JqbXhmSmZD?=
 =?utf-8?B?cEpSMzErWEN1Q1JsM01wUlgwQk4wWlU4RllTU2NaK2IwK3FPVGlMM21DQTk2?=
 =?utf-8?B?V1NveDVnTm5Zdk5WVUsrQzJwV3VEM0NGeWduTi9MQ0tuMG55Q3BvNHRCWCtu?=
 =?utf-8?B?K2lFTXlvUFhJUUVsaWJJdVZFM2U0WHB2eDhpNk9KL2luaVJIRUdLeVdScVdX?=
 =?utf-8?B?eG13b3gzV2lKL3RtN2s1VUpGZzVjZFFvUVVQalhOWmJCd2lKWlVWZDZpQy9p?=
 =?utf-8?B?NmJmaTRQRlRJemxuM1F5MUhvN0J3MlBBN3F3ZFptZmNLYVVBN3FEenVCVFVJ?=
 =?utf-8?B?citnSGNVSXA5TDF3aUU1MitCK0NHeGs0VVZ4VzdWNVh4Q3V6VmM4ZmhXRXVm?=
 =?utf-8?B?K0VVd1gvR3pZbWZkeGJORGwzQ3JMaFh6VTRCa2NKQjNuaTlGTWNyZkg1VmJ3?=
 =?utf-8?B?SHp3TTQwV2dKTURSZzJIWk9BQlZaY1h2UENPcVN1SzJHZnZuRkZ3KytaWjUy?=
 =?utf-8?B?V0tJampJd0lQa21IZ1JrZnhiazRCSWRUZDhWeWVrRTJ5SlhrbGVDQU5LTDl3?=
 =?utf-8?B?eGZRbGNUeXozRnVrUDUvaFJZQUNKR3hzVVhGVk5Ba3VsWDNPRnI4ZDRhT1Rk?=
 =?utf-8?B?dTQ3WUg5QVZrMllIcGcwSW1wQ25nakxPekFWS0habVoyVmtzM1I0eVRtTzVO?=
 =?utf-8?B?Q0RVdGJnUVdXTWcrcy8wODZydkFqU3UzYW9XTG0vMUZVdTFFUmxoUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e45038de-e53e-4b57-9ca0-08de5986a0f0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 07:19:49.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cc8SrTJ0ZKI/r8/uxaSMVB0s8p9QOzuIsG9Oy3AH3emxPKc896u89OWizXx2KiCvn2hNWomUJo119STW+5Tawg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6982
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: CF805A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 4igcz98budycdh6ws5m1wffghfeqach1
X-HE-Tag: 1769066394-846693
X-HE-Meta: U2FsdGVkX19SjDBWu9YParoh1LzCgLG6bRyq092qOYpShKVIPMZoZPInOQ07Szfmz7sgtnOJBv/ei3OTsVFV/RPdQm749kIoDfcN8LFM1AL5F8VgO6QQV9x9/0nSHa0vPgyOCf/i9K1P7L5la1zkwN0dRfLoGd1hrXPAjbf3SHmeTcLavkp2feVKRh8dzv277zD9ZVXoCyK3CIe/AXnBJnOE4iX++q0jiDY1e9g3CaM45QP+sgMd6XBiQl1Lh3xEaEIAw2absXAMzN3oqknSTHGapET1QEceRAR5gPJMoqgUJDqhUYtDwaR5fHVSZCbz3gpa/4DAeFD3YPlhU/I6uOXruwC4vji/7TLlyaKHAQQ2fhP3DOCuiHy9s+L8VyyeSfAPEt6Paxv9SvER7bpYRlXs64zhgX3RSWnwyI0iCdPN6JFhgMUsWp6JpTYk0iTcfUUzdQ1Jv7uuoRiNnfu3YZM36VWN2ccJafPhZy2zAjGDIYZ5190H2m7Fpy7+Yc2TALGHjk2SQJvZyop8qKzaxgWcSeiaBMNXq04Lc2mLy5YYvxCZ1bAERLRGL1uOCPbzWKpzy0wLhhbhrSF539GXhBH35pyUSckNTdTO8jmzOtGFmHnmr7bH30HrAg83FUd7oc+kAV2CzZzI1NfKl20lAU9C6FNJNYXETm4a5mt5tpocZJgly2opD4JhRc1Sg7SiAF51qfbV2ZKKxK1tF5VA/JLSkuAS4Yn4lfr9fyr458W306/Og6SMz2GsVIUW2o1VA00S5yQDXFvD3SceFEulELnQ9uK+/eZ7FN9k3WeEGgPNxVygAxJMXTshqICYOP0/3zdUbz88qiDLjZSMFMxXUo6ReJfKKcY5UO1w3cRmRgsH+Wket36Mg83mGFAB7JV4PDl/gXYq+5u6Se1PFOBG/KHHRdClHJTqdpbJNOV/q1TwtiGc6BTGaPTAaD8Y1aRT4tzcWIrgEYm+q2ut/Nt
 Q1m5tLbn
 DuvVLpC84KprIIqDJGeej6Jdzi+WNwcNagJo2DP3NCZI0FHi3dkd2/qEc+CB2trOiWCDCaa6u5ln0m5BXl/ZCo7adyf/zbjBnfWApVfVTMKGMsPkC9k9ox1R66Filqbr2wjg9t71hgyt9p9IqMN5TY7kp8t5IB4MgcbAoROgYjrJGfxXz/4WvKqscGtr7H7ZW4imUlDB4veEkToOt+tsmPwjrsNw3Gu7zOuy8nW0bVhdbJOo/GqFjp9TZp9x8n+DU2CaaG2Mf+5ZKSXn7YD20K8WewB1rFu4FG9zmedk4UdphMB8IjuJzCZYzQ1D4XRpEoVLMdy1eWokIcfINxq0Agn+3eR39ue+6lBif9yGJ+OpVqBO9i9PlYK70MBtZiMzKC0Zx7E472un5n/cU2pN0tkuXc3uP0dI3bZMAVroDMDQRHHswoy5i767Xx+dZuRfSI1IIEBg2qYpHyMDgdCmvB6VZPvHDbSYbgiNF8qV6lRwfswUKu6ifz89x5irAsOeCBJz83kiNW6pIRf7qiYmqKLpbQoLyrWrNTqabn/TTqzGafMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:01:18PM -0500, Zi Yan wrote:
> On 20 Jan 2026, at 8:53, Jason Gunthorpe wrote:
> 

This whole thread makes my head hurt, as does core MM.

IMO the TL;DR is:

- Why is Intel the only one proving this stuff works? We can debate all
  day about what should or should not work — but someone else needs to
  actually prove it.i, rather than type hypotheticals.

- Intel has demonstrated that this works and is still getting blocked.

- This entire thread is about a fixes patch for large device pages.
  Changing prep_compound_page is completely out of scope for a fixes
  patch, and honestly so is most of the rest of what’s being proposed.

- At a minimum, you must clear every page’s flags in the loop. So why not
  conservatively clear anything else a folio might have set before calling
  an existing core-MM function, ensuring the pages are in a known state?
  This is a fixes patch.

- Given the current state of the discussion, I don’t think large device
  pages should be in 6.19. And if so, why didn’t the entire device pages
  series receive this level of scrutiny earlier? It’s my mistake for not
  saying “no” until the reallocation at different sizes issue was resolved.

@Andrew. - I'd revert large device pages in 6.19 as it doesn't work and
we seemly cannot close on this.

Matt

> > On Mon, Jan 19, 2026 at 09:50:16PM -0500, Zi Yan wrote:
> >>>> I suppose we want some prep_single_page(page) and some reorg to share
> >>>> code with the other prep function.
> >>
> >> This is just an unnecessary need due to lack of knowledge of/do not want
> >> to investigate core MM page and folio initialization code.
> >
> > It will be better to keep this related code together, not spread all
> > around.
> 
> Or clarify what code is for preparing pages, which would go away at memdesc
> time, and what code is for preparing folios, which would stay.
> 
> >
> >>>> I don't think so. It should do the above job efficiently and iterate
> >>>> over the page list exactly once.
> >>
> >> folio initialization should not iterate over any page list, since folio is
> >> supposed to be treated as a whole instead of individual pages.
> >
> > The tail pages need to have the right data in them or compound_head
> > won't work.
> 
> That is done by set_compound_head() in prep_compound_tail().
> prep_compound_page() take cares of it. As long as it is called, even if
> the pages in that compound page have random states before, the compound
> page should function correctly afterwards.
> 
> >
> >> folio->mapping = NULL;
> >> folio->memcg_data = 0;
> >> folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>
> >> should be enough.
> >
> > This seems believable to me for setting up an order 0 page.
> 
> It works for any folio, regardless of its order. fields used in second
> or third subpages are all taken care of by prep_compound_page().
> 
> >
> >> if (order)
> >> 	folio_set_large_rmappable(folio);
> >
> > That one is in zone_device_folio_init()
> 
> Yes. And the code location looks right to me.
> 
> >
> > And maybe the naming has got really confused if we have both functions
> > now :\
> 
> Yes. One of the issues is that device private code used to only handles
> order-0 pages and was converted to use high order folio directly without
> using high order page (namely compound page) as an intermediate step.
> This two-step-in-one caused confusion. But the key thing to avoid the
> confusion is that to form a high order folio, a list of contiguous pages
> would become a compound page by calling prep_compound_page(), then
> the compound page becomes a folio by calling folio_set_large_rmappable().
> 
> BTW, the code in prep_compound_head() after folio_set_order(folio, order)
> should belong to folio_set_large_rmappable() and they are causing confusion,
> since they are only applicable to rmappable large folios. I am going to
> send a patch to fix it.
> 
> 
> Best Regards,
> Yan, Zi

