Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7441CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2232A8E004B; Mon,  1 Sep 2025 08:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3EF8E000F; Mon,  1 Sep 2025 08:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C0D8E004B; Mon,  1 Sep 2025 08:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBD4E8E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:56:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 918945B99F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:56:57 +0000 (UTC)
X-FDA: 83840681274.18.FA4DEC4
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id C8610140003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:56:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tInhzrjP;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756731414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/0mqcwvOl+moNJhRQ7+/S5eL8YiLrDkHyssJQvuuGo=;
	b=LwlCACyb5ObhBNmyKlWJvlRL+1+XkJjf1vAJxhcc9SrrrzPDYKFE9sGE8Iw6mk3pO0w2ZM
	TU8h/nR9VqbGztzunxpsjnJRpr2ihx38AWOfeBgr766q/2uz7COd6EGDRhwa6f0ugNcydX
	Y+1glF8Mr0SGxlQtBT0MS7vvGB7jo38=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tInhzrjP;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756731414; a=rsa-sha256;
	cv=pass;
	b=umlHulVKbAe1zPSKerwqPrmlKLWMMvgY4RoSuRMTFqfAHC1PrDeMEmFJx9JldGUxR+DS7N
	DdkITRnA3fAN2HdCyrC/8Uo9J/bBBEIdS9XHQWD58gPGDhcztmo5PnORIakWb7YzoClCyg
	eWDf2dVnIUNJpthmix5TBtIlrgXaQ9I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CN6JvX7srkL6Q1ShVYpGw22OvudxDNtoxrFmMrGvMfsWFKEQRil2DAJ+z09y/iMVSVDlk3qtLhESm2GAiOKcYYxZ/A6Fue5oRT/bnaWooRAqBXioYnZecn8WjtCKYFnWCb2f7K8c2mhBwFt5/P79H0ptq1KZgFxOiu9YWcDyMG4tXCmTxHrCxB/alhng6iB8sZffA1bsf0dp5iB+jozK4dCHBngQbfUGMk1LMKkWGcu0MdoqdElN3TUBhGMl54PSINXojHcUp4KRSoJ3NmWzs9BBtwGLUDSKY5q4PX33D2U4/VB1zyW6oKOD/ImfbH6iHra1bjUv0BvYXK56D0VB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/0mqcwvOl+moNJhRQ7+/S5eL8YiLrDkHyssJQvuuGo=;
 b=yQUh/WFjt9cBttfI0BqWG1aSE2Q+TnRSOJMLo4pRe1hQp9f7K1odGzqV+estgP36pkjh8Iy2bV/OhK+XbGFeFj+WcET9l23kHBd9HqhdSMGr+hPEh8icH6c8tDgTa27RUB0Uu7FjxPrnHswNYAZGtuhrbz/63KGIkObMvZo24V+g5kerpLdsRZeVWvP8vDtDGPPlEE100MpbkEVgc2oydtjI/p/fG9USsyuxs0GRqyCvgtXDluHOybz6uc0p8rYo1yZYX7UYYX0v5IcNikd6Hq3aNJmyxrjhuoySjA9s0adPcaV0aj06kpBLEkm01zBZ3+Gp/A3avhD7dgUzZ+nNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/0mqcwvOl+moNJhRQ7+/S5eL8YiLrDkHyssJQvuuGo=;
 b=tInhzrjPQhoqpi34AfZcQNxYoWul2r4BHXCnoAA4y1s/cylJpF+wrsPsUWxveov+dlYNzitB/Yk8W8n/Go5zjHRYfb1X+5gn2geY3Ad5m620aqDbBFBpopdYioaF2qxdSEvLSBgP58MJe6FDD15eptL2H4VYtNHYpKywXqKNDC7IsIlcKPGOPAe85hynIADT9o10ORGa0ePshtb3zjUC+1d0u0p9sjrGCvcAVWI3i1lTqkHPxn+cfh1MMtVn+E4yoegdSOlj8cT035y7ZI3cFNZcyW8jOUy4S4jpJtf0fuSGqZXDhUVvzUxxI1xBtG8ni1pWqBTxAR/YQyRgjmxNHw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Mon, 1 Sep
 2025 12:56:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 12:56:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Date: Mon, 01 Sep 2025 08:56:49 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
In-Reply-To: <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN8PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:408:94::37) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 60873d8d-c4a4-4cde-12dc-08dde957052e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ob+ZzPQE4OcbMi7srXb4vhxNXHftWKIZBYcaUdu3wYKQT2F0v6VE1RW35Gl6?=
 =?us-ascii?Q?mRwAe/+0o8Xst3/KRGu1eCPJ8iV2o2/03f8vcCjKLDAeVH+VAEviGlbRthA8?=
 =?us-ascii?Q?tUzPAuH5iWK2OleXXOgCQuDBuvgyFm6J7uVst6UNuJaWk2QEXSQiCjhWfQmJ?=
 =?us-ascii?Q?U6/4I7pknLkXbFtH2JiJLReQvBl1GfCd+RTK+QFENdfZ5fuPXA2dZXJDv64b?=
 =?us-ascii?Q?pmdgxI1QKiS4D2ptMwQDseW8gPbsPLObgu5uEcdBpzdqmCyn1vgaU7ZCVRIL?=
 =?us-ascii?Q?dcoNEkApUdr++s8RFgZlOnLqxX5lGZF+enrh0tHBwAjr++PYqSnzYsSuN7S5?=
 =?us-ascii?Q?s8M2r/Gz7nmFF10iCKbyEqGIbDFZbPT0TsPODVRPFMIhGAe7/1xibf7mBtfB?=
 =?us-ascii?Q?hkLCxilSTr+h/ZRSMzvMyO/kTsVpGcoxUgkgUixm9zI7G1D7kckMX9Sl/6m5?=
 =?us-ascii?Q?5OIhbTD38ioacICimFMXxGTCHzgOAgHSzCf+Y7j7CF9yCByX5SgQdvItHmNg?=
 =?us-ascii?Q?W5RPzpQA3x92bOp+jdt0UUL+xwkh6XYHtB8Oc6rls2Kym/Y3q5VAt7MCAvjW?=
 =?us-ascii?Q?W8OiFcB8xbh/i5Oca4c55HudK9DQy/PV3BC4/aSrmR7/25aJwTzV3Gu+6xpN?=
 =?us-ascii?Q?3/83PsR4sul5XzzgNRoaavWcVSbmhkQiYFkJb3poG/fcCNEVD9O8NkmSY+cS?=
 =?us-ascii?Q?JZN9Sr/DxTUkApvYui7O+u+2Hn/NdREQ/aZowceRIn8qp6e8D3hmcXZboLl1?=
 =?us-ascii?Q?D0yAz4wBQ4hIIM+JNvf+K7wPQF8n7ef5LMpHhOkDQOVn0KTpczR5mDflj5t2?=
 =?us-ascii?Q?+XzYHPshO1IR/aETbr8jOhNB7EPUa9cmJGiyR7kouooVRQgmylTdENaHjRW2?=
 =?us-ascii?Q?9UWnSJcLFLyAly9MwhUaq6v4u2KgrEuR//BU8Rzddjvb0d4Sbrf5faHLFk2P?=
 =?us-ascii?Q?ck718OU872S64u1Dh/5Hz+6lPMp2hApZQameRo05M3PnMYoCa1UgoMhwio63?=
 =?us-ascii?Q?wyyxoWGKK5NOmu727D9EEIN5AS/lz5Jj2UdLhGQfJHf0sUkxRlwoMKBr2HlO?=
 =?us-ascii?Q?xbLeOGHPdvsQmgN1NVqT/gAgv8QdgSB3lm+eqfMy/nzGUHj/Amsubt5BOeNh?=
 =?us-ascii?Q?jytTez64Y6IrBgj1ClUmmZLKz7hjHngO4z6vB4iAO4BWhuCE5CO2Q/elXJkK?=
 =?us-ascii?Q?hngKmrSMhTdBGtAcWdMn2nLhDfbVHLKspCDf/YskA/eqb922b3QjMUOrsew5?=
 =?us-ascii?Q?G8eVLpGGcfp6HcST92/IdC6wK2ErHIbM5+cLKIEBMYnkrckgu9IACwnwG45m?=
 =?us-ascii?Q?xC07GDJ9Iab6FWpl7oX8l7J/4x3WyuAW5VlwkbMBObHJKWrn4Gguv+QAeccX?=
 =?us-ascii?Q?Y4TAbpweq2qYP8keJ4b1+0Tf69r8O8fh8GkD3PKoVxKpTUNIp/3cGL6p99Ah?=
 =?us-ascii?Q?GfXjFmCMOPs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XE8Z8ELmKPGG3HSVO0zPfr6b7kq7EEqhJKHmMpxRonqfw1I8Z4bNnbXfBsqr?=
 =?us-ascii?Q?i+HbKnsbufm10Pm6HUracv0jkPvPyCazRFPNUi0QlZzfa55BVZydM12B8KzB?=
 =?us-ascii?Q?0fSvThrBPge/B0IRSQMlzhjQJGtXzmJQ+kqn76/OyBEXFWHJNKug99hE5rf9?=
 =?us-ascii?Q?GMBDrxSQEgxkdAs36rw2g1A2v7y4u75e1I9Y/erbaT2gW11vgL/h+bHSOKji?=
 =?us-ascii?Q?go53upKFnMNJ26bAb3qls1QAClFYH6YODnWBGxI9Rf9DztjqKVjjbd0uM8Fe?=
 =?us-ascii?Q?sNvVQbvcVWzqa9YhlqkdKa5659fhZyYxOjRy8hDNhX18eE2CFI49enmEJgU3?=
 =?us-ascii?Q?PxBv0R+Z8sJvJKxAkoBxp//LMDP4INxfRxjO3KVZpoFtMKJ/kk/ahrG6r3mU?=
 =?us-ascii?Q?K7auUi/QntPx8aYAHGmf6AS0Uwyq69+e14bWcw3J9DIM13r+SdrJu0oanRax?=
 =?us-ascii?Q?Lbxx3/cUKPkKb0FBhnxNrOh9pIgUTFISkOPrIRHMQ3MHLAkubEsQ0jHOjk4D?=
 =?us-ascii?Q?GqNQbWh558z8F0bJIetFByuHHPIykgOAnfH/QdmHSSeZe2UedO83AoCbYaTo?=
 =?us-ascii?Q?GZJFrBpJkLig2VgS2PkXQ/iLwRNzzZ5RgBvnNLHBSiW9QmDGfHGLcQak7Igw?=
 =?us-ascii?Q?uJGmy7HuyE29+VszYz88ktaJW3LxcR8+NfOOBxvF0g4i4XxIX3jwSm8o7vcO?=
 =?us-ascii?Q?vZdq6sKkBlSRdwbpBxw3QbcIt55rce8QKEYoVpDgXsLt0KF9kUsydqqYnCFf?=
 =?us-ascii?Q?PQk3Ugefv2IIibJaxmTh369Ig4zZKSeFuSU4s3zT99omLiXxxZbzBNzTd7l5?=
 =?us-ascii?Q?xhDmdn/9fMW6FDEetVlUDI3/K0rWEUkE+SQzqX5DKuo78SCt9N3NU6HJq3xw?=
 =?us-ascii?Q?7je/tK1Nu/1kpArlg73oGppqqjv+9eF4GKNEArvIeNb/ZduNoFFC+bVOFFL3?=
 =?us-ascii?Q?Mw3Zp8ONNBAc4jQsvuM5Z9n6rsyHO0zq5VvABw1f+RZuccNWq00kDa2tk7YW?=
 =?us-ascii?Q?16Ble06Ta0vtl5qIIXfr2y8GUkS8PT1LNAbmF3xUDSlD4e7AVfpiB7nzwHmm?=
 =?us-ascii?Q?xRKXIwx2bH/RIhqEEnj8vniHbmLRFp2shoiV7geNN0CVKZwr0MbMPGXXEfuB?=
 =?us-ascii?Q?pZsKsZ2QUhJHe06LMZqEwz8NVM7d0/xYn27BGHo2ICxHWsq14Pr2E4xVE9Iv?=
 =?us-ascii?Q?2qme1Bgh0mkblgO1Op+uKS5tdiQ0aWKzJ4LcFa0zsb86fzi3neJ3+dnOemw+?=
 =?us-ascii?Q?GuGfvv09mfiiXQP2DU2UFP8PLdIAkPT1/aOFkOyELv+DRmiGg820lKR83S4/?=
 =?us-ascii?Q?4NT1RnWpyZGxFAcywSM3YLNxM+fwG4ZgOtwsbq4VgznoWzkk5fIPwyikAw8i?=
 =?us-ascii?Q?D+LxPTzPHpydOO3Ko48sWG2eUa8zhxO0ecZ7mweT/9o/rCbORjLLyNhLIXJJ?=
 =?us-ascii?Q?lqJBhAQyjDdquPozh1xCQpuBUJJUeX0x+jTzKEglcS5UGdYnhLAWnXTrq6V3?=
 =?us-ascii?Q?5Yt2G1Yl8cV/dV0zoTAYKQz85GWtshGO9nvEB4+MYbyN5aUnlCigW6P+VizC?=
 =?us-ascii?Q?/mBrSA5PlPjstCAFK/q82PnbxuzAenS/OMJxUrIP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60873d8d-c4a4-4cde-12dc-08dde957052e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 12:56:51.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXEC7LdF1gmih3S2INwQjbbQpOH9epOe9FI46Zt5vgh9A6Q/UfC7F2Vk+A3Nx6Cl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Rspamd-Queue-Id: C8610140003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6p3g76nwasm8kr7tk47aaczienw4x6ba
X-HE-Tag: 1756731414-302178
X-HE-Meta: U2FsdGVkX18iH5kvtLyEekQrqm93goecTyJV7HpqpmgC7QYjCisFMUzl6sTMdR3vIOtp4iIwVSeTd6YNy9nkiIGMV7Nb6XeMtQMJcTMvLL50s/dL5VmCb761eiw1x9sfUK7fd7LgwFg0T/msU9fBLR5JPc1B4rK54TE7nrGdMFmizuRYnWxJzDa+Hzp/6AQfip8wDPUGXzxHcAbU1lOHC2jpYIrTC6AYiWVwTM6b587olgR4YVH4zKTKzJLz2bYlw7is6cSQ5yT5g4Bcqe4i+HWxTBw9VQqvC+q9y7O3gZPpFF/OXpos3Rkl7pPp9Ry8aViBkg0HhBWfaJLiYL9s6pexiuaYgQjhGtAGyPuOXYkRtDDI0ppgu1aAsAaEWtZD8yqeoX/Vo8C8ze/fjHNvgrk34Cv/s0erkdcxqpMIQQ0mRoM6vt+eNHJ8uv/cl4FesSaj7pvi+WVGjjtLTaDHXwXII8V6Zl3G+wOyiUZbUX0rnzIvlzQmoixsaD7ZC8ghbXaVKvhnKnjMtTn2hMImStmVfcgpnR/qsnoBhy3dP4G+uAIM2bLQfZwykuf2DPXscNHLVxRSCc4LocqDWuaxgpmxftIYd7xJ3T3E9ZYe9lFlieuHFtOKUkZfgj+5MeEjEwdMk3A2ia6NtpY0c6hUdSENCqbxft0U913KByEzo4oGiHAEiCHirzVPhMekyg/Kb8eCygGb0oG8kGI842gRyAEGlwB+R1kVYS9G9eR1hJLBoZXYgrfYlRx5KC9NEz+J6mfo8Kjikqs+keiAPhYqOaY5/7YzXFlVKF2OLOtjTutwkD3e5SZ0suIX6jY0HZn9AviWvdAbB1rDaMlmEjZstrHj2oK/VHp17CpvF2V1TudXWH+6pYLKL0Ra4Su4W7DSTOA1bOTB85AlzJsnD05K77PU7zhz7GnLsXjf5d1Dw7RRI7Aqdbi+zT7Q48mHi62+Yt8c9u6lD1ILBGKzfId
 kg/2zOAD
 9QJ7SSmyL38UVGiy4uKrvcL9dSjanDXOpofAdLevnO71AHEzE1/gi5qSWOpiNplc49sqoNlCIEp7xp4GyX1tk8d8+1u1hXXyojyDr0B9bJ/Rg5hRpsEO5eFvOiqE4bUHu+jlvcqXSl92nReEbbxQl2XPIuJ+bY7t414WRmFFgSxxZ10UbD8qvOnpyKxd6wJK/oM+Wh+dfingFAU2mNjbYVjzfR2NB9hnLSo4Xml1Lsm0zLLvKUowgU0FR9fIlu9K3Qb7WWwUEv258wF2r48yLXv0G4BewNvrJZ+dIiiqpJTjiss9/WObQVfqEuPBnGTryM/b5ssCubnoUyPibx/ORKDYprFn7479lQuaV6AbJmpyJNuOLBJCZoVcDIjgTAY1ZQo7j74oes9pW09EtnLWuMYHekCubGWzIZIH6pbpqY3dmSIqKDlB8N9vOrmfiHkIw0Zqm5WmYuiHc6F0nMi0JB9EvcAmGJkAMZV64Z3vWtdeYVan7YV1YWtt2r1hCphrFvtGaVNrM4tFcCclPqT1sAz39Xb8+hWFbTvQBzFPEWQcI/3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Sep 2025, at 3:22, David Hildenbrand wrote:

> On 31.08.25 04:27, Wei Yang wrote:
>
> Subject: "selftests/mm: verify page content after remapping PMD through=
 PTEs"
>
>> After mremap(), add a check on content to see whether mremap corrupt
>> data.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>
>> ---
>> v2: add check on content instead of just test backed folio
>
> I'm confused, don't we have that exact check later in the function?
>
> Your v1 might have been better, unless I am missing something.
>
>> ---
>>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools=
/testing/selftests/mm/split_huge_page_test.c
>> index 10ae65ea032f..229b6dcabece 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
>>    	/* smap does not show THPs after mremap, use kpageflags instead */=

>>   	thp_size =3D 0;
>> -	for (i =3D 0; i < pagesize * 4; i++)
>> +	for (i =3D 0; i < pagesize * 4; i++) {
>> +		if (pte_mapped[i] !=3D (char)i)
>> +			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>> +
>>   		if (i % pagesize =3D=3D 0 &&
>>   		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpag=
eflags_fd))
>>   			thp_size++;
>> +	}
>>    	if (thp_size !=3D 4)
>>   		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>
> I'm a bit confused with this test in general.
>
> We do a
>
> pte_mapped =3D mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>
> which I read as a "NOP".
>
> Questions
>
> (a) Will this actually do anything? Also, maybe it does now, but can't =
the kernel just optimize that out in the future?

It remaps each subpage of 4 PMD THPs into a contiguous 2MB vaddr range an=
d
perform split on that range.

>
> (b) Is it even guaranteed that we can access > pagesize afterwards? I m=
ean, we specify MREMAP_MAYMOVE.
>
>
> I would suggest to just use mprotect/madvise to pte-map a PMD-THP.

If you want to test that, please add your own test case.


--
Best Regards,
Yan, Zi

