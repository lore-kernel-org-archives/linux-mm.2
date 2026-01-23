Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF594D72349
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A636B0427; Fri, 23 Jan 2026 02:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317C26B0429; Fri, 23 Jan 2026 02:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B1C6B042D; Fri, 23 Jan 2026 02:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 058F46B0427
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:58:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CC21C1A64
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:58:37 +0000 (UTC)
X-FDA: 84362476674.24.455D0C5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 315E9C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:58:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fiph17u7;
	spf=pass (imf10.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769155113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
	b=t2DcpVNQzxGfkFlAl2m8IlOuCteVsLKTaz+UgR/4kuH2vWfjoAq+XgsBW1nAaR12IIWxn8
	ckdH5YniGVi1bXf5ndAeCpcyjFj/fbjKoTLdajE5Mls6gKDtNBbrSrvtjxG0VedUOVH9JM
	DsXq/k2iS6OhAHC/xWmIkkhepx6ykZA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Fiph17u7;
	spf=pass (imf10.hostedemail.com: domain of kai.huang@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=kai.huang@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769155113; a=rsa-sha256;
	cv=pass;
	b=C1fsysS+DMgvM8QknHKmj5hD+SKoPdC1lLvayitYCsMji99/gLTS2mofEk4JSCd/3vrikD
	VN8jvOTKle6s6SewM4QRQkFBIjt939SWA5kNGc977qEygCVvnDM1ap7FzuGm0skAmCfCmc
	S9doV7VyvRACh/F1/ihyY3Iw029SMK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769155113; x=1800691113;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
  b=Fiph17u7bT+0Py79WmvspmBvT7MgU+JmT4vYQbjb905jP9tCxD11fsfU
   WbHEKNIzidfyLwvyWsASex5GV2U93X44PIsCaybn/N21IR8s22qZkmifq
   sf+coG6/i0mYePzhPs/GVvj4tr1hQ6gS+xuV24YbyicUE/SF3HZcSmsVp
   sFHIwcrebv8e2dBtuZhICWSC5N15KBFTzcNUfd+wQKktNWWK7U5r181gv
   58C/BInlsZqz8j7jra3WLk+FQeHHZssxcdpL2rq2Uqboh2G5NauGxvmRQ
   MrapM+A8Sb4UrpY5PayctiNXTd7sZpU1YCCMfIm2w09xSrY4FiBwgaKsu
   Q==;
X-CSE-ConnectionGUID: 2MyR0LUdQRSKKEsWmb/0JQ==
X-CSE-MsgGUID: AeQi89ysRju+DmBcV9IVMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="80711709"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="80711709"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:58:32 -0800
X-CSE-ConnectionGUID: Uxuoj9duRLyWuTJTAUyw7A==
X-CSE-MsgGUID: uncsNV8+TqqGojwfwdhkmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="211830314"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 23:58:31 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:58:31 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 22 Jan 2026 23:58:31 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 22 Jan 2026 23:58:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGxJMOve/7d5XoTiN3G3ype/Enp1GocgKzhnPSkxvLy/mYKmFlwdoD7lLYkKKOwt7PrcRCjLHIuq6L8NtXfrxezu7l1U+XnBfQmkvX3Pf1L5l9uJP5X3aKYTtsg/oap0KpeGaf9GLFbbAB1ufGsNcncDtBN1aUhkmDT0ecXqJlQINAkj0wfrX7P38nO5pwqMZDhS0gFKTQ5FLGQAgXdoKzmeXk5sKEEn8yNX0jAZHlgsNX/vDeIBc7C3L5PrnLLUEN2x92n/vo+AaKrULNZRGNVmP5itF3iDxzYchDl44dMbKpcK/t4lWfN7ljwvMukt6HX+EDSSl3LoGFgYfWR9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nl2l9O8tI2VYkTgzBDaFsbK4QVMUIaeLH+pWv+WsUMQ=;
 b=rZERxtyar/TzvkIA4cypHu7y2RViLtHy9F20YYAnywy2RQQw7+hsiVGeQMC8LW6Wrk2dzOsAQ5e6mwufdUniGrV4nf5ZMCZHfm8m11XDY/uxlO/p86f70JbEUg+YR46va6GOrdw9/8GDIE/Wg21sUGrfkm20f9OTCXr58g5GgJIu5gDLRbxiz6dTehE/6NJWQRuxVCokclFtRK/0QONTtpp+cK5JS94bbfyOyT4669RQUrBJ8WuuU9zyV4hQMSXspIrqfwP4KJNyGWCEp7ZQlvZtwBQOytsnyrbwDehPoZTIElpTBxT+nmWNcoGLyLEuchU3y9qVA8iSQHgqOVUt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB8397.namprd11.prod.outlook.com (2603:10b6:208:48b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 07:58:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 07:58:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tianwentong2000@gmail.com" <tianwentong2000@gmail.com>
CC: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"jarkko@kernel.org" <jarkko@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Topic: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Thread-Index: AQHci6Q5tvQw1foINE2mfXMlwjgvW7Veq/4AgACeOoCAABqXgA==
Date: Fri, 23 Jan 2026 07:58:27 +0000
Message-ID: <2c33338d030f086d490f6e8e8d02667ff37143ec.camel@intel.com>
References: <20260122133633.79792-1-tianwentong2000@gmail.com>
	 <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
	 <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
In-Reply-To: <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB8397:EE_
x-ms-office365-filtering-correlation-id: 258ab965-9019-48d4-3f52-08de5a553131
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?elNGY3B5SEJ5TDl4cExVR04rZG5aYzg3UUdtT1NmUkk4NitSQVM5S3luYnR3?=
 =?utf-8?B?a0ZCdkQyNjJOM0lWUVlESEF0TUhGY3RlUlg1L2ZNVEFKOHJMTFU4U2xLMzI1?=
 =?utf-8?B?VWp2dnlCNkN2bjZWalNQUE5ES3daNEZxNmxTSGJJaDJ6QTNVenRkMGJ1TTVp?=
 =?utf-8?B?Y1pFNHRDQWNGM3RIeWo2ZXdVUjZLa1cyNjZ0Y042VjBpS2hvOWhmV1dub3pq?=
 =?utf-8?B?S1ljTHJVZTVNNkRGUS83VHhRaTgwYTFER1dnMUJzUHVFN1NuQkhTclFHK1Qr?=
 =?utf-8?B?bm5RZWYwdEk5MHBMM3dHRUs1UVRvRXhqZXRQdnFnQWpGU2I4RWgrR2JmTFJX?=
 =?utf-8?B?ZlFGb1NEUDBweTY1aXZ5d1djcHRYSStoREdKNDNiVE05dUdsanJBa1R1OGxC?=
 =?utf-8?B?cnpsR0IvUzlTQ2lUT3NFOFFCY0JMeVpmUFc3MjJCQzRyVGhmS0ppeDEwNUR1?=
 =?utf-8?B?NUZJK0VRKzlSaWFvUGQ1WkRvc1M3RmgrVnZXWTl6SWxnVElPQkpFSTJpY0Ny?=
 =?utf-8?B?SFZwbVptOWM5VWNyMHNKMmp5b2xKdzFwdllWdEQyMVZjQ2lXUVdaTnZxVnBk?=
 =?utf-8?B?b2dBS0ZDSkJjZ3lDSklQdGFCc0hBajVYRFhKbkxDNkVOWUZ4QzlUS1FaM1ht?=
 =?utf-8?B?dlNtQ0tGOTBTVGlhNEdJYmNkR2RCeG1VV0ZBUC80dzRuZ1Y5UC9MS3Y5b2d0?=
 =?utf-8?B?eHpZbDBTMnBuOG5wMTFMTkVxZlQ3QlN4cTdyM3BTOWdCNHUwRG9UVHNFaUY1?=
 =?utf-8?B?Y2hUQmdzUWluTm5jNlJLbTNIVFMzOU42bWxtVGhFNUZRYWkrZEVoY3ZBZzhQ?=
 =?utf-8?B?ZUNlc0ttZ0NKY0pibmZQQ0wyVUdJQXBkRnRuUGdxbG5uNmV4N3M5MkRIbExU?=
 =?utf-8?B?NGdSQk13YnZtWjh5eVk4alk1SVJSTnhyenFxUGpZcnBTd2VLSEF2dER2Nytu?=
 =?utf-8?B?VUNOZ0hoQ2dSZS9qQjRqQ3RzUVRZWnZJUEhOK2NRdlpUalM0VmVKb3FsN1Zr?=
 =?utf-8?B?clRCMFljSkpMTGZKbWt3SlVTbzhUbUhzSzM5ckkxVjh1ZFpJZG1uWENoRlBL?=
 =?utf-8?B?REhBSklPK2JDb3JJdFkxQzNpT3hlcFBXL2k3U2dvYUZHaDVOa2NXYlQyRS92?=
 =?utf-8?B?U1RCWHJOVURkOXkwM1ZtcWtuMWtQY3VPeTNkV2ZKZ1ltUFZkdlVDZThyV1U2?=
 =?utf-8?B?WkZDSU5QWVpETHZ4N0tWa1haNnlCdGpyUmliSTd3NzFWZVNkYWpMUDFOK0t6?=
 =?utf-8?B?bUpsQ242My9zUE41RDdKdVJYQ2wvZXhpMm9mN2hsWU1OR245QUoxQnhFNlBa?=
 =?utf-8?B?Q1pZUStHREU0bXJuSFcvL0ppZ21XZ0toSGpHU2lpWDJVTEFyNndVMERwdEhH?=
 =?utf-8?B?MG1xNlJSdFpyTXBzK0VET05kcHNHMWRZWHIrMDJkYXFGNTJOUERNKzVnTDc5?=
 =?utf-8?B?TXlLbWpwdVV6UlB1SWFsaENzWUlDR0RQQzRib2FIWlEwVFQ4cW16M0YyeUJq?=
 =?utf-8?B?MFBuVzRxS2RjMTBmS3pENzFIcmpXL2NWUW92eGdQRTlZQitnYlB3U0NlY0FZ?=
 =?utf-8?B?SW9rc00zRnIrdG0yMXE5a1hmR0lSN3dXQ3JYTU5wNU55WUg0ZENzMGNXWlNC?=
 =?utf-8?B?bC9OQWV2bWtQQ1gwakhzUGxTb3VaRnVyaWl6VkZadGUzTmFaWks4OHBJK1Vw?=
 =?utf-8?B?NERtY3J2dzl6dWpGcjlNY0o1WlhZNElCUDNJYXZudXBKam9Ud2tjc2dUVTJS?=
 =?utf-8?B?ZkE5RjYzSEEzZkdUdUtJT0VKMmJvQTdVRWpjZDErYjgzMXBrZEwrVnV4OGpL?=
 =?utf-8?B?d3NKWEJpZHVDYVRyMnFmbmtUOS9weGV5ZjluM0dDN3VZcGlZSWQ3NGxrNWdK?=
 =?utf-8?B?M1czeEhSVjFpVTRialdoTXhtVHdOZkxYVWhPdEhLVGp0QzcyMGNrQ1lFcEFG?=
 =?utf-8?B?WGVNYkVCK2s3NDlrWGJQa2o5cnNZMlJrL0s4V3JFK0U3c2taMGs0enppMUJD?=
 =?utf-8?B?eXY1ZVpwTDBrQVZGM2FMSEF4emJrd1hxSTA4MVRSdWpIbkYwZEZwTUx5MHdB?=
 =?utf-8?B?TjcvRWNrODhyenhENzRRVVB0dHlKbVlHVW5RT1VISERNemlBMnMyTS80R09z?=
 =?utf-8?B?V3RrcXVKaC91Z0lmWjJSSE1WdWZCWVlpaU5tdjVXaUR0YmtnMUs1R3dnYkc1?=
 =?utf-8?Q?o8zGkm3FYSWXnXseEu/uOgk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGNSNG1FbWJjcS9aUmJXSk5TREhwNVhRYkpRNnJ1UklVMXltUWZBM0ZacDdZ?=
 =?utf-8?B?eU53eU1xZW1CZzZUZHBzSFJsczFOY1AzQ3F5dWo0S1lNVHRabFRFMTExVzFW?=
 =?utf-8?B?QjF2eHNTejFlcmtiQXI3aFkvaUppVi96VlE5TTFOTGl4cm4wQ1BNWkRaeE5v?=
 =?utf-8?B?cS85cW5TS3lVa0tZRlFNbnF5ZTd3WUc3blFMeThmQmZ1aWtJT3JZS2pVNXJT?=
 =?utf-8?B?NlRiaGtmWWxobWx0dXppUWU0VGV4ditlNE5qaWtmR1hFWkdwdHdzN2IvLzNw?=
 =?utf-8?B?eGthQVBIYU5SOHViNVhmaThVSEhwaXVqSVQxWTJmS2RUaUpjMzFYSk1Sb2hr?=
 =?utf-8?B?eVpkRm0vVW5IWCtLbFZrT3huaCtjWEpJUlp1b2NzTVlGQmFZWUZ0ZTVRWVJn?=
 =?utf-8?B?MkpJNWRsYzRUL3FmRTVieTBNK3hkV0lzZnpwV29NblR1OVJBaWZCNHR1Mjht?=
 =?utf-8?B?TnlwTm0yNWhXaUlZdkd6ejlra2NGME0yYTRMS0I1SzIwQzc1ZnVPQW5MNWps?=
 =?utf-8?B?M21JUVRvMlAvaUlzMUY4N3V2Z2ZQYVRUNmRsTTBnRnFIdUxRb1Iyc1k4UFZv?=
 =?utf-8?B?RHZOSXdoRG11Q2NEV2ZqenRZa0F4SWpPQThoU3hWUTJiOUtkUUREQU42Y2dP?=
 =?utf-8?B?dnRpZUFFZkRGY2tjYVVleFp2Y3FWOVYzY0lUMFNEK2l2VjU2SnNBL2pUTi9T?=
 =?utf-8?B?cWZ0MUovZmY1YzVqM3VQVk8xZ1RITDl5VmcrUnVYa3loWlQxSmNFaE5jcFpP?=
 =?utf-8?B?eHdHVHBaVzBscEUyYklBWGNycHBvdDVUeEEzbGlqSndJSG5oa1dUeTFuaWtC?=
 =?utf-8?B?MFM3S1hqMXcxSTl2a2hTQjR1WmZxbkZ5QSsvSEN0dFBnOFRhRWp5Q0lxYjg5?=
 =?utf-8?B?eDRsbUwvMUp4b1NsUFpOamExUGU0dFErNDhMTkZOenE5Zjd6SVQ3QklIUVBl?=
 =?utf-8?B?VHhndzVQcGJEdmIrV2Y1S2UwNHlOZlVINEEwakdGRjBuOCt2MUtxL1hld2J1?=
 =?utf-8?B?QWtMRUoxdnZYRTk5TTQwdHJjL1ZOQkVLNWY2TWhSV3kvQ3c1a1JHTGRFYnVD?=
 =?utf-8?B?bjZMQmtlSzFSR1VCMUxlQ3hyY3h5TUpMcW9Qbnpock5CNTJxb2tFSlZLb3ZB?=
 =?utf-8?B?OUdDZk1jcW1ydXMxOTVNcUZpSDAwWHRMeG5NcHcycVdmcWN1UGdTdXVPUnVx?=
 =?utf-8?B?KzZsc0hHZ3lQc3ZTbXMySUZWR3M5cWhpV0RxODY2MFdhWmZTcXNJTmRLUkxT?=
 =?utf-8?B?Vy94OU5RSVNHcW9LZEFxSkh1QkQwaHNweXJrRy81SENldEhGUHJpZnZJK0JM?=
 =?utf-8?B?b3pqRGpRRXg1YTVHbGMxLzR4SWFMMFpqSmZCSjh6TFdZbXBhM3FEVXNYQ3pW?=
 =?utf-8?B?K0xqaG9ycmZia3JiRW1EbjRGVDlDeFdiRUJSU1NtUDh6eDZBRTNjUXF1OGEx?=
 =?utf-8?B?Si9hV01oTzFuRiswZk5yZTZCQTJuWCtST0ZNTlNTYnpvbmRESVJGdWZCekE1?=
 =?utf-8?B?SzJrbzRpZ01Ca0k4NG8wWGVCa0REZk9QQm13N3F2c2s4VEdlQldpeXFaSGRW?=
 =?utf-8?B?dGZodHlQMm1ZR0NFMTRtL0cvdG9VRFZ4Zk9Pa0VYNEc3T2JTdkhJdDZrQmpW?=
 =?utf-8?B?S2RBMGE0azFxSTVudG5obWJweE1ZR0tPNHVjSm9HQUtnbzhMQ2FNVTFkWStJ?=
 =?utf-8?B?T28zUzlEN0ZpcEdpUHArWm52UjYvenRaUkdUbzJncDRwSzVNcUV1UUtRd0d1?=
 =?utf-8?B?YSs2VFVlOE9uMU1JZlJMejRBVCtOaTE4ODNCSmc3K1ZBemZIUkEyMDc4Wkp1?=
 =?utf-8?B?OGJyMklGdnZVUC9ZM1duK1pZa2NuTzNKcTVmbDlWQkxNSWVNVWlxT3JpQWlO?=
 =?utf-8?B?LzY2aTlVczdyVGgrQlVBaloxTlRiQ0JTZ0l2ZDJrU09BS3JucDNZdzhxdnVz?=
 =?utf-8?B?VGQ1ZlloVlNnT1l1S3BpTHBEZWE4S0VZS09vZDVvc2xKdEVhdTJ5eGUxN0Qz?=
 =?utf-8?B?REdScVVzTjNpWkcrOEhaU3dseXJlMUNaRnZROGY0bWNTMEg0c2F0dEZjbkd6?=
 =?utf-8?B?M1RLUGlwTUtwaFJURDFPRU5JVEFrL2JubHM1STcyd1M0T2s2amFieXRpWkUv?=
 =?utf-8?B?TTcwY0Y3UFNlTE81cWVFN3lIYktCRnRtU0h2aGRyV2VSeXliVHErQlpMRDYz?=
 =?utf-8?B?SzVDaDI2aGRxVTVML0J1UzlnYi9jdTFMeEZNeDBPS2QxZ3pYK1lYK28xRXkw?=
 =?utf-8?B?T0tid0pRdmZxaHZUUzAyZ1NMbVE2Q2dKdnQrM3FuVTlaWVFhR1RTdW04L3NB?=
 =?utf-8?B?Tit4akdYUEFpQ0xaclVwNkxJOS93dGZXb28wUnpDYXJBL3A0S05yQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B797CC073A86BD4B8C66283917818258@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258ab965-9019-48d4-3f52-08de5a553131
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2026 07:58:27.6567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LB8WtVGwT9ZYA6sVvkuJ21CWxyDMw5aj2jfhev5j7GFTab0z84OC/BJTE3c0OHIpJHz7JCP/ZiQ911drf97ToA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8397
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 315E9C0002
X-Stat-Signature: 95dh4utn7p1w8xrt7wybqc3ib8i5u4ui
X-Rspam-User: 
X-HE-Tag: 1769155113-160333
X-HE-Meta: U2FsdGVkX1+HiL8ZV7L3f49poEq+20vu64r5Y179NG1AOi/5jigJOyyRkvDFJKw9RRysC5VqI1W3gw9Kxg0bc/2gkz/WgBCzYdQAtl/jKUfxyr2AqrDMCkdYUxH9pPif6QFjNv8YQ/uH3VlvPZkG2KgSCPPjlvP/Y52khLNLS1TYoIr8hroYJs7QpodSZEVeO3wRLIGen6v09n3OPhhRc24GZebzcATdczX3ppJfH9ILv0plRQLBUdSEVVfbNbaY+KMPUpKsrg+AMuDtdo9e2K7TTE41gfelAtOaaF32jNyNbqtCoIxbH3HIFr35J8vsWr74VgJS3MILbqlHdScwPHeUdFw7jk7lJgaGe3EDRbxFxAj9pGgEnOKkItdBCYzl1TbNbpJAvsY8vHWvY/ANevCkRnMSXGl3G3B33LyFgTenDDcI77yc1CdzM+PbxlTyJKmNSB8HrosDOvbp/QbGy7/heAQNziUVLyBt1ey6xJgoT0/9cClpe0DrqybAr8nh9eiq0C9z46ooGlqqxVU5W7pumizkBj5DI2BS+7fiyCEX34ei6RQ14e3z+D+sGmaZrqbiSGHo3IRU4K31F45+GMsh/y/06+lfTBPd0up4UwGsCPOXPney/khv2itZ0QjA0RdJ0LLJQvEqM2PvHldkJCPFeVv/e+FcWvumdHOdiX8tYE17DmRzh/QI8oXMQ7H5mwER8hVqUwg+D9KetuK5M4SKXW4ITKXlSBSesGZLGqErVBS4P57ZcLU0sU37RVVjgM9WUCDggtbCkejh6ybDo3PwjZTljjb6cpZJL45EtNkkfCHpuL9OHAky1KWXgOuHetpN6fJUqcBOFABZPZVJJPEZdUI/QZsY5QUnYebXDy3ZsVSEQgzH1nAsIxkiEcQ4iBA6NuPyjlj5gy/m33o8k7PBq2k4u5j8Ypm3KjdHiO27F1dZEoALkFrO2JWimcn6y9iPGR7mJIXrJgZC231
 WorOAGaB
 Zf5hDrBY2dFC1bJHdx2Tc4b8eCa/8zsOVAaY+oYhOjsUiFUekGMmxgsGPBp8d64oKoAUna8cOWsdtzX3Zbn5rtT6p+soRlV9Hpy30hSBuJVQV/dhyUbzhdzFmlEfROVfAyf9j2ZfLLfrm8+ggATm/t9I/M4Uo4Jm0Mo67vXUJdCSK/sXW+y4mY0Xj5JPBrRV4VRCko8Fbv+IzBHtQsqfO5VUnKlULPehoF7WfFek2n7tyGOrjZNtJrqzj+OAcTAnIcuMlkDE7Eew8reGM/jWEOLaRcPQ+xyMhbeYaggtJHh3V/U+10pUhGFfA9pJpyqSeHpSBSWoTJXKlHZ6ZlpNiQpsY2tWOHz5WmQTZM85C46IxKNizQ5DPxoZO9miAZXMSKNyo0ESwhbifn+jBvlqIOeOxmGOWblcKvbc0e1O1LOAss4fMvcHIs4PGnHPYzQgIxqZd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+ID4gV2l0aCB2bV9mbGFnc190IEkgdGhpbmsgInRoZW9yZXRpY2FsbHkiIGl0IGNvdWxkIHN0
b3AgYmVpbmcgaW50ZWdlciB0eXBlDQo+ID4gc29tZWRheS4gQnV0IEkgZ3Vlc3MgdGhlIGFkdmFu
dGFnZSBpcyB3aGVuIHNvbWVvbmUgZG9lcyB0aGF0IHRoYXQgY2FuDQo+ID4gdHJpZ2dlciBidWls
ZCBlcnJvciBoZXJlIChzbyB0aGF0IHdlIGNhbiBiZSBhd2FyZSkgd2hpY2ggcGVyaGFwcyBpc24n
dCBhDQo+ID4gYmFkIHRoaW5nPw0KPiBZb3UncmUgcmlnaHQsIHRoZSBidWlsZCBlcnJvciB3b3Vs
ZCBiZSBhIHVzZWZ1bCBlYXJseSB3YXJuaW5nIGlmDQo+IHZtX2ZsYWdzX3QgZXZlciBiZWNvbWVz
IGluY29tcGF0aWJsZS7CoA0KPiANCg0KQWdyZWVkLiAgSXQncyB3aGF0IHR5cGUgc2FmZXR5IG1l
YW5zIElNSE8uDQoNCg0KPiBJJ20gZmluZSBlaXRoZXIgd2F5LCBsZXQgbWUga25vdw0KPiBpZiB5
b3UnZCBwcmVmZXIga2VlcGluZw0KPiB1bnNpZ25lZCBsb25nIGFuZCBJJ2xsIHNlbmQgYSB2My4N
Cg0KSXQncyB1cCB0byBtYWludGFpbmVyKHMpLCBidXQgdjIgbWFrZXMgc2Vuc2UgdG8gbWUsIHNv
Og0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

