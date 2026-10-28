Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DC2606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GbQkng0k
Received: by kanga.kvack.org (Postfix)
	id 884316B05BA; Wed, 28 Oct 2026 06:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B166B05C2; Wed, 28 Oct 2026 06:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A216B05C5; Wed, 28 Oct 2026 06:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDFB6B05BA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:07:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A47781A0328
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:07:04 +0000 (UTC)
X-FDA: 85371606768.16.636BE0B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010025.outbound.protection.outlook.com [52.101.85.25])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4C7A180006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:07:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GbQkng0k;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793182022;
	b=Zzo9ntkwC0VDppxkLXcrk+A3wvXow4xMFKgf/eyspjMWtBH28X9cRjgQAa2u/lZOVlUHEX
	/+BTAMyVBBwFIlKEus2ZbQdnHMWNwgEqF0wG+SObybakdBXIUsL4zlb2SNZ5UP+yLGoN+L
	mPbKdj51v/qfkNlxoyGjAfzZ0ZI5Rsw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GbQkng0k;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.85.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbeNLxd6hM3TZZyVzhpmbvFjbEaztIRZCkU/fJZxW/4=;
	b=CsqT/BDRbFzah7XLUQfYWSx4cSRKC1pDgPNWQhqxwfJLBBkHr0S8jUjOqvg7QnlWqWQS89
	ZTUiNO5f8o7OihB0+Hw8M2EJHn3zgibQnSOQeebJ4Vw1Z1F5oLN9iE7wt4WfCbbOxJHsXh
	kKtm0xTp6okJBbv7VEKMPIM0dwLUWXs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXfcIxouMJUNmiMKGn42PjoomX/9UBPY22l6ehSvxi3tFvxNzVqgKHf5xGt9Ih1sdOSoWKC4pH3NNkUQs2uCSghAKh23SmT5qfcNXuiWZQjs5kURoIHEKTV/nN7ozAMFXtfQzFOPKu0S09VvEGoKSCiqBiou3aauJUvEzrARKSaaYgXSbEkxyObxzUEgNSFaHpZ5YckxISHmcAAaVZUp4EPBb4cdV6M7Rpdf2FJj61IR62PNJmw7moGxKq91JvpA4DRDnZNURQSR1p5cdAgsunIE2E0QeQcWXIG4ZDULqMS17Mr/OL9ViPuqH8a02zaX0swKDBHpInJ2NPKTTedZCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbeNLxd6hM3TZZyVzhpmbvFjbEaztIRZCkU/fJZxW/4=;
 b=eiAKZ1/YNi7ukYi0sFIMgZfPhEQonLjZSHgF27V4eoMmUOHFIAKuSIcUwdxVnNJ0mdzrxZrmbWrxvYpYlIUS0WH7eEhUW2dnEso3T8dTidCQ0jecDOwiJX+l1sDdQRaRqLf0Vb81+L/bOqE98vqZ4sJb8CxViJldMkY/CrE5cwBA7cnEfqLlOBuF85m4ejeVzfPkJuJSuIrDPU4Zds12ppaAtCn8FaIqmkaxHtINNYFTRmu3nHBZKjD4aBAO+Pzx5pIC8tKPkwpyH0ZgJGFkRMwSBluZH9mSbWwJz7CsIIYSADv8YzBdIOwSIfZhrY490XGqxxS98lg0JrhnC9VOkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbeNLxd6hM3TZZyVzhpmbvFjbEaztIRZCkU/fJZxW/4=;
 b=GbQkng0k5UqOfeDEVJiQ7VsSfRMYpWI5zdnnAi18+HvOvVKd9XZ/5RH5JiB6bLABA8NG6TIxn9JJSjaqcevjzQOKIBHea5XmMDAUbsm1154y86+i1wTJBNXfbKQZBFuuNjoTUeELRKafyqF6FYdb66AQWiZ3WYRlYfV4+M1UPlxfmZIOWCUDngXWB7HFYwkOPv1FB2sXiy/2Em0bcybtukUsPNgngKNxszB8kprFzqXbjLlFMqOqp4X4JrQzfe6kFdQP/nBQ7GtXy6xiTEU7YzaNVWUNYS96kT7HDtPWQg+Vr9kj1XiDEe9ChN+cdJVzabsU1HIkNGchN93KDJS8mA==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Wed, 28 Oct
 2026 10:06:54 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 10:06:54 +0000
Date: Wed, 28 Oct 2026 21:06:49 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Stevens <stevensd@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org, Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: Re: [PATCH v3 04/15] mm/shmem: honour F_SEAL_EXEC when an ACL is set
Message-ID: <auHJOSkggc-V9dVi@parvat>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
 <20261028-fixes_shmem-v3-4-4ce3baf2db4b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028-fixes_shmem-v3-4-4ce3baf2db4b@kernel.org>
X-ClientProxiedBy: MEWP282CA0039.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1dc::20) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0a381c-0aee-4d47-0c0d-08df34db319f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|261022115727099003|261009223027099003|261022105027099003|261021123027099003|261021121427099003|10067099003|56012099006|261026121527099003|6133799003|22082099003|18002099003|11063799006|261026140227099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	p/8LXgXI6GiTT3YeAEbhgWQH6QmSXsFeoVyti5UUEqrfET5qC1w3OcuN9JTKDeFRdMwIwzYxe8jjJNRNLW4Jb6xT8xqq5/R49jOVE1cyn7bR7kR5Suw8Kiq8bV2YHj3fd2GjW8FJZ0uIfPfnfcrc5xoPCJRmAvyT9LApeFG1CGVlDhBBVY67lJawpOsXZDWK36+u0FQ6scMfZPywMFWu4p5+1iKW6Xs+037lTsWo0KN0tXULTJUpnV7k+oQM7kK38MG2thonP0NgxAHzQaxQIpiKQXre7rnp95CmHahyguYkNlF+dagLyQ4/gghJFY+5rfbCCrF0xfNcBRdZi2jLqzlEaFnAEFsy5Sq5JU1Ai1BoSHNzD43x3nP5X4yKaAexuBhtx5bcQXeRzfeUDvl+XhbfnXQxUGLn9QJFfC4p7ziECsOU5qJ1NpNHDgnwTqWchSSbPEo4w3u0F7cLmuxAVwrOG3YIbH7ORlG7mtsJUXan9F/gSSSeztu+XSag+0i2R9IHe9ki10iKAryQuSStZGLv0AAMOKgkO4Xs+RKmcdGsbxKWQiTxDKtIcUVN3594yiFMrDwbM1mWyL9we/FTeZn8Z1/E3HpfgE8zm9y6ehrePY4vSzAJiwKYm5wiYTyqiF2ZrF4/9WFOwPnbTEYhHbwqz3abD1n2qNF5VJOWzS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(261022115727099003)(261009223027099003)(261022105027099003)(261021123027099003)(261021121427099003)(10067099003)(56012099006)(261026121527099003)(6133799003)(22082099003)(18002099003)(11063799006)(261026140227099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t6V7H2AZ31X0DOZC0NalocoiudAxLK/XORTsl8Gpi8oe1ohvvic6ct2D3cYf?=
 =?us-ascii?Q?6Lar2vStMu9EjkOXJJEwFtHKNTVFsuzItEqekgrpvbwkK1OGy1lopZ4Tztl5?=
 =?us-ascii?Q?4nJcuuEuKTbhlPXeJkq4I1UxcDJJ/yKhOoYXyyBywvHKdkT+w3C5UCTjmcyc?=
 =?us-ascii?Q?ingnqT+XYsfzehluX9QAKnf6ACJNgtT7a9Ezd3hD30DPVrrHefh5akT2dVaE?=
 =?us-ascii?Q?SwuMk5HW/MFTWiLNQsHnLk58hrUSgskfx4yoU2FESVpGxHR7p0QqNePu/Yek?=
 =?us-ascii?Q?Ro/01uvEEynX5rXyo0Yn//CODsGr5VgGFWCemldGL7+idiDWWRvHHq/x+KTu?=
 =?us-ascii?Q?9Wxy5/VZk1QF4bv6tcodWPEdzDr7IcVIGOAyh4hY9x6kfR4NRM5/IMwkRQmD?=
 =?us-ascii?Q?mZ63rLYBrZjp67zsoly0ROcaUzLKz3/qg6dLAcrZEWoDHUn3fj0Kpg1LkqRu?=
 =?us-ascii?Q?W8iNTmMBwNWNrd6aD8Fh08rrMjXHrTt7YekXl5hiVi0WOooYq8epKe1hjnpM?=
 =?us-ascii?Q?XVNS3/POGPzLbGBhZGJLohwbN0PUavhwieZ72eqbQQri6hUI8YiUTrGCMkRN?=
 =?us-ascii?Q?P1rq8YoN4merYC4dAZBHfBqTFHy0kivLVZbBp425XXJEUuse60eAArtv0YNZ?=
 =?us-ascii?Q?/WOIAL3kr48QvQpa/dkb6WMQEvgg0JBwLkojb+wU4wgehkjAyaVQlhqKShZ4?=
 =?us-ascii?Q?BP9oBNz5N+ohpF1YW4nwycwoorsT1oKq242JbKqMc/kwga/+JWt0dxwta/eA?=
 =?us-ascii?Q?oUdW22zStNpZ8UttyVylqXGmZlH9YReax/T/M0AIxr7D21s2Xcyo+2wo0w4H?=
 =?us-ascii?Q?6Hu5b4DHAx+dU5uPHUmYjVRVXvlql/YLOC2TY1PB1cMHKnGGlaFxG5dJ2pkr?=
 =?us-ascii?Q?ilGPIP098T8SQnxc6g+aJDjsbWJHCNqHfBmQLCByT1b4BwWtgwUz7DBvDs6n?=
 =?us-ascii?Q?9+Uqe7OhY18oVHcBULK1Ixp2xRX6/YImk0RInA62GBfzqLQPaMQ6wsKg1swL?=
 =?us-ascii?Q?1UY2VTFI3lyOantfYnO2+SpCKEdcX3k8cFFNQ+SBGCChNwk6/xO+z17HLzRV?=
 =?us-ascii?Q?9zPRL4bKQ+CYNUYpyCpOjokUS8aV9Hki9XczHRk6jHwjJi1UE+O7FqUYZ91z?=
 =?us-ascii?Q?8o5XJBgjvY5dkwHSC03kKIt5wEpjZ7x6zfPLX5Nl9e/iULTe+zqiXs644Jhj?=
 =?us-ascii?Q?KZ9SDBn2LrjzLHLIeZRjNMXMaYOhjfEKioYXNaUyA/9tUyoXRnZgo7DJDQkf?=
 =?us-ascii?Q?h+izdG0Gjzm6DkJQIXt0BKSrDUrFF9x3EjgOzwsxZsca49c4JJpeLItEMyi6?=
 =?us-ascii?Q?If7k6Bu/Cm99v1tdZpvEHvYSEmsY4Pq8DJRsFSYdZ3gH8LamVjNAshkhOMFO?=
 =?us-ascii?Q?bgAewi/wf8rmxdO0uUxMfxOoYG5cPxdVeis/Wmqfe42WKwODPgc15+cjmDYU?=
 =?us-ascii?Q?gJ7I8HMfD+Sxuk3dbY16t/OciwSUa772oVksbBjHfhxc4AkGEpJqvSHDSqDv?=
 =?us-ascii?Q?NCbFZoyEiUpP6mo3Pog1gvm3Jr2rezF7gnROdw7A/VflQiElAVnYNHZP5dln?=
 =?us-ascii?Q?yw8pf0DN4cMryp0CG47K4PMX+fiRaLtVN+UqhkggRocZ7rZAWJCdy6VCw1T3?=
 =?us-ascii?Q?ycidxmuGXG5uTN1ph0cUpC12HAym/SKJYY0IW60WTf+Rb77/giDXKEFG4opQ?=
 =?us-ascii?Q?xmMJjLsmOL7B0Bom4M0MX/5WqziXK5KcNOKn9sYRoPIMj1hkw1auDyqZLCsS?=
 =?us-ascii?Q?t4pOsVGfeQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0a381c-0aee-4d47-0c0d-08df34db319f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 10:06:54.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4FoH2Il40ZGpAYflG9/G5jSn5dfhSCAozTXUnkvNBcPhXjKFqi/xbWCrOaZqCyfo1V1xs1bh1Qfe2laGdlAw2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Stat-Signature: 4wzmo74b1tpuku9q433jsxk6131gr4yj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4C7A180006
X-Rspam-User: 
X-HE-Tag: 1793182021-296056
X-HE-Meta: U2FsdGVkX183+xRiXV7IUsSCez9XYEEQmiMdk2qS31JwY8W4EtWqIgAxVU8VoNCN6ulqZ9PyhGSMHbhm0PnLCIz9sckPhgl9lALCtsh244c/2QGmtyfE+o77MsCrHFsPUlsB/Vb20a/XJiRBmrXyWoT90+Eno42zR8B9EJ9Tvl756+4sQ34vZic2jWPtG08ukHr9yXiUGIJGkv10YXYkPGzZnfEmMGmML0/zHzUbs9JuGiP1JG8ZzrzoTU9/uuVYOE8poz4pRwDAMLRyFYb5ne971YDAYpH9DLPBmc0PxOSe6FkR1qcuKDDx8/shdxpg/nxnt+AVGxcAgD9eXV/bE/V+LUToMqkX8cRVZOxO+wNCAB3HlK33NZsd0cN95XuelB1s68oEhzIrRRfjoKBWOHUYlXBEcIy27zyxmImdtcEku/XXSipi1xAG2DpT4zzs9eN3A1NTJQyoYibDPBoqcTn/uAbKIPZNODJIRk/2P1mKkOBIRE5//ZTO/PCdB88yLjohtxLwYz+pfQh6zZc7YkyMR9AsmygKBMs144UpsphTWisgWAuUdYarSofcgq+YjVmwXxeRMjG6BTLQvQsN1RVm4msyvv+eUJLO+ibNgDTSdtrxBcwefitsOnCXy0olqHFVhCGA2X0tQMl5YPWNi/hZ1bvd08Z6/mCL3mWH2Ob1huxzbzigEAQN/a2hY63K2NgRPl61qIX/1T881KC67qNWDvA4+BapxJ5mKbyIzDl4xKWGJVzrP76tBjaivHV6M3QfBGTICVLaoTWcgxmaZvcF4JOPx1bl87GmkhlRMR9gVnAZHlZRCubZ4YlI02mwGqvhiBM/qhDQWd5KhtfAvVJYK4RxrUIgI0EX3EjC6mOCc0PQRejGOyynUlYJshhYoGs1zBviYFVOaUvFX5BGPW2UhosRXb31Z1p9oCt925LDD6CGyqDWCi/KqtFf91T8/L+aM9+sY56J4Gp4vC6
 27Vk5jyw
 tZrLcKLxaqvsH9exbvhYuuuVVMt67AIGYIUgwHk0B7Qju/MDuaO1Rk+bGeMZfyp7iIFHl/d4FC0fu+1k+4gl59OEWef4ERT9QI7NsOVjzLJn2FA03tC5Nqsgq7CBL0Fj7kQ+6bThNgD2uC8HHkkjDLmJset0doDALgozmulbxkN3WZg/fu3eRxjKZVa1buOATdZcXbFNZGh7hGO0zIHJY86Q6NF5HM6OuylUCTeCdz2JQncG4OMkNFPRiMGByGUW1XtTpY6Wc5X52Fh9g+sNesdqlKt7/ik2WzzFBZ048wbpYDOptVscs9FdxAtw87WPHl2bFob/UlrhZwmvHUV9w2RYE+7lWWgdFW6h9DwYTiMScrV1RVSGvnhm220J7UK9uz0tQAPv9mZi4KOWc3vQ6lvDXbN0QO/WNzVN8L0SpTZoNpD0KOjAPMAAzHYusv+6u9IF/f4tBWIh0APL2os1vSru0EtZ2WxRrg5SosKMH5Q3ByfoiFIgwmGar3ftqJeQswtk5DQfHqXAid4klbpmZFC3d0HxZgIDSWzg+7mdGvn9hAp3W58gjsEFMm6kKAAVAiR0z4J9tVopqXM+/hlPiiO/G4aawQPjpIunwsl038IJsntfZfBMMt0aQ6V4AycCc/PS17aOGWxKlK33XceAt4kS0fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:55:02AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
> 
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/memfd.h |  9 +++++++++
>  mm/shmem.c            | 35 ++++++++++++++++++++++++++++++-----
>  2 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index c159e40e3f34..272479317cf1 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -2,10 +2,19 @@
>  #ifndef __LINUX_MEMFD_H
>  #define __LINUX_MEMFD_H
>  
> +#include <linux/fcntl.h>
>  #include <linux/file.h>
>  
>  #define MEMFD_ANON_NAME "[memfd]"
>  
> +static inline int memfd_check_seals_mode(unsigned int seals, umode_t old_mode,
> +		umode_t new_mode)
> +{
> +	if ((seals & F_SEAL_EXEC) && ((old_mode ^ new_mode) & 0111))
> +		return -EPERM;
> +	return 0;
> +}
> +
>  #ifdef CONFIG_MEMFD_CREATE
>  extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
>  struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index af21a89abb0f..e3e4bbbe1d80 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -77,6 +77,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
>  #include <linux/magic.h>
>  #include <linux/syscalls.h>
>  #include <linux/fcntl.h>
> +#include <linux/memfd.h>
>  #include <uapi/linux/memfd.h>
>  #include <linux/rmap.h>
>  #include <linux/uuid.h>
> @@ -1546,10 +1547,11 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
>  	if (error)
>  		return error;
>  
> -	if ((info->seals & F_SEAL_EXEC) && (attr->ia_valid & ATTR_MODE)) {
> -		if ((inode->i_mode ^ attr->ia_mode) & 0111) {
> -			return -EPERM;
> -		}
> +	if (attr->ia_valid & ATTR_MODE) {
> +		error = memfd_check_seals_mode(info->seals, inode->i_mode,
> +					       attr->ia_mode);
> +		if (error)
> +			return error;
>  	}
>  
>  	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
> @@ -5404,12 +5406,35 @@ static const struct file_operations shmem_file_operations = {
>  #endif
>  };
>  
> +#ifdef CONFIG_TMPFS_POSIX_ACL
> +static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
> +		struct posix_acl *acl, int type)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	umode_t mode = inode->i_mode;
> +	int error;
> +
> +	if (type == ACL_TYPE_ACCESS) {
> +		error = posix_acl_equiv_mode(acl, &mode);
> +		if (error < 0)
> +			return error;
> +		error = memfd_check_seals_mode(SHMEM_I(inode)->seals,
> +					       inode->i_mode, mode);
> +		if (error)
> +			return error;
> +	}
> +	return simple_set_acl(idmap, dentry, acl, type);
> +}
> +#else
> +#define shmem_set_acl NULL
> +#endif
> +
>  static const struct inode_operations shmem_inode_operations = {
>  	.getattr	= shmem_getattr,
>  	.setattr	= shmem_setattr,
>  #ifdef CONFIG_TMPFS_XATTR
>  	.listxattr	= shmem_listxattr,
> -	.set_acl	= simple_set_acl,
> +	.set_acl	= shmem_set_acl,

If CONFIG_TMPFS_POSIX_ACL is not defined, do we want to set the set_acl
callback to NULL? Earlier it was simple_set_acl

>  	.fileattr_get	= shmem_fileattr_get,
>  	.fileattr_set	= shmem_fileattr_set,
>  #endif
> 
> -- 
> 2.43.0
> 
> 

