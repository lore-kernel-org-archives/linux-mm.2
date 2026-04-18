Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D316DF99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8C666B0175; Fri, 17 Apr 2026 22:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B160C6B0176; Fri, 17 Apr 2026 22:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B79A6B0177; Fri, 17 Apr 2026 22:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 861676B0175
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:44:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11E01C1BD2
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:44:49 +0000 (UTC)
X-FDA: 84670133898.07.7FD6002
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20592C000C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:44:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SOY7phTV;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZy/qpdlaLZdYd0zVi2JmCyMVDZXV1ZmesO1DChhnWI=;
	b=ke9wDLkTOomDh8gynt+kg/egW8FJUX1MReWcw42J5hHZ2X0DgG9JCFfNCZr5kkEpmNWWjN
	Z7WxDcDXkpcfvfe/XU9/YwnE9W918QLMsZ+v/A7NW8Oid+q8nt4TsjjdiYBSn6yrfGW8K+
	7Uk0xqiYit3ciYDslMW+m5de3Xv5KB4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SOY7phTV;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480286; a=rsa-sha256;
	cv=pass;
	b=J3bkZXO/T44nOn2aqq+qeeSYCoVpu9zYyOyDO5TPDYXO7JWf5xk7n23cH5YlOQ9+Pqi3yI
	xZYKUUJPbQhpJFE3lblrwZkvAd6fNqBWcOw4oC9z7MnZ5mo3lBz4av4ooWaBi0kS//Ug7V
	2/qM3MGPf/cS/6HPXVivZzksPMno/KM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=im9vtN8Nmk4s+R6NTYf3dJOvbtMfy84FCvqymvZBA/YUk//SrIgGf+4Gr4O302gaRdaeGgMSmuovsZ+AOP9V4jk3/1+kGnMPJ/avPKV/FSQoJEHu2SqX2TW40ovSrB8n1jRDePt7avuNtkNyWt9JesIg9qHaei4hk8WyYglyuGoV2n7YVHzjeJONDNzM50y/Rn68xykJMA47HTrGmKyJqc7i1bLqqSlOwTYKTHKPUIjOz+m1jCV/TxWsa0IMEQKb7Aktzf5McoAfdFqbvcr03nLCpz5gwykv+wmMQD5ntyuaGuEnBLnYei/A0U17pa8G1R4HHcMGZyf60KpxZkYbZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZy/qpdlaLZdYd0zVi2JmCyMVDZXV1ZmesO1DChhnWI=;
 b=RZBbO//qbHolz2UIX/cGlxoH5/PkdGiUye77pp77Hmo+kwrhWCGQZvIWjqFfT2KbsQNpyhalL9jT9Pv9UbDZuSCC7zMrOy4au/ayPeoDuU60lxdJ0KCbYhOe5nwlwrk6a0jkqJvcWFF06lDhNDtcOgt63ytc2LYS6yU8injt8VmCatgeXtLAtVsvyH2cQRkQdyk23i1dkrB3qG8NuJpF5J7N/WSh4gpZT8K2hhu2ZGtVndd17u8kZBn5rtR1rZHzf0JqIIjN6m7r4OTLtPKInGjSyXnmRIeVVAy8NBbD+5UbmGhBuhJ5oKYu2Qy4wKAiLHV6qJwB71CnKRR+BiU3hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZy/qpdlaLZdYd0zVi2JmCyMVDZXV1ZmesO1DChhnWI=;
 b=SOY7phTVmvYQEbg6R+bM86+Mf//CDncQYmCRSrY1VNVDpF6sc/lFyivztVVKBpKLC91N9Tgtd+XCacCjft3+R2g7BtX24nnOPnEkoF0UKD8hhT8E8G+vs0HuSboi6jKCxeseUrmzElTD0PMBlbX/w3Rkk3P7dRLDg0IjnZvYFRJyXoE+qhhVJWIhZsfaKrd2Xm51FMfXlVxqj4oVBejDx1YYUWllqfQsHK5fCxXkmylru0oYbXnpUl1qiuFLZfNPZr7jwQkOc4cLggIGsJ/d/f+adpFXnLlg/SbiB4psJHm1TfoGJf3fYc/TcKCzf0q4xQaBw4z9kgzPcK5R0PVodA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 17 Apr 2026 22:44:18 -0400
Message-ID: <20260418024429.4055056-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:208:23c::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bce3242-309f-41cd-3315-08de9cf46c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9igH6bX6rIGSmO/G2kXCt0yt5P6yIFoz748nGYcXG324uE24bmLD9ktyiwREIJPMpKrAMLF38nrx+ewMPCnH5pznkl0o6LMsMu/u5k012aHFA3ilxNVtZwq7FSxY04gou7rm3/itSVQGHWl6XQvti6v8SSEVKtJC/KWutaS+oGwlwum6l8E/s+hQSVG2gQWUJZgn0yZPNkq6VELYVieU/qsdNXR0gTZQ+P08jekPpUJOoCgpWLr4+TEdrJh7FBqW7JT1z5ka3q7yQIh3cnMXbxbOHYinuBHJMvSy5zFXX06C4xCVAlCBQQ+ngaZe/iAI5xO4LjNQYJOd5JnMT5sBbbtR+DVL8h7f/E+mOPULHM/9yk8EvACD2Sp41uIv/lukMWO/bTFdoFYHYqr2jvMv7Uz3gaXlj7wbZTbdQJUwocum+Qhelf+43/UyV1b/mGOxa7v08Z9XCc2xBeYhtxMO3EKK9CSYDqr86cPrnO7yY1HH9sVwp/sA/MxfGTEdzQcBDScvv4j9xk9cucLvY5Rg1/GttLObiKaNnVas3OFMKLu8s/NUsZaFBjhAv+5qkaOGaLFqEaphf8iSu65aJ6DVyfROw6jssemxHKWA69hi9jlrAhMzEInIlO3DBfbsJamxP8xcUAJ36LmcMLsFNoLVxWVq6h8+MEVlntTPT5oPEPX2A4VRgx+iqMjiTXgyaKz8rRnW/gBmQdo4GgVVQiLFqMtM8WAQ9LcJ9+C1Pj0O0Q0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HqgqsbzBq6xIT6CNGhzkYjJ2K0+ccxXVC9yE+TWas1kbUtJkiJGbxSbJo3Qe?=
 =?us-ascii?Q?yMHsDsmJvDHZTDgLVzcfwMVBDo6bFR6gg5ztljhL98TmQ015ZuVNP9ndE2W4?=
 =?us-ascii?Q?pYMH2Hevv++kMnajxGyz55WoyNrG1uSccC8k+pq9+00w7yjXkErSdPFMCfEu?=
 =?us-ascii?Q?GiXr2I39WsPV7U2S7vB96Zzfo/bAGGzTmxwQjvnHWrynVlJ2W/qB7PbFIdB0?=
 =?us-ascii?Q?fjPXi0AsaqGe7wv+kLVa2kJSMgNK8R8yejuHxshaMwphN9ABJRMwJmEMwXgr?=
 =?us-ascii?Q?KR1gz6WSvYq32ogn6tP4FvEgeg5hUTWLkmmcP6IaCacs1MZktP/hHft/0qlI?=
 =?us-ascii?Q?ybCmw0CRnc5bilnv3ECHKmG+OJ1yoc0sOw24mJHfPeDweYdj6nFmDfY7TTTE?=
 =?us-ascii?Q?moEvfqQd1qyQJ2H7s0qXolAItPfRQiScPH6t7+GY0ZpCiJrMmkHUiyDXalt1?=
 =?us-ascii?Q?/BnRGHataW7UPB8spO09i7ELMmXqTCLZKV2fGNt/4lUJXqpG3NoDTe/8GCAW?=
 =?us-ascii?Q?QS+8WnbTS1ArB87g4st+woNG05H/pYg9zpfnJ1GaxA4BgkqBLAzdrV1f0XYc?=
 =?us-ascii?Q?Wg+2nUbci02KDEDc1LrKhWOuvLFIX2ca0t7YisqEMs1a/rrFhDqg8ob1GOBs?=
 =?us-ascii?Q?ngi24oZhnCPGxQPU5I8xoIjKcz+6mVScUKRXbrqbE/VwCgUnP1SPtFdqqUEa?=
 =?us-ascii?Q?8zY9PfIlyUvYWGRO9fWJCPaPoxtOdBYda33MDLUNhDehBeinI6hTyF0zzqPQ?=
 =?us-ascii?Q?/Sfi6ygd6jCo3nVPSXR2/UhvWq6c7501lE4KOKmr6/q4c4VOJwncRsyWGn+x?=
 =?us-ascii?Q?DiBFi+cDastxUFYOHPj3DUYwQn95Dj24phzKOr/KrqFnwhkkbIn48Pkgdp7F?=
 =?us-ascii?Q?MtLjull9N0+lxC7JOwwWxRDPqA24vjV5cAGZsAqApbkJlVzyYSYRceoF24gR?=
 =?us-ascii?Q?P30rvJqAwgU41GVwoOTtYl8kaTL/+2w4xCRHM0D8kSpovxikRvFbowEtoHVd?=
 =?us-ascii?Q?o5v745mBNEGM3hYUSsjISWdzf50YwhO0EoyHQ599nqK0Cad6wpAIezA0K1YN?=
 =?us-ascii?Q?tAV4gDQbg3WPSL0RVXHjslWB0FBp8hDVC7eHsVivPQh7U+BuUjZTWlH8Ql5R?=
 =?us-ascii?Q?ggwuVdbHC4lW3ZPxSuWCcKuaXSozinvWPeaJg1aDoSgL0aDQHnSpZvrsu1jS?=
 =?us-ascii?Q?+9O/hMziKEuxN+NEuXzIEEu76S3dBTx0uPmKceubVXQkor/QIQXVINeprvGn?=
 =?us-ascii?Q?AHB7G92zrAhdVx42GT6o7WyiOdElxzuQgrK4hcas6MyGzu9RAW91UbYOqIbe?=
 =?us-ascii?Q?sblYHQCijg6AxNtnZKQ3ii5PU2GrK9sI6QzGNADDq1BHWaoOxIO/t9A3SCOt?=
 =?us-ascii?Q?OA8s9Q3xHSkrzXIVD9a2hDiqip3+7emA0KoUjLLk/2TIF4AKrNMeBcIWQCjp?=
 =?us-ascii?Q?/uuHHClI0Uz+KzZ/3JYS0qNygSs+RL5uxYhx4jqMAKmk0Pmt4pJJU3pv/EYP?=
 =?us-ascii?Q?tKjxzptvnpYjpkDC/x0MUToxhO9swVQvbSPUzBkP2QqBEco28zXGkJrrdoId?=
 =?us-ascii?Q?fSfLclkoIJdfcv1DMkSIrOwZOL53YCpcmwuGravFXjIGTdWXmrY0EurU1/d/?=
 =?us-ascii?Q?bt9MAsRhyDN74SSyApejjMPqfRg/6JvgJzU9NimyHnHDeQbPmF3Y+NIfVTC8?=
 =?us-ascii?Q?E0WTeD5lT2IbWLhTVZwM9ounm/uOaCZsxkUN8UedGuU7YqiD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bce3242-309f-41cd-3315-08de9cf46c7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:34.0189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNe9QaG9vc8+hMCgTUCej8W6ymphGgvsBSjh4hdR+vB3lu9LGtEcoxrFpYhseyO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Stat-Signature: pz54wr5wui1hadmtxm1jbbu8qe7dnkh1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20592C000C
X-HE-Tag: 1776480285-78520
X-HE-Meta: U2FsdGVkX19xujsaKSwQcdDVqN4MWILRT+iZjjhAduRnArbrRapjdfAFJ48uFsM7NFYj8GGLNmkAvuhhBX2CZ98alwDjmAjxIlk5+xwYQJZxV1Dp40XvmBLGkZTEzgtJx5MLt/A+pSroZzsdZxbMoN3XcgN0MgOax+lhk/9642U++ZZ4hRT5IhB8W/+RcCeHFVFEgBbDHQPoroR5Ghj0F1ro3prfoPr42mt7NFCNsz7amOeqncMEedig9l1nuJ1/uNfMoEPJ/Y7UZS1DRkChHCWJzQ//ewLoVVcHgwYfp/GMD8MAIwUbwJ4fhq+LT/hRXvQlJzPlM0gisfAYunxxf223nrvQCNmDbh8Zedfb/StBoUP0+2a1urNk3PJRTOL+iI9bWlTnC5gnHf5Uorz0OYhmeGKDazry+xfv2Fud7rpOvLmDE+aLlz2cZ7x4bH999cRa+sde3uOVje1/+OxM9yURWMInU5XVLWdqKUqAym1xZu4OKAqHKVFNZ39Eyejx1zYLMdHI7on60K5jLHlwTZL/4uVGBRU5Rmlte3HUGNFRrq6gvmCZXmiNWK09TG9XjYU1Ogj0vNRNRcGG2r5ncFMUrxVh0v94+F3/oP7j6Dh3ETYTvSxTi8b51RM//KmuzYdrqIMbyt79xsHAAQgXAUuZUv2LurvRupIzG+ALOh7B8kZuulMNUrdlbADH1mj5ea9PCXxDCpb9KJSMOdwNpaxTq0kKZIuVZxXhRO0wPmg4Z1whzUrpt1Yn/eBPVgo6MiD+JnVwjnqUOaXx8Y/p8YY+5keyK4Ccao2DGh+lXGdlrIyfXNooF5c54Tz94KLAOt6mweuy+O2btiSnh6rTFaoF2ANyYhpIV8UsBckDR4WoFyPsZvCUkkcf+qLPFqwFieraScpQYkRbPiGX/6SpWr6tkkCzsghngkNRIGM+Jt3ywwX7/alfJhUgcb5GEt80/mfRx4tcRS6+F/NOaPg
 65GjfZD7
 SXqYIbQKZBtWsq1/IdER1CtwqlESwGl+94Av8X/IccbxiuN3x7JPohFnfx2gatKdAb9oqXCxMVbCg3D/dUaPA+7bTIW9tQqxn7sHtDTzskbhX3BiApV8d/oG6UrqfzslyHTxn/a2Yb76/1ihaI0ZHNVgk2UHzVFK3xD7eYEAiNde+rnqZp1tiwrkbO3Bj95c7S/kPbGYbC6wQw1GUS+T81ksdtD/SlDv2+aimgRV1L9b3AWS0LeLTfEKf1gYAKJB4xBVuRSXK/JGzStN5IuOmmMcCkr0kmaBD76Z1w1W+X388YUizRTP40pxM1GpiRzqSyAs8R90+NLzF0cQINPjvlBJjW7w9D7nGxccBe8StyPBPWA93yQHo9UGzN6ZfJcSLgHoHQoXMVfYJmtIZHKbrieGqkDkv1csdypKk/T30F7IQXaG/5rjlIWpzLOvn8G1C7wNw606OrMeQGFeMfFlLUOEHOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_thp_support() for FSes supporting large
folio with at least PMD_ORDER.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/pagemap.h | 10 ++++++++++
 mm/khugepaged.c         |  5 +++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..c3cb1ec982cd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
+			"Anonymous mapping always supports PMD THP");
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..3eb5d982d3d3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
-- 
2.43.0


