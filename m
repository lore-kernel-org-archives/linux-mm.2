Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C96FC54F4C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3425C6B009E; Mon, 27 Jul 2026 10:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319FF6B00A1; Mon, 27 Jul 2026 10:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CB06B00A3; Mon, 27 Jul 2026 10:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E75FA6B009E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:25:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F8B1A07A8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:25:04 +0000 (UTC)
X-FDA: 85034778528.10.DBEDC53
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	by imf14.hostedemail.com (Postfix) with ESMTP id A8680100006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:25:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M/vQ8J6r";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785162301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjRbhPlL+p/zm3QIFM8ud62vv4kPxVx8SvFyJE8Wx0o=;
	b=HbCf+ZSjNdg6tZXfa//PNpAkdd0GkWMJeKwdbz5J6mJ0c3xd+gxoxq+kKbYx5n4AVyMPJG
	Y/2MWnT+VRBUciroKZUg75+ijorhVrFQBwnkGdkczkYbJl2Wy/kt3srkEryXq4zwyKBy65
	GrmMAqNsHaH0pX1hIuQIC+QK7NmtRKM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785162301;
	b=qs3DM+lT6r7AaF7US+2JNB7qM/rialwT1CvqX4lDOXGt7eJ2H6B8viHzzv57Dd2iK4x830
	KIWhp9YG5SDxttY2v/04NQrd3vyzOH0LpTMRI4S9TeyS5g8DNPUA+PPaAEYhuF6tXHHEYM
	hqlMxwofIPv8iGiR2K3gbeit9ohsD3k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="M/vQ8J6r";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RGxxugrLnzW7WLbTvf9aDnHYmF5zg8c0nRic2g+S7sQgLo4D8M8SN/VGmfkwSpCiLbj/Lcanw17fS0UWgsmBr03vulLvFgpEBT/HySi95sJ4rZ3A/+rPFucRm1Azwk1DP+cfnINis4q70x4JAFLeF3P0/6bkFjYyCZr+OI0ujkkza/CECv+d7GRFT8+O/AWcAawFhIvdPPOJY4u4U/kqsBMVaTgq2R4KxI6dVoMJEUHOOrUHbNVZf9iyPIOqHRcecla4tNR8KTYRikmzkOZiMPdglgm6kqiOWjNR1xe4cgNz1JTvkHXCmKf1SV84kMHbe3w++3HHHGKIBK0vogsAhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KjRbhPlL+p/zm3QIFM8ud62vv4kPxVx8SvFyJE8Wx0o=;
 b=CrvywVRqDw5rx65B3ELup9/4KSfAcRe+SG2gShDj5Yj3D6er+8j77MvR0AlMimbUwEhhzHVq9DPk30jfMyy+w49+JsWeS5lno0+F0UiFTT9BFm42nZvTwCDtyce706eG0CB8J4R7SIiOKoE16HbptFtC+4u/QJM3ZiHCeOXKELloExhmPJmtMZHy0kLjmGwPyhEehY01zp2imxBl1VJ9V72qwNvS2GGVFS1ccKW7Fwqn9f1Nq92Qg0VCxQj7IG7XqQxYIb17a+hx5N9jJQMC6xBDYMLw3IviolIx4w/jkq94FqL+xOrLUtJtoW7/QvWXZ+RUSkQbVRtRaTrbeu68yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KjRbhPlL+p/zm3QIFM8ud62vv4kPxVx8SvFyJE8Wx0o=;
 b=M/vQ8J6r5rGzgnZ2ZstNkHQGcYq1ZLXB+Fv9q8jiMSa3GaUiVi2OYa1VMbX8jZ4yHX24FIqqoiazI3FkmVX8RFc/IGHr9RqYI/pnBjcMUjlXeUiXqDrumRXPc6qA1eHAZim1A6krv0YeMHDAe/+0ENAaDTnajgELrDKvOwbc0SQJC4pSCumSAKIg8bldAcdDJz/SiP5xkmk/qskSC0Es5ifEMQlBv2cNmtiCHfUPUXaculjdTTOT/pXwNT0cDUPo82dULxir28NgfbkTY22vDCHuaWsaFohDO3IPOC6ZEHKONrhRbUm6fun6IGrngHAoWuepuL9OaJaeeo9dp82zPQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7500.namprd12.prod.outlook.com (2603:10b6:610:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 14:24:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 14:24:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, paulmck@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
Date: Mon, 27 Jul 2026 10:24:52 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <175C6638-57F7-41D6-8906-3F3B5D6108A2@nvidia.com>
In-Reply-To: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7500:EE_
X-MS-Office365-Filtering-Correlation-Id: 041b7e27-c946-44d5-f302-08deebead36c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|23010399003|1800799024|10067099003|5023799004|22082099003|18002099003|56012099006|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info:
	nUVk7PfkxujiJN5pRo2I4AoygaO+UdVBkLYIwDpJdIosup3Th35mjOG+YovMLVGmu8xGgWphQZZWUVkv68ALp0BQMcC97oWqWWBKghgv+S6u3dnaOKGX2kQoYGn9ApFPKwjf1tkZgwIuD2nWTR4aY7RfDpBuoYCY5p/aqsgXf8sdS5qOJ8LV0BYzUKrpwvO3DurcIVgHGOMxfE1d5RipdUj2zzb86Z/F53Dr0FsR/xThva/8FZ35ZQlqILmxJY8Wx6aRhG4jnUNM3azBhT9LsqWlt+IVePyz5pWAz+ahZSvnXk9nD5eu729QpUlQHQJX1AdWFaCWmmHKjsTUIrTHZ+GmGePh/j5Z94GpBL0O0/0mSfSEsrExDapTzF5oOlUJywVGvw2AO0du8plK7TU1fCdnMA7Ow/LOXjyNR4IDDM8IlcYb/tAzjWv2+xKSNO1/wdRoykg8CLtvSUk/28JhR3x4vQnaqPrTyz7NfZiKr9H2pv/14I1MpG+jP2YhrxPSYhRSp0rVTlKp3Bdsp0x+mktYy0gQeYscyUu/poIuxLeGxSY25qwojsM/Sg6eqKpK57wk+R6iPBUdWT3Y2UV6NBLxUg/Si6RnGEkI1o2uF5SnA10VVHfiERuJH9pWhZi/klKGKB1s0ufXSydiLMtMwQ5UHleU/HAch9Y4fAj21dk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(23010399003)(1800799024)(10067099003)(5023799004)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3w8Ecbql0B6JVet/GDwvieybj8zMxobcgwIdVZHg9Tv4+0eQFGH87du7ynlu?=
 =?us-ascii?Q?kvEelkoQKENecSCw5nWYrt+OgpVWhuwInsdFOaoHUgZZcfIutjy8aKJWOrRr?=
 =?us-ascii?Q?nD2hvsYBuhWJEG73zfRBcvixmz8IQ516vjknUNiHYghVW+21MEOsvSu2HPCp?=
 =?us-ascii?Q?PhwVaBNRCkJ3bopMBxBgFBKLQJ8QWMNRSCDnJm5gQnAhspsJF4fYkWBX2+k1?=
 =?us-ascii?Q?di7j/jmVVVloUu1D4EsWjS5u34GBdejx+CLsP1gjMRM0nrtJzMDaUMssG++Q?=
 =?us-ascii?Q?YNAWSYljKn0Z9rzAKYkfmxUfmZHRDphJWLD/7hqesKSrp51znw1JietKWf/2?=
 =?us-ascii?Q?MMSjTMfR8y8hL27e3mJ95t0+CISz0R8nhbHrBD01RLA7Xt1zgzDoTBwwIW6C?=
 =?us-ascii?Q?Wp5Ot3fDv4lzoZh7V0k4jRdySkHgrHE+T/q210fJYWGa36Wup3rvomUbLhvp?=
 =?us-ascii?Q?D4zOQUI2vsWj+IEqMCf0E1EsYtdDoP1ZvlQCB536FTLtsPQNJPYVhc0P0iRo?=
 =?us-ascii?Q?wHTBYAPv5nibXu3A2I7MxiiddVdd3eEq3fUB8cTMMcxvnahG5dzKX/A2In8P?=
 =?us-ascii?Q?mvluJaX8Jbt0UxK4uAHge7F+/TpsvGdxg5YEKHqRukWgz5iKWdw/7BEK2q7l?=
 =?us-ascii?Q?ApZyRusuEXiYGyMdKH3PNz1VG+XbPJpPCuPKUIQIGQKjuYzsEKWx77HCHe5p?=
 =?us-ascii?Q?GeqldBJPcxKdUvt+GJRVxQRrBYoNNAukPBadv06dJGtry3GNa92HBcm+CLXs?=
 =?us-ascii?Q?XifpvQBdGQ/AOWLT/KduxWaFVbvSyfwtTGudpgGyFRzvpCeuqK1nT/x2aL2Q?=
 =?us-ascii?Q?LKGk2zrWgqPk33rh96KP0Hpeg0uFJBjhdQH8t4aBDwrHra+SpMVDNHF/pOt7?=
 =?us-ascii?Q?/j84sx5zJ93Zw4A4t4IYwy5vv2sYsOwaOYZ9C52iAccdM0TaeEzFVa/ArPHx?=
 =?us-ascii?Q?OEfIYxwL8RWWVjfIJcBrJxuKONbTn0sLDbeN/znR32L99Pk22+Nq/IDE2KXm?=
 =?us-ascii?Q?UXNE+h3HQteOEvYmW/mxjRuDHu1G/XQfKDnw1vGTHnUAJ+16zxBWkSp0djv7?=
 =?us-ascii?Q?Ny5FVkVE7s06K5kq3gq/sSZ6haLUlUq+UBtiucSg1NWnXWUfJbKL9DFuPX9O?=
 =?us-ascii?Q?G0I8NYlwokw6MpcJR+zfrY4yLTx7zCKpQiuGwdj4ePzd0x7Mp3DBJb+yBA5v?=
 =?us-ascii?Q?WPVwKIDWMawWPf4WxvLrBmz1R4rWvX6KiV00ZvBxWdup3A1fsmCf62ZcNVU3?=
 =?us-ascii?Q?os8WGz3rEyQnyEHbsEulpK1YhaqfDj+/iRWcmfejsTBmn7LnhiNfe4R5giTW?=
 =?us-ascii?Q?QSADdAsFMJgw1EQGIrQkEqc7pDI/XGIm6p3Um4S0CiMvpvhDzmKRLKJwRMXb?=
 =?us-ascii?Q?S/8o6JOkLD3dsHV2h1IwlokyT8Rgwff4iNu8f0Bq+JrLDztpanIkvHyOAprp?=
 =?us-ascii?Q?bQnyQHW6FnkxX2mM9X+f0cKlXPdTh6y/9RiMrfU8IMRgyOWDOwNNQYgZG6DH?=
 =?us-ascii?Q?oSESBTFM9yILtp16na2ZGpeqsCAPVAVUTv/1xwfZfNaCvmHhgWCxBGm1QadG?=
 =?us-ascii?Q?P3PVmBVbnIWPyNeH49nWSHXuyfr7lRRYM+rxt+tq7bfunxqqYgPUaptr3KmN?=
 =?us-ascii?Q?FgOeiFIo4doR1PlieZhlLsmCrRlqCRjeQzOHRnKWZmBz0bHQ4gU1i1Rkjvlk?=
 =?us-ascii?Q?mFezLlrivQzfQF+W4fzC7W4RoBl4M77XMNQN6B9pmKBDrEop?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041b7e27-c946-44d5-f302-08deebead36c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 14:24:53.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwyQKLHvKXkfQn+JX6DL6JGjLiJenPavKsJGiWIg3F1SUZTD4+JQsVZumF1BToc8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7500
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8680100006
X-Stat-Signature: a8btfsu9mgt8wi3fr6ycm346cwyej1pf
X-Rspam-User: 
X-HE-Tag: 1785162301-763611
X-HE-Meta: U2FsdGVkX19X0apmY0n8CWJyCyHcCXNK59nGGZdi+XrpJ7Jj63HxN1phcDU7X17Q7gsz8CisgTfZ8x9/j5/SYdpqPN5WVRG0H/4w2s8vyvYhDSV53xQbecnWS+PRsLGiwGBZhLFEiColv0x1wPFY9nVSvuacqIjJwH7vO+fG18FirPfDpLF2HmmYjdbesTqizPYK2r2GJHxkFJGJOhFx+vLaNpoNJkhaLtSTuDn4zBTCQK4FjNZabv8RYYHsw6i7COvoBhSDaWEUaJitrfgjmPaiQIKMdurrGKBYDmy0c/YWQKJXb1FdUGVyRpgsUu/fhKSHmNVcgoxDGRAQYKrqfb/qGH0urtr4WmhloQKq7oQPmEBHWcBHoB7fyBlE/YZs8ZD1LMp7YB26FXiG6Z7pSKAuHTHqVy8l4hEF1NsioOr1JOargYesz/b/UXInMetuIxRLGR2jCFdoSsGPGsybNidpQlJVD7MQsR6bpn6EHUzJY6VR/2edLPhOyxBRXQ7BRaZh3WsG/ZZZawnd1bMzQMPHDFk2w93tZXAZcT4db4ZFitdyXEfftR1pcGwEEyHkdiSWaPXsw+CNM90EaN/P8HxrU/LhDKj/JDmrcBJRZWTsV3o94eFI0WuVc1CKzZ3CMzow5gYFQQCs79Zr726lq7UndjMLZaZfjsnnKbpUECF2H+HHJDI51qVG5Yv23spF8v1DFOFKRkn8fin+LpQQ24QmmPH56OkkZK3Y3uxyxrpTsrqjTift2PqJLK26T1RmRNxLXVzVSel2S2yseIoFkYRGH+5rdHBrPMJJNzLLEbSf34UlGOtS9zmIVfndGoHw71C+zpwQewEzB5n87JzIHzII6KZS4y4N+A+A2OsEi3n/dGHkO89oaJ54JdG50/1o6hiMsMz+xMxjBtf0zP1bBHNpNt+9A0TUrlNl2+y9oS2GFYhboMaK1aALiF9itQ/LbV0gUeKo5hUNltUr0xi
 Hw1b1zo7
 oaibeA4jFcEGuf+EudjRWlIbbIyn0+wRzEKX3bUK2MFKt0erI9OyGbCi1Y2vClus6KApR2bcmKU3AU97gJJFdYYuBaZq4RtYznZHgypyDLfp0lOvJHZfzaB5E8Lqw1HhHFQVzbh++RQQHYjFD3XdN/qm6WdccVH1Brf3LiCj7A53XUIXNV7y8IkaYHwSANsr2S+YaBoYVwNFiPj6EhZ9GijpPRD6SMk9Qy4oSPWYCiM0YWUAXXe8Wd68pj+cEmruO21NomvvLQH/9M9+JJQ/6Vh+5HW565foD75NTqP+1GdZ6Nm2TmNOmpSmrmUHXyDrF8dh/JBMKXrTFzN09u3VFMQ5Gm0rz07T6KGzzuhuCXgSwW6KODMt6O9UdsNumxcsaMxRKIrWQMASn1gwCOxiiw/qMTmA24EO7VZ4SHAvmQQHTedNlu2+4GDL5oymzG8+oPNO3MpaoRPg33CBak7svAW6iejH3AMkdmTZXE0jZNAbcJiQrgAdh0tZEEeJG4zQpRGOdIWSTh+Xk+t72Tw4V4B/xPB6KpsDK/L+LanP11enKQfB3m6z2OG2oh89FP4cptotl9yAkaIPgml0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Jul 2026, at 9:50, Breno Leitao wrote:

> migrate_pages_batch() unmaps each folio before moving it, and every
> unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() -=
>
> tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch kee=
ps
> the CPU busy for a long time.
>
> The loop already calls cond_resched(), but on PREEMPTION kernels that i=
s
> a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.=

>
> A long batch therefore never reports a quiescent state, and the
> migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling t=
he
> Tasks-RCU grace period for minutes, which is common at Meta fleet:
>
>   INFO: rcu_tasks detected stalls on tasks:
>   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/5=
6 task:kcompactd0      state:R  running task
>   Call Trace:
>    tdp_mmu_zap_leafs
>    tdp_mmu_next_root
>    gfn_to_pfn_cache_invalidate_start
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    try_to_migrate_one
>    try_to_migrate
>    migrate_pages_batch
>    migrate_pages
>    compact_zone
>    compact_node
>    kcompactd
>    kthread
>
> Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
> when cond_resched() does nothing.

The explanation looks good to me.

Acked-by: Zi Yan <ziy@nvidia.com>

BTW, Sashiko complained about hugetlb path, but hugetlb does not batch
migration, so there should not be an issue like this one.

>
> PS: This has also been discussed at [1]
>
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ab15a4dddd047..b937cbd764808 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1843,7 +1843,7 @@ static int migrate_pages_batch(struct list_head *=
from,
>  			is_thp =3D folio_test_pmd_mappable(folio);
>  			nr_pages =3D folio_nr_pages(folio);
>
> -			cond_resched();
> +			cond_resched_tasks_rcu_qs();
>
>  			/*
>  			 * The rare folio on the deferred split list should
>
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-kcompact-ff0550fc0ebb
>
> Best regards,
> --
> Breno Leitao <leitao@debian.org>


Best Regards,
Yan, Zi

