Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F37CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9B4280038; Thu, 18 Sep 2025 13:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1218E00F6; Thu, 18 Sep 2025 13:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69A1280038; Thu, 18 Sep 2025 13:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1FC48E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:31:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39FC0B7F2D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:31:38 +0000 (UTC)
X-FDA: 83903063076.25.ED89020
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 648628000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:31:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZODuUEyl;
	spf=pass (imf02.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758216694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46SZOMWM1l+AFPtXIZKaQ88V4tLQQ+ST1Htub5YtT7s=;
	b=JgNNTi0pLGk8buLPwZtF/yltnEfxE5GeAwnqXFhLX8FHlcuwObSiVzy8m+UnSJp3fFRDol
	6+cJBZfWd8XgvE2YW5A6yTZsAI0XFcYJKxrgndDH2sZT1jPTlM6/zUx8QkuWFLX3zJN8tj
	DhvvFVEhfo7ZBu2LcwCNLuWJIPBPduo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZODuUEyl;
	spf=pass (imf02.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758216694; a=rsa-sha256;
	cv=pass;
	b=B382sbMYH3M9iLfBd38EnHEkDZeOM7kDsopCnisl00EWYyi33cfOqVTNn5P3NL3uLXOrIc
	4IhuSUnG820qzFA3DPrG+58AOH8SPkAJfdqNoxw2NkJL6bOKfi184CDyqf8+1F9nUl7bok
	A/QMZSsEM47JnFcFT7Bz0St+wDVFSXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758216693; x=1789752693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=46SZOMWM1l+AFPtXIZKaQ88V4tLQQ+ST1Htub5YtT7s=;
  b=ZODuUEyldbNrF5CIv1OjMbRxVcfBbae5H6H0M14je2inYI5a0vgOx4SQ
   JGviaJi7XrTN0k6ai0DZIslliXLCc6WPFU3DZ2rZZUaSQ61fpAIuf48Y/
   9ifT05D/szBEhfjGjpUSLKxCg8ScI7zfySpLcecC1pn6I5Rn4Gl9md7W3
   JZXMCYIGsEWx+pnv3B9PvR1wsIRn/77dzf7n8P3zGV+MUXOmZvmAo7UE1
   48Q0Na3BYz+/JE5N7byRPUoC2xbXX94qp0fqRvGReTbhVTLLgP1TA/itY
   BOSilRM9Sen9VvPFTx47yU/enhUTgP1tj+Q5qMKY+Aiqz58NQR5JIpSAm
   A==;
X-CSE-ConnectionGUID: fecSre2LQvetyDqOX1Znkg==
X-CSE-MsgGUID: hMoxHD2lT/u7fDmKf7zC+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="71189810"
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="71189810"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 10:31:31 -0700
X-CSE-ConnectionGUID: XVh/owOQSX2gIPo2WfyZ+g==
X-CSE-MsgGUID: SO/y9Y9nTHyhZMfm+LFnww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,275,1751266800"; 
   d="scan'208";a="179604698"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 10:31:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 10:31:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 10:31:29 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.50) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 10:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vke2ko+8n9E8vhLG8Hdh6fgXll5H0p4Yprj1peBVDcqIb+14vDh8uyWrhf1VPguRTjJhCUM0AE2byUaK9EZP/aRTcU+W4vz8rbL+SFZn59NyRWmlqNxOYjuwPZJAOh8g31wJtBEdY95F4i7jgSvvKhyvBLs7aKdTZrt72eJbVLo5hNfCCx+8OrtinXy8FIuR5+zET6pB9uRtGYeeZywB5863Zyz+/hIyFRK194ZLLCjP1HPK4s35yEWG4tE0lvGt+gvENtGQEE4xp/sikcNhb1CvcGgrXXjpOdR9xRwmS5MouLsVat2q3AWlWWh4HKmFiHB4hRF1SOOfXQBNsPLzAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46SZOMWM1l+AFPtXIZKaQ88V4tLQQ+ST1Htub5YtT7s=;
 b=blLoc3EAlaCPOzqCga95prMwQKtWIjwOIVbxaAEcp5O/9kve9yfKpRwB56/sevzi1kSFE8hTSE2tI5EPCM3D2B7zX6z9DNpQmSTWZrVTcshfRLX1WbRzOH9+rulZhlaofUgckg+/HaQQRlOz1pvRHdAuhU5t2cAai01iTGdcW6KbJMgYwIR5uEdCgS7lh01bI8zGrnWAJKP2fjm2Q7z7qemWMX7Mfj92UjE+qdhs21cgBACX1yhqxayPPTj864Rbf+oi0uAzBOOKNqqKCTUyJM8bMl4l8G2ftlQ3FPvJcVDw4AXyMTwqXnNZc9R5MWoNEHlpvXCEvV8pwNNlwHQCIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6404.namprd11.prod.outlook.com (2603:10b6:510:1f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 17:31:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 17:31:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
CC: "maz@kernel.org" <maz@kernel.org>, "luto@kernel.org" <luto@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "mbland@motorola.com"
	<mbland@motorola.com>, "david@redhat.com" <david@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"rppt@kernel.org" <rppt@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pierre.langlois@arm.com"
	<pierre.langlois@arm.com>, "jeffxu@chromium.org" <jeffxu@chromium.org>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "kees@kernel.org"
	<kees@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "jannh@google.com"
	<jannh@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
	"qperret@google.com" <qperret@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "broonie@kernel.org" <broonie@kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
Thread-Topic: [RFC PATCH v5 00/18] pkeys-based page table hardening
Thread-Index: AQHcDcJlv4XRCffEXEeGrdGfSH4E3LRtZq4AgAWiagCAJijdAIAANqOA
Date: Thu, 18 Sep 2025 17:31:26 +0000
Message-ID: <6e5d24de6a6661f83442741f6be8daf691a05a20.camel@intel.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
	 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
	 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
	 <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
In-Reply-To: <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6404:EE_
x-ms-office365-filtering-correlation-id: 19dd8bf9-89c5-4d65-8968-08ddf6d931df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TlZHSlBkWmV3czVJU1JONXY1cHN2TEsvWWVCK3d6dlFEUDVXQ0JKcG13SVNW?=
 =?utf-8?B?amJTcWxtb2FTSjRJQ3NIb0pabkhoRE9Ya1A0SWJ6QXVidld6anhObmI2d2dS?=
 =?utf-8?B?WjdOTE8yTytrR0pWbmM0YTdLbW5QeTQxb2VPNnUzazQ0NEtmTnRnMWdVdWRa?=
 =?utf-8?B?V1pkbWhkZi85RUNJL3VISG14L3pSUC9zNXZXWDNwN1c5WUVEVVpWcEU1dWJ6?=
 =?utf-8?B?TWNZMWdybm5aK3F2M2swblhISkl5anZyN3gyc2FXZFRCaWY2bW81WUxWM0l4?=
 =?utf-8?B?SUpSR3RtVE1hdzVuNlIxQk5MNHZQT0gxTWZVUmFYWnpreklqOTRYYldSVFNy?=
 =?utf-8?B?U0xjclJkRXFqallqWVJ3dDY4RHd1czI5SDFVZEpUYkFoc0p0MzNLdlRzNVlr?=
 =?utf-8?B?eEJNakJDbkNaL1JuYTFNeWJQVHJsam1NUTkvUlB3US9vQ09Oa2ZmeXIyd0ps?=
 =?utf-8?B?ZHN0Yjd3cmRBSVp0MzEvMlBYWjZUcnlpZ0VqbXMxazhNZ1NLNWxRTlRwV244?=
 =?utf-8?B?WXBoT2xRNzRLWWNLVDlnUkFaT001akllR2diaDAvejR5NU5IN0NNY1RkNTZL?=
 =?utf-8?B?YlJ3Sk5zZmIzeUd2UzFOak02WWxhZkhIZ0ladjhFUUxQVEs4U09pbW9kZ2FL?=
 =?utf-8?B?Wk5JSWhaeURxdFU2Vmd5bG1NME1QMG1MOUdJdkRtbDJVcDAxUGlWOUpuWmp1?=
 =?utf-8?B?SkNhczg0aDhyWkZ2QnJPbnNXNUFoVXd6TEltNEZIcElvbHpIeExuTnVSWUQz?=
 =?utf-8?B?L0NRZzd3ZXlsWDJrZXJuSnBrL1lQRkdPbGVwQmZVVHYvaWJudVhmTlR0NnBK?=
 =?utf-8?B?YTFDd1JtN01oQThocnBlVWxlNHpYSm1NcVM4eG9EdzFiTWwzdGZQSy9JR1pE?=
 =?utf-8?B?anR3MWxXTmlKNEJPRVl3RUVGbmpIWTdiZExqL0pLMktsZ29hanZHalMrVGhn?=
 =?utf-8?B?Wmh6cFY2b1JxWVJyK3FGMFNaY2hkb3JwSnFhdVhNZFVudElFeDhKbkhOTnlC?=
 =?utf-8?B?Qk9zR2xlZUZaaDN0d1VpOFc4UlY4dmZNZG4xdTg3eG45MUo1QjlISDBFYWJG?=
 =?utf-8?B?cXFIKzFmSXFPUjR5RHRJRzZrMmdQKzdPd3AwdXFYdTNOTklLKytiTlo4WFBn?=
 =?utf-8?B?VDZGNHBzVGMzcEd5b1BFVis3QnMrVnExZ0pwbkswZWt3QUtZakJ4dGFoK3VU?=
 =?utf-8?B?V2gybUw1TWNsNjNVOTMzYThSQTQ1bTVkUHJjZk4vb1B1eGNoQkpxZ1h6allJ?=
 =?utf-8?B?YkZ1WE9NcjFWc01aT3Q5SnkwRlVrN3lRR1ZzWWtFUzBUK090NmZIaGlmOG1P?=
 =?utf-8?B?RmxCU3dqMjJUVEo1YS9aNWxEVXcwM0x6NXJ2b2NwaWNKWHoxbnlHTnFmNFpy?=
 =?utf-8?B?b3hMeWNUbkFYazV6WmxxRDdnNk16Y1llYStlNGJMUHJTcnpXeDd4YkRwZnBZ?=
 =?utf-8?B?VUZDNUhaVGh2bTczbGtCa1hYWFpuMTZXNTlmTGJYaVd2dytTVno3VS8ySTRN?=
 =?utf-8?B?R2RvdnhNdXhmQmxHTDBqN0s0eFY3bWcvU09YNVZzK0hxWVd6YXZaS2xQK1pp?=
 =?utf-8?B?U1c0eWh3SVhOSUlBeVIrYmhlN055SEpncWVtTklNbjM4c2I3bllBbHVCOXJr?=
 =?utf-8?B?QmxmSUFkdFdtSjhmRGhhUTJkTithZllEeHNjQ2x4SlEyY2V1V0paL1BEcnVY?=
 =?utf-8?B?Y29CRUhGYzk5bFpsdkF6SVI3VGcvYTVqekFRRDdkSWxKL0M2eGR4QkhzZDUx?=
 =?utf-8?B?a3JRSFJDQzVBYytHUCt6SU5IQlUyUXNyOExzb3VyWGJnK1gyaktBOFNqTHkw?=
 =?utf-8?B?S0MvcWxsY2NSTXljTE8rVTN3QVEwdFFnMUsxM0lVd1FQOHNoejF5Z3ZKVndD?=
 =?utf-8?B?K0xVU0NIODdUYnNxU1NyWklDVDZBQXkwWEdoK0lNVFNHRUdzY1lIN3BUTjU0?=
 =?utf-8?B?aCtNNXkrUWYyeWpFZTFUTW9hcDh4VSs0U3NHNzA5MHFOb0pUcnk1cjE5RU9I?=
 =?utf-8?B?QzRBTDZwUVhBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVdONWs4cTh1UzN4QWs2NnozbEdHVFYrZFcxT0t2N1QyZE12c1FKdVlpcURt?=
 =?utf-8?B?TDdBUHFOeEs2aXJjT25jb2dhZ2R6TUpYbG15eU9uMHRiTUNuMk9hdUxWWnJX?=
 =?utf-8?B?dXd2aEwycE1xUFNCMEZaQlI0VnUvWVZFODlKcU5oWm4yTjNIL1ppYWhEUTBa?=
 =?utf-8?B?S0J0aXZMZklPMi9DVW5EL1lGM0Q2ZU1PWVBuU0pQY3pMazV5Zk40Z1kvV3RK?=
 =?utf-8?B?UmM3aXpxMXBadW1VYko0S0JwOXFreTFjc05nRGd5V2ViZjZnNFl6dUpobG9C?=
 =?utf-8?B?dzlCZzlnd2sxUXZzNHgxTmtaOE9pVU9HV0lsNFZaQUhsYThUV2JXMTUzQkll?=
 =?utf-8?B?ZitlYWQ5d1hvSjdKa041LzR0c0Jia0VRb3FKRFV2VHBGd0hIWlBZN2hvMml1?=
 =?utf-8?B?VjJLbldwTEUvYzd3U3V4YURDSkJwaGkwdS9aWVU5NzBrK0QrRHZkYjQzK0c5?=
 =?utf-8?B?bmdiS2Zpb0RqdUlBeFdPWHhxdTJJNFovVStkTUVlV1NtbFIzbjRZRHozLzUz?=
 =?utf-8?B?WjNWWGw5MkxUV2Q3SXRGU2JXK2NlY3FHZllCZGl6Y09Gci9ETzVEQ3AyV0xB?=
 =?utf-8?B?dldKZXMvSFUrOHdlSWFBYW8xcitLTFRnR3NwQkZKbDNXY2hjUjBuNXUxQnUy?=
 =?utf-8?B?c0VlenZYL3ByUklDVjgzcmhIMjg1bDRBaTdkUlByNUhDaTR0WjdQcmpEOUUw?=
 =?utf-8?B?NUVHWktvU2tWL013WE9Oa29pZFE1TDNMMXBSZU1oV0FEQ3U3SzJFNW9DajlK?=
 =?utf-8?B?ZHdTTmlFU3JkSmUwVStyN1llcUlsRThZVTExZXlvQVdWNTJNYUhYNTY3a1ZW?=
 =?utf-8?B?TXdqblBBWUhwcEtKaDdrVjR5bmYvYTNXbWZJaFRGZnlQWkoxOGYvN253V054?=
 =?utf-8?B?RzlaVWNMU2M0eGwvZlBUSE5qVWtyc1dsOWF4bGNWVkluUjg4QWdzS1hGRlor?=
 =?utf-8?B?NUs3MER4MVVwTkxEUVVpR0VIblpJaE9XSGxjOG10K3FOZXQvRFM4UkFOTXJ5?=
 =?utf-8?B?eUg0dnNYOWQwNHVGYURVY0lZTXFZTDRIcVZIbS9XM2poKzFGTlpvSEFzNVdT?=
 =?utf-8?B?ZG5zWjBDWTZUM3VSV00vN29uWHRETndkQUxtU2lnVExMNzNIaVFCRi9IOGtR?=
 =?utf-8?B?ZHJYaTVUVDdRSHQrcW9GT2JZek9QOFo2WDhQbHFrSUx6R0dKV3lPTXlyRXE0?=
 =?utf-8?B?ZjhQSHcvc0N5THBxcXlhWmoyNjhLRmw4aUEvYXFFL0xyaGxCa0E0V3NjUUY5?=
 =?utf-8?B?K2Q2WmlEclVxcEJNWkNMZm94NjZIVEZQMlVtbWE3dEdXbWwrOWQxdVNCRkU3?=
 =?utf-8?B?R1pXSXJZc3E2QUIyVnV3bWhWYm8yeVhBV0M4TzUvM2RGejA3RTVMQkxzb2dH?=
 =?utf-8?B?SUpDT3N2SXdQTDI2SzA4K1Q2ZHBXWFFzZGxCR2xtV3dXalV5S0lIOE9iOCtX?=
 =?utf-8?B?VUM0ZGlhSXYrWCtqTlZ2c0QzT09jSStBNVdGanJvWG1hbjRPT0dYaW1lQmhM?=
 =?utf-8?B?Y1VkMVYzeHlHczJnUFM0ZEpNSlM3R0lnQkFIVmNwMVc3Ymhqa2RyeFNTS0tU?=
 =?utf-8?B?d04vQlQ1N0FTODRKMGF3R3o3cTFUQ1AwU0JrY2VvZXdRQXpsN01Fc1hTeWxF?=
 =?utf-8?B?N2s3bGsyc3ZkdThSVnFzNzFRUnJnS1lIU3VseDhFeGZsVnhTRHBCZ0Y2ZWhV?=
 =?utf-8?B?NS9iTHJodkNsSitIWlg5QkpDdE5La2MveXFjbmpQYlllR2toWDZIZEozNE1r?=
 =?utf-8?B?UFp1Q2hPSkNyQ2d2TEF3L2VVVWIrdEF2ZzF4a2tjM21oT3pIK2RUcmFEdXpY?=
 =?utf-8?B?S3VjUGQ0d3Z5S0FDeTZmOWluS0kxYW01WENRWU5hVEJHekUrcmwvamJLSmRW?=
 =?utf-8?B?OUx5VjlWWjIvQWtaYTJPOE1UNzZXZ2Y3aGYvY1pzZFUya3lwOEFjSW5ubzEx?=
 =?utf-8?B?OVNGRWtXbTM0MGtxOXVkcUZETU96YTU0ZDRPTTZGWXUwdHRQS2J6WmgwMDBz?=
 =?utf-8?B?cGVJb1ZEYjYrT2NDclhldzNaQU1MZDkwQkdVRGRvYjFPZEtrWFJRcEJEMGtF?=
 =?utf-8?B?aXJNSWlrczc1Y3A5WnJPbkI4bzR6YWE1R1hMUXhUT3JLdXpuZlR4Q0FkWFdu?=
 =?utf-8?B?VlZPQ2pGbFcyV2RaNG15NDBLbmRpZjY5MkZkYkN1Q2JkRFpHZjlvaWE1cDc3?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E75CA4824A0C2341A5B42AE1D808E46A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19dd8bf9-89c5-4d65-8968-08ddf6d931df
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2025 17:31:26.0855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npo6cvP+h1jDK2YKpYz+MFwFPbWK6u9xxlR7n419mw7/BTnGqkeVlL5AnSe5WtCiIoz6EYIWSjeieH7X7hVWjul4JLgTN4ApG0W0v9smjAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6404
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 648628000C
X-Stat-Signature: rdzuz9w9twrbuo1im3a39ij894t56ws9
X-HE-Tag: 1758216693-329045
X-HE-Meta: U2FsdGVkX1+8C2l7iLE6rniPKk+bQEPvIH4m6tFH/NuSOoqdH/UL4TBm4y/LuVR+qwa7n+CjFmW57quca9FtluZm7RavsoyjQxM4YnTfR9fq5qFXjpmwUknrnvUhccFb7k+izCHIufLTli0MZnN9bZ/yNWaIgUsBPAbNKsyNoQrf1tGY+3HNpelhRGzCGYx48I/Ad3GzZ4tS4Ryhhic3HIIO6rrvoj8SAzO8J/IXWd8NP+sjuftp8dgsvScsnmb+xMjlw+V337WDj8R7phn8D7NSjeqN8V/J/9JHRvB3pr6yoxIlZUgpmTzQzVkjK1i89Us3CPLOhTTZcttw+ugF3qlqd+CKVstZSOfdu/D5kNPc5XnHgKUQnRAjEzFmdCtrM9iC8LDj9IGEaz4WZQBiUSPbgB4n9AyKRzvG3YfB2BWLXxusRWRLZfJUI7n4dhBM7mjAc9k42aNJqewVVj5c6m8avgLRqvmEWGiSca4pmjxxzq52WZLpA94Ab6DbaYWbqwjY1BDB9qLUc9iLNL2RHo154Loy2FclqFyiNUjvhkcuT4AzFhu59EfeYtIx2ohHC7xyzY4spZUWa3geivmz0moMIQwmJx9hMKZ3HtHTOlSFfoiBpsF7OE7OLRLZuRkhmmM/Fji72ZtfntHt4xbHUX6P1UI6tBQNqRwfMki9h4D7LI7QjzOGZN5G9UYGQI7GZVIRh0ATloSZeuf3KC1P0iSm8ZhZLq6wySjV5XJ3WiIOEDoHqW9ZRjnBJ18yuxhQWCR7jzqhflPtIOL3NiDWrmHujF3GiiJ2RdVHRvGPCgfc0QFSyD8aYFbYUEE06MSmsC2CzWt3w0QFnw+WOVvuqSM8EqEVto5KN28wbNDzR9oXwm7g9I1rrXteLmTwSpuXLkoWdt4LQ4BKKoHXI0ZPYjflPfpzxLMUT7n2hPf3bHgfhQqC7D9WVdT4IsoIr3Oy/cMpZxtwKxWKPSyXSs+
 q/hssqUw
 n4GhOlvLq1XQ1sTYySgmI/vVMsISQ/P0CurKw0o/NceRIivtQEBHR6ZbcTL9BhaLWyvnZRUtV8XQAFKLp7tnEoEqq48bOThCWQ3CIAnDbZuCxUA8034rzKqjUaRPci848t7kmp75caKt5uDMSG1n68ZSt1DTomCymTnq/R1mRzQKDfqXcYDx8hIJNCv2rDoxGCWX3/UbEilCIdXx27XkMkZBj5+Xf9Ntgb2wBl0wgL3aRUDO1KT/5jEqWhj+fhN+/D1y56mU59Jdn1AlMyF2cCbQPucf4K+KJPH8221Z78LKZIiBI6hkBzDKz54RpSLZjrycoWwUUESpFEs5eiEdwS4rJ01G0zBkFCWbJ9hvrQjnZRaDCMay+T3lYCsi2oW/0U6smLySpgDmjzUkK2EtuvOZn8njYOUrpv8wDpzZ33cqDfiE+af95EDKIMcEqp9sejEmJyTntwvWhdgNy0v8CtIAaWDFNtzcurkukeO2I7QkS08UgGGlmnuxUR7qJjiGCHXsfl25P4G9MeH9BDBFi6jR6ifD/cWdhNfb/3lPWHnwHBTLJpHucq3pYYDc3XtKRv5X9VO6YpI2QrIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDE2OjE1ICswMjAwLCBLZXZpbiBCcm9kc2t5IHdyb3RlOg0K
PiBUaGlzIGlzIHdoZXJlIEkgaGF2ZSB0byBhcG9sb2dpc2UgdG8gUmljayBmb3Igbm90IGhhdmlu
ZyBzdHVkaWVkIGhpcw0KPiBzZXJpZXMgbW9yZSB0aG9yb3VnaGx5LCBhcyBwYXRjaCAxNyBbMl0g
Y292ZXJzIHRoaXMgaXNzdWUgdmVyeSB3ZWxsIGluDQo+IHRoZSBjb21taXQgbWVzc2FnZS4NCj4g
DQo+IEl0IHNlZW1zIGZhaXIgdG8gc2F5IHRoZXJlIGlzIG5vIGlkZWFsIG9yIHNpbXBsZSBzb2x1
dGlvbiwgdGhvdWdoLg0KPiBSaWNrJ3MgcGF0Y2ggcmVzZXJ2ZXMgZW5vdWdoIChQVEUtbWFwcGVk
KSBtZW1vcnkgZm9yIGZ1bGx5IHNwbGl0dGluZyB0aGUNCj4gbGluZWFyIG1hcCwgd2hpY2ggaXMg
cmVsYXRpdmVseSBzaW1wbGUgYnV0IG5vdCB2ZXJ5IHBsZWFzYW50LiBDaGF0dGluZw0KPiB3aXRo
IFJ5YW4gUm9iZXJ0cywgd2UgZmlndXJlZCBhbm90aGVyIGFwcHJvYWNoLCBpbXByb3Zpbmcgb24g
c29sdXRpb24gMQ0KPiBtZW50aW9uZWQgaW4gWzJdLiBJdCB3b3VsZCByZWx5IG9uIGFsbG9jYXRp
bmcgYWxsIFBUUHMgZnJvbSBhIHNwZWNpYWwNCj4gcG9vbCAod2l0aG91dCB1c2luZyBzZXRfbWVt
b3J5X3BrZXkoKSBpbiBwYWdldGFibGVfKl9jdG9yKSwgYWxvbmcgdGhvc2UNCj4gbGluZXM6DQoN
Ck9oIEkgZGlkbid0IHJlYWxpemUgQVJNIHNwbGl0IHRoZSBkaXJlY3QgbWFwIG5vdyBhdCBydW50
aW1lLiBJSVJDIGl0IHVzZWQgdG8NCmp1c3QgbWFwIGF0IDRrIGlmIHRoZXJlIHdlcmUgYW55IHBl
cm1pc3Npb25zIGNvbmZpZ3VyZWQuDQoNCj4gDQo+IDEuIDIgcGFnZXMgYXJlIHJlc2VydmVkIGF0
IGFsbCB0aW1lcyAod2l0aCB0aGUgYXBwcm9wcmlhdGUgcGtleSkNCj4gMi4gVHJ5IHRvIGFsbG9j
YXRlIGEgMk0gYmxvY2suIElmIG5lZWRlZCwgdXNlIGEgcmVzZXJ2ZWQgcGFnZSBhcyBQTUQgdG8N
Cj4gc3BsaXQgYSBQVUQuIElmIHN1Y2Nlc3NmdWwsIHNldCBpdHMgcGtleSAtIHRoZSBlbnRpcmUg
YmxvY2sgY2FuIG5vdyBiZQ0KPiB1c2VkIGZvciBQVFBzLiBSZXBsZW5pc2ggdGhlIHJlc2VydmUg
ZnJvbSB0aGUgYmxvY2sgaWYgbmVlZGVkLg0KPiAzLiBJZiBubyBibG9jayBpcyBhdmFpbGFibGUs
IG1ha2UgYW4gb3JkZXItMiBhbGxvY2F0aW9uICg0IHBhZ2VzKS4gSWYNCj4gbmVlZGVkLCB1c2Ug
MS0yIHJlc2VydmVkIHBhZ2VzIHRvIHNwbGl0IFBVRC9QTUQuIFNldCB0aGUgcGtleSBvZiB0aGUg
NA0KPiBwYWdlcywgdGFrZSAxLTIgcGFnZXMgdG8gcmVwbGVuaXNoIHRoZSByZXNlcnZlIGlmIG5l
ZWRlZC4NCg0KT2gsIGdvb2QgaWRlYSENCg0KPiANCj4gVGhpcyBlbnN1cmVzIHRoYXQgd2UgbmV2
ZXIgcnVuIG91dCBvZiBQVFBzIGZvciBzcGxpdHRpbmcuIFdlIG1heSBnZXQNCj4gaW50byBhbiBP
T00gc2l0dWF0aW9uIG1vcmUgZWFzaWx5IGR1ZSB0byB0aGUgb3JkZXItMiByZXF1aXJlbWVudCwg
YnV0DQo+IHRoZSByaXNrIHJlbWFpbnMgbG93IGNvbXBhcmVkIHRvIHJlcXVpcmluZyBhIDJNIGJs
b2NrLiBBIGJpZ2dlciBjb25jZXJuDQo+IGlzIGNvbmN1cnJlbmN5IC0gZG8gd2UgbmVlZCBhIHBl
ci1DUFUgY2FjaGU/IFJlc2VydmluZyBhIDJNIGJsb2NrIHBlcg0KPiBDUFUgY291bGQgYmUgdmVy
eSBtdWNoIG92ZXJraWxsLg0KPiANCj4gTm8gbWF0dGVyIHdoaWNoIHNvbHV0aW9uIGlzIHVzZWQs
IHRoaXMgY2xlYXJseSBpbmNyZWFzZXMgdGhlIGNvbXBsZXhpdHkNCj4gb2Yga3BrZXlzX2hhcmRl
bmVkX3BndGFibGVzLiBNaWtlIFJhcG9wb3J0IGhhcyBwb3N0ZWQgYSBudW1iZXIgb2YgUkZDcw0K
PiBbM11bNF0gdGhhdCBhaW0gYXQgYWRkcmVzc2luZyB0aGlzIHByb2JsZW0gbW9yZSBnZW5lcmFs
bHksIGJ1dCBubw0KPiBjb25zZW5zdXMgc2VlbXMgdG8gaGF2ZSBlbWVyZ2VkIGFuZCBJJ20gbm90
IHN1cmUgdGhleSB3b3VsZCBjb21wbGV0ZWx5DQo+IHNvbHZlIHRoaXMgc3BlY2lmaWMgcHJvYmxl
bSBlaXRoZXIuDQo+IA0KPiBGb3Igbm93LCBteSBwbGFuIGlzIHRvIHN0aWNrIHRvIHNvbHV0aW9u
IDMgZnJvbSBbMl0sIGkuZS4gZm9yY2UgdGhlDQo+IGxpbmVhciBtYXAgdG8gYmUgUFRFLW1hcHBl
ZC4gVGhpcyBpcyBlYXNpbHkgZG9uZSBvbiBhcm02NCBhcyBpdCBpcyB0aGUNCj4gZGVmYXVsdCwg
YW5kIGlzIHJlcXVpcmVkIGZvciByb2RhdGE9ZnVsbCwgdW5sZXNzIFsxXSBpcyBhcHBsaWVkIGFu
ZCB0aGUNCj4gc3lzdGVtIHN1cHBvcnRzIEJCTUwyX05PQUJPUlQuIFNlZSBbMV0gZm9yIHRoZSBw
b3RlbnRpYWwgcGVyZm9ybWFuY2UNCj4gaW1wcm92ZW1lbnRzIHdlJ2QgYmUgbWlzc2luZyBvdXQg
b24gKH41JSBiYWxscGFyaykuDQo+IA0KDQpJIGNvbnRpbnVlIHRvIGJlIHN1cnByaXNlZCB0aGF0
IGFsbG9jYXRpb24gdGltZSBwa2V5IGNvbnZlcnNpb24gaXMgbm90IGENCnBlcmZvcm1hbmNlIGRp
c2FzdGVyLCBldmVuIHdpdGggdGhlIGRpcmVjdG1hcCBwcmUtc3BsaXQuDQoNCj4gSSdtIG5vdCBx
dWl0ZSBzdXJlDQo+IHdoYXQgdGhlIHBpY3R1cmUgbG9va3MgbGlrZSBvbiB4ODYgLSBpdCBtYXkg
d2VsbCBiZSBtb3JlIHNpZ25pZmljYW50IGFzDQo+IFJpY2sgc3VnZ2VzdGVkLg0KDQpJIHRoaW5r
IGhhdmluZyBtb3JlIGVmZmljaWVudCBkaXJlY3QgbWFwIHBlcm1pc3Npb25zIGlzIGEgc29sdmFi
bGUgcHJvYmxlbSwgYnV0DQplYWNoIHVzYWdlIGlzIGp1c3QgYSBsaXR0bGUgdG9vIHNtYWxsIHRv
IGp1c3RpZnkgdGhlIGluZnJhc3RydWN0dXJlIGZvciBhIGdvb2QNCnNvbHV0aW9uLiBBbmQgZWFj
aCBzaW1wbGUgc29sdXRpb24gaXMgYSBsaXR0bGUgdG9vIG11Y2ggb3ZlcmhlYWQgdG8ganVzdGlm
eSB0aGUNCnVzYWdlLiBTbyB0aGVyZSBpcyBhIGxvbmcgdGFpbCBvZiBibG9ja2VkIHVzYWdlczoN
CiAtIHBrZXlzIHVzYWdlcyAocGFnZSB0YWJsZXMgYW5kIHNlY3JldCBwcm90ZWN0aW9uKQ0KIC0g
a2VybmVsIHNoYWRvdyBzdGFja3MNCiAtIE1vcmUgZWZmaWNpZW50IGV4ZWN1dGFibGUgY29kZSBh
bGxvY2F0aW9ucyAoQlBGLCBrcHJvYmUgdHJhbXBvbGluZXMsIGV0YykNCg0KQWx0aG91Z2ggdGhl
IEJQRiBmb2xrcyBzdGFydGVkIGRvaW5nIHRoZWlyIG93biB0aGluZyBmb3IgdGhpcy4gQnV0IEkg
ZG9uJ3QgdGhpbmsNCnRoZXJlIGFyZSBhbnkgZnVuZGFtZW50YWxseSB1bnNvbHZhYmxlIHByb2Js
ZW1zIGZvciBhIGdlbmVyaWMgc29sdXRpb24uIEl0J3MgYQ0KcXVlc3Rpb24gb2YgYSBsZWFkaW5n
IGtpbGxlciB1c2FnZSB0byBqdXN0aWZ5IHRoZSBpbmZyYXN0cnVjdHVyZS4gTWF5YmUgaXQgd2ls
bA0KYmUga2VybmVsIHNoYWRvdyBzdGFjay4NCg==

