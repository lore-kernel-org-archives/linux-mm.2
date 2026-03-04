Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20414EF8FF8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BB36B0005; Wed,  4 Mar 2026 10:40:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6141B6B0088; Wed,  4 Mar 2026 10:40:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8C66B00AE; Wed,  4 Mar 2026 10:40:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 389E66B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:40:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4157160634
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:40:02 +0000 (UTC)
X-FDA: 84508791444.21.5850BE3
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FBBB180006
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:39:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DSxcRgi/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBhLNfjeQcpvDCOYwwQVAxVWViVjgZOuLS76JnZmy7o=;
	b=R4MqA/2NuURti1PKd+gSmceLW2F7qx17ipyq1TBg09PL807Q2mf0yzLxpbYR3z071beIzS
	mDThF2Em5+jH1B2bh2WJ2QOVGPqOP/pPUXG/xNYeXl7FwcgqwRbkLhDzgU7ZGRlwKjx49F
	v3xu0YroezbZvzDqEKKLjfYSHCzAUpo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772638800; a=rsa-sha256;
	cv=pass;
	b=XwX2W7aWYFHOjVnzqogIz0x1ADOpbhVEK/uEG6UU8UeSmHQop+3S4zzJdyQVet8lJYeGLX
	qVdgc9WathR0PCArx2sBRr1TTvrcxUqs/a8HxwR7aKwIRCb+7niKs76G5opdkad2Ipodm2
	Go2D+hjFVSP50nZvmRysOd3puXGr3Uo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="DSxcRgi/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QL0YZrvHcQAK4KpWdxvxHTXHdnXJ4lyVLafotAmqs7bTEylaY6mphWZnyPNQml1fHLxE54bcGgFkSGb9Yx9HbzxoOpeOJNU2zbKjBj8/WdVVx1Ekw5yEQpMGAA0ENhSq7e4d6CVcsKVLw+Lhjn7G46pxuJV1GyfUwX0/3yZi1lYdbxFdxdU0I3zPUYhXfSug1jRXYsEqgOVJ8Chl54N/7zOhbQvEWXLBDPRuypguoBtD9rJf5VTg2GgN/j1GQYV+xhaJ/0B34plC8thb/pB684w0oh8bhSod8LXjG50hRY91vxfGXCooOcgg3DYFb+RaqWMw+uPmY/gH9Ci5E6akew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBhLNfjeQcpvDCOYwwQVAxVWViVjgZOuLS76JnZmy7o=;
 b=XXvGGDaRhqgePe/b4zDaghfUgJpBu1tq1HM1KbRUHFjtzFmen76+k+WjsJadS5BEbJ3HmXHxowsUO+9Lo7Y0L6j9ypUrY9+N5FoXM6HJmYQtnP7b4kLhBwDkbEyJnK+YPpQ2tnyNtyadtCquff2hq2ll4pIs1hD1HWn73s01EzNIFUOJsen93XNU7+JY/7Ma5FkaMbwa8INw8q+liCUhUcnzmyG2BREVBGAvfCxehLkTcpUgjHI1wbE81skgPQNm+a/dQpxnxAhJq22tGMu9IG3iLq1Jety4+I7bJdWNDeKZU7/yg524FGkoTn3OIQwL7w1CK00lV+wSZGnjrTUrmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBhLNfjeQcpvDCOYwwQVAxVWViVjgZOuLS76JnZmy7o=;
 b=DSxcRgi/ZZzXwTdYYPn/6tW/vOpzQjXPaDZglkBioPDeycOJLkOV/MHSrNSTGiiVx1gyKbOse+xL+nuLPR5DXxTsZXF5am7GOUk06YPFy4rPclV1jwEYVPe71uB3ShTaEFvkAjUNu02ak+Vv8J/GETBexhiZ0JiVG4cNGCcV85wacoCjHP9rW98dB4orqIK2lnnTWuqASj3vX/s7n4hPMBDlrutGSI/1M4H4bK1/iS/K9ww40ooaErrqIWFucvLhvAPWBDBqrTc6tN3bfPngLYrT5MQZi51bA25If6cfer9ic9qR/u3lWzgpw07CmrVAwlshOyIy9RmHpMj0kI6HEA==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4149.namprd12.prod.outlook.com (2603:10b6:610:7c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 15:39:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 15:39:50 +0000
Date: Wed, 4 Mar 2026 11:39:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <20260304153949.GP972761@nvidia.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <aagUtDTca5d0le2Y@arm.com>
 <20260304134313.GM972761@nvidia.com>
 <aahJX0NwtYHy1ILe@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aahJX0NwtYHy1ILe@arm.com>
X-ClientProxiedBy: BL1PR13CA0160.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4149:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ea628a-a0b7-41b7-08a6-08de7a0445ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	6AcMF+UVVdT9JH5mu1xZWCbVgNPwlAzTrI3+r/BL7Of6PXGcxeZxIJM4YLtAXJVewhQmzLV55sMoJAm/Q8SYEkuDCqS4C+c7zprMyhkrHrGCgiv2K0x074F0eH47B94reLDc0L0w2CNnLPvyHMl6wpRAGBtbKlJoF4ibBAsSeGRyqwOkBYp2puZQ4rnwisAS8M144SZNMyYzBztxEdlj/QjBNT+7Woo3G+OREJtHX3EMgtUrSwYfToe6Pb9tair+WI1pTRlugTawXNJFSbCJ1QyepXt9xqp29G7V64TPaJxx3/vX1ShqDOcEPZYI64Bn7yBQGGo4icYZZoXBlRMnDBkm/+ioWZScOmrfqaJ/jPfsp9WVRwLI4xFHwRYr2nSFt+a7602uOQZq9BqiNxJVsjYye2htIIHbZmb+4Z3HVDWO2b8F6u27e8HZ3KYyEDAqE3CRlspWRUnr0eCMo7v6rjU1yHuCPWeML481rEFtk8Zvjqr33SybEcHWlQb2d7C9UjfDnq8EJgWXT5WsoNoz2MUMaquHbiWobIYC+2Z4FTteDrQqKtnOGKTWe8gYgJf+YrVhFD4vJiZJFPNc4sSWE0fM8i3p6YuPh9sfHsqIDDoIqVM+cgZNqlJRRzQBJgXuFmfdqYqF2K6U/nnoBEdX1U+5+721fgBgK+5Y6yupXwpd4WJbw7JCORx1MH7OxYfwa2MntAEOKjyjH2jZCMbrQKZnIoae1r9Xn1GOF9y3PTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BEPD6asbSJFNf3TajnjC50CD+Q1h1UqkotvMuomoXenhOS3ZGeorALfz8Mnw?=
 =?us-ascii?Q?qfhmpw9NvmnS5cq0RmJ5v2AToV5XkcK6oyraUtU5f8O9oq7g1sfGEmzc6Djv?=
 =?us-ascii?Q?a7p+A7kRwhyPnhOemO6mES0GGrECRJrCJRH99mda3zjBnWVx8xj8hwVbHYbN?=
 =?us-ascii?Q?G+sAenZ3P3ONBGyVTvn6EMn1IiiucLG1+5pWiMKgkjO6jmiBURVTJy7U0+lu?=
 =?us-ascii?Q?0t8fGctbYsGXoSHqWPxiuWuERcSZTaNLFuibzEoSwL9TSFGOzk84jmOF+d15?=
 =?us-ascii?Q?LFj/qw2suELJIpcD3aPgil2MOe1un5TbPCibxOILIWzZEORT+dE3ykOjndb3?=
 =?us-ascii?Q?23ZrnEF/Hi5nib3A+sombSzJ0HhFTlbXcMepw36PIDzaPeZwZUleQFnuijVq?=
 =?us-ascii?Q?uaTitqB2Q4IfXRJkVHctWhFLfF0Wqgrf5BuZotbS6YOcIuSYP5kqlw1IjoBC?=
 =?us-ascii?Q?l0onkzNdr5f3o6hjspzJFqMY2OZU+Sd5D68qL5LOuOpFCLboN7+ZUbnXFxX9?=
 =?us-ascii?Q?oj0yv4JGnOWpuGhVfkYyv1L/ToomfLGP1v72UFLjceuFrpNOIDzP4L9Nm2Ae?=
 =?us-ascii?Q?WsTQW/WefY8Ugg0WHeq2PVbbaAe2eYbQ4mVEN0M69r3kac8pWSRK5ND5JSU6?=
 =?us-ascii?Q?7acNFjVd0Xajty/STM3uMlzYUAqygFUFzsnrQqsWldK+lWSCSzbFCXM/IhWP?=
 =?us-ascii?Q?z5esZrAVh/Ys1W2Py+npc8N74v+kFjnv2sqMGvX6lQfdqDzXLBDPon3ylHXa?=
 =?us-ascii?Q?iRpwdj31IinZTl9loweSpXcoQyiKmpm4TiKnU9mbTyex/QQGMySGg/zlXKai?=
 =?us-ascii?Q?Xpw+XnTUZ0cK4bjJuSFvR8MxOoEPhrh2CnI0pcU2e2q2JSoaFOZnoLUurz7w?=
 =?us-ascii?Q?GgZz6fVUcCATit2GEGHxd2PKD4/Y+0J/wWaSi4Ezx6jeYuyd9WojeM+pls3h?=
 =?us-ascii?Q?wSMWsGvmtjgo/lSTAVBXAmwIK8iFmzcQOhSPg5TU7V3EOpGIE43kc9DMA6gn?=
 =?us-ascii?Q?XfoxeEzikAVNoyS/B3RUOqHWTJ7imJw3iJaIDpCwx/VlMML9QaWne3LNaMtt?=
 =?us-ascii?Q?jooBdM37454/+1qOVcZn0TxOZq9YUT7R/ojEBDdK/At5j2tJmBEhTjlgu6z6?=
 =?us-ascii?Q?I+ctkU2+TJc6VdQbkMin11hbC4wCBNemj5lZgoHiIpk71Rhj0cNw+ukne+OC?=
 =?us-ascii?Q?ukZRg3Acy5yagprGHCZeUID4OZA6izcixG692uIf2xz+uniNdxhHhTOSWLE2?=
 =?us-ascii?Q?iBtUbRrRFfhNkJw5/UQ8OmFPTwf35J4S5o9sgC3nzffg3kOGosFwBiAeV3Fd?=
 =?us-ascii?Q?4hnErwZ5uezf6cn5+0ViCSGtW9m1vLjeueLnR5ZjyxEMfc6gRX411qIw0SlL?=
 =?us-ascii?Q?3FL6fm58hJan8PLCicQ63RvoQ+UP2cbm/iOawRmqTGnmx+lzUQfxUkbOjnqj?=
 =?us-ascii?Q?y8IRWiXy2xiec2LGFBXL7b8Z/xX+rBZR8jfCcGB+0iZ9EE9mbMF6bxY6DRSO?=
 =?us-ascii?Q?TpdqPQAzDAxh3qhwI1ofBBzKqLrxgNslaKxWtYVDrUzwXZGTy4c3i6AuYHRp?=
 =?us-ascii?Q?EUHDEjAlPHkpG48of2Cnw1pZinD0vlY66vz5e1LBfT7FkZcJb4/YJTRgFzi3?=
 =?us-ascii?Q?nfJsRWi9wKTwf1lIJk0VeJMbNlEvsUAg84ejlgFxbQyZRRKKbBFOMLjAFh0F?=
 =?us-ascii?Q?AfCQhW70fIYRqqMDiCWyrCkWFTGNW5AYBlOI5sMRVZVz3konv1U4RyFk6mu9?=
 =?us-ascii?Q?g6IMTv2jEQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ea628a-a0b7-41b7-08a6-08de7a0445ad
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 15:39:50.2748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XtOZ2GTdLE4x7pGLZVBciviUecr3r8zx94k0oIw6HlhMJoriElq4/RNhI7HDEqq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4149
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FBBB180006
X-Stat-Signature: cgf3smahinntuenxhura7fmjbqmudkfd
X-Rspam-User: 
X-HE-Tag: 1772638799-312910
X-HE-Meta: U2FsdGVkX19QEc6fDLZ0xwcqmIIaY3abIZgZ7zcz28DQ98beuJHALBVxQWdvkKAf/ZpL2LFqaJ9E20QpKXMf2jrwu43Gl3diUlZbWodJ8S3t+yc9K5XWS3RQrScrqrxgYQSuI1Z8jqpmR0MSyuwmn6QlvIpaa6PHufGxR+CaLc0jo6Kq/wefiYSlQlbYe3GTthXV64AwiQcclRxfmhxcj50hu7p1IBFQZThPDNXbY20g8qm9a55DnxWo2fzoaPazWsJwS5+KQtN6Beim7EiUT+zCH6xtGSruAvMRC9s52/QJvGHqsmj4nq4eSir6euszxkSIjTVOtpp6QUo9J38v4t2AiCtLaJBUEVxBTBXHM3skXwLewQcgYdDbPtV4mg/xEnijuf5yBr1hHQvfIz8HxbTQIxr1YAr8ccPQQ8F2mzBBMZIIXnXpZAsMKHZphymWPLuk71pzFJb4J3/RJPHCCREyCxvAd4YGozdaEKYL0vvqv3p34XJg/vUHaun8xc9tY2Evdkc8IyRzK1viPkLDNthkkvTffl1Hatwdb7h4B37JEjhtKFmeSQSYH9Q4FaSa5Gwg0pTGe9mG7DVp3sxwV6xGGOYNw2dOrLY4Vxp+Di99ci9sw15mB/JixzV5licekpD8zQAnBuGVmiSlzGHxrL+pmspQT2C6UlFrXg3YOpmIBHto2sZ60pYxoWtsfDq5JlYAch4tcsgRznQuaDh1nJFgT9iqZjqzbWArkxrVQdcWb5ZbBtM70lTH4FNY/1DjGopQe/QSQF435wXx6mGGCwNGZlVdfyobPaaqDhNnoFdF5t1xFGVG1Yw2IDEmkLbZsRCe1A7icAl5wetmyYzP/Seq1eS94Yna+neHgzt+UL/K0YeNosXDiojLmKZcXe+7h8cKfw7PH1ledjjC9qYSnxMJlXzGjw3EEzy543rj8lX97N4qm/nUMqWdSa1hNXUO1NWasYbCMs3JIV/xkvn
 6cE5LtDd
 RYbh57d9L0qth/P4CbMsSJFI3wZ2WnAMmFFKz3zKSLOqc5qbTzs833k0igYZjGLZXVgkzT5i3uFvj4w+satJcvF+pRQaWc5tIy9zveMtN8llWYUnnmFRztr64qbf58M0vH1FbXCH1qdVKeYwjBNsuTw8mXM809G6qZDosv8Zw10J6rwM2YAjOXt+gGOiYgnsCHFCryWM/nfvpbOZmVGUpXuo+SSwLvRuj9sUgTpwWInVxfWBH4bCwkBkk13eYbdP9PmBAgnHmNV6vOSbmBnZHqde78a3kd5+Of1KSm6GOof10BiGVIRW6VY2wQP1PhCFsIHgex5yXD5Cov7a21CWRn0NMCPD855jyz5MGDwX7DxKtpOmiYYRqyXwxGTvwbqKHD0s+ml2DzVcEAcnC4gU63xMXVnJFj6GZZvOSPpIRw01Mpi/R4FRqEriPT2s002wqhZEvSC5WT9Nff+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 03:01:51PM +0000, Catalin Marinas wrote:
> Good point. For the AF bit, the hardware is not allowed to cache it in
> the TLB, so we can't get an AF fault for an unrelated VA nearby.

The way we have read the spec is there is no restriction on what PTE
the HW accesses when it encounters a CONT group.

To be concrete, the spec seems to say it is legal to make HW that
fetches the PTE at the VA, sees the CONT bit, and then always fetches
the 0th PTE from the group and only uses that for permission checks.

Therefore SW should never assume that HW will read any particular
sub-PTE under any scenario.

It seems current cores don't do this, and it is a bit silly to do, but
I can imagine an optimizion where the core does a cache line fetch to
read the PTE so it can freely snap to the PTE at the start of the
cache line for permission checks. Consolidating permission storage to
fewer PTEs would reduce atomic memory traffic if the TLB is thrashing.

Jason

