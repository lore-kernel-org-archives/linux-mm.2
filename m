Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DDECA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1D78E000B; Tue,  2 Sep 2025 12:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9438E0001; Tue,  2 Sep 2025 12:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B913C8E000B; Tue,  2 Sep 2025 12:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7D2C8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:58:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4285C13A2F8
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:58:15 +0000 (UTC)
X-FDA: 83844918150.02.3A0101D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB1DE140006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:58:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J4hX6Wf6;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of giovanni.cabiddu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=giovanni.cabiddu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756832291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wK3YXVQ1iGfQ9+6JoGOyrcFnQWwMv3wcLGkqDlFcqE=;
	b=OaiWSFAMakAkluPEbFMvfAG3B+mt9AKoS7OaNT3kqJpRMuHho2zuV7jPqzQjQ9BsOM8SfU
	wnCqTunE2EHf9lfAcySHDYPSKqkO8tVNU+KVLtVysz6t+vTK5AhXT6qQ0fplRrhJWFvln0
	vyea+ptTZ9MVdM/C63KNdyolP9cfCls=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756832291; a=rsa-sha256;
	cv=fail;
	b=M8uMW8Z/zfn3LDGZ6LYj/rQdg25CcqsLYyeNdWJNSVfxdIGi+FSLCuix+pE3Xxz2C6+Qoi
	FnW7uSRCIE/1gHIs6KXUHZTkWklOQlUrCO8I964V1OpShoxQ/1zSb9QBdQx9KkLzP8+r3T
	RqiwDonG7/751scYwvKTnKbSdrP9wpk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J4hX6Wf6;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf23.hostedemail.com: domain of giovanni.cabiddu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=giovanni.cabiddu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756832291; x=1788368291;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=GHy0kNJQW6X5as5U+SK7Csdn9mW+J/d9MHfHxTr8OFo=;
  b=J4hX6Wf6MaPZqWl7FYU7DcZU8z+VkmnAFXXn+mSFn2g0thvqgdOQrTRj
   4sq50xfpBwdoslZyCBmk1GQDMJKKiryyKTPWdUBB/XArWLqG7lB7B1WFQ
   Z+ywSPLn+lGQYjW6opL4ckmihfSZ9FMCN1RvDjKL5FexHs24sUp2ZlJiI
   fOlCFm2HpPDwWFcX6DVbqwo76jlWPo1ARO3ShmOWLUwNvqjV+ZkoMo5FA
   hQtLbx0Mu1QmmI/YXtMVrhbP7YPTkE4iiMDsImdCcb3O4pVMtRcNkZrmd
   T1U6myQaDbHWStJNUseM4nylL2LvBFYe52NwJu5bbKHx/+LluzuxLHXTB
   g==;
X-CSE-ConnectionGUID: Jh8ClkFTS2Gth6BysjT0mQ==
X-CSE-MsgGUID: ctjob2ghR1i9uiTxmOVr1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58817853"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="58817853"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:58:09 -0700
X-CSE-ConnectionGUID: kJ+T9ea3Rk6MDczajEHCGA==
X-CSE-MsgGUID: XJjEbxltSMqA6SLToXAPpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="175698000"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 09:58:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 09:58:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 09:58:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.52)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 09:58:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhBsvJqN6wf9MTSFJsK2z7rwRluU1U2iad50pTAEXcKpU+2r6JGSxIflIDMCiWDZbWqhcJdmz2TgSMQYdZj2xML6w29Aq/ge948t6lB3iR0tjfbM96TLWeATty5QEvVDbKl80MUsGPlYdW5yJrEubDJ9jMSirZkSRQmN9BfAe348ecJZvzEEFfHE0WxKhC0tWuAgR0aFEkogbkEHJTMaFOKxeUZEqSq+7lqOIzEawPiFtT0QXDlFCAK2SZ80yNlNg03rxd/AMyMLwKtVYqV4ugBuHoNZQL8DrSLrg4IfZa/fDGo+YW8pEt1zltvR5Zr0lLlXa+YU1XhcwKc70U87Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wK3YXVQ1iGfQ9+6JoGOyrcFnQWwMv3wcLGkqDlFcqE=;
 b=uejVrH1aFCYHYLL54f/PCu3YX8jYZAJ2Xl2Ez9rvmYk2NWDGcu21h9raXvqJK/+ZwmwBnvqCbBpwAFuhnCgt4So66bcuwYif3bhJD6Sb/n0RsI22sOZY1/9DTKeXQjVhL+apy+fk9+aSmtT6C5c64zlGRPjsKgMpxjneTvtHJMPGI8jwLO9yTF3Cv0rhUok6jswErqe84dUIrjaOiaEqXzkzFGRPXQ5LV0GRsRgOoqEihQD0xTo7kRDnUqocJKlGDz/zHMyEn3EfuIiWDPXQOf8eQ2K51CIUY4tczfvrA3A1q+7n1vT3F9AsplXoIkODLmtirysOQaf84nG0RgoTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 16:58:03 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 16:58:02 +0000
Date: Tue, 2 Sep 2025 17:57:52 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Jann Horn <jannh@google.com>
CC: Rik van Riel <riel@surriel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <bp@alien8.de>, <peterz@infradead.org>,
	<dave.hansen@linux.intel.com>, <zhengqi.arch@bytedance.com>,
	<nadav.amit@gmail.com>, <thomas.lendacky@amd.com>, <kernel-team@meta.com>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <jackmanb@google.com>,
	<mhklinux@outlook.com>, <andrew.cooper3@citrix.com>, <Manali.Shukla@amd.com>,
	<mingo@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	<baolu.lu@intel.com>, <david.guckian@intel.com>, <damian.muszynski@intel.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
Message-ID: <aLciEF5kNHDcRFvP@gcabiddu-mobl.ger.corp.intel.com>
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
 <CAG48ez2ck2QaxZ6G1Qrp9p0brFecrnf+KRc7Uk8c9kMJqSOswg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2ck2QaxZ6G1Qrp9p0brFecrnf+KRc7Uk8c9kMJqSOswg@mail.gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7PR01CA0005.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50f::28) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: f7a5ece7-2c05-458e-d8f1-08ddea41e0fa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RWdVMjBQazBQMndEWDhsS2p2Q0p0SHlNZUhFY2F1bmU3UkZHZm1ORHVoU3U4?=
 =?utf-8?B?cDl1MERZMGRsMmd1b2J6VUR3anlmdUYxeTRDRVh4Z3VwZnFMdko2QjcwQ0NY?=
 =?utf-8?B?WW1ibkt6VUdXSUVFUFBVdGZ1VktwYitHNXBXRDJGTFlGZGJmZU9mMTdxVGFF?=
 =?utf-8?B?cElXQ0Z3YStnNUczNHhuMzI4WjlNQXlSYWwxK0ZuN25BWHRoRE9hazZGemFU?=
 =?utf-8?B?cDRrQU1LWnhoVUR0SWlCdzd4ZlBwbnY0SVhFaU0vM2pHV2E4VjY4S0RqdTFP?=
 =?utf-8?B?MHR3QUxna1hyMVlOclVnUnBQb0JxbVkrRUx6Y0dvMTBWVURZa0ZXSDBQT0Uy?=
 =?utf-8?B?djAwc3hrbFN1UjRBR0FiZXVWcWlzcGllbEM5MThVdnpvcHQ0eE1IOHlTNnpE?=
 =?utf-8?B?eGtxdC9SYnRFNG8rNTRJRFNrUkI3Yy85WUJLOUM3VmZXOUhYUWg0VTNPOUd6?=
 =?utf-8?B?L0l5WFVPUVdXLzNVbzJ1eHEwQXJGVDBqa2FtTEd5c1J6bnloTGx2UGxYKy9a?=
 =?utf-8?B?dVpsRVlYMHFaZmtWQmNQdUMwVXU3b2Jya3VoRXE5NU5HZzVST2FmejBNNkh6?=
 =?utf-8?B?VU1vUHZKYXZFTjFEYTA5WkEvVTdpUWRNSCtOMXMzaEl1MFB6ay9MMU9JRHpZ?=
 =?utf-8?B?SUlQVllvdy9GS001bjRHNjlVTUlrd1dmc0dUQ3IvNk1QYlBSOUZ1c3YvN1Bw?=
 =?utf-8?B?b3BmaC9STlNublp6UXVzSUV5b0RNN2VEcU5UeWtlenJYTVZxaXhGcDcxVWp3?=
 =?utf-8?B?WDNRMjIrY0RyYWdJamhIdUVFNWRSN0FIbDIvYldldnVTaldDTytuTUJwOHJV?=
 =?utf-8?B?TUwwVFhUUlUySUs3QjBWVWkzSStSMWpTR25yTEsxa2Y2aXMxUG0rWERLazIy?=
 =?utf-8?B?bGRIMjZpOVg0RXdMQ0FUbjZ6bkU1S3hub2QvdzJZVTAxT2ZlaGE2c2s2aGpv?=
 =?utf-8?B?MUdrNVVVMHlLM2pMY1BNK2lROHI3WnVXY2JTVGRhNWNlaWJya2ZZU21jaDhn?=
 =?utf-8?B?Qktlako3Y0dDeVBuWUQyT3FPRUJyNTVJeUNqRG1sZHB3dXJpaHV2cXlrM3Bk?=
 =?utf-8?B?a0ZueVgxM28rWW4yZjBCeUNxcDV3RU1DT0tBRkExeDRBTVk0QU5sVm00SDFW?=
 =?utf-8?B?RXJtWVRCaU1ER2l2dlJPL2QwRVlaVnpIaitUZGJBK3lPWmx0UUlBTmViZUpl?=
 =?utf-8?B?eVZoV29SSWdwNWZrZkxweU50SVhnbVR5clNydy9xMWNpNHVrY0VTVUhObXkv?=
 =?utf-8?B?dXgzYVA1bjhCb2QvbDZhR0I2a0hCZmVTL1VHU1JjKzlUczloeWVTeW85dlVa?=
 =?utf-8?B?Rmg4TjY5UmFaZVplNUJFYjhxTWRyZUdRMjZpQktpNW1PR0VjcUliRi9ZQ1lr?=
 =?utf-8?B?M2dMZ2R4ZmNhSzUwV3VXOUtEb3hFU3BqQ1JtTXhJU1dVRStTV25IVStaajZR?=
 =?utf-8?B?ZHl1WGJBczFOeWlxVk45eTM4WWZHL0Z0OU9MVWx3Z29LcWdaWFgxa3ZIaHJQ?=
 =?utf-8?B?aU1QSjZSNEFpNSthTENDeFJZMHhCRi9RK3R2TndIbndjNXRIeHIvZkYxL3Z1?=
 =?utf-8?B?NmZYV2lZWk5QMWdOM01yUHNVbEtQb2p4N1lyTVYrUnowRW5EOERMRDd3bkRq?=
 =?utf-8?B?TTRxZm5LQ0t6QlZhZ0IzczFITmJqOVoveU5McmgwakRoMEFQQU1XZFVydEJ3?=
 =?utf-8?B?Vlo1bGJBRFVUdlJ5RlJFdk1ZNk1CWTJVd0xGbVpLZ01mV2R1RSs3V2Y3cUxS?=
 =?utf-8?B?TU1idnBIOUVBUmlrbEtRVzdaNjdYdk0wUnY3OFh6U0k0MldhWTAySWZRbWFN?=
 =?utf-8?B?QzljNmRFbExubVBVQVFsUmwyNE0rZVVIK1ZnOW10eXNnUHBEWFlOc2hrRHlX?=
 =?utf-8?B?clNDMXRNVDNjNThMWVgrei9MeHVRcHdxbUpId2YvVHB2Y1k4VXFtVDN2blM5?=
 =?utf-8?Q?S3q7t/R4/jg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG5PU1dZM2FzUzlzWE8ya1hoVXIwOC9UcUcxdkVxNDM4bXg1NlFGYTFVN1VO?=
 =?utf-8?B?cEpuQmIyWWw2SkRCd1dIZDNhOFg0eFZuVGN6WGlmZmR0VGJMZjRXN2lud3Z4?=
 =?utf-8?B?Y01IdWJJay9YNFcxTHZYREZEazRBR3hlMnNHY2tUVXprWmpZUEdUYVg5emhI?=
 =?utf-8?B?RDlTT0lZQmQzWVhIdGdsZDk4dkhVM0l3ejhyOElGa2t0cGlDaGtnbkdUWUVt?=
 =?utf-8?B?S1h6TzE4aVpMWXlQbExvdzR0aTVoY2NBamlSVnZXakFFMHoxL3ROUkNwUG9n?=
 =?utf-8?B?YXpYMXYyZFZTbW1XWGo2Q0wra1lTdys4ZWtRWkpCWWJKWXVoQ1lpaFFJRWUz?=
 =?utf-8?B?U2tpSW0zTExkYTExUjZRVGl5UEYwWFE2TWdFUzRiSkhzK0x3TUZyQWFGdWVO?=
 =?utf-8?B?enE2QmwxQm5rVW9TUGZJR0txZEFYWUZNTk1QcW5ZcWJDMXRJN2FseC82TVdS?=
 =?utf-8?B?MjVJSGFtOHRFcnFFUFloczVCQWFrdXFQRWpvb1hQYkRXZmNSWWdDSTAzcW1R?=
 =?utf-8?B?NlVQZVFMZnRGYkZoQ0NZYnpiQWNrTHBLS1QvVU8zU2RwcVdBNVg3aWxGQWlP?=
 =?utf-8?B?RnBab2ZjSjRlUjYxRUxpSUFrWElUVUJTUlRkclNtOWJocXRmVHJ1UGpicTNO?=
 =?utf-8?B?ai83UW9uUjdQMzU0bjVUdFRKNlp3MExuS0VrSTUvZ0NhejR1eVRVQ1NkWmZo?=
 =?utf-8?B?YU5PUzdXSlpnNW52QlJRT2FiL2dsbUtWT1NwaHpVcGJRb2MvbU9seEZwUXVM?=
 =?utf-8?B?OGxJOE1qN0xPMC91eXpCV2o1Qk1ZZS85bndGYlRoMXR6bXVmYTUzTEdvMmFX?=
 =?utf-8?B?U1VqcDlMa09BTUcwY0xJYVlsYkpSODdJUzNuZ011dWNsaUhKVHlBUzN6dllq?=
 =?utf-8?B?S2xzakVKN2Q2ZUkyWDVka29hRXc2Qkp5QzFiY0w0TEczVkxSK2NSdUcxNjZF?=
 =?utf-8?B?cFZJNE1KYzdoUm1qc1JIN21Za24xVjlKWDRhTmhyMHpqS21qNGUrZWpwM044?=
 =?utf-8?B?MkZ4c3Z3a1pPYkE0NTcxK3luUTlHMTNDRTFQZkJrOTBLMi9HRWVEL0xGMTlW?=
 =?utf-8?B?UGROejhuZktaWWJzVUhqc2RvUzhBYTBVYjZmZUowNVhJak5aNk1XMzZ4SzBL?=
 =?utf-8?B?Ri9EOXNOZUI4UWZYMWtnQVRySFRiZy9vRXkwbEQ3V09GRkV6K0pJSS9UbFJ6?=
 =?utf-8?B?YjJaN2p5V3NkeU5OMDR2dmQ4V2JUa0xzcGVMZVg4ZHZKQW9ScXUrL0VRMVJI?=
 =?utf-8?B?ZVVLeDFLMXc5OUZYb2dhUHlKK3g3anFZVmlqM2FsV3RKcU50TE5RSGRmRGp1?=
 =?utf-8?B?cFdUTUlIWGNCR1RKMjNLTWY2ZlR0Y1VlQ2xrM29Hc2JFSk11bnc1UlMxeUk3?=
 =?utf-8?B?Ny9pZVgzNXVsQXAweVpFTDR3WmhnUEZtNkFCSTdQdlRkSzBtOXpOckl1QnI2?=
 =?utf-8?B?TE8zNDI5OTRFQkltZlRSOG9FUUx5VG9qSHIrZkliVk1PZUlac0h5WXczc0dZ?=
 =?utf-8?B?MVRtNTQ3SWtTalppZWZPT2hDN1lPYmpuR3NPSHozaTk1RUR2SlVvbXAvUElo?=
 =?utf-8?B?SDFLWHdPYmZRWGdkTTMwb1lkOHhmV05nb1B4WGdIelFvSkwyN0NGRG1tWWNG?=
 =?utf-8?B?SWYwUWY5bXNiYXU3eDUrTS9LNEo0RGJiY1VTYVNsM0FWWTNlMmc3aWhzdzlN?=
 =?utf-8?B?bEJtelV4SllKT2tESmMyM1FRRTFjTUN0UGVTdlB0WEdPZVQramdJam9EeWhX?=
 =?utf-8?B?NVpMYUVmOEpKS1lYRHR5RlBQajlzaGdBakZpZnBUbnJ4UlU2UXV0QVl4UmlR?=
 =?utf-8?B?b0xsMmppMHhhNVlyOThtQUFYVjI2d3oxTUxCbmVna01JcFJGWk1Yc1dzQm9R?=
 =?utf-8?B?UWFJdkdhVHhhblpkYWJzQ2hlMlFORjFmZmxkV0F2VEQ3L01tUEl1TG1sRnlG?=
 =?utf-8?B?MUtCWFh6SjFJSldLY2YvUXM0NnUybEFYc2JJcWtUeFRyWWJ4dkhkN3dnYWRS?=
 =?utf-8?B?ZHhWb2tmQW5IdjVHZ3RRK2s2a3JqZ252OXlvL2M1UlFXSHBhNkJzVHVxZ01k?=
 =?utf-8?B?WFVOWkhmd2c4L0IyRHl2Uyt1QXhMbXpOajJIbGJsdFpmc1JlTmMzRmFFdVlm?=
 =?utf-8?B?SEFQVUVCUFBqcW5JZ2ZySzJNY0hlanRQN1JVbnZjeVV0SGF1Vkh2dDB6K2pG?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a5ece7-2c05-458e-d8f1-08ddea41e0fa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 16:58:02.7615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4AhNuXVGqnGvXUnl1s2TGQNUrjBW/AdhEDgh/70lDdyovFnwEJy4cNloNyDk1fwUtgq+y8eV6tkCWK1+RLPE+WV33f6YPde0zYwtvnREHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB1DE140006
X-Stat-Signature: inbrwmoka1x8x3ze47u6wiy9sbk7w8pd
X-Rspam-User: 
X-HE-Tag: 1756832290-477007
X-HE-Meta: U2FsdGVkX18PN4YwrfOOD/j5lXgeITohjHlK2x3Dz2J6ozAS6ALthArrdi01ddFCrNLcLyI6SrYYirOrduQXSbH7OLw48tICdg5JsRKw/iamh2nkfCcSyJKLAwSNYrq/wr7bIE6IBQsuSdi29wSPEuC5gckTV4hI+SQXF5RZfVmi6ObbjfgWwdcZu5jRIINmz0NiKqeoen+mXLLCOcLYDEyyVELlsZ+tGFXKPZkWRqa3vKvfI3GAPEujG45W9CN2yKEq2tvkKyk/H9u3w+sTFnj7VqcgRjShaMNIevfKL8llvpFVneIX9apELrwkWpuWS6oSAevvETILk/70aZcmF9MY1FUdIImFYlpTvVaq0s/vNA176q0RICShTbA5LUJoCUxOI0LvJAjy5afknG8nk7QzotcstKy2w9FPpsSiK8sxTZzhL/2qaTEWK55te/JRRrQl74p3MdlKsgc2MBH+1/R3PRgBklHp7kV+eWC/kLVE4y11mfG2C4L4eOrRjiVqkAmGB2rjFYo9/EohbhzuAga0vVx3U0OoOh96IKUjTNvG3+UQfO1BhG5XBBUIbW5inU63ClIHFxU5e/9x6omzI1o46XfEa428d9HJquY7nBWLaxpF1o8eYG52YfHWCteR71wHvIN1Nw9PerUE6uJjFjfKNxgwDy0T0gvMPP3WXJ18e9iAigNk0d0FQGvEFhQ9400oUmBYUxIJ1l/KACnowjlcrYUEfwDsroafgArxhqxxilYc8REEhAXRJVMp9N6o44JlBrihUcop8nnvNGKePFFHBRUjMgBZa4S89FbXThghoq3A5+RDm+l/P4cA7YHneaKD1s3UKRLgF4Y2mMLvqvo2UggRSCeHqobX7whDAFGkff0wfQ8RuBahoCnHaR0WBn9N7yOUGQlXVCFGfpM8pvT2CeLbIaa67NqPe5RhMK7TTeBXM19o5V9iL2gNv11osx4fLzMLxIN707onsJH
 p5Hw3Ncg
 yrJGo2caA83WBz25pCfgWUrcMRiRO7ounAIAVBaZ95/EftXu88FNvdIzk5gE6XLhKXP72gDfAsfmQiVZkpOcgxbWiZa/nkjPIRq0mrLarnWADWrbctKutbmFQTF3aotSfKhOZv4L6kANYY3/NgW5lQxNX+Vzz+LQFw3Kqq1uxmK/VH8TXFclzpeq/fnj73md8dhElIYJyvMT5kBPGAkNNLhJ3uRW2rM07iAJDbD094devQrD1rE9Y7QXmmHsIwmJzSEFjeMg1KWYLSfd/t1MdKlGy+WMMJgnNzZNk9w9GtU5NbPuLsxFy17st8nMCPCdrrncaCxV63XZeRwtm67VBKaK89SYHIhMBhkKSzUqNX45xXEzalsUl94j7u1yDEn1kj5rl+Q3xntBjAZUw3PBuSH3Ge721n4f6gdJEKnvkwOefJ8CqtnEWEUxy8oIZ9BVALUll+ncFdTl8Lg7t1MFmeujCsxvMgzVED16WZcRXswEkVcrc7y3cJxzhvaOxM1J223osYEWgSY7sFRRs0O1KfXD2sId6rdrderH8cOwmztU6+ylry8Ggi+lpnywjgTnbZ7Ae/9TP0GwouZCBurofwBExDdBrP6CEla+b8/A2pAKWbEiKmifyZjkvNQMAmP1Tyda5FU6Mji5AG3j5sN+zawTVXYWhhuO2QyR1JxEcbAwgEzpuPciXVtVY/banvFHt2I4NA72Dd+JxeT09Bzj8XO4FO0LQL6ffm4bvQz/dbKV9/DdrA3iC4jJBGh/3lkGL4UX76i3JiDrJVzBNIFovDXdhs9HFqt3Akn9g281Prn7E95GZJ1+ZA/BUtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 06:31:49PM +0200, Jann Horn wrote:
> On Tue, Sep 2, 2025 at 5:44 PM Giovanni Cabiddu
> <giovanni.cabiddu@intel.com> wrote:
> > On Tue, Feb 25, 2025 at 10:00:36PM -0500, Rik van Riel wrote:
> > > Reduce code duplication by consolidating the decision point
> > > for whether to do individual invalidations or a full flush
> > > inside get_flush_tlb_info.
> > >
> > > Signed-off-by: Rik van Riel <riel@surriel.com>
> > > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > > Tested-by: Michael Kelley <mhklinux@outlook.com>
> > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> > > ---
> > After 4a02ed8e1cc3 ("x86/mm: Consolidate full flush threshold
> > decision"), we've seen data corruption in DMAd buffers when testing SVA.
> 
> If it's not too much effort, you could try to see whether bumping
> /sys/kernel/debug/x86/tlb_single_page_flush_ceiling to some relatively
> large value (maybe something like 262144, which is 512*512) causes you
> to see the same kind of issue before commit 4a02ed8e1cc3. (Note that
> increasing tlb_single_page_flush_ceiling costs performance, and
> putting an overly big value in there will probably make the system
> completely unresponsive.)
Thanks. We will try to increase tlb_single_page_flush_ceiling before
4a02ed8e1cc3.

I'm not familiar with this code, but based on the commit message,
4a02ed8e1cc3 appears to be a refactor. However, that doesn't seem to be
the case.
Before the commit, mmu_notifier_arch_invalidate_secondary_tlbs() was
getting a modified value for start and end. After the commit it appears
to be using the original values instead. Was this intentional?

Regards,

-- 
Giovanni

