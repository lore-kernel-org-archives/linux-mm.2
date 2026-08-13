Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374D5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EFE6B039F; Thu, 13 Aug 2026 00:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6BD6B03A1; Thu, 13 Aug 2026 00:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD4E6B03A2; Thu, 13 Aug 2026 00:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCC696B039F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 717FFC0528
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:59 +0000 (UTC)
X-FDA: 85094955918.08.5D4BD2C
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by imf25.hostedemail.com (Postfix) with ESMTP id 210E3A0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="K/QNjs+E";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLhtG+vvZYDJbT9CsAbPScGVywpiDLa6N6jkmr1n5ro=;
	b=YzUHvY8/Yg0tFpl1UlVEsLRst05IImoAy2I+T60fGEFLBk3onM8oUhNrgASI9hfD7PA/12
	AQ36edDyKmjjDfMHf+Uj8DjNpV68c7a0e4fVHpVBsRALcVitjDL32BgVhsFpkAp0cDShv9
	OJWUc5W6xdThQiQnjLA6mkVSkmnzJHI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="K/QNjs+E";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595096;
	b=SV9KI59YorgQs7N874K3R1vzb2MMowo00nWcgnUnbDjwwX0J7Wh1z69YQnhXcyuuMttA88
	3HgzEsWc7yV9ZgCeo1/HXzn1EI8Dtb/pFeoT6ptFAbpefQJ8qnTpPVIVLYP77j87sb2bV2
	WGjlJ97h9yQtkPRI0x/pLdUEYnXSfmg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7tqCpyH3x0F5Mfk7FKP0m2E/1A1LkcBualBJrUXBPgjizJYkvxytl65OYEU8Ug8zEAMdsZqFycmUpaED10WEtjVLAqR0yabR6xhdoclXAQjKS4lEFv9r/CFaAMLvKammqghPFLW+ia6I3u4fLnlm/N7RDkTQdu/8vWDj29dR2ZW8423Pifu5bVsEEOCC3wvKr81YwhtL93fKmnn63BAc915Qnf62JHaIb2l6ACq/adqt2IN7ap/Qp+2O0MnystYQI0/tagZPrlM0rA4J2C9P6tUAXrLOr7Dl0aJElwhWXtzYHoKowvWcxlvk8QyBVnpBduZgGHBJ3ANBSiQcYfneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLhtG+vvZYDJbT9CsAbPScGVywpiDLa6N6jkmr1n5ro=;
 b=hC7LtduiFsoxkyj/R/snstraATyi0ORWS5BiybUhexHBMaNLC6s79X06OxRkGoAVGpc2gHm8PNqtom6B8hOo1MIYf20n8fMga7uceLGz8c+B2aMtuE8CcQwspkb/TXEtDMpms9P75E9iwrO8IVpMctjA5zzj+EijJzKyKXQykB4lWEHoU9QYR8ROlyedDs9S9H9xwreDBkLbKt8hTVVT2bNk9HBkfROLpDRS5KgyrwxiQyX6dRRXDm88xCuHH9Qu6gvxQwPcZSFX+rMdkXZCyn8uGoeZ1vX7Cngc5JtOTLgfTgf8/imj/w/Ll6UpeiSmclS/0iXCkeHJCwoK/Nh5pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLhtG+vvZYDJbT9CsAbPScGVywpiDLa6N6jkmr1n5ro=;
 b=K/QNjs+EQf429aCH00cYTALsEPDkVnwA+dNAkDQIKiOiD44Y+T87ox7yCQ2UIkOi9b1N7umkBAlvaEn2/3HnPqO3uzH9gWbMm4Tk2lU0VG9yS2EVwziFm968/ESAhd0G0tc3IPDHw5acAlNBW3Nt0maE4TW3ZO9TWM3w9HyCRPw=
Received: from BLAPR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:32b::32)
 by DM4PR12MB5793.namprd12.prod.outlook.com (2603:10b6:8:60::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Thu, 13 Aug
 2026 04:24:46 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:208:32b:cafe::3a) by BLAPR03CA0027.outlook.office365.com
 (2603:10b6:208:32b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Thu,
 13 Aug 2026 04:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:46 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:38 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:17 +0000
Subject: [PATCH v2 6/7] mm/rmap: split try_to_migrate_hugetlb_one() out of
 try_to_migrate_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-6-3c5424c555c7@amd.com>
References: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
In-Reply-To: <20260813-migrate-rmap-batch-v2-0-3c5424c555c7@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=12600;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=m9fxe8wNgOIOvVrgEOQTh0iQGBrzrGsGDvtG1c3clfU=;
 b=p3GireR7fAOwvnRrM4DGa/qYHpMuykBdEo/ivlYvvzohzomDceknvYqKSUj8yKBwOz0DgoaA/
 P2nI34rQEtNCHPta3YEkDQFKUWeb4PyoYVJdvdDibwtWzCWyxILZeiG
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|DM4PR12MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e72defc-749b-4998-35c4-08def8f2ce52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|36860700016|376014|1800799024|82310400026|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	T+HwzmffNXQ+ganm2tF3sjOUVSe02OW3tR1lcqU9rSLBdpXp66ysY09qfIk89LlYYRo6haWmTeCKgAdLC+jFzaAmkLNScTxoCB0hrJrXxzDHw/zj9xL/cwyAGWIvAgjXfFM9DTKGsqbOORjfJTvj7nOn4VTr4zYURbQklLKbiOxjLFlKJWngKShyKoKUugUemtSXhYui/4n5hhc3r1Zv+xWcdK9xOleu3yxK8Tfy3CUjaPULdA7T+AlKuC/huGgQVcflPqk9izeDCdOhEe3idBdOn/qeUCvJEbbpoKYqxx4bwDBBjEanIw5LqmylyZaPhsE21r7tKrIezqUnRHSweFt+eiIokLvRv4ZDsrslSMflT/cJQV+NTpqUyjxWTg9MoNdt/N8rlE3H/SEfQYLQdTQpJLeSdTE5uKUllepshEVdIo602VZMwwu1GKaJ0S/prS3Ieh3XQ0T0Y/UfNu7k2txl95ryD3Wylkk9dSnaVNgXZ8HKSVN1F2urfNehFa0rsySGX/gH23mmgMLR/nDWaPBzRuQC7Ws5MQHOGP1tRgdHBR/Fg2zeFZx7xzYCq+2UBcY1UBe0a2rLpaqTZF+IDxq/Qauj08XWeskg9UI6YdE4XwGa5Q2nT5xE7dHMGMmrF28Y3bVdHuxeVoctmRbKbAYX6Q38T85Hr//EsiNEjqRF+LlbI7fMWkEvb1b8A69zwrpmzGosLYVBHSOCvThijdj7pzCTtdMoP8UuOLRpdvqeFsOXAUMzWYAWQ+1WvI/q
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4KZ1dK74jyOyg7+ZCk90PHmDXdGvH2vTfhX/4EqTBJ34/Fvil9mWBbL4oXOXbjBkF079bNn/0eFqJN2Ry3BmA06pi/8mDUm19w6AekkABTElL3irL/PUG/hfHwg0OAoRQKnsxUqlrLXU/n1EYXfbeswcnTzq258QGBGJZk8ec28rLSbPr6wd3v7j/apCkap68UgJy4uQm78R6l3DC0u23Jh7bBbGhz1ubfLGK2UN8NlbdEAVJouxWtyJ9cr2DzOURcEGLUewDjctDlrwKIUKoDQ+1Z+BTV8wnL4wSaW9fe/ETHVSEvmyBSAWS+mQROWKdJ7ox4i0CWXbyB9ZY1/fNeDhR+f79frav0t+9xwV4RZvTv8+kQECaCii15uIuHXI9ICgst2QBUA3Gj8BNsNj7yzrVGkGqdcsiAkWA3W0R31YMHakYZL91N1XL/77UZDw
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:46.0031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e72defc-749b-4998-35c4-08def8f2ce52
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5793
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 210E3A0004
X-Stat-Signature: h5zxxh1ok4erwz5si38ptjtyxoca6row
X-Rspam-User: 
X-HE-Tag: 1786595095-729187
X-HE-Meta: U2FsdGVkX1/idBI84do/29vLcew8L/tA+zkq3CcYUHQhuYQoUv+f7XJ6aTQ9mb9m3xRljUII8B8kPmLmLJuN2iZsYgKkJGcFWDXFaly5JZcyMwJmuUpMAWO6hD2xA4WRxlRROcwYEm8XOrW7bfqju8DHibOLXXTrcmkJQS8ZdRniDwp974lp1Nd3Z8Y8f7xvcEWQLf0rAgC/ZUGJh5AKDRyguh5p5cnacoq2vM9QJceWbsR+ThUk9bJu7vHR4YL38Bvu0iWqfCUJ82RXViismzhVPCA9C4GZZ6wMSbm4LtoPaXXP7LlmaTvl8BWIgEX6PM/FMg6pJf0K5UL9GKu6v5dKmBXgyv3DEJHK2+QMTLeaTm8HryIhCHOOwnOB9lDdRwxL/P9GS8jNHgLybhnxczMjdCodFt5fruQ25RdEPGLoLOtCe/1bsXOesz+Kb6D1MjeXmTtMVSNprES6qFETBmV9d/d6MsPBXShLGqf+LAWkgFX9LPlHpXd8Hh9JcKaF3qiZ+U1wq89qPDqeuRNObg5CDwse8/zNigFamdLRoez6iwDA8TYliaCDGtx4Canc1vflrHbZZtDA3FAD3QaZ9cFJTTKG5fPjgIJ0alijYbt2fQSKyaLZWpQ+i7O3z1CaDfWHUIokjdk3Se1KSnpYiXjOgTPlbHzFnF2oqSKIK4a0KcNa/hpUOtH5RTTnu9XdtkqKEpGWo6MmFlQxFnXTapNa5qoS+EBVg4gw5TZHXlurSBm8fxJCCEAF2nth4hyEsi8WKGH6vlAQ39c3gIcYXmwMav+DyfPYqUwLji69dOWUEAJi1fvwBpH+803LB4g/Jl5Kh9RhVNq5bPjbcDyY9xXxZL9oNfjoZumfZSWJBsYHV3RmClOU1t1zOxBcrUOrQS/NzEvU9JTVLSBl/2f6XlcvnaCQMwPcp3bC9cMXgw8faJ5XpwOXmGlsmZCMcH5Qfg+DKr27M5Qg6qYtKP6
 U26Vkpq4
 0K1c5R0Rvs29nDYlil1KpLuuN5dnDdThGo/HZu33b3f6UuuLMyXKkeKmtIJHNLBdnAPZAuU5aNH0CEK5zTnnFM5St25h893QWLd8NpV1FRcwQuFH+rxpvzgUcF03Gqw+3XSYMvACZ+X3JYBxeSNzCfVtkQs3mAZ29qpZIx5Zq6QQ67krzmb5EprfElRazw8L8kry12Htt4V48+j5xGlO9Nw3j02vRIj28/Ne9llVqeuaoq7Bp2lVkVJoJmZKWF+4c3Lp7QqHZZwLM03/X9F+m+e/W1mlwR+s3KWY+56bEGNXy4qWxGIfCtTM3kMERJGx0eFZTf2ZbHYw7AQH+xkwRV/P5xrLAFz/HmHQrjSdrx4K4vzBA7Hnll9BJj6DLEvhLS5D9l20KrrjQNlDogIGfIv4B2A56g3gPKm91AUjTnOsrblBZ36+L6iAsdWwQHLr2YSYB1kNCbOm6A0LQfagK+26wmVKfcxiWMD1gf2EI8b2slOxIhHSqQn1tpxuasCncTypz5EbJ8fukw4J2qqtD3/vHHVDl8sEaPDrcAGuDubuh1DUurRmjQs9lYGo3ZDMpntW2wKO1SOjTR7Hleivyq44fGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() interleaves hugetlb special handling through the
regular PTE/PMD migration path with folio_test_hugetlb() checks
scattered across the walk. Simplify this by moving hugetlb handling
into its own rmap_one callback, try_to_migrate_hugetlb_one().

Few minor changes:
- Since hugetlb uses separate counters, update_hiwater_rss() is not
needed for hugetlb path. Also, use huge_pte_dirty instead of pte_dirty
- No PVMW_SYNC flag is needed for hugetlb
- hugetlb folio has single mapping per VMA, so no loop is needed.
- Convert VM_BUG_ON to VM_WARN_ON_ONCE and not use irrelevant WARN check.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 251 +++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 144 insertions(+), 107 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 8b89e32ae489..35752a70f3a0 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2543,6 +2543,138 @@ static pte_t make_migration_pte(struct page *page, pte_t pteval,
 	return swp_pte;
 }
 
+/*
+ * Replace the hugetlb page table mapping for folio with migration entries.
+ *
+ * @arg: enum ttu_flags will be passed to this argument.
+ */
+static bool try_to_migrate_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	const unsigned long hsz = huge_page_size(hstate_vma(vma));
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	bool anon_exclusive, writable, ret = true;
+	bool anon = folio_test_anon(folio);
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	unsigned long pfn;
+	struct page *page;
+	pte_t pteval;
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	/* If sharing is possible, start and end will be adjusted accordingly. */
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	address = pvmw.address;
+	pteval = huge_ptep_get(mm, address, pvmw.pte);
+	if (likely(pte_present(pteval)))
+		pfn = pte_pfn(pteval);
+	else
+		pfn = softleaf_to_pfn(softleaf_from_pte(pteval));
+
+	page = folio_page(folio, pfn - folio_pfn(folio));
+	anon_exclusive = anon && PageAnonExclusive(page);
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must flush
+	 * them all. start/end were already adjusted above to cover this range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
+	 * Caller needs to explicitly do this outside rmap routines. We also must
+	 * hold hugetlb vma_lock in write mode. Lock order dictates acquiring
+	 * vma_lock BEFORE i_mmap_rwsem. We can only try lock here and fail if
+	 * unsuccessful.
+	 */
+	if (!anon) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON_ONCE(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			ret = false;
+			goto walk_done;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped,
+			 * consequently unmapping the folio.
+			 */
+			goto walk_done;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+
+	/* Nuke the hugetlb page table entry */
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+	writable = pte_write(pteval);
+
+	VM_WARN_ON_FOLIO(writable && anon && !anon_exclusive, folio);
+
+	if (PageHWPoison(page)) {
+		pteval = swp_entry_to_pte(make_hwpoison_entry(page));
+		hugetlb_count_sub(folio_nr_pages(folio), mm);
+		set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+	} else {
+		pte_t swp_pte;
+
+		/*
+		 * arch_unmap_one() is expected to be a NOP on architectures
+		 * where we could have PFN swap PTEs, so we'll not check/care.
+		 */
+		if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+			set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+			ret = false;
+			goto walk_done;
+		}
+
+		/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+		if (anon_exclusive && hugetlb_try_share_anon_rmap(folio)) {
+			set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+			ret = false;
+			goto walk_done;
+		}
+
+		/*
+		 * Store the pfn of the page in a special migration pte. A
+		 * hugetlb fault waits for migration to complete before retrying.
+		 */
+		swp_pte = make_migration_pte(page, pteval, writable, anon_exclusive);
+		set_huge_pte_at(mm, address, pvmw.pte, swp_pte, hsz);
+		trace_set_migration_pte(address, pte_val(swp_pte),
+					folio_order(folio));
+	}
+
+	hugetlb_remove_rmap(folio);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put(folio);
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2560,7 +2692,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2573,26 +2704,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the page can not be free in this function as call of
-	 * try_to_unmap() must hold a reference on the page.
+	 * try_to_migrate() must hold a reference on the page.
 	 */
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
-	if (folio_test_hugetlb(folio)) {
-		/*
-		 * If sharing is possible, start and end will be adjusted
-		 * accordingly.
-		 */
-		adjust_range_if_pmd_sharing_possible(vma, &range.start,
-						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
-	}
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -2639,10 +2757,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio))
-			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		else
-			pteval = ptep_get(pvmw.pte);
+		pteval = ptep_get(pvmw.pte);
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
@@ -2653,66 +2768,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
-
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and
-			 * fail if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma)) {
-					page_vma_mapped_walk_done(&pvmw);
-					ret = false;
-					break;
-				}
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			/* Nuke the hugetlb page table entry */
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
-			writable = pte_write(pteval);
-		} else if (likely(pte_present(pteval))) {
+		if (likely(pte_present(pteval))) {
 			flush_cache_page(vma, address, pfn);
 			/* Nuke the page table entry. */
 			if (should_defer_flush(mm, flags)) {
@@ -2751,14 +2813,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
 
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
-			if (folio_test_hugetlb(folio)) {
-				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
-			} else {
-				dec_mm_counter(mm, mm_counter(folio));
-				set_pte_at(mm, address, pvmw.pte, pteval);
-			}
+			dec_mm_counter(mm, mm_counter(folio));
+			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
 			   !userfaultfd_armed(vma)) {
 			/*
@@ -2781,28 +2837,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				if (folio_test_hugetlb(folio))
-					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
-				else
-					set_pte_at(mm, address, pvmw.pte, pteval);
+				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
 
 			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
-			if (folio_test_hugetlb(folio)) {
-				if (anon_exclusive &&
-				    hugetlb_try_share_anon_rmap(folio)) {
-					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
-					ret = false;
-					page_vma_mapped_walk_done(&pvmw);
-					break;
-				}
-			} else if (anon_exclusive &&
-				   folio_try_share_anon_rmap_pte(folio, subpage)) {
+			if (anon_exclusive &&
+			    folio_try_share_anon_rmap_pte(folio, subpage)) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
@@ -2816,11 +2859,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			swp_pte = make_migration_pte(subpage, pteval,
 						     writable, anon_exclusive);
-			if (folio_test_hugetlb(folio))
-				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
-						hsz);
-			else
-				set_pte_at(mm, address, pvmw.pte, swp_pte);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						folio_order(folio));
 			/*
@@ -2829,10 +2868,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 		}
 
-		if (unlikely(folio_test_hugetlb(folio)))
-			hugetlb_remove_rmap(folio);
-		else
-			folio_remove_rmap_pte(folio, subpage, vma);
+		folio_remove_rmap_pte(folio, subpage, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put(folio);
@@ -2854,7 +2890,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_migrate_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_migrate_hugetlb_one : try_to_migrate_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,

-- 
2.43.0


