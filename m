Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FD6F34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86CD6B0093; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EDC6B0095; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25F06B0096; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4F906B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:52:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66165C35B3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:32 +0000 (UTC)
X-FDA: 84691926144.11.534C2A5
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id B18AC40004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SGUnzxjo;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZqMhoOMKkITRxl/cPiLbG/DuTr/NAalxDFMiTPh1MY=;
	b=GiSBQ+7d1uxtnvfsTiw39RoxikYXvP9Rh2SG5Qzh3E9O6tU6BJStEl3lHQodp8ucyHa/Ig
	dUSR6QqD8+PgrKZGo4IX76mIh8pw+AE+FlWgAVtfRMuCKwS7pyMq+26KVnKhUOJsRQO6hM
	ml8UFX44I7d2Q6WalDxDVVutfgset+8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SGUnzxjo;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999149; a=rsa-sha256;
	cv=pass;
	b=RCWfiFgmnBX9fSQ9g9h2PiGEenmq6gs7yQU82uFUWBpgw65uaYcocZOET+P0fL/aDwMb6a
	fHvQKYlVZ5lGLCZV2jlKbuqt5X9W9iTsR9c5evg/jy6ULW76W4DdemJeBnwfZDBNUEp7NB
	d7HuzXjEmxbuvvuU3dPYgW4lwEF2wGo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmWoLPz+KX2kZ/7P+RBdpH9iFlDgcf1PeDWsUxCq+MCF7KqLcW+hcgalnRraJlenDcvnw1ni8yNnNon/Yau9+DvRZb1Shx87JyvEnAAWq0YmuUaKR3yFDdvM3gNNCJ1lxoKvezr69XDnZMzk85pGBX/5S4WUAWr8XGLqxMWea6hcEuq5tIBXuJ9caW4EkUbBpH4QAfkiNuSSXSZ0ArIzUc9dCN3wUmEi2ZTBTHnSyhhH17yRlVYT2byJk5RU4jDN9BjYNZss98Urm1V6Rh2+OqKT0dKxefvg32ukU+VhLdY2XN85vJUCT1doU1cM+HCqo35ESlcJLR7a4wZ0g0ddig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ZqMhoOMKkITRxl/cPiLbG/DuTr/NAalxDFMiTPh1MY=;
 b=kDAM+yfKeMSDmQw5czd+qBEHMxozmQt1hVFxooLg35ZviXuHngFBy0q4yKQz4J5mBPfC3B+b0TbXazxCCsexCy9AX2BKHuLoX65G5Agd9x/0dZ6cx6rGVLktS7AJMO7U6/NuMi6rkbPCW+EXpnpfgEJeE69lYaow764hgNUCCYgo7LOA9z66XW1y8vvtTCvI1X9L54BGcTnfputHUPb2fpW0w7Yg/PqGep5ID+QEKCMqzRIGbYVnfOx2ndmiTAlVhZ1d6+pm/l3A3+iXtwd2pm8y8kT1dRl+D6dwqoeIUUGrewMNLv69UmnI67msiyrdXRhMqPRNg6MFwjoeG66pMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ZqMhoOMKkITRxl/cPiLbG/DuTr/NAalxDFMiTPh1MY=;
 b=SGUnzxjotrM4jzFyi8bATZZ1fc3ff0HJE16YDIjti1O1E/R0Ucd22Zv82jG5FIOCujW/tse4eOmqAivOYOAuxjAYeR6U63njOmCMCh6aYWLJkQ7/p8L3x2zlTYdLO3DNPTp57oQP4ye/v2axOb5kUo1WeZWQzXSGgNWs4jS9A73h2UCOeIE52nq7rNTivBnGzvUtPVJxTT1KUM/h1mrVzKnK1NsE3jqonTrd9EQBgPN1qROvKwrrZRme61ovnzxm+OLFTDyxCL3R/za0h2MTSp/QynOG6idov2iW+8Br7YoZz4zYmzQ1zJshbmZhIkSwsS8IoU5VJMoSqmTZOFYBwQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Thu, 23 Apr 2026 22:49:07 -0400
Message-ID: <20260424024915.28758-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:208:335::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eeb80e7-cae4-4ca9-97cc-08dea1ac7d69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dWytQDmuNcYOf+nw0/nhLp0gQeapYbke7Ul/sNaToPa4s7u9ywkwtxGn33kA/Q2sO53rKTv4INAZJtV+/H2sgT3f3gQyp52Chhv5TTSuYXZJUAZ5KVu/Jygqet3kyc3zMZBK7tf0/t14ILCoTRN0teFbk2f/5hhyPjOIAvzKosqXEgOvbsa5UOWWGDXjN7500tRAIMztASa6imBZ1GU0L6o5HKjkINoIAkC0wuOnrT1tCQKR1Hni8VB8AP74o38lCT6AkiNMSXewmaztCIGx5JVkWf1MF78NrRM+G9Sx3suKQHN2qJKajejxduTTjQQVYFpsWT+04UCWtYG1v0g3sLBpFQISP+v7NImxraJaZiKJkDYR19hB/Ku2VRm2cFNDJNqTKFT/MGv4FdvFH+v6EYnBHWol/AjBn4p3qG/0cidx55FnWe91+qb/TaY9qtaUvDg1567Jqt2iIxK14LL2PZP49NlOqYW9sxZhrLWKnTjnvtmkVN5lJNuDSLww13sALHJWSI4ZfIlOFQ+dWWGSRYFwEnA4kqTkR699rdo/xC/PtL2sGTJeP2mfCOAHJ1ZMAEgEC3fnQjpgN2cMGswQPRwiWCsCenCxo8hBIuelDHTeZWdGRg8ByGw8hNKYwqhHY3cmDeMh1PYc4qyij6VUqCnvpEgmB4KwPDUJ/8VDqDQHmxD+kF+XwZs8LxVVdSOzbUgb1c10b6vOPyYuQwDG7xFIL5f2tS9FGeVbzZC5gg8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j79FZLto9D4/uUQNAdM9p2eNJWpwXzQvWyyOlG4TyZLSVA6seDPj961cFwOu?=
 =?us-ascii?Q?g4X5Eht3tl8fs9x410xcBhP7srOPSVJianBaeS1F043MCTVdLLzxWhnfFQz+?=
 =?us-ascii?Q?vtOmEsqmVpY3q32Ngm97b06X/E8TVxLosQectC36MFIb20E0QL2eXEFNbNp9?=
 =?us-ascii?Q?ruPVaaz/iMfStfMeKUrC9RwQjrEYMfmUJg46CPCQ4m9uhAm4k2YblUzyedkH?=
 =?us-ascii?Q?EuS2X2Nxr0HDI/dJPfhvWN+PECXF3TzvwXwzxik1l68d92dvPBADBrIIXjiC?=
 =?us-ascii?Q?gbI53+t4AXtL195RT0f9qCd1KINSHJgD++eY09WxlLHCiVdcC7dzGv+JhmdK?=
 =?us-ascii?Q?cN6DbMPua58GwYalkxX9xz0jgmk82F4dTCz7iQs+9iWMswvR2gYf8ZjDLe/0?=
 =?us-ascii?Q?AKOMcDtPSGCmt5tON5GPX56MfoCFICsBqlUt3BoQlVrrNDAWQdB793uJcx6Q?=
 =?us-ascii?Q?HmBz5yQLvMl8/NaupZIrl+lpCXaTzhyCROQMGSB5ma0lkzM1TBywNAm24TSW?=
 =?us-ascii?Q?LLrKFMdU3NBClcHTpMy13B+iMhkhVPvEbKtRly9m0aPI8Ty2gl8TQg3roA9V?=
 =?us-ascii?Q?FdS2jsNR5TJwo+PPgGprWmwFMOV5gROWMWuGYphEODJLRgZ6RrSUQ3RcZh/K?=
 =?us-ascii?Q?q53jvfLID8E77FXjvZgpwqoyKJm1tJddyRQUeV2QgCrh48twO0ynVLGDo8BW?=
 =?us-ascii?Q?rONBxxD8BTV47jYhwTaxNB8GzTg6MLKsAZ43pwJGgunlNuSzfav/siiETK57?=
 =?us-ascii?Q?qoGm8KXxDJrhl9DHPvU68L0L57D2swEaoaHSI3Mw4WH4/FMuXhKs6Y2PafPw?=
 =?us-ascii?Q?kvV2gjC30fIDuifRDBCXtbrKOH3nmdIalk3djFa8/x/KxtewKXMAIUQ2Conh?=
 =?us-ascii?Q?IXrnf81EPPrs1XRycsQU4upI34MV49O0Iufu9qtcsFTifAGVQo102FcAkFL9?=
 =?us-ascii?Q?atmJ7bQm1qjUG3uHG2yHtEgWlInGg7tuUpM/IIUOLA5Zz6MS34URDJ0k8Nb8?=
 =?us-ascii?Q?KWbAt6A3Xwt0Zq6lxNG6XSGJzURF9lOacjHb7uZ0JZ96ylIfFvBr+veMVMb3?=
 =?us-ascii?Q?w9UZoPhKDtuH/qY4Pg/OJNkUkv/7G6PvQq2hzZfRK6r/NW+o54iCiImVAFrK?=
 =?us-ascii?Q?ZW5umXu/5PMNygIXYfC4qLL7TBBfvfMEocMw5TtLXbXCtGBB28DPhxx/DIE5?=
 =?us-ascii?Q?S/i6S+mQbTSeGVGrcTHWFu5ueoztr4sMMfDu9I68uWzedV8WSlFs4wiFPVPe?=
 =?us-ascii?Q?rZvYX/J8T9XFXqsi2+LqQx6WnAJatcAgeRj+HJDN3bRhVMs00tomFM6sGy/M?=
 =?us-ascii?Q?hA2xDgtJeO8w/1MvmR7HSH7b21sYzCFhYb6Dt/gEkGwKV8bnOGQUv/KtznC7?=
 =?us-ascii?Q?i7cgWupa/zHAdGfPW1DhXa1JmEJnnG0xhd4AjkXcl5I0BgS15urhXTVsiTQW?=
 =?us-ascii?Q?LrGKIS/XnnqpO94d3nfpT3cc4/E+moV+ydR4EfEoPZehHqUjyv/8TEF4xodz?=
 =?us-ascii?Q?Szg5zGOlq9bKl4FriKpEP7eZcz2E0iYhrSKjqePA+rOvWghaKthUROhb/YqW?=
 =?us-ascii?Q?/gi5cHrr4WIQ3Ii11WONA2iRnQkkXa/PkTJ0T0CQj8m1WGQI7wYzgOD6/aut?=
 =?us-ascii?Q?g3Mhdcny6ySpQbvgoK2yj+WQ0p/HYqa2e0aXh/KkmWpBJ7M1Ee2H1wcLR5AT?=
 =?us-ascii?Q?A175n9QT1GGBlD65DZzdu7fsHlUwq2fCGEIsXqDQm36J+aI/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eeb80e7-cae4-4ca9-97cc-08dea1ac7d69
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:14.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaI0XTaJTJSnnY/+hWapZZm84m30eiRBo2P4Z2vs1S6zfI8GtJ4V3N3yvDH+FbiK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B18AC40004
X-Stat-Signature: bbcrarb3fs9uxey7ooqwphw3ppttigae
X-Rspam-User: 
X-HE-Tag: 1776999149-903640
X-HE-Meta: U2FsdGVkX1++S/fSKWrgxHNsh1STN/80IqfRVrsaCIrR4iaZlpLCo+djiRs1low3ryKqMjflzFUYSadt8sZy38QvCs05sjBE161JjB+isUsIQIjzozJEs1JUU3snmmwb6pxQrli1vAn/NSveaZXGGh1FYLU3nxl0vfmN854Mt6Ib9GJ2FB7YXSVp390m1vo3xmOKqjTAvWiZuSGkK8aX/zQDMP8E1R3VDR5sdPmKZAR/trEYxwZDzkBQD7Q0pSAj4o7t+51RTn5jTYi5n/QZqnT1sCA0GGz+/byRNARekhqbxFr1ki/hs65Lec+WuzrZkgMklLBDVku4XKlfbKUKtaLoYPtYqtzSKl4jPc9OOdDVBo01z2V6evwlLXIjycHyyvC7NK+ZGf0LMjEdvE6ZalhQIJix6Jc5cTW+N2An+bj4eoTR4UNrRX3wzT7T7YdPZkClt36U4ke1fN2xriuljr6Qz26eZtKDhm9PqzqjKkFp9lT/EluvRKcgGpiuMunZ3nZ16purDOfajQBi9L9RKXErlaQGPqDnXoMnw+a4UpT0+R0f4IPXA37eOxFGnsowhaDEtiSYQpPSnnz+UEfMuQ5Qcw8LD2zy5rN/Y7IC95OVAyYOPZtuP1tcUkX0fMn2Tiw8ZFJv/tBHA+n2c5MV2RGGEdCEtCJG/4evrJ1EoqWDMgVJEHEH6d5TZJJgcl/ydC/lp80oyHvWF1L7gfi5Li/6NrBIYA4MxdCfVW0XyFH7FBqtVU2LCLr9wCZW5YqqGFiawOFb2B3h5LHUd3kYCxlYvfc1FX5WA9labmAaesYps06w6bmtldBMhC/fFPYxaiU3Q+yMJ8hbNwixVvBFWzO6K0Zh/aPiKaOYbFVj5CkLqG/OOAdpY2nd3xHzlvv4naTevSAx4SLq+GboBDZGIGYsp2qcAuXlntBdHyVOk6AW4qsQQLv5lgfQ14FU2oUPXB2f0ywHz5ABGXBdWug
 rWZlZbDk
 rDXoYOjjiS3oJjeN9stOY8AxagK1iVQ1HZvemUnh+yy1yvg6CDoQzbAmhK4n5g9f71nQFDwMealD97EPKnUTRz7/qZZSMgzNGq9o4iy0AV2ADl5QLN8Jsy94ru0EektsEkHO2aMRm9WPd1s+DUyI41d1v8NyS8WjnJJ0wmqkplg7luhcdiCR/EIN8BU6A2o1HDfAgLKPD3y0xo/GkZ5K+eixtV1pBEzHuz/xseT7ih56wffE6Ob9McCu/qrAx0qcQb8I1GZGXr49uzIxn5mU8RXgeGBOsL9x2rcElSZCSwOLXO4CQZfLYpwZAV9LEbaKHGsx1GatuFkw3KC7qch+jgwc7E0raJz2D8L7Pcq4mDaHklLiSLU/Oh2cul1bLExA9HYQI3wvgakIBu8LworhzEE33ZQQzgNz8jV9udlgFLhILVqgkXtWNkoYnaw94uielpiyrCbj6wDTgjE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
hugepages are enabled by the global transparent hugepage control.
khugepaged can still be enabled by per-size control for anon and shmem when
the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_enabled().

Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe..acb8dd961b45 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 726f8ace01af..cdd4b37e4a68 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+static inline bool anon_hpage_enabled(void)
+{
+	if (READ_ONCE(huge_anon_orders_always))
+		return true;
+	if (READ_ONCE(huge_anon_orders_madvise))
+		return true;
+	if (READ_ONCE(huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * hugepages are determined by the global control.
 	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (READ_ONCE(huge_anon_orders_always))
+	if (hugepage_global_enabled())
 		return true;
-	if (READ_ONCE(huge_anon_orders_madvise))
-		return true;
-	if (READ_ONCE(huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
+	if (anon_hpage_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
-- 
2.43.0


