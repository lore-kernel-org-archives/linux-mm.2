Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACB9CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B386B00D9; Mon, 18 May 2026 19:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC156B00DC; Mon, 18 May 2026 19:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83356B00DD; Mon, 18 May 2026 19:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0AE6B00D9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:44:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55EA91C09D5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:44:01 +0000 (UTC)
X-FDA: 84782171082.01.69A349B
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84839C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:43:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Y2Qz/zqK";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekS6mkln7TSi4B9yJynjO6+YfKoIXbvAcOawTu0f3P4=;
	b=WR8Z2H77Y5t1Q7tsnHlolgu8enxzOEm0p92+qgVwXx7JvQKlG7gLRpmq73ZFxypjC30dlu
	1Y48rIjLqZVQIVSCt530G3CjW1XaNOXdVcB8wBx5XvwgaMfjVVFmGVCv+i1aJxpzumzEoD
	Uur8OdWu9042d3EPH17YW4N5beSTJXI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Y2Qz/zqK";
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147838; a=rsa-sha256;
	cv=fail;
	b=CmgmclFnJ08D/NM6jMM/7rfEWqK36GyhQhsVjAwLTdMQzg8v9mtXXhwIZB36HaPbrkHQvb
	IGH7vHQ2W9eWOyC9bZM9imiM7HrMBee4tUSsgpK6SBqxEprqOs9A3iy3JgZCyLNzW2SNdz
	i5CLLerBlhlvJ+LYux+lD8pEaYFNg3E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZDvW7eiOV2Xbgj3uNYzhAh3d5kKRDmqw1el4EWgRW8MWli5sbgOP/41oqJOnIZU06nhWEKsRxWvXKBjB1MHSvXMP+vsRnm5H3D7nADOXgnUvaONb+UYd1TxJT/G6XM8oaEdblM5pSiW4bZ61xvW1ScJDD17cfukn7YDy/eWMs2JyylrHgDD2uzTEbtAImukjEiafJINesguB9vksKcbcXjnJ/b/x3l2JTvAkBmBelaWxcfTJ+tuybymsy73FPdJ+7ZPLFakBAwYmxRlOjS6yKoZhDZ1wSJntjwGEKtG2maTw0HO+8gDPUemcfN265RaCoaz17NQPNYpvxgwuAFA+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekS6mkln7TSi4B9yJynjO6+YfKoIXbvAcOawTu0f3P4=;
 b=BaXW3Bjff8iIPowZFGwkc4bHCJcp9yIUe9MsVTpk1FIaB3o1+Ej/IWHcU1iAV5LhzPpAO0EcuuD7fbSLsXh+A4g3KAl+8L/JLYijML7DAM50IaIH4vhIGfXTIqiH6myZXKZrZkREtJzRd+kB87fQHBKq/J2Y0LH1k0p+ETidwCv7d3SME2rNH2RWZBwyaPD63uML3h3W8LjIVCjnvI7SWhkz0dwUmNCRs/ntZieEikJmwYfGNJ/RVxLm6/O5oQ+nHyDb2WI/5MmhjMVc47c1i192f4PnFIew+yB/uFpq8Gt0uy5ACC0MgYYhe6ZIiEZ0hXF+gh9eqq/ARvfiOuiekg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekS6mkln7TSi4B9yJynjO6+YfKoIXbvAcOawTu0f3P4=;
 b=Y2Qz/zqK+EXQMkW7u+pj1A9pmqeKvniXbH4iMgKjJGZnXNTB29gksnwanADbzOaJlN3Mwrd+SazVUxHpzT5jAL4CVnu201eTFK4KPf16sKU1wnb0mDw3zdkmmfqiRSN5E2XtHUeOy01lMdjeDZwT+LKEo1/oZRFSbEIkv0JILTfSHuFUA/YURL+YyoKIZ/TyajaJwluW/Eagk50CCXbFainPCotltO1O1XD/g/5pUM0iC7+29I6WCtyhlXUnKpB8eGF+e+CoeOjXL4k/fbwq14ARh+n7A3vuGoPJgVqpB6IOOYMIfdW3rR9oLfVvClJaX2NeIRDOYpG4MPhfGP0w8A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB8290.namprd12.prod.outlook.com (2603:10b6:8:d8::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Mon, 18 May 2026 23:43:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Mon, 18 May 2026
 23:43:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Tue, 19 May 2026 07:43:40 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <5F5B6E33-FA56-4818-B9DD-D49F8357A668@nvidia.com>
In-Reply-To: <22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <52285e2c-af42-4c0d-9926-017f80b6614c@redhat.com>
 <E2400A6C-C0F8-44FB-B8F8-92B5371737B6@nvidia.com>
 <22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH5PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:610:1f1::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB8290:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f48512-b713-4821-9f1b-08deb5375049
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|7416014|18002099003|56012099003|4143699003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	DlzRlgz9H8m2lzCLXdjBHfhXPzuXceEZ4aQQaOoYPsLnlTqwh0RuC3qVUS6ZL+G2K3IY1ASzCutcOk3n19+3pvhTN4Vwr0BG2+FBOC1Zbc/bh52fQU6Vs9ybON7kbQ51OAf+VZYGO558zCp1SSU4pS38w4BQpIvVF0uigAxVpe7RVNjGCgIMAKzG7EBJQ3IETZq3PF547UUNRb7NruRcG6BfCTg0XrTDXhpjdSA4HlKg5JNaQ7ugJF10t2+RPP6gVWCNbBVirpzkqz/r6Q+r7S/fVmEo/LaVSN6Z4HI98h2NMpyHPhSdbEi0XSkGHc+bzdFW6ZMbcGlx/3zXwfjNuxKEh1CaRFWyWqYtb1Jos8CvuqXaoXfLdy97UegXIoGP4oQeT1Dg3wqqKgtHef8llxw/ULJOZgv3AEQSu7M0hATm4hArjUnh1d/MienIqwKIhqI45Vcs2RGMIHT+eJNgW/dZa3Te2bKYf/LmnfJ3nqi2RAO7yieM7oKh3cc0jYc9UXOu6s6jqVi1deRMEmFbz2AEyy2Uxl7VLZw62VCWwnuWkpwkfG0Ua7NtkpsinLuKVwJYBAc5qnVSLt9bBuTliXeOVXP27hpRd903mpAb340x6U/7d9tF9dIPFTjo4g9hMCiRIuO9eKtbXv+0vNowq9wcX4hgL401nh+YLaF6+KIpdcLY2neu9+JalFZJ/ri4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(7416014)(18002099003)(56012099003)(4143699003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8rqNAYMNtrnyFOSbgDbCwAhvVwKOLaut/ofG52WtXVOquhoUNC7j4hHmjQf?=
 =?us-ascii?Q?pZZj8+mNTA0AQE+oUKOg3vYq79JQGpriN1ZIi2mKqZt3JDhcp0PO9DoxDzXf?=
 =?us-ascii?Q?cK1pP23/nM2pO5aZMGSuknA3NQ3vj+IlSqRwJjKf/s875cQeIOshW0t+UcIq?=
 =?us-ascii?Q?uwOZA37qqbPSMq7yWKHCKlLBmmw30j7i1BeNaSq8kKTHGO/whgfPW1MX3gMx?=
 =?us-ascii?Q?jhZkRFumUpkBsO0AQvjQGCyUh/YAqRTdB2JQk7xk1pLc/HVMWIF3dA11I8Eo?=
 =?us-ascii?Q?NTN4G8YgQZ3nQ/LAX80PUX4VPa8vb3nyZi8gFZooOXbnAyncedE0WK83WLGA?=
 =?us-ascii?Q?fOgYU778ZcLoQwWzMGR76xfAm30P8qUx9N8XWdufq1oz33xbGY2wtOEcMaC/?=
 =?us-ascii?Q?3dEhxpqD1hghVQb337Ja0AJKpPtTCpFNnOLCBQEIysECab+RoSkg1ZnonSls?=
 =?us-ascii?Q?iF/iae71d9eT0vpQ8sX2kRAjw3mu0KfGmm3BsbFMtouSuDflkuUdmfrtqmgQ?=
 =?us-ascii?Q?wSKvnkjNUFiI/fTbFdGtJxmM0dXkSN70w28djJgH5zMpBED94uWswDKinkIM?=
 =?us-ascii?Q?QgeWKtbhGuMUwBimQMJw3uo+EP7N444yG0LD6UsjTDVwsdXv/2/kQbgk4fcf?=
 =?us-ascii?Q?puIMWvDIbsYdrhq75PE4iIjLT1j7AykDvnN3xEU9Az3gEGVxpwCbFSGD1n4N?=
 =?us-ascii?Q?WkKw2vlrUBiVu37pNM1MWNiMN0O8tdKPY7G5WtEb4QXcRFKAVmGgWSq940Ug?=
 =?us-ascii?Q?GudJyWVdBx1VgRH9ZyOcRn06SyvhwyYRw4qnqI3iYo0t7UDv+qYSenchFdRH?=
 =?us-ascii?Q?WBbOJeephVTNhY6ApV/0x6HMhb3pXxOZiADt/fKePlvu3dxMOXZhF/PSnUfg?=
 =?us-ascii?Q?ceoNr1HRldPJNBtsigZVoAsD8/WlGK2GooeprV+2MVTE2D26wz7szeb/ThIX?=
 =?us-ascii?Q?11RsL2yRxQBmkk949A1ZdYWeV9zk1UH4bSBPlGYRi1ncAwG94YKhfhU0Ti4T?=
 =?us-ascii?Q?RX7WXJBg6zNwYhxNQRVbE2lryDNtKsIuZtgxKIgIkLPSo1t3PNaCaKcLKaOU?=
 =?us-ascii?Q?0rtfIGV/ImTcfMH6z0g9ut62RbyDetwevE4x9wVHQdHjOcRGg/WhIlu/+98a?=
 =?us-ascii?Q?90C4JcjLe7MpN3ZNFj9ZljktbvAgTlGPLTQfntQ1xtYcCEIuy9rQhgKf3vuF?=
 =?us-ascii?Q?h8wh3o9Ln744VjWpnhoPlfQnJYmupkEG2JVOW7j0x6Y8JQl4SOduR9nawzGG?=
 =?us-ascii?Q?GsyuHacRM/ebswgkLMFvFxDwFhS/2Qa4JJPX1nb9VETF9mzYymL5t3z8Xq2A?=
 =?us-ascii?Q?AETSI+634Od+O3KOOTgEVW/6qADPSfziRBH8mlts2QR2tW27saRYke2jNB4E?=
 =?us-ascii?Q?zSyn/SN+n6Xz4HMKsyIqPpT1nTCcjzEmWiqO4E5wJyUZ5lt26zmNIgPkJ96F?=
 =?us-ascii?Q?qbp74iuP3+JwQwngpl4jIoWEK7D+MbISzcqCfybqch/5RuBmpaKonziJsMQB?=
 =?us-ascii?Q?SOlF7uwXq4YCRM8MIeJuApUfsiqQsPpb/XDMgtYg9GnM1eLK3DsPyKt/nDAr?=
 =?us-ascii?Q?JHiloxlM/b2hYCpynbLr/CDBHqyigv3055QR63BkLqFiR2lMb2ktikeS7HMR?=
 =?us-ascii?Q?aQgSHgwqE+AhpyXLO6n/72m0RguBDXLfXygQ98s5Wzl5Ykd68YHr2GfX7kwy?=
 =?us-ascii?Q?CHjJayKpJTTJKDBiQ5XoOvuAUNhBX5leSGRRV+Hs/PlmRu36P2hQGsoyts2i?=
 =?us-ascii?Q?f8AMDAbtkJmMeu65TQfMRUaO2dl87xO9pxu/XWIn/EqTsiDYZCLP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f48512-b713-4821-9f1b-08deb5375049
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 23:43:50.8974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfZZ1ENRKAN3Gd3w8RveIvnQYk02pZHWjp++db8UsqIb8AMow5dxZI4agPVLMfLq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8290
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 84839C0002
X-Rspam-User: 
X-Stat-Signature: uj4xht4fxq65fcyxya9f7d16akaxbyn9
X-HE-Tag: 1779147838-305034
X-HE-Meta: U2FsdGVkX1/5nxj2M30zDqS+KElQtOUiz6PmGIqizyzqYBV15jWUo2RHWDePjA/OvvNf97vnNjkIquiOzojC4zJMuTR/aR8weYXsIosDb/hG96fB8qs80Qn1h46SpkLRkROM4D0jkEJIBnOvRdZUQ/uf1/tSOQVPHW8x1wJJ667H9iHAw8sAZIV8HqHwoO2HbVIXQW0DN71NfWfSeggY9HCC1ofoMpIoslksaTLpcqO0e18wyZRJcq7fFrNgRvQNnsNybwws39sphdsVOHFfa4eaDEjT8OY5SGDyuXX8lcap3ldC619Zb42iLx/bttoRBerH7nw6NC3DAlWngCy9qtr61lKJ2O6JFW6gZsROr8EWTaxb8VckIJfIGez8prdjKdcW/HgV50F53dI7QkJNOJgIA/rB7hD1vBabKrLEEXNni5sw/z4N0T2Aw4lyDTT9XYW/jePXOZLvOJaP0Lqrz0JnQlYqOxrMYh6Nn9Z5AizsZdhLN9yiSyDFpFLrJ2RInnipr8Isa28sYJp5a08//qMgDKF5hiy1nfzZyclO1pwlZVOWp1Vgaz9NMY13b9tsUd+fxBK9UDBW2GrHFPfYGA1oFrEIqLd14jyKpLiCnjSViaW+ks8HxEOWX1qRtNHp3g0h2sYQsCaj3fFKFhyEFmB8BjjWmiMigW+SgD2cqiIOzz8eNZdevy2C23drHsMC8uI2C72zpRhPuUjIsqdKslO6Mmr5UBRkiGMukUkEGJ2JaEDu3ToYjvbMh1brBBDmfoZxJAUogM5Lv/29QcNYdHzPRoKHcaaNYubDO6elJllxYAJgH3Rg19UHzAuSRe7QCdIOyN4aIaojU4iitHzJ707dJuS4G1PthPNa7qVRI0Tl7Hjm7kqlzUoTt6uUv5pQ/4B9WuVt7OjCrYQjk7TNG9dHXvV4PcV9UeUqIrdAknLvRzJy2vhQdADJGLUD+/6vgDK7ZQeuYo7/jA0P8dT
 w3oqTqep
 be/rskpqFKdOFu5XNf+IdkmqwTmI2Ryq4x2mFe3ZM7ZXgi8jm3jQhUDR/N1OgxQZBsq2MfXPU0Ve0f+c8DHhBNXxsd8vhMdOKn7kcfMldcZ3SJv3SLrEopNHCvoXA4HoIZBlGfVe6mv32j8No/cqLAEAue5l6yhiI0MHogd5QfyvXXrbhqWp2klXIVSsXQky1V+gARPpLzprVjrpbR3QpmUuBqVnc7aNtlQ9liV/+gCW0x8f6GgrSOU6CRIJANBHwvxm8znbdvnGO8EqP8e/G+Sy6fYUW1Iwk+25urr8RytIMMG882iNIBWzUz/SDH5I3aPtRv+ERgQ8TwsacLRlSvHvAdQGWb7wIvsGqmXDtOJ0oqiC7YSHMUE04tGEeYA9BZzJG5f6kt5yzxhNWm85L4Y/JnyPS81R00SuhZ8vfxbifnuta+EoV6j0b4SnnsSUkfUAwMMPEkI99h+OJIAZi7S3YGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 May 2026, at 3:51, David Hildenbrand (Arm) wrote:

> On 5/6/26 15:11, Zi Yan wrote:
>> On 4 May 2026, at 12:23, Nico Pache wrote:
>>
>>> On 4/29/26 9:35 AM, Zi Yan wrote:
>>>> Change the requirement to a file system with large folio support and=
 the
>>>> supported order needs to include PMD_ORDER.
>>>>
>>>> Also add tests of opening a file with read write permission and popu=
lating
>>>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++---=
----
>>>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing=
/selftests/mm/khugepaged.c
>>>> index a6bb9d50363d2..80b913185c643 100644
>>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>>> @@ -49,7 +49,8 @@ struct mem_ops {
>>>>   	const char *name;
>>>>   };
>>>>  -static struct mem_ops *file_ops;
>>>> +static struct mem_ops *read_only_file_ops;
>>>> +static struct mem_ops *read_write_file_ops;
>>>>   static struct mem_ops *anon_ops;
>>>>   static struct mem_ops *shmem_ops;
>>>>  @@ -112,7 +113,8 @@ static void restore_settings(int sig)
>>>>   static void save_settings(void)
>>>>   {
>>>>   	printf("Save THP and khugepaged settings...");
>>>> -	if (file_ops && finfo.type =3D=3D VMA_FILE)
>>>> +	if ((read_only_file_ops || read_write_file_ops) &&
>>>> +	    finfo.type =3D=3D VMA_FILE)
>>>>   		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
>>>>   	thp_save_settings();
>>>>  @@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int n=
r_hpages)
>>>>   	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
>>>>   }
>>>>  -static void *file_setup_area(int nr_hpages)
>>>> +static void *file_setup_area_common(int nr_hpages, bool read_only)
>>>>   {
>>>>   	int fd;
>>>>   	void *p;
>>>>   	unsigned long size;
>>>> +	int open_opt =3D read_only ? O_RDONLY : O_RDWR;
>>>> +	int mmap_prot =3D read_only ? PROT_READ : (PROT_READ | PROT_WRITE)=
;
>>>> +	int mmap_opt =3D read_only ? MAP_PRIVATE : MAP_SHARED;
>>>>    	unlink(finfo.path);  /* Cleanup from previous failed tests */
>>>>   	printf("Creating %s for collapse%s...", finfo.path,
>>>> @@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
>>>>   	munmap(p, size);
>>>>   	success("OK");
>>>>  -	printf("Opening %s read only for collapse...", finfo.path);
>>>> -	finfo.fd =3D open(finfo.path, O_RDONLY, 777);
>>>> +	printf("Opening %s %s for collapse...", finfo.path,
>>>> +	       read_only ? "read only" : "read-write");
>>>> +	finfo.fd =3D open(finfo.path, open_opt, 777);
>>>>   	if (finfo.fd < 0) {
>>>>   		perror("open()");
>>>>   		exit(EXIT_FAILURE);
>>>>   	}
>>>> -	p =3D mmap(BASE_ADDR, size, PROT_READ,
>>>> -		 MAP_PRIVATE, finfo.fd, 0);
>>>> +	p =3D mmap(BASE_ADDR, size, mmap_prot,
>>>> +		 mmap_opt, finfo.fd, 0);
>>>>   	if (p =3D=3D MAP_FAILED || p !=3D BASE_ADDR) {
>>>>   		perror("mmap()");
>>>>   		exit(EXIT_FAILURE);
>>>> @@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
>>>>   	return p;
>>>>   }
>>>>  +static void *file_setup_read_only_area(int nr_hpages)
>>>> +{
>>>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ true);=

>>>> +}
>>>> +
>>>> +static void *file_setup_read_write_area(int nr_hpages)
>>>> +{
>>>> +	return file_setup_area_common(nr_hpages, /* read_only=3D */ false)=
;
>>>> +}
>>>> +
>>>>   static void file_cleanup_area(void *p, unsigned long size)
>>>>   {
>>>>   	munmap(p, size);
>>>> @@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigne=
d long size)
>>>>   	unlink(finfo.path);
>>>>   }
>>>>  -static void file_fault(void *p, unsigned long start, unsigned long=
 end)
>>>> +static void file_fault_common(void *p, unsigned long start, unsigne=
d long end,
>>>> +		int madv_ops)
>>>>   {
>>>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ))=
 {
>>>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>>>   		perror("madvise(MADV_POPULATE_READ");
>>>>   		exit(EXIT_FAILURE);
>>>>   	}
>>>>   }
>>>>  +static void file_fault_read(void *p, unsigned long start, unsigned=
 long end)
>>>> +{
>>>> +	file_fault_common(p, start, end, MADV_POPULATE_READ);
>>>> +}
>>>> +
>>>> +static void file_fault_write(void *p, unsigned long start, unsigned=
 long end)
>>>> +{
>>>> +	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
>>>> +}
>>>> +
>>>>   static bool file_check_huge(void *addr, int nr_hpages)
>>>>   {
>>>>   	switch (finfo.type) {
>>>> @@ -488,10 +515,18 @@ static struct mem_ops __anon_ops =3D {
>>>>   	.name =3D "anon",
>>>>   };
>>>>  -static struct mem_ops __file_ops =3D {
>>>> -	.setup_area =3D &file_setup_area,
>>>> +static struct mem_ops __read_only_file_ops =3D {
>>>> +	.setup_area =3D &file_setup_read_only_area,
>>>>   	.cleanup_area =3D &file_cleanup_area,
>>>> -	.fault =3D &file_fault,
>>>> +	.fault =3D &file_fault_read,
>>>> +	.check_huge =3D &file_check_huge,
>>>> +	.name =3D "file",
>>>> +};
>>>> +
>>>> +static struct mem_ops __read_write_file_ops =3D {
>>>> +	.setup_area =3D &file_setup_read_write_area,
>>>> +	.cleanup_area =3D &file_cleanup_area,
>>>> +	.fault =3D &file_fault_write,
>>>>   	.check_huge =3D &file_check_huge,
>>>>   	.name =3D "file",
>>>>   };
>>>> @@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops =3D {
>>>>   	.name =3D "shmem",
>>>>   };
>>>>  +static bool is_tmpfs(struct mem_ops *ops)
>>>> +{
>>>> +	return (ops =3D=3D &__read_only_file_ops ||
>>>> +		ops =3D=3D &__read_write_file_ops) &&
>>>> +	       finfo.type =3D=3D VMA_SHMEM;
>>>> +}
>>>> +
>>>> +static bool is_anon(struct mem_ops *ops)
>>>> +{
>>>> +	return ops =3D=3D &__anon_ops;
>>>> +}
>>>> +
>>>>   static void __madvise_collapse(const char *msg, char *p, int nr_hp=
ages,
>>>>   			       struct mem_ops *ops, bool expect)
>>>>   {
>>>> @@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg,=
 char *p, int nr_hpages,
>>>>    	printf("%s...", msg);
>>>>  +	/* read&write file collapse always fail */
>>>
>>> Just to confirm, you are adding the write part here so that before co=
mmit 13 & 14, the behavior is that it will fail. Whereas after with patch=
 13/14, we expect this behavior to be supported correct?
>> Yes.
>
> Confusing, we usually add new test after adding new functionality, not =
the other
> way around? :)

My intention is to make sure my changes do not alter existing read-only c=
ollapse behavior
before patch 13.


Best Regards,
Yan, Zi

