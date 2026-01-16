Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E78D47CA4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B539D6B0096; Thu, 15 Jan 2026 19:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E5C6B0099; Thu, 15 Jan 2026 19:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9810A6B009D; Thu, 15 Jan 2026 19:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83C5D6B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:00:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A050B9D16
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:00:27 +0000 (UTC)
X-FDA: 84335870094.19.47B1A9E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 54F0840017
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:00:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PQIRViDv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768521623; a=rsa-sha256;
	cv=pass;
	b=XB3SRcmSG8W9E65B2pRSh9GhUdMblbJcZhlaOSqq6foFOb7ym91QkSRFMdrpWMtfSEp4fj
	Gvx+Ux8hMz20gy3+HCWHS1/zn2TPG9jQytbxcjzUShHL0PGirCJmMnlEH4E7sjhdEDxmS/
	+xoJnDTwyuPA+igPBPqcLRotZ0zBQpo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PQIRViDv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+J5cLn0zrTc4uYNyvXGPjmpluFDBooU8r33HyFUhfE=;
	b=JlKwFrbGDoqSoOsB0YQjz24l1wY1gwd88qdzaN7PGlyIq27V6p3Dzwp2eEqksLPX11YF0M
	t1nCbNS0u6DBP91nQxhRNG18e147p64XJTxaaDFX8bNGY/ijjo3y0d4mnx1bm0mYnuO5/M
	dGy57z8ydS90KQJ40sdPQW/nGzySmlc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768521624; x=1800057624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J+J5cLn0zrTc4uYNyvXGPjmpluFDBooU8r33HyFUhfE=;
  b=PQIRViDveU5i8OLO9Vb64IcBF5nhbet2zeuuHbX5QQweGHbWvvht5/9D
   PinCKsT81q6+/a0/33p72XQ9xiHDW09fstzPKrJRPHPtvjgyVB2m6GsBl
   gzPDYlFLAGaoSYQRbCtI6L7ETNFrK7bqkfuQKTsjG48MBM+L4pgIS5yNI
   6aWeJcToVYG+a6WZErtRp9FLajY+TtpPeB28Hqfm/aMdpPHBolQwu4gd+
   Obhg5p7+f9QtSpUcZMMpB8mjtzM2uWSaneLpl5BHsd9QmaLUcQcJ0NuKz
   Rlq9CQvnPxWG8nXSimFStmVaTZnQIPGxFk3uzglt8XLASW/DXW4RqqO5K
   w==;
X-CSE-ConnectionGUID: WonbwOgASxurMsGT/dd1zA==
X-CSE-MsgGUID: 2Kcjn5LrTC2x/27vELXEMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80950309"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80950309"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 16:00:22 -0800
X-CSE-ConnectionGUID: CjWqP0BGSGiU1sXXYx43+A==
X-CSE-MsgGUID: Up88fRUXTZusZ1aHFHrd3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="204879906"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 16:00:17 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 16:00:16 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 16:00:16 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.65) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 16:00:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xCJpM5VQkxwHDqi4NjoRRipIIG/GjidXi9OdVAW+QaZqQvB6M675lZtKBAR/zRNkL6/uRIcvV1n8B2si9V7KH5xTJJDZTPJMLQR+g7biHsV0ZoCV09otp8QJuJ50UGzjb7ZHXERcycEP3ObuJzuj4A3an/fgscRdifZBG0w2l4oTrdxFJwnjWIA7IegBF/HfWIYjPU3nqa+1vMVzLTf51rzT1lfN+joMl7QuYf0UNECJSB385w5G1zf2LbtIt4EChA1XBAIOCfXHi6xgJoNZs1OcJyxbDRbnByTRoI3Twcp6DC7CmPUIeXftPnTbSdUbm1ZCnB0eUZb6fnEA2wq9UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+J5cLn0zrTc4uYNyvXGPjmpluFDBooU8r33HyFUhfE=;
 b=Nqxz3WQv6rRBzJyeBGZbQQsXMH2IluAenLAGjj8JwGEk86TpSTlneX6BYBNvSEJlbd5oDUtnKuStLom5mPYEQgndMaAh/Wce/LskmH+MRuDW55hpZWade81vwswOvXSgSo5elgI8/xRxgTF9t/f8Ngix3IFRJlADV9eBierZPlkdsS3WkDfaU7go1ulvbUZ33XPUf5BZSPmrNZnd2GOmu+hYVXQwK3qjEf6MwW+L/lr6l7wzkxlbQ6omFv4Lvz09w79qdg4g34b8/o1zgn7SPcMyY9Jlnt90z6pRm0TMVqM/wSL+Qr0BZiM7jK1IWF2L3IJ1TsYdf1fb9+ALDR2ThA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by MN6PR11MB8103.namprd11.prod.outlook.com (2603:10b6:208:473::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 00:00:11 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 00:00:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
CC: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>,
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal"
	<vannapurve@google.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "wyihan@google.com" <wyihan@google.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk"
	<itazur@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com"
	<derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com"
	<jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
Thread-Topic: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHchnGR8zlgd593vU675Y8ML/1Q0bVT6T2A
Date: Fri, 16 Jan 2026 00:00:03 +0000
Message-ID: <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
	 <20260114134510.1835-8-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-8-kalyazin@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|MN6PR11MB8103:EE_
x-ms-office365-filtering-correlation-id: 5397450f-8296-4c54-2add-08de54923413
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MmR4VUh5ZW1CNG93a2VwKzJ1N2RjdHZ6K0g1VkNIMXJVQzlmTElGemgyL2FU?=
 =?utf-8?B?SWZyVEpFMHVEWVJEWmd3Nzl0Umw5QzdYd1UrYWNFNlhyWFcyVVZ3SU80SkV0?=
 =?utf-8?B?NWtPTlFEbHFSLzdpSTVKanpDQjZRVVYrVnAxd0xtdHVhNUY3VlhPaFhwU2Zv?=
 =?utf-8?B?RUdvbUk3ZDhEd2dFamNWZzVLMmhHVTFwbXRkZHp3RXh5cHFmWDI5Y252emZy?=
 =?utf-8?B?UUlha3hMbVlxVkNnc21POVB1REh6dVMwanNZZ3RDZGtaU2cvQzl2Y0htOFJp?=
 =?utf-8?B?RFpkSWdEZnd5S01tUmZqYWQrWnJaQ0dsSXVCMDhJMHQrTHpicmI0VFhEaFU5?=
 =?utf-8?B?UjdzcWo4VnZkUHEzdVdKK0ZtOXlubXdHRFhwSUJtVjFTTjBoKzBvTGhPRWlu?=
 =?utf-8?B?bzJZak9zaTFBYVNPbVdCSjd1OHdUR1lXN3Y0L2tvVFhodE5EYUc3RGlIZE5h?=
 =?utf-8?B?ZWxUWFdOWi9KR0JZbDNIcldndWtacyt3bUp1djd6MFBKTTNEUFNvYTkvalp4?=
 =?utf-8?B?Si9Jd2RROHEyZUl5STYraUxnOHZPZkduL0VLeXBscVNwN25GalBBVGR4dHNY?=
 =?utf-8?B?aWtScnpQY2xuRGFJZlh4TjV4SFNpRlhiUkxMMDIwUkZwRWU4R2xGNDdWdHRT?=
 =?utf-8?B?dGdndHNqd2c3V0drd0hVcWZwek9tMklHamJ2VGVqKzJ5aml5TXVGbllEK2t4?=
 =?utf-8?B?TU5Mbk90OTh5T3JwOTM3aHUwWnhnbTB5SEtjZE1PWVF2dTdRQW0rOEVmcU8v?=
 =?utf-8?B?NkdocGxrcTVRb0hZelF1cUxnK1hFci9DRFRFRnAwUHFUSGgrMmkvOVNyVEdi?=
 =?utf-8?B?MnB4SnRuYXFmWlM5Rng0dGJHR1dDTHNGdkd3QWFueC9YdWcxS2NWSUpCWXdC?=
 =?utf-8?B?eG4zYkcwc1pXYTRRNWU2bFRONjlZL3U4eUhYeUEvdEhCVHZMWXpDSDRCaVZT?=
 =?utf-8?B?T0hZeUkxd0V6RDZKaE5MQzExaUQ0aXdWbXpPdlI1UHNOME5NV1VGYjZlVnNQ?=
 =?utf-8?B?V0p3bEQ0UzR1SWlLWng3aHpFN0gxL2wyMTNucHhBN0dmenBROHJJQlpsME5K?=
 =?utf-8?B?Y2RleFFDeDBrT2p0aHBuNjN2TUtob1hoWEEvT1hwLzF0THNTdFRVOUtGYjBp?=
 =?utf-8?B?TjRnNlAxQSszS25rTVNrSWplQ1BpdHhpcVozZXFRUEk3RFVGUTdudGt0blJr?=
 =?utf-8?B?TStpM1ZqRUZCWGNvR1FENUJ5N0ZzNTVNbjUrd0k2aFR5UzBXdEZtMERabTJn?=
 =?utf-8?B?YWN0ZlY3ZTk3VWRTSUhHdmJyWENUS0NIRlZTdmwzUVV0L2lpZXloa2xUU2ly?=
 =?utf-8?B?dTV4UHJGNlJ2VTU3YlFDYnVIWEc0WlNpNjJNM09kdlNGNkEvRW9JZk1SZXlt?=
 =?utf-8?B?OUkvQUV4SUtYaG5qVVdMT04zRVZlWi9Qdk83R2lqbVptVjJxcjl5ZklZOVI2?=
 =?utf-8?B?RTZsa21aVmZCM0ZQakZNYXFYbk9HeW1GWkFkVVF3ZEVhMk9MRHB5OU5iQlY1?=
 =?utf-8?B?NG5mZHpuK0xELytnMnRlNzMwdkZ2QWtPZExEWmVxUlpRMXZJVnZvOXYxSUdF?=
 =?utf-8?B?TDZOMnF0ZUFiZVBnWFZJYnJVU3VKcUYvN3Z0SUtZcFpZOG1hdzZ4SVZRQWV4?=
 =?utf-8?B?NmwxNk0xVVNLTTc2OERwNGhTWXAxSnhRY0VFYU5iRG13cklnVUNjNDVpV1p3?=
 =?utf-8?B?M1RlbE9tM3pIYkI5K2k0VnZnY3JTUGdrYkFmVk96TWF0U1piTHd0a2lvdzlF?=
 =?utf-8?B?NWxXYTlxK3dWbitsNVRkNkUrUWZ2bDk4N1VDd25ENmFPWkhRN21nY1dnRjVD?=
 =?utf-8?B?UDZXaC9HZVY4a2JCY25RMVU5clY5M0puNG0xU3FRRGNGL2p2bEFoeFRUZ0h5?=
 =?utf-8?B?Zk42RS9pYWtIclU0ckNRSXU2bXQvZ1ViT2k0TFh1U2pvUzVOSmRjSEtVMnhL?=
 =?utf-8?B?cGkyMUp6ZTYzZWRVMGNHbThwY21xTWtHZGd4dW1WcFM3RHQ0TGQ5T0R5aXJj?=
 =?utf-8?B?WS93ZFh1UHV1ZTJ4ZnlBWXIxQ1YvdjdRSEJQaDVucEZsQ0ErS3EvR1hzcDly?=
 =?utf-8?B?R1cxTUdPaXdMNi80VVFMSkhxait2MWhtY3M2enptakJTMnU4dy92Vk8xcVM5?=
 =?utf-8?B?RzkyVXlzclBLR3o4ZjFwd0Fsckp5MWg1Y0gvbjJaeGsrV2w2blg4ZTRmRlhk?=
 =?utf-8?Q?kfY1eZ4BUX2eKEBv2YR6qGtnHum5RV8kvCJSl8NRlfMC?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHpLcS9rbmNoTkdWQjdZOGcvM2dQQmhsaUhWbThVbmVUaWV5T2dhd015aEFT?=
 =?utf-8?B?aERJYndFWkh1TGRjS2ErTkdIVGZkamJHazloY3kzUW1PRzVLTWsza2I3VDhJ?=
 =?utf-8?B?ejFLNjBtWDF0VkVKbExLWUZsQlhocTYwU254a1RLRENzMDRXUEs3bm94Um9n?=
 =?utf-8?B?eWlhNVVOQ0R4anNhbzljVWtjL3d4Rm1CdEo3ekpLTW9kSDRVVk5FS2hjZW5K?=
 =?utf-8?B?ak1RcnBWOVFhOFFmcy9vRnMvL2xYdUtiaXc1ZEtmNmRzU2JaSWwyQnRZZTN4?=
 =?utf-8?B?bjhxRlZVNUI0aHlBQW03cWRuNVpRVm9jV05wTnV1cDViS2lDMTZJYjRKZGor?=
 =?utf-8?B?c2dHVktVc2d6V3hsY1IxbVIyZnBqVHpFbkVqNU1nS1BMblBDL1pGUlFaTkJK?=
 =?utf-8?B?cWV4Q1VjamJ1RFI4dk92VlRia3dsOVlObnJUdEJGVlFrU1paV294eThZVnJG?=
 =?utf-8?B?S1diMGxjcnNrTFFaVnpkN3JnVHFHS0xIditRM1hUK1o1Q0Jsa0hCYU1iemlm?=
 =?utf-8?B?SWN1NzRJNWpJR0YvTkpUd1dOWHVRVzJpOElqRXQya1N2SDFaeTl0azRxOVZX?=
 =?utf-8?B?REdKSHRxWGUvTTVjcTZVMnpkRFUrUHhraWJhOHBoVHBrclMvK0s4WSt4eUJQ?=
 =?utf-8?B?ZU0xZUNQb2NEN3dqVlRXbnBsVGh3Zk0wbVNZTjJlclE3RnFISTVEZ3VEbnJF?=
 =?utf-8?B?anMwNndZdy9SY2RYQXhVLy8zMmh2UmFaWGRJVkJ4SUxSUnJQcnhQRGpzUGVS?=
 =?utf-8?B?bEZ2Q0NYUG1RQXE2T2s5RG5BK0oySlQwS0NIbEF6ZWF1bGwrVkNCOVBQZWkx?=
 =?utf-8?B?RDkxeDFveXc4S3hHN092V2Z0azV5eGpsY2ttTEUyTnNQNm5RakJqWHZOYWR2?=
 =?utf-8?B?VHhLOGRFbE1QaWhaenB5Y2F5cjRxRDNBNEx4V3FkOHdrVzcyMjk0SXJJWER2?=
 =?utf-8?B?TW5wSDRqVGoxOU1EMGNFb1NKWG54NnpwOEhkbmErdG1GZ2RQNDJiWktSdzBB?=
 =?utf-8?B?eG9YaEZiNlkyOTBUNzRuRDVkNG5YcHB6Z2xYTWFPY3BNOWs2UjFIVERlWmpm?=
 =?utf-8?B?L0xQVWh1RmdiUmcrcWFIb2hnVkZMWEdUZVVJVThCaUMxa2R2SjhkT2VZeW1V?=
 =?utf-8?B?MVErU0xWSitZL29DeU4vd0hucE1ZZmRSWmFSOXRlNWdzTUZudy8rK2NUeE1i?=
 =?utf-8?B?RTlpU3AzQUtRYXZIcFFxcDFydUlTQlpFUXhEV2R5TDU1ZkliNDRoWFQ0VXZP?=
 =?utf-8?B?UXhNRXd1SFJ1U01nTXBMVU00WW1wOFkraGFaVlVkQnRvUmFZdVBLaFpmZnA5?=
 =?utf-8?B?QXNHalZIUXB5L1RCb0N4UDBMbU03QVRYVVNlQkFuSi9wVG5PTGZxZ1ovMVdQ?=
 =?utf-8?B?L3NJeGtzblZ5TXE2ZnRqTkcyeUFRaWd4YkluSDZOR281a2ZBRWg4cThWRnQ1?=
 =?utf-8?B?YmN4VXROb05mZTAvWGNIWTJKL3oxRUhjaWYzRHUreFhmRGJNRWRGREpnYWJl?=
 =?utf-8?B?amRSOVh4OFJKMjdXMTY3SS9ZYk4xajBPR2phTmRzRy90dGVxUkFBQWdhN3pX?=
 =?utf-8?B?MnJQbVo3U2dOL3BNTks5WWk4VW5oMm5Ia1NDS2RYT0hzZlFFMDU0YjcvSEdm?=
 =?utf-8?B?am5SQzlPd3lLOEpQb3NUVU1yOW0zYndqdWhyVFVYVzFSRTVCOXR2NzhKaUN2?=
 =?utf-8?B?bGpaay9tWXBEQit6ako5T1JtUGN3dS80d1VicmU2K2hLYTI3dGFSaWZPUlNi?=
 =?utf-8?B?OGtZT1RpWjZ5ai9HSS8xOE8rYnZpdlBnSXVvRmRZOE10YnVkL1pJL0NqWi9L?=
 =?utf-8?B?VFpHc1hPNFhFM0dkR1BORHlzcUNrU1lMUzZrV0NNRkZaak96ai9BTkUrTTly?=
 =?utf-8?B?TUpuMi9TS3pXZ2M3eE5GclB5M1grOGgrQTI3Kytteitkb2RuY3FFOXhkQys2?=
 =?utf-8?B?anh3YVlmWVlTWE5ObmU4eng0c0FTelplZmQzbDNWeXZBZ3pEakcycWYwVHFm?=
 =?utf-8?B?aVBHMzdkaHFUWGhMSi9GRG03VEowV3NYbDlraXlxRmVUdzJLYUtZdzhwN2VH?=
 =?utf-8?B?RTdlNGxGZzVLNkhuNzJXb2lJemFOeG9RM1kxNGtDTFhHUVE3NFVUVVVDdURV?=
 =?utf-8?B?TUhaQktPZ3UxNndkVCtmVVFBenJlN3h4USsrcjBzb2Qxd05WOW9oeUdoemNK?=
 =?utf-8?B?MjhGTXJGN3k2ek8vdCtKaVZHQ3BvaU1QZDVkb0hGRG8zTkNJbkpYZEdUdnlD?=
 =?utf-8?B?eUVwOC81SXdiZWFPaFhFdjFVNmxsTVNGYnpUbzlXK2x3RkNtenFKNTZ6SWlZ?=
 =?utf-8?B?dlhLSUN0THRkdGF2TzZkQmdWTkx1by9USEVUYVRaMVIzU1NybUpPSTlHeXFk?=
 =?utf-8?Q?ZCXQT9N7A8tyaDk0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D778212393176E4889C84558D1CD40DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5397450f-8296-4c54-2add-08de54923413
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 00:00:04.8118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: clx9b7O834azFuaZENO40EQPS9x569x9m5RnzkxwUPunnqEFME29c/yTLORmWKfVntg/8cEHmrAkwFgyyqE1nvtpoDmjXXmsK8FitxasfLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8103
X-OriginatorOrg: intel.com
X-Stat-Signature: fahbdgkdh6y715itntraizabxmj8ahf9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54F0840017
X-Rspam-User: 
X-HE-Tag: 1768521623-870732
X-HE-Meta: U2FsdGVkX1+gZ2hVSr/4v1MIHJzdC1CbJAbLY0OMLuOCHF9GhUpbKi3xYyu5MVSsG7XJn+Kqxa30x77o8IjU7Nk0PJtI3vwPF0AAghQIxGC9hxXuD2TEsXAQmzs6Ahk/71AZJZPZReYY/xQPX0laoYNWsuxGS+ZEonWj/60MLrVAv6umtGwHg3eNaAwwi9/A2zUqPdDu+56HTGBNF1hfqTmuwCIHc5B295bIxDtkrX3aLUiGjX3gW4F08q3uglfJgF6Vz8W+vnkiwk35av5kVjSwQdvqBK9u8I280YoQn4C7ZMrPqMeGJHQtNjc1alpwgyGVV//fulTJVds+rG0BvAR8m1hyyeuAjWFpE1GnnTzZV5E/3RTfOGPgbAdPRjMrWYuhdX9xT/oQ+lynRLsscN5/EI6Lfp7TeagaQ9/IAj3dtHzE0xcVcfsERfiTBNmEnbC1xWLcBrW6Vm5xuM6GGLYUg9Hoxzf59n8KphNYTGwtTvSueg7MocrPkJJq4j/3CVY+GgfkAvFkXrSZc/a7TJB3FhJKUkUiKKwopXIGrQ2s6ufzAMEo6i5PCSWTfpLKZ9Hjh7Q7G4jXE2niovBDd92jJtEsB+4ML2BDw1h4F+Zjdkbw0/bB8HS5v71Apz/8crRlJ9I9+eOSZLkxPVm/K20FEBf4ArPeG9XGcXziau1e7D2tS5OL3HZ7AVu4gPGM1HpteRs0fPAI1Hh2FJt6nMtq8nqKrLOfLvgyPDx/+Tvi59KwSfaFn74WSYwA8BtuiZsNW8wwqLd+W05v4VaOs5SqaIq2e17F8yr3SxWQ7x3L/UcMimBckX4SjQQks3yLz2A5OUuyL7IisLruHdu2TcXrVxvWIk79CyUVUfmf2fo22vykWMjE97SSVtflY9dMbb6K42ohcjNoiknpzqrGbCAfmWZYG6BGDMBFtPP3dWowAnefYkPH30J+hybkwc5l6Bz3abqHvAnINVHjDk/
 VGHbYfIh
 nB9N1rFNkkJK97qSwo43fZjeG9MJYLCvk5i9vHC1JrRUCYUyp8yr42OXsvArmpkit0N4fkNlwTWrm9eyH3yf2Qf2RD4qXLq16gEPYok/tcaAgosXjyBaosgLaTzxe3gdca+CChV4uuPAptzNBrKlUTdyoztgu4nLz35Zko0MlOjlZVCHbK1PH4vL6h7w0LeSwmURzKiFI4xaDLsBnfCzkRTmqKgDawffAnL8ZZR6URB5ml47YpKIz3yEoUD2pZJHwFGJmKd+tusy1HD1ZWHt3eQqm7RilsWsJzHvyf67pjT70Uq8AX4AetDqpwjKGK8i30C/B8dpZ6D7vx8pbsby5xEC1I09/LQJY2nDc3ObVuuFXFKDvuEamJDrlLBrDd1/i1qBhN1vnAgMpjVdUSb+ShYBJTYj5AZaUCJ2vPqDkDX6+n/47AfFIKeJmqtsbCURXQK6JchubZEy23z1/dazCiZ/BKt7jQ8ck4M2l8BcwpuW6NY9CMiHGG/JprruETNwavrFzQRRa6/2KKPeLzacL5w+q91AYOGcbCjlEZKyvMHgMLbCk0wEO2PQlB8MXz4GxDRvrp5SIMmmfjq/uK7Bxl3pnmMUkD7jBtVFe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTAxLTE0IGF0IDEzOjQ2ICswMDAwLCBLYWx5YXppbiwgTmlraXRhIHdyb3Rl
Og0KPiArc3RhdGljIHZvaWQga3ZtX2dtZW1fZm9saW9fcmVzdG9yZV9kaXJlY3RfbWFwKHN0cnVj
dCBmb2xpbyAqZm9saW8pDQo+ICt7DQo+ICsJLyoNCj4gKwkgKiBEaXJlY3QgbWFwIHJlc3RvcmF0
aW9uIGNhbm5vdCBmYWlsLCBhcyB0aGUgb25seSBlcnJvciBjb25kaXRpb24NCj4gKwkgKiBmb3Ig
ZGlyZWN0IG1hcCBtYW5pcHVsYXRpb24gaXMgZmFpbHVyZSB0byBhbGxvY2F0ZSBwYWdlIHRhYmxl
cw0KPiArCSAqIHdoZW4gc3BsaXR0aW5nIGh1Z2UgcGFnZXMsIGJ1dCB0aGlzIHNwbGl0IHdvdWxk
IGhhdmUgYWxyZWFkeQ0KPiArCSAqIGhhcHBlbmVkIGluIGZvbGlvX3phcF9kaXJlY3RfbWFwKCkg
aW4ga3ZtX2dtZW1fZm9saW9femFwX2RpcmVjdF9tYXAoKS4NCj4gKwkgKiBUaHVzIGZvbGlvX3Jl
c3RvcmVfZGlyZWN0X21hcCgpIGhlcmUgb25seSB1cGRhdGVzIHByb3QgYml0cy4NCj4gKwkgKi8N
Cj4gKwlpZiAoa3ZtX2dtZW1fZm9saW9fbm9fZGlyZWN0X21hcChmb2xpbykpIHsNCj4gKwkJV0FS
Tl9PTl9PTkNFKGZvbGlvX3Jlc3RvcmVfZGlyZWN0X21hcChmb2xpbykpOw0KPiArCQlmb2xpby0+
cHJpdmF0ZSA9ICh2b2lkICopKCh1NjQpZm9saW8tPnByaXZhdGUgJiB+S1ZNX0dNRU1fRk9MSU9f
Tk9fRElSRUNUX01BUCk7DQo+ICsJfQ0KPiArfQ0KPiArDQoNCkRvZXMgdGhpcyBhc3N1bWUgdGhl
IGZvbGlvIHdvdWxkIG5vdCBoYXZlIGJlZW4gc3BsaXQgYWZ0ZXIgaXQgd2FzIHphcHBlZD8gQXMg
aW4sDQppZiBpdCB3YXMgemFwcGVkIGF0IDJNQiBncmFudWxhcml0eSAobm8gNEtCIGRpcmVjdCBt
YXAgc3BsaXQgcmVxdWlyZWQpIGJ1dCB0aGVuDQpyZXN0b3JlZCBhdCA0S0IgKHNwbGl0IHJlcXVp
cmVkKT8gT3IgaXQgZ2V0cyBtZXJnZWQgc29tZWhvdyBiZWZvcmUgdGhpcz8NCg==

