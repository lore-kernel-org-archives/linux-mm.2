Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0E1CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0059F8E004D; Tue, 19 Aug 2025 11:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FF88E0007; Tue, 19 Aug 2025 11:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0018E004D; Tue, 19 Aug 2025 11:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4E648E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:36:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79BAE83CAB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:36:00 +0000 (UTC)
X-FDA: 83793907680.09.C594A0A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf19.hostedemail.com (Postfix) with ESMTP id 887761A0019
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:35:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="j/a4Ceo/";
	spf=pass (imf19.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755617757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0j7Mc43s1Z/cXYaOpoht8iA7j7PdICPBtnxBpSdCzY=;
	b=EcMGY14H5evR/9B9csXOqCaNwg0IgQwzM4+uMZETh1BVANc8bEKly8ar89lKKPkkNPmulj
	85iVaHAdq0ggFgkZHtcBlAyhd+7xQGkFn/UqOTSvGnRfEZk1Zrqkg3vdCz0x2i+yNw/xW0
	0ynbBLyrlFqS3U82REXyojsqisIHOI4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="j/a4Ceo/";
	spf=pass (imf19.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755617757; a=rsa-sha256;
	cv=fail;
	b=Vf+VFhbOFG2JBfteNqG2elstDCjPfkDN3yOvGFeQjUeYTyt7InmU0t9Dg36MRusTWze3yj
	UIczjb2mPKqf3yP2il9TYFSXs8qA6b7rih5+G+CJF3ho2gTjfU8fmEEqa62McKFMgramMq
	SRKETdE39TGzlYSxDGn2oqa4E1u2FLw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755617756; x=1787153756;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=O/SvzCSthO9X6rOReEF0j0Ol3I3ICKqrHNtpif72YPU=;
  b=j/a4Ceo/zHct6tn+sQv1oxksFsCTpqHAkILhkEVVMojwxLKjAsmfbyFv
   tT8m6EhEA0kXxp/1hLUgsx5GFzQkYhJbh1I1xcJCo+fsAEyXB7kL45MxT
   t1/DVbnHytp6bX+DXKrbqw2syhv845U6RtlsCWEPwQ6tMBqSS3UTx1WJ2
   HR/p9L6UkSF1dLCRmT+z1byIWf2WQ6bGUxfIWTuRtGF8PWpUOEBgT5Y+p
   9KTalyt092KGE069WJ6J5henvy5USz6xHQucf3HRACZvOarAo/yABio7F
   oXNX36M4+iHP4kOQmfGMCnYz1/rq2SuI4U7qMlm7P8F/gSDChmY29y9Ux
   A==;
X-CSE-ConnectionGUID: ddfN40r5QnCdqtqkAZxNIQ==
X-CSE-MsgGUID: jrMyd3HZR0enZ6H1UX3qXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="68964023"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="68964023"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:35:55 -0700
X-CSE-ConnectionGUID: qZjuwKMNS3G8Rab9Mvey1Q==
X-CSE-MsgGUID: 72U2PoB4Sma3BqXYUfDsmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="173121258"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:35:55 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:35:54 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 08:35:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.64)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 08:35:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HV4kkARZvpHd3YUP5l0vLABKfhB3eeMg7RUB5nF88jbs5tOL8hZi3eUD3Zd0RxH1nPi5rxUtrV8lEa4TaD8i0XcyjcNgMoUsE1HYquJ/MzazpVTfgXf7r5v82bMbkKzpY7jBMJQFnc7l/J+FWUwdVq07QMyIxvM8L+aJ6v2zo0kqlypxYfhpQ67yfdEM1ID2thKoPsJtZIPChI3qlDn96+kZZbEIMO0PohXJqgu+nLuE5imfFktEmds4Y+xNaKV6ZfgaUpFv89SCcW9msG0HvChefgS18y5knKikPvPS33qhaQ3gdeRT+9UN2aLA2XBWLc7MDHy+xIH40qxgD/FaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0j7Mc43s1Z/cXYaOpoht8iA7j7PdICPBtnxBpSdCzY=;
 b=L98oe/Zs5Lg1l74cDNVcbi9e9kwmahqIyZzCQKWSxCOuIK47/DHhmwXdC5qnMxTWF1932Z4qZ9BLUbhJdne7DV0l8HODXTgZSH9Iqu2RUbPE7I7Hq4N8ca2kP7k3fKJlp01tDypKsCUDR4myAhDWW034a2kcCeOz84H5HPVSDR/B0iWgmaBHD8Zvw+KzfMlW2DwtJqHGoAB0L7WeLzBp9AQ4YqchjKn6WCR3ckws1riIhJLh2RfAx91OFQZ/3XB+z+11kR67awzgNpPGmVxqfqA7vhpNMgn4SKpq96a3AbezcHdfWLGQNz/Jms/P9tONokDegc0MiiTTzuclD+MUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 15:35:51 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 15:35:51 +0000
Date: Tue, 19 Aug 2025 08:35:48 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
CC: Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	<intel-xe@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
	<dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <aKSZ1JduQwAFSFQn@lstrano-desk.jf.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
 <20250818160726.GH599331@ziepe.ca>
 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
 <20250818163617.GI599331@ziepe.ca>
 <aKNYUaPS0PiRk/yj@lstrano-desk.jf.intel.com>
 <20250818164655.GJ599331@ziepe.ca>
 <4lsv2lcd7lssyvcjvkqe4t2foubxbhuxrt2ptzee3csymz5gg3@jwrg3xow72lm>
 <e96dcfd4ce7c84a5b66ff9d5f082ea209266ce48.camel@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e96dcfd4ce7c84a5b66ff9d5f082ea209266ce48.camel@linux.intel.com>
X-ClientProxiedBy: MW4PR03CA0183.namprd03.prod.outlook.com
 (2603:10b6:303:b8::8) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH7PR11MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 584edcfc-7327-4718-fd06-08dddf3613f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXZ6OFhiZkwyUFBpKzdsWE1qb1ExZWRiQWt5aEJFWkROcGJ1bndEdi9MR2ZF?=
 =?utf-8?B?QzlPM0xzeTVob2xpQlJQWUc4Zm93a3pFZ1dmRGVILzdHL1o5d2w0aGRLd3Bs?=
 =?utf-8?B?dGZKdEJiK3VZWVQ5SzhvT29HUkI2RHN6M0pZSUhpbWkwVFlnYjlOaUc1RkJa?=
 =?utf-8?B?dERIVnZBaWcyZGxmOEg5S2lnaENQSi9jeW1pb0ZIOEJBUCtjVVZXdnVKUHhn?=
 =?utf-8?B?U0NDcHhkemxmNFdpV0FHUTVyc1pJeGFrODI3T2RsTTlFcytLZGxJWWVBeWFL?=
 =?utf-8?B?Tm1vanhkVzlzMW91TUdXQ29KWStYK3p1SjFUeHFGbTNwWW4ycElPYm9yeS9P?=
 =?utf-8?B?eDNqM2loeSs4M2JXT2RUMnBwVmVwRmNLb2o3dFh5Sndnd2txcFVKZmFWZy9Q?=
 =?utf-8?B?YWlkazA0TERjdjdNQkpRVE95TTcxOTRPckVsSHBYV0hEdmpDN3RxTTlNanZN?=
 =?utf-8?B?N0g0emJWL0RSTkZIREdKV1VTZUN5cytibXVsZ2o4VGR1ZlQ0RTdxNHl0STRZ?=
 =?utf-8?B?LzJ2YkloVkgyYzhkeDl2eDg3RXdkOW5SYkU4V2hsOGdDdWJCZzFjSExFMjhq?=
 =?utf-8?B?R2QzQzJ2N0tuRHRhU0dqYWZtdnFKTVNiZzYrZzNmejNzcC9wUVN3c1MwcXcr?=
 =?utf-8?B?SzJzTUVHNHpZYnhhbnhUTENKdnRSSzJzSmVVRlhFWFBDRnY0SzRoUE9lOEJP?=
 =?utf-8?B?TDBDbE5TWVpZNldvQldQa3MwZXhKcUVFUmJsc1B1VHRBYys1NjJHbG5iQ1Mw?=
 =?utf-8?B?V25iYjc0SzFDeUkyTENoUUNaTkZ6OUxVWkZnN0VRU2NoRmZLTGpEd25jRWtW?=
 =?utf-8?B?TW5BQjdUNE1lTUFBek81eTVZU095VWNVUmR2TEhVQW1VMndIVCtMVmU2cklR?=
 =?utf-8?B?dnJ2TDVIVUJ2bkF0NW8wR2NSdjhQRUprcnVLQzZYbkpxVXNZcitMV1hpd2Fv?=
 =?utf-8?B?UmJhb0NnYXljRU5ZZmd0eUJBeEJ1MVJ5UEVHV25oSTBscnhFQk1yNWVXMFdO?=
 =?utf-8?B?UVBKVG9kR2IybGZ4UWlrVHYvODczODZod0JBSWNCU2drTG9lMGFPQkIyVnVp?=
 =?utf-8?B?djhzemRFR3VSV21uTDROb2QrNnlxUXNjVURVZC92cTJJSngvZ1luVXdkSTds?=
 =?utf-8?B?ZEZWUXhzeThtVGRwcmp6SUtTTjJBcjBBc0JnL0tpVUJ4K3Z3MGNocE9ObUlE?=
 =?utf-8?B?OGZzUGo0RUQ3Vi9aQ2VMSitpc3QzRXZ2N21kb0J0a0ZlNVpoMCswNUxIc0xU?=
 =?utf-8?B?YlZ4RFNJbjUvaG9ydXV5TThPSThzcUpZV1NoWldtaFNaTzhBeXhwajhESk8y?=
 =?utf-8?B?amE3TnAzNkwzZjdHaytFOEhCeDZJTXdReU1XM0kxM1N6aVlCQ3ZINUpuemFL?=
 =?utf-8?B?ai8xeVdYdkxPYmhjU0dqRiszUDEvb284ZVVyRWJnKzBobDc0VmhNb05iRFBS?=
 =?utf-8?B?dkdhZ2M0T1RiaTFyRkw1MFBTYnhDWmx2Q3VRSCtra09pUXE2VTFpZitKamYx?=
 =?utf-8?B?ZzByaE5VZlZObUtqcEFXNEt0SHYrMERhUXZudWppSUxLV2hyeWNGNlBsNVph?=
 =?utf-8?B?WE5FbEQybnhVMktvR24ybkZPaFAzNEpXcDNlRVduRERPeGFuMDlGVkY4SVhi?=
 =?utf-8?B?Rk5mREVKT0U1S1RRRTE3dysxZ0l3cUxpUWJxdHduSjh6UU51UFk4VWtjVTVw?=
 =?utf-8?B?TlE2b2FDRUcxOGJYUEJMWEExSm9NL2pBa2RsQlpTOERFajNMQnhvdUczUGYy?=
 =?utf-8?B?Um9IajZaSFRxTWZXS005UXJ0N0d5WGZxR1ZGMXZzUFRRMGJEbGFDK1FGMmls?=
 =?utf-8?B?elBIc3VJMnZqWUFPQ2tSTWVVRW5KVmdnWGVtWmkzaEkvM0gzS2pSNHc3U29V?=
 =?utf-8?B?dEZyejlVRjNFT1dRcHRuaEtIZkkvclZFcHlOOG9ZNnhVZFE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TG1SMnF2TVNyVWp3VTI0SDNOMURhcmM4ZUJ5TWIyZ2dkclViWERleXVlRncv?=
 =?utf-8?B?R25aNmJ4dGdVaDFSZXYrMUlabTRlOU1hWXF4UGJpcFRUaDFsRDZXWkV3dGFs?=
 =?utf-8?B?UnI1Z2hhUnNkeTV4SlNGWlp1UHd1aXMzbVJJNmlIb1pRRGFjdUNTZWVOVlFm?=
 =?utf-8?B?YUZGdzMrejYyLzlQYmMzRXlEaWdGU3Y0S1pzOFF5M1RHRDlFc3g5THo4ZFpt?=
 =?utf-8?B?RWNoblVDOTdNS2RoSnIrVFB6dG96VVVyVENublZQRmQ0cGNCcWZSVmtVdEhS?=
 =?utf-8?B?ODIyNWlTcXRLMUJTSUc2VS9kNHR2d2hGVWUyVndjRGR5VDVaTTlvYjV6RHRO?=
 =?utf-8?B?NkxQMFZKYUtiZ2ZVbEJ2ZWlSOUt5QXg4MU1aM0RYWWsvVVV3U243VkNsdUFT?=
 =?utf-8?B?aHQ2cE9XcTBldGpFTVpNdnVIUmlZYmpHQjV4d1NFa1paWGhUcld3ZDZSR0RO?=
 =?utf-8?B?QUpFTmpOcUkyQWxGaFVnYVBKZ3JpV216T205eTJ1Q1gvQ2tzZlJJUncwS2o1?=
 =?utf-8?B?MWNSQlB3a3BMVkczenVtRm5RM3JLVnR1OElNRDhRK211dUFqcjgzOFIxbFhj?=
 =?utf-8?B?QXJ6TXJlaHdDZnBqaXZrWmtRSmloT2FlcTdVL3ZKR0t5M0h1REszUDZxbGkx?=
 =?utf-8?B?ZGdnaGFjRDduZEVpdXV2elpVa095eVk3TVdJWWRtaksxL3d4YVErNWJSVS9W?=
 =?utf-8?B?UEtJVVpLeUpZSy93ZjR0Y1NKSDBWR0RGTVFBWllTcndXSHAreGlGR3lIQjdQ?=
 =?utf-8?B?aDg1bWRiNytrT0dPZ3pSRjkrVDlzVDFxdjdzU1RVZ0hDYmlDQ2F2R0ZwNHVO?=
 =?utf-8?B?MU0wdWNOcWpjclVLNWhRajY4OUVWQVpZZ2hkWGZEQmM1SDloVEhSdmRNS3BF?=
 =?utf-8?B?eUhheGM5NXlpK1BFMnZhdHdyTllaQnN3WGl2YTFPQ2dZZ3didGg5VlRjemRN?=
 =?utf-8?B?US9qODY0bHFodEc3MGgvZjBlWFBydHZZenNxRVMzQ1pHWkpGUUg3Yk8xZ2li?=
 =?utf-8?B?T1g2RU1RNXovZE45d2dkb3gzMW00ZGN6VlFyL0piNFBuWEFzYzdRRXBkRjNn?=
 =?utf-8?B?QVJDWE9LbmRpVXpwek1kR2xZbE1xZ21rUmR0ZmRvczJWMDJDMGZ5MmhjU3hB?=
 =?utf-8?B?US9td2lEaEhRbGZHM1JrT2UwOTlrVjFkOTRCaHgrN1B0cDg1dTd1NjU3enFu?=
 =?utf-8?B?VTlOdE82OXNEcGlOU3FsLzRzSEtnSXRMbnZkRTAxNzRYQm1TZ1hiOU9kTmFL?=
 =?utf-8?B?L09iVTBKU2IxUzh3NFcwNjN3RWZ6Z2UrMXk1d1FFZnVObjV4d1ZlQXJqSUZK?=
 =?utf-8?B?Y3l1dGpjQVJQeHpMNUlwckswaStiNlN1UlpCZUxjOTdvbmFianZxaGFTZUNX?=
 =?utf-8?B?NmJQeXFLN2JJVDVLNVBVZWRhZzQrb1BPSmYwMXkvekFleENQTUJ3VlRiYW56?=
 =?utf-8?B?QmRVN3dsV3VjOVB6Wk5ka0xSazBGMWo1ZUt1TmRSOTJMK0E1U2gxVi9HWkFx?=
 =?utf-8?B?aXZHTWtCY092L0VrekJ1REdwZnpwcmhhcURtelgvdnZGaHUzeW4xZEVPVjFM?=
 =?utf-8?B?aC96NTZrRVdicmM0MTY4WW4zOUNjMklHNEdTcVc5bHArZ3NaMXJhaGZSS2Y2?=
 =?utf-8?B?VFg5Rjg1NW1qMHgyNUJleGRXZE1lcHlvOWg5djltVWlCNkZIbXAzQytpSFcx?=
 =?utf-8?B?bE9BUmVXUmQvdklPME90T29RZ2c5U1h0eHJ0YTBoVkhRSGl3Q0JSa3p1bHE3?=
 =?utf-8?B?TFgrRi8yWTd2bEgzNlpGZ2hKZXhzSy9QS2hDcEhxOElYNjhDMWxodTdpcWZW?=
 =?utf-8?B?UUFGcjNhUndNZjk0WFZzdFowbjZvc0poam14STNWRkFNL2xIN3MvKytlQVRW?=
 =?utf-8?B?TVFZOVQxcmgzVm96Z3pXVzBjTEVUR2ZOVjgzcTZsaG1zakZ0SURZTWlXM0k1?=
 =?utf-8?B?L0Z3SXdvM091U2lVczFOUVRPODVycGlTbVc5VGVUWis3SkdRbVg4cXhWeHJx?=
 =?utf-8?B?QUZmTVVSckxBWEk5ZGh3YjJ4aDFyUU03akRROTN5Vk1QLzljYVlVaHI4Nm1a?=
 =?utf-8?B?U29wYXFQaVVqMVFtZHc5RkQvMENscXkvSlZqalpxdVJyaVlqRjIvMHB0ZVFh?=
 =?utf-8?B?d2ZaLzZxNDJlVERNSUk5K2k1UEcxYjJIUCtwM3NTVVFTYVZVWnBSekVRWDR3?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 584edcfc-7327-4718-fd06-08dddf3613f3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 15:35:51.3826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTDQrL+NiOzlESobrdvphuqveFrnc7ya9S/Wu9EPikuxiIDCcVNsfozAENenq/MDqngATHW8Nne9t3K46qEFIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com
X-Stat-Signature: 33yebxmat3c7op6az6g87q7heqe1bsd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 887761A0019
X-Rspamd-Server: rspam01
X-HE-Tag: 1755617756-974259
X-HE-Meta: U2FsdGVkX19rvofr9v2uhpEb8V7QW2ObanAr9PvSIc4SgKiaEl9/BtK1C+CDTefEI2jrDwM4a/b2aSOukhiZ77TRlDfmXFaIDN2pQcKEf7ddQN3tpxiHuXcWyAtJ7tp13TzCiIyRtClfDCX9oipuPrMlxZx2ZP+73EuAhGNU2j/3KZBrdRIgn1E4tF9ndcspk3aj9JaRkaYWX0lXe5Ct/2mt852LyYIrV3jgkpUClWdL4JPjQ1l7r+dmX5QPuq3aIgSWIqxKXPq94Tk7In2hVdGPfbyCRTt8qYs94rcj1gvH7SbOZZO0eBhNBC906/UWrPXrATa/gM6hwNIrRkbyvgTqHXZH6OUA8uQwTYeCP/tP8acSxpoIJqHfnicfdHgApIguQ9lsr8EB3GirY7cXhnhLfR/79YF/tDispkNncroPsFYX4aMKKt1tmRG1eEbw98UWcTqx06mrecwZQRxGB8uudpm7CxGxT0I7oJlU1/JjgDEM/ToS/QBucfyydYpXjzxCe7rmCieCZ6+Tcg/QaCHo15F+nTogtHHlYmKCvRAqwzRgfwYcFuJy1fpGzau4cDmkyw3OL2uLS75HhZGI++gpdgOwcQlS9U882UkdAm8heBJn1k7DTu6kzLeSD84ySGT6tF9lPUFdcRB/DPFWyb0sJUTjcloxZ7rQLFnfalH1icHsS85gaQ7UVgjOevgFVPY6kCT64znCZo4CzA0t409ckD9om2+opisDmpXw/BdKJECZPJPWvoLpogmaFrbDpr8uf35eaNrG1J0bjq+OOhGcRCQ/8UwaUXgo9fQQa+UgzP47Zbek7CddAdCh5DxgERI4bBf/4++zeIWGZWMpDnMgMZ+VJR4KcdotSABpvHJ5ufyaV5lWm4F7hwzfQUaaPJwyzVDTXNGywJbHT2m85ibPw4Cf1A5fynJ6RPcBSg5l4pPd6CNUjJfOksL2tCAp7TaGqLSX2Tvn01WvagP
 Mj317P2u
 UeqC6Aaxxgw3tPp68kcz35JahbVF/x1mFPb7thzUL/A0w2Uq54+RraSgFTBAHObD0thuTmy70t0p8zjXm+PtzOiLG3mZFrJnT7zHsh8ln420+BCWmSconkD7Zqx7F/2BsWnE0T1TNBHOCErGK3XBCzotfDry01ZeNXCfpoAQcYiLllcwA4DSto9PW9RORo/5EXjpMMfBbEA8kMU823zjvOxk89cpELfa+HHK5Wz156pUnCdwMemblN4tdZqzkA+vddLOGtq9E1jt2POro4+0lno/Ulnc0+8whNnRZEsLVz6i4e96me7qGQ+0nF8SCUxS6Vwl5f4fMxraDNNAY1YGeSk41iLg5JTwm1TGnlKf+/w8MtpYx1rQf5P2w6Zb/a0T+JH+9Jh25QKyFOKTisBuWlcXZGEnAnfLOb08gvOupB3czve9z4rmz4BqO8B3ArK73WBFKi+VMsShTXGHPF1QDRDodJ5axuPuUzHC3A54q9pGwOPyKYxzcX6GcRqGZ4hWYIIPZkpvWOxgHZ+J+YdJd566eWrRfoTL8HUzt/X2klNRfh8kzhSQ6+6Y7Es7zbCl+Mi+jpQVXamGFW+AV1HL4wR7Q/O4K2YpqClCcwDsKWxGGEtWNmtXkEKAYjSyNxkz8ZLtHhj0RGLBaM0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 01:33:40PM +0200, Thomas Hellström wrote:
> On Tue, 2025-08-19 at 19:55 +1000, Alistair Popple wrote:
> > On Mon, Aug 18, 2025 at 01:46:55PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Aug 18, 2025 at 09:44:01AM -0700, Matthew Brost wrote:
> > > > On Mon, Aug 18, 2025 at 01:36:17PM -0300, Jason Gunthorpe wrote:
> > > > > On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> > > > > > I think this choice makes sense: it allows embedding the wait
> > > > > > state from
> > > > > > the initial notifier call into the pass structure. Patch [6]
> > > > > > shows this
> > > > > > by attaching the issued TLB invalidation fences to the pass.
> > > > > > Since a
> > > > > > single notifier may be invoked multiple times with different
> > > > > > ranges but
> > > > > > the same seqno,
> > > > > 
> > > > > That should be explained, but also seems to be a bit of a
> > > > > different
> > > > > issue..
> > > > > 
> > > > > If the design is really to only have two passes and this linked
> > > > > list
> > > > > is about retaining state then there should not be so much
> > > > > freedom to
> > > > > have more passes.
> > > > 
> > > > I’ll let Thomas weigh in on whether we really need more than two
> > > > passes;
> > > > my feeling is that two passes are likely sufficient. It’s also
> > > > worth
> > > > noting that the linked list has an added benefit: the notifier
> > > > tree only
> > > > needs to be walked once (a small time-complexity win).
> > > 
> > > You may end up keeping the linked list just with no way to add a
> > > third
> > > pass.
> > 
> > It seems to me though that linked list still adds unnecessary
> > complexity. I
> > think this would all be much easier to follow if we just added two
> > new callbacks
> > - invalidate_start() and invalidate_end() say.
> 
> One thing that the linked list avoids, though, is traversing the
> interval tree two times. It has O(n*log(n)) whereas the linked list
> overhead is just O(n_2pass).
> 
> > 
> > Admitedly that would still require the linked list (or something
> > similar) to
> > retain the ability to hold/pass a context between the start and end
> > callbacks.
> > Which is bit annoying, it's a pity we need to allocate memory in a
> > performance
> > sensitive path to effectively pass (at least in this case) a single
> > pointer. I
> > can't think of any obvious solutions to that though.
> 
> One idea is for any two-pass notifier implementation to use a small
> pool. That would also to some extent mitigate the risk of out-of-memory
> with GFP_NOWAIT.
> 

I think we can attach a preallocated list entry to the driver-side
notifier state; then you’d only need to allocate (or block) if that
notifier is invoked more than once while a wait action (e.g., a TLB
invalidation) is outstanding. Multiple invocations are technically
possible, but in practice I’d expect them to be rare.

I’m not sure how much of a win this is, though. On Intel hardware, TLB
invalidations are several orders of magnitude slower than the software
steps our notifiers perform. Ultimately, whether to allocate or
preallocate is a driver-side choice.

Matt

> /Thomas
> 
> 
> > 
> > > Jason
> > > 
> 

