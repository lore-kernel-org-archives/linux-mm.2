Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1D8606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YJFVXeZf
Received: by kanga.kvack.org (Postfix)
	id 30EC26B00EF; Mon, 16 Nov 2026 17:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF6E6B05B0; Mon, 16 Nov 2026 17:00:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE466B05B3; Mon, 16 Nov 2026 17:00:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6A36B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:00:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61DA814022E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:00:08 +0000 (UTC)
X-FDA: 85442350896.04.E964896
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012031.outbound.protection.outlook.com [40.93.195.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7535D14000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:00:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YJFVXeZf;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794866405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh1oZ3B2UCp0B0Cmav37zbAnlzaISBIOg5wd9YX5mYE=;
	b=R3+xxGUFdh5OCvt6VYXnzjslZnpVI0AxjsQwksw/gknZPgvJzSKcBSwG25S5W/6VCHORvI
	QD4uLMczyfQdUIgwnPvRWHg2fG04C/8XnXahUAtVHtPuCEJfYOFHa98onT9GDVrcNm4+DX
	DBNSgVN8rLJ9cVvU79prQPc1ugSKeFI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YJFVXeZf;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794866405;
	b=pFuZUIGoan0Ggobx3HKtCEOwP/C0kPaipOBsN0Hj8xfv5jGACOjfWT27Bqj809MBcIpN/D
	W8Uo1WilaApUCGncLZlzjgf1tes0xkbsjTZApE44PeotpHBA0xWMzyTbrWATMfjDLi6rRH
	Vm9Pr+WpiRY94yoGyfOts22g9+iFPic=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zkr0FqGJXRIPrCj4NPW7To1EP/Q8Z5wtgEZ52jLQ3Lk2XhQM2MyYIVrlyWJYbyrsdQLd6tS7MsQ4PcMgNeRnPfFyA1onvpxWJURAIB1l0xWxhszysIV33vbf0HsnAVjVFpZ23RmjHIsFCsb9o0qlNKznmit8PGIsEwWkq86/WNqv9+aKpDCi/3EW7wHRQkxyGwykYvjpA7fluHOgTaLqazMj8uY2cvL/Xzk8PpCQs4X3RhXnpwYvp+2pGkcEkoA440gATltdDrYXUGFkb+NUUWLAfftJk5fQj7jVj+w4jcgh3Px1XdgtnQ06cJqzm2NMLyYL4jUiX6c3f3My99YviA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nh1oZ3B2UCp0B0Cmav37zbAnlzaISBIOg5wd9YX5mYE=;
 b=biVTq1LLM2wemzMkNjED354Fy0IZTpCrMdlTjwCNxyuEGPWRpxkSUu5I7edd1DPfln+aTQ/J1l//PKlUZbQcQgwn3fqgi2YFgaHRP9hsoH0zP0O51IO2oHlrHROcw+BKIVh28erKYjfoYBy9mTX6KHDQuckP0gBNPm7E37//ruljytILo8I9P+5VWK2PEg1elMZhUQEPBUppe+kwFuBT+4JuVo4mgeBmlmS8ZhkaIUQROxU9qNjoKlZm87h5lMv4ujD44cS7mC0TR1M0fPRkA2E9KNWbtTU5t0gWD5aOSKZ8Tnys2oFpFjJyNLVJT6NmirGXI0HLzILVEzwNfAsRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nh1oZ3B2UCp0B0Cmav37zbAnlzaISBIOg5wd9YX5mYE=;
 b=YJFVXeZfinU2H1mAQVulUKIG94+il8V/TTjwGBtTarr4t6aJlHkVxxh0HK6vdfvipwPrvUURZcDnQ5BryHCIfnn4yfhFhFCDtiqrrXUkL50iAyGF9l00PzAJzvPHEO8EtPBdV3cHO+7MEBU8D7S8DRjLAQJUyqxzrIDgHyxVdrIO/F4UHRhqPSDNI/7b38shlGM5famd2Hv0RP3rBOchF61Gi4nfZwQ1QOA4keyLTFC8jzKjYsasCpObkoXB+G4EW0mwAUeqf31aTPdLAJ1SzAH5nEZWuH7sIC/iAU7//pX4zat12ku2uDOqCDw4hxgEQ76v9lxRwcC5XSivWmWH8w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6298.namprd12.prod.outlook.com (2603:10b6:930:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 22:00:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 22:00:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Nov 2026 16:59:59 -0500
Message-Id: <DMWZ1COHLFJ8.3NI53X0OT1I2W@nvidia.com>
Subject: Re: [PATCH 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
In-Reply-To: <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: BLAPR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:208:32f::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: eba38fc6-8fe5-41f1-3981-08df442cf5bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003|261026140227099003|261028144727099003|261021123027099003|261021121427099003|261102123227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	9O7Fy3ma1k9UuRTvjqXl4htKjADAlgvC6hyYo6C4v/HypekVhInBQfJ7pywqDuzbSaOz4zPBUuv3P/Go4awt+V0WGN5qijCM00uBQlYRuk8Rv2oNHWixkubkoSTXPrRx3gIleeH6fXPGrZkp/INgEL4scns9aUwyxUUmdTD5PTMW0k4t2bkzTdXSb8wpimghwvu2YsPN2jlAd5yniq09gL+z0a4fq9At1Foxtai6yYcVbScvA0Jd57GHjOEbXKODt2kO8dvaeREe0pEvzAVZd7DnOBChrClniHj4N5R5Uq1YFS7A39KCl6K7wDdiPNK0AmuLQZ6XMeYgWGkAy82gJQC7PBoOZvGBXMtTXiTMf+NVo0RcAlhMIQw8VCurf4DMHx8/4wOVjxfqNAGd8SDQbyt16SXAsA7anra5z94oIWRWFy0R1xpJ5uYxZQn7Q8sQsRNIa8sMk0QN+sbGL24mUSCAqvUb0KtLf2MN8+FF/3S6wZzn67sgx58Ob/x3sGEfkvoRe9ZIkcMPwjiCaenmYGS4y32uyiGYWHkgsDa1AKigREeAhp3gruMN57kbBtNmx2QcwKuekFX4+Y2rgThYYihl+1sif2XMKFNC4ANs4YtZmKMnU0Wj8TgLdsdRxB0dMyZS6arvbKqomr6CE3x+QOfa0eSc/6Lx46hBymvhvc0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003)(261026140227099003)(261028144727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzdzWlljQ0FmeVBXa1FnTGd4eFd5alhKVkkycytqcHR1T3VTbVNqU0RhL01n?=
 =?utf-8?B?N0JSa1lheVdCK3dyc2dKM3ErYnN5a2JLTUV2ZGRxR05YN1ZnWS9EKzZWcjJt?=
 =?utf-8?B?VHdYS3FhRWFtejh2VlN3SXduN0NrQVdFQmRnMEpyTXFVYTIwdzExVmV5L01q?=
 =?utf-8?B?VDhuTUJNWTRlbEQyaDdnbzUvaHQ2OFdpeEZwZDh2MWJTVU15SUQvQVlIdnBT?=
 =?utf-8?B?eEsxUnovOHNmTTBKU3pybnU5UVNzcVJWNDZrVmh0a3k5dU5vQm5tckpwSE4r?=
 =?utf-8?B?eVpKa2wwU3pvT292Sm02MTZnV2NaZ1IrbHZWa0JkLzY4aDhwOVRWTFRMUno5?=
 =?utf-8?B?V2lWdE4yaXFrL1FNNTFZRHMrWDdheG5VejBtblFHOTVqMklIdmo4L3VaaFln?=
 =?utf-8?B?d3pxLzV3RGhEWHgrZlRBNU50aVhmay9pUEgyU092b0prQXMxa2RDVkRveXd2?=
 =?utf-8?B?em1NaXdBTXFEZGp5czVRcm0zdlAxRFZ4NWIyNkpoN0tSN2xITk9kQlg2dnhw?=
 =?utf-8?B?SXhZSmpYZThwYmlLMVdId3YwY29wRUxDMXBkbVg3czJSTWZzcVNkRnVHbHc4?=
 =?utf-8?B?aHk4SjNxcTIrenY1QXhtaUxnMCtaSVVvY3NzdnpjOHdSZU1FQnA3d0lxcWNt?=
 =?utf-8?B?ZjFKWGxSb0FJcjliR2JsVExkN09MYVAwNHFRT0tRVG52bTIrcmU1bGFYVmR4?=
 =?utf-8?B?WHdBVXliTi9TckNGWGFJSWY4ZzU3TWhLc1h6NEw2RWh4L3Q1b2dZWGxRNWl4?=
 =?utf-8?B?NWdDOWdXcUtvWmpmdWtINGRIVGlycEE3dndpMHpPSVZVUjdwNXVSTTF1UVpH?=
 =?utf-8?B?YTVpZ0xyYlo0Nzl4Qlp2UHhXdHBmYzhROG95aHVmQzBlbm1ZRkh5TmViZkx4?=
 =?utf-8?B?L014ekxScy9PSzd3emRMUmF1UHVSc1AvbjJDUmRjZ21QQ28vVlRGVG10dzcx?=
 =?utf-8?B?ZTlLYmNGWnVVd2NmWnNOYmw3cFlMR1NmYm5UdW5VcEhCVlF3cTFVMzRCL0py?=
 =?utf-8?B?ZFJXemVCL0ZYQ053NTB0a05sWVp5emhHSzlYdGJpMmlMNG00SnVGMzN1OW83?=
 =?utf-8?B?Tzg0THdDU2Ftc0xCOHpmeUtDZ2FNQktQeTBYcU5KZThVRjZXa21lQ2Z5Qmwr?=
 =?utf-8?B?SmY1SktHVnU5ZHc1dTNOV3NoRXZLVHpTN2s2cWhMNEpJQTgzanIxd2tSVmkr?=
 =?utf-8?B?bGUwUHJkNXg2a3gzN295RTVRdGJBSUVQMlZUdnJKMDZvSTRXdko3QmlrczVS?=
 =?utf-8?B?YjJ2azBmQUdiR3o5ZXJyNktlRmZSdlFtY2MrMHBJMjhySUsvYThzL1pYMHBu?=
 =?utf-8?B?MnJRakt3dWo0ZkxHUnloOTJ0eGJ2ZDdUb3lGRnFIM3VzQVBDTXlseFA0ak10?=
 =?utf-8?B?YlhZRkp6TldLdW82b3YwcS9EY1MxOGZlQkY2Rktkb2RHekwxS1ZQdUtEYkFG?=
 =?utf-8?B?akVKYzdmSFBTYm5yYVNITENYSGNQdXRjR3lRNVN0MjVFemNrMkZjVllmY0lK?=
 =?utf-8?B?eVlYRG5ZK0hGbEV2VldvMHlmSUR4WjVuS01hOUF6S2hiY3JKME9zNEhoZ3BT?=
 =?utf-8?B?RytUTjQrcHRlYm84TG00dC9nM09mU095MWtIS3hpQk4rbElvTEt5SE54MVE4?=
 =?utf-8?B?a2hXR0FMYVdkZjN6WkVmcWx4YURYZHE3NEJzZjJxS2N0eEdieDlhZWtBVjA1?=
 =?utf-8?B?cHBvWFZ1dXZHZkt6Qk9RUEFVbWxRd3g1UXhvWFovL1VDN0FINGdCRXdSVVhB?=
 =?utf-8?B?M014MmlkM1RHbTBmZHkyT3hSWnY2S0pFNTI4YjZTcXk2eFBKeVJ5WmRPWWRx?=
 =?utf-8?B?cFBVdTRPcjdPNGpteE1sUStXYXkvTTRZaUwzV3pNN2RvdnpGbnFjQk9QcS9i?=
 =?utf-8?B?NHNJVHp6SC9CR3RsTStUb3Q5YU1QUFcrSXBtcmxhUnR6OVJjUXJtV0prN1RP?=
 =?utf-8?B?UGtlRnFETUZtTE0yYW1WQm93Z1k0VjRDeXZEWk5vV0JtdURKeTdQeGFENW53?=
 =?utf-8?B?dUdxYmRnWmNmN0NhK21JTTF3SVFxVXJ3SzlqZjV3YVBRTWJLQU80b0JXaVJi?=
 =?utf-8?B?R3BxT0JJWngzZmxCWXpjdWQwRWxUTWRQQit5UXZveHlmWEhteGNFS3VLYW1G?=
 =?utf-8?B?SDA2RG8yUjRJR3RTNTNIZ3JSZXhObS9ENEhoemRrZHJtUlZnR0ZJVVNTbXN4?=
 =?utf-8?B?NFBJOHlYQkxldFJUZFdHQVFGUTQ4Rm5NWjYwTTJILzBhMWlocWRKc1FiTWUw?=
 =?utf-8?B?eitVTVM4MHVNWVJ6KzdYL2MrWUpoWVQ1UWpNNFBGdEc1NVdOQ1Bnc1grTS9s?=
 =?utf-8?Q?b77155XsaW8/jwBKrZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eba38fc6-8fe5-41f1-3981-08df442cf5bb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 22:00:00.3184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQ8WpIGjc97ceGussFlDOIvnKUkFVNW1rl9IN4kSAkm5YChkfhpkzdKEgx/aAD5f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6298
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7535D14000E
X-Stat-Signature: mh8u8u46qf48h6xb8ipfg5wfe1gitcuy
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794866405-7204
X-HE-Meta: U2FsdGVkX1+hBC+GeIS+Wmx10GpV8vAt5jXWeG5rXxMAK+mMS988IQvlzIlgv2Nj12e7Ri95mCZEFOOfWn3EeVMuOnS3kmYwSZEywAZNCSGjMncyvPm3yXXspyfjLJOQO9Dt0gRXvj3ykpR89iIn6G5Am+oCikCCHfagMOjMtvU62lqDWCtoxKA2q5FwE5Ll2/i6ahV00AGX3RQl+3QhNttQDJvHJ94Vv7cHf+hyntsbSqYbslL9dfq5T7xih1ZpTFgnEjyoa7BGmj59mI3cJmPfE8PF/dJTj6MD+izkf30pGvHuWiC+4LPRr3iL81/lEmdiNxRUGCDkIChYXUOB8om5Z/GHTpwEvGJuUkyopMdtm1chTCyuBx413ZX6H4OwEQMgbxTbR5TM7RP8frvhPzUyHnTzJk/2stBu82gNT6A8WxhcWCf/y3eHgKkq/3s+UWGYEJkZR40tUc/RQcpm04ZWr9oOPSCr/GkMyKTiOcYVp9o7ToIDVm/LudGyKPpkxlWArbJQbB6Stj+7YONdp9FeEOnQ3ZNyRJnC+DV3Wy0xCv4SF8GqGyb7DbnFwqg6G+rqj3zVBRUPxj5qXb8RfwpZhuVhES8PFU2/640UGcS4Sl34ed4foGiOUZ0pm90mobr7L4eeOfmUQM4v/aHGYKbXVOTfsJq4ypepQoMpHp1SIbXK6Jq8SDrHp3OzpLo0LWFxg28KLYzlGyGX7DvD6P5oy5xZ28JuYjal/5UaFOc7130+UsQc6oNuX/fhi1Pch+Ov6MoRQHXMerS+1mVIcPynl9ivJOJFeOkR8QT0nBNItOyuzjsaASbxOp3LNgbAAg+q45DoJQdoWT+5m/vEYzA+lZkB6WlaPr2b1gNH7XJkuXeIww0q+GP2JsG91enhVxlWilWu1h4knJuOTFAV53fXSaChIubwKAS3QaiIkMlrhur2E1eFMeq4EBU5TOyobM6i+JMW25srCjOM739
 wP2Q+Aa+
 B+Dx8NIFLhIO4ydUMs5DWp7JPEPyXnqQ0R6fh0ytpBpBT7+tZzL2VTuFN1YvmkSqNWBMrER99k8OabpNfhXrrL8yS1Ir0TfBqwr475G3Es+/Wl0ClkSfZgClNW2wtcSAdPn6ffx/gM0utSJl6yAgz7SOMARQLupEz2d3WtoZlXXd2RTweXp7QrSbABfyvI8UMfT2NZ29cND8IKbQ2BF9PwhV4Lumcj+hJvTYq7gagC5qYrZN2BJOxDkVmbgS+iNKI68Ql7OMRQ+4RhMCHxPchfxSa9w+v2/N/bPIHG0o6weADkNSVyJev+dt/Beqwrw3+mHAKpao8TD223ezuavcsZS6XC044h7NEdUTg7/Q7ZQ6IswYGkpa0PFpAp2XqH3fRcOAbKlnvNiXy0bKQ7RCCdRD1WCmZyleyClwLGfKMLLBkv6oGGUZKIbtHztTsrE2qRB2PilCGQ96WKODquyq9FHt32xVRgq5Tu8UveuFHsUSocFnKwjM/OMNBoRumhOnO9Yz6Xl1CzqE/1hlXLoYYuMm8jzHD+15Zu3ug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 13, 2026 at 6:52 PM EST, Joshua Hahn wrote:
> zone_watermark_fast() has not used its gfp_mask argument since commit
> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
>
> Remove the argument, no functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/page_alloc.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


