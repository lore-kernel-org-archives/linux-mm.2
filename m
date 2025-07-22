Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB96BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434FB8E0006; Tue, 22 Jul 2025 15:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6258E0001; Tue, 22 Jul 2025 15:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADDA8E0006; Tue, 22 Jul 2025 15:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAEB8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:47:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6108216015B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:47:00 +0000 (UTC)
X-FDA: 83692933800.21.9E6B0B2
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E21D40005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:46:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ORnxll60;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753213617; a=rsa-sha256;
	cv=pass;
	b=fhQjq74CxtYpK1bL+PjVWtcolZ1lKXauXzSrCeKAF6veRN8obiVEukKtsAAiHZqAqk1HCq
	nPt8fsB1iMv7GNqlw7pkKSos/uN8gvz8PICXiaEtBG7HwM++zvCiXsLZjZxMkO0veoCyA+
	zL8NQJhgwbFC6XGl7vMWtfBlcpnColY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ORnxll60;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.72 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sBTLYHVY5uivYIuEx9gKPl3PE2bZh4a3CYzsVI2CLTA=;
	b=DUNOlfs2ODlyiloJUfmLytx1S1Tt/UnVuPUnJIDCA+lu+Y6zqsJl7bJdWebLBRERKaYoBs
	YJGlWj5nSIlAXDXwW45/hNtxP/g1yeMFm7txCAWW+IOjy34MCAgYqaVVy2vMSf226KPZe6
	437gc2/Tm450Ue6qpixQi5jPho6oVNw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q37Sf45JVrGWypY9nm6VOTGB67Rr0etrJveKe564ZPORwLinEfIx8Y0FN8hqJSDxgDnD1pDXeiKZPScRr/LMKcggZpc304V+cbujQ1+78R3gX9GJ5x8S3pc4neEreljhJzsLZIhvlXKJ1GfP/0DxG6lKE9Rbkvt+u6WBd0cYM9IYstW1KP9xiC6g8xLDNTNuWhH5kM7d/lZmDPTS3C4CKGpQntEqIaa4UsNgXX4ViC0DajZDeDcQzjhQzD7B1zzN9PrRuaidwMk17YV6SNvFbaCjMsFwBbektbLscM7CVDIye23ff6tfZ+/9nUt4MbXoyU8K3lrnpf9HRyJFM62pTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBTLYHVY5uivYIuEx9gKPl3PE2bZh4a3CYzsVI2CLTA=;
 b=dQca+s+UpKtm9UNDbK1Z4LyUzB1EWnXJ0IOYIQv2QlohchX3BXx913nzS60lyJSyPzHfn9fjfKULcGUHlwFxi6u7kwEsgS7EnSNgkG6T424Jq2izXwxYTp0p+665Nf/jv4qkQ2GLIghmjr/65bxmmWmC3HMkzIpVY00nBL7/l4BlrtHndKAXUI7GkYHEaukqgge7CHurHgYZ42OCMlOsccrU4tii2F7Ki0gk3Bc42ZqDYnxPLtaMguFYfYiyH+Cv/JTZZjluwzbJNlvGPKHdktf3XSi75dJYFOgnFGn0tgCRDqdYzqHNINvx+TYXhtVHSZoafqNPsuwue6Kbn1qWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBTLYHVY5uivYIuEx9gKPl3PE2bZh4a3CYzsVI2CLTA=;
 b=ORnxll60kjXanqo9Zfz9Wl3oFnVooZkE1qKY6+J+9ZHOrdnmB28d5GUULMwJ2YEb8DzNMFPkD9YWoRbkm9Qb4Mff+fsOZrO3BboGdwaHgp2iNnLBd38dKtmrnOKVJnQvHDT0udx3GC7lpXHitXd1MBl40KpsoFz0ehior75+RlEbYkFZJueEfHTaTuqDMIbF0LmmKb3DmACxkp8ZGXQw6lgGDlwSUj0DCgGKCFS0hyT83klNm0K1JtTws6BVxXD/SYgoOo5hCjwRRklHsnwnkVAYkcyMMNym7fwfn2QMTRkBzTMaTvzucrZd9vDXHxlxux7Wkixn+B4D9VUg8dzM2w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7031.namprd12.prod.outlook.com (2603:10b6:303:1ef::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.27; Tue, 22 Jul 2025 19:46:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Tue, 22 Jul 2025
 19:46:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Richard Chang <richardycc@google.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	Martin Liu <liumartin@google.com>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm/page_alloc: remove trace_mm_alloc_contig_migrate_range_info()
Date: Tue, 22 Jul 2025 15:46:49 -0400
Message-ID: <20250722194649.4135191-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:335::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7031:EE_
X-MS-Office365-Filtering-Correlation-Id: ed80f024-9049-4d34-4788-08ddc95881ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HGkxeH7wisIIUTXey6ub+WpkSM6RujTx5BY9q3M/I8r6FM2w2xRqIS1u3j5e?=
 =?us-ascii?Q?JDJQCNisMcc8xJgsgYTihvxfMtDgXfBgTQC8M0RAtppS7Sy8NQbJqk2JaA0E?=
 =?us-ascii?Q?TzwqrRn8109KY0RHDEiMjVegAKx1x5TwGzh5XCeTaPx3YF+mN1sQ2gxoVdr5?=
 =?us-ascii?Q?k15RGSnnjk/5IrqXbS1PO0GNxCzaewWfS/pmQQH2auI/JK/03F8PHgVfhT4Q?=
 =?us-ascii?Q?Svq6uDWtsNkjiN+4QcQronjtepRzjfbHo11YPeqCLZwLLZ3I9WcSJ98xPqrF?=
 =?us-ascii?Q?U4K1wORBXCnmcq1t8WNdRjWkmWumObiT2SP9JndNj1rJDR2ja0GuG1bPWbUN?=
 =?us-ascii?Q?+Or0SVLh2Ig/+OMekA5bkp25g3+RviMP+weR/twXkYosWh0mmhbIn0h1rD9I?=
 =?us-ascii?Q?xNYHHwSoUCdE2LGSYvIKMi57KCePtvXL0Xzy4jgSCPXwYlKgRFu2OLlckt2P?=
 =?us-ascii?Q?iKrgzuH+uHrgN6ttes4QC/xsuswZiPHOkX6gV5ORVtttopRUPKkIMombv36F?=
 =?us-ascii?Q?gttWuSNatJSdwkJssL93AK6yfxRoMW4ZYEpGPMyB91SzC9Kb1o0lZ9kJ5dSi?=
 =?us-ascii?Q?YvBjAK3A3KA9KTqtIOWnQJoSyOZUpOJBPV5SGm2R/qnNEzKFOxLJM4DOwXg1?=
 =?us-ascii?Q?3342UtH8RwftyQGFAhmvFq5Zf/N23I7N2nKm+/mrp2v0tFS6uti3NVoTdcid?=
 =?us-ascii?Q?Ujv9Tn7ji6+L2yiJhAL97J42A3CgtULKuA0OxP2QXNjNMNTT2RV51+Hqemgc?=
 =?us-ascii?Q?iPMMiSY75oB9Dk0lKn4ca7tulzq2KWKigcT13g6a16dTyc3csE2gnnDvgZcr?=
 =?us-ascii?Q?uC03PdVgIWKizlJA8Tt9nWQwSKUZDwQArbbO0Mt9UZUVYkyGmDKCfKSnarkP?=
 =?us-ascii?Q?NwUb1j/ianRdwazegiKShvYUpMK+CZyxItEJY+SFMhTBv0UvtCKAU+PgDg6u?=
 =?us-ascii?Q?MIZBzK094+tfODkho9hzbHoHzWk0WZVHRFK6OsGdo1BGeEsiQaCEILz/MFk2?=
 =?us-ascii?Q?GoHWl+j8AnbVEG2+utlQoULQRbSYZXX8Mc84dQ495R3bpe26LFEnODqcgRVs?=
 =?us-ascii?Q?a9rTOnxErkMyoE+THf7XX+JdiLw5w2o8ob2X4RhimDTFWH2/WceFs24G6mi2?=
 =?us-ascii?Q?PZ0dyHUZr2cp7JRVawiQs2xcxalM/kfhu3oUcBzeePxMGVcDHc9V88Hxdiih?=
 =?us-ascii?Q?6oYVX84Ww1vl8Q8mqnRbjZ3eC5bqYQKRrJXjpXMvE2eLrr4zpS2XcY/k02An?=
 =?us-ascii?Q?WjmyStyxWiPaD8HDwIxQzTw2kkaFHIriQWeM6sKC1NQbukpuoqx7m503LaL/?=
 =?us-ascii?Q?4P798Ii7QejiEnP14KUt26kizECiK4GUah+ZMKnL9aAGf8SllyclOZ+Ok52u?=
 =?us-ascii?Q?DieGX1OTl7IRyfV2pN/78sSRTkWKO17qhHHPMLXQf5Krj3TN79513ZOjeBUS?=
 =?us-ascii?Q?WAgH3PabzlQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7UbR9Q/XgooMZ7gMFSyVafBXjQXX17B69OKkN+GR8DhjnjgeZ0JUAAWfuSPv?=
 =?us-ascii?Q?8iWZfkvn53jvVJi1uahfpcuA+aAH8beLKNowGfA3SRcvOhOsnOaEB3WGn35Z?=
 =?us-ascii?Q?NtK3axhs1MbTfMd8bTCVaTJxW0ee4KVvcFfBqUzWmsIon/nm0OaACmiSYHym?=
 =?us-ascii?Q?jEnxJzO+X7GOEIkxhrnP0wbxss2nlP+ZR3wnd8UfeRnROtBaJ9fnSTaej3ey?=
 =?us-ascii?Q?jeai55dkTmJM54/0KcLnMnx5Y+U55129ikXD+BbajsAsxbUsWL4nlXPnZmEg?=
 =?us-ascii?Q?UP89kP0Brh0BcO5OggNeaWGOElW34JA/BLXrwzd8JUPeHgCjbwu0/lzByHtm?=
 =?us-ascii?Q?PVwB5volSD/US+/esN4aE75sFNPb8Cm+5rHy381v3E1c3VzXPqxYn0uNlMic?=
 =?us-ascii?Q?1No3bY732wg6tMHYejnflXaI7JAheBju10HzidSnT5D4pA/JZrumcVH7kJo0?=
 =?us-ascii?Q?3tQXKRJKHn2tJDaIulERRaVRiK6AHvaSkxzJdFhcN1bvw/72Hqz3tucvz/qV?=
 =?us-ascii?Q?EnxH5utHcCi6y++bxjo3AH0ZoeBuoY8gQTMf8kDHWjSF9J07dhML9+LpvkvX?=
 =?us-ascii?Q?50L+x6sypCDu9GD9wKc6SyeToOD0X+XU17c7QZVLqSsBLUjnjX0ayDvfWjZn?=
 =?us-ascii?Q?Wfxq0UX1BZzJ+ojQFHSCTzEHXRw2UnvUuV+gBOf0sCUGV4hNO+fbSSfIbOHp?=
 =?us-ascii?Q?XGM3KJqXTLFvEVZZ/dzy04UMWoYAuReNrL72hj7Yh50G4VyWJaClnL1xb/Lz?=
 =?us-ascii?Q?WraUY1rysXElX/dwjTXGVfjhNQL5XUDBPTsJCBorlBHZaqF+gOrudfzm0l09?=
 =?us-ascii?Q?QBqVJng1tJeRL/YYjQy+oBeG3QGFzcyh5Coyj/FrXu2CbSxn3paGfYzyCDSR?=
 =?us-ascii?Q?dntRwYrDYi7AGRAad4cdHHjt8GCynHUh5iwTXXsonIaGtKL8VL3dVysjrZqm?=
 =?us-ascii?Q?/Vrg4uGvi+3wL5Ix02DvKR3PZWhYxaVYHJ5aKQC4BJzPxnV5J243Repxowx4?=
 =?us-ascii?Q?olipD/sq79KNII9AcZqS33AVT7bougOxeV8uSh+ODi+VL7hZrIeW2910PVOT?=
 =?us-ascii?Q?7XXB3LLmJU71hmS4lIoHib51+0Bg5Uy2w/3KYMglRHF898Sy0culqJ5pBlD6?=
 =?us-ascii?Q?jeptJKfntayZf286HzczZl7lov0TsCkUU7bCnkZDXaP0P9JtshxwcpPrdxHc?=
 =?us-ascii?Q?sOpygzTrULi9Zx1Zo7rw/D4CqnNZFw5VMG4haBHcYPRqoxSmZtj0rw3hZhtk?=
 =?us-ascii?Q?FQMKSE1FCkxB+J7pkOy7tM43UOZ6lYmTlZlpVK0ecgQpiApWgGwiD+D+MpUq?=
 =?us-ascii?Q?xnKkoB+lk8IWlKYPw5+RgzQXtPATro/HZqd/yzLLIRzcAuNSRHBJ2d1pBHkI?=
 =?us-ascii?Q?SZrHVI5u/u1XCgUSrSdYh/gFhjjMvC0zpNBENbl52mFTCAIFoJImUJNV+aZ1?=
 =?us-ascii?Q?D0lGxZUphDZ/2uN9xb4ax7PGlUbuMuJfR0RpFYfu0qFMEYJ7wfSJETDWga5e?=
 =?us-ascii?Q?DY2rcmhnfack9uV032TD//XcLdHcE5D2EILejyu3nbWUDdniIFldV1eHcUyc?=
 =?us-ascii?Q?qZe3Xr/coaoruEWbcAL5C/3lotQ3hPT/lPqVzcYS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed80f024-9049-4d34-4788-08ddc95881ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 19:46:53.1553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXLv0+/IUrT5ylyLTuMNHBC/cMcU9M7nmj2uCuVh/ZfjC422qduTaeeSZBpgvMMr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7031
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E21D40005
X-Stat-Signature: 1ihor39d93u8hzgyy9irro6qd4rama75
X-HE-Tag: 1753213617-749881
X-HE-Meta: U2FsdGVkX1/Yh6lZP7kfEzCFh0pzLCuJ+5Uh30ydjC+FrPQ2SFKw214o0IoOSVxkEqaufqqYRMySIpVLxqeSiB0i2C+eEZnsVePPf3IU7ogXt+8jafbjEv5k0F5AyN7uTFdC0aggmsm9ONf/K85j0kYcuRkbNEqS1P3SQ/AE24OYMfyC9E5nJoeODU342JJtL7XV4uyl/KVsCwPV6ZPLqhiPtk+eDbdl+y/0q0CU10oSax4D3fNNkerkjHUrVic56Pu3dC/RqUUOsm0ftqfWq4l+b7wz7B1WeAZxN+JKxBcKLBvR1CVdsn6l9VUIU29kxBAF8jCqdcdw723HHj3j1qJlMbB8mffDSeouGK2NAY0OGELoSheUDudUW0zLTS6bJKkNdxkcwx70KMrmhvfpT+POnzHKsNkk7ZXkyQgX9Kh8GBSbcCQDcsx8URS9O/DXAwEAS8gypFldPIRIyJ7ppx4MOJF0L2j0Dd1jpOWY3nKEabj07c+q6qcHbLJ0HzALaLX+EHz6ZGYaZHBLvJY8PHIJgb+Aey0+Ef+rmuVWiJu0+qVpZY30qi+EIadI4D21HkSzgOPG7acrzJST36K2Nj4UepfdCrQsgS7VYfnieP1nPkNbsRFaG8S4qzH8a7fDKay/CzVWfroSc4QBtP8qedn2i3E2yBNzeHGx0PFxYJi7eLazySU8/0AgftlsrSrMIX+1YkG3pzj6T1WNsC5i6m+C8AzftoVltDMqdQQjrUIuQbCHgvfiuva9vkmO5KFuZHiCU3qem5HGUs23936iLxu7Rf9sdpNhyauqlSh+xg2yAS8/G4sOwTU+FJ2XNtt5BKGVjFV7o8PRAIWTbRal81ZA505jxT+RdWbPVULwTePVEKqj+kIQolAtXM3LLqBSJcchMo6RbVEaOsakzPl7LH/PQE/IeUDueIRFb4JRFft4zTYnPbcEAL9w2dQK/aea9acXrPZZTXBgT5a2uMt
 1JySWqwu
 yQNp9Q0jWYiZRTmUlp1MhskkFNWVASQNFNLjnRTGH7rmSqjBVK2aQ0CisEowd2/Ll3XrdVHhwmtv0EZd3YBpQB/kaTWG9VuGdb2w68WoPum2AJPaCfrQXvOiYUciNdQDy26jj1ExW7bB4gZ38N5p4AoyHJkjqwS5KcxIP8yPdZM92lTjI9PUGwXgExql6//hQoVZAYcDnLbf6BeZYvkg6HmeT7l9dlSW1aksJUsB5JkRlnyYfz6aAAa4VXGXm+W7ULzKUNcFryMvu28uUxBVH1fW+6/6XKPVYerPf1tlOTtOEjXB1jK/cu3n+BKXG2ag+98I5D9A4Cfv+8YfHBziVCON3fXHBMKdEcP7MZL8kYi9O46wdtqgGqQLSM/XpF0zBv2tWtdVEPSsDUIaLiNGqXuBz6WS3YKmxSQK66I8/kxlbrKJRRqxkEvhtkEzHtkmQ+eQeNGuU7d+0ZYvcUthBYrVAf/xF73L9JupVyaujds19B9aEM9eMr3FXbRDLUewjAsUj5tDJSiznXsFSwHNG0VPVS5n1vAcwi5te8g5F1OvE7O5+Ry5+3RRCnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The trace event has not recorded the right data since it was introduced
at commit c8b360031218 ("mm: add alloc_contig_migrate_range allocation
statistics"). Remove it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/trace/events/kmem.h | 40 -------------------------------------
 mm/page_alloc.c             | 32 +++--------------------------
 2 files changed, 3 insertions(+), 69 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index efffcf578217..474358773abe 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -304,46 +304,6 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->change_ownership)
 );
 
-#ifdef CONFIG_CONTIG_ALLOC
-TRACE_EVENT(mm_alloc_contig_migrate_range_info,
-
-	TP_PROTO(unsigned long start,
-		 unsigned long end,
-		 unsigned long nr_migrated,
-		 unsigned long nr_reclaimed,
-		 unsigned long nr_mapped,
-		 acr_flags_t alloc_flags),
-
-	TP_ARGS(start, end, nr_migrated, nr_reclaimed, nr_mapped, alloc_flags),
-
-	TP_STRUCT__entry(
-		__field(unsigned long, start)
-		__field(unsigned long, end)
-		__field(unsigned long, nr_migrated)
-		__field(unsigned long, nr_reclaimed)
-		__field(unsigned long, nr_mapped)
-		__field(acr_flags_t, alloc_flags)
-	),
-
-	TP_fast_assign(
-		__entry->start = start;
-		__entry->end = end;
-		__entry->nr_migrated = nr_migrated;
-		__entry->nr_reclaimed = nr_reclaimed;
-		__entry->nr_mapped = nr_mapped;
-		__entry->alloc_flags = alloc_flags;
-	),
-
-	TP_printk("start=0x%lx end=0x%lx alloc_flags=%d nr_migrated=%lu nr_reclaimed=%lu nr_mapped=%lu",
-		  __entry->start,
-		  __entry->end,
-		  __entry->alloc_flags,
-		  __entry->nr_migrated,
-		  __entry->nr_reclaimed,
-		  __entry->nr_mapped)
-);
-#endif
-
 TRACE_EVENT(mm_setup_per_zone_wmarks,
 
 	TP_PROTO(struct zone *zone),
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 78ddf1d43c6c..a98c5d1f4336 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6694,14 +6694,9 @@ static void alloc_contig_dump_pages(struct list_head *page_list)
 	}
 }
 
-/*
- * [start, end) must belong to a single zone.
- * @alloc_flags: using acr_flags_t to filter the type of migration in
- *		trace_mm_alloc_contig_migrate_range_info.
- */
+/* [start, end) must belong to a single zone. */
 static int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					acr_flags_t alloc_flags)
+					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned int nr_reclaimed;
@@ -6713,10 +6708,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		.gfp_mask = cc->gfp_mask,
 		.reason = MR_CONTIG_RANGE,
 	};
-	struct page *page;
-	unsigned long total_mapped = 0;
-	unsigned long total_migrated = 0;
-	unsigned long total_reclaimed = 0;
 
 	lru_cache_disable();
 
@@ -6742,22 +6733,9 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 							&cc->migratepages);
 		cc->nr_migratepages -= nr_reclaimed;
 
-		if (trace_mm_alloc_contig_migrate_range_info_enabled()) {
-			total_reclaimed += nr_reclaimed;
-			list_for_each_entry(page, &cc->migratepages, lru) {
-				struct folio *folio = page_folio(page);
-
-				total_mapped += folio_mapped(folio) *
-						folio_nr_pages(folio);
-			}
-		}
-
 		ret = migrate_pages(&cc->migratepages, alloc_migration_target,
 			NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
 
-		if (trace_mm_alloc_contig_migrate_range_info_enabled() && !ret)
-			total_migrated += cc->nr_migratepages;
-
 		/*
 		 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
 		 * to retry again over this error, so do the same here.
@@ -6773,10 +6751,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		putback_movable_pages(&cc->migratepages);
 	}
 
-	trace_mm_alloc_contig_migrate_range_info(start, end, alloc_flags,
-						 total_migrated,
-						 total_reclaimed,
-						 total_mapped);
 	return (ret < 0) ? ret : 0;
 }
 
@@ -6921,7 +6895,7 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 	 * allocated.  So, if we fall through be sure to clear ret so that
 	 * -EBUSY is not accidentally used or returned to caller.
 	 */
-	ret = __alloc_contig_migrate_range(&cc, start, end, alloc_flags);
+	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret && ret != -EBUSY)
 		goto done;
 
-- 
2.47.2


