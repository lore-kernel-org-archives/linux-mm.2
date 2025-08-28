Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59C8CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 01:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37D26B002E; Wed, 27 Aug 2025 21:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE80F6B0062; Wed, 27 Aug 2025 21:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88AA6B007B; Wed, 27 Aug 2025 21:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1FA6B002E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:48:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01FDC14096A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:48:40 +0000 (UTC)
X-FDA: 83824482042.28.619DD09
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 873D7120003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:48:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WlbPSqWe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUrA796v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756345717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9ObHZdugpVgxEo1dpP8JBXsdmvMHlAkc9wSe3dJpCA=;
	b=36XITzxHmBW/So61nR/Z1TvasWSVDbzEHhiN1ZDXEcPzDtu/WbLJmYXc4no9QonQaJfOMO
	ABLh+tHon/d4w+4mSqE7gU6IPBcm09D9PVfC1RsgMLn+tvCDpC+nGRHgipKdpdVkx25fvy
	WNSUEepR4/MqWcZ0w7WGEQZS7c7Ug1c=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WlbPSqWe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUrA796v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756345717; a=rsa-sha256;
	cv=pass;
	b=vFt9qt55d7r7XEsqQJF7KMn6uMQQuLTJN8GZwNuofdXLr7x99MwLP6+3MlOkFrCiS3CQED
	8n7Yq8NSEDv9m4r7uzGNAuLAAM3EMmH2PTxFyX0ub5wzigrZ0EDmf607647dY2wcSQR6mQ
	qI4HMIbiXFMZp4115Oqc5asORdjvnZA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHJY0002020;
	Thu, 28 Aug 2025 01:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g9ObHZdugpVgxEo1dp
	P8JBXsdmvMHlAkc9wSe3dJpCA=; b=WlbPSqWe9OxiG2ZZL70jH0k/AgqSmUHQcs
	BV8fEHTy8bK/f+NkPdn+5CQF7o6yHHFAN4CO3tNrUNe8iAlaPJpzGnQbfctL0kvk
	TjMRuxpR1rBdl7QKO+qfHPFCQy24abiUhMM1Fr5G8bmuoKBN6q2XNTGSkJxsVp8h
	bkx/j6BFIrTGFn/jqwoCPs3EtuErBgXYVB29Z0vgLK1dDxGYz0v7HyAC3eyfeGNO
	I4+cpNKI7tcfE5jWGIPPlDytQYMF8PzD3zdOiln0dJpadssr47sDgORDoyP1VtYS
	RoUjsVjmIGmrocKVmEX7N1/wzKT1bODJSzsYv/Rz6uP99Zqxb0EA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt7qeb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:48:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RNi6dx027538;
	Thu, 28 Aug 2025 01:48:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43b6c81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9l4TE5A/FHnEkxaJTdTEXMDi+rchbMqg6QB76ewMJq8Ogl+XWQbri3O2s/QYLWZpNLUA6W/PHQb7h5Qea8lpVTDRISvkY2cVmAUKcGiYTCpH0GRL8jR1gE9YNonyk36+0qaIg4h2WDvoZY6Uq51QuDzK3Gy7juM2VZENvISyFIYW89wH/bX6B6OrIhXzMpG7NRZw8GxmI9mP8jvMl0IM49YJ/LkLdhi9ZqJXNKFhVbBiDcvNT+Ab9Etk672A1SxwqqvCFEPNRHHnfE4J+NVcLq6oFzRWnZDF9+TOXF8mYtwx4AJNFKNhXME5DGl/F9td6ZIj5PZ5JwQ7rCMTE6qBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9ObHZdugpVgxEo1dpP8JBXsdmvMHlAkc9wSe3dJpCA=;
 b=N6n0z4GloGUdvf1qm2cTJFYtjDEPHDKz5Z72J/nqqgwfnGzf07gsFvTKJ3Ix7ErKUr5FxpSm6O9xaEIuiK3tSPf9Yl6Kj+mqUZLfBh/PeGUrz3/MJQqLHCzzxmbU2+iQpqU39Fu3NfdOoitYBjZTqCGvaV3lb1RIrPSokxr8oLdyYyLTHOlYY+dvxQPD9TdDNG91mtIVRkYpe3svoT2OjX6016p24SldtuofurDhkmInVjbjPJpdg8RfrG+l70sKgP8EALrnOvUvs2J0ppaMoKU2ULiPKcq2LIdSIglU1Xo7vhh1LxWRkiM23rpJEjPVa4IwF9t+RiR8jUNzSPpRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9ObHZdugpVgxEo1dpP8JBXsdmvMHlAkc9wSe3dJpCA=;
 b=GUrA796vR4opKWwiik5lSCNmtZ/pcT4qe65+E28LZaLjPxcJRWGjELQNPKni6RL1k3oNaCp6w+EGd1fr2PWTs7nW6zk9G1xKxBMvg2nBamc6RvL99tRlDTWBv0SqvJ36Bkn9m+7yOjf5b0JJf9pYVwgcuI+Mkl9hXK++bvwCyJ8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7152.namprd10.prod.outlook.com (2603:10b6:8:f1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Thu, 28 Aug 2025 01:48:26 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:48:25 +0000
Date: Wed, 27 Aug 2025 21:48:21 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Max Kellermann <max.kellermann@ionos.com>, david@redhat.com,
        lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-ID: <wmxlcvxqx5qmkzpk6x5fducmmv7giget2nwsvspw3uouufngvs@kxoyppwsyxrv>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Max Kellermann <max.kellermann@ionos.com>, david@redhat.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0183.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7152:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d033e6-b968-4112-485a-08dde5d4fa71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7053199007|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ICaUiJtBsjHgVDv8H3DQMJj1fpvki25ZVPvIelWncO5vR4JiGZTNtwO52isS?=
 =?us-ascii?Q?SC24SUae6V6UHV9Zj+i8/zxQshO08hWpklWGpbl0LCGcyytgOxnkXzB9FjZf?=
 =?us-ascii?Q?ozFwAHoOibRDjhJARMb0lXVjJ6dGoT660kQWFPPXX4qTPpbeytpZa3W+7fPa?=
 =?us-ascii?Q?CENKmrMnvqyA+pYSZYDKW3Ke5UEGrKcoCumChK4KbgkoYchOgT4imE/H61pZ?=
 =?us-ascii?Q?KPstL/tU2UjAPw0v+4QiffBmL7tqsH5oO9ae7eESfvP/dBVnH5puctyEL6Ph?=
 =?us-ascii?Q?o2M4N5Wa46kPCa6x5jCMJrwcYTKliYG3SZjT7Zu+9TtPGe2YVhr0/sB2TpfH?=
 =?us-ascii?Q?wL7yR/KAScapBFDu7pN7nw3ImXUyYmv3cnSalqLvoccXINmDoqPYUsEAJq9M?=
 =?us-ascii?Q?2y0pzzZmGm4kOy4uVx8JR7j5bn1s+Z8Wbdsg4VXAZHX9iSOsVDSh88kDXADt?=
 =?us-ascii?Q?xl/muQgtbwa60e/FxcKe55kjdWC1igDWxpAvSGp5bd7jUiwRJFVLUaOWKaDO?=
 =?us-ascii?Q?vBAOeg51wkUcShnF853E1okdXXBouSKRoEovyDjbjYw/O+Oqw1M3vOKZoIQE?=
 =?us-ascii?Q?PKJoH290SJxCqVu6woFmE6d55SQSuDJNXOy7dD3NFgIOZLvD20SVqUzxXbGE?=
 =?us-ascii?Q?i/jEsY448jhEqccuft7ccrs0ZJxA7dQ9KT1/Y6zFGZtM2EpJHbPOAeT1aOC1?=
 =?us-ascii?Q?aGjIbzDNc7LZpQ+1Xe2IK6/IXZG6efupwnMGhiWDUmzxrAzg1vQEF5iuGCG0?=
 =?us-ascii?Q?xv9ITgyvADibjv/x1BgbK0Mzba139a/kXAxRRJ+OPlDFT79ocTid1ZzbG4vA?=
 =?us-ascii?Q?xu9DihT5gS0URwuBAbln7RObrymu2sFco8w6Gxebxe5u5Q2wmx5I/aTgrack?=
 =?us-ascii?Q?n6Q3Ga4cfeH77GJaw0hXBSItixZrB705jbx/1v1JSwizUhPSWFcIvM9eQvNU?=
 =?us-ascii?Q?M/EYn75x3dHj5fij1vhO6UH01Zy+yhQ4REHIaCu0e74XVjgaDdelbkgKWI/x?=
 =?us-ascii?Q?TKfIS66zOOwpjYdst2yq7lt3xGF+TUIm91eKEbyFsm8VmhCzTeGkjTo87iAE?=
 =?us-ascii?Q?ystUuwTiHjxRl2lvgULPZCmqv9r8lWf53GnA1FF188uiHUgmcu09JlAdcKUj?=
 =?us-ascii?Q?Ek91Yh5shvNr/23etQJJzcTCU/4P3srslq4xw7rbGuZLnSSVLp9tWvhFq0hF?=
 =?us-ascii?Q?whOdRHOBZ+2E03jA5JdD0hLKPTQy733pgu9f6M0JGjkqzzWvD3+scrfoYMt+?=
 =?us-ascii?Q?l+WCBndW5mFNMNWTv3Fw8PBYNaB+BkrHzN9G47E5ZLJxxVyCIKhzxarBBHQW?=
 =?us-ascii?Q?NQO7UD6ZdKndQJV91oivc4gcsWDvSfTHUJ5zXqsfQIJtwCkOp/bnbuSY1b3e?=
 =?us-ascii?Q?JDxQ9slBUmiLL9gK4xXsWlqz16pAgUeM3mSWhssjN/7xBtHQ2IC7i94CsPS+?=
 =?us-ascii?Q?dAmp0Ts4BpgUM0mAHsuTn9n3AQ3Im5smKXv+br3yGCiAWcbXh3IIag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HCPgGcDJiz4NVd0fNyG5YHqZrvqeYhhNaWRb96V53WF+qO56XMf2/n0QL9tu?=
 =?us-ascii?Q?E3C0Pdm0aR/JWALoVLJ4gtuSbahERC7Hw8oVx8O65Dcc6GOFTn9WkrP/BWNq?=
 =?us-ascii?Q?VIBWMKGYClhdo1+4avy4wA3iAnf+1A7IIP6Cq4SSzSC3C9UOYqXgsXOYA6kt?=
 =?us-ascii?Q?e6Wfm9ghm5uKNQQ+W1XDrRUIS6REdEQt0if83GkxF1ACYJgLfUfsb7K2DU5f?=
 =?us-ascii?Q?CmIUT2HDi0JyvZmzI0UqVz+bx4ofpXRzV5vrg7H/xKl//cPmHRHhBexwQ9nj?=
 =?us-ascii?Q?N8L2ituGwYvQovCwiwjQ/GH8yTiVxiC6+TlkSeDQJ8kV+s8mRiKmuFZcIpT6?=
 =?us-ascii?Q?DJYO+XPyP+d/B5p9zfkobNeHPlWUItw6lKzEsceP8uFtOdTWhT/xcVLrv6MB?=
 =?us-ascii?Q?HbRLmAuaGXzZ0e01DLijHOumQllt5DsAQFGqOpNdGNT2Dmx5xri1jra9U92s?=
 =?us-ascii?Q?KnKyeWmLQzFlYT2H4rlEAu8NGz9OVEk/fxdxrRa4PwFjl67oKKlLEWY/em8K?=
 =?us-ascii?Q?AbwTohbxnwljMswnbvsJ3BH0L4tXrLaLP9xQUjPo0yEyOYVqXKH+sD3Pg9Lr?=
 =?us-ascii?Q?UVbnBDlCcgsoQ2Le++cJgKy/5kBHw1xM1SZWmkK+O3yG1w4EWMDuYaukGpLn?=
 =?us-ascii?Q?wttWSlbJii3k0d2gG3kwTcyB0FXnwwYsI8GYxSukVUdHTuk6IMCQA8/n7hAy?=
 =?us-ascii?Q?RoYN+3O8r6vlSYCwSPkzjnBu8yhoLSBroKTidHE4EOwvL84dADP7Xet3trhw?=
 =?us-ascii?Q?sIDMGJmcrPRqmSuFIZ/35TC4JxBqWBS1zDyvkraitHnv50UAJnMiD5oDE7oV?=
 =?us-ascii?Q?wx3N/LO7fkptsJYTOA7gGt+UpE3yLLGIcMEeINpy5D8S23W2mu/E5NzENdUr?=
 =?us-ascii?Q?FLxhgOAiORMrkwVmFA+pzRP5Y1DLFD2hTtndqRAZERwhIDz9QqgXfF7Nyz7+?=
 =?us-ascii?Q?/bSnGtPeX7vgalN34Zy/ZS7dcF/UTH0ztcIAjN/1JPqs6ZLjNSzFsFqXAUTp?=
 =?us-ascii?Q?UthZCPaU7qeYeMw0VdRhGGj4EztXGiFJe9Jn76LYUUcMbAF3ROxqy4T2yKud?=
 =?us-ascii?Q?0NEI/i6F9cMA/JLtJearkFY50WH69cukHWhEMO8v4K0y0l4eWyVq3lnsceIO?=
 =?us-ascii?Q?lxLXwe2a7xrtL13TI+GkUPTjjK0WGG7I5+yO4er9Pj++9SqkbIvKAyCMKsFE?=
 =?us-ascii?Q?txX033sWTy31JJoMUotvnIEkDozRyAzA31IpkqPKsCIXTgl207OX9HRS4vME?=
 =?us-ascii?Q?R7scFoQYxDA0iTQ+xrOsNjxMuRcq8aZ59zwjU0XHN3vcHhcDYHRZXc4nal7q?=
 =?us-ascii?Q?ZgZCrHnppfiSLB6rQKEybHSUS8ZxZr/lUgpnGsTKuiFhe4t8WNII47FsQ3W0?=
 =?us-ascii?Q?UAUdqdJArvZgwuViSZgz5OWJxUHRH6hkvR9kRXmrRMw1ss3sq3o7CtGwwFsC?=
 =?us-ascii?Q?dv/lGzPJzfoWvaZPiHfdhT387IY+ckyWwxoJF1HFh02DhTBswM+PT+321dT5?=
 =?us-ascii?Q?DKHA9+vPNGyWlaBUEATpm7of6E+eHr++/CgIBk+UGKkAFAZYquKn3psZ5Fw/?=
 =?us-ascii?Q?L6fhLgUlX7oaSuQGfn3Gmst5PAGNhUnJKVyNeF3SmjYnzm3u4pl3GvQpWByl?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YvTMpx5BiPcMQQdFGix/ESBpl9n3wXkn2H7YxflWLfp7s2iX1v45gthmoG1NlIBdlVYt7Kyp50m5cPx3Lih2AzBkeAoMSMuFDB92PYgAVYvzrNxGNOedcGBldC2hYJEWZVeADT/epGMrXRluT+7jCCvhuhZNii91YQUFXyliqrZ0Z0nm+X8rAPGb0p+dP/yq3++A2hk+fDV0gotNz3thwgdqoqWJP61d0OrYM2Jt3KgMFPUvivdoNU/vXWQ+u3lZ4faoDh71Q2yWQ6W5A8BKM07MnBTTf7ZxFvBUWHglMIVGkZM2zGDV2ee8bsYy/SaB26Ox2t5urkyyq4G00IIaew/Af/80zzWbZqLlsxSfPrFjwBYVw5kIGq1LcWcdWpdXxbzQACF6hZhDwoyXGoa0+xHdkKCjKytajudmUvZhawaThZ+58bSXRElRjIXIunYBnnKJG4Jp2CsQ13+n9fKyG90M4XMFPBCnaw6Wm6xiOFnYpU5Xr+xH75WU/pkbm+6AuwkL5aMc43kQJN3oJQqd6VKiu7JHA19sI7j9RE+TyuHoPaRkXwrn9nAURSXlgL9uLl7d0mxDNPiliJDsgvZqpvKGHB2Ot6qWkTDRd6/Yr5o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d033e6-b968-4112-485a-08dde5d4fa71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:48:25.5680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXInUMsUNSbp17yEE7zbBB3yiR8045x0QCtvr0bIJqITNN57AQ5259yf/3dnQ0wlgM8SiYFPCU+dY025ysc1ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280013
X-Proofpoint-ORIG-GUID: FTlF8C8mbPlA9c-Cxkpqh2PkNe-Bsrp6
X-Proofpoint-GUID: FTlF8C8mbPlA9c-Cxkpqh2PkNe-Bsrp6
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68afb56f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=UgJECxHJAAAA:8
 a=veKPIY2cyrZzUK_aQfsA:9 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22
 a=-El7cUbtino8hM1DCn8D:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX8WfjBu1Cq9EQ
 h0wxgk5ModHdKzIGDolOpSEdlC/L5g6y03LuN8lIiGHyExDhC+08+j4Ji/vk1nP29atyx6P67Fk
 6CSeTwFm5xQPOGSkdUA0LN0t3w9jS7o1eVXfobnPUy+7saHXV5Hbsg9WIUaLlJgQ/t63s6KRLS7
 oZaf0icbbueZs4RCO3g08JO6YzK8x62sQiz3k4flQ4I8GamVy+ZU5Br1bfjK9hGtTZLf5Kln9/o
 s3yZmWuQaOcm1+Je0yCxo40p7aSW4rxJJpCXuFOQjPofSccpKoAj11zPmk0UjmxoJlkB6oUR2OE
 wbqihyjLH/upp6Y+Jtn1vfFyq4nEkopWxKNTET1FsHvTH0oMimMlOr+jxQBq58r7C5cRaj5RwmY
 wDbPfFFd
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 873D7120003
X-Stat-Signature: h8dozaah117t58frea5s99s1rgjcs18x
X-Rspam-User: 
X-HE-Tag: 1756345717-802981
X-HE-Meta: U2FsdGVkX1/ZqMcR11dkjPxhV37jbTqEe+CUMXWk+MZa1O5ZStXwHv9aZcTRBcvGUzvWu31Q97oe/dod0O3XwhgSNYnVO3XE/so3iJ18QDyamQLNy14wgMnEnWYV1xuj5fN2CnOVn2wT68ABTuF6MBiVhWMxcCqlF694I/W0Ww5O8hQPg+gSf9vPV67H3IW+ht81imkV9nV6E9jj2h2sQs7v1BDnPBolFM/NGV580yMvzhgXjUl2WwXh39E00iLYR2dPAAPTnchL/I+oAkS3qkJ0UMXk3L6aAbJniWN/u5Oj6u4m74z3Ev/FLKfAYXehxzPbE+ETLpEeom0QQ3SohkxzbiW7c4tbDNLXkuOtDcbKkouusb671Bv4IOfRna8Kb3715ZKZ4oS7dp3qhQcBMk2KWUa6tmfKoD/xXqvZkbGTzxBVgZUBKq2JUTXZsqLiLDG3q43+bGWxJiA7GdXMrue61YIfQ5MVPsJu2vVfcYwpFN1AKRtxbS0DrLLBIWuuaLG+uZVwNiepkUBFeoW4K73i9DirPewh04j1iLh0oeOjwygdLQsxgCPi3n/PoCkHyxeOLqIhLi861TpgIFOIGPkf/OAPvVFoj+c1T5zM1clWbjGbbsfPm+Og3XuYut1mLKMxCMWE97gXpNopV4PcWHH48Ie7ONnUSNZniiQH412hiksmzoyOMPgVmiL8UlrsrNMH7jBwBPcd4u9pQRUwjAFYrQ5+sG+5cgpVHkIQYsoNLdwBbb3Rv0bQnfm/aEuYKmWp5fU4a9Aat4vGFpkErPqmbVcfEzLOGiPzxScR8JvLK537/EPDL/2scTlJX04Trx27aSU63tiH1nwKybYdUJr5x2xs/PL+7IUpjhwdzm4R6yWikw1TfUXzYQqpWP1PDSCsejMKTl4G0dN7lLwh7kb875VufPVQB+1w3rqhItaZ7eho9/qv1JmNBEHzfp1d3WLG7UN1p7xDOuGG3ZE
 AWoAK/MI
 By0HAzjqbFOLzgtg/qOhz3YMNsHKDHXjF2Lrg6RxErpOOXjwCFrebrQ6U+Mk/+2GBg7Ki9p8eWVpxJKeLgrGo3cSEAfou8sj4ryjsZzcdj1E4oOYg6/oZjVYvZFsNHhLf7vDz/ZWRqKB0APX2NzVQ75zs4F52bc8832mD8/adXQtezHQRGrdJofUs+CderudNNvCkCVNMIkrHHXaFrAzg8MYtudTjUTJwDgv7zEXn3uszb+t7Za7BXPrFlF8AFrmZf7A6PSsxQxiY1Fj66KrlDK0Dt0E3EJyTtCtTMqEGVwKNwS3pIKDsf+0sHAISYiy2V/WSwOwAhae/ZiNH/ztpf0KOWSbVILzVaxcnwxsvCP08B/nQVszMBaOybSncRoiLS1tH9X+kN8GBj4+w5QE36dQsoQenT2gzxKpk6XL8gMUniAYlSXpwQKlPwVz33ZrxTX3GgBa5svzI4P9rGLvDzym4YEdEuQZYPDwGrt8tYWyAby0ovHg0EzodIvoy2vEqB9M91XT0J/Sus7sZpmY46dIZQQHgHJAmjksUfrdNTLcia/PkbuKVgH3cEJpochiMTKSMo+z1nWK/ptXa627yAM+4+K9E37yBK/s9KraSiTnb3glwpy7WZ/Y1TuEUWvaDWwJvFHkfL/ye6Io+WszhBOQAqXiEWw0LGSKkqGEOU7xMIcQ84BA06bXTv80k0zFmDuvoYGAujUPMUQJwVf1DmydMkl9+HwJNmlMhK7M8zZV0IF1vwFtaAcA4+7wfaG3wKo91Dtv7+C5EoQntuw76k9vA9YxauS4lC6N3iNLw/iDG7/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andrew Morton <akpm@linux-foundation.org> [250827 17:48]:
> On Wed, 27 Aug 2025 21:22:33 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:
> 
> > For improved const-correctness.
> 
> OK...
> 
> >
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -537,7 +537,7 @@ struct address_space {
> >  /*
> >   * Returns true if any of the pages in the mapping are marked with the tag.
> >   */
> > -static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
> > +static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
> >  {
> >  	return xa_marked(&mapping->i_pages, tag);
> >  }
> 
> I'd actually be in favor of making all incoming args const (C should
> have made this the default).
> 
> Because modifying an incoming arg is just obnoxious.  That value should
> be viewed as part of the calling environment and should not be altered.
> 
> Try modifying a lengthy function and wanting to get at an incoming arg
> only to find that something in the preceding 100 lines has gone and
> messed with it.  Or forget to check fr this and get a nasty surprise when
> testing.
> 
> Not that I'm suggesting that someone go in and make this change.
> 
> On the other hand, it would be neat if gcc had an option to warn when
> someone does this.  I bet it would be simple to add.

But what of the lazy programmer that just uses the variable at hand
instead of declaring another one?

I also wonder how this would affect inlining choices?

