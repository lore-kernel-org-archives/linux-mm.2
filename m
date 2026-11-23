Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44AA606A680
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s3wP9tfT
Received: by kanga.kvack.org (Postfix)
	id 9385A6B05B2; Mon, 23 Nov 2026 14:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8186B05B3; Mon, 23 Nov 2026 14:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0266B05B4; Mon, 23 Nov 2026 14:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44DC26B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:53:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDBED1A0993
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:53:31 +0000 (UTC)
X-FDA: 85467433422.16.E080A90
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	by imf11.hostedemail.com (Postfix) with ESMTP id 736AC4000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:53:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=s3wP9tfT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795463609;
	b=4oNx+fsBr/id75lUTiwrAEPjo86ly7T+86wHgayeVfyhYTRyFfICwzZp1vWNVEOyw5XWXo
	jzZ0azrqgPaYLW41qOVCwNRGa6fq6S6sAyaHaDRSwBCvSD7hON6bhnUmslKdv2Es9ZZ/95
	drdIi33ejQipUlPUkWO+TnM8s8qIxX0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eafpaXZOlM+WAFUdROfBe23EdE4ybfiTgf1A3lleGbI=;
	b=Pc10K6ogvu0RLpQg1MsQpiRoQyQoG0niyZWM+YRFTDQcVEIBXMu2cdQfbhTucUNUEqmAD8
	WWBe7zdaF+nz8aTO7ojt/He7o7k3yriEiSxCc2Hz3B/H63hgU1px+puq3xXqBh4iah6T3x
	opqi91Ff0WU+aW2ra1OyKLiaIi4UhTY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=s3wP9tfT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o/Xsb/Fn9Sft3MjG8tGbx+BRpKezCXDuB6IbByG3lYnnPJXb5Xg6YPAOXdBWyQ0O2qAmodm5Ot/lduBW4YO5Q8vNeYg127ppAaWAQu/4lfNJcULkbPADg2BRTb1v+y3OsL2egIqJp+/hOJnbClLM0/Vl68R5Hd2/3f02vNtJaGipt+AHhn+ANuAFn0rjFVwpCgdR67vSTVEyG3Vd7wPgv+YzpKUJJLZmf9PwwtEg0SJCSrEorcTdI7tIbSRCXH9eGptqkzAoWF3y6w64Y+TTMSLCGG6Nn8z8bAQZ5MraSc30zNKGqt09YV5b7bW94gRdM2nIsow+vpmyMB+N/BYHAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eafpaXZOlM+WAFUdROfBe23EdE4ybfiTgf1A3lleGbI=;
 b=DPxeFgz3h5ecpl40A7LVD4pLaZxohPYeRvQxLDtDJRrfJPeYOakOx5EgI4x/8Mbdafc/bd/eLISRlQtdH8BNAwb/CrT/PO3YHQhJa8VgSdfrFP4mbBxjWr+JludWGKd7vKMDawfLXEJDqWzMT0HmeewXgoW4dk5Z6EGGydM0mnFfF3APTI/0JaO/3WLMvRd2Ybn8MvuEuCZo1ulfdzqzcFuFdsQKr+D/yZ452NbvrT40doWGtrm/1ydgQS+qAgojn0/Ao8K8U9JtQaxAdryvPFsTS6dVGs8aNF+whMhr1NV8dkBdrAV1J8t4nNTJOtM0UJflfIPLIdPA+oUxhbQ7Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eafpaXZOlM+WAFUdROfBe23EdE4ybfiTgf1A3lleGbI=;
 b=s3wP9tfTpxisLqIaI+nEo8f7wtGfurSadIrIb0lNRVKeZATLUM1JEGt/Wnb7jPS4JlN4BDXlUwS0uX5Q90L51htsyn6jpERL23oKJbL4+84j8N0H+M1oqxifyltXJScUTDK4csK49gSK1/lt1nYoJfD+iNxcjV+JCMAJIe869PmonPuaY1WQ3apIStSE4YvCI8ERygJl8cIdYfwI0zG/Y7dLpkxSgFfNLK8ZRQo8u+qRw+f3KxbCoECFfR7rTHvM+kBCJqzWuWJ9o2cyrbPoPM9dmpErSDuvwgMBBUZVGIwR6uhUMxxg9oFEIjNPhqyGfvmMD35Ie9B1Mh6lpOXFJw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 23 Nov
 2026 19:52:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 19:52:57 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 14:52:55 -0500
Message-Id: <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Muchun Song" <muchun.song@linux.dev>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache"
 <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Nhat Pham" <nphamcs@gmail.com>,
 "Youngjun Park" <youngjun.park@lge.com>, "Gregory Price"
 <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang"
 <lance.yang@linux.dev>, "Hugh Dickins" <hughd@google.com>, "SJ Park"
 <sj@kernel.org>, "David Rientjes" <rientjes@google.com>, "Yu Zhao"
 <yuzhao@google.com>, "Vernon Yang" <vernon2gm@gmail.com>, "Zicheng Wang"
 <wangzicheng@honor.com>, "Tal Zussman" <tz2294@columbia.edu>, "Kairui Song"
 <ryncsn@gmail.com>, "Xiang Liu" <liuxiang.277@bytedance.com>, "Ehab
 Ababneh" <ehab.ababneh@intel.com>, "Zhao Zhenzhuo"
 <zhaozhengzhuo@uniontech.com>, "Lian Wang" <lianux.mm@gmail.com>, "Joanne
 Koong" <joannelkoong@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>, "Hui
 Zhu" <hui.zhu@linux.dev>, "Maxim Muzafarov" <maxmuzaf@gmail.com>,
 <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
 <damon@lists.linux.dev>, <linux-doc@vger.kernel.org>, "Tianyi Chen"
 <hi@tychen.cc>, "Ridong Chen" <ridong.chen@linux.dev>
X-Mailer: aerc 0.22.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
X-ClientProxiedBy: BL1PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef7a86c-72b0-4024-0af3-08df499b5f2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|18002099003|6133799003|261009223027099003|22082099003|4143699003|56012099006|11063799006|261102123227099003|261028144727099003|261021123027099003|261022105027099003|261021121427099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	gT30D4ntIw6TkIsYZGSxITi8fhXPY3TodR2n0XGpZ03B+WJteqW1Iv6Id+PtMbY6bHLDFkL4+H0jd7yWaXeA1La5Run203yJ5NuQ/GXuwOJmrPHEQrrLWJM4Cjoi6rCZgIMsNAYKNQMeHvEsiavFmBQIVkjxQzYCr4dAAcBFDets0bfIChi3zzI/xPqNiwD/z4tXXSrohay2PR6YzcQilJJwF9Fi+s+yHtG+uJksv7l4HefIKSbGMbN1unKJ0nKByYXIRV8FrznHly06GgZnE+JLg08eYQjVP0G/evC7c96XuTcbtyxBLwmxPPbMdkrwy8Dgcofde/Bm7Vr0t8/ckZo745SqqSUbWP1kUEOplh9S0TkzkRn+cjqwBUMaZ0T+yOxYFeeNMFrRSkORU7NkcCHzoNRpiTD/i7gHsPtp/3o9YmRMqjgco2JJdDFLBekeysc7wlxCTAUXk2RuxGTQ5rDBOEHPJmTabTWQ+mtgrJ4XlW40SJua+Yfb7GlaeYURwmxUtBeHoRmrZfJ93j+BZBEZTwHXQa1BUnHSGQ+CF+PAnPHLzpL7vLg7Uv3jJr1E43JklCEsZdXrGjxSVsQxo9vKDcKUY7AZyBvIUdZQeqam0IAISGNv+ZBIsFtWft55VByrEl0kvabPl/kMMV3gtxEo+vhVvY0fJT0e9nlk2h0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(18002099003)(6133799003)(261009223027099003)(22082099003)(4143699003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261021123027099003)(261022105027099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW55RVU2a2lzcnpHU0QyajlvN1dtOExYcE50ajZzd1VWTWd4SkVvTUU0eGls?=
 =?utf-8?B?MGtWYlVPZzU1TUs4R21FMlhHK3dDU1FISnEzZkdJV1RUM2trVzV2MkFlMXRo?=
 =?utf-8?B?aWcvOElYU1NaVVFjQWFLMGxWWjluajlsWDZUTEcvdm02RVBCQzBQVGwvWStk?=
 =?utf-8?B?MGRuampiUTlSTlhZZzduMThkejQyNVllTlMzRmprcmp4UFA4elAwdExaU3ZQ?=
 =?utf-8?B?aU9JeUpwSklraWlDRkxyYmRuMjlKMTZRcXVCSzZqOVFoNm5PR05UR1dpSXla?=
 =?utf-8?B?UkV2SFU2ZkJOMERkbXpaTExYbEpjcUJPb0d0ZE9xRXNiQ0hNNE5LSkV5cFVq?=
 =?utf-8?B?czc5WkN1NEF2dEhVYmtlTzQwdnJPaUNla0QxMUgyQkxWNFJGemlxV0hGeUxm?=
 =?utf-8?B?WHhWUm1rM2h6anhkQVNLcSt0VW1IeTQyMmd5TnhPRFZsSUNBNkx1MjdFN1lI?=
 =?utf-8?B?VWdYN05kWldCb09NdEVYaTE4cW5LVDgwcEt1WTZrLzB0RVZIZU1sN0lXb1dp?=
 =?utf-8?B?dnFJZ2xHditqQ2NlTVJkelNhZnNBbWRQV21uT3dJdGRSRXlJZTd1UHdlVFY5?=
 =?utf-8?B?eEtkWUtmcHY2WUJtLzFHTFJmZ1BxVUZVTWZjcVZvS3VYenNZVU16NEJTVUhz?=
 =?utf-8?B?eWxUSTJHemhjSEVaMmZzZThaTmJ3eTl3OUtoTkVGOXZEa1FueTZidis5Rm15?=
 =?utf-8?B?MmszakdrK3BTM3VNUHg4b1gwbmhWd3VQak4rSHo2K2p3WlFrRjAwQ1NMME0x?=
 =?utf-8?B?b1Yva1lvZWtXNTFsbUhPRW9zZ0hCdmtKOW43bkVnRXZiV1FKM0cxVE9ZeUY5?=
 =?utf-8?B?S1ZQUTZvQXJKOGNGd0VRREp0SGZYSzZJMkNFcWhFQVdBSlMydS8xQy9SQ2I2?=
 =?utf-8?B?RUxnMzZhcmhRYW00SDkyN0JEMW4wTWlTbXpwOFNaRDdBUTM0dXBVTXdnTnpV?=
 =?utf-8?B?NW9kMXZiWkF1cmx6d1k3WkpQak5BSEtvUDZ4UVc4WDEzNHR5OWdndkRwWXFE?=
 =?utf-8?B?NFRoaVN4UHhkWDFaczV1ODhvWjNPbThLRjlYZkVaNUljS09jWUtwc1ZYTmZI?=
 =?utf-8?B?dVRQQ0M5eSsrYS9MdmxoQ3hpWDBVeHRNNWFhZkNlbDhEbVNHYkRyNHNESmx0?=
 =?utf-8?B?emduWEtmeUNsa2ludjIxeWJraHdRdStGZGsvWDk3aEpjSDRLTmNRWkEwd3BU?=
 =?utf-8?B?MGQySTdaZ1d4Tm5FTTd6MllCemFDSktLYkVvYjR3TTgyVlhOTzVCbkVaWCtu?=
 =?utf-8?B?OUZQUU9GRmkzS2lma1ZSNWE0cmxQMVIzeWloY0w5b3g1NGF5TVBxcmdJNGF1?=
 =?utf-8?B?dlNMbmlxdVpFOGJkSzBQSUt5NWZuck5xWlAzRHAxV3FRN1pSVTc1ZWU4Y3ZW?=
 =?utf-8?B?WkFzSDJmSVVjYTAzQ2RsWnRMS29tdTArZXplK29TZkMxb29xMm80RGtSb01q?=
 =?utf-8?B?WlZqOGdNNCtUWE8vVDNuWXlYSXpGNktvVGFVYkpTTzFLVmhUTVlSTllmTDdV?=
 =?utf-8?B?OU5udVhjYXppQ1k4c1BQdWtzYzdoY0dZSEY0dTZUZEtjd1FXZlMwMm9HU0U0?=
 =?utf-8?B?RW10aTAxcmlVMEtCSXN3eXB6a3dLZ1p6bnZpRkNsWVZZYXIrMENtN01kTGdj?=
 =?utf-8?B?SVdLamtpM3o5TGFUc1ViN2hLNU9TcDduc01GNU5qZVA5YUcwTmVLcFMrejVz?=
 =?utf-8?B?WmxEbUxjeENHa0VZaTlCR0tPMnVveDY2R25reDdHYTk3aWt0b1VMZVdTbFRp?=
 =?utf-8?B?cTJ4UFRESUh3YmJEcHlSVWJxemxNaVJqcGtmN0plS2Q4Q0gyWGkzdkFlT05v?=
 =?utf-8?B?TlhySjhuOFFRQUtid1ExUVArRE9zWW1tMnl3d1VUejZxaFBQK0hYeVlUbkR6?=
 =?utf-8?B?ZnBtTURHOXF6NWpIV2ZCSzhDc2phTFNiaGlTL0R4VGpYaytsTGtHUFdjSy84?=
 =?utf-8?B?QTA2NzByd1pSc1BTU0RQOXk5cENRS3hoRDlYSlNqN2prZUhVeWcrUzNQK0hh?=
 =?utf-8?B?b0pkKzdpZHFoWkRPa01NUW9TNGVrdUIwRVh6bU9Gek5SdjBlOHFqT2JIRGZF?=
 =?utf-8?B?R3lkNnJISGRGN1NGbUdicmpTSEZBMWdBT0RLdU1hZjRXeHdBRzFCbENSemUx?=
 =?utf-8?B?STc0enhsT285VWRjZ2JUaDF5YmJZWEdsT0dFUXVlWWJUYk5MV2c5NW5kQlFL?=
 =?utf-8?B?Y0NrMGVXVlFZaDZ1emg2QU5FRi9PWkt0c3JtU3VCdUZ5SEV4Y3pmZDlXcHdX?=
 =?utf-8?B?Unc3L1diT0d5U3FDUjNwSkU0OThzTzR1WVRoRlllNHduRWR0d2JLTmpjWDZi?=
 =?utf-8?Q?8DQDPAEPIVIeTGKSSM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef7a86c-72b0-4024-0af3-08df499b5f2d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 19:52:57.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usCjLyyWxoDeH+/ESjkPz5atv4veQKM74Qqutf7qM3l87POAqFixo2NpW9LJMu8f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 736AC4000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: eupcg9egs1zwyarh9e4gzgjh7oucu7dp
X-HE-Tag: 1795463608-682250
X-HE-Meta: U2FsdGVkX1+k1+kw0r8koG9RaAgTUa3DqgygmkFl9LIwj12RsOeDKb9JYWMDzR078qpSz4Yw5f83MN3ox6x+sLIKXHR+2ajQoUH4SKAebjtkToymAuCaxZPDGN27ajNm0smAxELGBKzpzDB/DZmp1AfnV5rYWyp82KQJd23VM1g/rc+afTWId2LaC0Vr/8852asmxI9+o1VHRnCgdCy+84SWy5KkqlcAIs7p0kAVHkinEDu4z4ASZ7mlNFXQzozTg3a1J5gxULJ9lC6zC1FOb5zAbT6WiNrfGMGenqcSa5gRwp5z/PIryVqkzqnHV9ImgfpqCYxXcaRyds6Wr3r5otM0/jZafZaQ/PEPMMvszi2cpYJyODqex0sR6bLNbMRYaQntdhv/diHLNNOyt3FEzD6Oud4ujpkAzc/9Ner8y59OJOtGpGx+jrPzX5Ghy5bOILLG+FKOve3+DfGCcNqvd4lM0r6QGzaezZMZ71Eeqzya07sJZYYgD1JVnpMjw90/v3H+nof7Pn+iZO1UApHb/BJ40SnsvYG3Vgg52vAQUcjedJ5xQpAq/5DsskMGAK1t4yyfEg4V1W0HVepe+ewVmUPqQ5X/SYp0PDb3AXo7miAP56ym69991pgEd0DIAVhCYHFpITV6CciyojuRXSS5qYE1vI/60sIBpx0YEtkPP37Jq1R/87eiIjOhxtJc0utnAAq/fqzg9jjW4Zy7KBi2HT6liNeFuXkT+jg6dJtQHi2hBQIPveV/7AMUJ7ys9bVaPBEEes90aCXKdU9+kbBdacIDY/sfSgLUZJylf2b9e7kayU17GMVm7LkJsEgGxtLALCkY2MVu0sG+OBcUqEFUL0ObvKVuomi2vSgw4M9aY7/qrOdB8w3e1p9tbldW9qz3lb/R3eYJ4JjkgNcyQ6X2dnvX/9yX+sNTTOInyOmvKDX9ScTsYdUQr0BgVX4DlWSWdUR0He7fFGTS1njdKI4
 ij6fLiaB
 b6knEcXOy6+O1D+bzzYq5GJhaRKZXxnOXWIN5C8vKH9yzw8Sg1z+ChhE1uaVRBReoa5kAIs/0qKKXlLnJSWXNJP5zgkGimjw0FHKZltZzHegDs6OmRzNoJCVSj4cUm69yiYLK3yMz5+rRj9W0kD5Y5ETx39/CFYetNfMQFg78k3EiNtBOPNNYw2Bd88PWvWIM+Wfe5aHKaC4K9JNoPzqBql8IPtWZw1gpCn2WP5vWLBx8e6l2Wr66jdxbcppjyQ8nBrA2DRcddcigU53cPe3DJxg9wwT83IXOhXMzB/vIIsqwET0JJMKHoApAHyKX5au5+Y/8KY8UKRXKMCAx355mVzGBf/HAFWCRjdttbfZY7aS6REkDPcxw6kNjqW2ufZfvP/FlCMM7vHC5hP9A7ST+B2rDZ0QALWmUyD4uYodvF1NXHPloiNwFcSEFhRH5vHT95gc2pmIyAKPRK0xnP/kI4AfcbAehX3Z5gMwYptjUs5i8COwbfdCRGFoa+eK0EEcGaQ4CiuFAqvbGwqmZTMb6MqfZ0Stm4tOc8Tozftya7rgRUiWWjIO5zTpHYPRIR1cesdf3mjP6Hn1RiWr861Nba2T/C6X7ghLFhDP0uiD141GX4+3TJtRAYUK3M08oVbDtJ7sm5OqlT/+QDDsCBLzk4b2Nyxf4GWUZaqCHD2fism2gvy4+5Bqd2QKNiwQ5YpohFf6xWbppgSwD/b5scxOsIEI2a+wJHCb0LXS87QyI6Tsd4L9BzXHfNkqt+jaU+wti+M0t1Sdkr53OQwlnZLCPVYochnKS+iu3jMTKpUKw+aCUEh8OIWFcnwE5Nt4xS+MikbDX0epboSJUehZAfhEC3rLaJUITDy5PV61HaOHO/0nZ22jfLdE0EFRDfllXDweR3qVVMtOL9JCzA9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> PG_referenced is only the lowest bit of the folio LRU refs count
> (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
> clear it, and now it toggles as the count grows. But with the LRU
> referenced count as a stable API now, we can use two helpers to provide
> in-kernel users a stable and sane reading of the referenced status of
> an LRU managed folio.
>
> Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
> count when MGLRU is enabled and PG_referenced otherwise, and switch the
> smaps paths over to them. The lru_gen_enabled() test stays inside the
> helpers, so its static key is not splattered over the few call sites.
>
> Convert smaps as the first user of them. MGLRU now reports every folio
> with a nonzero count, so the reading no longer flickers and clearing no
> longer results in an ambiguous status.
>
> The classical LRU case is unchanged.
>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  fs/proc/task_mmu.c        |  6 +++---
>  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 3 deletions(-)
>

<snip>

> +/**
> + * folio_check_lru_refs - Test if an LRU managed folio has been referenc=
ed.
> + * @folio: The folio to test.
> + *
> + * Returns true if the MGLRU refs count is nonzero, or PG_referenced is =
set,
> + * which is also correct for the non-MGLRU case. Kept as a separate help=
er,
> + * to avoid splattering the lru_gen_enabled() static key.
> + */
> +static inline bool folio_check_lru_refs(const struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		return folio_lru_refs(folio) > 0;
> +	return folio_test_referenced(folio);
> +}
> +
> +/**
> + * folio_clear_lru_refs - Clear the referenced state of an LRU managed f=
olio.
> + * @folio: The folio to clear.
> + *
> + * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
> + * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
> + * just like folio_check_lru_refs().
> + */
> +static inline void folio_clear_lru_refs(struct folio *folio)
> +{
> +	if (lru_gen_enabled())
> +		folio_set_lru_refs(folio, 0);
> +	else
> +		folio_clear_referenced(folio);
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {

I assume this mean people should stop use folio_*_referenced() directly.
Are you planning to remove PG_referenced helpers to achieve that?

Other than that, LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


