Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FADCC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B406B0093; Tue, 11 Aug 2026 13:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BE26B009E; Tue, 11 Aug 2026 13:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6AE6B009F; Tue, 11 Aug 2026 13:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD8FE6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:47:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63F991A0184
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:47:21 +0000 (UTC)
X-FDA: 85089720282.11.753B5F4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf31.hostedemail.com (Postfix) with ESMTP id 04F9520008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:47:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W5H2hIcP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BAqU+9l9Ly95lBefsXRHuvy9zf/fGgfMzTCPO5ivDwE=;
	b=BGociRbpS0t5jwqI1yNoSePpVkBxZi2P7UpVm0vbidtJ51vdlz6Lh3f3rthnXbTJ2HDVuc
	xsRAjm/FxzQfrMK7gUAORJdk0jHQBKPpmx+elXrfOACf6se4mZ/GYRrjLBA95h2APE/YUv
	10ODFHlFv3Vwj4DfpK+NdIpoxRrqhsI=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W5H2hIcP;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786470437;
	b=7CIewNrtpmtd++PXhScQTqFeT2KqN37BMBwSOyxqrcByC+WmK9/YXAOXIFcV0VsGe1RLw1
	jkPIn6d9vgLxKtYDoUXooOSqS5Nzz9yAYH5x6qI5qsj5Iu1b1OcYDHIak6gsPeUneFdR3t
	CmFI5Is8vXitFT0iO99AAyAFB/UWu3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786470437; x=1818006437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BAqU+9l9Ly95lBefsXRHuvy9zf/fGgfMzTCPO5ivDwE=;
  b=W5H2hIcP9+s33LdU+k+goQv1Lta4zhITZ1eYxh6vkWmFvwJ7Y5HMWHr8
   zX4Se6Uv/PN3SosZMqXYEk8AgF4f3SPgVZJNkIumkCyrvTGQd2Ygd3ZF6
   ljfg1jjL8pE7d6vsuII9KmMa5VpXvOrsd7zxEH96PJMaVMvqP1dC7NQ3G
   lN868ge9NNx1IbkpvIq8iMS5vBjHVE0UrWaW7uY4OzknhkIY9EYK0fwiF
   s9CTTbx0ihhAoxTxQ4iw7Ndf7rI4xQ+B7w+0iyYmkpIcbpmyyka/wRpQc
   6yPbz5NRv/sra0l4tx0W7CFyovTTFWPfPlOg3kgtdMoea5H3IB9691Oqm
   Q==;
X-CSE-ConnectionGUID: iZLK8r3PSAmQmG2hHny6nQ==
X-CSE-MsgGUID: IbfLz9qNTXeLtlH4Pgounw==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="87033141"
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="87033141"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 10:47:13 -0700
X-CSE-ConnectionGUID: zjtG3WMsT+euKQUehtjGZg==
X-CSE-MsgGUID: cEJ5Zu4cQviBT4GflEMWSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,218,1779174000"; 
   d="scan'208";a="263994024"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2026 10:47:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 10:47:11 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 11 Aug 2026 10:47:11 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.69) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 10:47:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYbaL3fBqlUtNZd0P8d5YfuIDiqxy9yqO8eQqf/uCQwqUMuiGLnwVhZJFLECGqSOgMZh8wziJW68qtKhljv+6Ds02zzd0hD//6xy5e/r6cjmVg198XhALOYnDWzwmW6t7dF/h6cU+NxGku+87CLBgg5YfjgA9mi38dQfb2Cldxzsijg7SXVuO7p1NnSxGd6VmzOWbsLVEgj5gDyOkAdi0yLijOv4CyLg0M3QIwUedt2Zq4CwFUv6GrG+VV1fGeAfqyNYVyQtnOfjFVVH48jOkXc1jOnOPkqZUH8RDcf4CtGpR+rAF9V07BK3hE52OcCTTtioy0msNoI9ckv6OiGkRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BAqU+9l9Ly95lBefsXRHuvy9zf/fGgfMzTCPO5ivDwE=;
 b=y8SVbnHbPxyQIVyWnVBhlZ+ifRkmv63crBnaHnasVM5S4ON7J6efQnJoXAYwohgP1QXHNvlkdjX/+nLV8a2QhlwbWkBr4XqpehyO9n9RDvpw/FYV1aMAkGrQpzGmbXhpvHWGxITn3XHxsz2EfUbp4c5TG21IgcezsquyFDDSyWlrUZLH2BhsggNncUJ7ze1ScDurHYM6/XYCkcmPTiNSvlB2ipHDPAxQ0kvgWekwrM6gtRXSgjbYk84WbU8jUb+SOdZ9WdvqCP4sSmXzJNFnUzgE3yobXLxHP5IzzYa64T+nq8nQLKsa9WfiNJVtg8Oj4GBZk4f20nd/iGKjBZr+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by DS0PR11MB7632.namprd11.prod.outlook.com (2603:10b6:8:14f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Tue, 11 Aug
 2026 17:47:04 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 17:47:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "steven.price@arm.com" <steven.price@arm.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"tabba@google.com" <tabba@google.com>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "forkloop@google.com" <forkloop@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "willy@infradead.org"
	<willy@infradead.org>, "tglx@kernel.org" <tglx@kernel.org>,
	"wyihan@google.com" <wyihan@google.com>, "pratyush@kernel.org"
	<pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, "jmattson@google.com"
	<jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"rientjes@google.com" <rientjes@google.com>, "andrew.jones@linux.dev"
	<andrew.jones@linux.dev>, "chrisl@kernel.org" <chrisl@kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
	"tarunsahu@google.com" <tarunsahu@google.com>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com"
	<shivankg@amd.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net"
	<corbet@lwn.net>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"liam@infradead.org" <liam@infradead.org>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Topic: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Index: AQHdJrce/nCTYwCmf0aQh99M4VuIhraTTHOAgAL4owCAAYWZAIAAQqKAgAAUSYCAACrrAIAA1bYAgAAEIoA=
Date: Tue, 11 Aug 2026 17:47:04 +0000
Message-ID: <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
	 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
	 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com>
	 <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
	 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
	 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
	 <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
In-Reply-To: <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|DS0PR11MB7632:EE_
x-ms-office365-filtering-correlation-id: e417a131-6da3-4e39-c74a-08def7d08e59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|11063799006|18002099003|22082099003|4143699003|56012099006|38070700021|10067099003;
x-microsoft-antispam-message-info: rjYDV0SrYh79DqkipTrzW4zfePjksh89GfSO+A64kyCFjsTSOc2aQPpeRyEB0lcmnZ49DimuvDuSpgoHwFe1JOpwN7tI/T0YGUK+DlcL/QegnJzioDEYOqcbtt6cWz4kQAbJqZub9QhQEatJmEth8fkt/FhrINxPI8g/TU+idisyVs8XGQISrSmH3ys6UeW7PjtnZoca5s6CEYkYOeB3idJs4qS7vriffTPs3/fNMm/kUTv4yIdLG9PYujIblhrCb+5BN5irOeI1JTZI4lqVCSNOjbJay/dEM8jAPNzkQ39sEtgoE7OoSpiMpioQKRq/0la+DWslF7smtxf6aNOEcqS9Z0MxmBStNa4x9FbuqU3KIxyzeIDKDdeD60OdVR6tB3pj8dmqo/0dlv3E6468az/H61nmxSUPiLNlHPFKH7dRUvk4Hd9J6h3mnizCQH4wyK4yc1LpYNrt2w1Ohyc1K3WqRtOkSGQZIvWeYJAN2DMBjOedASnBO8qgX4VfkqRkdZMGLX/YAm3dJmJ+hyPwx56dO8E2u5EQB9DvlkkKLGmvRQqVtBa32miOfRcVm42jL7hI6bmVe0uWZMQ2oqKFUe9xCnxsTBXsUT0Y/1e64USv9TMDcxRkNM6RcPk4dXis6dKDWyr6w9133j4ZGknWrLNOHZUIw5EPd7fEZzrYoUQ+AIt9ylGxSk5MUAxWfzDzxDpe+Vmrm65GCqrxAwPkkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(11063799006)(18002099003)(22082099003)(4143699003)(56012099006)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dy91MG9qNVk3RUF0dWpFVUk4dDc2UTV5SmJ4NGtjRTcyT0RGOURaWG1ibHgy?=
 =?utf-8?B?OUVjcWhLb0xubGlTR1hncDlyRjZnSlFhMCtDaW1JSFl3ZGVhTXhjN0lxWnVM?=
 =?utf-8?B?QlJtTFB5ZWtnRGJ1bTVVUTRhb3JHdHhDUjF5Ym9Na0hKSHRjbGNhM3FmR2Jv?=
 =?utf-8?B?eGZrK2RSSVJnZXcwYUNMUzdQT2RLMUdrblErRm94VkR1SDliNVgzTlc0UVpU?=
 =?utf-8?B?YURkUjhlN1hDdWhKVlAxaFN5Qk02eEVXVXQ2TzRjUkh5T1lscFE2cU9CT2Rw?=
 =?utf-8?B?eVRUMFZOT0tNdThGbW4zTjU4UDl0WEFNQjlIYnR6b3pXTFAvUmtkdENzbjN0?=
 =?utf-8?B?L2Z4aVBzcjY1QmFNd1lMUU9XNGlNTkovRlh5MllkREFIWXZVcGlBS3NFL2RR?=
 =?utf-8?B?MGhSMEFuQjFCWkxOL0R2cWRWc3dRdk1ad2lvdUg2VFpoeHlwUGxmc0hCeG1n?=
 =?utf-8?B?ZUpFTVZWOXJPb1l2a0tpS2I5RWdQL0cxVzQ1UFV2U2hKVGRjNUllN2lLTG1C?=
 =?utf-8?B?Z2FTZzIyVEc3Tm53K2I3bnA4OFNGbE9nT01KTGhZc3RCUVZvOVJUTExRNEI2?=
 =?utf-8?B?V1QzV0ZZV1ZVcTM2ZmNzNXErbXB0dVFEWVBWUHROWHhRM3ZvOFJITElMNG5J?=
 =?utf-8?B?UXdXcTJDUlBHTkxxWU9NcStxeHJDVk1oSHQ5RWJqcFUyeGFiRmU0d0l0czlj?=
 =?utf-8?B?MnJZNVBaMUdQbDMyYXlwU3B5UFlpc2dmT0c1NWpKMk5ydHJVNU9qUWZ6WXRL?=
 =?utf-8?B?MCtEd2tFM1BweE15N0lzMXBzL0JGNnRTaTJySThNY3VvMTJ5alF4RVorMUpZ?=
 =?utf-8?B?b3JacXNPTXpUWFhUNGw3eWxaRHJkTlc1V0U5OHdDenhJK2E5Lyt5V0RBTUZK?=
 =?utf-8?B?ejZRckJ1cllkQUh1elY5dkZ3VDJxeEdlZllDblVVNGVBTGdBY25RNzhTVnVh?=
 =?utf-8?B?bXZQd3NCNnkzdkY1QTRORXZYa0Jvby91T2VXTlpJSlloZTA0Rm5YMFM0QUhE?=
 =?utf-8?B?NzAwaWs2ejdpVTIxWmdYdGNrME9pb1hpbUFKQWlMT1hZZ3ZnOC81dXNUZSsz?=
 =?utf-8?B?UEdJUXBQK3NkVjYrRnRjMURJOEc3ZmJwYk4wMUljLzBGRVVZR01RRnhOd2dy?=
 =?utf-8?B?V3c1S0hyaEpVaVpDMWRod29OMUFKNXJsWDlKQVZFckt2eFNsTCtpcW9mSWQx?=
 =?utf-8?B?MHRwZVRLbVRnOU1LSDBCZTBkVFYvUmJuazlUUHFLQUtCOHZQYWp2eGhYSVcw?=
 =?utf-8?B?TU9pS01BbXF1VUE0ekEvQldibUZkRUVXemI0RTV5dWtoQmlIVkdLMUdtZzFv?=
 =?utf-8?B?QnRkcEhNcVlQMS9aSXlGMWl1blhHaUEzWGs1Vk1SbE5xdlZnT1hIWUo0NjdP?=
 =?utf-8?B?S080TTQxdGdGSFZiekJwOEZlV3MxR2t5K3hjcjNLU3QraDhKNTdlakdvcjhT?=
 =?utf-8?B?MEdhSVJyOHljcHM3STdBR0oxQ3ZQNThqeWE4ejhXNjNyNlFTcmg1UjlkSWlh?=
 =?utf-8?B?NUlpdW94S3VuMVV3aUZxUjlHOGo3ekNJYTVFcHg5cURRSkFZK0l1Z2YvRURo?=
 =?utf-8?B?aWd3QVFRSXlEeUp1blIyanA0c2hsUjExbTRFYW5seXhxa25zandDS3Q0amdn?=
 =?utf-8?B?SHRoNkNKU0FGTkNmY1lOdUJnSUJqaDBveHVIVVIrS1o1UGdmaEhwVzAzUDIw?=
 =?utf-8?B?dTl0UlQrU0tOa3lrYWFxTllldm4wRFk1N1NvSVFZeFpqbzBoaXpKNlErbGNh?=
 =?utf-8?B?dklwUHBTbFdmOWpRa0pKVXNaQ21OV1FKRm1ZL1crOStnY0dMc3pxdy8zWnpq?=
 =?utf-8?B?N1owMk9OQjdJc0ZMSTBlSTlPblRxV2huNmtieFFvbGM2SFV6NHYrMVI5UUhR?=
 =?utf-8?B?OVVpRUJXVklaeTN5RTZkTU5SVVRwZGczdjBKSFplZ1BVSS8zVXJReVU2M1Ro?=
 =?utf-8?B?d25DeTVmNFdISjhubjZDdFcyR0hkMnpSZ0Z4QTRneHpCQzRoMkhlc24vbXFK?=
 =?utf-8?B?empyeXBPc0d0TTlFUitWWDV0NEs1YUFFRlgrdTVmVE8wdGtBMWd6MG1Ia1Z6?=
 =?utf-8?B?T2QzNW9xajF5ek51akxVZjJveEFwaytCSVJ0b2JiajMyME51bVk5MHJyUVY0?=
 =?utf-8?B?WjY5MzJDaFBMUXdTUmF3TmN6N0Y3YWtDWmpWSEFmazNJcDlvSitXdys0QzBF?=
 =?utf-8?B?U1ZyYkhDVldpaHFQUmllSzh5cmNvRXk4M1phUXFOY1doSWVpZURRM3JiRnNm?=
 =?utf-8?B?a0NJR2hzdE5Sb1U0OW50dEloNTcxaEpZVmtFQldBaEtvdmdxMDZ0a3VIc1or?=
 =?utf-8?B?U3l6R2U0T0Q5NElWblBmVVoxSCtyWGREWnlFZjdRblEwRytBS0FxaU1JWllR?=
 =?utf-8?Q?yzvgSlzcbZohQ15o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69C712BAE8C9DB4F8D98EAC53B2928BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mN0MH2v9Oy4BNhmPzfeBcvOL7wB2Anfa9H0G3Zw5YK9Im5aarVMOjqox1cI0sup6zyJAHULmQXNbdmiC32xfXKxHCxcqkNE3dJlLtOgqo2oWpBc9z53GDsjWt4FS5w5r/TidSyljyurWCqyNvFx319oRui+6Ho3xlQRuRMEukzykJXO8VMiiY/SeVMKejuzhsqC0wKSpMaBDX+fpGHV+kSV2qXX1ValcOXvoXI6beM4qMgG/IO2XoU3HGKOYraO9g19XGKnX1AL6sAF1Kz+69s8k1MCXn2FK9CJzQ8ED2ExFiDewT4H/o7hCYdnT3xPw7yXG15WPST8i55U3CpWxMg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e417a131-6da3-4e39-c74a-08def7d08e59
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2026 17:47:04.6162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MRtOWUM8wo3mQGnNdykBk0SHesTN0Dd007io/3+a2+jJfDaQF3DglpCYrNLmDl5YjKVznS6JpNCpMkvdTY3+GNl9dvIjnMIOyzD8crMT8Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7632
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 04F9520008
X-Rspamd-Server: rspam07
X-Stat-Signature: cixq88cjek5689bjxn1gzuj5dbn9fngw
X-HE-Tag: 1786470436-49247
X-HE-Meta: U2FsdGVkX19mqjAhyYJ9wNkkxAVub+sppv/q0PmHOPpVDeLMkzfWVJh/nq4aoZTVrTaCmHAiqF9jJsmmq0cg9bvBRncMmckLjm+oRrg+TcoWjrkev9fOTJtd34zlstg0f4LFoimPcfGjeOBr3HNwdqhyZCJ7Eqaf/3m766U+JnEvbuIrsEyU+BARhTRcfDT0VVtckVyfmrybtzrWu6DffTRcicbQO9Y6NY7Qics/ZbFvQxYJcl53gqCg5iW8VBslXte56Yrz/MTSSRFqww/XfzUMBDcsGHkLH2RHgOS4LhHXNSl5yo/gAlGACU7ooBSX0/Q4GHlnF5D7Q1hXQupbfSBPn7gS1qMgMGDDOVaXeQ2NMbLtjPxXuyKO062Ma4JAizvHUrl/Qy2Frqu3Y7O3g4FdLrt3HelXZKe/URljzwdqCfN1KUoOuMBRv9QsyOYjA4OpLCaxaEh0chTgJWHDl4jPILGyOY+NhwR24XZ7Ihz1mMToqW8HzlX8o9CZHspRsLF6e//xJSfTNrxEQ8gSvzNlictvzFSThOOyaIzBro/FmBYg7AbKJr3SHnN3oeX+mQDhSJ2l24ZRyp2D1nFPrb+/IRe5pJxx1A56PRLUJex3495yWzFI9z+2wwONv1YPRex5TWfgMAzO6CfCn427n7Kpf0msrkM0jVkUagdnkZ2l9DzVGZ1d6UqJp9EQqqgmcW7eSDvDCW7n0jvfD0N1l9OG6nK18EfOFhv92G6p8OVd7xubjPD0T4M7tT9OonemlF/EN2u74oobk54v5KUwg2d0j10YJn92rJv75UG/42tp0fWJg69JHRGfdR2SdSzbxqjxzrhcTjH8jc7O6FbY+DcHZUwzSSjbX2+WZw3oAO3iXXPqiWH7UoQZ6U33v0XVF/nhy2OKidwC5qLE+Q+F2aOXQ1CIFzjlfDh9HYdQ0gVIm7nkrIpzwXAhmqcmcmLAka47gxEayYlJF0xDeXJ
 rxMh+4zI
 3f19cVsCi9vfXGCLitGdDIG19pNzMxQ3tzLNWi/Ha4uTPBduZxwkh84Zhg1u0Hn3tB/EyJoY9arT27Lotm6yNPlk3XOj1djx0Zy7xXtUQq/ZgfCb08VBD/Tqkim9S7lyNKtCVdE8o8tNBk3KF0VojkZSj+75nhIrqHR2Rl5b0iiIYrTajy2WRtdcmbHVAq8ET2qN3iM3DP2D991g/eVXWEO5QyAC7Du6apYDNnsP9A8UOJmvlrabZWwWhP5hjKatYA0UTWuMNVXRBSfJ9wlu68fRJ/Qp5bT4/QGttfZTPixSJsnJ4XZfwyCkX2ysmUHksAEjurnEXmPy1jV015R7Z+PyAU4XqcMl96oOnGx1AdPwD79ubFfnPG/S7Byq+zeWAR9hlvb8zttW6EAsqyg59Lh1127PGn8qR1CHcX01k4aZQJDl2SQxjADT24MM2/U6Nf6mT6tYIvwgfdTNj9dUCZEUe+xBB7bXMFLRprLQZmRl89MSLJdnqb9RgfGfpkWrvW/PMlmF4XcN/Uh21nHgnYMFvqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI2LTA4LTExIGF0IDEwOjM1IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ID4gPiBXb3VsZCBsaWtlIHRvIHNlZSB3aGF0IFNlYW4gdGhpbmtzIG9mIHRoaXMuIEVpdGhlciB3
YXksIGlzIGl0IG9rYXkgdG8NCj4gPiA+IGZvbGxvdyB1cCBhZnRlciBjb252ZXJzaW9ucyBsYW5k
cz8NCj4gPiBMZXQncyBzZWUgd2hhdCBTZWFuIHRoaW5rcyBvZiB0aGlzIDopDQo+ID4gSSByYWlz
ZWQgdGhpcyBiZWNhdXNlIHRoZSBpc3N1ZSB3YXMgZW5jb3VudGVyZWQgYnkgb25lIFREWCdzIHN0
cmVzcw0KPiA+IHNlbGZ0ZXN0Lg0KPiANCj4gV2hpY2ggc3RyZXNzIHNlbGZ0ZXN0IGlzIHRoaXM/
IEkgY2FuIHRyeSBydW5uaW5nIHRoaXMgb24gbXkgc2lkZSB0b28uDQoNCldlIGhhdmUgc29tZSBz
ZWxmdGVzdHMgdGhhdCBhcmUgYnVpbHQgb24gdGhlIGJhc2ljIFREWCBzZWxmdGVzdHMuIE9uZSBq
dXN0DQpoYW1tZXJzIHRoZSBNTVUgc3R1ZmYgd2l0aCBhIGJ1bmNoIG9mIHphcHMgYW5kIGFsc28g
d2VpcmQgc3R1ZmYgZnJvbSB0aGUgZ3Vlc3QuDQpJdCB3YXMgZXZlbnR1YWxseSB0b28gbXVjaCB3
b3JrIHRvIHRyeSB0byBrZWVwIHRoZSBpbnRlcm5hbCBlbmhhbmNlbWVudHMgcmViYXNlZA0Kbmlj
ZWx5IHNvIHdlIGFjdHVhbGx5IGp1c3QgcnVuIGFuIG9sZCBicmFuY2gncyBURFggc2VsZnRlc3Rz
IGFnYWluc3QgbmV3ZXINCmtlcm5lbHMuIFNvIHRoZSBicmFuY2ggaXMgYSBiaXQgb2YgYSBwaWxl
LCBhbmQgbm90IHJlYWxseSBzdWl0YWJsZSBmb3Igc2hhcmluZy4NCldlIHBsYW4gdG8gY2xlYW4g
aXQgYW5kIHVwc3RyZWFtIGl0IHdoZW4gdGhlIHBhdGggY2xlYXJzLiBTbyBpdCB3b3VsZCByZWFs
bHkNCmhlbHAgdG8gZ2V0IHRob3NlIGJhc2ljIG9uZXMgdXBzdHJlYW0uIFdlIHJlbWFpbiBoYXBw
eSB0byBoZWxwLCBzbyBwbGVhc2UgbGV0IHVzDQprbm93Lg0K

