Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51446F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0CB6B00B2; Mon, 13 Apr 2026 15:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A926B00B3; Mon, 13 Apr 2026 15:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29916B00B4; Mon, 13 Apr 2026 15:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81C796B00B2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BDCE140289
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:05 +0000 (UTC)
X-FDA: 84654500490.29.6B17EDD
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012016.outbound.protection.outlook.com [52.101.48.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 308841C0005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F6SCRSL3;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajPHYunhj8kAl/FupGqxvgNKDNEGgO8NKtECuhF5psw=;
	b=3+P2v5xoyukJxBzVOVa64nuWYj/iSUOuS4pNheCurNuzadnydQArLiIAEdUc5b8nzANiq7
	ZYEovvbwVv7SUVZwDKVNVPqmMsor1QHMA+a2cUMin20Q3q40UuZDdGdqlDGazJ9z6nBcqO
	8je6XKoXdM0dmfSMwEm/uyoTvidc+0g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=F6SCRSL3;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108062; a=rsa-sha256;
	cv=pass;
	b=PB8KrZ0MOmQwZ9AQ/FWyYW42wuQGTVZIIxbrNMUaonU/Er7x4vJTJJiWabgOnevj+PWn8O
	NAN0SoQ4uNFJcwBSLGPjl29mPmsbl4W+VlzrvWkiUZMVeFGjjVSRMq35LVY9hw/RyyLJjm
	BkWPZAE+rCJX7htA0V/A9cYHGdPMLO8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=voNZrfbMb7E49NQKOoROtHdZtDK2ffkq5yagGFNUaG0NUoLHcgIsnT4h4l7AgQiiBfJiy3cwix4SqvbXx72CxpJpww6g64ANp9Rb/YAe8EGoT8/jxJtMaKYd7e9qUfj/B2+WMsazgpboytowaV57Zvixd3yqyw/Yrg+UQkz4N72kbU1KESyVjfn/a0ptF8uQKED/gisWbZ29wOx1s+DTV6C4V3lzIvdx4hojxDFsnwpDhDHiKejZWDoYWpNv8F9XMNtsXVa3Yb0Uq1CLnFifYYZ00aHSDV7/sXSDGefk8zlBoTK0K65sMosvb8Hg8AbrTY5UNwmZlVPSCDg6FIcwNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajPHYunhj8kAl/FupGqxvgNKDNEGgO8NKtECuhF5psw=;
 b=CUBciNYdYw+l+zpMs5hr7yPjfT4zwnsqsrzCNWdgxN2/5AIBh8UWusg4SeRBB0Lmv/io47kYbGnvBplhwClFY0L6/YJqgdWT+2UeL+9dIzPTLh4uI+uYMMktOzM4eRg17qo156fNPQJxsnBSbSUG2VdfrOFfqPoI+ukBwP4wfVzPcDLCSCQUdtvfKRR4U/sysJqrIR7rjxhLPOCGHbRBOsGBSeeUdQkiP1YY9y9Z4k2W1xBYR/daiYAYk1F1b9sHXf9KhstWIZ4C66RQJ9Hqo8LszMYbm7TOvv3kXp8nb8e7Mabl5uEV4RqR3M4RKwtPWnFwTJqRLPimGbc0GjzQxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ajPHYunhj8kAl/FupGqxvgNKDNEGgO8NKtECuhF5psw=;
 b=F6SCRSL3rdKmJKC7RLM31fJCh7RwvfjG+YdBliuUNAAdquqC3BgQrGgsqfFTDxckWAG0y8Zv9S9ibValdDej2RA+JfOw/xxkP+7MVx8JLjwJRdfcpzrq+pQu0+3mXREMlOpw2Osw/+HcSPa1STVscCCXHz4uFq+TCEXgMDpuWwio77Cb62QOqjB7UlfZfk4SDfGrh6Xa46D6nX/+ectNKonhddBoCChuZ3mKUlQDwqOaUtJqwP+Z3d2/xdqzitgKJRbhjt1CDPc1LNsMRYG9jptsviOYPs+TPixskockhPP/ag9Rilz09+GXkpbH3Plb6YdSL3dePb69rUNVRtD4LQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:46 +0000
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
Subject: [PATCH 7.2 v2 04/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Mon, 13 Apr 2026 15:20:22 -0400
Message-ID: <20260413192030.3275825-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0064.namprd20.prod.outlook.com
 (2603:10b6:208:235::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 53a74138-536a-47d7-f090-08de9991c2ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	cPlp+ICnVLzyav2I3ZYKI37zOIlJ4u4fIdIt+/JeekuRQHQ/zvQqqEdnqE3YjjDtLozPf6o58WYQCvL7CFRrhSD4kEE4/HzA+YCSukv4ErnDFFv9NxjYGToRnypwPuL/xXg2KTLufvixQ1RAJZ75W3SgJvwkg8/tJuJeqRU0q8OeuittLu/9Q3qfFETff56fma6A30DpNoGCrBkH5tyMLG8RwMFJm615K1UJLodVcJLP8kcinkyv2hKGe8sbMeeql11dV0qAGe4vNzzV850Is7whquq9HbhNzY7Z9YlC1ZzrVXJ7lC6JQGR4exRLoUoxR3P2r+wmrAmGB7O26hC1FY/TKTM6vM3TcGxmM9pztvCZtaQ79cMsMR/pDZKkU8IfAhquq5yCSNJw18eC8p31s1cIdo5leUsj8KXP5YcJh1iop7roQa7NsFH3BF4V7dhESEdGH1Ug8wrxj2AXlPlg9a7WhT57hHpjZjfXrsYJy/ToNroib3w+ozHBI+hogY+rHHTpm8oNg/NMHLO4cEhtpPtk5lMkH0bwrUm6HL2Z9aJ+B0LjBvb0hZT1GSCNU24JRLOSpdRdBcUS8QSdZlsUncLZDc9SNAOqyHD6n8uGbQtUp563cB3krD60rHwVAQMUfISzF+54eDuGxiHTfJWwwUHWbFe4wzWptza492VhIv71+uojYatresbSe+voktKWy0PsVjOYs/XL8gf5xCbBn4XdiXvqmEABImUmHRHYLCo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ooDnSDjGAH+dEnGQCaLuo7sbWIE2B57ZW5U5aMpIxja8Ldx55QfZ6I77/ws9?=
 =?us-ascii?Q?Wge59xryrCZrLoM3brf/yI/OXV8sXoz1gMzUrBBncCPDvPJvNuVRSP6ri+62?=
 =?us-ascii?Q?7vZh5CJDkB7Vni07wZD0917MVHcAGNjMRcnAwINkversPmBbvHbkbHFlgtit?=
 =?us-ascii?Q?2j9N6yHsRaVXPEXvMU3Dw+NHOb/EXNEuHznVt1bb98KP+Hm5aMPkP40qyADR?=
 =?us-ascii?Q?8QWnH+XCTWhaWTXR6p2OUp8NoqPl57owmz3YL+Itp6ndLjFg/ehw/axljm57?=
 =?us-ascii?Q?DSMUsxCwBHDPXC7VBSswcgwWEZxDfHWj0WAwM1uC2qT49koOywpHRYcn4X3l?=
 =?us-ascii?Q?IPP6keSRr7bM/J6bA60BMoNq6BeREH4kV1SDfCDYdWOd1iqBv97vsvNmzWnp?=
 =?us-ascii?Q?f6C9jojbwFXIiOPacR9cjhMYZe1UU9oCm9lWg77w2xVVUqpkkRJeq7Abt5IC?=
 =?us-ascii?Q?9Wsg/i5cyyV5YdYMZtUYoEBDgWUevdZRQkawIMPUz4CsEHyfLJvTYv9KpF+R?=
 =?us-ascii?Q?cJXgiCcF3J+yAPcTSU0HBwzedkkUI2Ad5K+Tiy8Nc+V8KsW0P59kJ4Wj7kP/?=
 =?us-ascii?Q?lnutnbFH7xAygNOovkpdPMu11k2mJ4M92MiB6yf+VTKGBgbXM/Bi24ntSrBw?=
 =?us-ascii?Q?XbD9xutNMsoHXB47FyVAvt7dEU8muKl/l9XudyihicRDG9GP8MvXrtsGbUfV?=
 =?us-ascii?Q?+fY59NEZIpf4YOJkByXRiSUI/jt7otyOZ8ZPNYJsX+t95jmPdKm7jd6FYYMk?=
 =?us-ascii?Q?OGvPiTNyvX9knx2/aTSyoEcCbxXq0GCQ5FaH5mv+/5BVV9PZQs8zEB37ixJq?=
 =?us-ascii?Q?EgQHF38R71rstTxqQN7qD2ybgRDH15g0ZpX7b6OZtkmPmyBbSlyUQqIULLfI?=
 =?us-ascii?Q?JT5+/Klzp26dko2ztE1AEj+uTxviJMifDpa3WX+Qb0g8TzBFWMNMbkHk/4mZ?=
 =?us-ascii?Q?FEzgLjKCWbpu6/K7wtICNGX1a9xqPpH+8FWURzeZCJ5wPIQ80fFMewgo/xB1?=
 =?us-ascii?Q?Hs5SsFy/DOl2MreftVUe4DY9FIPFwwuXjG6fFbgrfUkEPQTTOYdNe7SKfRYX?=
 =?us-ascii?Q?GD8uF0+5oleYR6YN2U/pFKXi3ehiXLubsQUFr12Yb5SPeG5DD+89TSFk6XQQ?=
 =?us-ascii?Q?qCqk7kdrGPkXwAxFGS/M1YGtTKB2SS4XrfLLDm9dI+QAwDOW1+d/Op4JobLC?=
 =?us-ascii?Q?gMS+OmSBGdFiMqZBjaPB6EaXsh8UD8D0JGm4QYXp/HIIz9kNj0tC3QB5zFJ5?=
 =?us-ascii?Q?bw3tVdK0wm11BEIh2f0BEPjBqdHzgDEB+b9Ab6oeS17/RjoMcwLhoOZ9mLtB?=
 =?us-ascii?Q?0b4Q58/USFI1ZOgvfpn3GDizc/FsGKvdj4ELr3laKQYulgPy5Wk+0mFOo3me?=
 =?us-ascii?Q?DoqLqlZag424L2je2F0+JK4hnL+u8k07GzZWEi5wOMo7Er8QgKfDWzwRemXq?=
 =?us-ascii?Q?cpYzqfwGy2o++a3J7VGi2bTPlHfiH85yVLupMX62rCgi+pa4lMQK7WZqzScb?=
 =?us-ascii?Q?QY9Y8RAscqwdpOkSL9xyD/KUuJPlo1/q8pEjHWNlbpRN98gAz0tLlFk8h74L?=
 =?us-ascii?Q?oaMfuLRbUULf6isIeRBu8W+SW5FMgZ6cNvVIiGh/rCgOqCgqj4ks6rSXlsTw?=
 =?us-ascii?Q?SPBTZmixaMKd8lemlYuH/CuN6aSwIPZSpNLNGYnzVeNUWvVrenUVSskPEMEI?=
 =?us-ascii?Q?rcFM88o/IMmkqXFclIz2NbQ2tvD3HWQ6wXEbIQVKkmSj4Vam?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a74138-536a-47d7-f090-08de9991c2ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:44.9854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4r9zAqQoYrFs67MI4BZtu+DJo5V3ixqvuHHTEqgrHPC8T4zbjnkKUQK7brHI4aOY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Queue-Id: 308841C0005
X-Stat-Signature: iozhyrbp5x34a7kro658ij63cyeonfcx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776108061-700507
X-HE-Meta: U2FsdGVkX18CFF+LgcaoO8H7BKpMRQriw0eIU1268WhaJIgH1V88Y5vQrKdAasngJ931zgaCOasoUI+KdX9sWvK6zQDJx50ya4+TtCsRtGoY4lpECAOBIbSimYiTpRuBeC8jwNY4k9MJ+1xWMXEcbhQxzvMD9a25YWaixLZ4LIrMlaV5M60PE+ERTat72st3cPGwYoc/q/SmUBbBXk7znAmbCgNY1yu7/b9JRX/NnxXexqHfYqYCUi84NSnS5DyAiLFnAr9Lyuye0Crlo8j/rGBOIwkrlo9oZ9Artq65BpGth4yqLYoyfI+QtqC/de7VLoZRtQT3wBd15YdgWA+Ia1zE5ct1t06DhCPN/333EohXdiSyY3c37NTjyl2z3u2bEw3qktgIxFDELBjaRBIvykhqjSBdJto/PbImVhigWv9nCbfyDmTBDAKT02TrSeE+LSGRSqYftBxReJ5Q0lWQrAsC765E6cCbXDeHMbEc3umSRbXlWOeO4P/z/RA4Htxmsv/YWqBb1Kyeg/MRGgnLvf1y2YK9j6wz9UDX2sDUhiuDcMe7jHpgJwjPonmLrEgmZWE+9e5UUAAUyqi2pKFyn/8Dx/gOMzU9d8r/y2EFs0AjkB0iKU9gTkTLKZl+P7740H5ewa0GYfuA5rL08ofDBmNMQ4fk651lAc3JdS8yfFbe5HaT8fhvvbbL9+H1UwqStoT//ClmJj8Tg56xjI8XE2ZSmqwQrt+Dh48wuJ9jchenwSlkpWkh9xotKItfrZDUSDGcHa3wnTW9kwRjUwSqeGKa8jQQnmRwxo9W7WsSkqVHM6/YCzH5mtwlV2uy4H1TjeFuTM/h4PzX3TiIiRPkKRpwCeaiAbVBHodf4i6fu30aB3uGbpNombIf7fmb3QBFX1/O+eL1C0qXlhohUB4Cagx0b2oTFBevAl1JJmNt8v7LSA4MdKNmwDbr3u0kB4aNu09I8ZzRvc9+NNprQ3k
 cqhwXX3U
 m8wEUnd/5GIVBpnWoNnJfai9XK8+TndTvGW9ySk2AWPzkpyvn4ERggBi/VzcgaVIQgoNLm2PPgspzpfmw89gC2zTM2TfjBmiIH81bHRg1qbcYsULwmJlMLhASmddTnxcwjFz/l3WlAfGytvEKpoNljCrSIms/d5DMmWyOnsQmB8zERcZDcpPpWub3pay8sPUh5j2FtTtaqhm8Y33/PjXCBh2aB3F+XJv76Vk8EgIU3SqklCkrBLrbEHUfNL+jlrE9yPPi+5GIgON+NYEPw90CbWVkC4Uibn73/oNWH2iM4TFm7RdRO8dTMG48QbxzHOi9ZjvsmD2XPpEp5DlVymnXmD6jiCAR2fKhGFlJ8ojixv4sKVgGVPIzoc7rmKnQiPJjOB7MUoEPgOZCBsGyQGuWIK5p6ppfmRX6zETzjtJ41Q44tVi7imIf33h+W6RXDDnT1NU8fPhs7+/wHDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
mapping->nr_thps, which its safe guard mechanism relies on.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0


