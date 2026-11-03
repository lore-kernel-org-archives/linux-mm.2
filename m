Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D917606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 23:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=S85wdh1e
Received: by kanga.kvack.org (Postfix)
	id 3B6526B00EF; Tue,  3 Nov 2026 18:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FA06B05B1; Tue,  3 Nov 2026 18:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2009B6B05B2; Tue,  3 Nov 2026 18:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D323D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:42:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4CD6A0581
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 23:42:11 +0000 (UTC)
X-FDA: 85395433662.04.989F3FE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4831E160009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 23:42:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S85wdh1e;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793749328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+ZatiYmqXPoSbRWB7iLHNOH/yDQmseGoFdLs8oUt0w=;
	b=xjm2eDvQQPgxRLhHI9eCXVXqpXkLANTBbEY8Fva/ZJeZDoZTsPx+aUY99eplWMPToOdvBD
	AI45XyQKrICGUd1FScMtu5QqL3jwHKi3jC862cyn8/NAZrFQYRL4sj6hzCFp1SkiAUlp0W
	hgATG+LHd1JNmee2DVHJtKHv/D+PoKE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S85wdh1e;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793749328;
	b=A5quYd+O8JP0IRtsbfqzLFQxsqGF94QlAPNoxIoGV1KMvC96cY48fHsui4xXhrAUWVbNF1
	lC7mvO0TFWnO6NECW0LIT5eLcR02UJpoZ/ND0NvJvg3kXw/1GRBV47Jhj6v5KpPzB1d/1X
	jGtT/3hR9cTSdfluwL3xNbjCyI5cFT4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793749327; x=1825285327;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J+ZatiYmqXPoSbRWB7iLHNOH/yDQmseGoFdLs8oUt0w=;
  b=S85wdh1e6j0lHwt5lYC87WfBimO4YoLpYZszga1sZI68Ca6KlrxRvYfn
   bhXx8JjQeaqXMYSenz0xVxVnc1xSTt7Y87bp3ARWAcjIrZ7myziELwX+s
   vMD7HgzwnNe1CEOcmyubMY3Dv8USYOsT8UY5PZybhgE6tOSZANTFi+Aqx
   5vAd7lcpT806A/+DbKBGPtLPV/gEF2j8JdIjjdE04oFpqgyTj9UbirRv3
   H5alH+Y9LjZj4tCvkA19g922Pr9dhGIu2qwFnyzyL+L3gprsM8hDivhGd
   cE8Tlp3S72Z7i/ZW4AnoE3+pMXXCeQdL8HnFO7J11yEUnTt4Wlaj4jh2p
   g==;
X-CSE-ConnectionGUID: /bPBdD+tQHKgTeHZ/VjLNw==
X-CSE-MsgGUID: 1oAhERNRQoWYki/swY4aUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2501113"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2501113"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 15:42:05 -0800
X-CSE-ConnectionGUID: wEXlamhUR/Kbgz0Aev4KhQ==
X-CSE-MsgGUID: wyPhHIYhQma9K1mKhgrK9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6680842"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 15:42:05 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:42:04 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 15:42:04 -0800
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 15:42:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dwrzoRZgsTKsXVrLaKpJrf7DVhzCzCCn+hiyztKebtRYgLeLfr7JhhhIv4GdpSF2Y+NPHuWamrMZvbFD5TTO8YnZshVUwTQv2GklOFV0o7eGnYy2XPs3nRtsxeUGVw8Mvjv4wayxw7ohjLtQQsb/kavKJOVCmq0X03+NABc7KJxXUkhcUhkW8mIx7CtT3cPinRL+WYpegCrpa30hkICz2acCYasDReDZQASPn2ngT+wGL7NTBTkVDkIGTyy9ZhBpeRRxUfReFT6KWjKRBsQ4xsXQ5itrCeZVbiY7bKZ3PtG8LpRCTjrjya9A+5yJHbDOQKxscUj8SqUGh9yvgj1zfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+ZatiYmqXPoSbRWB7iLHNOH/yDQmseGoFdLs8oUt0w=;
 b=OgaTw5jYaherDHi+D4nUWcjHhqfRK8fzEr4C9HHwpSt1XocIGc2kl2M8acmq2M2ZMmcvvHvpp25R/wuX803jYW67UjY2F2rNkUr356XtHA92zMFyIkyNqN+PrGCgEbJImGxCuo8KTj7bv0rjNAQfeD/yrzcHoUPvHVQRyWfvOBVy29w5VtTaIGwOSni3DShBODq0H4T9iOJasPdj6LVvgoxKi1k0GdEHRdzfWgTG9asZz97D0SVCCKNY1gzA/kvDMsgnGazl95rGwLyKmCv2TbJUB3wSth4en3Q7cXb7NAeU/zlmm/WM8UYWP8ezRhBW914rHTYyy1x3KNsce7Ciig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by CH2PR11MB8834.namprd11.prod.outlook.com (2603:10b6:610:284::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 23:41:54 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%3]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 23:41:54 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "ziy@nvidia.com" <ziy@nvidia.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "buddy.lumpkin@oracle.com"
	<buddy.lumpkin@oracle.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "david@kernel.org"
	<david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>
Subject: RE: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Topic: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Index: AQHdWC0d+qXJ7nBgaUO4tsT9hgjACrb2b7AAgAYjP8CAIJKG0A==
Date: Tue, 3 Nov 2026 23:41:53 +0000
Message-ID: <SJ1PR11MB6105A05870574FF39B449CE28C692@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
 <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
 <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|CH2PR11MB8834:EE_
x-ms-office365-filtering-correlation-id: 407aff95-0ed3-4d9d-c5fd-08df3a040a84
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|38070700021|11063799006|4143699003|56012099006|261102123227099003|261009223027099003|261022105027099003|261021121427099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info: 2jNsCnVBHQaMXYJQS6YLyk6HtsqaaUQAki2ZEdfJT0ErmfkduHLe5aKecjpZ8ZL2NqJ/CG4JNC5WTxcJ6k4IALwZvAL3VZUrcE0Qa5dKF6+zsJBZDtDUB3OJjOu3E+ZNhG/DEIeimNoBkJTzeOywKigUCOXfr+cM/JjCWL3+/001hzgpojKDo4tbXx1FGjEA6blfNtFW7Wl2Qz4jk6O0TK2DPvN8fd++C0HcqGlcT26xc+mF19vVwYbnvY2LsrQSsHIkMkwqsK5zc4YVjLHSjiRmfP9OG+gc83XVonC/GQuSIkANq5muzUMHTSm/35XZ5WNdY/LAFsdiY4E5eXCoAiaNJGvmkE+LuEKVXn55XDqddVYMAU7S08J28e+26XFN3iHzm7W+ScXBjpfD9B9818pm/KM4kH2jEHSOA5UmHSMO7EzYfEG6BPESHbqYrrAwOY3pwLweD8jB+hfIfhIn6z/n8zof6uQVgbvW6GuNSAQ3I0x6FB8vr59iLrgOzCv7hHSCyIBqyX6iUpJYxCoBY3HvijMJyS/T/jbgSBGLhcZbtwkUAZDKSUOLlOcPinWWVTxSg4xYfIMEzvsYZ5xZYAVucqJlUfaBCxCBkEzmTgQlg2g3jP7h169Uozhaa2Z60oD2JwXa5KuqKgtBn436tiEGsnwAgVDbaqNSh1g5PtA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(38070700021)(11063799006)(4143699003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261021121427099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVVnMThVTXRRcDJxeFNxRGNnYzZCbXhTRXIvRFo5TnpWTC94WTJsaFVnOXhU?=
 =?utf-8?B?RnJPMDVzOFozSUxLU2IwRW00SjhobXZsS0dPM3VaVzg0a1pKaTVrSmxLck0z?=
 =?utf-8?B?Q1JrWGxuelFzdEF3MFZ6SWVsdU5DRXF1TmlPdmpBNlljREdoUE5TUGZveldw?=
 =?utf-8?B?SHBYVHpaRUkvTHhCRVRyQ1Yzdko4SWQxR050MzBKRmZSbDFBYTdKUEUydXFi?=
 =?utf-8?B?a3N3bGQxT2o1cFVIcG00eGFaelZadWludFV6RkRQVXIrbmZiUGc2NEFHa2N4?=
 =?utf-8?B?QnRzM0plSjlmN3RLMHpjRDhmNVZvQ2dZSUFHKzhDdk8xL3BLT28vUmt0cFBx?=
 =?utf-8?B?SjRTM1lEVEdIdHlGR20zSFN5KzZqaTR0QnlpN2tGQ2RibDB2aWJTMFVlQkZs?=
 =?utf-8?B?c0ZtU3NlSCtITk1TYk96MkhWWGtPTVB4UFBUa21WU3ZkM3Y2TkFWeXRzWWRL?=
 =?utf-8?B?NzJpaFhIY3ZVU3NaTVhyTVdpWmNpc2Z6RVFDV2RJNXllWVNxSXphVEJZKzFE?=
 =?utf-8?B?eEt1UjZHM2hwanloZGc3WVdXN1BGZHEvdUFlQm1JaUp2d3N1T2tBU0xIY0Jl?=
 =?utf-8?B?NnRjR095Q2tGeE50enVZUDJJRWFraTQ4ZmNBN21qTUhrNFlncWVjS1pablY5?=
 =?utf-8?B?OGZpTjNublo1bHNsMDU5Z3ZNR1ErODNMVHhRajdrQ2o0dUhNai9VUm9pQng1?=
 =?utf-8?B?WkpiaGZHZnEzMmtIdjBzd3ZIMkxUTmdnRW5KWDJYNFo4NEw5WVRtMkRrSWJ2?=
 =?utf-8?B?cXF3V1d4ZzVYbWZtM2lkeGVPQ3B1OEpLalRmUkNBa2NPVFBHVFI2bXl3dTZX?=
 =?utf-8?B?RlRIYW1mdGY4YTEyd3pwdjR3YWFnYzFtVHJKcEdPczZhckRyZjB3Yk9pN0dm?=
 =?utf-8?B?VlJmb2kwNVJ5TkFycWlvUGdOOVhZRHNnWVpuVk9NN1hOVTZveG9wdGlVVENT?=
 =?utf-8?B?Tkh0TVppWXdOU1VIK0lkZllPUlVEME1XV1BTazRPY0x5RnVyWHo3Qy9QbTZt?=
 =?utf-8?B?SkZSWXFoYUp5djZuNHlHTCtZcU9jcG9PaytMN3I4VU9mNjl6UVZlTXArcWQz?=
 =?utf-8?B?eklPWUU4Yk5qRVpMcHRNTVJ3S2FEWjV2bTc5Vkk0ZXRTbDhZZnc1aDdXQTEy?=
 =?utf-8?B?cjZvUGJlTTQ2eHZnNjhNZUlnUmV3YXhEOUgyMHVTclIydXpPc1BpRFFQV1Vy?=
 =?utf-8?B?WEswSlJVNkQ2TFZXNXU0N3BWM2JQb3h1UUZkd2RPOW5FSkpuZTJINFBXRUJy?=
 =?utf-8?B?bjlzb0drcXpMUEVxYVJDNFV1V0dmUldvN1FzRlV4YmNsWjV2c1lUMFl5Z1oy?=
 =?utf-8?B?d21TeXFyeGdmNTk5VHpEby9jQ0loeGRoUFpmWFovbVhPNDlyaUU4bEF6RXls?=
 =?utf-8?B?MENiL2pEOUFkQ3B5aWd6dEx3UHZFc01WMjRFMDdpMG1uMm5KN2pXM1M2K25L?=
 =?utf-8?B?cnFxVkc5dzZ2OVgxaCtwNTZOZGRnYlFCeDNwOVJJcFlpQU9tei9NUmJORm9m?=
 =?utf-8?B?b2k5NW4vVEh0MnlFdThyWGt6WUV3ZGM2eExrZWY4OStxeXVzWnNjMmNHckJi?=
 =?utf-8?B?RURBK1d3cEZNMTEvaUo1RDBJL2JqbmdmOWp2c29ZQ29QekYybzNIaVBQUi9z?=
 =?utf-8?B?R1RYRmdGWVBKdjIxWGFUbVp1S0VOdzBpaFJ0QXZWODh2ZUVYWndKRThpSzBt?=
 =?utf-8?B?Tk5IYm1HSm1Rb3NQcFdlUExTNTJmRFhhRndKMmp6dlVYazRCaDVQaTZKekRS?=
 =?utf-8?B?Uldud2hnTm5HSnZSQUN0OXpQazN1dFJ0bHdNTEFqZTZPakNYK0x1ZUowaFBz?=
 =?utf-8?B?TDFYK296ekE5Z0krdGw0MmJ2T0I5R2IwTVlzVXR0NlhGOWdNNnJ1N1ZKS2py?=
 =?utf-8?B?U1hPOURERk5kUll4ZnVYK3JFcUZEZlI5VVk1c3g4dzc3RTFuWVptekM5YytR?=
 =?utf-8?B?ZlFZSjhhVGVHSWJRY1dxeWV3MkdxRW9HL1FZVU5GM1I0aDZKYUtGUkI4aUg3?=
 =?utf-8?B?VTlUMUdTVnRabjJKai9OYzc2R0dPbU5WR2QxdER2VlFmZmhjOC81OGFibWZY?=
 =?utf-8?B?QzFWUmJFODllTGdpZ0MxMGJYQkJtK0k2Um1RQXRnS2hWRVdLVVc2em1KemVR?=
 =?utf-8?B?LytrRGhHR2Z2SUROOGZEVWoydXNBUFRuNVhMTC94M2hQZERRaVNvZUxWZVBN?=
 =?utf-8?B?RUlRdVpuRUpHek5SMnJJV3FPZkYxYTFxOFJwREw5RStKRElRQmpESEpOSjhO?=
 =?utf-8?B?OGxKOHBNc2J0SXY1U0ljM25wb2ZzUXVtdFNPNzZpbW1wYnRpMXdmYkJRZ1F3?=
 =?utf-8?B?aWJLOEFtRWpOL0ppZ05vVWV4SmdRc3hFT2djZDRBODRBZncrUVNiUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ON/xIV9ob43U7zrDyXzXjhlOT6urC++BdzsZQIfF6XkDm/1DJ5GJTRzKnzetAkgsP3DPpPqD4GpU9+Nfr1348/wsoopdstFZH1VN552lwjyDmXD19bg+wadIpYwdfLbtp+GEKIbpbDMs8zfFBBNCnmSz/IcLGG/cptXQvF2uqSPqxcE79bM82OveCc8JjYuNAk1T1g/GDk8xGnEZnG0zzaRjqmllSO68FYUTtjpPCW4kGSfQF8uo0z7xe2+d8KKgAo1W6PSUnReN4WRqddMxVtGR+JBRnIWJLHVH18BvzUQjnsO72i5jn+pAlUTRtnPYZCXCZDSkv+V4vqfhXyTmYw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407aff95-0ed3-4d9d-c5fd-08df3a040a84
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2026 23:41:53.9821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yjHnLwZbRPGVL5Uz6nXB7xH4xESJEegoxz6gIYsUXjTq9PUHvEiMRDsHFV1yVaZpwbcXIKA52tRUso+7M0iG9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB8834
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4831E160009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hbjm3d7oebxybu1n4xtrbm51bfbrpr4n
X-HE-Tag: 1793749327-35984
X-HE-Meta: U2FsdGVkX181mcqkT5is7v2Xul11OyhLK5GZZtQcZRwNCopGqm/wDhQS9LKYKfKA8x2wiN/qVHL0RUuC/Bp9bvErkYe8BJcVC2NvM7SZtrIoFxQwfmUM358WIoJiyW0V1UH9bZgWrHG0qVPOOhZsrzRzMQh2vJ4SvuIJfs0gTtksucf4krNC+I+cL218Z6tKaoZmqQ4D4K4uK7RfJJOjw46ir9ateg06IkL4O7Z9PEe3tM9WKKlUIEVnCm+t5dAxZVJisLC85tSEV1DXKMusCKS+ONhDkCKaps6Il6olXEwZ5gAOdM2rCnPp+l28YkrX24mCjfqI1NsJdqwDioydJiSsyMS47MiHgEu/HkOuAtQqAPh1WZBkEW6GKpXOOw8S2ssDTz3049mm77NIWbWmtH8fXwrwBXbwyCULM1+AvFSKeT8soXrT7K906ctSJdk/KVGMGyK3ar8QQip15Bf5AuV1MgWB9cCoCNYDL4sTx2OutkBf0hD0ztpIT+gkWkWYxFAIgZNE+6fwDP67Ep4wWsF0FpAnS0eb0qvRGH9jJCuU5s4nsl5gEqVtz0bA66Q1mmSAQTbW7F2UbiMMMJxKQhC9WEwtBhIxMguVf6YrRQHruS7EWN7b00G+rnDWHCiKHAsGGbg0rPfT3r7SQU1X6EhSPXv3jPu761Rnx6W1xyKHYNFROnFY/wS9IqWyh8aBt1lJirRon4Y3V5E0kcJHOyEauNmwPKa3cBXrf8gOJpl7xlw3wek2YgFkubzrEjHIIaKFoJ5thy6ULgHnurMPSkk/VRC0bbYNKkV3eyr3KJZQCE+BHhc0j4LGQkJUBqpZMrzbXg7ZzudO6IGdCNm70+wNP1uEKyqgwEHuR8RlES1iMfgLmt6UsNH5oJTDRHetotVgLsBtnLYqpfQHhU5RCMjfO9YeSzrc7DkcSRx+wrjSarr/lClFEv/4nRfXUXM3yQJXbJGSRJ5iaUPNcug
 mvpab0K+
 ge32gqOr9YJPRyl4aQWObgoJadaEMsnx98VUBe6sAmZy8mTJyLpY7PSigVGxXTam/hh8OfQ0JqBj9utH6Aut3AU6T5hIBqT+bDPsKRGOBS2glb4eML9EtNu0KJG9hvMTsSyKjR4Pp/thrqqPKG+HC8haCWDYKwNEpuuR/wdBXQxD97dj7LoCjLg5ctz9SfGB8rQxe/RLcZgSrFeNX9/HfX+u1fw1ua5mk22pOCYvzsat1S/kQ1ZuxxZsfaU8M/1r9Y0OpI+mFQnZ0aTZhx3l5Rm/sfQqjdeN8Yi5homZhFeuuze1jP2BeUHCMD3mbRzy+cpZoJf0x4I1WpmjFMXhgYvrqUnCpB7deZY4PEAwdDLX/TPNIfllpTO5bO6Ex8D8i9R7eC3q9mJXLCNsSNYr7i8mA8iVN9jz1tG/ixq7pCISQfxslkMTrHC8PLrGw9YvHOJngQ8Elk5BD9v9rae1qGMusWQhO/lx6l/tBKCfcVg4FbcRSHUVT3QpKJMlMf//q3RRgg0JWzXjKJNI/OTONjVf3L9lkBp7PmdcHgA9j1iGd38qZ/EyMDPFJjSRVU8FWYjRNetN3xAeq+nyK31CbOHR3ru+0TTjQDoyqXmVXv5Yn4conQVZqG+7uyN6V8Zq4oPqk1+MsrbwjrJV38IkdmaCXJmR8ws0l/PjyZslnf7En09juPHSGOLaz89xCd17TLaHGghn0BuPe1rWvq43fuKAuqIoDpX3EcqUt0NB6R+GXm2zKnjOxHnvLEPGvJ5e8o0ndqtG8YoE9zeDc9djPLhHEgK0epvIBIhQSrOB4KALaiHdE+TMnGylm2T7YTWd0lvyx7BEqT8dHsgc7WclKF1qRv4spFAzbbLqIxpKDABCLe+dLcdgk+8Hsj6qRtWulc4ZKlNDnzvVUjbu1NMwivhi4u/6x2n2/dwSOfozZh2ZYJkuVQ2F46Bf9dZ2t7UohUxIc8xumd/SrC7kFS6H6PHQGHio6
 FWCjhzgY
 W+Y37kt0Mlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SGkgYWxsLA0KDQpJIHdvdWxkIGFwcHJlY2lhdGUgeW91ciB0aG91Z2h0cyBvbiBob3cgd2UgbWln
aHQgYWNoaWV2ZSBhIHNpbWlsYXINCnBlcmZvcm1hbmNlIGltcHJvdmVtZW50IHdpdGhvdXQgaW5j
cmVhc2luZyB0aGUgbnVtYmVyIG9mIGtzd2FwZA0KdGhyZWFkcy4NCg0KSW4gdGhlIHByZXZpb3Vz
IHBhdGNoc2V0LCB1c2luZyBmb3VyIGtzd2FwZCB0aHJlYWRzIHJlZHVjZWQgQ2Fzc2FuZHJhDQpw
OTkgbGF0ZW5jeSBmcm9tIDYuNSBtcyB0byAzLjM1IG1zIChhYm91dCA0OCUpIGFuZCBpbXByb3Zl
ZCB0aHJvdWdocHV0DQpieSAxMC4zJS4gSSBiZWxpZXZlIHRoaXMgaXMgYSBzdWJzdGFudGlhbCBy
ZXN1bHQgYW5kIHdvcnRoIHB1cnN1aW5nDQpmdXJ0aGVyLg0KDQpUbyBleHBsb3JlIGFsdGVybmF0
aXZlcywgSSB0cmllZCBpbmNyZWFzaW5nIHRoZSByZWNsYWltIHRhcmdldCBmb3INCmtzd2FwZCBw
YXNzZXMgKHRlc3RpbmcgbXVsdGlwbGllcnMgZnJvbSAyIHRvIDEwMCksIHNob3J0ZW5pbmcga3N3
YXBkJ3MNCnNsZWVwIGludGVydmFscywgYW5kIG1ha2luZyBpdCBtb3JlIHBhdGllbnQgYmVmb3Jl
IGRlY2xhcmluZyBhIG5vZGUNCmhvcGVsZXNzLiBTbyBmYXIsIG5vbmUgb2YgdGhlc2UgYXBwcm9h
Y2hlcyBoYXMgcHJvZHVjZWQgYSBjb21wYXJhYmxlDQppbXByb3ZlbWVudC4NCg0KSSB3b3VsZCBi
ZSBncmF0ZWZ1bCBmb3Igc3VnZ2VzdGlvbnMgb24gb3RoZXIgYXBwcm9hY2hlcyB3b3J0aA0KaW52
ZXN0aWdhdGluZy4NCg0KVGhhbmtzLA0KRWhhYg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gRnJvbTogQWJhYm5laCwgRWhhYg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIg
MTQsIDIwMjYgMTI6MjkgQU0NCj4gVG86ICdCYXJyeSBTb25nJyA8YmFvaHVhQGtlcm5lbC5vcmc+
OyBTaGFrZWVsIEJ1dHQNCj4gPHNoYWtlZWwuYnV0dEBsaW51eC5kZXY+OyBKb2hhbm5lcyBXZWlu
ZXIgPGhhbm5lc0BjbXB4Y2hnLm9yZz4NCj4gQ2M6IHppeUBudmlkaWEuY29tOyBsaW51eC1tbUBr
dmFjay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGJ1ZGR5Lmx1bXBraW5A
b3JhY2xlLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4ga2Fzb25nQHRlbmNlbnQu
Y29tOyBxaS56aGVuZ0BsaW51eC5kZXY7IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7DQo+IGF4ZWxy
YXNtdXNzZW5AZ29vZ2xlLmNvbTsgeXVhbmNodUBnb29nbGUuY29tOyB3ZWl4dWdjQGdvb2dsZS5j
b207DQo+IGRhdmlkQGtlcm5lbC5vcmc7IGxqc0BrZXJuZWwub3JnOyBsaWFtQGluZnJhZGVhZC5v
cmc7IHZiYWJrYUBrZXJuZWwub3JnOw0KPiBycHB0QGtlcm5lbC5vcmc7IHN1cmVuYkBnb29nbGUu
Y29tOyBtaG9ja29Ac3VzZS5jb207DQo+IGphY2ttYW5iQGdvb2dsZS5jb207IGhhbm5lc0BjbXB4
Y2hnLm9yZzsgYmFvcXVhbi5oZUBsaW51eC5kZXY7DQo+IGJhb2xpbi53YW5nQGxpbnV4LmFsaWJh
YmEuY29tDQo+IFN1YmplY3Q6IFJFOiBbUkZDIFBBVENIIHYyIDAvNV0gbW0vdm1zY2FuOiBhZGFw
dGl2ZSBtdWx0aS10aHJlYWRlZA0KPiBrc3dhcGQgZm9yIE5VTUEtYXdhcmUgcmVjbGFpbQ0KPiAN
Cj4gSGkgQmFycnksIEFsbCwNCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiBGcm9tOiBCYXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4NCj4gPiBTZW50OiBTYXR1cmRh
eSwgT2N0b2JlciAxMCwgMjAyNiAxOjE5IEFNDQo+ID4gVG86IEFiYWJuZWgsIEVoYWIgPGVoYWIu
YWJhYm5laEBpbnRlbC5jb20+DQo+ID4gQ2M6IHppeUBudmlkaWEuY29tOyBsaW51eC1tbUBrdmFj
ay5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gYnVkZHkubHVtcGtpbkBv
cmFjbGUuY29tOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOw0KPiA+IGthc29uZ0B0ZW5jZW50
LmNvbTsgcWkuemhlbmdAbGludXguZGV2OyBzaGFrZWVsLmJ1dHRAbGludXguZGV2Ow0KPiA+IGF4
ZWxyYXNtdXNzZW5AZ29vZ2xlLmNvbTsgeXVhbmNodUBnb29nbGUuY29tOyB3ZWl4dWdjQGdvb2ds
ZS5jb207DQo+ID4gZGF2aWRAa2VybmVsLm9yZzsgbGpzQGtlcm5lbC5vcmc7IGxpYW1AaW5mcmFk
ZWFkLm9yZzsNCj4gPiB2YmFia2FAa2VybmVsLm9yZzsgcnBwdEBrZXJuZWwub3JnOyBzdXJlbmJA
Z29vZ2xlLmNvbTsNCj4gPiBtaG9ja29Ac3VzZS5jb207IGphY2ttYW5iQGdvb2dsZS5jb207IGhh
bm5lc0BjbXB4Y2hnLm9yZzsNCj4gPiBiYW9xdWFuLmhlQGxpbnV4LmRldjsgYmFvbGluLndhbmdA
bGludXguYWxpYmFiYS5jb20NCj4gPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCB2MiAwLzVdIG1t
L3Ztc2NhbjogYWRhcHRpdmUgbXVsdGktdGhyZWFkZWQNCj4gPiBrc3dhcGQgZm9yIE5VTUEtYXdh
cmUgcmVjbGFpbQ0KPiA+DQo+ID4gT24gU2F0LCBPY3QgMTAsIDIwMjYgYXQgNDozMOKAr0FNIEVo
YWIgQWJhYm5laA0KPiA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT4NCj4gPiB3cm90ZToNCj4gPiA+
DQo+ID4gPiBUaGlzIGlzIGEgZm9sbG93LXVwIHRvIHRoZSBSRkMgZm9yIGFkYXB0aXZlIG11bHRp
LXRocmVhZGVkIGtzd2FwZCBvbg0KPiA+ID4gTlVNQS4gSXQgaGFuZGxlcyBjb25jdXJyZW50IE1H
TFJVIGFnaW5nLCBhZGp1c3RzIHdha2V1cHMgdG8gbm9kZSBDUFUNCj4gPiA+IGxvYWQsIGFuZCBz
Y2FsZXMgdGhlIGhvcGVsZXNzIHRocmVzaG9sZCBmb3IgbXVsdGlwbGUgd29ya2Vycy4NCj4gPiA+
DQo+ID4gPiBVbmRlciBtZW1vcnkgcHJlc3N1cmUsIGFuIGxydXZlYyBjYW4gZW5kIHVwIHdpdGgg
b25seSB0d28gTUdMUlUNCj4gPiA+IGdlbmVyYXRpb25zLiBUaGF0IGxlYXZlcyBhbiBvbGRlciBh
bmQgYSB5b3VuZ2VyIGNvaG9ydCwgYSBiaXQgbGlrZQ0KPiA+ID4gaW5hY3RpdmUgYW5kIGFjdGl2
ZSBMUlUgbGlzdHMsIHRob3VnaCBNR0xSVSB0cmFja3MgYWdlIGRpZmZlcmVudGx5Lg0KPiA+ID4N
Cj4gPiA+IFJlZ2FyZGluZyB0aGUgY29uY2VybnMgcmFpc2VkIGluIHJldmlldzoNCj4gPiA+IC0g
SW4gdGhlIHVwZGF0ZWQgQ2Fzc2FuZHJhIGNvbXBhcmlzb24sIGZvdXIga3N3YXBkIHRocmVhZHMg
cmVkdWNlZCBwOTkNCj4gPiA+ICAgbGF0ZW5jeSBmcm9tIDYuNSBtcyB0byAzLjM1IG1zIChhYm91
dCA0OSUpIGFuZCBpbmNyZWFzZWQgdGhyb3VnaHB1dCBieQ0KPiA+ID4gICAxMC4zJS4gV2UgYmVs
aWV2ZSB0aGUgbGF0ZW5jeSBnYWluIGNvbWVzIGZyb20gdGhlIHJlY2xhaW0gZGVzaWduLA0KPiA+
ID4gICBub3QgZnJvbSBjaGFuZ2VzIHRvIExSVSBsb2NraW5nLg0KPiA+ID4gLSBUaGlzIG5ld2Vy
IHJlc3VsdCBjb21wYXJlcyBmb3VyIGtzd2FwZCB0aHJlYWRzIHdpdGggb25lLiBUaGUgZWFybGll
cg0KPiA+ID4gICA3LjMlIHRocm91Z2hwdXQgcmVzdWx0IHdhcyBtZWFzdXJlZCB3aXRoIGVpZ2h0
IHRocmVhZHMuDQo+ID4gPg0KPiA+ID4gV2UgYWxzbyBzYXcgcGVyaW9kcyB3aXRoIHplcm8gZmls
ZSBzY2Fucy4gVGhlIE1JTl9OUl9HRU5TIGd1YXJkIG1heQ0KPiA+ID4gY29udHJpYnV0ZTogd2hl
biBvbmx5IHR3byBnZW5lcmF0aW9ucyByZW1haW4sIGl0IG1ha2VzIHNjYW5fZm9saW9zKCkNCj4g
PiA+IHJldHVybiB3aXRob3V0IHNjYW5uaW5nIHRoZSBvbGRlc3Qgb25lLiBUaGlzIHBhdGNoIHRl
c3RzIHdoZXRoZXINCj4gPiA+IGxldHRpbmcga3N3YXBkIHNjYW4gdGhhdCBnZW5lcmF0aW9uIGhl
bHBzIHJlY2xhaW0gcHJvZ3Jlc3MuIFRoZQ0KPiA+ID4gY3VycmVudCB0cmFjZXMgZG8gbm90IHRp
ZSB0aGUgemVyby1zY2FuIGV2ZW50cyB0byB0aGUgc2FtZSBscnV2ZWMsDQo+ID4gPiBzbyB0aGlz
IHJlbWFpbnMgYSBoeXBvdGhlc2lzOyBtb3JlIHBlci1scnV2ZWMgdHJhY2luZyBpcyBuZWVkZWQg
dG8NCj4gPiA+IGNvbXBhcmUgaXQgd2l0aCBsb2NrIGNvbnRlbnRpb24uDQo+ID4NCj4gPiBIaSBF
aGFiLA0KPiA+DQo+ID4gVGhlcmUgaXMgYSBwYXRjaHNldCB1bmRlciBkZXZlbG9wbWVudCBieSBL
YWlydWksIG1lIGFuZCBnYW9mZWk6DQo+ID4NCj4gPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9iYW9odWEvbGludXguZ2l0L2xvZy8/DQo+ID4gaD1rYWly
dQ0KPiA+IGlfc2NhbmJhbGFuY2VfMC4zDQo+ID4NCj4gPiB3aGljaCBhbGxvd3MgcmVjbGFtYXRp
b24gYWZ0ZXIgd2UgYXJyaXZlIE1JTl9OUl9HRU5TLg0KPiA+DQo+ID4gVGhpcyBtaWdodCBmaXgg
eW91ciBwcm9ibGVtLiBIb3BlZnVsbHksIHdlIGNhbiBmaW5kIHNvbWUgdGltZSBuZXh0DQo+ID4g
d2VlayB0byBzZW5kIGl0IG91dC4NCj4gPg0KPiBUaGFuayB5b3UgZm9yIHRoZSBpbmZvcm1hdGlv
bi4NCj4gDQo+IEkgY29tcGFyZWQgdGhlIHR3byBwYXRjaCBzZXRzIGFuZCBoZXJlIGlzIGEgc3Vt
bWFyeSBvZiB0aGUgcmVzdWx0czoNCj4gDQo+IEJhc2VsaW5lOiBMaW51eCB2Ny4zLXJjNyBwbHVz
IHRoZSByZXZlcnQgb2YgNmNiZGQ5NzI2ZmI1Lg0KPiANCj4gTXkgYXBwcm9hY2g6IEFkYXB0aXZl
IG11bHRpLXRocmVhZGVkIGtzd2FwZCAoNCB0aHJlYWRzL25vZGUpLCBwbHVzIGENCj4gcGF0Y2gg
dGhhdCBhbGxvd3Mgc2Nhbm5pbmcgcGFnZXMgd2hlbiBvbmx5IHR3byBnZW5lcmF0aW9ucyByZW1h
aW4uDQo+IA0KPiBDb21wYXJlZCBhZ2FpbnN0OiBLYWlydWnigJlzIHNjYW4tYmFsYW5jZSBwYXRj
aGVzLCBiYXNlZCBvbiB0aGUgc2FtZSBiYXNlbGluZToNCj4gaHR0cHM6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmFvaHVhL2xpbnV4LmdpdC9sb2cvP2g9a2Fpcg0K
PiB1aV9zY2FuYmFsYW5jZV8wLjMNCj4gDQo+IEJvdGggYmVuY2htYXJrcyB1c2VkIHRoZSBzYW1l
IDEyLW1pbnV0ZSBDYXNzYW5kcmEgd29ya2xvYWQgd2l0aCAxMDANCj4gY2xpZW50IHRocmVhZHMu
IENvbXBhcmVkIHdpdGggdGhlIHNjYW4tYmFsYW5jZSBydW4sIG15IGFwcHJvYWNoIHByb2R1Y2Vk
Og0KPiANCj4gVGhyb3VnaHB1dDogNzEsNTc3IHZzLiA2NiwyNDYgb3AvcywgYW4gOC4wJSBpbmNy
ZWFzZS4NCj4gcDk5IGxhdGVuY3k6IDMuNiB2cy4gNi4zIG1zLCBhIDQyLjklIHJlZHVjdGlvbi4N
Cj4gUFNJIHNvbWU6IDQxLjkgdnMuIDEwOS42IHMsIGEgNjEuOCUgcmVkdWN0aW9uLg0KPiBQU0kg
ZnVsbDogMzkuMCB2cy4gOTcuOSBzLCBhIDYwLjIlIHJlZHVjdGlvbi4NCj4gDQo+IEkgYWxzbyBz
dWJtaXR0ZWQgYW4gUkZDIHJlbGF0ZWQgdG8gcmVncmVzc2lvbiBpbnRyb2R1Y2UgYnkgNmNiZGQ5
NzI2ZmI1Og0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDkwMTE4MDcw
NC4xNjgxMDYtMS0NCj4gZWhhYi5hYmFibmVoQGludGVsLmNvbS8NCj4gDQo+IElmIHBvc3NpYmxl
LCBJIHdvdWxkIGxpa2UgdG8gZ2V0IHNvbWUgdGlwcyBmcm9tIFNoYWtlZWwgb3IgSm9oYW5uZXMu
DQo+IA0KPiBTaGFrZWVsIGFuZCBKb2hhbm5lcywgd2hlbiB5b3UgaGF2ZSBhIGNoYW5jZSwgSeKA
mWQgYXBwcmVjaWF0ZSB5b3VyIHRob3VnaHRzDQo+IG9uIHRoZSBwcm9wb3NlZCBwYXRjaCBzZXQu
DQo+IA0KPiBCZXN0LA0KPiBFaGFiDQo+IA0KPiA+IFRoYW5rcw0KPiA+IEJhcnJ5DQo=

