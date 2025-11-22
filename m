Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A83FCFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891116B0030; Fri, 21 Nov 2025 21:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867E56B0031; Fri, 21 Nov 2025 21:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730186B0062; Fri, 21 Nov 2025 21:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 629EA6B0030
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:58:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D4D31A0704
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:58:43 +0000 (UTC)
X-FDA: 84136735326.07.51E5D8D
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C38D1C000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:58:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gcz3LT+0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763780320; a=rsa-sha256;
	cv=pass;
	b=ew1C6Ptoy7e7yWFT//ynQqjVmtoZ2zYH9OgxXcgBtPX2xW2nfVFN1HfazCWda9d1iEyawf
	eLuVtwzPiQAky1YmJfaeSYqTcqnDbYKJmzbZZO+Djg+ys6YtGAyJxghosv5hQL3taudtB9
	yM1MrTuNAJ9y/eFl1mDcVvVuzu1CEis=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Gcz3LT+0;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763780320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMlIQZdXjPVxu5O9IU+5Ch8Lt286wZMwzhJwd4Uv22s=;
	b=l0wOsZ0wIz+m65TJV6hP82bzAcZ6kGzteAX0O7jIeVvxpMrtprBTMdFse13FuBqazjKYOK
	rRCVZWeBNgZ2SupWBmRpwP7kGT8poKw1KiErvXrv8mb4btz8XYfa20CY/7b67tx6ZwU896
	zzT7q7Qjqd2IURVPqAgW3QdDbK2aWZg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eB7MerBioOwaE4V9KSKGq6BkEoAWv+3zy6JzNXL2oxRrj+t0iILheFLth8UwFaiLZ2yrWntxHKCWEXe6M0y4lLcI/vEkSUcA8lF2P7cmICuKoilszW33DiPAx+1ab9NkEUU4+4s8zUnif08ojmvX9chdMKZuUcfLkVBL8Ucqp+bbKv7CkAwWiGr/B887MNn3gdyEwwKGGHa0a39cQ5oyHdxjaJCOj4undgW/PMfNMU6Y7ztb2ewh0Dg9EPgBSSrpXcAYIxzuukVmUq1EycntN0OBWL2iVthGoul7py0dnJ8ySjWaa20drCfXmIv4hDg29hWP58cVCT9XDZxf+uf3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMlIQZdXjPVxu5O9IU+5Ch8Lt286wZMwzhJwd4Uv22s=;
 b=cvCn9JmKSTzu0eGmOyYH86Vuc4nTFEQh1tV0fK0teqJWJReywXWu1SKHaIqhhPxmT/CU38Ve2qMgM4+OOSGSBUKk7byIpehf033TDx7NYO7uLL4X71kiS7Y2EXm2ThB+YN49zTsFfs1FhX11G6GMTXWdP6cTAZOdtkNNqSI3b5fxici/1Etv6tpFZZoT7DW1pN9X+yZRh2PEJQdRY8YGaRGgwBsFnuOVnH/U1dMySJ72KAd/1GR6pRHd53U9NKuwEb5qic2UFSLEO6UuCOdtdgNy2CfS0jjYOhmvW65a3tm4dNg31vLJhMVgL1TEdxOM+Jv1Bq4IMtEMvi+wWK+a/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMlIQZdXjPVxu5O9IU+5Ch8Lt286wZMwzhJwd4Uv22s=;
 b=Gcz3LT+0/Yt967W2m4gtDRgEE96aJSz8s+xkmnfNWnMF4QuzNuYFbVl3e7nVCoKW0Oz2O1rW1pIwUhfYWNHkhdxu4l1bYSA2GPX8eFfeKoZ5xxMkrHKM4o5Yo+rzVG2nWe/RUyKqtfzSv42ADGJqsQMcEJQzTTXema60YDlDP4wdx9aH86DUU8Na+bBs8ZXxbRxtWfUxu4cmPbBMFgvUXk0nxjZ0rZ+CPDfWVneE7YfEWJYN/uDyeqS5pbLVptNjf+uiSumhUoCLLtVCO4mjeGWjWtsJ4Dgyx4F8i3G8WWUR8SYCPc5OLlYtUb7H1cRQgz1XTSpP2PGgCui4YuLmiQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 02:55:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 02:55:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] mm/huge_memory: make min_order_for_split() always return an order
Date: Fri, 21 Nov 2025 21:55:28 -0500
Message-ID: <20251122025529.1562592-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251122025529.1562592-1-ziy@nvidia.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:208:236::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: 91d8b110-b674-401b-4084-08de2972a157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Tpv3VHrMYu37hXiz4Zt9bNifZ1seDfxLGPYpGU+cj9xqHZBPlbIg16afVQQk?=
 =?us-ascii?Q?Ole4rGaTAlEbVYHMLHEOtmGRvX0XcApxahWfgvmIeSsaAe0uuS8vq2+4u+9/?=
 =?us-ascii?Q?mEBG7f6+OlY4+PVs2wBZvXtkBwHzl9yN1zC6kTBg2hQTU8tNrETV2K2iTigK?=
 =?us-ascii?Q?TAG0WO1RpG2J1JK+5d7st3wj89clvoxPoV9F5zfwo+TzVnfRcVBLofSJWqzM?=
 =?us-ascii?Q?HH8+wUhdJ+CDAKraCy85LtZaz1O3wvXI7HtxbukyIEPVP9z5/e/rnTessGV0?=
 =?us-ascii?Q?Ni2f1j9fk3suNIXL9VLj2yqW/HsS6Z4YOHZpxuthxIt9y6UlmD3toQCWiq5S?=
 =?us-ascii?Q?L/aUtmszYg1vROK1nIxBsVzYB7dDfWRboqaPjQqkbZdIk4/SXyHBTH87GcHA?=
 =?us-ascii?Q?zZab+M76fw6gs9pd5V8XvS97km5irnMEKSzLCcjeYOllqsVOwhpWAeejRmIV?=
 =?us-ascii?Q?LEPH3Gz1TORhPVxofaN97kf0HwOBSmYd9cFcHio1ORTGFOy1KwuMuib7akPD?=
 =?us-ascii?Q?0+sQb0nxrLk3Ci3HYQREVpVTM0uePvSKlXNSVKJ9p76P/+kuxU5y28CosmTE?=
 =?us-ascii?Q?59J/8lrhZO5JLY1ZoBW7h8egpk0Hseo1kA6RzZiGqyRHmKwlmu6Qs6rPseh+?=
 =?us-ascii?Q?pAnQw9XRtmXBHqW8gXs6l6l3iolJC7x6PEQtgVao0jyKvC+jSnymYZwjPosV?=
 =?us-ascii?Q?gd3JsQVCNn8D8OOtAQ1Q0jdEDblqEzFSSZ0gauJGOVUnUdkxmBX+Hr2e7LG8?=
 =?us-ascii?Q?ikPayVcYiNaqLkO8YHxrBdEuBqVy1+49xNJ2HeENM+SihAkY0GF8HtrXH0mC?=
 =?us-ascii?Q?/nxXwf6w6l8yPhySsFZndSTv2iLk81FlF+cxMLSChQoszzdC1FMP4nKEQ1jM?=
 =?us-ascii?Q?noSBUqK0hi6b97DFmJAmlzhqjGCDFErf+Y/stGd5uQiAAul7ylF9HiL/7vTb?=
 =?us-ascii?Q?VIHD4pAEHHiryzg35KmzebVqhWYocFB2YUaPYl0zRxTstiRq92dw8pXkZBRa?=
 =?us-ascii?Q?Q5atGJZyaClGtv5U5FGFY8nyj6A/S75a7tLJE/085UXBf8WD9ddaif6b9YWV?=
 =?us-ascii?Q?qvcCIM2ii0LA7c1ODlRYfPKOFL2kMyihHh99+AkCF/HgXjsabMKZakKUMlW8?=
 =?us-ascii?Q?oEtwiXjlZ7ZE6hfgTvdBoOlFLDQYgIHujVwF+qo4OdjXS22jYtahKx6Uz+Sn?=
 =?us-ascii?Q?1CIhEphia7YC6dOsmZSulSiSiJ1pk45+cQHFiAg/VxKwtgxuNUzx3Z94mV4A?=
 =?us-ascii?Q?GzcQG+XtZ/7BlmjNStaNOYsl6reuL6Quv9Bp2QM2jps/S9aKALZ7BORNPO0r?=
 =?us-ascii?Q?OPqBuO3/Sih5t0IIW2enfDa4Gsxpyv40iS995qwtaMtY5gFA/ZdIfObtdY/5?=
 =?us-ascii?Q?aRTp4pNhvHXKGkg5YGF44/u3j4RsAc7hKs0FWJlsnCCN1Q/N5rPdH0gJXhUY?=
 =?us-ascii?Q?K6f/wGVh25GGoN5uR88axJ9Y6QW/tJou?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ufEAnhJ1XBjJBjy9mUq/XfL5IuNpFIYx60R7PdDcedXwR0G/iYlXry4uekd2?=
 =?us-ascii?Q?2yVALoMTs93fXvdVboMi1t/94eLN/fQfWgmjlHcDGY2pobakiqLVENP2s6iy?=
 =?us-ascii?Q?bQK41xc6CkzUGrpGzyLHxeER9lZYGW0rrYT2Zd+ZGkVVV27hagxbot6qKjTP?=
 =?us-ascii?Q?mmkFpZEg2M2BicHfDQlwFkxY6coj+fxo6ZwXBn91CxMDWchR6v+GA2f0E4lo?=
 =?us-ascii?Q?d/GrAuaowHg7hkH1cQ+fzsK4sWwNCGuEElVS4gsOlujcCAP2bScrt2JThMI4?=
 =?us-ascii?Q?ZhkaXMf74GEfhaZaoU/nIhBakzPrn89iPnT8cd+EZLVutzveKYLOo4UCUK6p?=
 =?us-ascii?Q?MUpc3S+dqzEq6aow7EsE3p+ilNTLtZQ7BOaUjBiBROF96F3DJ0rDWnL9TU8h?=
 =?us-ascii?Q?E8kGMTW0nQduh0NJ4JU1E6KhrNco1vQuUb+XpZ9Xs1MC8Hyn7cTMGmy3awWv?=
 =?us-ascii?Q?MI6pTMeCu0sGKPYN6+WRZCaDSAeHtcM/OJVtQrnouJnU2krl8a2u4XvzBUSl?=
 =?us-ascii?Q?F7fbm+XpQp4zcyEJgGKNj03uCMk9IjOe0srAPPufxCnL6zZwZM59sUvD/tod?=
 =?us-ascii?Q?5oE64K5bNlAGmwRHItTL3rjf8GwqPy2zSTbwxfvhxvEHvBhlybvk7VU6Jhde?=
 =?us-ascii?Q?rAU0k1UIbQzavivlsMVm1Q+Grjt6vKY9Vf1aJFs8QVQa6uwc3fzpLvSBWUha?=
 =?us-ascii?Q?/4zejhXuGHSh9hgHvbBBYTWU+wTr3G+DEVKvTR7Fod/mEz5tiysTi7s5329X?=
 =?us-ascii?Q?c7kfeEme/wOa2gcuo9o629qTdeMF84Etx+6Xi3Jf8lhKLHZPPM6pCfiYt40Q?=
 =?us-ascii?Q?JhSQdaBKLb7FPSF10mykWfsJflA74D3s9BrKMe8jHckCv/TXGhG51mFDX+EF?=
 =?us-ascii?Q?x2AkDhDUy2wQHsKr0DXMbmVh4PHjnLQPOEHUXNsNeSQVYuIhSF7qTL2+939a?=
 =?us-ascii?Q?xS/r7480/6h2iLViINPv3DmhByX8BVFdU9hkTs016knJ3Im/9Uf1kR/zDBaG?=
 =?us-ascii?Q?kiNOswWiKzzITlpQSJT2jpHu2KIkxFw/yLsxdNEU1S6f5BJvy7jdqYdr1ARD?=
 =?us-ascii?Q?aNI1d6a3pLZ91Ce9fXdgODhi4AHA2x8KmaPSrMaWEO7IrgimMFv5K6zrr3up?=
 =?us-ascii?Q?n3Jj4y0PH1/n/0IePDBhWAtGZ/PYm+Ugm7HPGfe9xb75hlWMw8YgPR/yAYnl?=
 =?us-ascii?Q?ezqptJN0Y9qfGUxx8JrQ7nrTeqyDyLkHZXq2Rtdt15jCLXK24zFEd3BJtwYX?=
 =?us-ascii?Q?SICKXRoFzybGnfy/ygt2ErstYgSFBHgf2dG60SoHzQuTwXBFebc+wg8yQgdK?=
 =?us-ascii?Q?sYwpe6y9MQpIjgIPdAcPFEmogLt2bDu0zp617uRRFBIQjkZKbjDqv2WJE9Hy?=
 =?us-ascii?Q?pNppkRQ1wmQUdlvqt7I6/5mkK975cvmVOQgA+ysKflu7ETNJhk61JKfau2js?=
 =?us-ascii?Q?J2s0qYNSdaKRqekxweSCjxxahlgxPT7duUgoC/DRbUUkV2ZmVI3jzRTdsWVv?=
 =?us-ascii?Q?jH8hp+QNE2Jo+/i5DDzjRT9imKhXypLbQEQlbUtwtg1cPw81LK3o4xzz4VPM?=
 =?us-ascii?Q?pJE61QYb6HuGiYaDpHJclD7n/+TfY6XfaYPrpXwy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d8b110-b674-401b-4084-08de2972a157
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 02:55:44.4140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOMrFZTHIyT/QbJmAO/VlqeWODRsKZvlip4hT1M4ETDvkNHtCdwJV8CCB2q2A+7G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C38D1C000C
X-Stat-Signature: 3uxiif5bciusi7mz51f78j5ezpzncbh9
X-Rspam-User: 
X-HE-Tag: 1763780320-718177
X-HE-Meta: U2FsdGVkX19QfECsntsWVs46iTKGL+C5kIeoRRkiM/BYveHtx3dqa6lCppqDDIICaByzdWpznGuSPiYZ1OOyOO0ZjgoXKIPKHZjGMKBlOhGQNvyowaBM3TshlrGZ2EWrckKHcE8quvWCRyCZorag9Ew+E2HlPXA+RjPO7473SCAFYSDW1kx2OBd6/rK2AJyk+06lrYev4JtSFbev03sRvojpSrCUwXiGJhAWTtishIDUQqUU+M9or8OY0Dr0EX3U4mZMgzqu/RCM7tBX0fRh+8H3Xnimd8rWhIfISEh0BK6fHO8ILdzveO3bda3HwtAJa10wxnPgYstvxZzbGeGoyxhAVuGb3zW4dwNFfNNHVNZQXplI8K2JMtct8n3bvY1a/aOgEHJUBd8DS8yTGLehwDSakZfPO37MM+t0B6Ub8e/3Sf3u5DjMpxCNGWMnRRSY9Iho7kvTSKL9w9qtbsIFn4RPZ48domU7JQwFbTHqQZxS6llNNe/BHVW/RTS2JwI6Amd4hfNRNB+TnRcnZFTnBX5s/OT+4L+Ken9UwZFW9p5qEyeyHwie3bkSLmJ50lgSCvFfnaXvu7gzm4ogrnRpzSuRUiwsOsYhsl2i+FKcohObu87IsKdcBjuZAyuMppHywpjmjgoT5Gz7wK7V4EaOf99Qz4eg4gPTpzpDeBiJadmz7HuTZ30XpS8ynfqEmER16YTa3Ascv2n/IenZJEo8FMPzRG6gXit5azLbcA2JubYSdsrTd+K3y8VsTdEAhjGq+yRnwhojNLm+dglIK1slz7o6o3ePy+5K11JJpTwS55sU2YoVOKKzgf33UX48TwxrTVdL1adigkBqZBG3wLRWImlUyYRK0J3iNVXyxvPpD+SOn7OIMdLF9yiaPmVvZnSfvM3FlYxJ7oskq1U8ShxtFjHlGrg0PHWe1j0kcBtUpOW1P6+N7Y10t3C70P2uUFWUZvFqaMhGo9/Zx2JZbhh
 sFkhGi6e
 qT+nGTJBoQmmcazwbVY2vi9MPnLiBONUGno60tnBAbdGDK/fmhuqWKO0k3N9qUi80k3W4ktOoYqboNP9hJgrgWE8lt9ThuxjhlGmx8HXpN8mr7Nf3bUD5yUxO/43WD9tYshFheW3PXptBGJY58nOu/C1795Xdc/gl7cc77htokPqdTBl7/FWaIo9sgQu6HoTFsrPBK7bffRV0cGVIUJFLXgSeQOWLK1OhrXrhnJso7fm9qs5dIEV7xkrVYrBSMfCyJYTtw/xQqqoJ1hJu5NMHe6L7b9hNrBxiDEwPFCPjxH8qHtEYG0N9bhOXWJgUcI7IHoE3zGZg5MKJKVOZiKK5uCuVA6qza24ztZi3WwqGo7ywcJZUSBXn1n+PvKTZAk8LPunyI6d+e4V1XfdYmyggK6D8qSW1sVu+INs8VNJtkYVyTUrVpgyFNPiEZJStpQlh9vEYjMBsPyHmn8q0dUfSOzNhFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_order_for_split() returns -EBUSY when the folio is truncated and cannot
be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
split_huge_page*() target order silently"), memory_failure() does not
handle it and pass -EBUSY to try_to_split_thp_page() directly.
try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
new_order is unsigned int in __folio_split() and this large new_order is
rejected as an invalid input. The code does not cause a bug.
soft_offline_in_use_page() also uses min_order_for_split() but it always
passes 0 as new_order for split.

Fix it by making min_order_for_split() always return an order. When the
given folio is truncated, namely folio->mapping == NULL, return 0 and let
a subsequent split function handle the situation and return -EBUSY.

Add kernel-doc to min_order_for_split() to clarify its use.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h |  6 +++---
 mm/huge_memory.c        | 25 +++++++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1ecaeccf39c9..9b3a4e2b0668 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -372,7 +372,7 @@ enum split_type {
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-int min_order_for_split(struct folio *folio);
+unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 int folio_check_splittable(struct folio *folio, unsigned int new_order,
 			   enum split_type split_type, bool warns);
@@ -634,10 +634,10 @@ static inline int split_huge_page(struct page *page)
 	return -EINVAL;
 }
 
-static inline int min_order_for_split(struct folio *folio)
+static inline unsigned int min_order_for_split(struct folio *folio)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
+	return 0;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6c821c1c0ac3..ebc3ba0907fd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4230,16 +4230,29 @@ int folio_split(struct folio *folio, unsigned int new_order,
 			     SPLIT_TYPE_NON_UNIFORM);
 }
 
-int min_order_for_split(struct folio *folio)
+/**
+ * min_order_for_split() - get the minimum order @folio can be split to
+ * @folio: folio to split
+ *
+ * min_order_for_split() tells the minimum order @folio can be split to.
+ * If a file-backed folio is truncated, 0 will be returned. Any subsequent
+ * split attempt should get -EBUSY from split checking code.
+ *
+ * Return: @folio's minimum order for split
+ */
+unsigned int min_order_for_split(struct folio *folio)
 {
 	if (folio_test_anon(folio))
 		return 0;
 
-	if (!folio->mapping) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_SPLIT_PAGE_FAILED);
-		return -EBUSY;
-	}
+	/*
+	 * If the folio got truncated, we don't know the previous mapping and
+	 * consequently the old min order. But it doesn't matter, as any split
+	 * attempt will immediately fail with -EBUSY as the folio cannot get
+	 * split until freed.
+	 */
+	if (!folio->mapping)
+		return 0;
 
 	return mapping_min_folio_order(folio->mapping);
 }
-- 
2.51.0


