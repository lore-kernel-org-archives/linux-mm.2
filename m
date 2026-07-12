Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52629C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142FF6B0095; Sun, 12 Jul 2026 03:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B686B0096; Sun, 12 Jul 2026 03:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25C36B0098; Sun, 12 Jul 2026 03:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6A1E6B0095
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60DCE1C916F
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:42 +0000 (UTC)
X-FDA: 84979330044.29.6B712ED
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3146A1C0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="QC3cKXF/";
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842099;
	b=By5twBDwvxvwVs2l0ZRq+SJt1nDtyCPft9gcjdZy6oyRAUrkqRxhYLrhdgrzRtBlx17fhI
	RSSFSAc2k2lQCr29NT/wtNswORAM5jUsparlsxfFX4C//iteLBt81qV+Cahuw3rikCz7Xc
	QHz72MhVGz5KLKIZoleTBOcmEkbmHKY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="QC3cKXF/";
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.46.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDRb3q89wfKwwC3j/8iU8EEJ2BM5C0f3qSFbGzDevzI=;
	b=YwUmzBv4xH7ku/z4XYSU07EsN2bMwTfVt1EjUruFzVAeWfX8iYCF45CvMekbj0Ng9qFReV
	IqW98yFBK8cln0oNZ6emQvcBL40spRhMuTocJCTJScuxUcfx3guF4CWcOOvSHgnUiJ9dPn
	C4nacFqWDvK6L1Oq13IdSwQ7euVCwFo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DG5+NymSfOAZqOIhijvwMu0eBN1WZAvciLgZda/R//sxwml/oKBHlC8Azle9dVRdAzkGOPRVZy8mrjkZ8Krk1G4F+HDdhxiQwpatl2T7bHz/Wc/MjibnthetFwMDvywFKF48/V4lFNnZRMGK/FwMENhKIRagmH0RmpyHbNKty3wZqHYGy1heNQvJu9UiBjBWsCrKLwOkWJmESeKdc6uLNH3u+OI+Ct9lLJkbey6jBvIsP7XSU4MFddotpEdLzLoBTYfSw3pqMXUAWElkzjdSQfSX0Ra/lNdLEZy/4CR8iipZtiZr+JJjnQ2TmTAIKqUchohQLnjrcl9njoLKggTdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cDRb3q89wfKwwC3j/8iU8EEJ2BM5C0f3qSFbGzDevzI=;
 b=Phu/lXdfaT78VG9MpwAnXopPZaZpBhFr+6n7Etmxj6iMVEuNFLGm/mybn7NFmzf7gf3Wc/ERik5DMp8L7YAYZrdS+JtOzUjXFmDsWw6z8lc28zb1c6+RKa1AhpJD6aIrxCGpQe4YnnPlPg5/89pAHsd5ZulkRkI9f4DaPh2jjyFhY7L4plCrJsC1Xhb+TU/Ox6jNiQngVLGQGxKQp6/W+bj07QHzWdcioejLJ3+LPEqdnLe3oCdDfoD7UtlArm9h/WBBR4UNgE043g+Niql2tRImHFNlk3Trh56NLlshDOGtTzh/UwzCAJeFgKT7ecnePPpVueOp8q2DMciFZZJiTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDRb3q89wfKwwC3j/8iU8EEJ2BM5C0f3qSFbGzDevzI=;
 b=QC3cKXF/NIfrN8g2Mf+V0CYMwuDFN6PW/UO+9LK3Od12p64xwJOUGAT9M3YNP0v/7tq2iFSqA+HhVMQi3XE6kkM6t6a/Pu7JAzecP0JM/klbZeb6iE+Odu8MrWnw3WkCZ5K9hWIG4pDfq7aN+A1Cp5cZszD7SBPabFgGkYehxos=
Received: from MN2PR05CA0057.namprd05.prod.outlook.com (2603:10b6:208:236::26)
 by CH8PR12MB9742.namprd12.prod.outlook.com (2603:10b6:610:27a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.19; Sun, 12 Jul
 2026 07:41:30 +0000
Received: from BL02EPF0001A105.namprd05.prod.outlook.com
 (2603:10b6:208:236:cafe::98) by MN2PR05CA0057.outlook.office365.com
 (2603:10b6:208:236::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9 via Frontend Transport; Sun, 12
 Jul 2026 07:41:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A105.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18 via Frontend Transport; Sun, 12 Jul 2026 07:41:30 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:41:20 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:51 +0000
Subject: [PATCH 5/6] mm/rmap: split try_to_migrate_hugetlb_one() out of
 try_to_migrate_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-5-872a734431d1@amd.com>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=15491;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=kA4wEi7ppwGHQEuijqPdO/498Z6da5jU8Oyz0X6nkYA=;
 b=wRbrjbzqlIzHpuSnUEX/BHkdBXd/1TmBTOLV+WXvAfZ4v2sAJMMSDeDmqZXWa+e86rAx6FTaH
 ZD+wh8TX4aDCKLKdNxD+ZpNskRh8q2QAgydafmhrfjVI/Rg+isnacUS
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A105:EE_|CH8PR12MB9742:EE_
X-MS-Office365-Filtering-Correlation-Id: 23912fd4-225b-4b49-3674-08dedfe8fcef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|23010399003|1800799024|82310400026|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ykaes4BDVlA2bRg/Ouxss2zWlINkBI/y1+8tPp+AddwNiogQNi0uZXhy3V2aPOwUNlxBZXj2NZu73eWxIY/sfhCQL/KhGS1pAMq/8NN0EswiVcCysofm5R+cuOaTxS5lLYVUfrBxecwwsZS1sHA9FgvONk6pdirqaGU6AM00+5VRoAkP9sFbFgEatJ530XZKFKxCx3QxISNSNn4k00IqWxMcAcQpX22II0RM3pWaXACP42H7UR2a5ejdNvITpXTmYjKDTWPYIn5wt7Q1PZ8TjJwfWyPbRcBVxJHI6unRFUZt+nS1EcBun+nwgYo5mlvYuL9FnSN4BrhjnmvVTfUxt0G+fgK5WHZ1cKdjoN+xtEZoyG8fSINuyjMVaiI3lJcUrIWjZvYbD2t6k8LHK9kCFpiiwYKuhR92VRvXl8srJQXiS5+bJ+G1UduoPnZyJ+stnKblgFQOJDEV4hltNO2NdEW42hN4Y0htINlapiJPafv3MyPCrTxPFyUl88IiDwXNEiPjwF1+hVbQiqMRRBBde7f6KpjlH21VEUKAF8VIV5ttyRYcvTnA79fnswu1gKQFF9195nR/IMcEXKid2cYohmmfYZ+GS8GyWjrZxIcN7DcU5tr+Jh6gYpT2zGtdxiNNcqu/EFGL8I+Q+zsTFOYeFOd3Mr1oJ+u5YyjKOOrbvz4y9Gm4gBZFo7/+rmISi/GZPdar75RRmaZ2IRmYz44YP0upWVocz58lzhAOaGpdZ23gCmI0Bojn0HvrU13CnCjK
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(23010399003)(1800799024)(82310400026)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DR+BKDQbUnmNlQuJ9S9NqwLPpYdimRT+BQcnfKopY71oLxWfxYsC0YkCyqWlfcTDP6E9iLxIsL2rIUBSN7J48cEx//3k8KrRThbPzICOoBPT6bg7detC+ou0J2uwQ9EWCQQxIwC+CiDIZ1FBP1miFokR0xBkW9euNTOHRxwjig8FcnGaOUOPmBpMKuvoSc0/dgeKROrn+GMIqwofbdQiLarxrplI7ynz1F3mtQMtHeHv4IiB30exUnCxTchGak2MIXdfTv7FrqvP7FKEUot2ycfdhTG87qc+gxQeLamjIr1FafqEofMtNiSRAtSgaLmIxWQxMc+jWe6tKXUtLIrdPcnS1B8cw+atHuw/gTAOqj4sjPbdmJXKBXCmXyUMgzO8EQJjW+Rzf5Q9dj24Cp2TmdKhpytVQnDjcTjtHZVvf6OFoYwdCK3MKnEdvoDSJy8E
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:41:30.1765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23912fd4-225b-4b49-3674-08dedfe8fcef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A105.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9742
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3146A1C0002
X-Stat-Signature: sek8ci9ihdwjm985mdtyxnb6xi3aeass
X-HE-Tag: 1783842099-963881
X-HE-Meta: U2FsdGVkX1/SqjhIBhnOEjetCAEUw93Hl24GMVrht5oBpdV/46TPntT0VzodBWmCt1bTGK8Vik9uCiGlC+a1hTHBBIU0IcVMQXbk8MiKjrFD8eOAowECD8K1IeTJpnvBOL99s4E5uNshHY7jPaohSF4a/FxCdl3XKas8ONJ2iOd7HSYBaflpvEGOD+t3s80yTbxPLlcWAB4ARucWfilPpURnBkXUqEaqrp5iobnkg7nUfqzljH9dntRg4+UD5XWLxIIRk0LGV4Am+8ZjDl2sntuZnZsdN9Vv/djMykNWyWUUj364P9G4uWndddwPDi9WS4EAnSsGNwbRGVZ2CNkBpfhW3JVO1qB+uyrsd84mbwiiVkr74UVKAIMrAU8etDMgLaMnOis40n4n9yx6TT+cC3gNh4ltjmD6nCec9TqCnoj8SNA2JYxmz77IhsIdj+k9KgjOZemUo7LjmvC7umiQtHSwPmHdj1aMJqMIYBaUCheR4vgipXtqaUVgBSoHqBDfR3YG07DYyMRAdnX52NkN5k9yPF/Oen3DfoGzWv8GML235qFIhmPVhGk99We511szvvXOpEUm2jYxYTOcPJ3VdiJV+/ynQPxfbOyg1JZVcMPd8D6oDIPFx9T1o5PgSJwVaDpiZmtIFVEVySahawppAwVHgfghIGtllzgH+OtJNU97GxsetQYnimcvwEbyc6LgupMZRb4iKj7P0I9Ou8Dgw4sOqQ4Wm1GY1iM4x9EWqWO7e/6bCdI6C7W7Z1grKJTHLzYOO41AfUNAXaL6vQqPNQjWy4QHufqLf601tjnwRzyTg6QaFd9JKuSefD2g1Y3fZ2hrFdyY9MvxMsO9Rdw4SOU6nNxPDWnqBZDFUPksD2OpulKfAX4fsZsreRRZeJEPbEm4542hcGoYZI36hUP3fHfopecal1+5Rgwf14KSb/qffaAZHcJFRm9t3XhnQvEmYWvp519cYUy/ktcVn1l
 wKg+60Up
 do2PMZ2HmME2taeHomjcrmveBgdXUqmHAyx7jaiHmgsxGkGzgnfvUWoSqVTeV6XcSZpnD7K59F4Je+Gt4xqYJP4BXPryD34T33JxphNO7kX5z060HI2mwAa8ntfPSa6DVL7bRNieGUMaAWrnvd+Ib2xX8QDyTDS6ClylExju3HLqp0rWsQS6yCp7Wyj2mBDpwLQd482LHKE7V1KxCwg+FU0yQHWfUSj46p0hKeDaz/gpeodUFYssQEqjxn9O1kn8nFo8sNyvV/zb3B7lsY4dk5xou8hpUay9fj5T4V9iiF6Dcl7ABSLmNX7Cam4r87A/H4sW9CTXNObIGMJlekcCUKBUcvbOPNyFBalLUTmoU16MbKoSDqh461N2HuMhi8VAfh1ukmZqtUtHLl0e8WH718VLPHKiKXcerHOuqhhYh22voiT3aA8KtFtL6LhWDaOAybKDRXRa09niVZSxAI9TB6/5hfR+wZCWxnUuVuj/R1Pzs89d4otuC/ztjbPQQDHFt8d2rPr3SavzAtTL9NBxyXSI/YkiV2E3jygm2qdZMi1uZHD+FGdtdAajmCUPqpaSI/f7FKWcPssrAKJd2nYS0yv97zQ==
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

Factor the migration swap-pte construction shared by both hugetlb
and regular folios path into make_migration_swp_pte().

Few minor changes:
- Since hugetlb uses separate counters, update_hiwater_rss() is not
needed for hugetlb path. Also, use huge_pte_dirty instead of pte_dirty
- No PVMW_SYNC flag is needed for hugetlb
- hugetlb folio has single mapping per VMA, so no loop is needed.
- Convert VM_BUG_ON to VM_WARN_ON_ONCE and not use irrelevant WARN check.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 329 +++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 195 insertions(+), 134 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index e854679553b9..ef68adba89c4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2405,6 +2405,187 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 		rmap_walk(folio, &rwc);
 }
 
+/* Build the migration swap PTE that replaces pteval for a page. */
+static pte_t make_migration_swp_pte(struct page *page, pte_t pteval,
+		bool writable, bool anon_exclusive)
+{
+	swp_entry_t entry;
+	pte_t swp_pte;
+
+	if (writable)
+		entry = make_writable_migration_entry(page_to_pfn(page));
+	else if (anon_exclusive)
+		entry = make_readable_exclusive_migration_entry(
+						page_to_pfn(page));
+	else
+		entry = make_readable_migration_entry(page_to_pfn(page));
+
+	if (likely(pte_present(pteval))) {
+		if (pte_young(pteval))
+			entry = make_migration_entry_young(entry);
+		if (pte_dirty(pteval))
+			entry = make_migration_entry_dirty(entry);
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	} else {
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_swp_soft_dirty(pteval))
+			swp_pte = pte_swp_mksoft_dirty(swp_pte);
+		if (pte_swp_uffd(pteval))
+			swp_pte = pte_swp_mkuffd(swp_pte);
+	}
+
+	return swp_pte;
+}
+
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
+	if (page_vma_mapped_walk(&pvmw)) {
+		address = pvmw.address;
+		pteval = huge_ptep_get(mm, address, pvmw.pte);
+		if (likely(pte_present(pteval)))
+			pfn = pte_pfn(pteval);
+		else
+			pfn = softleaf_to_pfn(softleaf_from_pte(pteval));
+
+		page = folio_page(folio, pfn - folio_pfn(folio));
+		anon_exclusive = anon && PageAnonExclusive(page);
+
+		/*
+		 * huge_pmd_unshare may unmap an entire PMD page. There is no
+		 * way of knowing exactly which PMDs may be cached for this mm,
+		 * so we must flush them all. start/end were already adjusted
+		 * above to cover this range.
+		 */
+		flush_cache_range(vma, range.start, range.end);
+
+		/*
+		 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write
+		 * mode. Caller needs to explicitly do this outside rmap
+		 * routines. We also must hold hugetlb vma_lock in write mode.
+		 * Lock order dictates acquiring vma_lock BEFORE i_mmap_rwsem.
+		 * We can only try lock here and fail if unsuccessful.
+		 */
+		if (!anon) {
+			struct mmu_gather tlb;
+
+			VM_WARN_ON_ONCE(!(flags & TTU_RMAP_LOCKED));
+			if (!hugetlb_vma_trylock_write(vma)) {
+				ret = false;
+				goto walk_done;
+			}
+
+			tlb_gather_mmu_vma(&tlb, vma);
+			if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+				hugetlb_vma_unlock_write(vma);
+				huge_pmd_unshare_flush(&tlb, vma);
+				tlb_finish_mmu(&tlb);
+				/*
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
+				 */
+				goto walk_done;
+			}
+			hugetlb_vma_unlock_write(vma);
+			tlb_finish_mmu(&tlb);
+		}
+
+		/* Nuke the hugetlb page table entry */
+		pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+		if (huge_pte_dirty(pteval))
+			folio_mark_dirty(folio);
+		writable = pte_write(pteval);
+
+		VM_WARN_ON_FOLIO(writable && anon && !anon_exclusive, folio);
+
+		if (PageHWPoison(page)) {
+			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
+			hugetlb_count_sub(folio_nr_pages(folio), mm);
+			set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
+			   !userfaultfd_armed(vma)) {
+			/*
+			 * The guest indicated that the page content is of no
+			 * interest anymore. Simply discard the pte, vmscan
+			 * will take care of the rest.
+			 */
+			dec_mm_counter(mm, mm_counter(folio));
+		} else {
+			pte_t swp_pte;
+
+			/*
+			 * arch_unmap_one() is expected to be a NOP on
+			 * architectures where we could have PFN swap PTEs,
+			 * so we'll not check/care.
+			 */
+			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+				set_huge_pte_at(mm, address, pvmw.pte,
+						pteval, hsz);
+				ret = false;
+				goto walk_done;
+			}
+
+			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+			if (anon_exclusive &&
+			    hugetlb_try_share_anon_rmap(folio)) {
+				set_huge_pte_at(mm, address, pvmw.pte,
+						pteval, hsz);
+				ret = false;
+				goto walk_done;
+			}
+
+			/*
+			 * Store the pfn of the page in a special migration
+			 * pte. do_swap_page() will wait until the migration
+			 * pte is removed and then restart fault handling.
+			 */
+			swp_pte = make_migration_swp_pte(page, pteval,
+							 writable, anon_exclusive);
+			set_huge_pte_at(mm, address, pvmw.pte, swp_pte, hsz);
+			trace_set_migration_pte(address, pte_val(swp_pte),
+						folio_order(folio));
+		}
+
+		hugetlb_remove_rmap(folio);
+		if (vma->vm_flags & VM_LOCKED)
+			mlock_drain_local();
+		folio_put(folio);
+walk_done:
+		page_vma_mapped_walk_done(&pvmw);
+	}
+
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2422,7 +2603,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2435,26 +2615,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 
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
@@ -2501,10 +2668,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2515,66 +2679,13 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2613,14 +2724,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2635,7 +2740,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else {
-			swp_entry_t entry;
 			pte_t swp_pte;
 
 			/*
@@ -2644,28 +2748,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2677,37 +2768,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * pte. do_swap_page() will wait until the migration
 			 * pte is removed and then restart fault handling.
 			 */
-			if (writable)
-				entry = make_writable_migration_entry(
-							page_to_pfn(subpage));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(subpage));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(subpage));
-			if (likely(pte_present(pteval))) {
-				if (pte_young(pteval))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pteval))
-					entry = make_migration_entry_dirty(entry);
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			} else {
-				swp_pte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(pteval))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd(pteval))
-					swp_pte = pte_swp_mkuffd(swp_pte);
-			}
-			if (folio_test_hugetlb(folio))
-				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
-						hsz);
-			else
-				set_pte_at(mm, address, pvmw.pte, swp_pte);
+			swp_pte = make_migration_swp_pte(subpage, pteval,
+							 writable, anon_exclusive);
+			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						folio_order(folio));
 			/*
@@ -2716,10 +2779,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2741,7 +2801,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
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


