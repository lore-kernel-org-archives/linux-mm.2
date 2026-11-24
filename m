Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E15606A334
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 00:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OW3gD8cg;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=eKcUJVD7
Received: by kanga.kvack.org (Postfix)
	id E29656B05B1; Mon, 23 Nov 2026 19:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDABF6B05B2; Mon, 23 Nov 2026 19:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2706B05B3; Mon, 23 Nov 2026 19:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8235F6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:44:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8527C0A97
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:09 +0000 (UTC)
X-FDA: 85468165818.04.61F048E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf11.hostedemail.com (Postfix) with ESMTP id 505C940002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:44:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OW3gD8cg;
	dkim=pass header.d=intel.com header.s=selector1 header.b=eKcUJVD7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of reinette.chatre@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795481046;
	b=Rjo5FzvZ4SQx0OyTvS2mE4GMjuiRm1rGsW4E4RnxD7wJ7pdMeThzFtfNYHeCstG8UYc+4p
	1cyNXh/5/mxLgf3vvQQMAfMYfUj6QEiMS5b2QVNN4SMeEJKVRX6IL3D4awGHCTHcBLLYQg
	/kVx0NNhuxpOHFIo0ekno/Gj7HSZk9Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795481046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgaRGRNCtGjckwNFvJyZ1yqj5xuaRbbXIKuPgN632rs=;
	b=1oZfO1wxXZLQTvR0+x5n/o2fPGlv3RpRuTdwU5wZNCWvNSIk+DcdT/sFSHP7zNMzNtH0Rg
	RnBMg9zkyowPGXgi1gkrohXFskqTwiaHuiadRe+Q82thOW/JWdS19qIzNvbU/bEdlwezY/
	gqGz40edI8RoeRkTpdhY0zLGKVmBpo0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OW3gD8cg;
	dkim=pass header.d=intel.com header.s=selector1 header.b=eKcUJVD7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of reinette.chatre@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795481046; x=1827017046;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jC/cf+NVaOjKJyXfASgrSweAwMVjtBAXyVhmnc4SwA8=;
  b=OW3gD8cgkJ8uJOpZuJMVDyEe2HIqCyE/QhBzblrv1yUSiJir+ALMShqD
   rbt7plXNBdPji5EGQoSpDru6JpaG315MMsGpQwWq8ESWKyddkTYFqHzJ+
   H5C5Z4+mRLUjoil+aDj7KFP3dBChHO9MyXFSLMAg/SstGUYYC403Z2U3E
   xsr4TLquYM25NwxyL6a/LDx+wl+gT9lQDIHdjM/fy3BvuwOg5BCZWbRdK
   10PTC/sTNxKRg1eG0Tt86Y3hkCDONnl/ntUJpcTkOLAF2z0N9CpVb+1D/
   kNei9m1JJdY7sMmyB1Q0H4jb9s4M3yxracrCIl9NW5bg6Lb9dJO6KTQyh
   g==;
X-CSE-ConnectionGUID: RXKpMakKSSOpusp1D7JYkQ==
X-CSE-MsgGUID: wjWem64BQAaP47y5GAMyTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4147896"
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="4147896"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 16:44:03 -0800
X-CSE-ConnectionGUID: PGQV02mBRMWIQ3EL1UFftw==
X-CSE-MsgGUID: GiVVKpoMQDGZzeUoF587uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,229,1787036400"; 
   d="scan'208";a="11605288"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 16:44:03 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Mon, 23 Nov 2026 16:44:02 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Mon, 23 Nov 2026 16:44:02 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.39) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 23 Nov 2026 16:44:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QErakYwkMJc67rRdQCB1Ax9/RldFqjT2mNM+ZGfhv7NreAZyQGr4wfufXeP7RyajSi716IPRVKdIezHJlwLoLd1Ynqsrr+NODl8sUNcYrdL7iQtfbXZwh8qVWZ/Ojx2HK5uwXMbPRp+O9Q0W3oWEggz7bkLOtjeAbjQv8NxzTmII7Oo/QfTgntJ1nKNKjklnSEMccI2IuyVfRI66GrqQSq+Lrl300htFZhqB4zMbYKPRCmb5PwvuNFKr2pKMEmZ27TbrYv8NtrMxlwanQbkBnEHB5mmq2QQTbAl2jwLgDm79aZz7f/rS6kLGhyP6OwlKK35eiv1h0CaDpmshhycWfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgaRGRNCtGjckwNFvJyZ1yqj5xuaRbbXIKuPgN632rs=;
 b=ydV1pR4S0ko07YLMPNFjoE+GOF3D7Cozm4ZbB+0h89eCzygRXcy6YWbPzZe9w61SikwqoE3C+/vEyTNvKKY9HfMJPlUlV81cuWMcE4gHCa8Gt2+J0NJCb1R6YGTPUXvFOo/NMsdqWjmLcjbnP90Jb9iVDA+EFZMk1byzY1NwAvDxqF5UlfRVww+SEVGjBBUuBYLfQQeL3CToWYMkE3guAOGeNH+qdtCFhXxIdgY+h2REnKNJqzs+I/F7a/uPeqIzOwr9StxhDkapDYGAAKAzwO1/pt2aR/wrEspRAfIO6JsWKBT43I+QmXzPt7csh8fX6zwTotEBPq99da+9K5jWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgaRGRNCtGjckwNFvJyZ1yqj5xuaRbbXIKuPgN632rs=;
 b=eKcUJVD7pdHnjp3GL3eNolX0iWTeOB0S7DwiZV24WSYyXZVgZ3e/qd+hPBnK4DHFvSXg1VdGoNfDMksGO5mtZWROjJvfLZz8Do9H4PF0ImX57+8sCMhuwhlJRHSY5K5/WPmVrpZvqA3aSsqQ60R8cryXKb1S2v1NRIVViBG/MUE=
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ5PPF33E90C8BE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 00:43:58 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0615.009; Tue, 24 Nov 2026
 00:43:57 +0000
Message-ID: <307b89b8-7613-46c2-a8a5-f6ecf7d05b25@intel.com>
Date: Mon, 23 Nov 2026 16:43:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource group
 assignment vs copy_process()
To: Ben Horgan <ben.horgan@arm.com>, <kees@kernel.org>, <mingo@redhat.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, <david@kernel.org>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <jedrzej.wasiukiewicz@intel.com>
CC: <fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
 <17fe3497-b887-4dc1-a8f8-3b647c1880a6@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <17fe3497-b887-4dc1-a8f8-3b647c1880a6@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ5PPF33E90C8BE:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a72114-52dd-450e-5130-08df49c405d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|22082099003|18002099003|921020|11063799006|56012099006|4143699003|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info: Qq80cFJkYjheX3/C9yQp0Qd7mAALdhwVYwU8DyGZXBlwRQZNWX6/FBmzaObRD4/2MbF3YKgH0+k7QYQq2LnpzL3d7YvNWGmni5hHN3hWs45KQ7io4Ee69cOaS97nvKJCJDNZGodvIbz/AifNr+pCx8X17sHKqjJudxgwaO3r3MwNT6bIDWoHXXsTEKhbqL3gRhp6IS1Irmcdc4XtFjDngz9rVVmOquafIDJgA7/edFtACFNzdjqETVaCTUyFtiD6SojSz17k8o+boyX56Gbu9+2m980m6jrxikjYcCNd1NWsZ59HJB0+XAmhXRZg9pabzOa14ZKMePsb4zSoZS+Z34PFZP2OAYb5ZV9OAfv5J7K6BHP0biGiErRraqrLTqCqx0RmY9lB4SFsiIe8M+9iXYQHNwmJPmjkQB3+nUpKdEzNkDRRJ4s14CK95LzNA4FAVD23rsxSCGZjTzJlF8KreIjYOHPdiPvrQ36Bq1vTCB5dsz6i+eNFlh2jcb1lhhEwZ42rN8yVd753+pdrYBa14OwwTpOhJhR6mcku0DU/vNvW8xE/+gzZa993M0x7pfmLhCtE7pefz/XCSY1MOAld9mulQn+dgui+SR2nsIDC/HyNIj2WUqdQCjm0ZCKpFp5ZgeM/XWQTyG4nyB1WB9SDi5eArzVbtetGoZrAVE95YjTW71SF2Io4RehFef/WfDSifbQb3JxfsP0YQfukTdmLxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(22082099003)(18002099003)(921020)(11063799006)(56012099006)(4143699003)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d25tSlNxRXIrc0xSSm05cjNEWFZZTjI1Q04zUURhY3djbStQQ0J3c1dCbEM4?=
 =?utf-8?B?UEg5MWF1Z0J1a3pWRm9rQzcvOXE5bmpDRlQrODFibkFFLzdGVkFDTjIrU3ZO?=
 =?utf-8?B?WVVsMi9nNmZ6VUY4WEwwOHpYSkQrQmQ2V1hISEpqUlB5Uk4zYWxYVHJ3RnBJ?=
 =?utf-8?B?NEI5UWxoVTJuZGV4TTVlT2hqVUxMeTc1cWQxS0h4ZkpZbFlHN3pKMFIrV1Ry?=
 =?utf-8?B?YkcyREM3RHNTeDhBTjZ4UEJkQ1hPZHBEb3dhN0pUbjcrSkdNUm9Tc3VsaHgr?=
 =?utf-8?B?L1F3SU1EWmRhOVpBYXpERVdXMkhHemo4c0NXdjJWc0w0bmF5eDZIdStRZkNG?=
 =?utf-8?B?OEdvNmVKSFpGbTlVVVdERDg3VlZOY1FKUnRnR0hKQisxSVg3ZHVya3NVRkxs?=
 =?utf-8?B?QnZOcHJrMkpqbUdrTi9RRFgrb1lHZmxjc05DNjBkQ3hHcGNGMFZHb0p1alFV?=
 =?utf-8?B?bHdsL2tSakgvcjBKRHZvQVhWWSt4OHNYWmhPZ1lKL2RMajB2UGZ6emN5NkNT?=
 =?utf-8?B?TklTU3VjdEREWGdBU3VlOE11aisvZDYvd2RMQzEzMVdsSFA5dlhHN2JwcE1q?=
 =?utf-8?B?c1BVTDBhT2lmY3ZodnY3RHlHQzZiZVJ5Z2MzK2JTaWpTV0I4djFOWGRpWlpv?=
 =?utf-8?B?T3k3bXpCNGFiVGsyNXlxaTlBYUE5WkJpVHJrazRyUDNuelBvNHFEUUFESnFu?=
 =?utf-8?B?Y2o1NjE1R2s0TnpDWVA2RlAvZVJHRCt1SmlnaWVRM29Rd3NpTENOWUZkVGNM?=
 =?utf-8?B?Yk1abWR0OWRDVU5qb0tGSi9MQ1l2cGhKREFxbTR5UzJidmpBZ2dwNUJOV0dy?=
 =?utf-8?B?eE10S1lQUmRCNy9sOVVNbkN1NnZhcGZXM3JUV0wzOVBVM2Z5eDF5WFlvMm1T?=
 =?utf-8?B?N3lyd1JyRTJvbE40b1E1SXVwYlFwcWRSdE83QTk1WUVWSnhQN3REU2pNWk1k?=
 =?utf-8?B?T3BOdVRLNU1ITFd1WEpMWVRGSXcydEhobld3T1ZtbjRyVDZWYzlYZnZqa1VV?=
 =?utf-8?B?eXNnZE5GaUplcXNnOU9sK2JvU2JBNDhiWkdzeEoydXlQb3pXOHpQQUxwS1Nm?=
 =?utf-8?B?Tk8xbng4L1FQQXcxaGQxN0luVUtzbmFTMGI0T3VrZGJ5RWVER0lXbGErY0lt?=
 =?utf-8?B?N1VveGZITFRZZlFzdTdyTlJlU0JNK0p5L1lpbFFrRHdtdXhvREVkZkNNczRF?=
 =?utf-8?B?bnlpTndLcWh2bnQ5LzZva0NGR0FhNmd0cC94TFVTMTEvSnRqQittRnlKY280?=
 =?utf-8?B?amR1UDlLbk9yelVEcmo5WGRxM2k1cmxoTGQ2S1ZIbEFHUXdnMjB1NnF0K2FK?=
 =?utf-8?B?QklBb1NWUHhKemV5d2oxOENqS25tWFh2U1c4clN2Z3JHOW9XT215cW1LejVx?=
 =?utf-8?B?Y0VITlZ0cy80UTFrS0FzRUc2NXp2UmxOZnkvalEvZ2ErbStjdHBkT3Z6NHJK?=
 =?utf-8?B?ZXJyQ3BxcUlOOU1qcFBvbVNrb3RGeVBRQXg2VUhlMVg4aDdaMU1VMEZSMWRN?=
 =?utf-8?B?WEZMZit3aTRnbGtaeGRJOFpKVHdLa2YwWGY3NHNyM3NJWFVYSkJkc0NjTGo5?=
 =?utf-8?B?NnR6S2xTU0RkK1p2V0dWOElTSWNiZ1dBb1B5WU4xUFJmUDVwVnhNVVo4SmxY?=
 =?utf-8?B?UE1yOFMrZDRrSFZ3b1huanF5OTZKb0ttY3Jla2prUkVhR0lQZHBjNDFYQmJV?=
 =?utf-8?B?K0RxU1FZWWJOQVQvQUdiTC9oZXQrWjlIWDZvcUJkZFNmZUJMcjFkUWRhRXI0?=
 =?utf-8?B?QWRyUG5TZXdXdllWYlZvdDdYVXpTVkx0VmpJWTVvdG5kVkI1Tk1MVzZGY2xX?=
 =?utf-8?B?K2dCSkpCN1VLNDJ0ZGZzZWV6WDNRU0gyZnRPNTZWMXl6V25lWE5pRWFaYU5r?=
 =?utf-8?B?WC9WR2dvR3o3a3pJdnhoUTExZiszcnBSL1gyT0srT1ovUzdCNXhMVEQrZjJw?=
 =?utf-8?B?bExWNHR6eCtJVVZUbUNoMXFXc050WWYvT25MZnUvL1h1SjM0bTVSR2hzeEVV?=
 =?utf-8?B?TFNFM2FKNUNmYTFoNHJ5Y1lDMU96TmE0T21kUWpxV2dKcGxlbWQ2S2dpT1Fi?=
 =?utf-8?B?M2xFSys2cjl3MXppZEhZM29pY3F2aGZKVHB3TkNXd1FYamN2bHJXVEJMVkk3?=
 =?utf-8?B?OTdoT1NRdXY5SlNjOExmSVhDZWtRK0ZuWHlCaWdmcnVzQThTYVArYTB2TVRX?=
 =?utf-8?B?elVHZFFURTFrTjlNZE9yNWEwNldxYlYyVndVVFdDWEJMZ0Noc2RUVFJYUVZt?=
 =?utf-8?B?UEM5OEFlSWV5NWt4ZlRFM1lublNjVWJWN0hGYTNxeE1SRktudFBXNllEdmJ5?=
 =?utf-8?B?cXBscEorQXUrQzI0WlUwck9pVW5jM3EzYkdaa3NKQ1pjdnJKS3J5WmZpR2pK?=
 =?utf-8?Q?GRab9AuCwX1D65kQ=3D?=
X-Exchange-RoutingPolicyChecked: hvnCyF7fqxFTbzgjKf+pb0KkkC93ET47HqcNfCZ8WazCkVnq3SrmMRUcex+xGVSttDb2zI9V72HAclqcypiJnxerVKLjHcN0K0PdDX+jNVy3CfapwvVRFcVixlxWLr0AOx3wrTstB1vTVjJNHswUGLAHJ8fXMbIb7vIkOn2Qir4vWyDEhr6tNhu6zmGHvWWVc0tszbOEhfn6OgccoVOk8MuVyiZJCbYpYPHEUot86AVkk2sYeUVJnPq2LH3lEZWEl7z5PVzIfEIDJJENBVvyUSqVRvB4ZCNTtk+H04M7NMNaypAiontTv4pKT+u/EPm2IGJYd4MbjDB3R5HNsmm1MQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a72114-52dd-450e-5130-08df49c405d5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 00:43:57.2256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nBxaQ9/rWwG18FgpIKp842fmvVArTnya/w7FuN9hWf6FPjY0beRVpb30w+bk3CM2Byi2QEDpImX1bCGi/qEh3qdDRDHCnTFlB/hxNd+mAwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF33E90C8BE
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 505C940002
X-Stat-Signature: snss3nktshzpjdwiyi6bcpp3yk7zuiou
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795481045-546630
X-HE-Meta: U2FsdGVkX1+7GIXOi8v+yv3oSJ99uuYlIBTkbnn591wFhnhU9TfGGquKQDzKI8eNO4DeAIrB3vxIulm0Horq8g8dsIbKiAdZvVlHgYhrDihz3QXbVMcn1VGpgbd2gHhFneEC24+neRWCWXEHDgOL3aGiXJIrGGmuC6NSCdym1dSpjsJvctno/zkf9BnhDMHt1s0NggqJ+Zda0Pk0Bi6z4bbBACZkPkPzpXtCFSJtSwVuZVTWYp6NWDx48lSmh9Aiyf30XrDsZ2WeYielUPiq3lUye7j+ODF1k4NelrRwvBWL2tQmQLOUvUY5FQON6nK0gUPJe3ZQ+MZiz4lXwJiTtfYbUYw0KxsKXep6ARG0d2fUslZe5EOUwNdwRaN2ptFD/9Hn3NiWelSAwkmt0bTcAYjB0Ovd2BgcrSyavS0XAdezGTw5anGXIlDp3wkYSYAdUa7KjTn0q8Fji6tMmjCrD1I0EzlLgVxsGpyyUz0iFCGshgeSH/TAQary15/6tMjDbtFnGfsYEa8XvlRPSojYLoK09f0mIhR8RjPAKjFXpfkF+1/IuQI2admv8CBGU1lEvSneyI07xZqf3LkhkcTkBap3GCz41sEO9UB3OCtGMwHlWOIEbofrszNsSRBnV73dult12I19CesHhq4hT/yqrn9Puu4Dgxd8/vNz8ZHJtiH1bJAlai4fGSDGEajt0ei8GGGjeTqLZVMI53IQbG+u5nyrDK8sse3Wj7mS7vvlKOQ7P9nPgkp+mkjQHElEkDCkOiMnedb9YqGYzJ60leucioeGsgkt69PtPQJmxn7g6YrR9V4uUR9n9V+TDdAzPe5a5RhJFUlsehRCl/2G8x0uoVnRFAzBlR854uEa3OxxFcX1yoltZo9Oq0hqes67l23rrqNVgYyjWM9XBWQA7qcHSVji3qoBIFn/hWvDGs7xBHdsuWJuM/zD94SckLVpg7RzoRKitBtCvS59SfR+/Dj
 bTIcRmnJ
 1E7TKu/z/7C7PLYb0qOK7awv8YcRTF/b6lQlnq7xAGc3wObNLc3RH8xCCNATeBeltaBRhR6tzO/5CElnolB2ppr5EthlelI7ccpzlOaEDZLH1V0EjD02n/J7w9QJCqNw6rMGn4b7ArMxdptDAdOECz98ksx0Iysob+NNzIDNr9FxuJ7ZfTX1gj8NFriZPnP+7pr0ZKC3OV9U8bZlqfYsDI71QkHOMy1qpzz8T20amBWL1g4wBbu3YbTnpYmzOkDLJ5afVR2z/icx8DpYsphgmylQDxvS8MSr0wmFZXw3aniPbkqSzT5Fm03IBLzbDanE0NYdN5n6GcoeEcJ9YdmYpviRtCRhIZ1RWHNtyQyoaJa53Yp/43tOlW+LSV0Ea37SkwOvEHbhu04GIogDm3zse2vWNPdPvULpJwFLXwnN5z1caZUd5TLwksA+7temyziJ7Y7TwoLe3TaEgFaPQvSZxmi/YC9tPU2WIySapUEi7KV3LigwJXVE6l1NUUQv2Y3Y3oWXRXLFU3zAF6cKRwn/0OxQQkAcGwBzxu4h7badXet/s0ka4ta/RC0adkjmpUoH1GQf4Qm8/tyyRXeqEQp3D+cccQtr1IShww0KsTjrGm1N1XdfeWBy3Thf1vRIRrjUEZtSNKVQcg4+mRM2hpeDTRzxDcuTIIqhcdqN6PQAVJW5MxCxRMXbtuKm12g0ULkJ6+pM/HgcFRRMDd+OlnsM21SNUGQbW1suSqs/S2gnCCvlnt+Nz4gqOJ6uZlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ben,

Thank you very much for taking a look.

On 11/23/26 6:14 AM, Ben Horgan wrote:
> On 20/11/2026 18:39, Reinette Chatre wrote:
>>
>> - A static inline in include/linux/arm_mpam.h, beside the
>>   resctrl_arch_*() inlines already there. asm/mpam.h includes
>>   linux/arm_mpam.h, so the reverse include would be circular and
> 
> Hmm, the existing include of linux/arm_mpam.h appears to be unnecessary.

ah, I see. I can include a preparatory patch that removes it.

> As such, that include can be removed and resctrl_arch_copy_closid_rmid()
> could be a static inline in include/linux/arm_mpam.h.

As a follow up, do you prefer include/linux/arm_mpam.h to contain the
full implementation like below, which is the first access of mpam_partid_pmg
outside arch/arm64/include/asm/mpam.h:

static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
						 struct task_struct *src)
{
	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
}

or, do you prefer to contain all users of mpam_partid_pmg in
arch/arm64/include/asm/mpam.h and thus instead implement solution as:

arch/arm64/include/asm/mpam.h:
static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
					     struct task_struct *src)
{
	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
}

include/linux/arm_mpam.h:
static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
						 struct task_struct *src)
{
	mpam_copy_task_partid_pmg(dst, src);
}

Reinette

