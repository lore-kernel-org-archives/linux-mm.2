Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD7F606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=nkWyPFMJ
Received: by kanga.kvack.org (Postfix)
	id 3FF566B06A7; Tue, 24 Nov 2026 07:45:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0956B06A9; Tue, 24 Nov 2026 07:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278546B06AA; Tue, 24 Nov 2026 07:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F261A6B06A7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:45:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79D5A1A0B36
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:45:28 +0000 (UTC)
X-FDA: 85469983536.19.24F2F9D
Received: from iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com [13.216.7.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0AA9740007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:45:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nkWyPFMJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795524325;
	b=L7myrPrO+RmxV4cdjasr4BzioWOIlaewy1OIx5+2g31+EtwVYxeSaf7v7eXYHTYacwYY0+
	V09YzWmk+xwVumSk9BH++UX2Fu2Xn9G5NvmqER2vMxtxmAzMf4C4kZB1zNTgMBEN1BlDBv
	4Wsx7kiro/2Qh8RTK150v/PQE8gr+JI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795524325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLftVIj7c4fRDmtY9AJB8KjcShx9YvPH3O6gtpsCTtY=;
	b=tbGJXFNSpPz8Nt51dQEs58ZpTcQNC8Wqubvb4YLZG9n5B392ehQD3l8zzC4GB/4ugLccCq
	O7lPUmmBRiFBYaBg1iU/LD8b5VNg6/dVoLsaU7hT9+7ilBNsdQqU+kXTH0aLWRurm1fDx/
	xEVeCoIsOQoq4Wx2Z90SpnL++Ug99Vs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nkWyPFMJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of "prvs=7818f1f3e=farbere@amazon.com" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=7818f1f3e=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1795524325; x=1827060325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sLftVIj7c4fRDmtY9AJB8KjcShx9YvPH3O6gtpsCTtY=;
  b=nkWyPFMJJJLyHGpWCh2DWHfVqrbyl0m33sJHJRS8tzzbTVSJFc+IBbat
   /LnhvbAM+rNywLsNQQByfI6JIQG55ZxF0X2n1bk+T4aW0Ex0gcpOFc71N
   Zq/fp3hWZj5PoB+5WuGAnmHFs0qiXq3bDXD5okpVPVQUbS0/mqu/AN6w5
   2NEgXvMK7JiX8VHQ8NKaQIenx/1tTfAJyTtOOTd9eWKcG6HY9w3kmR0M/
   dbY9v/rNtXib+QMpUBxN4mu0VjjrI4VL/NCa2/r8q2jsg3MbQaswphKzb
   GSI2nIhdfTf414k9SFH8d8auRU+EpOKkL6FI+M4XQ68wWB3eSVb4HyP9N
   A==;
X-CSE-ConnectionGUID: Wq7sA3b8SlO7hcytAsg6gQ==
X-CSE-MsgGUID: 3EabCbZwQmSGsByn5F5ycg==
X-IronPort-AV: E=Sophos;i="6.27,230,1787011200"; 
   d="scan'208";a="32668337"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 12:45:21 +0000
Received: from EX19MTAUEB001.ant.amazon.com [52.94.133.139:20392]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.93.217:2525] with esmtp (Farcaster)
 id e5fb3264-beae-478c-adf3-2433221893f9; Tue, 24 Nov 2026 12:45:21 +0000 (UTC)
X-Farcaster-Flow-ID: e5fb3264-beae-478c-adf3-2433221893f9
Received: from EX19EXOUEA001.ant.amazon.com (10.252.134.47) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Tue, 24 Nov 2026 12:45:21 +0000
Received: from DS2PR08CU001.outbound.protection.outlook.com (10.252.134.239)
 by EX19EXOUEA001.ant.amazon.com (10.252.134.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57
 via Frontend Transport; Tue, 24 Nov 2026 12:45:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pBLR1xiIfwaoKXcbnNnufnhg3l9TZr2da9qk+Zzosqjl5gVP0ycpLbAyNtDYPZi5lnwEmtiwDDsCwtbmXUwajzJzYh78NEGp32qVEZdOs9nMTkqsQykESz/Noa1RJZWXN0JHZI4LSN5io1Sz874t9BUYitjRolziq9ZsRSGhNXDv7Zn2HDSayDIzZabaJqBlUMrfUwyTtuongxfjLxxqBiyp//yG0ZCP6pL6ucNHXeFl8cuBnRkL0O7h54CYXDRogSsuAc8t0wvoINBkZYmr3KR0f/dGWVRskYVKoyH0Xbzley/u8n2anvX8O+WLm5CyCtOnZMXW6+dYfdS/1QLDqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sLftVIj7c4fRDmtY9AJB8KjcShx9YvPH3O6gtpsCTtY=;
 b=j7Vrs7WTH1AlRrHYo2T05v2d0XvFpp1z+II4G1Bqy1Qkq6vhxmdMO1H6AYM5w3h6bDMd9GT+mWBqPAIKQJKXIsWPVG5QXZT02V25hblfLLPWbGFB8pgBOEd1txOcgcwPGmQ+Ld1yEHFyea681awg5T6S1U64s74USn8vDH12vC4qKdNrFK8i+s58kaYiRyNffjO6XBg95YSQQ+oNxGfG/a1ouQqrHqdO9WrjAp2MKuP8UFNz1deO8lWMAeb3CR6iaK04jThFqqfk7nM5o+UnZj64FVCPSVdtWDLKl443FBES2u3vseQVaamaVYO1z+B/1VM8gaAQLSc8xw3JvQRMeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by DM6PR18MB3475.namprd18.prod.outlook.com (2603:10b6:5:2a3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 12:45:17 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 12:45:17 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
Thread-Topic: [PATCH 2/4] mm: add vmf_insert_pfn_order() and
 vmf_pfn_order_ok() helpers
Thread-Index: AQHdfBGo463+LgvkqkqpefUNLa4oIw==
Date: Tue, 24 Nov 2026 12:45:17 +0000
Message-ID: <BY3PR18MB4722314909E880B1D77EED62C6442@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
 <a242ede8-71c2-4f75-b5e5-dcfa98ab25d3@kernel.org>
 <BY3PR18MB47227EB15146F8F16E1C005BC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
 <29bf5516-36bf-490e-ac35-d89893fa61b3@kernel.org>
 <BY3PR18MB4722713137ADE7A59A1EB81BC67D2@BY3PR18MB4722.namprd18.prod.outlook.com>
 <042795ab-e8af-443f-b34c-72c674c0ea32@kernel.org>
In-Reply-To: <042795ab-e8af-443f-b34c-72c674c0ea32@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|DM6PR18MB3475:EE_
x-ms-office365-filtering-correlation-id: 51e24b66-4232-4d09-d176-08df4a28caf2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|38070700021|10067099003|4143699003|11063799006|261022105027099003|261026121527099003|261028144727099003|261026140227099003|261021121427099003|261102123227099003|56012099006|18002099003|22082099003;
x-microsoft-antispam-message-info: s28rmgflkj61VnlJvB4/cHWbpVM4DTZZrbFEBjJ9PokJ75LfYWO+3sJ9ajRbfcpObd22cLoDyNCp0CZTwvbfKBqxgEH+KeiJL32esnTM6pNoqyaX835/FJw4SoOuu2BUwlPljdxYNvApsIAbNfE3jItQiLTinyvPIg5Ii/FEkUBlRVw8mB6TAdHYCRoJV9MD/biOzke3AWMKJeidvR1RnWlitt2rwCK0PAkxLdcMirhtvTq1wjRoSrLJ7FfQjA5pmeQ2ykE0p05KzPSXhklxNuBCNirULKuKu25j7fdtd/EU8kD/SKs/PF2yjE83is4bTuCqE6HbTtJsYKl5wRXvP8ZBCdVBncaKZ49ULZD4kgVULXVZAzrvAwia29oH4a8erYVRh1SRLvWURjL0CrMYiefQRuKfIQN0oLJ/L7UP9vLG7ktEsTBqzFsKbJHKcfMPS8FysLJrOwjudROjydJqhWuhRo0Gx/zil8udDGZazNHGL6fnNN87HVk3+OXOaku7B0q+UDjYG35mpbpR1STrv6QuTctnUrDfPCGlGd6V3eudKdJ16bW1Da7JE1WGwR6iFFtdYP/i5ElNltdwr5K326eJkuXnOb824SZLwRm3dC//gOzA8WanIeUBooj4e3dGKUAFz8S+wERnhVMSp/loBeQpu0GWugiawLW2kZrUwZAZSj/sMmkOA7C8bfuCYyrXLqHuvGuZsVZW1OYVVXfAqLEkdIeM2A3uMh4+3EJG5cI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(38070700021)(10067099003)(4143699003)(11063799006)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021121427099003)(261102123227099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1NyblljOHc1OGl2UWxBUE9EeWF2dU5zWElYQUdOdHE5d2xkVkJMcDdPbWdG?=
 =?utf-8?B?VXRaeFk2cFlzOUpZWEo0TTkzY2owZ1BVZlcrTEZUVmVuSWpsTlY2T1hKUVhC?=
 =?utf-8?B?NHhXeWhPN2EyRE1hSkhNNHJlb1M3SmlRd1diYWVJeW9FZUM5OFRLZGwwWU42?=
 =?utf-8?B?eldSMytxNnV3WVNGNEdrbUVtcmF4SjNzeTNXb1dkVGU5bTN3UGxJRm1QOXdj?=
 =?utf-8?B?dVBQOXFMNU1MWndsOTliVXVlempuNGV2YVlJWEJqMHV4L0p2ZG8ycDI2Tlph?=
 =?utf-8?B?RGpNNFJtalpqV0duSWN1cTZaSHlBQzMrTmtLQjVkcnh6dXBjUWFkRWtRSXR6?=
 =?utf-8?B?cmJ5ZmtPYm8xRzVyTGE4YytTVXFRK0MrOHdtM2lFQ3V2SHdIYTJwcUZuRU9r?=
 =?utf-8?B?NnVrbU1lcXNINlp5cURLdG56d0YzWVRLSi83NWdhaUZzMkwrYnhQQUtENW44?=
 =?utf-8?B?Z1NWZVZrcHVBeCtFcUlxVWZJS0JZSFVvejMxb1BTR09hRFBYUVZ3bmx1VFU2?=
 =?utf-8?B?bTUyQ0Q5dkpnVWpGMnFFcnpvVElGR2VPQWF0N3MxTTgrR0VNTmVtZFBUNjdh?=
 =?utf-8?B?WVRTMEJYYnRQKzNZdGdFVVpuNmpYa24yT1hJM3EwUmtVZjNSWk5peEp0ZjNU?=
 =?utf-8?B?Yit3TG9PS3ZzaytVQlRRRWlZZjdOSkRDdG9QNUoyWldNSWhJdkhWT0JPU1E3?=
 =?utf-8?B?djNON1NiY29Mb08wRTBvSUtLK0hhelNvSjk0K3Fwb2t2b1ZYWExwUFdvUS9V?=
 =?utf-8?B?OVZab1EwZFlic0xRWWJBMzdZVUYzeWJMUHJVSEJNRHpEME5INzM1U3lrMUl4?=
 =?utf-8?B?UEp0dzF3S1Vhd1lUMUZDTVk1WHo5bmwyUG1uOWpyQnUrMWxZVUg1WlB4MFQ0?=
 =?utf-8?B?V0REcXQvaWNmL0RPZmFuNmF1ZVpyNXRiZ0hNWFlUdGNzd1lIYzg2MUFOaGQx?=
 =?utf-8?B?WC85UzhuZnJ6RFFXcEljWjRPdzlWaUVEVHcraGdCOEl6NElocmJQMnBIS0dJ?=
 =?utf-8?B?SmtYYWQvSTlvaHZIOW9FM25JQnkySVFCTHd6bno5UlRzbUVrUnlyeE13UXd3?=
 =?utf-8?B?emd5enRhZmpGY3FLMUZOSFlOL2gxRnh6V2kvOGxvUmlMRHZjbXVTK3lhWXcv?=
 =?utf-8?B?U1lkNjlhN1lqY0dWUHBCNnN4Z1U3NHhNMFJoejh4aG9kU1ZCRFFSWFNjTVJL?=
 =?utf-8?B?U09BbW5lbGVoV0JNNS9BczlQZnpiZ28zUzN3aWExTkFTbGdtUWhicFJBZVZH?=
 =?utf-8?B?MU1KNitEcmZtYlRheTFVY1YrVXdyamNPczRKUkVmb3B6U3F2MzlIQXMxejYr?=
 =?utf-8?B?dHA4RytOaEt6YUVRODVna1ZreGQ5NkxZeDU0NDNkQk1WbVV5RjkwMFhOTGtQ?=
 =?utf-8?B?QXh3eVh5VTZhTkluWDRPL0lLRWhBc3JVRkh0aC9HaDZQQXVwS3dwRkUvOWkr?=
 =?utf-8?B?SDd6NG1SeE9XSVhnRy9mamhCL1BqRVBiQXN5N1duR0NwbFEvVzNWTWZVSm9j?=
 =?utf-8?B?WUQ2b08rMEhKOUtnSlJVenFQQUFpUHBjTE51amZIYzF1TEhtSWVxRFphNzRl?=
 =?utf-8?B?eitpTzVyVjJUbHRxNHY2UCthaExoanZJNGtPb2c1L3h0Rm8ySTNmR2RXVng1?=
 =?utf-8?B?ZjB0WEdYTjEvOWhKY2FTeERkZTA2VlFWTlVRQ2U1VEFkVUJrSWt0UWdNYzdU?=
 =?utf-8?B?bTRFWlhUNVlyNHQwb2FtUXdRNzExNk5JRmZLV3REUWJndE1haWQ1TXhuTVB2?=
 =?utf-8?B?NzA4R2ZURk1reGdHU0FRd0lXTXB6M3pxQm5YWjZTenkzd2JVbG5leFpRZGNB?=
 =?utf-8?B?UkVtOW5sdkNhYTFjMHhwZlo0ZG5NVTYwb0V3MFQ2Y2grQ3NjNk5tUW5IWXJO?=
 =?utf-8?B?SlgzTzZlWXdoUUd4a0lId1FGbW0vY0NxdHpUK1FXT3BZVjRSVWQ0NmJwbGZR?=
 =?utf-8?B?Q3ZZeTJRUnBjWjYzUjlmdVRQUGJ1Mm5qVXVGRVh0KzFGbXhkd1VYZkhrM1lu?=
 =?utf-8?B?NGw0UGpBaWQrRHlRditUcmNsSXJOdmMrTTFlZ094cWRMOWQ4ZENPdis4SVhW?=
 =?utf-8?B?WnorVC9uUGU2cjc2cFRnV1pxelZIbUNzaFZlbDFpVHJ0aGpJM3d3aVJQZk10?=
 =?utf-8?B?d283dDVjSU5yeGhxZ3YwMU14V2hwRHA5MzlQSmJXL3htVi9FREx4dWxadjkv?=
 =?utf-8?B?TzN6V1hKY093dzhneVhCNmw0bTgya0ljeEorSVVwYUVIZU1FQ0xQc1Z1Wk51?=
 =?utf-8?B?TGc3cmQ0V2pLRXJwa1FBaDNaUUNUWlcrWEJ2YXBjK1R1NDZ3M0pGQUJoNHdT?=
 =?utf-8?Q?mgm09p3Ly8QHF9gAKj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: VomdJJ8d96v+E3Rm2/TmdHtxrIEIcMI9sIyCJw8zUJ6nYG7uHxSJamKCDVJ5z6i3Y5Xj2XqLUP5QxiurTCXNi/M3x/64H+4aiPY46Ie8SLgXepe+z1ghJYGoKvQSdXWu3cZjbmZLRU6l3ULUFiisg9CyAIZXpKACZT9zPbHDE7/NVeOJYsC7BNVKLWA70cHRzquBjrSJ9OHH+0gw1JYpTOTouxPK6frVwhIBEzd9znskGg2IfuJyhNlqRWx9q+NMg58rKgB3RBhwKi9CHoPIRanz74ObYFnszl5NhiNF7tKcdnpFyaiho0ZKZqNGiZxOQOUwR7O5UjWwZ6X9ZW4O/Q==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e24b66-4232-4d09-d176-08df4a28caf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2026 12:45:17.3376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1t+xM7bTFsGwQZYx7E5hovEvmzM0L8raeRL8+WyXcEhlxF8DdM++rNbDAGXb3jCobybrCyO6ZcUo3xOIMywkbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3475
X-OriginatorOrg: amazon.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AA9740007
X-Stat-Signature: sshcrwzz3oydwdk91kis74g6r64wmwhp
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795524324-365246
X-HE-Meta: U2FsdGVkX18Bs42P5FEMsqdInS/WC7nmNq1ROKOZFSe6cLZItcYu40hifQESX/GdE+Lp5plRV00ZogIDIbI6j+N+yyakSePRGivSXXs68QL4xYVzOJ+KBNGTty5FDAenTXAbVUWezU0wsQ9HrIqfvMxEK2/ufL5ftiUAT+wR6p4jvSieFZWGgGBWI/SvGw/Sjrj8GXawHUsEHa33ldOfSzRofe17K12hTvfETsCVwyiO0quXwmLOcs4jc83GRhcMYhnBQeq8uwvi+gyXmjliXJvIUQPzO0DscDfnmzvqPk9+pNIZSGat5hNpXYhtNEC45MpGMInkI+t3pbERQAJbybwNDQF6fBYWZGc9wGkfchQ8RQYRWmpeUUGvjliyR/EDd7bmxOKXTaMwXlvKSIvLLBhikG43iEmfemOAop9EAdziKVLFDM7ASGZZyFJjYUqG4o1KoIc3RUVY4Qz66fYSfcQp7e/lHEANTY7HBpJcyT9wocavbgfqsmpd88X4zSwJ8JcejK7tEMNl7w5uHtTrv1SS5OrbmB4g11xi1kgvEZ85e4xzXLejrDA5tNtgTTTbQTQRrDNhtwSG/YYlsjMGTBHJlLyHYV80QiLfT+JnfCHOPTlQ+RTHufVvcb4/pFuyC/RFPYh3W4E2FAt0SlB+VOBBz8y9KvSUAYizS5iz/dzDiMh95qAQ2YNVPTyHQjChXiSfhgQWKKGsLEzew7NZprqo/BiKlH6x5xsP6gPUv7Cp1JiBxKmVIFLhwVX/qVXSgYHsAeEynPJwfS3PcCWce6k2m1+sJwRTW8dxHiODGNhmbjHpoLMuU9pildlnbqTildb2nO5yqJ3In636HxlXKLG0O3qiyKOMKI4uO0w62mxdqSglWjhUiVO2wYKIW9ZWwQs4L48r5TMPZiRH12ZsZTA3StpINJTDYpfve5iZTXYL8VHY+aNAkILuuSji7FJSJqDO8BwrEmhFhlVEy4p
 0234N5nx
 fN/XmPXRaPSUenoW7MJ2uySriUPr9aHtlgQVe+ZvzvTrpSDG9HAwPk621kN03y7wZRm8wwwbKw5dwl3OQJmP2gGHGSLMFmrOPRV67/I9nWBNShEInToUPF+O9CPXYj+CVo5IUcCOMY8CotcNFcOwe7ezV5PLi+97zA/ycoUriJNuvk3UvQ50CusVyDqvbubgNSoARYp1Ma2m8IMBFWaKwv2M0FOlrYqjnTRqtJKZ/HlyXk6uGIIVDOnEyFryD4SvIXBsXTI3ZTKO3HaTMmMOAdhaakB8q9Z21hIbPQ/z5K9faOIDvs0I4SWGHtBsd8upURhhipi28m/MJYlhEd5QOxthTiFybDU/9eR2W5m5uDFrAp8HNHNxZ7EO6RB9WVECw5W+oGZ5/+g/4fBletvvSyOzAYs465m17SNJDds3Mq2AKjhv3N974bl5Za7JYZxW6Md08qAb4VQvrKTg4XH9Flg0n6LiZBOLJK80AwuffvjlLkyqXj4ELjkYqVri4WturaU0eAdKtRHKL0giwu6xTtHW4bckn3h8mRgoYWlpbdM5PLLWeKbcsyS2Sm4GZgGNv5Jdo1dWLQFy9KBMRQab8xH7IUjCvbKlAiAEvQCOj5Ld5QD46I/MkZjmC2i+FFw5QjgsldLx1NOYYN5c0CPniNasiSRT2LHUmYDYYun1KJ9sSbkdFrer3H8wlRoFf71C1PupcO1iXWV8qKJyomyGlCJBtxv7b+60pdLJvefwi6gt80lEIn4FCkTTP3EM5On0Hy8SWqBIt3YaE480j4ORbNDrUg898tQGW4pRR4brlqLPPBqNLiIDy5F6MS5qryREVyNL71NYzAUfPXyVTPD6spaCVzaTk7SNQW9HBDTjotYL2LeIkfICndfWz0HY2+WePie/e4kTxzGZ7GbfVRGLpbeF167KxsgdMmTYw+lhutxDRj5hX+r7LpcAXJTx8Q5A9H5Ec5nvKc0Svl5hl5L/MGvp2swh0
 DeqNiBj2
 KrssK9Powcgo/vaPi6dYTguMr9eNtQ029ZmrPzbgnWuubP8jpQ1tA44p4NkFnnl8R7mJ6vJQSEjYU2g5Do4Mww0pbNobuG/cVO/j7f6Arpuea/i8Xx4SQiDRCTEpD8Cg9S12OZs89+ZjHmp3cxzaZOvtCNonzxYlqi5l24t5k6+CrfSdBfaodsuo8LymxEc+WB48vX1OrMP4WPqQ9y4YIgLeHnsbvagaXKmznXXSrDAZT1+u/ipSdzwT/RFo7ZgJbfsDM64nU+lXK82Jxf0dIbS76mEHDLPK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gMTEvMTUvMjYgMTc6NTQsIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0KPiBQbGVh
c2UgcmV3cml0ZSB5b3VyIGFuc3dlciBpbiBhIHdheSB0aGF0IGRvZXNuJ3QgbWFrZSBtZSBoYXRl
IGtlcm5lbA0KPiBkZXZlbG9wbWVudC4NCg0KU29ycnksIEkgc2hvdWxkIGhhdmUgd3JpdHRlbiBp
dCBteXNlbGYuDQoNCj4gQnV0IGxvb2tpbmcgYWdhaW4sIHRoaXMgYWxsIGxvb2tzIGxpa2Ugc2Fu
aXR5IGNoZWNrcyB3aGVyZSB0aGUgdXNlciBpcyBqdXN0DQo+IGRvaW5nIHNvbWV0aGluZyBzdHVw
aWQ/DQo+DQo+IFdoeSBpcyB0aGF0IHJlcXVpcmVkIGF0IGFsbD8gSSdkIGdldCByaWQgb2YgdGhp
cyBlbnRpcmVseS4NCg0KWW91IHdlcmUgcmlnaHQsIHRoZSBoZWxwZXIgaXMgZ29uZS4NCg0KVGhl
IGNoZWNrcyBhcmUgbm90IGEgYnVnLiBUaGV5IGFyZSBpbmNvbXBsZXRlLiBpbnNlcnRfcG1kKCkg
YW5kDQppbnNlcnRfcHVkKCkgdGVzdCB0aGUgc3RhcnQgb2YgdGhlIHdpbmRvdyBidXQgbm90IGl0
cyBlbmQuIEkgZXh0ZW5kZWQNCnRoYXQgdG8gYm90aCBlbmRzLCBhbmQgbWFkZSBpdCBmYWxsIGJh
Y2sgaW5zdGVhZCBvZiBTSUdCVVMuIEEgVk1BIHRoYXQNCmRvZXMgbm90IHNwYW4gYSB3aG9sZSBQ
TUQgaXMgb3JkaW5hcnkuIFRoZSBwZm4gaXMgbm90IGNoZWNrZWQgYXQgYWxsLCBzbw0KSSBhZGRl
ZCB0aGF0IHRvIHZtZl9pbnNlcnRfcGZuX3BtZCgpIGFuZCB2bWZfaW5zZXJ0X3Bmbl9wdWQoKS4N
Cg0KTm8gY2FsbGVyIGNhbiByZWFjaCBlaXRoZXIgY2FzZSB0b2RheSwgYmVjYXVzZSBlYWNoIG9u
ZSBjaGVja3MgdGhlDQpnZW9tZXRyeSBmaXJzdC4gVGhlIGNhbGxlcnMgb2Ygdm1mX2luc2VydF9w
Zm5fb3JkZXIoKSB3aWxsIG5vdC4NCg0KPiBBbmQgbWF5YmUgcmVqZWN0aW5nIElTX0FMSUdORUQo
cGZuLCAxVUwgPDwgb3JkZXIpIHdpdGggV0FSTl9PTkNFKCkgYXMgdGhpcw0KPiBzb3VuZHMgbGlr
ZSB0aGUgdXNlciBpcyBkb2luZyBzb21ldGhpbmcgc3R1cGlkPw0KDQpObyBXQVJOLiBBbiB1bmFs
aWduZWQgcGZuIGNvbWVzIGZyb20gYW4gb3JkaW5hcnkgbW1hcCgpLCBub3QgZnJvbSBhIGJ1Zy4N
CkZvciAvZGV2L21lbSwgdm1fcGdvZmYgaXMgdGhlIGJhc2UgcGZuLiBBbiBtbWFwKCkgYXQgb2Zm
c2V0IDB4MTAwMCBnaXZlcw0KcGZuIDEsIHdoaWNoIG5vIFBNRCBlbnRyeSBjYW4gbWFwLiBGYWxs
aW5nIGJhY2sgdG8gUFRFIG9yZGVyIGlzIGNvcnJlY3QsDQphbmQgYSBXQVJOIHdvdWxkIGZpcmUg
b24gdGhhdCBtbWFwKCkuDQoNCkRyb3BwaW5nIHRoZSBjaGVjayBpcyBub3Qgc2FmZSBlaXRoZXIu
IHg4NiBwZm5fcG1kKCkgbWFza3MgdGhlIHBmbiB3aXRoDQpQSFlTSUNBTF9QTURfUEFHRV9NQVNL
LiBBbiB1bmFsaWduZWQgcGZuIGlzIHJvdW5kZWQgZG93biwgYW5kIHRoZSBtYXBwaW5nDQpwb2lu
dHMgYXQgdGhlIHdyb25nIG1lbW9yeS4NCg0KVGhpcyBpcyBpbiB2Mywgd2hpY2ggSSB3aWxsIHBv
c3Qgc29vbi4NCg0KVGhhbmtzLA0KRWxpYXYNCg==

