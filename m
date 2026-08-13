Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D11C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF446B039B; Thu, 13 Aug 2026 00:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F1C6B039D; Thu, 13 Aug 2026 00:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5E66B039E; Thu, 13 Aug 2026 00:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21DAA6B039B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:24:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B9F1C03DD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:44 +0000 (UTC)
X-FDA: 85094955288.01.3D375EE
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012071.outbound.protection.outlook.com [52.101.43.71])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6BC5DC0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mgtyu5hi;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.71 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHFPS0BbpCM1EliPslOE50oMu9h6cy1rk2aOZUavTtQ=;
	b=hj8yisFx4K5qFoUqi1+4PM+LrhJFEaF5XN+c2nV9H3h5fFvwXv0nKRyqvsAHjGvDQG6rLf
	xkaTItZqpQbT7mqbMeiM36hpOz2uHpDsYcDPKhYP3LvImHowrPPa+wjmwbGJZDu57qIm0s
	pxuX1W+E3JG9061JnOgeNJBZY2LmuQQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=mgtyu5hi;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.71 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595081;
	b=3NkIL9s4tuICFQR5l9LcDQOUFDLfhYCvroVkdf1EsJx8zW6VgvE8/5kRVVgGjFUUfGMTAj
	TThXZx4qTnmfcThQZiimqRvPf0al2yPv++vSNpH7z5rwkECpiRpIzVrl1rOPjLLjjx93Va
	JzEIJCmbfkAUEU2mu+swP1tXsWh7HYc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0KdEyMkBZxy6uhQ5DvR3l6Hua7EjBzU0aUj1WZOymIkbjkshEkkClxrvhoefLKFAluKnMkNLpSaEB2QpDcb6w/1x3VClhnX2eQgXGzATOuaVg8XmJtRtXdhDyhkqc4Dg5xPzXnoaPlAwicVJ3/u5TKJuiz0u5n5ohO5+nNdlvGXtHSJDNwwXQ1dXNYOB/k4H5/qlLIEiVTQAtSU+P1gN7TS5F+4RzJSHRDD6Q/DBS8b52ZUvROhgZJn7f/GuqCUvW6fQDQ0XIYk5EMKFQTvZ5ruIvI0p2AnoR6yf6yK4WvpWKlOS/PyOgjFdLuHyBZrvGl7zbU0uxO6W/gCyewKxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHFPS0BbpCM1EliPslOE50oMu9h6cy1rk2aOZUavTtQ=;
 b=Vv0nuf4vYGs3clmBCOjy2tJckdxCfmDmH1xalxjjlDy9gKU+OHkuoSNg08AJZ/xA3TuL5LDVo4ZC0Hx4AMel5yerPq7sQTFHwdiO2Mt9fB7lrhra/ZRCkwS2PUb0ZENopV2xcgXparabGwj2Ep1I6JycHr6A74W1YDPbnI99CjFko2QNlrm2+n0rvt6a+fd8SsVagFOS0qH8gBRE29K4MxJvHabqNd9gRIWnINO4Slz8hgjfNg/wn01cDuX7y8zXULZ7Xj3FZxzZgMFflSq3c/8RwLTPFKH8X5D2KZ8WgV6eQTQ+3aLyLhBRf6i7BNX8XOZiWHix4cV6+Cqz2Ciq9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHFPS0BbpCM1EliPslOE50oMu9h6cy1rk2aOZUavTtQ=;
 b=mgtyu5hidZ1uDPbzfJwhQSe9Za1pr6bU1S3+sm3pOkgDs2S9E3Vhzk9gs2AIdvJl6M3hugXX6qU1lwM9GlJDaQPlxOAj8LbDJ33wNgjkKwaR/dzQstvXuPOCtJ9LXuP6nX8KcVIw5wJE1gDx69aVP3ldh0TkBXtZzHKJs/6MXUI=
Received: from BN1PR12CA0016.namprd12.prod.outlook.com (2603:10b6:408:e1::21)
 by SJ2PR12MB8955.namprd12.prod.outlook.com (2603:10b6:a03:542::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 04:24:36 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:408:e1:cafe::52) by BN1PR12CA0016.outlook.office365.com
 (2603:10b6:408:e1::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 04:24:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:36 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:23 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:15 +0000
Subject: [PATCH v2 4/7] mm/migrate: batch the restore-side migration rmap
 walk
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-4-3c5424c555c7@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=4209;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=CaibqPtud+q20PIvSXd24MCW+xkI5GLqHzjtkAhhKHg=;
 b=HSLbcAu245mLxUSh34KgnA1wKwGyRR3aBV9cZ5M+p5haVS/zrnL9dnmwLzOkKLtaU2smzjb7f
 u0H2vnxKDaTDgfHkbrA3AIgxjprJ9ujPCAievc0VbYTq6mKBPU52Nby
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|SJ2PR12MB8955:EE_
X-MS-Office365-Filtering-Correlation-Id: e32a0393-74c6-47df-24f2-08def8f2c880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|23010399003|36860700016|22082099003|18002099003|56012099006|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	2AfzihJeHq1y4ktrgLMe33BZXFdudprg/SrKL6z2G+vKJVWMBMdmqnZ2a3E1BuYKhUjEL2VcwV+bDpY7OyAvmu9DKymlVKV+pQkSZM6cyZS3UM5f+r+IWsc0FwfNxUrAOABMRVmcz+WJaDbARNcPpyEGrrzEoEkit6vcEQMFPKsJpbRQjf5kQtE1qs789BqqIrcVSphTzocgSKu/NMzzucEQPknoDmmhhoFrkaNuMBXRjou3odbomnkAGvC8bS1K+2Pbw4bazZqqCUnUNxoHs/NnENE9qKndF4JR1h8eDwqDyBx06JIpgh2zxpTap/d+i/7BUdauAJGUgLb/imQ4OLpX+KaoW5u/M7hToTJwEJEKB+cSJTb+qdIMOzYUkpbBod778jl+C+0NrsE8zUcwZ1S+p/SaapRn59pOEWeOWNP9nIHJLrlbfsqPFU1KAcj5XHplmKnfbC+x34ffxdLvGivCOuNoqQpFt2ua4aUOlE52SeZWosQPyTwH/3NpnpfOsdym7G4k+GeKfIWPyGNPjq+gs6suLDaDr6BLLL+mbFSfq9OhTDcBwLvOyz5fgypFKKaxl61QpJ19GuL4AEOxtkEyqpxMXs+Z0bpTouqF2fD2IgrW2Fx1Scoy9xtf/94wRZke8mYJBgB5Xc4Y/JWUCrCFpOrGYt6xS1MuzbvJvJCABitGbepUiGuhMgPkxLVYN1GYqWa4VJ3WcONxEu6xn4Jgg9Ps77MobiohUkEsKdSW+QqjuCY+/ZBodVqwnPG5
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Vt/q5OQhKgiG88HF4JziofN1L0Zh7YHs7xq7iW6Aq8c8p7ZVnJ95gtnE5BxXlQywJunk5vKw8XZI4AQL3R3xKoqHfPA3jmDr8day+AifFq3RZng61VAIyEzD2t/NEOqAWrEeJQdQcQWGpXk5AYh0K7imlACm6kJuSUnQLpACTv13Gusc6jshy/Aye/8MQ0Ya8PA4aCZBQIc01i3ObISaqXsQG86KbMX26jHBVevuPIrHUGxnV1VZ41DvOaI9c3R1PAgLrurc5eW1QnGxeFNYEHQHU3N5j/+o/+XTX+r1egS6Bcpf6WDLD5YfPdqw2nvwCHxiufRYUishRMbvbc6ER6hMpyd+8UNVzmtvB2XVzFgAF31+wkqe0bXLA3h04anBKQ6RC2XgiOSFyu7aKnu/DTv1SBcRaJ1QO3Fc36WC1H5AV8gZusArMRA4hivFpnDP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:36.2386
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e32a0393-74c6-47df-24f2-08def8f2c880
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8955
X-Stat-Signature: h6cm3ay67xkf7xrr5wfyfuzao3xbuszd
X-Rspamd-Queue-Id: 6BC5DC0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786595081-328948
X-HE-Meta: U2FsdGVkX19/kTuXFwqfczPEN5gKjtGj95pLqBRUfQGXhivXIRJkyFj/2aMUsmr/zdrCJDdElH35Z8LOiNnTUlXYU8iApFqv7wz1qLDdI63zCGH3o2j2Q5yHHslPjGI/7MHd2Xm9CpEoPEiNqo7UOzsH1qhx2jf3YGZHh/2mL7MB+P92/hcJd8hKn2hKEbXF/r0AP8QDjLSIQHAu/eSvc1jpkXTYTfkK9ckm499hyU3P3PnifAJu5kpOS6j6jABtkbNA9lY2GJ5IszOYI0QngTvJkEtC4yuVBZCMr96B9aZd+5d0nN10xQmCgspmS2WooLOTVxqeqAAAfyCopqh6qfY6cLOAz8D29Yk0SzgnAKGF/jjSt/CmN+xLLemPUAyFoMAh+9qLGTu5K1V0vR+jn1i8IqjwRpCy9N4tAHm8ukjnGjimeFKKo9JDnjRoYwsxyaYZiauy/pNipwu+2aA6TVX2j15lwjn61Xv+BiKY0Jm/kDwVTnxH9Mt4/aJiw2FUdcOAferxadYVkU0EDukwEAafQv+al+WE8sH6OOzE8yEx/ED6RovuXBoL4wO+8hZr8KZWbZ2hsq8yFVKatKfQqJZINk0UqKMP3jxNUfJ8hi1Tr86ymAQs6RvoKEaxvLSss1Ps5kYsc/5cU/nPdMEkX4dQSHAS5DrUUiQe2LCRBszS9kyie1+xxDR4PczI6MuSl3EpMR87xg1euZbedsGhdq6i+m1qDMF+ueuQEs0+PmcaHATSMnVf9KpEseLtuXKAKs3T83brNdf3jHo3kgpb07rpTFjRzkoUxwH1gtknISi8RWhAGddcrMXUL3Ysn92xzUSlSw0rwo+Fah8W5DHNrcWYw0ifBXI2upsTVX5KAFrSyWqjgFqoL/l9tbVcX/PjrfB1+FWKXtQOmoNKDF2RSirhTWM96/tUaioOlattLGjUO4CRGhMRa1egr5NcvzVl9YsjkUJQZKDw/55XVwF
 /d0EOA1K
 A/Q+5YHSznCU6yGGENusiDMGryCInuLHOkZEkELXPulzkUM0DkrrkiOpKTI4uz4AyNvJcwuPk+NaTKXqrvUl/qjNMeT230UMpEvxftWV/hFh/S/8PdJvO57O50g2qgRRFFCcCu4WRerUxZ4HBtCsmFCOED8BUjOa1p6GZGm4IRNF1Sig74trrMpgZERJqQmWGXBV8MTYXpah/V3yfMIj3ZynSQjUZmEv/ToWJxHmeNan2QQ8P79K51w7TxXqYRqA2Hi7SSBtUu737jxq/7+YW6x01AEsW5GN6jBuEdWm4//Rah3Em5bFvqOL4f4hsUaf80wDesqvY3T36UwOGtZ3VxsimGMX0nYMS/OdyWe7C7yCr9aqPq73qDfrQ22QJTQB5v9Pcv2MQRw2bAwIGeNRinoJ8OwzU5GtdwhoXm0VM1i13o5HcIMdf7xTn0yWLVMoebJUX6c9r89o122OzqtW0asUGrgL7w2/rQoHFVgmb2GCNv8lJ25rzswGlqVqVRhz1eHPt1Q+BQoRaeZ80lR147f4dqOFm27EAMiK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() restores migration entries one PTE at a time. For
a PTE-mapped large folio, it repeats calls to building the PTE, add rmap,
set_pte_at() and page_vma_mapped_walk() per base page (256 times for
a 1M folio).

Add migration_pte_batch() to detect batch of contiguous migration entries
that map consecutive subpages, and have identical PTE bits.

While at it, use folio_is_device_private() instead of
is_device_private_page().

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ee1b8a55a2a4..aad555453469 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -345,6 +345,28 @@ struct rmap_walk_arg {
 	bool map_unused_to_zeropage;
 };
 
+/*
+ * Detect a batch of contiguous migration entries: consecutive (non-present) PTEs
+ * containing migration entries with consecutive offsets and matching pte bits.
+ */
+static unsigned int migration_pte_batch(struct page_vma_mapped_walk *pvmw,
+		struct folio *folio, pte_t first_pte, unsigned long start_idx)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	unsigned long end_addr = pmd_addr_end(pvmw->address, vma->vm_end);
+	unsigned int folio_nr = folio_nr_pages(folio);
+	unsigned int max_nr;
+
+	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(first_pte)));
+
+	/* Bound by VMA / PMD end and by the remaining subpages of the folio. */
+	max_nr = min((end_addr - pvmw->address) >> PAGE_SHIFT, folio_nr - start_idx);
+	if (max_nr <= 1)
+		return 1;
+
+	return softleaf_pte_batch(pvmw->pte, max_nr, first_pte);
+}
+
 static pte_t migration_entry_to_pte(struct folio *folio, struct page *new,
 		softleaf_t entry, pte_t old_pte, struct vm_area_struct *vma,
 		rmap_t *rmap_flags)
@@ -433,11 +455,13 @@ static bool remove_migration_pte(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	struct rmap_walk_arg *rmap_walk_arg = arg;
+	bool is_devpriv = folio_is_device_private(folio);
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
 		unsigned long idx = 0;
+		unsigned int nr = 1;
 		softleaf_t entry;
 		struct page *new;
 		pte_t old_pte;
@@ -460,12 +484,19 @@ static bool remove_migration_pte(struct folio *folio,
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
-		folio_get(folio);
+		/*
+		 * Try to restore nr>1 contiguous PTEs in one shot. Falls back
+		 * to original per-PTE path (nr=1) if batching is not possible.
+		 */
+		if (!rmap_walk_arg->map_unused_to_zeropage && likely(!is_devpriv))
+			nr = migration_pte_batch(&pvmw, folio, old_pte, idx);
+
+		folio_ref_add(folio, nr);
 		new = folio_page(folio, idx);
 		pte = migration_entry_to_pte(folio, new, entry, old_pte, vma,
 					     &rmap_flags);
 
-		if (unlikely(is_device_private_page(new))) {
+		if (unlikely(is_devpriv)) {
 			if (pte_write(pte))
 				entry = make_writable_device_private_entry(
 							page_to_pfn(new));
@@ -480,11 +511,11 @@ static bool remove_migration_pte(struct folio *folio,
 		}
 
 		if (folio_test_anon(folio))
-			folio_add_anon_rmap_pte(folio, new, vma,
-						pvmw.address, rmap_flags);
+			folio_add_anon_rmap_ptes(folio, new, nr, vma,
+						 pvmw.address, rmap_flags);
 		else
-			folio_add_file_rmap_pte(folio, new, vma);
-		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+			folio_add_file_rmap_ptes(folio, new, nr, vma);
+		set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
 		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
 			mlock_drain_local();
 
@@ -492,7 +523,11 @@ static bool remove_migration_pte(struct folio *folio,
 					   compound_order(new));
 
 		/* No need to invalidate - it was non-present before */
-		update_mmu_cache(vma, pvmw.address, pvmw.pte);
+		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
+
+		/* Skip the batched PTEs */
+		pvmw.pte += nr - 1;
+		pvmw.address += (nr - 1) * PAGE_SIZE;
 	}
 
 	return true;

-- 
2.43.0


