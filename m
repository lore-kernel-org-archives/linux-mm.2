Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2FCC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AF36B0399; Thu, 13 Aug 2026 00:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123316B039B; Thu, 13 Aug 2026 00:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C186B039C; Thu, 13 Aug 2026 00:24:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C867E6B0399
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FA60A049D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:36 +0000 (UTC)
X-FDA: 85094954952.09.120134A
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D2B91C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NR70t14g;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595073;
	b=q6OsIVW+4vED9odq5FNo5HX4xrjdgwst+CUUMjwiyOEgfV8jo/uHBlJFwIY/Ofihu1P5xI
	SiqU7gRSUF5FNjUETp4Wye9oHxwVTgFcnhB55TI5fCpG1v/+DpG4nxJF+sHAjgOqaU4ogG
	qiS/OBdAd4NeYYHK2TkOpmso1udszgI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NR70t14g;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BykK82YDo1LySzOhloAkWorz+g6kLKF76otmIGbgpbs=;
	b=pllv0kSngpGhLR9yZQKY9DDTJWhNm5WL11hH/kezkaSlnQDN8aJxrh9gDRjnmyQx4n+ilY
	4MyUtWO8yaEyRltXeD6xelXbWAp5100Q2Z6Zakh9XEpInppGAzTzCCt3Vj7A8HpQQvVe3X
	LuLWPcf/J+wi0bZHxipGpcj1m5DGYpY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJzBA3W7lnGFclbanKQ3eo6SD+TOMdxlFqxJy91MQ2bFgAj2bg/o4aWA21N8A//+iTqOcIdQTibSpQB5hcrl/uJ41oxNQvoweO5DHBmZkp6UnYUGcNN8bidouU9hTj0YsqjN9ax2g3dGnB8lR/VCTZARLFqF6vh8aphq4xkw8B8IkCfN8TAwrcY2+Qp7A6AMY7eH/mf4DbAVozF1khAZ9o6chB9GMFhWf/nqVKXtJClmhW5/DHHIl1kcmCG0tscOMtD74CRuAgd+HqaoAddKwA4AkiV5NPmYLR9yLl3Bp6dy+7vtVwgQMroDIMaT7HugFzH5feSxI4UP/6gjZbaq5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BykK82YDo1LySzOhloAkWorz+g6kLKF76otmIGbgpbs=;
 b=lBXKDlA15AUx90wA0d4/OUxyw7t8jByRFrRWbymOwGmlPSsHCosacaww0mf0MeqjqLXcIJgJO65s9KeCwG42ZfLiOb15fBXSwsMAnrkK/lETrKOXMw+nq1AupTVgUZ0W+jFdjo13SMjfse4P3WeWBtZY9LUJ1cxgaNtfwHzZvgVpCRB2vGMX13m8eze6FK5th1AEVvXbXkqfYCmOaZcR23AmmlSPRwOwpsY8Wwsw00X53qC5+ptFjuGDqP9Uw+PiiNg70AIZv3TTucnF4luPh7hDHJktW3QO095SGKFapfJZKvVSEBSJsIbhk3VxMqGDU9keV69ihIyDi46SWv9Bng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BykK82YDo1LySzOhloAkWorz+g6kLKF76otmIGbgpbs=;
 b=NR70t14g08Lo9/L1vkIlevr11JsQjE4YmpOKSNPYot92uhJBj2g8nEnSfyGHB7FLbMDH5ibhEw8N4x5wnLTmGDd0JYEA4XiWokKE9e1MLZQRoMDPDQvVTs7hS6xI3bdzvmU3JV1yzDDNji9PKsEexSSXcTcUBvZSTTm8bK4B1+g=
Received: from BN1PR12CA0016.namprd12.prod.outlook.com (2603:10b6:408:e1::21)
 by DM4PR12MB7527.namprd12.prod.outlook.com (2603:10b6:8:111::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 04:24:24 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:e1:cafe::9b) by BN1PR12CA0016.outlook.office365.com
 (2603:10b6:408:e1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 04:24:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:24 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:16 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:14 +0000
Subject: [PATCH v2 3/7] mm/migrate: split remove_migration_pte_hugetlb()
 out of remove_migration_pte()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-3-3c5424c555c7@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=4926;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=V2Csu+W5OddYNfw1PGZXsHW/zSePcDCED8EWGpg8Wb4=;
 b=ob0iC1dS6KmO+0v44bGeBcevYeRg4ooQfD1WaJVqISFV/8ubExlf4yGL1/neik+nanQ1dT1Q9
 bR4VUZBw9kFCEfLx9QKTECvkzXmsJnXhtt8U2xfjJmui4ivE+U7skDS
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|DM4PR12MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 3988a3a8-2bac-4873-f10a-08def8f2c14e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|23010399003|1800799024|36860700016|11063799006|56012099006|10067099003|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fbU5U0QAA+4w2dZN7t/E1zRw7X/DtUtM0gOZKgWZdKIbdtjdhAAnEZxoQzzvhhT4hJar8pJg1w5oAYxqJpkp5tRLrNWiQRiB196sycyVN2xTl0GHCoXRclsvlrw4qidls9xNneb8qfiOEn2oTYRf6JKecokSbXEUDJ3UKVP4k2TepZj52gy+tgLKeLwA6C1E0HbW956v/xG0fJKreA5gC3Ya0yEWRyhERKIXli/DdVl6ZyQqSuSzg6g0CCfG6GcdQFTzoLhfQWjlkW6bZ9+Hw1ksJxMOB31zyGO1Nhsb6uF5eAll1zsB3q6nID974yR8kyXwcQ2xemk+ulxrj6o3kswkhEoSHql+zgcPBhLfxIRgXmIMeCZ6j7oSqNb7oGRkbdiX90rFy/XA89I68ovbRwDVbT7ToZE0xxiJJ4D7UfXXyxDg6lvJ7MX2Irbo2fYytpNAKKQHNb5exsrcbuPnXDJUXWnhzS5KzCwejIzEP3vKi6jEJzdSCzIlk746qWTduuV1k6QE+hPhNmFMne/xaupX31z3tSGAb55pLw6qmBJP36XCrEIIqcyO+fJgpnFbXnRuNpqyatSFqtOxjBRifwwXf5briWiwPZezRkWTb281g029oBdu6sS/hwlOx/kqDukT1SDYbF6dREYOBgLNznw8rXDzaldEkfEfQtuYzYKLdhO4+M5osfOQt90j0H6BfqjTGjn6dj0vr7bQ6AFvafAuxWemqsGqJAGcIE2vQIjQyufcpAK0XkWlJN0XOg6l
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(23010399003)(1800799024)(36860700016)(11063799006)(56012099006)(10067099003)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PcubKfli0gMysUIPmHrNnMJUNdUmltzW6KCvgXGCmuPElXOZlLaEh1ov96CpO3EspfWwbCnv1eTgk34DxRlP0VvKJRbIjmtJJWhGfr6EzX9++ayO5a2WPba0ojSWIWqFHBCoC5XFCdUmT405AJpghjwGIpLdx617kzQzEbX8jO30FxmL44lXcOXZwtysqubNZ1fWpDBlV2YYw9749ozVVaUz7Oh2RnxyCQb3DBCbtZts1JzsIQkrNrbQ3C5eHmBepII794d3zEI4apsA8wbd6SujzYfdZWWRsof93s9b0D4/ckqN/KpQFQLgMVuNvVtqVcSyHs6zv+JRqAJKFnUTqemSk5rps07yotrqTKWFLN89T4zTVkOsYC4ZuQXsebq1nv0mRSHEywJcR9m2Z+dL35kvXcxx9R1Eh43fWiuwXr8wgKiN8K1wkteFmU8cl76a
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:24.1733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3988a3a8-2bac-4873-f10a-08def8f2c14e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7527
X-Rspamd-Queue-Id: 1D2B91C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ndpdagsnedb38nzdgxqpaqrjbxb9n6tp
X-HE-Tag: 1786595072-300435
X-HE-Meta: U2FsdGVkX19/ZY26XgDxHWIQarFtclWjjoypTauQ1Sfl785C56UWc16KTiS44MWuV+ioCmMbti/z/QtPnZqf3ZFzkfXvakiO4FFICGqRluBZX+bkZ/sJaQ1jv/qjaJW2uzusuC4+epujziqCEruhSC73aRUQpYgugzjc8h60Vh763o3MxAiZlPy5VSlLi9jvpGBUnLZs8BypltcDLKchTxQfabrXTOXYXEYY9gB3ZuapdU0uFlLAR3cA9CmImbo4KSaK33Vs1KHJ4EgIMrMdqfHCoifPi6T4YwHnrOpAtANicxanlsarr7ssMIemf7K93Ueo64D2asZNYKjVmalwNu5c128TBf5WXwb7kCcC9YJW5C9aSIzr/5IyvIKIqkhrmTnYj3qneSosdd1TSUPdKWn4pCdecvsmMN0oeOscUpuCBbejcIjgL2pAmruKibd2ljoO6Q2r2632vTz0w0IEower+K+TdUuaHck3cEVwfHXtKWJBKmkp3OP9FHcIu6sVL3FeoDv6j7hWdz3zRLO/myZKuujf5/SugVGYmFIPyvIgzvx9utLhxcwDiB9xGYhd9UmWAc+zWt7Dk1H9QP1IPRA5lnPsmTGQtkGDjdgtYkUj9vlvXyKWxeN7GOqqNM8Av2idh5aal7SWjrWhvksSZxBiuD8WsBfFOy8rOQH8sKh3V4RozRsyFvI6Tl6A9S3XCzcJOCzmzETffwvJ5BfD5l0VwGZfeJ2sAflBF+b9tX5y/bylRgsYL/+IJhppUfB4zWXMGjvcr+oWvCz6chC9N5hKFI87xWVxvEo4mcgJnSZbloUT2sgE5HN0U+CJ9uqv3KYyrBHkdmcw43PigmXt1LGuK9br3iVDgiWfqiypBC94H8bI1czEFFHSyjO0Gp0g7xMrBKVU6rN78pXi57LQhacLnmN232+9vaMgXRENXlE2vtepIAloebuJ275b1JMYTWz4OgGzI4tzraCtpRD
 zxwbd0q1
 dt3dhhZlnIvMok8veDNsoIPhsPUXhti+gfop/Wakz+/gxJGDIxbXw8ViZ7zoYfQGkZCbTlOQtWwz5/Iva9vuMtllIbC0Oa3wJA1jFt7imYBUMRHD3klbAr25w5kgXbOjFfLJhr0Ulokj/kAKmhujrYmZEqxNOkprcPZk63l2JNb+VkDVEsEucCghfELLEKiKQek5lUduft+P59irfYl5KiriCsnot5RVddxOyPeGAxRCie13+lAUxqZWTAN1AUOsR1FfpjTSNOgHlywBksMwytl94rRUFTHSMwqdPY24L6cmG56Xc8d3As/BiTTJcWDhG2iUiY+W9fmwOwErMrH93Fkbt7eqUFuFHdYM6zEOTeJaetG5mHOEsHveMR7Sj+8Xs1xi6EzFO7/unyIS5/lXioM8DuGtZVOHjnfrFTucBhFTEuZcGAcQ8lXpvCX8k3I8wcMlruIu1c4ngbTZNnrFAesWKOCHLu+UQw5mC+HySTu1jpB/fXxcpXNkOc4XVMEd+oECo2EdcO5bhXVbFmKvUhtRIzClOvn1eRB+FpIzG5d0aCiJP9Nc0M+7bfv69Aw1WnBK/4OdEyCYgzSV8+EZaS4yPUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() interleaves hugetlb handling with the regular
folio path. Move it into a dedicated callback selected by
remove_migration_ptes(), leaving the generic callback focused on regular
folios ahead of PTE batching.

With hugetlb folios routed separately, simplify the PMD mapping check to
a one-time warning.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 97 +++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index a3362cc9ef66..ee1b8a55a2a4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -375,6 +375,57 @@ static pte_t migration_entry_to_pte(struct folio *folio, struct page *new,
 	return pte;
 }
 
+/*
+ * Restore a potential migration pte to a working pte entry for hugetlb folios.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+static bool remove_migration_pte_hugetlb(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	struct rmap_walk_arg *rmap_walk_arg = arg;
+	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	struct hstate *h = hstate_vma(vma);
+	unsigned int shift = huge_page_shift(h);
+	unsigned long psize = huge_page_size(h);
+	struct page *new = folio_page(folio, 0);
+	rmap_t rmap_flags = RMAP_NONE;
+	pte_t old_pte, pte;
+	softleaf_t entry;
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		return true;
+
+	old_pte = huge_ptep_get(vma->vm_mm, pvmw.address, pvmw.pte);
+	entry = softleaf_from_pte(old_pte);
+	folio_get(folio);
+	pte = migration_entry_to_pte(folio, new, entry, old_pte, vma, &rmap_flags);
+	pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+	if (folio_test_anon(folio))
+		hugetlb_add_anon_rmap(folio, vma, pvmw.address, rmap_flags);
+	else
+		hugetlb_add_file_rmap(folio);
+	set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte, psize);
+
+	if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
+		mlock_drain_local();
+
+	trace_remove_migration_pte(pvmw.address, pte_val(pte), compound_order(new));
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(vma, pvmw.address, pvmw.pte);
+	page_vma_mapped_walk_done(&pvmw);
+
+	return true;
+}
+#else
+static bool remove_migration_pte_hugetlb(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	return false;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
@@ -395,20 +446,14 @@ static bool remove_migration_pte(struct folio *folio,
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
-			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
-					!folio_test_pmd_mappable(folio), folio);
+			VM_WARN_ON_ONCE_FOLIO(!folio_test_pmd_mappable(folio), folio);
 			remove_migration_pmd(&pvmw, folio);
 			continue;
 		}
 #endif
-		if (folio_test_hugetlb(folio))
-			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
-						pvmw.pte);
-		else
-			old_pte = ptep_get(pvmw.pte);
-
+		old_pte = ptep_get(pvmw.pte);
 		entry = softleaf_from_pte(old_pte);
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+		if (folio_test_large(folio))
 			idx = softleaf_to_pfn(entry) - pvmw.pfn;
 
 		if (rmap_walk_arg->map_unused_to_zeropage &&
@@ -434,30 +479,12 @@ static bool remove_migration_pte(struct folio *folio,
 				pte = pte_swp_mkuffd(pte);
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		if (folio_test_hugetlb(folio)) {
-			struct hstate *h = hstate_vma(vma);
-			unsigned int shift = huge_page_shift(h);
-			unsigned long psize = huge_page_size(h);
-
-			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			if (folio_test_anon(folio))
-				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
-						      rmap_flags);
-			else
-				hugetlb_add_file_rmap(folio);
-			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
-					psize);
-		} else
-#endif
-		{
-			if (folio_test_anon(folio))
-				folio_add_anon_rmap_pte(folio, new, vma,
-							pvmw.address, rmap_flags);
-			else
-				folio_add_file_rmap_pte(folio, new, vma);
-			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
-		}
+		if (folio_test_anon(folio))
+			folio_add_anon_rmap_pte(folio, new, vma,
+						pvmw.address, rmap_flags);
+		else
+			folio_add_file_rmap_pte(folio, new, vma);
+		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
 			mlock_drain_local();
 
@@ -484,7 +511,9 @@ void remove_migration_ptes(struct folio *src, struct folio *dst,
 	};
 
 	struct rmap_walk_control rwc = {
-		.rmap_one = remove_migration_pte,
+		.rmap_one = folio_test_hugetlb(src) ?
+				remove_migration_pte_hugetlb :
+				remove_migration_pte,
 		.arg = &rmap_walk_arg,
 	};
 

-- 
2.43.0


