Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9863FC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B676B03A1; Thu, 13 Aug 2026 00:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6533A6B03A3; Thu, 13 Aug 2026 00:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541FB6B03A4; Thu, 13 Aug 2026 00:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EDD86B03A1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:25:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC62FA01C0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:10 +0000 (UTC)
X-FDA: 85094956380.15.6DC0370
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	by imf19.hostedemail.com (Postfix) with ESMTP id 789FF1A0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x3fd42jB;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJmcLgRoaeaouSkf3yJv6TF6RMZzz0FrmGos9xFDxFc=;
	b=1ktuCrEn0Df92L2uphVeR0XzRu1cV9lba10qtQoAJZ8esP4cQkyaqE69gEs4yQjXJLpoLM
	AQa9tEYMzx3ge9j0dWuSSBrBaMQRjhn3QO6TSTSlzjATOZ3WXqbfgXVQcfG9222PLRRkv/
	uCUjtQuWXBT4T18rP3K+KJ+CbVNP2RU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786595107;
	b=7fgccIM+XdJLw1QxHcHbZVdO0YyHHzRPgKQ8dy/bXSMT3u0JJHRNb/zXmN+yyxYvYkZ0tI
	p0gzQlfKmcaylKWpn6SgUNXhn39giw/RwP6olJVsKerpAj+QpEtExT4+pxxgMxvdJNWniK
	1jqLvRzbOAkoE8yI7RNydm8ZuUhjsrE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=x3fd42jB;
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.59 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ns+WIQmp0dLl/WQQgCyX8jeGpRqzoiI4rWTRBxLCG6vD4MxExKKukgp7LsY0v6UPZpA0M6mg2zBpjKA6g6NfjLvBOOKXY94J5i00rmtk9JtnSVfNm1bv3iwMELg4uumof11louGVtZi8LLLqBzWo0/h2UD17Ss5wTmTqQtqP9DFNUKsqhrTGogVYRYgmiSnc7Q1KVtJc4kd14HxctCIBEtRKLmELPfufFasm0FkOucFTBdzLYc2/g+nprnYgMnZBfQmjFb3o8/HBfoHAAgp8lXVkeLez41k3rGsibLmfybO9xC3+xY+uyLvszLLl2uGe2YzTfQsMdOnRw18RROzJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJmcLgRoaeaouSkf3yJv6TF6RMZzz0FrmGos9xFDxFc=;
 b=G1z5TVFWiSdqVPC2L+8xgbJlHtnUAXYacTleZQuoHfRsFoI3s12UY4VFoZr3bfg6UyYj/8ww2px0CcPXANSdKUtKuiRoK5GVlHnyFtMyOHuRCDWHCwLS665NrMNE0L8xeVFg7levicNaneXLRwtYkL9QonNgnMK73rzfMbhkOHxeYEyxST0M7Bsuw9EocyeUT/sfW4I6Djt1kQQiHtUxJMJf/x0ZnHXXbC+85tgOJbPCCPDRirkFVu7hX7V5M/rZnICe1h9SkVQDXGY5ovd8RcpSSrhcMo1tU2EBdY1n4nQ2z1XMUirdEcqsXZA4bXlGYCQV+v1g2Jc5njJWEdC3mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=surriel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJmcLgRoaeaouSkf3yJv6TF6RMZzz0FrmGos9xFDxFc=;
 b=x3fd42jBBoFApQ9qSgNFVts1TnhSLPEclP2/38dK7NQs25ObQ++rcPwWGU34hW4xJsNCJrEYAftEvl14c/NiQMZA4UZiTGzyyypRk5FTw3A0V2u0pgqdIayMPeL5UziHaop4eYeKwBDkWprunjyd02hDRt3ACn8TMga/PnogaVo=
Received: from BLAPR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:36e::14)
 by CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 13 Aug
 2026 04:24:55 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:36e:cafe::91) by BLAPR05CA0005.outlook.office365.com
 (2603:10b6:208:36e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3 via Frontend Transport; Thu, 13
 Aug 2026 04:24:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 04:24:54 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 23:24:46 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 13 Aug 2026 04:23:18 +0000
Subject: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260813-migrate-rmap-batch-v2-7-3c5424c555c7@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786595034; l=7623;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=N04qQs6ab3QOp2plxNgK76AdZ7rwOslb9VXB2PbRwNk=;
 b=LZGQQRKQxxrd5UfHQJW67iLHdSc9AzHrsMjwBxSj4DBrm7sUVRZomdXWG4/fFq8Ad7t5c3mfj
 QO6Jw4nyR60B9R/9He0xlAFU9Xhjd2luoGU9D8S/uaTvVXUJTmcUDUM
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|CY1PR12MB9601:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cb8934-ae4a-4355-c3a4-08def8f2d336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|82310400026|1800799024|921020|56012099006|10067099003|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	slDoFa0XVeCXamLiOKfcrYlDMUSkk+6/44H2Hljoj0sEsNrdyG8GC9Q40zhGT5pVSij1vGxGom9suOY3tT3lLLfDbPiCoNSWVKlWTOly08wRjIyJlpMHsiEt/L1C0ediR9z66IghQCLzMl6GAMp6PpBfe9anwXd77Ogi2tj/lOVG+SoJJ8jxy3pH++cM5sAHjg0pKVjo+up5MTiPJT5xFx23Is27xpE2FbhopqrRF+Eep3R2HMilYAD3CdPIHhUcnY7lN+tIyo/nt92DELZq8uCz1ME2I1kkx6bEb8mR10hwcEIiry6aEHuWoiTTPNi7laTfal8rk7HCRM73JiMaLr7tKAiwRxsTgWxnUhCHeckhgV5CJlXi08oZZFNH14N7LDFJMcKyINBwWPcDhqE0VaztIcfkaicDMpdsgnGlwcms1OBe4SsgFhxHmkotOgr/A59OnitmNvjEINK0T5a9HL4HdIEgaLDXDtnJn6GbJ+c56ySi23/+uU/+uXwchKICqV2SXKp8NFeEWQ2Zr2bZ9MpoAIK+dvUrfAptyTerAv+HQUWirTKA6GdzE1UkTbenW+VbafEOpEyuwBxpOBWQQVFf/FHWMJMf0gQZ00wlRcoS+N1E7fdGQb6Tp/KEd9vVK8NN3L+5zpoB15wKX4l2UlflNFcQib8O/Qmx3/Rm+m+gCEkwmM4bpfvv+WW1IVy2a2HqOF92Kumi+Tvx/6P5dr5BBwBsljpCip2/8J97W21dTNWGT52jThalMRRul5ln
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(82310400026)(1800799024)(921020)(56012099006)(10067099003)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8Hmd0TyVHivaYeSWowyOE5RXs+Vt/crDQk32hQG97Mlws36m/5I7CipAGBWrJyl2aa7gyGCBrM6ztDTFmpWZRJtlqKld0e4qs855DRybmNt7rUlIojUKPgx9gU7lHR/AgVCsvFdiFUxQu66lvdyHdjow4hG7fT/csGPuWpWCYS0Lzi2ongPw3e+5lNojTfAPuyOulkVwEoDIvMm8beQYALNV4UO323UEe0xtps70X2cNh5eyK5JnRhcCrJCC69msgRY0kKcN6sIUHZwqBbcTN00aCzSQM3QWVJAsq9SiojamBpuHK9KOiQoaaoihyaPF8rQlwX8buVL8plavSub/6AQUZOF85L6+oj07OBWFuZ+dUf3anzyhHKb3C/Xbh4Wim0RGWOx75TVbBtL+mDJSb2aDadWd5MReLHx9A5eozxhXqTRNHHyaG4XFAefiUQZg
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 04:24:54.2139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cb8934-ae4a-4355-c3a4-08def8f2d336
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9601
X-Rspam-User: 
X-Stat-Signature: wirga8ym448k9gwgys9uaupn6y5woh9s
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 789FF1A0003
X-HE-Tag: 1786595107-143017
X-HE-Meta: U2FsdGVkX18JbycovjN1z8RHsutXvT9kRVCg3mt4gAj0F3ptatTiStyEi9Qz1ddMuObAagEza6yNDBPsoJOrEiCPgcyy14cQXxq6iGQxhMI8zEnF8mboiuf9mx7qt1jpIhWhLnyahRcyKe3c2xwQSXAwCutZR5QTSr4n5mW3P1K1grIgpnSfGS6M5gj/4EqozQdG0tPbw1sugN9c/AIeYRPKd3WC48mSfBBbEm2pyX8JGpo6NOssJ6PKFIouLyiw0YhIE10HPONAlcbzwtqQ+AQ78hVJ8YCqsSEmV8okiCBUaDjOwfXAnyf6iItGWEoXNhu/0vDAMDx4FOeveDMIDL7HMuwdSKumsyxRh5I0m5rTw7cUAwXNqEvvsMyLojbxnLp/k11B2llSfQ1MNZkO61tsj86zRtAY0NIPwQkC7++y9yqtc07T4KAcfQ2X1Rbdwzn+Di6gCHb3WYhkhZRovc7Kii5pi2nkztk5AF158WUjv4x+JoFFPpm9fHHwt8WOeFeOX0bhF2li5AyLZz8qT99Zx0dSbxnuhC3ai0JOlLo1L+W/vJZUVTc44HWc423MF36xfszdPif8L+KBO4r1UuBMHFitcABO0viPiGgK7eqtIpfGvg2qmIjJpCxkcse/WWESac6J+/D7dcjAOCz20rieVCwtU2+bo39hX8J+c6SD850yvRRGsTsr7nnEAP7k6O39J4yNCMmF6D307mHBrqOZ1BkbrogyoJmp1bkKn9hDJbGGRdqbgxFl7yfYk64CsSU4KWg9mxddIib6fJDo7gtRLcZlbEqVH2sQTU1Hl0wOO1hOVE3CRobj8nGVh0qowm9Cu+DXpnF4XgCfpY/eHKTddggSE/1GEDVptODvU3CuybzkApjCEhqkiPh9jDgOI3E8w24MWaNTWMnVxq/erLETRUCQ4TR6DHX7EW8nTxB0FwCfU4VaWGlPT5hnsCalknbH3TkEnX7XPAZJOEa
 2n7lSJ7n
 tJY+qrkwIwtqhQz297TY7Wd6aBKNf+J8arXWx9wBCsSlOkFmGgx8I/Uszwf6zbQ4vPCg1m6tAHXx5dVmdh/8DVQ/JsZ3GTIVdxZa88aXmnQAtz9OKUumYfboCgsb/kr5n+MU8GGVK22RNIP5aK+BtvEnt4NgyNCSmUIR9pPk3PxwNeWiNe/RQYM5Ett8ToC4tTtCT43g+NsmPgDbUyqnKE6PTg68lwvsG1ekQplD+7PL5evuIJB8ujuDIfj6VgCyrfsNUKT0fG4CMYIolLEsXE+HHisXXMql9vvL2HXppfu4AIjoB3mD8ngZ/z1ccs2mpA6DKdjV88gbruS5DlfIIjGGK8Xh9RinMpxUVgbqH6o82ipW3PqWP0iznfN3z1LhYCk6LbTdFXoXJ7Et1Ile/zSBXYedosOwjEQ18lzTtONhomDFk0M8WhkYFMnufUqLOUuthwcmiy+8VMfP9Xlua0VLywPxU+9ucQmH59VBmNWaTt82rhMgQ+1wLnc0o4FLr9zeK16Pu0eVpF6mp9Dr2cIgW6/3UpBq0AzqoRozmqmJKVf5Sl6mbUJrI20UwzhudoUu+rzPkhNfbG0cUuWuco+tWKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_migrate_one() converts present PTEs to migration entries one at a
time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
each re-entering page_vma_mapped_walk() once per base page (256 times for
1M folio).

Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
eligible batch for PTEs mapping conseuctive subpages of a large folios,
and convert the whole batch in one shot using the batched helpers.

A side-effect of this change is trace_set_migration_pte() will record
one event per batched run instead of earlier behavior of one per base page.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 86 insertions(+), 29 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 35752a70f3a0..63b885c0b7ef 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
+		struct page_vma_mapped_walk *pvmw, pte_t pte,
+		struct page *subpage, bool anon_exclusive)
+{
+	unsigned long end_addr, addr = pvmw->address;
+	struct vm_area_struct *vma = pvmw->vma;
+	unsigned int max_nr, nr;
+
+#ifdef __HAVE_ARCH_UNMAP_ONE
+	/* Cannot batch unmap if arch_unmap_one() is defined. */
+	return 1;
+#endif
+
+	if (!folio_test_large(folio))
+		return 1;
+	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
+		return 1;
+	if (pte_unused(pte))
+		return 1;
+
+	/* We may only batch within a single VMA and a single page table. */
+	end_addr = pmd_addr_end(addr, vma->vm_end);
+	max_nr = (end_addr - addr) >> PAGE_SHIFT;
+	/*
+	 * If unmap fails, we need to restore the ptes. To avoid accidentally
+	 * upgrading write permissions for ptes that were not originally writable,
+	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
+	 */
+	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
+				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
+
+	/* Limit possible batch count to a uniform PageAnonExclusive value */
+	if (folio_test_anon(folio))
+		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
+
+	return nr;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
@@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	bool anon_exclusive, writable, ret = true;
+	bool anon_exclusive, hwpoison, writable, ret = true;
 	pte_t pteval;
 	struct page *subpage;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
-	unsigned long pfn;
+	unsigned long pfn, end_addr, nr_pages;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-			if (set_pmd_migration_entry(&pvmw, subpage)) {
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
-			}
+			if (set_pmd_migration_entry(&pvmw, subpage))
+				goto walk_abort;
 			continue;
 #endif
 		}
@@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
+		/*
+		 * memory_failure() can set PageHWPoison concurrently without holding
+		 * the folio lock. Snapshot the flag here to decide whether to batch
+		 * PTEs or install hwpoison entry.
+		 */
+		hwpoison = PageHWPoison(subpage);
 
+		nr_pages = 1;
 		if (likely(pte_present(pteval))) {
-			flush_cache_page(vma, address, pfn);
-			/* Nuke the page table entry. */
+			if (!hwpoison)
+				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
+								   pteval, subpage,
+								   anon_exclusive);
+
+			end_addr = address + nr_pages * PAGE_SIZE;
+			flush_cache_range(vma, address, end_addr);
+
+			/* Nuke the page table entries. */
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			if (should_defer_flush(mm, flags)) {
 				/*
 				 * We clear the PTE but do not flush so potentially
@@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				 * transition on a cached TLB entry is written through
 				 * and traps if the PTE is unmapped.
 				 */
-				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
-
-				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
+				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
 			} else {
-				pteval = ptep_clear_flush(vma, address, pvmw.pte);
+				flush_tlb_range(vma, address, end_addr);
 			}
 			if (pte_dirty(pteval))
 				folio_mark_dirty(folio);
@@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage)) {
+		if (hwpoison) {
+			VM_WARN_ON_ONCE(nr_pages != 1);
 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
 
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
@@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+				goto walk_abort;
 			}
 
-			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
+			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
 			if (anon_exclusive &&
-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
+				goto walk_abort;
 			}
 
 			/*
@@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			swp_pte = make_migration_pte(subpage, pteval,
 						     writable, anon_exclusive);
-			set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
 						folio_order(folio));
+
+			/* Set nr_pages migration entries, advancing the PFN. */
+			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
 			 */
 		}
 
-		folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
-		folio_put(folio);
+		finish_folio_unmap(vma, folio, subpage, nr_pages);
+
+		/*
+		 * If we batched the entire folio, there is nothing left to
+		 * walk; stop right here.
+		 */
+		if (nr_pages == folio_nr_pages(folio))
+			goto walk_done;
+		continue;
+walk_abort:
+		ret = false;
+walk_done:
+		page_vma_mapped_walk_done(&pvmw);
+		break;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);

-- 
2.43.0


