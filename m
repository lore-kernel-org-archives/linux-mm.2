Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292CDCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1C780180; Tue, 28 Oct 2025 12:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1FB8013F; Tue, 28 Oct 2025 12:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4426A80180; Tue, 28 Oct 2025 12:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2E28013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:41:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0EAF8892D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:41:57 +0000 (UTC)
X-FDA: 84048089874.13.839A09F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6ABA180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:41:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hwS+AunW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y7R/rCSk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761669714; a=rsa-sha256;
	cv=pass;
	b=RCyTlwBD0qUwwVCPfqFaR3pGizexR/vEfr4/gRxLvtGSgVfNU+56X9X2+w7CGjKgOxItg8
	T1qnHyafXa52UTx+mbUc//To1gQDnmThtCpb8Fjz3Pe/cugL1+NcN77ILIrrLg5Fan3DUD
	mqrkCB1ftocs5O5L3LKZTcyGVGdkatA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hwS+AunW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Y7R/rCSk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761669714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aykUtKRuLEWz4t/vVyduJ++uCuxUbMeeMLhfAbbmEwU=;
	b=J6qIYeG/er3474rfUtEtpDpyHx30/eMtV0qdlWxaC+b0TIjZT+M4/2mpsXUV563WxwDs/g
	0R4su7k4QHi40KDPcB6Rf199gvjjIUdGJ4I5eySWLoXL9igK5pbuuPI8u/OOV7zgA506qz
	Wusn6fb+KUWATWpl7U6T+Cpx6U1It0Y=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDhWP019404;
	Tue, 28 Oct 2025 16:41:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=aykUtKRuLEWz4t/vVy
	duJ++uCuxUbMeeMLhfAbbmEwU=; b=hwS+AunWDNfB7JH9aWCVrVPvTb9ip3MbyL
	IJUeDJK7x7450898W+y+BfwjC3/sQFUW/Unni4am2+Q+KrYXhSYESp8Lk+VcTyOB
	dVTCD6xRnhO9sUx16mMdoBbYJP+S7jVNneDQf5he3XoSSrzoPU1vWqREpuNZhNNz
	GQsssqN3nInjeBq6DEPP/vI8jMP/CaxT6gI10VqIHO8dO9a+X4sRvuHTAyOTjsI8
	XZr5VxTb2ZAxYImBufYSbHnyK7ddaUSnRrZ2Uf6XjY/Qe23gTnAtUPmK6FrOhNRL
	ZUH0r0V+ROAdKznA9kvbR7y05vODRO6LVHCcuH6ToBALQoKaubwg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwm0sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:41:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SG70Nh037432;
	Tue, 28 Oct 2025 16:41:47 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08f2p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:41:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cFDIST54FVo+DORlMgEN2DxLzYd9RdLhTgj6T5i9eaO4LdElvaqbvFHOY2vVGuQfXZR+pTYv7Q8P8Jv/Q9eudfrHMc48wz5xG/1Gg7TMPXLr5ogr2+W9b5qkK5zZ20bOpISPLwiAValc/5sO0Sim9m9H4xzULTOTqjhdr1MO8+NVCm9p5DOVorVYzcHaf7PfZVZXWYfUO2mcti5P5bjHUR3kJT1thpmekDRJBRbCdLWUsnbXztjtwpVBvejk/K89RVfneki/n/NCEMqXbUlmmE4iNSZZ+W87tyT5Aj35qBT4KN7l9eq0MewdhDJI3nCfkI4WQ5b/T/phHAMFXDc7tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aykUtKRuLEWz4t/vVyduJ++uCuxUbMeeMLhfAbbmEwU=;
 b=CKXzB5CzcCKrwTy9THStJ5KbZw8WmmgbT5S+OFmKbOrUwE3V+DfO+yIAWU1ms2KRbYtnSQsNiJlsRF+XAmkS0zL3S8GtxfBT+J++OowTnnheWDAL2BHimhzwdBfJzD9yV1qgFbobOJr1zWmzyfKVcTprDp+Y54W4dGecaJi8dvnyTNIoscndEX2TKVSY0aDY0E7MZ3JXfcwYT6IlXNDiu+ePDvDQkWBlL+X8xbipBnSHbgmPyyyz1mMoh/Qptllgyp3YiCLED9WFAWynGKg1PMUQmia9lp3xD47KPUzeu+RnFDBj7Q2490kLgew7g1jN38K/2ebrCKdeHcANAm+d4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aykUtKRuLEWz4t/vVyduJ++uCuxUbMeeMLhfAbbmEwU=;
 b=Y7R/rCSk3M57tfMyTH0QMu7unF9XyDa6knNHDRw5qXpMGdT98cx3qBxIjuwYfKESKpKRKXw72rangocvJaGmLMCNFdDuU5SBuwbM4zfQfK7347Qz+/gE3diNZngtlJhxjmLo42yLfdco9+eWPxRdgxibAV+Kww1lFibhGOJobb8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5050.namprd10.prod.outlook.com (2603:10b6:610:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 16:41:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 16:41:44 +0000
Date: Tue, 28 Oct 2025 16:41:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        "open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: Honour writable bit in mremap pte batching
Message-ID: <dd6249d3-3a2c-4eda-9b3f-bcf72a4d36e4@lucifer.local>
References: <20251028063952.90313-1-dev.jain@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028063952.90313-1-dev.jain@arm.com>
X-ClientProxiedBy: LO2P123CA0106.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5050:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b6486a2-317a-4729-aa0d-08de1640e160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HFVf5wb892OvBHXbQNcDOiWdq2nyoW1brbzGxvP62FjdUIi7uhS5+SbSPbUz?=
 =?us-ascii?Q?KDyHm4EO0PisrZPZeEbcTRlKWNua8bgi9Pnbah33graj11qZJW4JuaE95pqs?=
 =?us-ascii?Q?0T+RUv4E1L/cl5+C3OYtYYIHlMnCKBt9/czKryMkZL7KHNkvhfq8KoeqQvpt?=
 =?us-ascii?Q?LgRjqKql26dfuc6mJRzpjMu8NRFxaGIA8WbET+tUDsaXglZNUf+cvL0C+GFA?=
 =?us-ascii?Q?xp6hmW+qaL9t6MjXm8GkOSpmX8iN/NUqIcFePiuzVY/bg8YodPUJQNynXLdj?=
 =?us-ascii?Q?5fSv1fd6jNC3SqNdghAyx25mnOmt9MRPoEiJe+MCpBKJNV0/2Hrsm4M49JGy?=
 =?us-ascii?Q?ZUTwyBm6KRSGgOdCgXd21gqSR3Go60hry+lAkUHVj7puPSsgVEHPxZotx2Vy?=
 =?us-ascii?Q?jazRTMVc+aarLZ2OFtCBIUYh0jQUT3MUvLKqltehvhaUIsb1Q+NY9d4CmbJZ?=
 =?us-ascii?Q?KQkr3TyLIa/POW4EmhU7HxET1Z4pO8M7pZy/Ya2rWh5vxMEgfHyJ5tiXQ3D7?=
 =?us-ascii?Q?tU5/7TkjjXty2TKC0bGjRzI1NCSpAU/aLkTrrHpGbKvWyQ0l8NuhEWTf0HFE?=
 =?us-ascii?Q?HE222kRCKtCrukqTarMxCfxz671TwisxqJZf+8QYBQ1X+2gEuX4OTXgzdha4?=
 =?us-ascii?Q?YCkNMm+zybnSFhpILO5Te3cWILD0edfzIU3bbL2CUNqsA71qVgjCAL88vA8I?=
 =?us-ascii?Q?TJS9ofzCEggp3DnVYBm6bFii5SpLY0xNCKYG3LZM6aPg0ROWu0D39n/Xal+A?=
 =?us-ascii?Q?ILdFKzWxijVWvVTlidQmZnIufG0PoVy3go3GK8BX9bOKRqWAs30ARD8QQrql?=
 =?us-ascii?Q?HciMKkfY+qWnq3hDKKuEbskPurv7rHfvde5nJ3St6QDisU08qX1xsV1pKdpl?=
 =?us-ascii?Q?/tw+5lZsTRjtYhFFW4ytO31zusQJ/9AyOxVYbjkq+4Px3H7DvbiT781/Uzza?=
 =?us-ascii?Q?QbCQVnbEAUGJ/7QHbhV9vbXeoVp+XFAgJ9lapIysmvcFakZZz/jqhJBcESLl?=
 =?us-ascii?Q?dlXTGMNn9Mt/0aIl/fsevOPlFWym27JqcebK9/2s2hWul77DZcJdbVDBio2e?=
 =?us-ascii?Q?44dl7+RLBq01m8RoXuQu2TXhA51wnXVhtamtWftMJt78BGXJvns07X7+HgYn?=
 =?us-ascii?Q?SmVcQVgOHbfgP0whTPUOCEsmeijFNoLqET0voZnfV89+qaovfcqLiPQKxU7v?=
 =?us-ascii?Q?T0tRPEOlXSzNqsYpn2aLXVW97HkJcKPyqgpzIaKc8IxVHm/TyaN+EgnQARYX?=
 =?us-ascii?Q?uk6Ktv6vDV3YNLQm84F/wM2bZhUuobqw4mzAcX/4q55Qg5yNH8jQ6/fldKRP?=
 =?us-ascii?Q?oBYJzqJSm9HBqPUyboqHDYpswEXUJaS3hRb8cAngLF7A3gWgr/kpQomIr6h8?=
 =?us-ascii?Q?5lK7jBfWm0nkLsi5GiGaBJhfABO9djgXDwvTqF9EYESguNE0bHLMiQa2lyBp?=
 =?us-ascii?Q?JYDAqGDAYIG5cU0auPJNXs3fjbEoFvDG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2qoyXtOaKca2Ygx9A3lUb5E7DgluCKOHSD1hSG8Sz3BQ/N5AixQOlViWeIbc?=
 =?us-ascii?Q?NRXOAUrscdtd3oO3T0rWonCdA8xcsZ9f5hyF0evJLU99B3EddSGOFLsxBGY7?=
 =?us-ascii?Q?6zb0RVnVep4I3phq3Uv0bJBkCkLtZ+dRXRxElCZFJpdbDDOIBn91EwB4cHNA?=
 =?us-ascii?Q?oZvFe/0J/VxW/LvXH0dFPFwet4MfC7IBKfaqh3u8LEbzjTSgsTfCyEJgz8lV?=
 =?us-ascii?Q?iT5N1doftv66u1fZEom3P9cl3reqbToSciVOzH+8qkgislH1KTeAZyr+ugV/?=
 =?us-ascii?Q?QoH4/di6+KYumwGc7WwCQtGPTXvLyxbMMZwWfnInOyccliHMqNTUNs4FS0J8?=
 =?us-ascii?Q?Zih7YRikzuevp0K+GzNXv9lH50z2dlBbaO9oiqJIDLqiWievzDcKspnTEVGa?=
 =?us-ascii?Q?hwMXJICv8j4qiTLP5VQWB0aLXeVC5DpK+sMfiY0J0Vvoy7DwEzWxdSTuadwg?=
 =?us-ascii?Q?QnvY3KcqQkb34IwZ5gyX9vUUWkXhMDs09uSK4JBLwQbp9FW7CiEDj7FVXxql?=
 =?us-ascii?Q?9MClM/GHh4vbIRwMFsdhxTdUnD8EVyweM7KkYNyJ7xpKNdMbLQN80QCGKC2o?=
 =?us-ascii?Q?UsJYjVJKJmjEp95iF07980AKL938Pp72kwqezkq4hWJoEa8cQX/1EKN5rABK?=
 =?us-ascii?Q?FnN0bU/yOSqIta8xtHS9/pzuDKiQQxZzEibd8o0zqIcS2GzkORcvSY1sQ+w9?=
 =?us-ascii?Q?ukFg0CaGxiT0YLmesB0lA+kMudzSC1Y2/s+597eeT4Ae17C3Y6GnEyVK9HAV?=
 =?us-ascii?Q?bs7i0Y5009L68VPEw93wA9hh7HdcanoG2ImHkr5g9eIdYpPtZWh/1a5bepDC?=
 =?us-ascii?Q?4m4R3kHRUeHsPsINa8aj3UtWcXA4MWUjPNX3jEbGlDV7qBBhTZ5Yqw/JWK23?=
 =?us-ascii?Q?JqP1HqzE4w+w/D+FORx1tFUkfSRqPJMRMFPDfcoE8Gqt7vXk2z2zbN7ZY1eU?=
 =?us-ascii?Q?xKaWMxoT7nslp+oz59HyRyYgW/ab6grn7dcfiPAC9d7nmeMFr8p2pnMUAc8A?=
 =?us-ascii?Q?8Cp9yKtPDoYbXp2jF48XQPJMyR0ITCoSaW3u1mn+PsGTf6vxXWzE6hlDP0Nq?=
 =?us-ascii?Q?8Ohl6RvS20yToBGwvbF5TvBaMus0AJPvTRbT7ag0TtLAknVYVbZYFzVL5CeS?=
 =?us-ascii?Q?rOohOrcyXY954HfGxmXhgnNV6CxBP6IILEWEi+xS+C5HsL7b+sGELWJ+1pQ7?=
 =?us-ascii?Q?OYQC20NnEcu0XHd0pN8aeLJkY7HADsU2z3g17SRd54klpvJMjeIqWmteknl7?=
 =?us-ascii?Q?gJRZt0psKSj4+iymn6pNGLKyYeAbxy839usEA06oA19gyr2XADCoQNt0QAqJ?=
 =?us-ascii?Q?3tNRO6GvxZGfj7YtYFP+kX8BXLjTDZpEe64a8gkVGam2gEUrqcPi3mRBbqt/?=
 =?us-ascii?Q?w0gOaSH5EsJvAc2pCarJxMHUcJkz/h+E+K2GPecjsYc8jDiyJFsq73zJJwcT?=
 =?us-ascii?Q?NTK3FFRNBJeWVQvGAPENRb1mVlbH54MrVK+lybtH1CLCXU2ww+XQIUY8NRXS?=
 =?us-ascii?Q?85mAefqXp/YAz2/fh7i9xjk/cDnF0rurVkAWtBS6Xyvh6BOROdM0c1WNWwzU?=
 =?us-ascii?Q?1JfjZMy8GrmlVIMlwvM6PqqziAql2XF4AOyyiUhkEaenC5NT8DtkW8bi2AO2?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eRWxrgeuUi6u4DBHBhd72WhSMB7EWw52ovVHIeUgcFWDKxH1Meh7PBocukPUV0E7RSAJm3KCXijzN+gAO9Kit56lLhgVX+tyrLeplJzhhS7ltsk1T1p1SQ3uN9qiZUxoaM/xT7LzjD4bhYCGVYJ43MGiFsfk8/hpYwdadbnnBqPHhD8y6d2XFl+0pOOPI6Ve/v+uILnLGrhPKptS8MMHuvrj++JeABVRhcNcV23aa9TYmnwhArHpwOKv34pvn6QdFrDAOWmel2axnD8yym0GjzMCFIqhOeI1eNb0+uy1AM6bDnH6bws8wSFtgw9TYMEOiEQ8cSYciwRsfb68z7SDiFXAODfOArLw4By5i/4rkvRSxqy9TYUbr8gtmIUAV/IpxDIDXFLTO2So1rt9uK1VijIYTIX0Oo667wyjHf8168cFnq0t0FEXJ1AssqAJP4RqV3VQBvUbYkUPCWDvMS0+EMGx6ZnR7qUjwtkW0MmQcoEjSI4wqmuXVPJdb647gGP9pSrJaY1BQ3cOwx7Mf3jE23TIQyXZLPn95RIOu13zZe8BhFgvz7QIXITHFnrWX77aXHL1PQjKXGws184XbHZeEGKPET5zYLzrSEgVmxYaTnE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b6486a2-317a-4729-aa0d-08de1640e160
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:41:44.8706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bz7uvDGq/3V/9s4StLWdKcV0aLyFmw00p7SSdOUAABBO7CcVxgzjfjxbI6Yz2/MHFuU7qyYhYxkK+h608+N2/aQarrnVHFs5riBVlx2ySZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5050
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=968 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280141
X-Proofpoint-GUID: yJhcd_Hg5_19mQcXNMYO2KOOhmVh2kVX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX1yQWm2YsISG6
 5W9BREAljlAQdnMD53ZejctrzP3hZbO1Gu1myiCcxXajCzWhMQFg1Y5IGTJICozGdZVtM4mNZID
 lwruRv+RSzyqCarbODn8oQ8iuNhocw1efSA1m0ikb0xjIYVdsD2h6kUn4xSwv0MiIIsda9b898Q
 jDXZyI2Aer2MtOD7HxITwPL32cztvqvOwO76823ze4bywDmDhEOJR23pxnZKfL9Xi7N8JcQlZrk
 QNKAWNc/9/jXbszqoJ2cjdRd+DSXz68ThgZWZ3a++BnO/T4L09Z4xozLSYkjp9KaSQM4odEyuor
 cs4bZ62dbiseQplmjxaKuZXDm1p/WbDbrDrV+AzOp8yhz05k9PymsDwsxqX5edwZVbJdeWPmsBB
 2hONiWTlIzvgzsgYiiEr6y8cOT2VYQ==
X-Proofpoint-ORIG-GUID: yJhcd_Hg5_19mQcXNMYO2KOOhmVh2kVX
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=6900f24c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=YODceB1VSVCFG9OjeUMA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Stat-Signature: mm31b5cc8imt6nkemgsrto791run1fxd
X-Rspamd-Queue-Id: 6ABA180002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761669714-707341
X-HE-Meta: U2FsdGVkX195gXVH0sSX5Eqxm3L4yMDGdSJ9tbGrJ5IgYpRExUktmAqNhu9EanW4uWA1+ru/PyQ5P5xQiXn8FlTFbYBoIx5r5vtgyl0/QB3gGr8EvetqgPoCsoOs0nsY7LP0a702Xd7GvkybRnLI/hHBcueuDLKy207DuZGG39e616PcikE8Sr8ouAy1BEIo3uammJq0EEopFeB8xK05ptWo9ESjhsa2T4dHsxB5JbJY6aNcXzOMst7LHKmGuIR/BsZw+syIySfC+IOcEzs4SwdiWwEQlzolCDgkkoj2cl6/PzzrAQ/Y7DoriniJvgWyWOZJZIrhFLjmMPJ4bRv7/qPj4IXZWnCnAqw92MtCADEJ3r+gcaTJRm1toXlZ+b1VMHAE5NGR6lG9O4ryl4r1JP/ffyfQ1VuXMCbIiq/a03j+A8BFAJ/h3aG9Z0yucSq8Ju8c+DWVp7KwE006wnEAQvkP02mbjw5zmj5JHLzViixkrcStscedUrkoze6SEzFPKtZ9wmQLctnIiuP+0uQVLmaNG6/fFnX++zeC4ZOXO32ciy8+fQBqwEf2B7ELrllaLnDo1awvajdDta0K+dePYqG/tY3oyO3vXXdRg07cHlDBmM45ijqTlDMq9aLZAQiRsnf8MXzgkLy8MPrHNk0Xn1dD17Xe/T7vELm8IxhoAJD9TBIdp16XJi8HPo0aVqmFMuF2fsOJNZnCvUZJYvsk14ObSQBmmxyevDr9scuBLqeAftsJEwzzJ9iDztyOV7qbA4gPM0JKf6WS4mmp0MQGaCa+RFK4yz11gfDKi/wHkKPsb3aDHUzV2etlzVw03xxQHPkUYX3O3oz66WAchy8QaxdiGdzIuq9unpvGotMAHsrhLIcyjeWQPbPYxE7LSJCoyFLhQ+yHt3ZUF+AciqmXaLZpybF4tu2MWT6GzaHhSC2bWeTUOW/IOR35TbMt3GsqDUyJblawjb3OL/xIehb
 +rJeuhFY
 L1lfC/te0MpJjDuH8keBh2qkdtvDNjeB0XHkVUnDIy099veTHVrOVbKgUb3pc7QZv4AbETscXe/Z83R1stt4GhyiFdzYK3Tme/rtC44FxhbwZTYVgGI29Slpbi5rxLuvl9fgoIQoMkqJeh4yx/4H0lKdThXCmHvGi1osB4N25Xtjx/Sy09QsP1BUMmlRLdi3gVGjICGFcqh1SPc6Crokb/kHjq4TRAeNZKPIlL2cqXFMj8cK1pU+j6H55pziEKgR4UX6jAPzpia3bjsWLBuo3J+ZFQ4fZ3LRktgb6AocRLeRRLLbRoJw6/Muukdet2bTs2qRKy5PNBa2dMHhHajjlDOQ+hz5QczUn5vUo06Ll0SF/BvGZllNzaSvMoM96ynZqud96qUFTFN3PN4YpKpyRU2OuDGb0zy+dwnjT7ypr/G04z7rb0n0qu236DXuviiMLztIYrmX48lx43e2NQE4pfr2ldxYDwnSt7FKQcYDLHK4JgE17A7Z0E4TFG3i+9rOZDUEjbInOZyfCcQULZATtI9OYouW0DM0Ca9RAyW0TsitS0DxBbCMu5BG3g0gmq8Rbdv3LND82qIhk5YHgjJgpWlPA27OaR/zMYxnWw4RGmAjqotmh7/auG6TpM/prVNTkmvz9UIBdd1psbnMnX6l75eauvEgVzg30me+kOPVkddETLtxWXQ2fbhIDMyTFdMGyhohjS2DeOkHBPGVRWwi8+nQ/6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

You'll probably get a tag just from using the British English spelling of
'honour' from me :P (joking! ;)

On Tue, Oct 28, 2025 at 12:09:52PM +0530, Dev Jain wrote:
> Currently mremap folio pte batch ignores the writable bit during figuring
> out a set of similar ptes mapping the same folio. Suppose that the first
> pte of the batch is writable while the others are not - set_ptes will
> end up setting the writable bit on the other ptes, which is a violation
> of mremap semantics. Therefore, use FPB_RESPECT_WRITE to check the writable
> bit while determining the pte batch.

Yikes.

>
> Cc: stable@vger.kernel.org #6.17
> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
> Reported-by: David Hildenbrand <david@redhat.com>
> Debugged-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> mm-selftests pass. Based on mm-new. Need David H. to confirm whether
> the repro passes.

Given he A-b'd I assume it did :)

>
>  mm/mremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index a7f531c17b79..8ad06cf50783 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -187,7 +187,7 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
>  	if (!folio || !folio_test_large(folio))
>  		return 1;
>
> -	return folio_pte_batch(folio, ptep, pte, max_nr);
> +	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, FPB_RESPECT_WRITE);
>  }
>
>  static int move_ptes(struct pagetable_move_control *pmc,
> --
> 2.30.2
>

