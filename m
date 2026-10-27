Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A70606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FeGPJMsK
Received: by kanga.kvack.org (Postfix)
	id 4348D6B06E5; Tue, 27 Oct 2026 10:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B696B079F; Tue, 27 Oct 2026 10:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4516B0798; Tue, 27 Oct 2026 10:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F19056B079F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:57:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62B6AA0A8F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:57:54 +0000 (UTC)
X-FDA: 85368710868.02.B024A7C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010043.outbound.protection.outlook.com [52.101.46.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57C3A100012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:57:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FeGPJMsK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7kAyhjWyQ1BiZTz6J/b4VMlp8msICTkeq7uCPviZj8=;
	b=4UqritQT88LBQTdrEoGJMCOP63gdumxHTpF5uhD1GjYi1xVmDOjhXGZ7dguEIoHwSdUxiv
	9Pm8zlsEPDyqZx0OeU3RdXPWGfHSI6q8ng5ZVIG/VEopBMrXMmbBLtgvjuiGsSXnnKhwDw
	Jg9vNd9AYVSQQWkGrcFJzT4zyHbMiy8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FeGPJMsK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793113071;
	b=1dnZTOLlqRqUdZSRXZRk6tgRjDopiKtE6FOL/vidyvf9HjyIZemYgTrW+3M1wgzzKIdn6F
	4/g+UyTEB/nOvkNkbaUduZiOVB22aX7AOioTUBy1090BrVRt859pnIoHppVHwjnssaWPZc
	TEqyapovgLOXjsead2hjxriJMbCjgJk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jy6USLn2oynhKKLOcVZaPrTLE4HUTNY4wMlOMbSb/w8txGV6ZxIxjEfCukH2o4z7bczUgNOnCnQ2thRZrs7MqmBMwLYAjYFau5rmpnU+f8SmeLCULbEmIu2pKz3Ea9t7Ndnp4kUBj2RoMZaDi/xPlRPi3mUmwk1fm1PZzdZ2D1KZE2wuqB7abcOviRJ00znU5nekL5Ds1mgQy+JG/+3i8y1OIz62KF6cz+YcSY3YQteyvM7K9oF33mhsF75gAQxC2qSjMvHyfMLiVhrojPdyLXXKOTKkyOUrHjWmLj9/8THOJT+bXjOxjKoQ46HCGFpbK73SsyJJKwZjouOjM5eqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7kAyhjWyQ1BiZTz6J/b4VMlp8msICTkeq7uCPviZj8=;
 b=sGm0WXW/k6TLWrhdeog6rEyABBR+4d2fxF4x6uAOBdelFwPGo6hm4RjbpS4mgtqGW0wv0+UOB3vU9ITTAryGWc6yrqSridKOxZLzvi5NkJzRzEWJRgn5PgcGiOU/s+AqdYo6l4F37E1u7BHp2+lnm/+KvGnJMRTfEuqfXFxPLjra3qO48eJ42K4zZugxziC78rXBdHBWMyBwLZOBpITZuMly3Be18hSOUIQw9KIfdGbaz34Uo5GC8OXSBhxxouda+zrOTtv+n9yrO3ahnZw/2/aGuy3cohgzZJXxcL1Z7lbHkLPcb3pS+T+58RLBlp6KG6bUg2NIT8t+fUCWJyQ72A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7kAyhjWyQ1BiZTz6J/b4VMlp8msICTkeq7uCPviZj8=;
 b=FeGPJMsKY5Gbw/FQc/8bVHQL+3uSE9Li3tFWGIQTE3MKPQQQ/KxM6F8RAABaRzNP+ER+0Jz9EFsK10WKcPKujhKK0G2+RAhM7lbEOeSa+8foZGzjLqPubcUVqS0O788m8SG1tQssui3uDRPrhOYyGc2Z3W7KR9Tr9+mqy3cYRqQer2RYmvWCGg+B6SQ6AVfME8eLeq4SPlG7aPxe/kMwcu20d7hf8fjWSncJnmxnCKXmrW4MNZyDFfkI3RIU+7ayCXfg80qkBIWT+8Aac//3CKJwNx7bLbfFZVUGaHR0I1B3U4kvUjNd4aA9Bn0QuZBdKipE3jG0A8cRDv1FZpcinA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS4PR12MB9681.namprd12.prod.outlook.com (2603:10b6:8:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:57:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:57:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/migrate: move NR_FILE_THPS on cross-node migration
Date: Tue, 27 Oct 2026 10:57:41 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <DB41BDCE-B28E-4CBF-AC22-971A09CF7179@nvidia.com>
In-Reply-To: <20261025110209.4105994-1-ridong.chen@linux.dev>
References: <20261025110209.4105994-1-ridong.chen@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0985.namprd03.prod.outlook.com
 (2603:10b6:408:109::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS4PR12MB9681:EE_
X-MS-Office365-Filtering-Correlation-Id: 58a7d7a1-8ad9-4de4-f97a-08df343aa7cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|23010399003|11063799006|56012099006|261026121527099003|10067099003|261022075727099003|261021121427099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5zLseNvUF2j7ZPrKsT3pXpBQj4/MVqsVwjq3/bh08cfqZnJUDVAFeIAHQci9wbDIQ96rl0qkc54FkJNVzb9c1AjcSa/0BGbiff+zpokcyfxjLljpmsSBXtT6nBSHLUBJaQJnFHjTv08w97WlOQaPbru2mhft3F1UVN5G6905q9RhyeNI4EiW7Xm0wrNl+gEXK4wZeleAZ92H3jFxntWZYV0dORImIxUtdUOc8lVIz96KykYtx+izMOVkWYrCB4vDRkNjfzB9JqynwWNcYBIcDoXIif/Jx3TDZsEpT4uwn1tPyyA5ySRbez1R1S7qv9alwVgoqhewqbFm5pM1mvIyYz4wqveHbbV+FbJrY3jrQK6FJ4x+VrpWirgi1b+QmSDPsDGzIa6PZkf97bSql5YteaGcmKjHQHDZFak9BmrcljajWBjDUmwZD4woR7SHVWCHaDakORgKGaQLD6AUGY4/cVemwBhdF5L16ffqYvR+zw4cJawWq54iZFBIe7D5zBwmARJ8eSNXplbTOhWXIs2hihK6vwmSQeNmUjlWhfWU3qOZDt7E7Gnqq/4IQHOanVYEYf91s+C5WhkIDf+VF43PanNXKNlmgo2IWh/lS5RrAQTDQ48kCO6/L5weZsMn1MgbeHAOB11T4EnT0eT37nwyf3Zt3eHHdYBzPFRHcOAb3SU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(23010399003)(11063799006)(56012099006)(261026121527099003)(10067099003)(261022075727099003)(261021121427099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?soQO+LlAj7X+wANRYPwOQjtBRMvutbHdw2CFmRrI6rSWurS7LA1q4BPVzS/7?=
 =?us-ascii?Q?qAEoqjm7dlSZRtt9WnBStFdmTGUVMXUmIRh7gCwdtJODSDBihyj1lb4RWxnd?=
 =?us-ascii?Q?a/FDatv5zedgqiELgdU8nrW9r9CgyuBKYwlesPBplutiQyFxLhcl/Bfrc4uf?=
 =?us-ascii?Q?d5lgt2qXYzqkhfXi6dHR53wiYjpVfzgK2zCrepzbg6DECJWwJrmi2RaDrDhw?=
 =?us-ascii?Q?XGUyKtYGm5hekO7EhfzyjM9JdtCh+NHL+7qym1hOLGbDU1i7ohk80y1lchqu?=
 =?us-ascii?Q?xYEshEV28ETwgI+il7eFIdV01SZnO26jyh0XUNHb/2RzvJH6nKdmYX0pJNmw?=
 =?us-ascii?Q?Q2ErTneMoh9DllDDKK5VYTJArQ3vWceoSHVikJk8cW1Kz+sbKv9Qpj4w48i0?=
 =?us-ascii?Q?R83J6M19RtB4f/nHoUM0pOJynciwwC6+pxOkdu/5J8FIKiNgdWZ4afvjlKSM?=
 =?us-ascii?Q?Pcjfz2qT89lK++SK3G570wdeShx88NZrRc5UDkIfxcEbk3Dnm77VcWZtGQP3?=
 =?us-ascii?Q?+2g7x6rNbG/S3GIBfAFidG3kzblA5K7rng/6BN+zvXFaUGQvSTUJi7oC04bp?=
 =?us-ascii?Q?IErXgeoDxnKpeIJs9cMki8VXPH/sKqRmLAg3wQKgDTTrAenabbDohZviV4PH?=
 =?us-ascii?Q?ujLfkhPUWU1ZhR4XOxxZadJN1Xk9i6iWDfSOC7tc7cLucntehqio6q7J6Qsi?=
 =?us-ascii?Q?CDrfRyRf9nq9ZntrH5o9nbqiRrNraJWM2UgRFYW4x0cgZk4Di/cQUdeCvGEr?=
 =?us-ascii?Q?IuFSzKCG3zmhn2tcudNfZ5A3DRKwSFOqxylSzWR8DqvyVlwIRXaWVoDxRCNO?=
 =?us-ascii?Q?Lw2DBWWAwK1cVUNR+JIHw8gksHABe7+YowilUKSa4MrYkShcPeVkwOhu/j7c?=
 =?us-ascii?Q?rN7GS5Gv23WutW25PkTdnecAq2YHb4p6/R22vZnxaNE3T3Abok0pp37sZ/u/?=
 =?us-ascii?Q?iHZFc9uk4D0kbpdda/dZOE8IYDRo968E6Yat50A7Et4UcRa8aNz/c6AlzAGu?=
 =?us-ascii?Q?4ZOfuXMQQnOsfFoqRzbgxwBI8BDwg2I0Go0wCFNNXqkTkwP+BoyT/7qLMlwo?=
 =?us-ascii?Q?Py20L7b3QMnYXjD56ROYO22ZKMkMinPCX7Ori5C8fBCbkXU0hL6xBZ9yrRiI?=
 =?us-ascii?Q?AGvhdH6z5QXM6ZZw/onHWJAJjJiNWWwQHiQln90h5njPXAEKhmxxOdpPWef+?=
 =?us-ascii?Q?AKHk4+pUzDyXLMTmawczwZFABMyNWe7A2aN600I5g7ynsi7F5yZjp4hvT/c2?=
 =?us-ascii?Q?Q1kq2BWOjEOW9b7Jh2UKQEyR8wc4K0eSDz1OpTgkxy3zdm06eDl0nT69sBpU?=
 =?us-ascii?Q?oRZJV5Q0/tvhvC01FvkkpQ9LirK6XhE+TUwUsTR7WTyQdeDtQKCTeZ5Wdifa?=
 =?us-ascii?Q?0rYjcmo39XOPLvjzKpPlQPiQ2DmNt8qwMGjEvVaLE6CzzjTzp3KXaKxTBGY6?=
 =?us-ascii?Q?OrRWPr3GIL/yUb3ylYwlEOi1Wz1zOM8/6sBwdYzJWLhH/sSM100sWK9pYGvQ?=
 =?us-ascii?Q?NaNqyQTqIgGpZL/lB3dO3jxat+Rif5OvLCR+5cwWMEfWmJ/iakGpQDvKK5z1?=
 =?us-ascii?Q?3fEbcB2DsNKneqgEhiKLY5SHJT25ZjaEyZj2e2MfW5hjxGIB/wZQo+8XoZRL?=
 =?us-ascii?Q?T3FmRgFYw1pzmF4fgyBPtfG7oCCSYjur5bREhmu1dQnWksVxSPcC8/trzMLY?=
 =?us-ascii?Q?LjKh6w+8uRIEk4wu6b/ASZ4UFuoHiDd9u/uRjw1fvNtjuES4HtXlzX+9LYQZ?=
 =?us-ascii?Q?9bnIn/Th/A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a7d7a1-8ad9-4de4-f97a-08df343aa7cb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:57:43.9059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4n0yCeeEBrB054ltYdEB/3j7Mq37LKhknpr+hqZZUJ4gqT4iG8kt+m2VPFUvHypi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9681
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57C3A100012
X-Stat-Signature: rjdtuh93zipoig5187yo995jr8mxcnnu
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113071-101483
X-HE-Meta: U2FsdGVkX1+ICQbQFfhpFpO8j1BlIf8ji9JZEGDr5YlYYc1TSk8xchmslLp2xdFca7OSGqzz0WppTq2pZn9KHXsWDyLiishXKMcb7edGyBpcYB8jN1a6L+1zZWoFJ7e6iIsRGlYkWBgs56mtZXtMAzCh+M2+tGCCF93msE/tZH1WDCGAJg5ZfYAXGOSO6+HB9MYkp2/IC6bxiXAMz9H79aHcA1ChTeCnZFIH5sEvgTXnxAz5NqbqAFd0iC/QikQpRjwckswSxgQQ3tBOop3LLgcJHtYaFYCkFSnUNFSzICCVrwe01ykfKtM8UbzdK6GfTo7snsQBPrOjv4DpXv+9V5KS1gpQeE1AZdOE/KODw+JV1+VxNTkFpH+OvYvgyM9LDuQL7J7mxAEX5K0alk5GRgJlBlXyuaPW0YidYx8YXlA+mRJxtILq2QpG5WEVyk8AgRTn+TToCP5IJWw1YFf+kqlB3UsZIWgDhGs4Gx745pcpJUqcjqdbNJsGF3QQmZHHiFFC2KcN2h48UKfb4psA/o6jLHsLZHpLn/ZrHkUFoD0fusbEnESv8R2cFlFM7ZAvBrlcq3aTBG0w8tA4CGmkSF0z3llFQxzaufEx/+RxACHYiTf74A4NS18XS62LIgPRIEkwCYujk+gjMzwGviak3mkB1qk+kh7hbqMFxFIdN85SnJj6a+jeb8I2i8YozdmYIzgnGC+BR9D5NOm3TP7dzhiZYeTvoFbvpAZuTeoYdI2vYaTIDhjvzdx5moPN0l9N0L99W+BVqbWaGkANKabFfT51rhGfGCpNwq3v+H9WQqiTHbrM477x/WeAh1RHgADgericP6Wc8jRrU4nRzhOneVZv1hsPJaOLSvr0qgfqvaGuktYzBoZoylqzmjb9GZaPq4LrbtAncsLKbaZfvqYJ1zYeQqQcx93dnOmrYp5JC1FZcf4yeiVvR6XwM1iw4IYFoOhRshOqwYAsnJKvTPy
 Za5ROTtZ
 J6TB9a6S097ITBJ8uj2IlAIR25O4ywfNHMEDqM53pODG3x9VCXBaJCX0VwXrCskuTpNO6T122EBe9UY0u5IIPRtrV8k2s5dnb9m5/eF7V2VsB90nCEUIMUgY8DE/IvviEvE8zJ3COW1RmnTst703jfEJpy5rXrFjcY35nfHuWDgkhXBX+j4ugRIgnebWTGeUDN3hpdkzOvdaoYOV2pcKFf6V/akYH03WPXS7FsHF9z7jNNFAF/FgAJ9DjUw3TSQPdPoZFlyHia0k4F46PK36I+cOrqbJNc0/8+W2g5HnQMXDxNWUBVIvHXsTbHzFUBELzbzIJZZd9bHX89BlzxP1M0pixsmDJZGz7evJmof0jD7XidY4N+rsjdRevCMCGfVrDy0xEMWz2oHWwBB0oHexpDWuUlwk1RC0OLefhafy9GOEGov6hj7u6Cg3uhxr6A8ETRFLVSvy8hGZvkPNR7z8FZ/afLxinsCc3iC6h15E2Y2TTaR8KryvPBXr+ZjPu0c6X5JmuIE2h7nO0+X/zGlFlSGRtig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 25 Oct 2026, at 7:02, Ridong Chen wrote:

> From: Ridong Chen <chenridong@xiaomi.com>
>
> When a page cache folio is migrated to another node,
> __folio_migrate_mapping() moves the per-node and per-memcg counters
> that are keyed off the folio's node: NR_FILE_PAGES, NR_SHMEM,
> NR_SHMEM_THPS, NR_SWAPCACHE and NR_FILE_DIRTY.  NR_FILE_THPS is not
> moved, although __filemap_add_folio() charges it to the source node and
> filemap_unaccount_folio() takes it off whatever node the folio lives on
> when it is removed.
>
> Commit 0b52c420350e ("mm: fix shmem THP counters on migration") added
> the NR_SHMEM_THPS case but not its file-backed counterpart.  Now that
> ext4, xfs, btrfs and erofs can all have PMD-sized page cache folios,
> migrating them via NUMA balancing, mbind(), migratepages, demotion or
> memory offlining leaks FileHugePages on the source node and underflows
> it on the destination, in both /sys/devices/system/node/nodeN/meminfo
> and memory.numa_stat.  The global value is unaffected, which is why this
> went unnoticed.
>
> Reproducer, on a 2-node QEMU guest with THP set to "always":
>
>   1. read a 256M ext4 file through a MADV_HUGEPAGE mapping while bound
>      to node 0, so its page cache is 128 PMD-sized folios on node 0;
>   2. move the mapping to node 1 with mbind(MPOL_MF_MOVE);
>   3. unmap the file and drop its page cache.
>
> nr_file_hugepages in /sys/devices/system/node/nodeN/vmstat after each
> step (in units of PMD-sized folios):
>
>                     without this patch     with this patch
>                      node0     node1       node0     node1
>   1. cached           128         0         128         0
>   2. migrated         128         0           0       128
>   3. dropped          128         0 (*)       0         0
>
>   (*) the counter has underflowed to -128; negative values read as 0.
>
> Without the patch the 128 folios stay accounted to node 0 forever, and
> every further round adds another 128.  The same happens to the per-memcg
> per-node counter: after step 3, memory.stat of the cgroup shows
> "file_thp 0", while memory.numa_stat still shows
> "file_thp N0=268435456 N1=0".  With the patch both are 0.
>
> Move NR_FILE_THPS together with NR_FILE_PAGES, using the same condition
> filemap_unaccount_folio() uses to take it off, so that THPs in the swap
> cache are left alone.
>
> Fixes: d68eccad3706 ("mm/filemap: Allow large folios to be added to the page cache")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
> Note: prepared with help from an LLM-based assistant (Kiro, claude-opus-5.5).
>
>  mm/migrate.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

