Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A07C982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E5D6B0096; Fri, 16 Jan 2026 10:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13C26B0099; Fri, 16 Jan 2026 10:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D266B009B; Fri, 16 Jan 2026 10:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C20746B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:34:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57C99C024F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:34:39 +0000 (UTC)
X-FDA: 84338224278.11.6F31505
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 99D3C1C0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:34:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GTqL+pAB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768577675; a=rsa-sha256;
	cv=pass;
	b=NtrBkJXd+sSPybGVzI3IP5ayLE5ST7Y47UWCcen5qzZWhcxVUtactabNdhcbBvXprtBWgo
	KTZfARA8hfpe5nMeWqFAJaqw/3cXGmDc1GMg4k6ggMhbRKsXl+KfsdgP5+ZXRWVcDmrD7n
	UMv8/W2RCKHufq6KRGQnu3JvRO+nt2I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GTqL+pAB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768577675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=st8juQvrTNUGnSHy3KgG6+pRGePpBm/YcaoCSbo58FQ=;
	b=QicUgNA81Irzyf4Zt8kUOp5IpR76oI6KRkcHggpx2q99mVKWOkd+tbUNVsG142ELrhIYMI
	OPQsksRseLxgjpT7fsr+0Ur2yXo4gsWWzEnxRJoWuILUDe9hw7+lvglbYfnL9uqT5Mo0ZK
	+xtStV/0Xe8MmfySvP77wrEJRAKDU28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768577675; x=1800113675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=st8juQvrTNUGnSHy3KgG6+pRGePpBm/YcaoCSbo58FQ=;
  b=GTqL+pABT82RZ+thoY3OnMnzak/bVxFuobPbOnJD/1/MctI9XlZhAmKd
   tnelMo15Q3obv/db5a02Vw2sJk3BwF+WHCf382tmrl0njoB3R4ilTyRTU
   UPkd4EWKozMT/ulsNK0Dq40qjyUMQjGSIj9vEnT2/vPzdaEXvlF/pL2bY
   oWA0aTyXjzh0Mjbg/fw3g3KtwmK29N+iN8bFex//fMWgQBqhf43WBTtQF
   m/mObJ+a9IjpTvWazcPwB2hxUfMmyj1oAXptsv1Tv+HAFyVCitFcTCDuP
   0ZzV2BM90DGkUOZcA6jpM9sBbVUNDNjXSZKrxoKlJx4pGya9MYj/UhJG2
   w==;
X-CSE-ConnectionGUID: /5peSyNVRQaPsLSzzvuQVA==
X-CSE-MsgGUID: 8RJDsheOSc+kIGdMqss7Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="72480064"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="72480064"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:34:29 -0800
X-CSE-ConnectionGUID: TNyKPYVVRnKNw7HhRJALFw==
X-CSE-MsgGUID: Ghizf3ZjRGi7i1gkUHLluw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="205320516"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 07:34:28 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:34:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 07:34:27 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.15) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 07:34:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1Z1PuffSVdkTwE2ab28FaygeP67ONOQtT2v/qr4ks9Ucr/nqwUCS1LUp2DSolH+Zp7glT4pfcU63lrNv8gxUfaBXA/6kH+wKhk2PpMlG3I+fACIkvhKqTAYE0LaTb04XPhsrliLKOM1cA1dMGAUsf178KRenTSarKFe7z64r06EG6iiJY0Eo6H9SqrvlaOu8PHoITF8zpaDN++XkVDoxB/bq2v7RkUwqWieNMPf5dfxmaJM8dHUWPjqenCqh5C27mbD/4+PjJ9fzN7XEyWoZ1Ve3ndBLbOEopefrNX/PxTUnat28PahVSqh+Leg8RqMlqQmM5hfVoOEVc2YfgtjSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=st8juQvrTNUGnSHy3KgG6+pRGePpBm/YcaoCSbo58FQ=;
 b=tC6FHECW4TOryhaqJOopWtIRPK/xf/mdMdzshfRuG8NGSPdJM3Da6KknYsoSiVDV9KdeoxSuOB0je9ZMn1tu2UiR5/zb8jBgGjDjBLVMi49rL+pcBWdKRvTDQhpztLDo7kB4r/O6h4lK9XTSCm0K2xfh4Nq9Ck53YtKqJbJn0oqqPwCxAgsGWwZKA6lHmIqsEmjDPi8qBbjRIBLtE1RweA4XcxDBwYqmiLLRzQ0scpnrxdPTRXSi0MO52V69m3iBlwO8xzwPJVb58rUeI3xBvm3p+hnvKEFtJru2C/XFulc5LheKpL6BEcY0Det0jFqxcVZWaN5VYYY8lhK+KUd0wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB8141.namprd11.prod.outlook.com (2603:10b6:610:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 15:34:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 15:34:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kalyazin@amazon.com" <kalyazin@amazon.com>, "kalyazin@amazon.co.uk"
	<kalyazin@amazon.co.uk>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
CC: "david@kernel.org" <david@kernel.org>, "svens@linux.ibm.com"
	<svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de"
	<pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org"
	<ast@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org"
	<luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "peterz@infradead.org" <peterz@infradead.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com"
	<jthoughton@google.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"itazur@amazon.co.uk" <itazur@amazon.co.uk>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
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
Thread-Index: AQHchnGR8zlgd593vU675Y8ML/1Q0bVT6T2AgAD7kQCAAAm5AA==
Date: Fri, 16 Jan 2026 15:34:15 +0000
Message-ID: <bb58a21f91113ca39f8888d718d4450a5fd72808.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
	 <20260114134510.1835-8-kalyazin@amazon.com>
	 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
	 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
In-Reply-To: <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB8141:EE_
x-ms-office365-filtering-correlation-id: 9044e799-762c-447d-161d-08de5514b4e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eGJmZ0drK3RIYTI1ODA5aGxHWHJnN0JibVYzNHpOU0ZXRWt6eWZ3Yk5QbHBo?=
 =?utf-8?B?K2NLNEg0NW9vZnVJTVBGdFNlcXVKQkJBVzg0NzZFczNwN1poMjRlSVV3ZDUx?=
 =?utf-8?B?NFFHdWxsNndMQnI4Z3FGZm9vajc0Z3RDd3RaRytpNUtOWmVxTzB6b201U0dP?=
 =?utf-8?B?ME9EUWtYU1lhM2crM3BvTXZIQWNidmMxZUZwUXZzb2h3SUlINlFYa2RuRjRD?=
 =?utf-8?B?TWJNUGtBS05RUVVuaEdLZnlmeVloZzl4QzN2N1k2LzJhM3R6MVpTdmdEcjF0?=
 =?utf-8?B?MlNyZWFYT3dpdlRIOXFyZW1WM0xodHNHSm45SzZSU3IrMW9QOWltcTNVYnBn?=
 =?utf-8?B?UGtEYXJXY2V4Qm9iTllLMVFOc3hKZ2xVSXd4WUViNHgyb3BoKzdmMGtoZlN2?=
 =?utf-8?B?Vlc0WGoyb1dxZlFUUnluSExFY3dXdzM5aVBoTzR6TnBiMndiMTQybmZwblBq?=
 =?utf-8?B?K1hqR1h4U1RtWFNhL1hNMkxxQk1QYkdGVHlacE94L3c3MTZSWjVTcHQ1NG9y?=
 =?utf-8?B?Wm5kRGtwb0NxVGk5S1NEUmdwT2RqZSs0V1MyQmEzTlFReXJHczA3YU5GYnND?=
 =?utf-8?B?YUFSdzR1Zjlvc0xwclpCdkl3QnR5aVJ6dFVlWWptNnBlNm8zZ1QzT2NhQkhN?=
 =?utf-8?B?NFhiZC9uNkRCQ2VLZVZZVWpyRHJwUzl3ZlFhenZUcThQWXhyZmFSa2I1U3Bn?=
 =?utf-8?B?TEIybnRkam8zazk4ZUI5UE56Z0NZbUxBVUl1TUkwdmtuaUtxSGNsbmVpcy9H?=
 =?utf-8?B?UGJMRHozODdVZHc4YW8rQWFjNkV6V0ZHWDE0WmVVT0lFcDZSNWVMOENiS0g4?=
 =?utf-8?B?ZHNTbks0YVZWeGxVMW1Ubk5neU1IOHpCZTlCTEIrNUVQSlpPMlhpYUx2MFhB?=
 =?utf-8?B?anlaM0N1QVliT2ZhNGtXWHJBczFMelg0RlkxTitXNlpMYWJOWnMxNUNWOWJZ?=
 =?utf-8?B?cVRCMEFpRlMxUUxnUUc1eTJCKzQvSVpsd29SQ2VNYnJyUTR3UEtGcC9YdSt3?=
 =?utf-8?B?UE0xOFh3UFNGc1p2cXZlTzUzdzh3N1pkR2JPejR4MkRVVVR5NERuQW53eXl0?=
 =?utf-8?B?NThCWFFkQ2N6dzVlZHhMTGVYbS9SaFZRMEFJNHMySlFGMGhvOHhWZXJGZCtp?=
 =?utf-8?B?a0lNb1dLY1JvL0lnajNGdHdDaGZaL0tpRzhIL3B6UUxzTGR5NlA4MWFLbmdT?=
 =?utf-8?B?STllV0dXSW1TOHQvb3kxK2JQR2dnRXZCQmlaS0FtYmdXTHNINFJYV2VhQVha?=
 =?utf-8?B?K2VRTE5UYy9PS2kzKzBTclA5NUZnaVAvbGc0b3hISXZJM2w0SVgwUVZsUFZX?=
 =?utf-8?B?OUt3UnF5WEpuQTBXdkRTalMzVVA4ejE4ZDZ5S09CTmRUb3lYSVlqUmZ0N1RI?=
 =?utf-8?B?bzFtc3BxcDdyMkJGUUhHZFc5bjZqOXZhTFVybWJEcUNhQXUrNERhMjRsVWRr?=
 =?utf-8?B?Ynd1YXRuNXBXNzRVemtsVHhtQVo3TDhzL3FGRDFlQi9jWTZ5dFd2djJZQ3Y2?=
 =?utf-8?B?VVY5TDE2b0pIZy9wb2NPM2I1KzN0SGppU2JnVjlkQjF6a2t4NyszZ2pvcGNt?=
 =?utf-8?B?ZXB2c1lqcytUM3ZIZ0V0WFIxRmJ1ZFd4UHkrOVh6S3NNR2Q4VHJHaWZsZDh6?=
 =?utf-8?B?clBvNkxaYkMzbjVtNXp3bnIyZS9CY3hGOTFZS29UaUlJbDF1S3JZM0ZPTlI1?=
 =?utf-8?B?YjNselp3Y1krZWUwT204REVUNWxLYnl4QzAyU0hTeEw1elR3NVhlWlJqbEhH?=
 =?utf-8?B?SUcxdlZrd0JJakJTcDA2TGg0dnVwNXhlWi9ZTEswTkJ3MGg4N0Y4NnJJeGJF?=
 =?utf-8?B?S0RoYnpQNXNLM2c1OGhOcVV3YnlFYWE2RU1zYXhMaVA4Zk1MdkRJM2JCZUlX?=
 =?utf-8?B?NEpKYURBZ0NpQXdnSjZJK0VNOHBNWnV2RTFkL0FSS1JjME1VdDhlZzlUMDd3?=
 =?utf-8?B?ZGN3WFd0bWhNV080Qmt4cjFHUmYvRnNubG51RHIyMkdSRGZQZ1ZCMVFhTitM?=
 =?utf-8?B?cldmT3o4ZEJoTHcyb0FlR2tGU0Z0cDlSVkl5Z0VScU5ZRjFIUjZzRnZHb2lz?=
 =?utf-8?B?eEw2UmRYVUZKelg5ZTczbEljMjArcGNjZGl2VTVYT0pzZ0IxUENrc2pEa29z?=
 =?utf-8?B?cmVNYUVsdURiTjgybSs5bDhXdXJQaklFaTVpUThSUjlTNWlLdTZQbzFha0Rh?=
 =?utf-8?Q?Z6tkbMZi2nK6W+k/gwFEHa1ydq2EjDDDsKNiqkDIpfZ7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWZHVTRFVVpNUE9JVnZVTHA5WWNNV1BlNlJ4UTJnemVmQ1g1SHo1YmdtVm4x?=
 =?utf-8?B?WFBxNkw0ZHUvU2U1bXFYK2ZvRGxua29IOEk3aWVzTlNFZlZvV1lsM29PR2R1?=
 =?utf-8?B?Ymsyd08vNk9vSlpiMlhZTG4zRk5rVVJFUE5PZmdTZ0RPbS9WdW9SYStHQ0RQ?=
 =?utf-8?B?V0FKMDBTVVk0Z0l3c2hMYUFBZFVSRTNzeDVILzNHUFpZTlk5RUhNa3d0dnY1?=
 =?utf-8?B?cXkwL09SdUJxdEhxREJUbkdpN2E1NWxNcjg4Ny9yZ0ZENloxTU9aaTlGZTJu?=
 =?utf-8?B?OVFVb0hYcnRkUUkrbUx0dFZlZ004cStqS2ZWQXBPcWhqY1JtdHZpTVZSRzZ6?=
 =?utf-8?B?YnFERGRMVjVhR2RJUWxMbVdWWWR4UXMzT1VRQ0tSTk5VVkZmNlpKT1lCTmw5?=
 =?utf-8?B?WEVBVCtYdFJwUE8xdWh6SU4yRCtWV20vV0QxTW5VR1dEZUtVMWtFNmlNWERR?=
 =?utf-8?B?cHhFYXh2ZUZHQWZ3TnFlZjRvaVlzajF3NUZVTzNrSDdXZXZIeEp2cURXSzRs?=
 =?utf-8?B?NThjaGhNT2hrTGRHWHpFWTZjYVlic0xWRGlwL1hFcjhMYmlTK25sU0NhWGo2?=
 =?utf-8?B?N0NzT0hYbjBkODNhMWhpZHNkc0ZQTHJJaDU3QnVvTzY3M2ZURkxreE5Ld0hP?=
 =?utf-8?B?MnpMb2tLV1ZEYlVpTFRZOTlPc00yYWVnZHBIUDk1NUVsQVVJZWh0MlRvb0t1?=
 =?utf-8?B?TzdyYlVCRTRSMVZCNWlaWG5GM3ZHZlIrcWprUEFOMCtqVGlhemYxdjdJank2?=
 =?utf-8?B?a2pOS21Va242KytFa0FQL3hseDBaZy9kU2RLV3MwMHF1eHRmVk55bWI3SFhW?=
 =?utf-8?B?NGhIc2NyaktsTFJ1SWwrTFFLMGdRLy9vQzQrbHBzcnVLTFpDZTFZblNDQ0Yw?=
 =?utf-8?B?Mk55QkZKcUhMKzNQOW5sZ1VOUXd6ejJLQW1vMUlGbDhuTFAyZmdGMEhvSHl2?=
 =?utf-8?B?U1pwc0pESHo5MCt5cnVPd0ZScC9xNVJ2SFVVY0U2Q2FiR0xGT1llenRSY3Jy?=
 =?utf-8?B?bHJvbzgrVDBwTmVSS25BMVdobGFlV29IbGdKdVQyZUY3WDk0ZmpoSmQrVzFu?=
 =?utf-8?B?eEFyUW1sR3hqdXhKSUhLUjRPaklWZjN0U0psZnVaOW1uVW04KzQvSHd3Sno3?=
 =?utf-8?B?aXFYbklVWmJlYUlUeStmbmRJRmVBSk9OT3pqbUpMbFErSTFxazZyMXlNRGlF?=
 =?utf-8?B?WmxZUkJmVlVCcld2WVMyZ01OekNaVCtZVFh2S1I1Y3FBM1lXOGhRUTVYdVRF?=
 =?utf-8?B?bC9wbkw3ei9KU2Y5VkdMZ21COFR4NElseXJKbEZHaXdUaTVod1NjTHVoRlNz?=
 =?utf-8?B?UTRvMGZyS0lBTmxKZ3o1M1JjY1ZITEgzYTZrQ3lyK0lJVEpxWkV0czFqeWl5?=
 =?utf-8?B?OXpoSXZwd0pSWmZFTzdtTjArU2I0U08wUmQ2MDF3bmNrK3QvQVMvdWNFNXhZ?=
 =?utf-8?B?dml5SDNHbTVRb1RJWXBUc0JCaVMwUmNtRjBESE4wYk83OHJXbE5HUjgzVFg0?=
 =?utf-8?B?UlF6SzdXRDBkQ05UNmt2Uk1JKzJOMUdnaStNdWJ0dVZSRlhOUkVTcGZlb1o2?=
 =?utf-8?B?TXllVEtPNGdQcjlqRGtVOU9RRk5HZ3YrSjFEeWJMai9GZDllRnhxTC9lSGJK?=
 =?utf-8?B?VWZvbWEySlVYVjcrdUt5M0JIV2pacGZYNkdTTUVyWkN1R2J4OE80VDh3VVUw?=
 =?utf-8?B?aTZKd3YxWE96SmVENjVvLzR3MlhjVGxwYXQ2Rmk4OE1mMVZ0NmFuQXQrZmtj?=
 =?utf-8?B?ckQvdEx0VklOY1hZOFI1cVdEMW9zWE1udFBEVnNXQkVtQjNUcmpRb3h1WWRJ?=
 =?utf-8?B?ZmJRRGtQUnlqNHh3UEI0TUtnc0JGaUtNVDNRQ0FSbjIzbUE2dmg2MkpPaG05?=
 =?utf-8?B?RVZrZng2MjVXRXZQWGZpSThWWjUxajcyYnNTbGxHNkluVzdxTDhMaDJEdHVu?=
 =?utf-8?B?MlcvNTdSZjdjbVJCem1UQ1BPRUxPUVJteVk2WmZydm82K2REaDBDTzNxK3da?=
 =?utf-8?B?LzFrRVJKMXhwN3lzTkJQQnBvVzh2a21Db3p2azVPcjlmMFFoN2p4UXBZOC9w?=
 =?utf-8?B?cUVoVnJnNndNcXNtcU5kRVNFOWZSbUZMdit2UTUvVGFDd3puSHY2a2paK2pO?=
 =?utf-8?B?MHZDdDViSDhtOFNCU0tNelRFbnErd2lJdFkxalF2aFZ5aFZmMnJ3VGcyWGlP?=
 =?utf-8?B?WmpHcGZKYmdBNzBZc2tOa29rQ2EvN28vYUdKY01TenlHN0RPZENtUWlpbHZi?=
 =?utf-8?B?YjVNZUFFeXVhMmhUcWhlSHlCMlBnNm9hYzl4UTdPWEhEUlJuMUZNakZaOUV6?=
 =?utf-8?B?M2xpR0ZsV2lMUllYTGJnRUx6RHRTUnJmbFh4dElMeFdjeHNFdmxScGVkVTVz?=
 =?utf-8?Q?CR1lXikHsSnyirfc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36E6F72C9C9E054892A6A9EA0B042B94@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9044e799-762c-447d-161d-08de5514b4e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 15:34:15.4976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jmzg6kSAamplbrxYI2+NZ3xr5ZvF9wIq8bPnnSJINGkJwSj+4KGp3Co/fTRNVGfXiyfx5QkgHfVanlO90BkAdFvZPYlnJ/XSzCGyQTUOj7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8141
X-OriginatorOrg: intel.com
X-Stat-Signature: s36rgca3r11pntysrewq9dohcb1j66em
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99D3C1C0009
X-Rspam-User: 
X-HE-Tag: 1768577674-68176
X-HE-Meta: U2FsdGVkX19H5EPQj8C7yIOwvzwXMSLdxHdhX9AcEnsPYKokQ/o5qKlH2FDS6uqvf8bpeoQzX5FLc6UogI6s7VWBCneaERr7pVpyL212tip5nD2qT8lphE4VgxVpdoFPtft+66CLnE+UIbrqAwI2RtNg61wgEqrSfv/4TDBVBD3lqEJdqbeD9taWWiqHWvlxDGToPPT69pMN6LeCi3AifzcDYauMhim0ngrAO+BcWILIbsSCZ3ydO8J7xpX24zq5hBUWu7A9tTzCoDtnHdXbDhLZNugfXgByav6HBRpBEuCk4paVUOtrtuwG+l/dBZhzlxqGmLQgy9OtNACBEBj1vDXmjHhEUCF/nqRY0ZRJmfGcEB902oN2LQHCwf513QlkiJUszRcELcEY7wgQyW2EOTGYa5xjBHUrocG4OjoriVTURvO5odzZF1W/rrPrsoci22Y8nZe02jtEgitoFB855rT+CEX1bKAxn48GuWCUA2n6f6bvT8DbnCE9VQhs+aPqu8KgTalkYwUHw1Yj4l2Ui2CzZZbe9hzp6R0VQgLEKJ5PU9C4WMIcsbXmnTpkoCIIGLEZUIjGRewCdfeSsHEyR2yrz9VjFcpIx/OYxy8kxPQgiDyjQkQulzNvh9kmlm/7bieHFaDzMDQAkkf7IjSduhBJwwYfv+XP0BI40IolYnftpvp8ilg5zbX9TdVyriOnn1sXBVZn6Eb+kfwv52qX9pJwcuIFrB2hnRu7ApstrCKNLPDPeiWclF8Hns/mnyMmKJbysCizm2jfnk1/cwiE/om5Pczv9TPdtPNEtI5eLfQi0678bpbMk2UBkEaqn1RrCy95dXKE6wQpNzRQrXwr1qQ7ALXAKjZoierbpAYjXb7XIztrGIHbsoSAvEQrNW4AkWGMC8Ig6CyyHz7jt5bMFNZa/oOWyzhW3xzYu/4mhkGKWF2IbKwicTSyRGK1sgImUU+olqokkI2AoY3idrB
 dJjryDy+
 yKaiDmMUbZKq6YlZ+IXDr6E0ql9qmDkdBr2BJzreBSXo2EktTUbS7PVz8cASzU8w9NOoOZHQyFUa6wBofnHjDl/zERFX3U4nmB3VYIv0FmnTBhqoNs0SmgySeSdeoNihs2721MaCFInkuHmcuNexizYpAUpZDfe2Yd6eVEFa4CE4DV9ER39WhgnsFuGRo3Ut9CZCQr/hQaMXW1rRfRlvmXaTjhav92EL9JC0vVZAMToCBqk11eGyN0qYY22764R7npz/mbK1gU6ooZucmyNu8Peh/xWS1Ywr/yEoyrtwASXFqNv72vKWLplySho8B+K84ILfsWhKgEwzsTeykvyLGRsXAswx02fL1htEo/cHX1kPMRmZf/66wqB98vgKSg6Uu/rbjRYlvf06Ow3Pwxa3UMZNBpjrF/wSyvQ8Hpn/1jSqurMeUnwrD0Zm8qtSNqH8yLhjZxwf3qvyf/MW+Z1BSUFYLUZBGecJ4Q3+yX/bHLYAMmstM1a4PkOkr0nkqyXjPJkRjhbCZMZCYB3RXwviysTyQDaUQ75nSk1ehSjoFl3QOenHakYEgUP5oBn8y7EiWqiXaYUww2Vutl6D/wXd/+nug+iHSI7CspFjS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDE1OjAwICswMDAwLCBOaWtpdGEgS2FseWF6aW4gd3JvdGU6
DQo+ID4gRG9lcyB0aGlzIGFzc3VtZSB0aGUgZm9saW8gd291bGQgbm90IGhhdmUgYmVlbiBzcGxp
dCBhZnRlciBpdCB3YXMNCj4gPiB6YXBwZWQ/IEFzIGluLCBpZiBpdCB3YXMgemFwcGVkIGF0IDJN
QiBncmFudWxhcml0eSAobm8gNEtCIGRpcmVjdA0KPiA+IG1hcCBzcGxpdCByZXF1aXJlZCkgYnV0
IHRoZW4gcmVzdG9yZWQgYXQgNEtCIChzcGxpdCByZXF1aXJlZCk/IE9yDQo+ID4gaXQgZ2V0cyBt
ZXJnZWQgc29tZWhvdyBiZWZvcmUgdGhpcz8NCj4gDQo+IEFGQUlLIGl0IGNhbid0IGJlIHphcHBl
ZCBhdCAyTUIgZ3JhbnVsYXJpdHkgYXMgdGhlIHphcHBpbmcgY29kZSB3aWxsIA0KPiBpbmV2aXRh
Ymx5IGNhdXNlIHNwbGl0dGluZyBiZWNhdXNlIGd1ZXN0X21lbWZkIGZhdWx0cyBvY2N1ciBhdCB0
aGUNCj4gYmFzZSBwYWdlIGdyYW51bGFyaXR5IGFzIG9mIG5vdy4NCg0KQWgsIHJpZ2h0IHNpbmNl
IHRoZXJlIGFyZSBubyBodWdlIHBhZ2VzIGN1cnJlbnRseS4gVGhlbiB0aGUgaHVnZSBwYWdlDQpz
ZXJpZXMgd2lsbCBuZWVkIHRvIGtlZXAgdGhpcyBpbiBtaW5kIGFuZCBmaWd1cmUgb3V0IHNvbWUg
c29sdXRpb24uDQpQcm9iYWJseSB3b3J0aCBhIGNvbW1lbnQgb24gdGhhdCBhc3N1bXB0aW9uIHRv
IGhlbHAgYW55b25lIHRoYXQgY2hhbmdlcw0KaXQuDQoNCkkgaW1hZ2luZSB0aGlzIGZlYXR1cmUg
aXMgcmVhbGx5IHRhcmdldGVkIHRvd2FyZHMgbWFjaGluZXMgcnVubmluZyBhDQpidW5jaCBvZiB1
bnRydXN0ZWQgVk1zLCBzbyBjbG91ZCBoeXBlcnZpc29ycyByZWFsbHkuIEluIHRoYXQgY2FzZSB0
aGUNCmRpcmVjdCBtYXAgd2lsbCBwcm9iYWJseSBiZSBjYXJ2ZWQgdXAgcHJldHR5IHF1aWNrLiBE
aWQgeW91IGNvbnNpZGVyDQpqdXN0IGJyZWFraW5nIHRoZSBmdWxsIGRpcmVjdCBtYXAgdG8gNGsg
YXQgdGhlIHN0YXJ0IHdoZW4gaXQncyBpbiB1c2U/DQo=

