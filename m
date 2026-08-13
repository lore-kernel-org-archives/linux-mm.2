Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB5EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D894D6B02C7; Thu, 13 Aug 2026 16:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42CD6B02CC; Thu, 13 Aug 2026 16:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB6A6B02CD; Thu, 13 Aug 2026 16:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 955E36B02C7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:26:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F9C3A02B0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:26:28 +0000 (UTC)
X-FDA: 85097378856.08.7020011
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D97040004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bj5N6jvb;
	spf=pass (imf07.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786652784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ2ZLMYMsx/cGvyzAHu3qP9nG4MeAYZRCWp/hD0nim4=;
	b=u2xki40VfGPkdPnvt/T4cel1UvHQD+pTdXEGz1amPS9eetf59WqQIfQ+j4it4CJD9fnc3A
	ck7Mtlbj9OJolWpalwcoGSIe2pctOi9YgpgtwRQOJnoSOGckmAUEKEeyecjVK3z0C3+uVJ
	t85iFpoI8QFvb8v99WuGJ89hDFMiJ18=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786652784;
	b=WmW8GXGI8EPbJVG9S+YPl8dBoOc20CGyDGxjiWBXtwVst8BSxeu9X08wccuTiKpgjjkSmk
	ZKP4xE4GldnXIqt/nela2mavQry/6IOgg26sQhT7wZels65fFcCy4MAbLKgy1Ix6Cd35m+
	edgXolBUE0DxjdmZLyyy9c6qBhhmq/M=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bj5N6jvb;
	spf=pass (imf07.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786652783; x=1818188783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XZ2ZLMYMsx/cGvyzAHu3qP9nG4MeAYZRCWp/hD0nim4=;
  b=bj5N6jvbLglRRdNqoGUwaOXI5VmmuB3z4ukOBgwPfL+lPa9xCr72+oIA
   Ql6PnVDQleWbQFQ7oVR5EoeS+jV7JUFTkOMtU5s3X0acsC1l+xnPeh7di
   sn/l8lmvcjkYS3FZEJFrTmFKOvZ67ud1F23ZFOA7RkY+imGDxmWHJ4eRr
   RNL+Jfwljm6eaMz/4QzZrRZEWcSISHKqqUa/Nxd0Xsr6WX9lAIrlWtvCL
   uLKueMKzkVWY2uURkpMceXldQL6DkACTFkECcCV68bWJQS5xRY6qYBUcq
   WCF5hU5Jys0uUrrSQkoDqUqFFijC4kcum8IWD6McDWKQxpWx3DB2hPaD6
   g==;
X-CSE-ConnectionGUID: Ycv/+bZFRgmgdqNlbducBg==
X-CSE-MsgGUID: wqL3Ai2jSlun1dtKXlgyBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="91047090"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="91047090"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 13:26:21 -0700
X-CSE-ConnectionGUID: X8OwR+XyRTSJ93Ux1Mt3Zg==
X-CSE-MsgGUID: aL2yjEw0SheZaRDBwD9Oxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="293967962"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 13:26:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 13:26:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 13 Aug 2026 13:26:20 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 13:26:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNnR4m0zjS8q0KfyhkCxKPxsXDEmn/64epH6kul0tn3X6BEyYBhhhtkumSgF7OeyMltqUj88LyL2vZiV5u3hFrb29bYObgt6Tx9gT/ETuVX65po9XTaVPGZWQnHP735MlBGZr89I/4cxX9ka7khPgzaPVqvkLsTkF8zOqW7nOjxo1V1ASA7avTvtf9Ltp1OdyQFF++KfhC3jD20n7vW38yDPima0gqcNmZwmsJ9SwkmfdJ8cTuoyyAxgp7xW+i6mUxFZt8pjdcG8KettQeX4WVZO6KWabn9SIghcL9msbuIwJGBoXFg26whM8Xj+K7WlrP6FOC91WkYKTlnvCc6tdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZ2ZLMYMsx/cGvyzAHu3qP9nG4MeAYZRCWp/hD0nim4=;
 b=LB93NWz3DdTp9QapNduvbCnWFsJzlYjuGvz6oMyujokuoqAwdHJTFkp9kK3rjfIkD3950cMFtdT45ndSKA8/zOiQmPX0liKDTYVENQakq6rN9HGE0EKGNNCn7foOGM0djOMM/cdrjdxVekF3MEiZUOYY20fieS39Mf6EbPYr3xJVAW3+2NkI7yH6l+gBaszOIY/EbLHCg6jxhHYOv38TonVHyQr/hSglX54FhehdpQNcHD7I6IVTeE37NEETgMlDSV5RjzO5ytcBNs0ZYOh+6JjDEnhUfIwi7MUijsfaZo+DzMtRc7VgRgXqESqdEaCEv1JxDiESuCecVxIGHwxU2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by SJ5PPF2F2B659FE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 20:26:11 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 20:26:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "steven.price@arm.com" <steven.price@arm.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "forkloop@google.com"
	<forkloop@google.com>, "tabba@google.com" <tabba@google.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"willy@infradead.org" <willy@infradead.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>,
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>,
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>,
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"chrisl@kernel.org" <chrisl@kernel.org>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org"
	<baohua@kernel.org>, "tarunsahu@google.com" <tarunsahu@google.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jthoughton@google.com" <jthoughton@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"shivankg@amd.com" <shivankg@amd.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"youngjun.park@lge.com" <youngjun.park@lge.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "baoquan.he@linux.dev"
	<baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org"
	<liam@infradead.org>, "axelrasmussen@google.com" <axelrasmussen@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "seanjc@google.com"
	<seanjc@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Topic: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Index: AQHdJrce/nCTYwCmf0aQh99M4VuIhraTTHOAgAL4owCAAYWZAIAAQqKAgAAUSYCAACrrAIAA1bYAgAAEIoCAAzW9AIAAGmwA
Date: Thu, 13 Aug 2026 20:26:10 +0000
Message-ID: <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
	 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
	 <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com>
	 <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
	 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
	 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
	 <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
	 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
	 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
In-Reply-To: <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|SJ5PPF2F2B659FE:EE_
x-ms-office365-filtering-correlation-id: 484e6c3a-2958-4ce9-aab6-08def9791d32
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|38070700021|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: akzvG2s3iCCUuyHYH35IbJNRM4HsPbVpT16hJrIt6SImqEHbyNtembabqhbvgUbqBPO2cfuHl5j6agp48Th/sgurxf8QkfImMb0P+5DXhBjrVyyI+5hZCAmOnSDqQyNIOcZ5yi/UiQsVxUxeu1pzz/820uK0CMCMJugzrUEnwZnoCS0DZOoKu88Kgpt0atSVat6tTFCLjYzFJSv6dWnUC2iVz+2d1nN6azRKruTpsgue3gZBrOri2sICnsY0/GaAKPbvcmBULpKaaxOl/Q6fx7MOCnAuWrOSLoy5rz2gtRRKAB9J62IRLwOPLeYMAK0jztRZoLGdwFaQOq2dc+Iva1K4FvGkEtBXxwTh+vZHopaZCmkQyd9sub8XPeCBt04LNX1RneBqsVuKARcQ4SBBK+6acNiz3fr7kEuQO3znhw945A2i5HRdN9spgp0UfYvHb3ukNfCfI5JFCv8Gv1H2O2zG1JZD1fQZtPkvDxwsIOIcN5TBUgkApFNgBktLsRkzg2Cps7fUsEWuMLcNpVngqG+BMpK5U7Vpqsrs+ljo0ztlb/8OOkbBuVk7iIVdz5VCN+GgkMQtfkyjfnzz6e11OoxXDLENGVSFgTE9Mb46nZwZyrFmQUua0VI6laLfO4Kxgmwo+L/XV4SKmFjbKTpYRLZx5cEfQhdTUAlIMiAWpdEC7zNoCZiBLNooKTODXyjOIcLHFFMXIH0SCtX7UM/W5myJ/nuYM4WoJmtELUCoOS4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(38070700021)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N21HSVZuUlM0clVHREUxbkMxbDJxaTJnYkw1d0s3V0draXBzMkdGK0ZOS3pF?=
 =?utf-8?B?Zkx5cmE1b2hlSTBkTWhDcE5ZeiswblI2NFdNOGI4N0cyOEJhM1J5S1dlUmtr?=
 =?utf-8?B?V3lnV3hieHJBWlR3MEJEY0RUajc1S3UrVTRVWndPbTRORHZrY3Y1MEsrZzFt?=
 =?utf-8?B?Y1lZWlpKQmNhQkNyZk9XRzdvSHZKQ1V0amNXdVpMbEw1YmkrRm1Gc25tMGpK?=
 =?utf-8?B?K3VRL2hLVTdpZ3UwUHBldERNcWxjWmdFWFM3aFNlY3hNNHgzRy9IZkZRWi9I?=
 =?utf-8?B?NWRMVzJsV3ptdVdYMGxwaVdoUG1ERXRjVTk5bGpoRUlLN0NxUTZidEZYR2dw?=
 =?utf-8?B?VGlBeWlGMVJ1ZXRqZ1BuODhTNXFtcndENXVTeUt4bEZyVDMwZ1A4aWg5ckZk?=
 =?utf-8?B?eDhCZmN0KzFpWG1tQ1lKVmlWYU1ndFVxNGZmREtxdWtnUzlWbXNRVnBuMEJa?=
 =?utf-8?B?eUJyenRTazZwMUQyQUpxMHVwdGFhYzBvU0VxTFZybkVMUnk3N2l2OW1NeWht?=
 =?utf-8?B?TElYY2JpT1VCaHp2eE5jeHVUajg2UzVVNFJ2aVdIUm01Tlp4QUtoUjB4eldX?=
 =?utf-8?B?M0FhSk42TWEzUWpKc01wM0pZOUFMMml6RXExakVFdHB2S3BndVF2OHJWMmtH?=
 =?utf-8?B?WFpPZmxnaGJFTVRjTUJHeEZYVjZCVWNXY0owZnJQMEFPMFdJZVpVYUp1eDZC?=
 =?utf-8?B?YUdYYXNDWTkvY2Juamk0RGsrb25LZ2hoY2VCZ2h5bEtLQTBya3BRLzNVSU83?=
 =?utf-8?B?TTNqMlBvWUdOaWViNU14dmRYM3NoVzRJOUozQjB4OUFvNU0wTG4ybFpVbW80?=
 =?utf-8?B?cUtCci9iak05VmFqcWMrOHozdTBvY3VDYmRrbXo3azYxMFBDTURWRGUyVmda?=
 =?utf-8?B?amZGYmtjNWR4NUlIQm11YTNtV0ZSODdJTVR3cThKWkxkRUFzbS94eitLclZN?=
 =?utf-8?B?TDRkQVAxZzlsRnVNZTBTcXRwWTFMM1JLT3o1a3FSU1BKQWRzT0NhcVlTV3M1?=
 =?utf-8?B?TXNEVDVmUmdMbDRlbGRQUTNTVGVBM3RtTGNvVitHeHlJSFNXT05IbGV5Zndm?=
 =?utf-8?B?V3QxajJyMEZzOVRSWFNNcXNWMGhnRjFFQVF2ejJPaURBTjV3MHFnSzFoajNs?=
 =?utf-8?B?Z2ZibDhZU2xkb0k3Ni9EZnZZKzVwUnhRQ3dtSnFDK3NxQ3A3ak15YkF3Vnlo?=
 =?utf-8?B?c1hGSzFKVklkMTRLY1hxbUI5WC9SelZ1T2lpTjl2UGdmbHZnMFgwUXd0Zm56?=
 =?utf-8?B?SnR6Qlc2MXJZTSsyM3pOcTloNXNOOUdTSXZwbUR2cHJvbkg3ZWREYTRTODdI?=
 =?utf-8?B?cjR5Y2cxSFRUM0ZFc2JZaTVnRE8xWnVXa0VMZGZHK25DYll3TmZvelNQQmlL?=
 =?utf-8?B?UkZQYWliQVhoZElTNWRBaUw1c0dEK0xtSVZsTUhPeTVIWnNOTmg2YmlmOTAx?=
 =?utf-8?B?Sy9GbmtlNnZlaFZXb1Yxd3d3T1lXclYrd1VDQzFJRnNqemhPQkdXaXFaYVl1?=
 =?utf-8?B?OHpYaFlLZUZKU0VXMFV5a3NlV3drODJuK0s2WDlaYTc1dTF0TWo5T1ROK0xs?=
 =?utf-8?B?d0VxcExNYkJidzkreG02SSs5QXl6ODhDMGpYWnk3WUprMXgvOHpHd2JQYmU2?=
 =?utf-8?B?aWF3R3YzKyszVmxIMWxZL2xkREt4Z25tcWs4NzQxamNreG4rQW5qUEtxajYv?=
 =?utf-8?B?ZGxmQy9GNXlIWURzc2tySXo1VmJ6ZWtQdExkaENNQ21sbkJ1ZzFKdEdzNnRJ?=
 =?utf-8?B?dy9VYTVFRGV6KzlDMkh0YTd3KzVPZWVnZ1ZxKzFNTUdvUlVJY1pjVnM2KzNK?=
 =?utf-8?B?cHdMSXVZMS9WOGJ1dmxaajNJSW1IOGZrUDVhNXJhZTJQN3JBWHdidG9VQVNa?=
 =?utf-8?B?RVdBN0lPYUNBRUVmdEQxc3RSaEZVQ0YzQjZzbURzem9hM2RCSlJxWDhLOTg3?=
 =?utf-8?B?YU15dWFNZS8wdEhBZjk4M29QM3V6RjlUVGNIdy9jOWZLcy9oQ1JvT1VGY0d3?=
 =?utf-8?B?dnpFeHdIZTBNYlNPUnpzMDZscUExZDF0c0RBb2RTcVNNQU5mT3doRVFuOVFZ?=
 =?utf-8?B?bFJTUGp4VjRtZTZsTXVONXE1c2NFN0REQ1hVMkdQaWZvdjd0Ukh6bUhHbXpH?=
 =?utf-8?B?dE5XNVc1a0l6cFhaZ01SdDBVNDFDb3BQV0FZR2VwN2ppOXF4R0lTSkVJYk1z?=
 =?utf-8?B?RmR6QTR6YUxTSTMyM3ZhSFp6VVNSSWJMNXMvY1RtTjNnOWdTM1Fhc00zU1ZL?=
 =?utf-8?B?MUNzTGJVblJOUWFWdHRFbmEvdVF2RVZmQVdYeExjRmcvVzF1VGJxN2xoM05v?=
 =?utf-8?B?U1V5Y0tkSm1GZCtxWCt2dC9lUVZTTVRISnVQdWlzZEhPTGV6R1dPR0hCd0JI?=
 =?utf-8?Q?5aTP06rzuHS5V8oQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82F608E1ACB61B409103F6AAABD16D1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: pZ+8WwBbo2NpA0T83oMDrWWM3oA4bfUncRPBr+ulihK9cUXqhja78tSw++uWTGl8MEBBncheD0SWD3ooL4y0/wJS9yBSpkET1HdRZHNzyb+F0h9DWcaDacrACt8wyAshBcu5p/QdRKCs7n+130b/sg3czLHOdr26jqcExJ8Cf9alo+/cJZaDuX4Y23BdTN0QjQ4SxcIluQ1Y6bmhkSY3GCmIUu1/pMOsjN1qkIeAkHYCszsFW424FHoRYzi7ZCIrnI2WBRS6bUfGwwFd6Jn5HIbRFRriFA9+5FmubLwzPDUCrJyLcds9c1f1JIjdlhQzHhhvA75nc7t4wk0kzvgiXg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484e6c3a-2958-4ce9-aab6-08def9791d32
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 20:26:10.8783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODAOLI8LNlnz+oCKPZ/uc5Pqp/be3cMyR5hCdwNsTSUA3aby8CEKuEBr9UBPzROwvLzalK3vWvPoU4qaKQHvA9luF+WcnVVmux0+V5F6IWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F2B659FE
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: ypy51o1tquco4kius9gdeoiwoaw74jby
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D97040004
X-HE-Tag: 1786652783-524701
X-HE-Meta: U2FsdGVkX1/Scxl1Z4rREjKNTs4HJnulAK8bwMIrjjB9YSfczUAzPxYaLytDvJDoJvqIqExdMMQa99qE2B9IQ8r6XHRSofIzXjJzJsoVlYXwEZFhOFJlHlW8xC4aMCw+PkQdNExiGfNKRF/KujLU2KnjeR5MtplJqRhmh+FFrQs/I+obZeRZMKT4DjbWwsM4A065pOI+DK3Xh5PW9ySNKKr9Mfkqy2nlp/PLI5h9bcVhz14B1ajVaXX6os+CRUkHY1U3Gauua11ryV9lOA7zMFVFQXtAoU3Mr8J567m0909ryCuHPHKMsM7jRZpAiYFWvICFWeAGk0o5lstBIPiQ5+JDCKgTQVu1JXa0lfaWDI2gp2hu+Rae5uSqSYGEHo3AV1Ek1Il5jpBk6H4AiEUC177SKek23CwQPue3c0gQV4vq50+tQNRrqrPn8aKj3k8g97Q/pVf2UJ2tDobVt37lVYwVxDqL4GCGRy7N1v2bRx1hAYWXEE4UYA7yG31qIcnzdQ6M7fkcPcAx4kO1OtCrwcB8Bq6lxTa61LE8rLVp1FhDhFnMff8xW724Ff0ofoSKKrurm672+FHqukNK5r41MnnqPpOz/6fOBXye5zxWQQESGmuP/VEdtcGSgJvSC/SyuhYs6lVkwEKp6KhUo7i00bNDq+uH3rb1TimrcVl2zxOxK6JNbFgeOhplDyVKGPS6PSrJQB4JQArcdWdpYeicix8rCNtuiln2/+p1y6xpT+ojtBhI9DvnA9oGwAx6Tnm0UkEL/gcCivK92kwPe7W2vo9BM4OmXfBduKCb3jJt8VlENYZJB9qxLzlL66YMoAZWWQMmn25jIeIuCA8l7rh3xMfVXwTKFZY54wqWJCSfnl+TyR98opN+84EGgHz78O0LVYWbhCZpYEni6kazDKJ351pXtotW36y9IY8u08QwZCcQAkvN76RnW4MS+HpQ9ok+F0idnB9grrnypicixfZ
 DZhaj0QR
 RMbd1P+lC8fFIFkvmQeuIF6slL+uBkIFhW1PzTU6Sv2l8coQk1mqlq/s0eIZJ4weOdGgT5pHX6Gd7+WpRvmQOf92azdL4qLXiN9ovpLepiBiWMeienjpJfomVKfPZWBeMCO54oCvyZqfAN54IOxlAAozJWnh9dtfdK/tYxEWLMAEqIFqQGviSTKAAGWwjgTAq2H/EpFbnhD09mDDnp89g/ekWFxGtEnGPEl1xJKFhsuFfT/Kyh0aEOd/waVQNrPBT8RMLs7fMZdRaipMwZUww4BybbUv4LPbGqiXmmNmGsyBrq+z0D3eQ+XoatIW3Z9kxtBiM6RzkXIcDgnA/HQE9FSaX7LXSQNzmI5J1+TOp5whmkHD40YE1pnJsT/FAiAoGdIHxfo+jLQ5gAAhpQueUpAPobuKk3P/o+MzhyGhDReLX7LvuG6Y6dQfUCW2HyPVx3wh5WBNdCDxCP47dz6sRoxcwwJlar+IjwWkJBZ0+19WaikZEKN+Cxoz/1+GsTeEU2DtVBxTTMh9cI41pOk39+9ipOEw9i3Kd+xjlP6Phrrwsdy2TyKfNd93Dhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA4LTEzIGF0IDExOjUxIC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cml0ZXM6
DQo+IA0KPiA+IE9uIFR1ZSwgMjAyNi0wOC0xMSBhdCAxMDozNSAtMDcwMCwgQWNrZXJsZXkgVG5n
IHdyb3RlOg0KPiA+ID4gPiA+IFdvdWxkIGxpa2UgdG8gc2VlIHdoYXQgU2VhbiB0aGlua3Mgb2Yg
dGhpcy4gRWl0aGVyIHdheSwgaXMgaXQgb2theSB0bw0KPiA+ID4gPiA+IGZvbGxvdyB1cCBhZnRl
ciBjb252ZXJzaW9ucyBsYW5kcz8NCj4gPiA+ID4gTGV0J3Mgc2VlIHdoYXQgU2VhbiB0aGlua3Mg
b2YgdGhpcyA6KQ0KPiA+ID4gPiBJIHJhaXNlZCB0aGlzIGJlY2F1c2UgdGhlIGlzc3VlIHdhcyBl
bmNvdW50ZXJlZCBieSBvbmUgVERYJ3Mgc3RyZXNzDQo+ID4gPiA+IHNlbGZ0ZXN0Lg0KPiA+ID4g
DQo+ID4gPiBXaGljaCBzdHJlc3Mgc2VsZnRlc3QgaXMgdGhpcz8gSSBjYW4gdHJ5IHJ1bm5pbmcg
dGhpcyBvbiBteSBzaWRlIHRvby4NCj4gPiANCj4gPiBXZSBoYXZlIHNvbWUgc2VsZnRlc3RzIHRo
YXQgYXJlIGJ1aWx0IG9uIHRoZSBiYXNpYyBURFggc2VsZnRlc3RzLiBPbmUganVzdA0KPiA+IGhh
bW1lcnMgdGhlIE1NVSBzdHVmZiB3aXRoIGEgYnVuY2ggb2YgemFwcyBhbmQgYWxzbyB3ZWlyZCBz
dHVmZiBmcm9tIHRoZSBndWVzdC4NCj4gPiBJdCB3YXMgZXZlbnR1YWxseSB0b28gbXVjaCB3b3Jr
IHRvIHRyeSB0byBrZWVwIHRoZSBpbnRlcm5hbCBlbmhhbmNlbWVudHMgcmViYXNlZA0KPiANCj4g
V291bGQgbGlrZSBhbGwgdGhlIGNvbW1lbnRzIHdlIGNhbiBnZXQgb24gVERYIHNlbGZ0ZXN0cyB2
MTQgWzFdIQ0KDQpJIHRoaW5rIHdlIGhhZCBhIGZldy4gTGV0IG1lIHRyeSB0byByb3VuZCB1cCBz
b21lIG1vcmUgZm9sa3MuDQoNCj4gDQo+ID4gbmljZWx5IHNvIHdlIGFjdHVhbGx5IGp1c3QgcnVu
IGFuIG9sZCBicmFuY2gncyBURFggc2VsZnRlc3RzIGFnYWluc3QgbmV3ZXINCj4gPiBrZXJuZWxz
LiBTbyB0aGUgYnJhbmNoIGlzIGEgYml0IG9mIGEgcGlsZSwgYW5kIG5vdCByZWFsbHkgc3VpdGFi
bGUgZm9yIHNoYXJpbmcuDQo+ID4gV2UgcGxhbiB0byBjbGVhbiBpdCBhbmQgdXBzdHJlYW0gaXQg
d2hlbiB0aGUgcGF0aCBjbGVhcnMuIFNvIGl0IHdvdWxkIHJlYWxseQ0KPiA+IGhlbHAgdG8gZ2V0
IHRob3NlIGJhc2ljIG9uZXMgdXBzdHJlYW0uIFdlIHJlbWFpbiBoYXBweSB0byBoZWxwLCBzbyBw
bGVhc2UgbGV0IHVzDQo+ID4ga25vdy4NCj4gDQo+IEkgZ3Vlc3MgYXQgdGhpcyBwb2ludCBJJ20g
aG9waW5nIHknYWxsIGFuZCBTZWFuIGFyZSBva2F5IHRoYXQgdGhpcw0KPiBjb252ZXJzaW9ucyBz
ZXJpZXMgbWVyZ2VzLCBhbmQgd2UgbGV0IHRoaXMgc3RyZXNzIHRlc3QgZmFpbHVyZSBiZQ0KPiBo
YW5kbGVkIGxhdGVyLiBJJ2xsIGJlIGFyb3VuZCB0byBmaXggdGhpbmdzIDopDQo+IA0KPiBJJ2Qg
c2F5IHRoZSBsaW5lIG9mIHNpZ2h0IHRvIGZpeGluZyB0aGlzIHdvdWxkIGJlIHdoZW4gdGhlIEtW
TSBNTVUgb25seQ0KPiBnZXRzIFBGTnMgKGFuZCBubyBwYWdlcyBhdCBhbGwpIGZyb20gZ3Vlc3Rf
bWVtZmQuDQoNCkhtbSwgSSB0aGluayB3ZSBzaG91bGRuJ3QgdXBzdHJlYW0gYSB1QUJJIHRoYXQg
d2UgZG9uJ3QgaGF2ZSBsaW5lIG9mIHNpZ2h0IHRvDQptYWtpbmcgcm9idXN0LiBTbyBpdCB3b3Vs
ZCBiZSBnb29kIHRvIHNldHRsZSB0aGlzIHRocmVhZCBhdCBsZWFzdC4NCg0KSSdkIHBvaW50IHRv
IFlhbiBmb3Igd2hhdCBzaWRlIG9mIHRoYXQgbGluZSB0aGlzIGlzIG9uLCBhcyBzaGUgaGFzIGJl
ZW4NCmZvbGxvd2luZyB0aGlzIHN0dWZmIG11Y2ggbW9yZSB0byBtZS4NCg0K

