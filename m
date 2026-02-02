Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E00E7315B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395F06B00B1; Mon,  2 Feb 2026 06:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DC56B00B8; Mon,  2 Feb 2026 06:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262826B00B9; Mon,  2 Feb 2026 06:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12AF06B00B1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:39:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B956CD4B8C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:39:20 +0000 (UTC)
X-FDA: 84399320880.03.95FF65D
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFA90C0002
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:39:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gA1CiGEN;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
	b=C4JrOvVE5cJRKNJ2vchXbWkjRe+sPLbR7aC7LP55JbUgQOyjBhtqBfcL18joNxAlAB8ir1
	9Son5Xd61Hb8s6KLpyQP7p2eMAXpRkUTVkUGalvE1EQ3ZfvWQLAblaAWXOqUbwhQ24C0Hk
	d4f4/RvVo+9GZeo1rGhgfk9IdqKDVG0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gA1CiGEN;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.46.21 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032358; a=rsa-sha256;
	cv=pass;
	b=qvnes/M2JpVNwxl1lNo9feTLbDlIuaRodqwYdYE8AyRcobkqzuXg9AdBOMxzxJf288Pc6e
	ymVH0SIxL9LzazBVFT/xXE9AHYqLeHqDZSEGuCgYDR1kmr+kja3WDNDqLu45YGwavmI+8z
	cc6FRGjwJnNjQ2gXmHsB1unTDJ077YU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/r8M2nAeJtQhWXdC/Qz/ErQGycnaYJiXrma2jlQabxpOZRBs0xphlr9Ay4KIdo66I93hdgUJqVgAdRLHzkKyXDCBLp9oDXtymG+pMpnyJKqTp8aHhTMCAy5yXMBEaBUOwLaUpVIOqilGTZAROYbwCwMFtI6HDf90Wdkn8Gd/FtP36sWsGkYNOAPCYrdHQGD8n50vPZ7JinDoks187ybxHQaMFYxo44wn/tat0Lp6esgIguqrTQr3CfRccA0Cs3oqsYZxUmOrPgIvp6Rom1G3CBZEuzYb9kx11h526opIGBLDWSvTKojwXbSQEhDCG9UXNCwSF/dOMvQtXyvAFbljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
 b=vTDFRgeYOY5D8i40KMaFtU8av4dhFJnBI5eODbRF1hUwQWSADOUrG1s9frCZ1RyaSa3mv0nV45wnd8oJhy1Zv7w8pQiOOLIyy+886FHxtmf8o0f7dHm2Pnso1lgaZ9Hff2Z91z1agreB18UMUf5RFect2TjFVJiPd0lIJ/pYqXlyBLO9uqWbZzyVfCDCjbPrrIJ3tpIfXbY4U5tY/SvehTQjalA1zXmQ1lketRm9o0CjrZeQlww4oHHeMDgF6CJJGCrPb6v1BOhVPltMGCM5G8ENx9FFoXJTJZyLW3HqJswxjTisDqe4poeoogYh3dZcpeGlP7iMg6mWAD76iECGRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DxFpVJv/av0DPVhGRwmcwo+RxumKgoR9M34Q2wLSfA=;
 b=gA1CiGENg8zBtvaxKF25xift8ykuw3/zbIfHX7aXiNGLQHa1GMVjoAcwkJuxkIFxuYudyST3cavXW6lCqbMJR9eR7U9SuSNhas5pUMgvJzWHCcGEXsqdxTCQ6fMVpLpGG5e6LtsQuPudY1ZtuwrpMxNofgcDgofX4lAsh8NDChVbe5ac0oxwKgDt0c61wsfQB4cRCAKaFc4gYVfcCFvehwjhUfXrSPEOpdMFyFzpLiFtQ4HDzbkRVmXbchydBv/F3PjhyNxLJ2zgXJb6VLmGlWmuWKAYnE6FxpDWGxOQMh6cGTmbRgnjAtq79RZHEbGRGANXucjGeppX7XEgcD3Qbw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:37:14 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:37:14 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 08/13] mm: Add softleaf support for device private migration entries
Date: Mon,  2 Feb 2026 22:36:37 +1100
Message-Id: <20260202113642.59295-9-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::34) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed315b1-e442-46ce-5050-08de624f6920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i5IVHNj0xxgxfEScIht7IxpfkBK1PzPDhzJNfrccKN3sP0hQD2iMqp0sT3Ks?=
 =?us-ascii?Q?WcDvUn6PWrTSxBaTDpSBdrQ1p7Cepsv2t8qU/g5Wui6CL8Up0zmA5yv/x7tg?=
 =?us-ascii?Q?a9YuTZ5/av86yvcV1o6TMOqVR/VsSpeahwlMJ2hDskAX6qFsVS6AzPB9xcjP?=
 =?us-ascii?Q?NcYfHEFG0u1FgcfJ4hSd7AMdlph6mPiWN/XTzIU72mbXk3ZTMFgsh2a5kQLi?=
 =?us-ascii?Q?6VrNwNi2YHQjEdEKs0eJjzbQctiQPe1QAXr7fLJnVc1+GcnB14ngGy/WQSgH?=
 =?us-ascii?Q?rdNX7KSZA8WCJXxXyKrtXZle1JcOAB3iYxbAMSJwPVEM7L3THAap3auk2n4U?=
 =?us-ascii?Q?gO3VFgx+Z3ULwaeWTeZ8+hmSQcj0sERJz0b8aRls1AfcGzLybiJG69ICeX1N?=
 =?us-ascii?Q?iGWY8xFkLfV0MlSUupqX9FQ2WoRnkk9ewsHgngdqQweb3oc4E4iNRi+WazaV?=
 =?us-ascii?Q?A9afKcjKaBW9DASEt7rnegd8/h+2xR3E4CuZOoCLf30TYcC18mFaIU41vtLf?=
 =?us-ascii?Q?X5L0FYD0lXpHZMP3svZnmt6DBZwAESz22eMS++JjslKrDlbSzfkDgyE8Ko/j?=
 =?us-ascii?Q?XvuNd1YZLx5PG3tuABsnnHOahZE4W9A+Z1UJTvMgElGjVpX6W3tO/UG6iHKL?=
 =?us-ascii?Q?vn1M+8nt76rLNCV0ULfQIPy9aFXaGqh0XHg73IY1z4k/eHXu9L41+1tQ99Rt?=
 =?us-ascii?Q?MBgDorotK4y0ftqQDoWj9G6j6+CcWuPZxyrNGqYmU6+ZmgRNKC8Fnl3452y9?=
 =?us-ascii?Q?BPtEKLXGC21iJas5Jv+FnKQTZ2xETXl1MbxIksA2oDmBe24H2Zgqeymx/vL8?=
 =?us-ascii?Q?1pOtpUMMMouFE6oOaJqYxtK3jtquIHGZVJcplJ1Y0xQSS+Hka5tUgjFj/Gom?=
 =?us-ascii?Q?dlYF2wCtFoBqhyEVSBL39HoQY20y8GL2yhvANw15oQEaCa/1IQMwEUUf1/tX?=
 =?us-ascii?Q?Coad+/4ZhDPebBmmDng1a1Ykh+nzjCHkFaxT8L/2cf6SeuYqi8VxubuThMxz?=
 =?us-ascii?Q?4Ciyw7K2Ze4Pb7rhYQzg5z7l1fFJvuDShcoQDWXCRp/vHHgf21OBU30zuTxg?=
 =?us-ascii?Q?mVYiVnGtMkTpOuwSjV3tZeFpUeW2n8DR9UgrY8SieUTtyv/zQc6PFZ2CdP+e?=
 =?us-ascii?Q?DbONIJLYJ7dyDSiZ2Wj21O/Ei4xWe+gJb/MEYkRIZkzPIdPyBeLQQN0T1f47?=
 =?us-ascii?Q?nJzTNevhP25WM9oY9nzBpGXlE8kFvvss8IZFHhWcQh7EXqE1iCppGBLVZcPb?=
 =?us-ascii?Q?C+xb7QFGhgTJAkykcvV7wq4UnSbVDwpR9sg9Cef3kqh+oByp11idfiVDkjas?=
 =?us-ascii?Q?PRXun2ia2acAX8d6ypkoF1Ivl84Y6bEJXCqsyRuRxiwnn0BHCCFHoUBk3hgv?=
 =?us-ascii?Q?tiCe3a58S18ZyYOP/nBejLV5oBVHrf66QBexjaAH9AZ+vGBHnkcOgYX88gNu?=
 =?us-ascii?Q?JzHJBohi35o2FjT+j4s9yflDrySh94nrV82KQSEgfxf3s9oO2qZ1SPIEtPYV?=
 =?us-ascii?Q?aOTlk5zSFZ+4lYKw6266bSgWDHgYQ3ZcBduG3f1CGqsquZRWidYlw/MXU/iE?=
 =?us-ascii?Q?EZcyC7GCHpsc4rxaF7M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iFVsSQoSZ697On/OzGYyKS6hpU6PM7IXzaBetzKC0hdC0WmYP+m+ErJwocIb?=
 =?us-ascii?Q?NSif9A9puM4ouf6I88SgHVuW9E3QZQB/vr034+hhjZutqaEenPTFUtQxziEb?=
 =?us-ascii?Q?KX7GULmLQjFE7vRRiv7mGaRd00OB/yTj0teWEnt7iSMtdx6EoUa0NuhIO7mg?=
 =?us-ascii?Q?IFpT9W9AJaUxPO+HusZlwpFiUFeNlTJPfqQA0U9Wt5gH9eapyao7aAIK4URW?=
 =?us-ascii?Q?hzwZSbOm72vppZyqQ+Nx8ihQAFHTLcbsrt5QDWjHKIk+bzWZFuN/m07ZtUxj?=
 =?us-ascii?Q?neHxnCYKuN9wCiONzBN/4iMhHzJE5xA47LJob6r3xE9B2SZJsXkTwOfv2V0E?=
 =?us-ascii?Q?EbOH1bsXwmynYo/iMI2UjaJc2NzZzpvMrZZfAXZ6cRfNPf2dCYEk+abHkZM2?=
 =?us-ascii?Q?8UZl1/8eZZapQ4mpvk3ito1FEvSd4mLhfoWbstsSuHyfGUdFjNvcx9WzVQRI?=
 =?us-ascii?Q?LaweQt7WQLXU6flyvAsPBsLGdS3I4adVorMcj/dS/joa301mWuRwlHf0tMnb?=
 =?us-ascii?Q?RDyBS+1Q+4Kcp64CZkKxrj6FK+Plw7npJtBAGUWbtggOsJFMz+EWhl9/r2n+?=
 =?us-ascii?Q?r62JTBWvVA9+3e2kTpW254Ka66aznmYV3k11qpzZXEn6wf1PbXsOQvb0vElS?=
 =?us-ascii?Q?2UiMhKdNIabjkc1dRUfYxg+lqnEJTVPxfysth2em2xUG/wN6ik6T36h4WdAm?=
 =?us-ascii?Q?isJU04+rUrVyjBkdb9E60pEMmz/x2qRqIozRC9Nu8JXYq8OQ0zFmPl6tKiJ3?=
 =?us-ascii?Q?lRxg6k3TAn/oYxMxNKbzARfmYxtuaDS8TMP5x3AStUXQOsSN8gHRkCnMLrhs?=
 =?us-ascii?Q?hm8gUp8ErJJjeznQEr8PS3HESSYyU3MW/Nn/kIsSUrbofR2MnjcvysXVwTxA?=
 =?us-ascii?Q?LffiBNnW9BOnGInf1akGxVns1EtsIJPiQxQ5GePt23mfsy7eNqgFnLeRMj4E?=
 =?us-ascii?Q?LuhusM9dntNFKBH1cSFamhJ1RjKw7bJFX2j4En2BIXucBt7Xcu2G1p442rVO?=
 =?us-ascii?Q?jak0dXwSTseOCCT7/UUzgO+yBZ252+VyymkNyVCT6rlD0479eYLm8xMt5rUs?=
 =?us-ascii?Q?YVbpag/1QBsV71zyiTijOjX9Lbo5rQEBjFTQAMJ8gnp4bjN2Frb/CazluYGT?=
 =?us-ascii?Q?Jkoztun2LZAsjFf/na2v+3o3aK6R1N3Xq33+kDN5aT7uHivq4q6savWOiLjw?=
 =?us-ascii?Q?Fc2s0fBewZRBGRlolAxul+BKl0tug9xu/W96DFNPPDjpNrf9n05GRxovrrdR?=
 =?us-ascii?Q?cX/GFEpWamVCaVGfT2mQOiMbmzk23zN2FqLZI4DuIv3R6GOTREFsyPExBmQj?=
 =?us-ascii?Q?XnEiZkWKlDi6cJavUoQY0kNsZXSgOudq8JeCrwTkdqKPFiTBAVIe0xOeNAer?=
 =?us-ascii?Q?t+ZGIDMIGjx7ZBD8rCTRJJbMa0IYVzPQtqLEMhFkz8H7YltCsCTh8FY8URUp?=
 =?us-ascii?Q?bFrmClfZwkHUWt/yJc2s2V/pO2MbDDWkwfmJz8NQ/49RFDXvq4dtuLm7h9Dq?=
 =?us-ascii?Q?O10fGayWmxG2u5niA4/p1EObjGfcdWRHis/NLV5n8wo8BTfq/uusZD0egU+9?=
 =?us-ascii?Q?k2L+mpfIFb+xcLXEOxx5I5l/CgkLxJEg7t6vs9OQpMu0vlEiIlkyhYSk3zer?=
 =?us-ascii?Q?be+RJG/03Ox1Yrt9NZf7BfZ9zrgoMc5pLZ8qydqsO75ogTYH4if2oSWbP0bC?=
 =?us-ascii?Q?iY8bPDTsFqXqwpyiDq1NsSm3/kEz+tAQZYOqUCXZlJv8fS6lc2JqRmqZNHrx?=
 =?us-ascii?Q?Pn/wCW8cHA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed315b1-e442-46ce-5050-08de624f6920
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:37:14.1829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eq1u5hUM9zQ6wkzy8q0m5EmzhU5nkDBePM86xcXnDREP6sPuIsoTv3waYasLqoeosACyI3KRRq2J0tNltkH7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Server: rspam12
X-Stat-Signature: ygf6oohtu1fjbua3fzybx6ezjcmouh9p
X-Rspamd-Queue-Id: BFA90C0002
X-Rspam-User: 
X-HE-Tag: 1770032357-614297
X-HE-Meta: U2FsdGVkX19Cm3d2Sq4xkwpwg8hH8HZBj2RV/uiuBdX+2jBsuiRw0tB39C9eaT6Bm0bnaJZZLcv+oRnqf1AgW9HFOGvopR/Lq5QKlMkmvLEaVf3S/NkjZVcPd+o98VpDrz91PO4BKg5UuaxqD8a+8kEbr6UqjGqgkzr2BxwjCRwTx2gAgIejOA5il/N3ELtiaP8RK754Ok/NQvkye17Gqf5C27LJYdx+2F9wdAt/c3q5q6UB9DIuGibyKEE68L9VA9I5r3iAyWdN2+Td1Ed7gNoSU2uUBhInC6XK5VBWK0q6whYol2GSZTVc56804X284ScdJ+GpWkB7pFvixzF105/BMtC2nO9Okx/p6RYD5e51iuQVultNVoTV3Gsf53Ap/EVmmY91C1AksUdA5PSxGh+6WN4TBbSubRN1QL2C41PYZ15bsfZNrBbwp2mbUBLwpE1tgffAn7VF/n4b2/tZXzrevFDyGBEbPgaOVL+LiTWFvMkLBR8kQjE4ZxXVKkMzjJH3BXh7N3bBvG4KuxvQhnHzUEg230n+g9dk9rqGNi83fuyDqjMAjCueAGQUi6fOV49MNaIMINrh/6SgnlMw9ziKZWoPs3TD7Mmz70Nt9vYf1/0ovT4N/14FlYqpgvN/IIAToYUuD3FI27KlSUaGW4huOjaoSSovjFi3H4E4YTzjzqiwm+jsvp+CxqxGwZoOSEFdhYwaPWcptBccV0jTmEJsPcUGQEBfmSgw2DaLaJVZ8PMhnd1C7gU6c5dro0maPJCiNXVyBXwtMl4dDLlxLbFsE/fjCkaNDnLzB0ibpS7JsT4oEScTrldb/MPjuHk4wO8TakR3t65ikLcow5wgfEayDKmeAQIxn/E1J5VbmUDNnHtnSv8YOSY0eVaQeguH6b9de1qmeV2wZakIYNlGfAWE9i/rgUwZiIFsVF38dBDloE4mlWZcSEXPIlcr5mM2GE1QcRivDiJcvNMBosv
 uhIfm+Pv
 vgCUEqD1BhLjoll5M2CK4OngTU31th5APq6wBmP621bDMrCyS75zuJw3manG+QB3Bsq1VwqH7DlKnPeYzujqEM6Wyu7R1Uw07gmKqQvpVR08tW0Q8MdNdPpVbOquxlhHxKkDTOD619NR0d0iGKQlhpE6uso+860zaO5FliygNQ45dnzvnwokBOgM/MtTxl28ZAuRfA3xKMgfCOs3QtJ3D9DYTFhq2C/ZXX7HI+rPjj0gFCm01rSQLiI1mxOBqAX5WE31aWzqYDeZKlBSOKJz+H58acQzhyzOBNLZsBRB+pTRCNqqOyPGhuwrOS7wBgucaLWprXiM+UKOk2WLu+fcstSd5kUpoGqOIjmoAhz/3qnZHMApgzY7P4jGzdxMKY3lYaetnNuvo/BoHfuDPSJxGEImCrtgtO3y4KoqMwiJ8gqkJlpmxXvzhM9OLp+HiC+bljx146B+o5NvON1RYp6fesKjbvT/8v/6pYhGKJoDVjhsRoh8JWh+k+rTgM5XHpzhn040s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add equivalent softleaf entries for the device private migration
swap entries:

  - SWP_MIGRATION_DEVICE_READ -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ
  - SWP_MIGRATION_DEVICE_WRITE -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE
  - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE -> SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE

As with their SWP_MIGRATION_DEVICE_xxx kin, the
SOFTLEAF_MIGRATION_DEVICE_PRIVATE_xxx types are used as specializations
of the SWP_MIGRATION_DEVICE_xxx types.

The new entry types have the following relationships:

  - SOFTLEAF_MIGRATION_DEVICE_READ is-a SOFTLEAF_MIGRATION_READ
  - SOFTLEAF_MIGRATION_READ !is-a SOFTLEAF_MIGRATION_DEVICE_READ

Update the existing softleaf_is_migration_xxx() predicates to reflect
this relationship.

It is possible to distinguish the between a
SOFTLEAF_MIGRATION_DEVICE__xxx and a SOFTLEAF_MIGRATION_xxx type using
the softleaf_is_migration_device_private_xxx() predicates.

In practice, the only reason for introducing this new type is so we know
when to not call pfn_to_page() on the swap entry offset once the device
private pages are removed from the physical address space. That is the
only time that the difference matters.

Creating these new entries will occur in a subsequent patch.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v3:
- Separated from previous patch
- s/SOFTLEAF_MIGRATION_DEVICE_/SOFTLEAF_MIGRATION_DEVICE_PRIVATE_/
- Update comment for softleaf_is_migration_read()
---
 include/linux/leafops.h | 90 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 10 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 52a1af3eb954..60681ada7b8e 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -28,6 +28,9 @@ enum softleaf_type {
 	SOFTLEAF_DEVICE_PRIVATE_READ,
 	SOFTLEAF_DEVICE_PRIVATE_WRITE,
 	SOFTLEAF_DEVICE_EXCLUSIVE,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE,
+	SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE,
 	/* H/W posion types. */
 	SOFTLEAF_HWPOISON,
 	/* Marker types. */
@@ -165,6 +168,12 @@ static inline enum softleaf_type softleaf_type(softleaf_t entry)
 		return SOFTLEAF_DEVICE_PRIVATE_READ;
 	case SWP_DEVICE_EXCLUSIVE:
 		return SOFTLEAF_DEVICE_EXCLUSIVE;
+	case SWP_MIGRATION_DEVICE_READ:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ;
+	case SWP_MIGRATION_DEVICE_WRITE:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE;
+	case SWP_MIGRATION_DEVICE_READ_EXCLUSIVE:
+		return SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE;
 #endif
 #ifdef CONFIG_MEMORY_FAILURE
 	case SWP_HWPOISON:
@@ -190,28 +199,88 @@ static inline bool softleaf_is_swap(softleaf_t entry)
 	return softleaf_type(entry) == SOFTLEAF_SWAP;
 }
 
+/**
+ * softleaf_is_migration_device_private() - Is this leaf entry a migration
+ * device private entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is a device private entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private(softleaf_t entry)
+{
+	switch (softleaf_type(entry)) {
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ:
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE:
+	case SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
+ * softleaf_is_migration_device_private_write() - Is this leaf entry a writable
+ * device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is a writable device private migration entry,
+ * otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_write(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_WRITE;
+}
+
+/**
+ * softleaf_is_migration_device_private_read() - Is this leaf entry a readable
+ * device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is an readable device private migration
+ * entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_read(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ;
+}
+
+/**
+ * softleaf_is_migration_read_exclusive() - Is this leaf entry an exclusive
+ * readable device private migration entry?
+ * @entry: Leaf entry.
+ *
+ * Returns: true if the leaf entry is an exclusive readable device private
+ * migration entry, otherwise false.
+ */
+static inline bool softleaf_is_migration_device_private_read_exclusive(softleaf_t entry)
+{
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_DEVICE_PRIVATE_READ_EXCLUSIVE;
+}
+
 /**
  * softleaf_is_migration_write() - Is this leaf entry a writable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is a writable migration entry, otherwise
- * false.
+ * Returns: true if the leaf entry is a writable migration entry or a writable
+ * device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_write(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_WRITE;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_WRITE ||
+	       softleaf_is_migration_device_private_write(entry);
 }
 
 /**
  * softleaf_is_migration_read() - Is this leaf entry a readable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is a readable migration entry, otherwise
- * false.
+ * Returns: true if the leaf entry is a readable migration entry or a readable
+ * device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_read(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ ||
+	       softleaf_is_migration_device_private_read(entry);
 }
 
 /**
@@ -219,12 +288,13 @@ static inline bool softleaf_is_migration_read(softleaf_t entry)
  * readable migration entry?
  * @entry: Leaf entry.
  *
- * Returns: true if the leaf entry is an exclusive readable migration entry,
- * otherwise false.
+ * Returns: true if the leaf entry is an exclusive readable migration entry or
+ * exclusive readable device private migration entry, otherwise false.
  */
 static inline bool softleaf_is_migration_read_exclusive(softleaf_t entry)
 {
-	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ_EXCLUSIVE;
+	return softleaf_type(entry) == SOFTLEAF_MIGRATION_READ_EXCLUSIVE ||
+	       softleaf_is_migration_device_private_read_exclusive(entry);
 }
 
 /**
@@ -241,7 +311,7 @@ static inline bool softleaf_is_migration(softleaf_t entry)
 	case SOFTLEAF_MIGRATION_WRITE:
 		return true;
 	default:
-		return false;
+		return softleaf_is_migration_device_private(entry);
 	}
 }
 
-- 
2.34.1


