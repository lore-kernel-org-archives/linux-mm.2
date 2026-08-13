Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E96C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 23:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6ED6B05E2; Thu, 13 Aug 2026 19:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67766B05E3; Thu, 13 Aug 2026 19:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D084F6B05E4; Thu, 13 Aug 2026 19:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CD66B05E2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:30:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B18D802EE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:30:11 +0000 (UTC)
X-FDA: 85097841822.09.E7149CF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2904C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:30:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9iL8c43;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786663807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LN2+8SSENJR4MKuFUgUBGG0u3AWQhc0OPW1Tc97I6kQ=;
	b=mh2YoJ+Cn//3NtDeCbtEDvlWPH0ImL+KbkO7u397u9Gs4vv3zXD8/A7OkXwszlNRmnXWBT
	djSzG3/ZBmU5toUA2kCa2ipe+5vdmMP397mbFs9ma70e6BL9sId/rzflAKbSzzPRYlYnvn
	yqEsk85JLJkY4/+7NljffB4XhZbJPU4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Y9iL8c43;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786663807;
	b=M9EoxoSXCHig9RtePRy8FZokc4x1WUG8YGIzt9vdGmfFAXVamaRd9yuZkAZ+aKraIIIMkW
	kXcCGHwlZsomA9lOkLZ48u7/L2cGLuCk35ditUMrTfxFICH9etu1J5IODDoGh/DWrGTUzy
	168TEMcam+JSRJ52ljVLbtx8lIn/vEg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786663807; x=1818199807;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LN2+8SSENJR4MKuFUgUBGG0u3AWQhc0OPW1Tc97I6kQ=;
  b=Y9iL8c43kvZqbtbkCVtXdkmB1iYoCu7rU1a9utNj/+svM23s72mtkl7L
   CwMUpzfHpQBLmd8ANn1rY+bcOd112HYpAe2nQc3ngxG+NRyjvgZJy4Ftp
   G38tQwbOZkRJXDbEmcMMiG7pyoRHQcs0GUjZoicQtiBDvouv9643ExgHQ
   bYI/vvaw6FKsl9ZuYcdqTZWFs2bkHMwQZHbB5Ed9yDEHiJJ0GguLcZd+c
   PHFOlv8lk4Zt1Zyk33cD+8qLA35R/KaOVJfvXwKTE9BqRBSfK3dcVw429
   d9j3ZPfTvFd0R3P5bEcqr4BShX8EgKcVWLNgM+oOs5aAWEDVD2bNle1qa
   g==;
X-CSE-ConnectionGUID: zGKI8pTCTXurw/c+S6PZog==
X-CSE-MsgGUID: itpkFeG5TSOsu1e1+TxXLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="90924343"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="90924343"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 16:30:05 -0700
X-CSE-ConnectionGUID: gLf6uMqmSMmiLEE8ggnA1g==
X-CSE-MsgGUID: fwDdfAreSBmi/mKrCZuAjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="260274724"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 16:30:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 16:30:04 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 13 Aug 2026 16:30:04 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.48) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 16:30:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5jlqsbgfucI98dCu51mqFaOjOIGOMy7WKr+y6v22yWZsOjajpcP2hYMxE57VtlzpwEIW8wxRsryo3HZvVwTB2DsNEAfT6QRgS69jN1KtTThKWnm0x6Q3IFm1iyKyPTyFDxnkJ3ecYMg7G1b/ZK4k9Giw4eBwnyTZQd9Lo1G2KojJZUSUHOh9L1y7lJiq7fmqkZBmtLU359K6QLpnHvvBhHhFv9WyQXE7qgF1HF06KgrFdTPAA4GCax5GtWJkin6u3E948+yzCTUf3ratVBvzW7jnQCPkTJSahNEsKY9EK11hOkDIDoe1Yeu0Egf+l/0Tmrk2nJr5o27RFq6liz12Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LN2+8SSENJR4MKuFUgUBGG0u3AWQhc0OPW1Tc97I6kQ=;
 b=LlmKF+y12nYElhiyEOksI2/F6xGienuxIDwViKEmZ9CGftTpCUCondRH6iq2oLXPoUw0hAnyu5cGlnJBOpSEn0Sp7rZB9Gd2xcGMraHq5sVph+LkrzQNfXd0W1xfTGxs+L3WFnl9c2ovqbG5VZMDJ7no1ym5LW+c0P+V1pbi+YTtWjjaUURSGdIZcgkuLAOZViWwJNLAPtLecWHc1JthrG/dmcgH9VA5HxyLt0Abs96tCbmGYol6LkX3ew5HXzHDhZc1W1d86AmSe5QjRLVvp197JZnfFKKrPWci9nVusJr708HTA+IzrlfNX7s7eV4pGoBVpRFoFXWEHvEKqdbmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6771.namprd11.prod.outlook.com (2603:10b6:510:1b5::20)
 by SJ0PR11MB6791.namprd11.prod.outlook.com (2603:10b6:a03:484::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 23:30:00 +0000
Received: from PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4]) by PH7PR11MB6771.namprd11.prod.outlook.com
 ([fe80::effa:162e:c9c9:a1b4%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 23:30:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "steven.price@arm.com" <steven.price@arm.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "forkloop@google.com"
	<forkloop@google.com>, "tabba@google.com" <tabba@google.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "willy@infradead.org" <willy@infradead.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>,
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
	<baohua@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com"
	<jthoughton@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "tarunsahu@google.com"
	<tarunsahu@google.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
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
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "qperret@google.com"
	<qperret@google.com>, "brauner@kernel.org" <brauner@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"corbet@lwn.net" <corbet@lwn.net>, "liam@infradead.org" <liam@infradead.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Topic: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
Thread-Index: AQHdJrce/nCTYwCmf0aQh99M4VuIhraTTHOAgAL4owCAAYWZAIAAQqKAgAAUSYCAACrrAIAA1bYAgAAEIoCAAzW9AIAAGmwAgAAwl4CAAALEgA==
Date: Thu, 13 Aug 2026 23:30:00 +0000
Message-ID: <ca7aabf7020e16883272cc2e859e406445f216fe.camel@intel.com>
References: <anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com>
	 <anj2bPrGqzZgZWMF@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFzRj_=GVy8T4P8ehhQjYomYxkngzwtKBF0iEL0Cv6fuQ@mail.gmail.com>
	 <anp1I64K0KeyQuyo@yzhao56-desk.sh.intel.com>
	 <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
	 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com>
	 <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
	 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
	 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
	 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
	 <an5RJYTwlYeym--O@google.com>
In-Reply-To: <an5RJYTwlYeym--O@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6771:EE_|SJ0PR11MB6791:EE_
x-ms-office365-filtering-correlation-id: 322a6c09-84c9-46f1-01bc-08def992cb12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: MJ/JlwP2qejyFmdsqJE9CySLWP5ZfDqM4v6O/eIWPoEGW4q49xSlCQ46pJx5BI+2LhmkHfR3sNGT9H/J4fCVma0an3/x+l3iGtmcvKrH2H4QYYniIsCSYeIfk/9BYy5rY0lbdG0KPLdd3x52GCRARu5c5DajeGOlz/vCN08jCyDllJGiJemdSfvKVpQmpVwEcSsVCBGgGQocz1PiWzilIvokVAziCHpVuvogu/5ZGcdSwpPEQpZJfU+/eVQsOmoYE040uvV7wFkSoLL5PdoBQQZ9jz1vQ8QeY3XbAOu8ICo7WXbAQs4ITYXdYmtTtiZK+9zljtzR4pr0iXATOMn+yBoKxinqV5jy2sJfvuAN9Ce8gTPEKjvcKZzufOui04WR/irZ8caomVUDqYBwj3dVirJY+81EQRqTe/NB8EECqIvovPQa3l+j/XabNAHGSlIUnmXE1am0yz9fnJ0DxCcGi4WmEPxvoBx6CDFX1rtmOSust8uENrD10itGdrtQ1u30DxyH7EsbTeiLXM3n8bl+pqgUAgap35cuf9DJX4RbS4o++feZsosloq7qYlt7sx6nbD3Ze/w+p45n2qmHyEWxZS7CAI0+5mwkpTrWnxS56EM7NVD8vigMpiu3gpYNcSOV5fs7+JOJ0sqW/xzAVi/DVtgiz48wAzvoO2GWPu9cGW74GiHyHHPPZSRj6EG3cbZf7hgG8+dMOx3NBQEX1OfGnofYRSSeHT87fLdpMmBn6LM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2tzekhGSTdBcHRHZkExaXNOVVVkS3FIQml6THB6dWUrMUJaVzFzeVl2d1Bw?=
 =?utf-8?B?ZHFXVFZJUVc1Y1lPUS9xakIxUDFUOER5a1dVb2Y3RndYMXNWcnJ3REp6L21N?=
 =?utf-8?B?UnVpY3VEVit2S0hBVXROeEljd0VQM0ZZWUc0ejdLZS9xSHd3M2VUVjkyWDZJ?=
 =?utf-8?B?S3NGT05MSWVQUUEzNjV1REhoQVVYTkhLQjNkb3ZGMzg0bWxQQmhiTXYxdVp6?=
 =?utf-8?B?UHAvQi9ML2ZnK0tpa2kyU3RkaHhmYlJHRmZTODYvc05rcm9LYVFqMmdKRzdy?=
 =?utf-8?B?cHgzTkJnQnFxN1VTRWFHaFpUK3lXTU9aM295TkJXZFhOQ3k5RWNRM0xISmdH?=
 =?utf-8?B?WGUxNlIvOHJYenFmVHJoazVyZzk0RlVhME05L3hpSWlrZVBxTHBiZnMvM3ZO?=
 =?utf-8?B?TGJQU0FVdTIzRVdCOEphNHBVRHlzbzBWN3d3NWVrSDE0dW1DTDB6R2tBS2Fo?=
 =?utf-8?B?czFKTHhJQzhuV3ZoUWdjTmlZcXpyY2ZNRmlydTJoWDE2WFYzTlZoWTBldFE5?=
 =?utf-8?B?UFZ0dzVxcFBIZjNqblBKcGRVQ0NLc1BVYzFObThjYm9xYzZ5UVltVUprdE9B?=
 =?utf-8?B?RGdkQjlRTVNkcDVCMHBwRmJJZXpUSldVcmY2Y0RLNHBkQVZKTHhpU3dCTGVY?=
 =?utf-8?B?V0d6QWl4SDlsc3hTTTVUeDdpWnlNZUVQTGRoS2taeU9taU5pMjA3RG9qRkV1?=
 =?utf-8?B?L0NlckZzc1FjWXVVL3hVdUJCNWtudXN0NDRJRWJmN2tJS0toWU9xeVZxb3Rt?=
 =?utf-8?B?aGJzL0ZRMHlkc0VlekRQaXBzU3I1d0NDWmpKb0ZSM1pOVmIzcGFTMmY4bTFr?=
 =?utf-8?B?Z2o3Ty9zN1Z3YUE4ZmdiaWdHTDZ1bnpWZUFFWTZJb202VFRDTXEwdmFNSlo4?=
 =?utf-8?B?UjZiOWNHTm5CWXJ1RjNKYytxMzRTL0xpUjcxMmZHYXJodzU1c0dKYVQzY3V5?=
 =?utf-8?B?dVBucUxBbExYMDI3RGh4VjNpVGxHN0RydHZtYWxndjEvUjNTVzI2N05OV2Yx?=
 =?utf-8?B?S01sWmJxOHVKazljSDQwUlNndTAydklvVVhIc2RMcitOZVpPYTN2U2JpZWdO?=
 =?utf-8?B?ZGh4Y1RrMk90S2hyYkltZGVCeE45YzJjVUUyT0FTWjREUVQvWG1uTnlXQ29N?=
 =?utf-8?B?clNLMmdlUjVhV1p0bjlWVXNZSmRsaVUyUWdUcTZ1M0QxMGx1YTRIaUpKVDZj?=
 =?utf-8?B?aGlVaW92K3hKYUFaMlB1VDJFc0V5OXhrdzdwMDR5NUxNUmlCMFUxZzFQcndV?=
 =?utf-8?B?ODJkak93TjR5RjdsQzl3T2RvSmF1MUszaDJYemNqS0R6aEp2T1hCY0diRWNN?=
 =?utf-8?B?aVQ2b1N5WG9mbkhzYTdtUDU1eXNkOXdHRlIxYithOTMzMTZNcUxZQ2ttWWw2?=
 =?utf-8?B?bFQwdis3enlScXhQL0dPR25BNFlPelJGRW9WaUZpUG4wcFo4TDVudE9QZDl0?=
 =?utf-8?B?azErZGlTdmZhMWpFcWc3Mk1WSUhIQ1pGSWcvV3pUZVdhTFNURXlBMmhvdjZQ?=
 =?utf-8?B?NmJ1MEMxUm43c2pBREl0cHJ2ekQ5ODRMRE50SWZDNEdyUTZUTk1WNlNQQXVJ?=
 =?utf-8?B?alJScDQ3UVdxaUwxSlpNb3BQMmRseEFNSEF5Z0plNSs0eW9zNGZrbHROK3ky?=
 =?utf-8?B?U3psdEFoUVY4RTBJRzlCckJkMXdQYzB2SmZweTd1dWlrWjNpWXNmVzh2bzZZ?=
 =?utf-8?B?aTg0SU56OTVqYk9GWGduaTZqeHpnVE9UalBpSStETHlFVGZXbTBFWmFheTFx?=
 =?utf-8?B?WWpzUFhxUHBJM3ZUbFJmdHpmOThjVDJHb3ZQQWRCaFJlbUlPY0dDWE53clha?=
 =?utf-8?B?dGdNWkw5SFdNZ2k4SEozV0dFcFNwdGlGaVhWRTVtK1h0RnN3Z3hJMmswaXRD?=
 =?utf-8?B?Y1RZOFVlek55SmIwMlRyQjZnVlB4akhieEUrS0l5dDBscldwOGcrMm5LVlp6?=
 =?utf-8?B?L04ydjRldks0R21pdUZuQ3ZVd0wycWJnZmtZSTJLemFPbXVESEZDWkorMm1T?=
 =?utf-8?B?SGxEYklTN3FGUGwxUDJxZUhWRW8yVTFwWkZDby94VVZxbnlSaTRNR3FLVTJP?=
 =?utf-8?B?VXVENG5aTGFyYk5HSml2YlMvYzNJNGJFbUhNcURxbm9HZmtmYUNhVlM4VlJF?=
 =?utf-8?B?Q3FjM0ZGdHZFSnNIaElKQmZ1Mm9kcUlyQzgzdlc5RDhnbEdFcEZ4MHEyazRY?=
 =?utf-8?B?cEl2WmNiS0dFeForcjdGTW43ekNiRDNWaktRLzI2ajMrWE5UQlFoOFdsdjBH?=
 =?utf-8?B?UkM3cWdZYVgxaVl2QnNsRTh2REFabDE1SzZKaCtseDFiZUZpdlUyTmFmc1cy?=
 =?utf-8?B?Nms2UjEvNW1qdDZiS1JwS0xWRG9hN1JLc21lSEYvTDM4K2xOMFVxL0l0cEhl?=
 =?utf-8?Q?nywr1aWYgSdvQoas=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E07468472708AE48B667A9F9A1DBEB41@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: RsICPB+pmJ95GMKsV8PaIEeNKBKMwJVlpzKdFgN6yMSc3bcei2CXzvBCy5fVficgPEEWxbghEnAJfIcP+M1FcbzJBdp1Hs3ckdD8NkgEe90Hd93rVsIK0hUcAhmjkpVbfsDA4sBADNN5RUlT54yI0jcAZmFQkfF082vcxnCUkMTXdn21kB+V7+qhwXXlqtuXHpp+RHa+rntI4XZE+tWgSiG2P3qI4e10IxSeprNYHMJ7i0EyioCrq9dil+pZWLqraprhOgkeWwKi0nrNfJAEIqqPGno7r7nYNxhaURpYAkELTquaR9GvjrixKlI3O97hfb1TdBjwEfWHoS4WtJMS2g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322a6c09-84c9-46f1-01bc-08def992cb12
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2026 23:30:00.0459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2sWMrpu3hBouXQB0YAYiuydXjcoPgrVLFRa2ZmtrG2vCl+1fz3/Uc8hOBAclmJjcUyivUC3v2I4q9WFgDtKUN1QqhwVe8Ssyr8Msn6n6yqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6791
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A2904C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: jrmka89dwezfyjp3ymiuzjcuc5w77d41
X-HE-Tag: 1786663806-102031
X-HE-Meta: U2FsdGVkX1+AJEBSfVudwVJceiTzp7R88WzB9gFOH4hgtbJoj6udm4PgTcgm6CvYixFZu7OgMQuOl3c3ehlXvzKGeNXxM8alD9IJbwHYKNfHCV7mHBdEqxrMEp6/J7Y/egB9B2O1tLvWkMplLrsFfKnxUPWHX6cil8JQn6hXg/riRb85SvKqMZXr6cy9/MV/+Q6CdcZHV5RL/vqEHV6KTLdIJGd8z6/CPWcjvDhrtbr9jxSWrMeJjsMNEglkOT5gvL/iK90s78uUZyOc7l8oK02i36Ayf0MkR1B2KGwYlkDmrJfjbgWkiJdzHfUrUqVIQMLVopiuskhMpievXG8eILVQF28X+D2zs+u+XzIvLNOt+R+pKP8tZW1BWwobEheNJiU6Fs40YwJXVo2ErlgYNJ5eksCaPKB6L6Lg80W2SYQUfPiKyuK5P0OAXOyI8fkMx8+Hzb67e0Gl9FGgnHr39fcHtbFdMBKXvZQQD+jVvkZ53/6M/jCPsdtkFsZt1CHPlke/LD+6ND2A0y+lmAFvLGNNLlnVVsn1LFhAJKxrkIK1ZrV12d9gJU7733iWyO0mNsj3R0SnNPNVN2o9sfm+TZVyaOC4wSHXW/o6J2ahNziYrrM1TeqJ8E2P8odGI201fcCsBL3j4MbgY/3uwgSxgrSZy0JB+NEEqpXJ9mLAhXP5nsLT+hLQKnhmFAZC1/G1MA9HMkehoI5Jx2ZLslx/hKigYXx0tU8PzCJZIrYshfYmVb4mfzCDw7STjyUL1lJsIro/dfpB0K7l9GV8nyu2WDYuDE7OLrCOejj6p1o1p9yu0HGLoELs3z9XbDPH31sTJm4YCpCjdw3iuYShgJw9KJKaJRMw5x1HG46dnVG8CBoa1dmMTsrUV/FZlzXoo0MSNlD+SrhA4tQdzzBI+GVVDaB/dOuYjkyUGknfI3L0u6FlM1kwEt5cr0kP4kNlAYZmVDIOGg9TfhyYzmpemCd
 OrBOO+fm
 7T3DZ7IwMqRnmMwalgMk72LVBA03fatgvVA8aux1ydibiu0Oz7cxw4yCiqTMqBUrxZ1o8vjStPzXk7/O4MxHxE/dQmcOsCBrfN8VEBvze4DNMwrK/wgvid3EgxBiKU6WMQZie+Po/QIENQnvseuyi79RbQH0P0C9LAdBgKpB7xnZqFdSIlGLvc7M/Ka8GQsQR2pi0s6YMUc0LEItdyukWddrwH6SPLWlUMvgNQAx8Ehle115PQk+8lQ7yt9p9noyL/rK0qxdnvLm5IfDNg00oN3/w33Mt8QHCcR7MewA5cg5HezBjc9enajqmXw29MfSTX02Tca8m6KYdOnvOW8KvdM0qmXJin9/yBR9aQhlqvHWk5plwHUs46xPzHH1AZpoXezsiQWveRn1AylHKG6OGPHMNMCgHSaiO9ZiSRQSwgr9R1PcoyZgxCNL49X3rWR3BdAr7O4eR8N14a3kY1lV0AfwHlYz3FmaZheewCGpUxAAVpxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA4LTEzIGF0IDE2OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEhtbSwgSSB0aGluayB3ZSBzaG91bGRuJ3QgdXBzdHJlYW0gYSB1QUJJIHRoYXQg
d2UgZG9uJ3QgaGF2ZSBsaW5lIG9mIHNpZ2h0DQo+ID4gdG8gbWFraW5nIHJvYnVzdC4gU28gaXQg
d291bGQgYmUgZ29vZCB0byBzZXR0bGUgdGhpcyB0aHJlYWQgYXQgbGVhc3QuDQo+IA0KPiBUaGlz
IGlzbid0IHVBQkkuwqAgWW91J3JlIHRhbGtpbmcgYWJvdXQgaGl0dGluZyBhIHJhY2UgY29uZGl0
aW9uIGJldHdlZW4gb25lDQo+IHRhc2sgY29udmVydGluZyBhIHBhZ2UgYW5kIGFub3RoZXIgZmF1
bHRpbmcgaW4gdGhlIHNhbWUgcGFnZS7CoCBBbiBOTUksIFNNSSwgb3INCj4gSVJRIGF0IGp1c3Qg
dGhlIHJpZ2h0L3dyb25nIHRpbWUsIGVzcGVjaWFsbHkgb24gYSBwcmVlbXB0aWJsZSBrZXJuZWws
IGNvdWxkDQo+IGxlYWQgdG8gdGhlIHNhbWUgdGVzdCBmYWlsdXJlcywgZXZlbiBpZiBLVk0gZHJv
cHMgdGhlIHJlZmNvdW50ICJpbW1lZGlhdGVseSIuDQoNClNvcnJ5LCBJIHdhc24ndCBkZWVwbHkg
Zm9sbG93aW5nIHRoaXMgdGhyZWFkLiBJIHdhcyB0aGlua2luZyBhbG9uZyB0aGUgbGluZXMgb2YN
CnRoZSBzY2VuYXJpbyBzb21laG93IGFmZmVjdGluZyB0aGUgdUFCSSBkZWNpc2lvbnMgYXJvdW5k
IEVBR0FJTi4NCg0KQnV0IGp1c3QgbW9zdGx5IHdhbnRlZCB0byBjaGltZSBpbiBhYm91dCB0aGUg
c3RhdHVzIG9mIHRoZSB0ZHggbW11IHN0cmVzcyB0ZXN0Lg0K

