Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C463C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A4CE8E000F; Wed,  6 Aug 2025 14:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955B88E0002; Wed,  6 Aug 2025 14:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DE18E000F; Wed,  6 Aug 2025 14:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7077E8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:57:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA2D6135E87
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:57:52 +0000 (UTC)
X-FDA: 83747241984.19.3EA4F2E
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	by imf14.hostedemail.com (Postfix) with ESMTP id F3C0E100005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:57:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VQqBDTiS;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.76 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754506670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwObype5uRHFyidv6uGrkM6N+21wrE019QLTQ5TcMdw=;
	b=OTskVdf9DH4VfUQqDlTkd8LkJLV7UUpqltqDWfx3KX75SnRt1F1NkSdyZe1HwXbfe369pf
	24FtYivR8FEkQKCzx8K6vtkXm9u5LqUN80IYh3WWwHBsjIJHgrYMAIjhCQwG7KZa17cPF+
	wbAmJNBVXHdejibmk5ID1wyuZHUyoro=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VQqBDTiS;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.236.76 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754506670; a=rsa-sha256;
	cv=pass;
	b=waUIzkXoSyvwPEG+5Uo7Z6MmaemyJIYpQkGoCeAtny1dRzG1NElc7L5CetiqT/EejFlea6
	Al4/9zcgxMpwPGvtlL1szbo3Ozqa49HXuDgkfhZpK0Yj6zUymYL7myLEItZr60am3zoiDH
	RrNvSUnQrr+6mJMFEzt7F8F744dDEy4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iv0345zE4Eax5DDWZhsxCjr+WgQ8iuFEr0/Z46k9TcLW/p6jlkAEXbKDBXxWQcgUvyKp+/q0injn2FakD6FhqdYm7m7jbJDFojdoupz4kWQbstSRRjMGIS9g2UQIXLNpGo78gSjtTBSzpFpnvHQ3hBD7YI/xnrH1wny4uhx0uLoF4tyGt+NuXlhTyCeXOR7TF7ttg3vjdErwTAh6olEw2unjT5XxNcsij+FFR7BDL0iktFSziq62muI5xI2Tydod1+j+VwNYyJrhRRTXpaLglW+aPDd5idM8a3M1PfwC+Yi5kdFSOq4SXVWLf0co0Z86Kwj2d0OlP2vfxjP71EyS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DwObype5uRHFyidv6uGrkM6N+21wrE019QLTQ5TcMdw=;
 b=we/gxUt/KxcdvyENMMttchQjgWQC15i6DoWbtlKtoBTslL6ctwE02dXNU3sGx0kvTLX9/u60UIZCTGoP2f2OenoVsFm/fmVfG/c0LpWKhTTUxVUqv/IxMxLIpoB83WSvzaySQtr832Os+RHZlXGkkPnpyTE1JrzJsw75zaw/kVYWAGVyPoQQK/n0fL1BoRRGjkWgcBltNGh5YIAko+BPuCDb1KAej/e2Ur+wl7EGf/MxZ423a8YOOdRfLNueVkN6tWhInjmhNGBqZ5g7CV3Xxy6VGxN/ZqtpEmvc+HEgXopz3tH1Eb8hiVuVaEOPPpSBVZqK14lKaheWuMLM2T2DWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DwObype5uRHFyidv6uGrkM6N+21wrE019QLTQ5TcMdw=;
 b=VQqBDTiS+GaCII0fJVhWxEpr1/PaiMLIFZ4s4Jn0/5zJ/E5/DvsaK8CHSD9CazT9fTRpC2MPnJh5y3jfxKsosLIy+LjKKgPhqz/h3n1Jh/fXyMFdydbzUSI5E0a81fu5OuUPYfprl4cmiXxnYUXDzjnY8KlbpdoEXnfHnTlgCdxuVgRiYoL30QF8wQhpfQCjSdpTrBpAQ+f5MapQvRd3kD+zBQxhwfQRTBz9LUME00tWCn9Z3nPEgxO4+lx0qim15ovefZZZ+XzsU+IUbCdiDazFOrmQyLLefoT3noLZJVDPa3o/hH+Gtx3lTKT/7aM8Zjmo56DAn7ZI5UBTmJwbxw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6967.namprd12.prod.outlook.com (2603:10b6:a03:44b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.17; Wed, 6 Aug 2025 18:57:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:57:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 04/11] mm: Introduce memdesc_zonenum()
Date: Wed, 06 Aug 2025 14:57:44 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B565AFD4-09C4-48D5-888A-6E78B85EA554@nvidia.com>
In-Reply-To: <20250805172307.1302730-5-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-5-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:408:fc::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 128e55e3-0ba1-48f3-6268-08ddd51b2165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/jp+/ktihCdH2zoTx8EYqIVodZRg0ajohNMVCDjsgk4IM2tVP2oDkcs/7XMZ?=
 =?us-ascii?Q?JytqzZA85qe6K5qGL/8FEdWQrPVJfNUQOn+z+L5VAftWFLk67djqrNHUUS5q?=
 =?us-ascii?Q?KCGGG0N6rT+XyFPzx5BPZ6M40Nwxann23prfM9SZtJ5cSfh+JTzccdk06UdM?=
 =?us-ascii?Q?By2P/kT5/aoN8p4Pzl/nck1avumS1o8IMcllHqwFKoVA2mAhyV/05FS0KQFv?=
 =?us-ascii?Q?eycOGPK0Ltg8I6z6p6MGcb1+LvhJmUAIHhlYD7dTWEsLs5h64nDauoD7cpRR?=
 =?us-ascii?Q?w4nl0tALBvOhzt4xN+08Sir2/x4GXEMvVBH3NS9UX/mUV6OTJ+ka9XI1AWR+?=
 =?us-ascii?Q?dYoWxQD10L+QXrJzJODJU1jXRmgfbdx6kYYb8WAUvKwZizrnQi92901DXv/k?=
 =?us-ascii?Q?tKX9xDPHVX6iHynbUmv6sAhl07m0Ra80/j3fBLxZFPTHYj/nSbT1PLy3b2HQ?=
 =?us-ascii?Q?n0p1X6/j6R2+97qT3O8zE9jTTC4Op8uzeceo0nf0MmtjwmpZdsfXU8M3Fda3?=
 =?us-ascii?Q?YgG+/BPcLNPNeLUwPIJ88LvHILZ3ZAKcp5oDW3KBORG824QXWeIZG3jRtdod?=
 =?us-ascii?Q?/n8zBgeJKP3kSFdSkNxLyvOYCYfUVmLa2+wovp9ODJcXqh3kAo4X8ENLXUFN?=
 =?us-ascii?Q?HQs9rxEBaXJQZh0+YxFrp3Zn1kR+6R/zQMIXna3uvZ4W/IlbG0uiwux4VcXb?=
 =?us-ascii?Q?q/flg1uW0wR2zNBVzDA5INJqJM6Kb8aXRlgByATBC2yR/gh9JLqNIhGouMwv?=
 =?us-ascii?Q?YozvwU/Exlu0JWrZ144yahcfjNLmvFiW7CLHXR95AOhih4QyYE798EYSPZUa?=
 =?us-ascii?Q?nkjFmlORDCT3xNdCIwPK6YBwcCsvA2g2vVrTmYTRS/o124rd8KyCONr/0wdd?=
 =?us-ascii?Q?GyR9imSicQkLGBKrKp4czJ9ef4kWppAuocHTT06cdDx3FJLgNzYMCUy3s0AQ?=
 =?us-ascii?Q?yYfBWc0s9sBer4KzzDmpY9UjQiw9Pj7hi+iLwX7F3U6kHSZuLkYhT3ieovUJ?=
 =?us-ascii?Q?G64Im2vFjJevt1Lu1GKR3ZLZ7duCjaRuMCo8/szJpKjuxlIOe/9yVuOI7SiO?=
 =?us-ascii?Q?zqiib3Gf8cmZcNm1IWFzI2zav4mnhlxWMZbCS1CZN4LchNr3L34JXA0/vwW9?=
 =?us-ascii?Q?RUDCYmy9xttvFsIpkFtTo5JWRM1VqPtLjpFll0owNk2wmtRiQIa9dpGQ0oaW?=
 =?us-ascii?Q?jjb+m+4riqWFGQezohDb8Xg4LS/0ew1Pz0QkxXIzf28lRXBFzhQ0HFYBAt8k?=
 =?us-ascii?Q?JqCzygqStz36DfHAr3A+/FqC9keB+3Z+ZLpeOw5KbWTfKhkKx3/+1BOXQC1d?=
 =?us-ascii?Q?Ko92dqhOo6hYDpCRmAuavEqN9FrJa6i4tMYJiI9ideV+DZ9rsLrUusV2QLt9?=
 =?us-ascii?Q?d+KW387uMFMRQXvHJSkeR+B7WmM40zy/fRGj0bnY0JAmUO27Y1G1mOs62Huv?=
 =?us-ascii?Q?rbjm0BSTyMU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSFKNwf11eeokEN4dkacVRaVJx6E9ujST2ra0vycf8cnBT+1rxdqiPVLHsGy?=
 =?us-ascii?Q?0ZDYjVea8trD+l+qq0/GtVKS9m26MMf2KBWHASnCUfDrjh9V0KeyYwUqWLpa?=
 =?us-ascii?Q?rdOGeJZWiagcyhUvXuDtFFu4Y8OyOIL6l5Dj1ciZERj7c/pimU+RVYVoYkzE?=
 =?us-ascii?Q?t8IF5UqgM/y28yEA0kDNBE4/LKYahgpsscmHXcXjKbWYF2Tsk6MQ6a339jQT?=
 =?us-ascii?Q?jjCfAU8brJq56UC4pB6L/EGAiWRKKUOp4VodyeEPnhCkis50T5IZE7bxxH7u?=
 =?us-ascii?Q?v4AmS2Srz4ikzh85iDqKtaEuCEr73gByvRr24zFODPzWBx/2XgHNED1X9BcN?=
 =?us-ascii?Q?RMBOVhmHWVi4/26ShvPWTiDRUBIMFxnPAddD6NEBbjEldpXF7akkU4qyTM4J?=
 =?us-ascii?Q?a4ey/3ANWBTPg40u1Mmbdp6KF/SiL0c/Lx4r4al/WHJwTTox2XypHnT90H/0?=
 =?us-ascii?Q?k1DHrPP5p2Tuk7ulLCGbkpX6OobjUH0MulhxEK2bt8IJe16voXZYesCrHAKr?=
 =?us-ascii?Q?yy2fLOGZAgm+avzUQ5ZRGKpbSnWHsenC1NYaOw5V3lMsceYyVFnI33YMUUIf?=
 =?us-ascii?Q?VqMN3LUI8TYFra9Fa60wm+IWXqkWwOcdr2cMEtMd/sVAi5fusx1P86Y7Uu4W?=
 =?us-ascii?Q?UQp27wvEknUN63CEn9Jj8UW1ze+tGMOnarvzooqiLqqk99dAGfYIXyldKKAM?=
 =?us-ascii?Q?zrZpuPxfgqqqbwXYHFaU5yNqeQSm1yZdUV5JrSItBFtVp+JH/RKJm+Lkv8tq?=
 =?us-ascii?Q?XS9/FANLxJtpoMu9Yl38XwnJT1aYgwMKdkiom8hAnUb3sAxPkANJHyWP/wF5?=
 =?us-ascii?Q?D1jL5FI8+c8rMCjurZfXCPkUqtJaREarbf6/ZcBHSOnKNG9i8HDT3Rz/S6kV?=
 =?us-ascii?Q?mepBcyGlV3APEya4AKTbP6/X/ApVhg/iPe9RVy4H/RMwEjRvyJtzO/lpRFD0?=
 =?us-ascii?Q?VSM1bxx+iStpXnm5oKUO3+PlJd4Dxq7m3slZ4J9lbABucls2JmgmzTkORzG6?=
 =?us-ascii?Q?3MQ2P3tNGni7YVwhdgJuj7goSAq0Kfj1iqig5tc5J5LWflFuvFrqkDBVPyRd?=
 =?us-ascii?Q?7HrX6MywXfu6V9ClwmZOIfkOGd+qeToX0v8BwumhTyTH+V6gku/tMZV+Da3A?=
 =?us-ascii?Q?bp/otrYzwzConjmYlup+gdYTgHe3+JRE0BXAsrU4vHrcOREQeekLiRg/Z1Pq?=
 =?us-ascii?Q?GpM/RDq4eEjeQMt3Iw5DKTi+tWeJ4MLhcb53C45eD0TBW2qY/8HAyu0MNiAO?=
 =?us-ascii?Q?0GPkFbRieuahoLct0PLpxgm1V5Py6StRNvl4kKm9IK076EcO+jxkSndhZNcX?=
 =?us-ascii?Q?RxzQQaCUZ5tNzg1zXAkDSFdJp5cAyx5aG3VrmfD3mUYZzTWgHddgYKrrOS7K?=
 =?us-ascii?Q?YEzK/8jZR+Vx/xVxYa5xnfM5lm2W0RQ08Lb0t1QnmWOWMVaY+4tvr0SaqOt3?=
 =?us-ascii?Q?hiP+a56wO+vG6oVJT2uVSs84QDUc0H9QhHGaiOEFDLz/0auxkJ2IbUfel4qW?=
 =?us-ascii?Q?krq7VcT1bwtJlE1Qn9FeOG25j4Diyez3b1XxtK1pI6fzQo7KE327wZMc6w4h?=
 =?us-ascii?Q?wESuUIvUfgrmQURt9e8q+98OeyDxazsomwODL+KP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128e55e3-0ba1-48f3-6268-08ddd51b2165
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:57:45.8811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivk1TrGf1wwSxXh+A/JEQtOkBnVtuD1aP2CCkikaC9Vmgx3CYv0CYODbhh/4ZXWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6967
X-Rspam-User: 
X-Rspamd-Queue-Id: F3C0E100005
X-Rspamd-Server: rspam06
X-Stat-Signature: n7yy4zo9udj1arftnwfw765schpfwf8p
X-HE-Tag: 1754506669-66193
X-HE-Meta: U2FsdGVkX19BGGUxSZfE0N/Q2trpC3GmDQ8OMYICkoklVmtPpDa0J4JRbQTKGwZqM3K3LVnVaDcFYBONmE8IdnXi9cmF3avLk/UsCMu7SkYQsj2rsxFgcRhmU9LaVDTgnjaXxpLWZXZAyCoFI7kojwUyKjiyE4Y1MU1YH1LFoiPdKRGVYVDmR2JD554pkfXtsj/GhLwIJyCVFZ055RrkGsOAa4ofuu3xgWhpcXEgkbS4bBoT1GkNXP0YnjoAzVXG7THTtWdq/b3+ueO+KGx2f+iwquN4t5mhdBac+iEXSNHx9ieCD8wUxOC10Rf3ohDiWmzfEgn6Ch2WjqR5uVkKf9tXzlRZNneeqGAFZG8pCwSXZRsEqhe6f50G8STHkh6xuBtUKpVlbD57T6ISypgg068pz+g9ciJxwjNuF8lXeMISz0KslS8WntS+mgELakSesZKcalmEMjQPZvBxt/JGxZkzKwDZ89plq3+Nxf48pXVvHZGcJNjRIeyA51hNF3uWjRIxK6g4cz+FeZVlWYiryh2JREd/8WJFqlStI/0Am/A5Ex5LJ2PaRyIa3GP5FMIsZIhqb1+B4A4dwEuXKegQPBX5vNUS53fZ+l4ZsnPrNIWnX1oLX7gqcmn+QYarI1vXcNmLlmO91Yu8AZCJBTJobMZdVR0kBbBf/c7Qup5JOdPiZccyB7O6a4qDBiEYPLa8Re5Q6tFdIhK/67mlJPm1VzMa5jYyuA7HIIhCo40opqFIxGca+FkI6EJNBbBOHWqxfuS6+0dQkfmCmqSgAfyKjQgbzg7vfHRYOfXMQDXT3yXTDcjEdY/vMrD+ynPM3GqHyvXQNVqhLnfFv1B3vJyVTFlbAqp1CBaj9Oos31FUJBc28JEPbcuzgf9VxUkz+mWzRYfONugnsIEyMzaz/hEC2Z1QBkCG1HDTCKSYBYoaEEscmWzeohTpM9XBMVfy3yUPKICuxhwQ4BLyJ/6bcdj
 XI78jwhB
 oG7vyixtvZOVABPe+p6HQmwXZ+X0iWbYMabV3M2owQnu3PEDvQMHXou9KxKHbrThQzXBdx8d+vP+V5iFK8kVYHwI3E7jeLnCJcvZ5ROKxg9opus+Fs5tDSCxuG4soZ0oXNmfSymEpQo9oXG6xLFBMMZMztzIizG6NXRxi7PO03A/ZoHKOzkqgWnF/3+sozesn2Tyy+Lik5ux2jVqPad9jYovXp0TMaXUwsIGXjXT0ty2/ASd+d16G2MkVzGKURx3sSvL+mobtwi6Y4An74fVFtIhQ0lHsi7s6hYttMuNbJkwCnYOlhkGIAM91g+C6GDKgVILBdmCZbtlLQy7FoAPcWQQPLitnJa7OW2Y7bBVVc+sHnTnSn4eiRcky+YjH+Y5AEnMEKK3edOJ/6LeCF2MKcML5mdIq/e+pg17IHGILnfdTAZcXg+rB9oPMK3QTkEVPC9yGnCOGF4BfHGOT/4yp2lR9nQeYkVQrhLrHcx7D++PSTPMWMaISYp4LHIXMBkQn7VR8fz9f9zySJyA7EPMveatpYEIIMV7VcFxejAuF/58Ak5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> Remove a conversion from folio to page by passing the folio->flags
> (which are a copy of the page->flags) to the new memdesc_zonenum() function.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mmzone.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

