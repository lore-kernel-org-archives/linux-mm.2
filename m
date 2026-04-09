Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2DA10FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975E76B0005; Wed,  8 Apr 2026 21:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926696B0088; Wed,  8 Apr 2026 21:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815266B008A; Wed,  8 Apr 2026 21:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7116B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:53:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 166A813A904
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:53:40 +0000 (UTC)
X-FDA: 84637345800.19.615BAD2
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DEF61C0004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:53:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ExN/gqUM";
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775699617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztJZPaIPuD8Bmgv4Ulsq34V+ZqeOSPIzzBuf1R6wYSc=;
	b=ri1MJftFiJxig51LODgJbaUbUhWnICIcp7sxWM2qevIq4M0INY5tbHTzJx8GvBD2fyPeE7
	SXV+zTxRzsXXAY6IGpwavID1Vnve45vrcZ0hMhw0DMiIy+IF9U21V8LSJmdSpjuSwm/41n
	XGiNCkdZbqvTTPbyDiMS8xNn2ava/Tw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ExN/gqUM";
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775699617; a=rsa-sha256;
	cv=pass;
	b=5W9+8PGoAMAlyn/WvIEHJ13x9+BmsFAtDREVmPf3LlKQLK7vjgw1Z35aFVxLUZ1DQhqkPZ
	6E7TjWaCBOUw9q1qHhYWl+j/Lc/W7/ztYHzu8NVEZgO59iQBiy+ev357q+sfXzsZBKoZbJ
	nk7pY8nouUfiQ/jNZvuisUOe7qLuLKs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=odwDfhYTDK21wz8LGVZtYXE+cHGFxIF6VXOVFo90uFo4/WTM1k76zjKjHWc18eZLxHfwoPhM9oLZv5XA8Y1cwKuu+bbA83BbwtJ0l8IrgqTSyIwA+/Iy/BzDcUFOVbAdLQNCc2Fah49vwHuQZnd12YY4XE+iSUn74RCpEKhatLadWzYcN1q6l7EMu96V9hnZiOCJUS6SNxbB8KcjIi1CoDBGoHnCAreatZRQT54gemF9QsOqkJsY8RgdRX/wqRUyh0WuSPGqnAyTSmfNVAzIn5kT+AH3EBatxEzHnW/nMb2WNAT0w0x2uSq+aVsiHm3Va7bQLDwWRVnwNWcammMKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztJZPaIPuD8Bmgv4Ulsq34V+ZqeOSPIzzBuf1R6wYSc=;
 b=SpuApEkcNYArOLbFIS9UYWguKcnTfRv97Nw6tDG9r1TfDd/JtyJBMgbBKRcY7+87S1l0FwNDv0knAioDzUsPzFE6MqJ3cMqEn4irQ4lZfxioF1EOnqcG/at55750job8SawJsLSppxVrHE1kG6eq59J3T2+s0qlorhXrJ0mgMGci8deBhC36uQOF8rh9xStq55vw3m6hI6Wx71Z7ynjHlwlBlojT0Y1U9lroRVpP2Pc5wNrkmM/XYSMC/exg2xgEON2IBN1wn8oNkKLQ2yExh9iJTKhfbelTYdQ97DTkum/gnsJls+oLURv2tG5Wt8kqyfZdcBPVyUBQ5FKxjmGK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztJZPaIPuD8Bmgv4Ulsq34V+ZqeOSPIzzBuf1R6wYSc=;
 b=ExN/gqUMik+g5iWSsSRnlBJqBUQeaK0CjpdUPRHM5ho6pH4hxJL2piu9iSkEG8EncouQI7cMj1oWbkeA7X8KvbK4OXsLwybPd+ej2XlekjBmNS+wfe9k/lI4P85VkFwllnrBq+dhKpNEBHh1Xfm8zybWycwrmcl7wn+ABFZnOlKZU2sdAK9S8qGfQu5vjmuLggn9/D5JKGpzk63RThD3oFjIeSKfrC7vXjJu9VXmipxRCopCJsrxMtjrvkkeg95L1R2Xvn5kyVphng/ZcrZsISNNULCwA3Py65lRm2ZKNJ14bjCnRyyATgq1mgWxWMvPzE+JaOOLRKwPdRyYzEyHpQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7818.namprd12.prod.outlook.com (2603:10b6:510:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 01:53:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 01:53:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Ye Liu <liuye@kylinos.cn>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Wed, 08 Apr 2026 21:53:29 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8A8072CF-4C70-4631-AEBD-296AB2258D75@nvidia.com>
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
References: <20260409014323.2385982-1-ye.liu@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:36e::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7818:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d81a628-0951-4153-684f-08de95dace2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	d8kwwqcVbsb+nQHqxFZ+7wn08/yuT62h4AAk/5BDT61l5oSOZ6Ej2WGlaNquAYzyaV0DZXE0W36uFrUyjzNFECk7Xy4guIueAF8UQf8DCPm9Tzg3NV97ViK5+ugBYZS1c/uQJxkEWFLaaP/KZ1i1So97aZM5u05T60uwuNL4Dtw8SoDYbrsS/5CuNCySP0QlcrVeyzrPu3Gk96aRJtYQGhqbpCwLgBKzMttNywFAqK7es3GOtZFuJG04Wi2Af1Ed3T3KtXrlOCnnrh0gcHkoF1DufEM4tF3XY7kE32jnt5IbPNT+6B0ReEB8wex34wxqj3BVVcqjzI3IrRDAhm3lrDnd+onru5FbEEYNvkdz07x/p/USygNoSWu+ft+bB+mddQyc2P4UC63eN6hI+MVbETzDj7QBS6hblyynQm7YngvfwFX3DYCvkMt2hik70OjJ9mEcRQto5CbbKcVyYfjgj8FsUPtSMpUi6Q/447phnHBxbTKK9Sq+3snG6/WFjuLK7ig6YwdlTtMfgBRUxD0Ke+pe0vX7F1eyANSEJoVQ8WwpoZUmHe07M2ZEhMrx4CAfqvytlP64jzSGGFf8L6vO1CWx+6NmmRz1Z6uVkaqqefTOCDlFVVOdOqMzr8DmTJJjUn1R/b++DdV8Haj4Od3nug2z4kd8IDAzmUFtZotL/Xs5aIrj2Cic4y1srsbSnDz7AWrGnVtHlTIbDvqs5U0Zk6yD1/n6NT+Vd0wVb3Qq1TqOQwjfg6NzOsZlhmDEKd+z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yiM72+K9T63kI7ExlcUGWcGLTS0k4x5L2dR/+bNHUgUQ+pzi5m+PX4kwQ3YL?=
 =?us-ascii?Q?wMGBdW4w/YiAiEomxme443c7rdDQJ/wM+HQZnZ02lSY97s+47rXtzy7gUhir?=
 =?us-ascii?Q?cn8km5HR34SK2BWfrgsJxPQj5LD+RAajAUBjyBNOT+yYl5DcJEM5weQ+6+oo?=
 =?us-ascii?Q?40N35AqQN+OijQjcRQdKzyeKtQ1Y77nyeH67yvZCuWBHXKEa51IGnFAi81cW?=
 =?us-ascii?Q?LDB40jHE8jvzSiNA1Mrmy1sjtW55BPI2Oez/UEwgvWJIQMnUHzaDSc2/3TZe?=
 =?us-ascii?Q?4tiS9qF0tLvXCJpYhPa62biFPNv2qer/Hx7G8GXQwaBADVrV8tSlLKhx0kcY?=
 =?us-ascii?Q?AaNAzTlPpLOHUMbM9CW7xQQzLAhARgkOTIFIf0Gv2MdnA6ecGavW7deK88uw?=
 =?us-ascii?Q?ApJ5/CDJnGUutpN70dI9eAbne0CnNhxVRfdzzuFb0jqkdgEvEFeIax2Tjfav?=
 =?us-ascii?Q?M9p4ktNzKS9Yt3duLNj6tXMt91EMLdI5Fxyg5q/oWiizJkuUkJGQ5xMXThTU?=
 =?us-ascii?Q?jpLzgbqek008Nh5PATpvUpuNbfBgqjrM6bARIZktReZsCEDvyIv/ig9doJA7?=
 =?us-ascii?Q?tnTKl4z3PhgvvFyKe/kyGrgkAqUBkwTPPbiNVLbwVomf/Pb1pjgScDRrGhGb?=
 =?us-ascii?Q?ZxpfsvgnFjGw/Y+1Dq4B1ua4D3303Vot4KEpHq6OKCR3t8VkEdDwInQjQiDb?=
 =?us-ascii?Q?vXxMt/JpKG/4LN63ps3y68dGenm72Fs0Ec+BHF7v2SIrEBggdPp4bHX0SGKx?=
 =?us-ascii?Q?UdqOVHsEYMzhwKP5ENQ4QqBXbWNP9c9qNuy1uZmxk6K2SvYSxuwADGCipfan?=
 =?us-ascii?Q?+/NR4QrVq0bvx+xzRtCLJMuae6Vncftmq5w/4ngu2a0MG5voU3bQK6ce4O1X?=
 =?us-ascii?Q?wd6gj9J0divfSYT5THf5y7Ep8EBVLbv2LcPbHngraKlVmkdAL1R/FnlzoELZ?=
 =?us-ascii?Q?+ika/3usE7o7v0AUujK2g/DyJPa+TX3zw4ItFVkbyWisIL521Z2eeC/42WAJ?=
 =?us-ascii?Q?qW9p5ZHZSGisE66rkcZSL76kjOWTcrx6BlmhPgG7k1ouwSnp2tXTR4Rv/pZs?=
 =?us-ascii?Q?UxrhHx4sdDCASuXD+aDxAbnJ+4raRPfuTaYIQxXfPHItOcIF8Wm/zAb6vv3s?=
 =?us-ascii?Q?OzdWOO6LA4fILMpCs2K/vvfan+4AExAkb7f1v8iUa6Ev8mbWfM9kJbokxDr6?=
 =?us-ascii?Q?9m3nPuVI8Imgu/8VwHvEkQu5tk8O01ZD4iGom+WKzMCerGbLJflL9jQIv7C4?=
 =?us-ascii?Q?wcxclJyid6ORZKTz3LWIQhimqB1UXTVb8PYp1A5P07Cvguu9eKzSSkJVhdiW?=
 =?us-ascii?Q?ontAsJYq7LvfDsQP87vOMOk+YIYMt99xQR+sMgb/K0l7eAP81n2g6hPLINcv?=
 =?us-ascii?Q?emv0sv7c52SONB/Q+KVfA0EYscNA39zgAMg8IHD30jfo45JiXmKTH90umdDf?=
 =?us-ascii?Q?AYpKXomeVC9p60nbUH4ast0FjLAqVdMyRI4Z46jYK8s+l+XZV3hUj3okYfBI?=
 =?us-ascii?Q?8KHUWg2EnW+hS7c+JsV99Lygq+dDdzC/NNBd+0tHteuaYPao25HDO+9YtBNc?=
 =?us-ascii?Q?l1QWMjQ6Lxsk4gQKqj8DMWJvfcUAhXRTLdJaQXQJPh6fIlBpqI3BrK1xwudB?=
 =?us-ascii?Q?PKPNsI3d5BsS+xEp9U9o3l61s9vHiAp4VQ+Qk1tkNVdLVlV8p3Csbez9PcOT?=
 =?us-ascii?Q?01gBhZKzzYPU7BwXCp3INygr42kiJ/LnWJXfb+b4rWZE7EUOw9sWurhA+JEg?=
 =?us-ascii?Q?7iaoSI0zcQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d81a628-0951-4153-684f-08de95dace2c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 01:53:32.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2Vqk0SiuzzX961edI5Hhts9qmm0As4vIP8KZLnZZilMWfhZenRWa+lVrFf8HebM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7818
X-Rspam-User: 
X-Stat-Signature: gh5nsg8ikng8rfcpddgmsazta9dqj66n
X-Rspamd-Queue-Id: 3DEF61C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775699617-303502
X-HE-Meta: U2FsdGVkX1+6lj+EYaeLJDRvfGL9LQ1SWzNRQMlk1o79DlkTfmOJQ/jaXBirXFjeAqmZW2SSVCFo3B4rmsiu+F9OPwJ1fW73XLRv0atanmuU+54/ldOkFC5RzGdgwLsXMKyMyAvP+ZpMIpdInRvMycS47G+YwP9MnD1jzeyGXbSrfM0kXhIB1H9w+mJO8JYDCrsVm9qFRhcTavOhAjDmjeCZuLRQ0dHDG+wBrarLXCqtQQe1QQx8KolWWRqxG5S4WOFC8MWC7liu+6dmpdyRQabRbMjLJeqZ4SQ2izjzoy70WkZsrhoOM+8r4FZSKlNeVTFac6kSohva0lb2ITAFTO8rV2jzlo4EmZfFLf7fJXxD3nfTb5NLz4cv3Npdqh8A3cfanjvoFJUn7pGhvjCv6o9Tt9n8Yilkje330SKRevbnWbGrNkTJMlSHFuTv2h6pr50AKa4xknY+bYGWRKtzjfIKZRb6hm5qiLBSiraosBFfwwGHZtSLEHv0AfMwZzMQqLO8amsbGJngm5Lq7Zb4YSOuD/qm1h8qKxzw3++V8WCTnE32mnwFvM8dqkVpwKxmltC1QkkuKykOB1Y6eRB942INPPV0fEla4fW4b/w8uuMHNp3qYZofrihf8mIb2fxjdqXhtG8ejX5l4hYrXoV6N5uv3pFzwPwPxFSRzwGEKAm2InPuTrD3geN5IA0W4JtI/FOBXKTw4+JzEfUmhpGnz9jCK3IET+oR7wmWEm394gKMNzK5zQ9Vq9lF28irAbPUo0DDGAiomRBHYEZZtbiDOFH/fDSOfzGAR7urrmnSeDyLg8OH2at0aYRK+3ojES9FitJW7iYBpMC0DrRSdEPDFdHZPx3UfpC5sl6yWyu0aLdwA+0yCnMexkrdNG3/dAAJKdrc7rMYocDmLvmSA27ZMNIfiWUTjul509IL6q5ouuO430ShaKyHPp2FcOelSXRlID0MqQmfq77o0PtwFpu
 Oqhza28o
 5VfXr8jqNZVRM+X6MsqYNQdSSIMkH67zkDSKJEcsUPt7/u6g0QGGla9yOru/93K+KRsFT/a2z6dU+e04qpgW5loXf/qUMMHiA5U1lJTJXMU8YqUPeCO9YqYokKZHJG3kSaBvy9hq8YWi9NkghIG1WSdFJxpXQqQ8cqUoRFxJSTIiIKHiARX4rmwisr6fls6MBh1FWbjUSS+n09b4Mg+6AQE1csG88TjSAk+cM3qOptBZ08Eocqm0z+WAhK5yoYo5W3r2d9ByanpW2DraYCz7HAfKS8ECbfMT4SIhiJdEtxmfnDnGzwo+ascuP4upSZ4QQfcgIOmWV514EsmXzF1e9U1tGv7vzYBmEt2bCohDnt7KdQ+POJutpCtiSExnmHrjJxOYq6AcsV/Dyz6/19zcXxqPGDnfv8L2iY5+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 21:43, Ye Liu wrote:

> From: Ye Liu <liuye@kylinos.cn>
>
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
>
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
>
> No functional change intended.
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>
> Changes in v2:
> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>   consistent within khugepaged.
> - Update the changelog accordingly.
> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.li=
u@linux.dev/
> ---
>  mm/khugepaged.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

