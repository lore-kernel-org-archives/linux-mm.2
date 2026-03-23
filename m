Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8B5F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DF66B0005; Mon, 23 Mar 2026 16:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5016B0088; Mon, 23 Mar 2026 16:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4996B008A; Mon, 23 Mar 2026 16:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5486B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:24:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FA20140D31
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:24:38 +0000 (UTC)
X-FDA: 84578455836.06.0A4B7DB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DDC080014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:24:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P+Mp3ymv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdbA7OgcfYruSblOw+4O0Kya7AS51d9Lxzenseo1S9g=;
	b=nSkIWCUirDgd6pPyoaVbLH332TFkxAycuJa+po/QebnfE7G/Vn8KsSTUv+k1zNMMHBuXjT
	6VFTYkz+nf79vVPImenDgi1xrU/x8ofri/lcOaK1tLmuGRRr92L8IU0u3guyX8ppaB/CUV
	X/bGWsGRlk7QXUdbnWTlHlmrJgHJJyA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774297475; a=rsa-sha256;
	cv=pass;
	b=hsWMppRWC8M62sknppYR1f0aTM/q5FetgQwErTxHRRqvvSkDk53shg+2ArmzTHY4JItqFL
	ueEBnp8qwEYij7/5i8ASso+VRTyWAMRosCa+db1JERXT0dZ/E34JOmuzYX727iwiRtR1aR
	re7drT2FblXn/foNdDFMz412Msr7tvg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P+Mp3ymv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2TYHW/Oc5hmw5kqmLu776Y8KQzJ5M0F9pUG79tZFXsaXvFFEE9sszwZZdN3HVPWRbxOgvWEtCH8ss1Se5XCn+ZYXRp7/fnj+Y/vQWG/KpA5XQu6DBRQO4I+y1dKgfoT2FkSvVlQ1npRIV93h6fw5Mj3Sji2vLdP57xj5tLllDKFxW23Kj9gD5VWJGf2GkC6y7aAL51o4L12uJ8CVimAC0HnjiSc88kB1xEicZnDwemAe/Ck8OFm2sjXmZSBznmfcyXcOQfD1Hh2w+B+FYMn0Quz63kq+NoepOEWqQgCYuXOzVsLxXSCZxhsDIm37Qg9lKQPHsneroqTb5AQ3xTMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdbA7OgcfYruSblOw+4O0Kya7AS51d9Lxzenseo1S9g=;
 b=sjSj4iYeG5tqxmWAgJNjTAit819wU60NLDPosyyYkF8xtS0v3i6w+n5MHOr88hE7g1k/FtH6Z8IB3mERoDn0fNVs8V0LD/rojAmJ01WDmLdUObqdcQSDkTzjPJb3VEI/154fDoTBw5rlJZZQf5jdcsdnB50u9F9pY9mBrncianm7KYfg60qgtIW5cX32h1GzQmZ8tR1fIfUgd0F44SaWSjrWYviFIbxN9wH+0WbWaYqoTuc16JEsDIwx/yV5+wLFbwFxZr6A58EutpKuzrVjiHUZOMa4e8EoxkBpS9jpuRjXgtQ4PkMQLXBESIeRYHDTSR2ScabeX37sZ6vsFA5T5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdbA7OgcfYruSblOw+4O0Kya7AS51d9Lxzenseo1S9g=;
 b=P+Mp3ymvburOQl8PGOkRvEmagkg/djnG28GGPlTh+1f3KiSO3HcakeuSybyhR2w5GhBedwsZcgLsqAWcfR/YpOd4l9ZFiQ4M1lcC0pJ5+vr2fVAgThc62e4wMszUvYJPDmgUD/40gC3NTYZ/TBsa73zxhgZxvr1Z87LX1AqsutMuW3Rc/vXZLzQUkLrB1ZOTHqCyHSRL00G6BAi9nsgk3oSxDN3RAMT00pxxfxqWnO+vySK61bELgKXL5uqbuMbcHByPrdqPOxTebMoqITB7G/5FNqk2E2fKPYIbBm+djWcxUnB3GijZvDOhy7egoEY+OMZdPZHQXbgRayxfewi0+w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8008.namprd12.prod.outlook.com (2603:10b6:510:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 20:24:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 20:24:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 16:24:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
In-Reply-To: <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 6179d64a-dc98-46d8-591e-08de891a3014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	xUqOMZOI3rN+mqPKdqML2EtnHPNGdhBtMmRAsghfkMh6tLXRDdwi4nZ4rr1s5JinfSzqa2/lmPn8zIMKHx7R8AHswuwc4dZnsD0io+1/pIFAJCJU/qFoYn12dF19ScMIm+1j8pl31A5veI4rd4uH+TwG+MHWY2+sG3HU8MXsAhoWGgnd5MrCILKPRsP/1eL5ScWHS8WhRDkvyW+WVPLww7khS5r5ORDaboGRRcQLUN8sPMBiBkqEwSy+VvM53OdXkRohuqCS36aR5D8EuRbhmLGoEdhBiubui5erNBMGLxGrauG6QgPTgTsU9GZbSvH8/Uiils8nSiDvJqvK9/7iWWI1E8JeHPu8bKGMrsgwxQM/ZKU75jjTceW5gK63t82L+HZzOTU2qnWZptcvkr2SwJ5zu+MvrrlDRbpV68Lp44A72SxFLcv4U4VIhgBafjgGnrKfwBYQm74Ht9cVHr84/yhs4S4c1nfVSnU0+Q2aU99iw3n1lwnwDXLaCal1sSlgevPirPzQ6SXzTZeOX5dqoXH+lxOmr1cOb/hwl2IDlX7BkD5WPp3+QfPh3XhODhLwWlrz/4/yCc1lZpTxUQiNhbt5Ynkal1bi2RGzhNLS8f4sIJBiZTkza0IL+dREi2q+3wdTLZLi0ke9R2lGjGBxfEcbau0Xqv3nnQHSoiihwSlRTENoyYQ/94C4qXbdoeh4CNTNjXWnTEJ3Xk1M4c3XyGz/OHFyl/+8bJO3D+C8ZqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/6ZXgzP9fm0SITOzvLgx/rPvhGy4wY2hPxD3WqTLgtAEdHs3HDH59kZU6cvp?=
 =?us-ascii?Q?/3QbsWInu8kbVd8uzlONbgvSeQ+D3nAXHuyQF1IVFvGR39Susk9HxwvrmQBj?=
 =?us-ascii?Q?B8UatDmur4qrPcVGy7gpuwYGg/J63q0yZcDQWRZWjIMW1Q3HRgIVwBmd+6Sm?=
 =?us-ascii?Q?HaTF42pebMx4gYbxtxg8ruOA5GpMmuXkSp8E1D1oXMOEi3Z0sPFdKv2n7KVz?=
 =?us-ascii?Q?d4XCXqCuzmYUfmJ2NFDNH7kbKQ1FXX2C7x30GH/UfPrqSIaA8oUeMziIUmRF?=
 =?us-ascii?Q?sSjsWQki4uzP1Pig0OgutTHQQxF5pzV8JvhxanFTJVJxkR8shZMAfTxaModK?=
 =?us-ascii?Q?uiNYPPI+mpWYx/U4QHLZnJfAiGlBY/5vv0aS6dN2lfRBUiIpg4R9eY8KxuLt?=
 =?us-ascii?Q?NsaSOzWqfq3b7qpc4h3I3ohyt7/fdcf8qVkVzBuan7wzf8ry0L+0wmqU/HqJ?=
 =?us-ascii?Q?CqTSPhYPRvelgsg04mT7PdHAks+sDVC7SVlIfjGS1Y1um7XqsI2vhzIZc63P?=
 =?us-ascii?Q?LvktqJmGRLhh/iK7BI/7EhA0yuRqB9aTWGNawfr/0XGHUv3XpHkaJ9pE9H/X?=
 =?us-ascii?Q?4ou852NbOxRo19Bj2BzeUyeUJsD0B1ypW4HzpXsVpYtZnbaFE1+Hqgr/kJZN?=
 =?us-ascii?Q?qk5lGgM6OKqFPy1XOx/aQ3RWhltLr4v9q7uWVKgIgSqc886WGe0WHaNWmzqD?=
 =?us-ascii?Q?Lx2Jv7z9Z+fSo3y9Hv2Gh2htHpQEeplL9b2CcbXrxu6DVuExEAQLlvrReCpg?=
 =?us-ascii?Q?hJJyjvsBZtfkcTwIWJe8vagmzM2HcPr9e6Ep0eInYnuoXNiLWixNCipp7nSH?=
 =?us-ascii?Q?ThmlvmQ9RLmgvJPqtO1noF4hM1+kZ3iPmX8KskOJv96LhHbQHlS1CKhHI6lp?=
 =?us-ascii?Q?8NkuHPKk0xUe3Sy7aX23H04Y+iZhB6a6b8Dif5VL+akticQRbWRXEDdEjPSx?=
 =?us-ascii?Q?PqNzMnVjmNS/HQhMsu0joLoyKnie84zVsGJJvAPxIJt2kWouj5tmV8SXJk9f?=
 =?us-ascii?Q?fveE5lDx4I5snhmuokrbc0vJ9PWPuh5kJv+FQHUw4K73lsai0irSDHnrzOBs?=
 =?us-ascii?Q?bOp1hJpAuvBvusMPkfp561CPguiVCufoTvJ7dXJ94dkOmj+qyddaM6GYw/uZ?=
 =?us-ascii?Q?RbzURD+0GyTwc6wXAvaUofXIrMdnW5i3WVkuee9DCEoDovbmOgTAxLKOqmay?=
 =?us-ascii?Q?9wTaE5uQJzzaxmHTDJn8Qk3jeGGgaUZy43UU2w/pcsYVJ/D4ZfiHL7LAOK8b?=
 =?us-ascii?Q?V++WWlNWpx7EnHpGQYegL2KsUcnbyw8xw6+GZuEqxjretASOli8zTgm7dlUq?=
 =?us-ascii?Q?fnGetBZJSkmr+vmU0doSb49WzLF6yeuNpLxLTXGixlmLnjYp7ZLSpT0PWcCJ?=
 =?us-ascii?Q?BxNrnjP4Rh1dWO8gKnagntGC9inlx1XpuwM5GYxhl8WFfrnzrwPf8s4SDg/j?=
 =?us-ascii?Q?GTm5W05X9sgWreKuReqnvEcwPDBArPCG290N0xLWpQV7xa+eKfPtLHF6vKaN?=
 =?us-ascii?Q?PfA8D83pYneej2f+SwxcdED1/CqgdS77DpTPQ7v67l6mg2QcO9knf4+jpxGf?=
 =?us-ascii?Q?T6otc8+KSQCemg0sycSlQdq6EuctSWt/TarR7sJJN71VNPL+6pDjuxMIKBOS?=
 =?us-ascii?Q?mR5fry4Jriiw2j2PaUPG0FJhlx85zhgEwFPOgQ4oiFj1hs8AaTmUNFEAsN7P?=
 =?us-ascii?Q?mVGsdZNJ4ZJBGKzvk11BnTomp8GvgiUjCLMEb+UDmBybD3Mg0TIFQljphofq?=
 =?us-ascii?Q?kuuH3xpWBg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179d64a-dc98-46d8-591e-08de891a3014
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 20:24:30.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlQUG5GPaHrz7UyJYtc4vonlBTAQsffznDzRRMd7oyYNpjDrftvlY4IhPtiCqdRV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8008
X-Rspamd-Queue-Id: 3DDC080014
X-Stat-Signature: yboq3yb3xp8mm6qgnhfbecx53qnuf5jf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774297475-292620
X-HE-Meta: U2FsdGVkX1/u539JpODzGEKUVxpmQqQGfXZW9EE9eRPK1wLOopcqxPOiv7kAgHQUJ72LkZGBoS1NY2PoZ+A46RWSXwNrZ5dddPnDliGgi15pxQTY6m8UuDfxdKK3L0g0V98pPMd9g09rBEmYdlAzvrIc1+VhTYOyCRMFtdyx1Q/x3mC8cuW2bNbkMu7qYNWjdJ5bjP/l5/yzqJnSE2Gq7Q/RTQ2PBFnLKlC7lIOlvCJvVqydZ7OWNnBGvmvI7b6pERBB8pzeTOtW5z9fu3kKWRHqkmq8ya4U3CMf7aHqsOE2LyIRWR63PM2q4S2Rm2tYyIiHPeGePyEUnfhQdRhDde+NtQyK63+Pc+atlmAry+rh/ZSy1TG8+B6jwuRb+M/fMk5siOnnnvYDVCoLiuUb9OgdtvCOet42iMQdOedjg710qFFHKcUL5pS4w1box2UizoeWKDTgkjJSLxC+aUxdsG5DqdMiOtyADwMQ+rD3XNtrv3J7jt2wp3ERRXvHrRy03axsRRbgnfboJdc4cuR0bm+KrA4pExSXWopjx5qmFNqAVfnJ3JoNHEg86cTKYTAiAFwAcvNpnwKs5Uu/4mv1XLJYYBoiQxOFvngnfEEbWxDCEXAzl/6ARmXyz0X7J16DH4xojADhm5ACBkMMDBjCK0JCJXLIHGKe4rekN+MNQ+0M3pF4GC2fuIFB3u5czZXRkU+nQ62oszM9htfaiUm0CsASP1EimGXhyIPP/1o584ZKbOBHIMXbywGAy5m8OFgicCZsFZlSLDeRvpDOvY74uFZbmMZm6e04tr7qgCzkkST9Pm0uAiH4jBWj2azbjNmjie6wkzOKRzwfknPma6XRTl/PBBMVs16YFYrxiCvp5mqsYF8fjm9AOE+0zcVAjgobLea3j+/Be/PBoM5eWFyTA8nls221KOD171iZ5D1nWZiXrhVK1S+vUji0vwAQOiYqD/eznJAB8K76eKlZ3iV
 w2+0eYfa
 g8HP5lG/zm+9ngf4+5/PXrplKXmnb5utb+fih/816+katV1akFl7q8FbeQMW3+lR6EkikEI6vIt4ZXvCifxvGWVrs5c4L3aaWZh7j6mx/JIzpg+f65oC/JYbVvMJRaYIgO2izwA2p/iBKXIC4E173mpsWC8vRyd90l4Rvq10QQ38DCiPoM+ApFjGtr5iuvo2bl4q6FfqCyAHLzVyXHqxHbzumh4zFUG3djobSqXc6V54ur9w1zMaN7FylmIWISrwn6zfXQg5BfK8UPzJOX2dX18nfYaAagSrsgw4X043RltOznZCFuIXvCGRo98yFYp6tzrnTnaaLOjQOwMZuu9i1GgE+Pztg1yx22gsV7XDJ0POQhrDixqpfbcNRBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Mar 2026, at 16:13, David Hildenbrand (Arm) wrote:

> On 3/23/26 20:59, Zi Yan wrote:
>> On 23 Mar 2026, at 15:53, David Hildenbrand (Arm) wrote:
>>
>>> On 3/23/26 20:47, Zi Yan wrote:
>>>>
>>>>
>>>> My understanding is that collapse_file() is only used for
>>>> READ_ONLY_THP_FOR_FS. If FSes with large folio support also use it,
>>>> I can replace IS_ENABLE with mapping_large_folio_support().
>>>
>>> Otherwise we'd be losing support for THP collapse in files? We'd have to
>>> cross fingers that readahead gives us some.
>>>
>>> So we have to be a bit careful here. We want khugepaged to collapse THPs
>>> in filesystems that support large folios even without READ_ONLY_THP_FOR_FS.
>>
>> Based on[1], collapse_file() only works on read-only fd. So it is not
>> as general as all files. If we do what you suggested, the function
>> will be collapse read-only folios from FSes with large folio support.
>
> Right, I think that's the first step to keep the existing use case
> working. Long term, I suspect we might want to extend that to writable
> files etc.
>
>>
>> BTW, has anyone used/relied on collapse_file() on any FS with large folio
>> support?
>
> I assume so, because for executables you would have to be lucky to get a
> PMD THP? So I don't see the non-khugepaged large folio support on par
> with khugepaged support.

It is more like turning on READ_ONLY_THP_FOR_FS by default for
FS with large folio support instead of removing it.

OK, I will give it another try.


Best Regards,
Yan, Zi

