Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5DAAF3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3AC6B0095; Mon,  9 Mar 2026 08:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E376B0098; Mon,  9 Mar 2026 08:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470A86B009D; Mon,  9 Mar 2026 08:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 361CC6B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:12:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA38B160145
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:12:16 +0000 (UTC)
X-FDA: 84526411872.21.7CE3E0B
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010064.outbound.protection.outlook.com [40.93.198.64])
	by imf23.hostedemail.com (Postfix) with ESMTP id B22B1140019
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:12:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="kADXDNw/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DP8G7gq5TCtMzoUALud8QGYN83GG1lkK6KmnWWgrZI=;
	b=zKrZqO20PAdLIwRNKhx/zvDtg9gjdXToQ49sTIblcFcx2+CR7rGE1InDUjW2+T+ejNI9Yd
	1PaSbGZOmSAwBjrgeQItF639ujb+llUAzQNhNCQXxlOtEtjFdwAFXeVTS+o6wF1NUrW2aq
	Z6rgHkVfk5U2e6uI/zU43wKrxQbZ7ik=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058333; a=rsa-sha256;
	cv=pass;
	b=l6HbnppyOoGqsNy4SnxLw4fNZ2bGLR1FF/gtSfdw7HQntx8FFWFylsa9VoO3FbHziorgFC
	KjeY7xl1Uch2XW9bgjjyaAkmiBYW9v3Cibo83B9xicrO58pSbHS/LqEn43QtqWgIwB+rvQ
	pdwmD4fc0UqFXe8IHCqHsVGQqFXqOW8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="kADXDNw/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkPXhoAiJEEiQh+5bOYhxqBJJdDDh6IUB2r4ERj2Uu8jGArn6+npOIq6uxFERICrpeSINsiCQVugv4K0liT+lA/Npl2m5L6itPBowbKlJ1mwIOKmahMH0RDzXsyccx0a2teVVewU8JoIV3KQ5xai2wCBxtxJjpykkvnInmWcaFCxirnoFBM64UNt82YIh6Y4gTl3JWaU0GpHbX7W9G6sUS7BvtZRstDgAXJyZ7GoPJ7v646RP+ZOiaGcfwHiXq7UeH1Hio3l6o4ve0DCSl+AtLVXWyohTm/fcXWq5dvVS/FxfrOZumpQ+04XXAwG3czKWQj6ONqQ+ZrLSjGQSsLv+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DP8G7gq5TCtMzoUALud8QGYN83GG1lkK6KmnWWgrZI=;
 b=EtDB24td7iyfwRapISFpmydUrq1SvtVhqoiwFTsqMkQGldRHLBxgQXEi/uzTiVpLW//ibBA4a24XLG01Z2D4YJfuAwTyxs6YVAwBRkFJX194KOvCSIjBD56UUH6AzquQEQ10/1muvPC1W+VLXpiy8r2x40L8dUpifncsPhjDPd3n+ESNbrWz+/QK80NEjTeB0ZIsPI4GOZw/eBU79QF88MCCnkuDxdYoUJOO+x1R8b+pFHhYrb992yXN4uRr2wLqTK9nvvnzYfhwM+jKCSzkGFtrE6ZoF7DWQWZGugP18OavPSFuOASqFHVmzufAVe6nIUxWlQ6bvUHjf1svKqhXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DP8G7gq5TCtMzoUALud8QGYN83GG1lkK6KmnWWgrZI=;
 b=kADXDNw/5Rvr3YEWbmqDaGTZLG2dTx3geSkfMQebJ5vv3EXdIZutx0nT5UcFNjwWg85KJJy5HRnjv6BhgBHlE2XHsPqaml4M+7Bb3jveqIsMDLh62mBay8t48ThgSPfpXNejIZEWLED6mem07j3JsjVN1nG8/ZXY7vxVpvcJqzo=
Received: from BL1PR13CA0395.namprd13.prod.outlook.com (2603:10b6:208:2c2::10)
 by LV3PR12MB9188.namprd12.prod.outlook.com (2603:10b6:408:19b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 12:12:09 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:2c2:cafe::e6) by BL1PR13CA0395.outlook.office365.com
 (2603:10b6:208:2c2::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.24 via Frontend Transport; Mon,
 9 Mar 2026 12:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:12:08 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:12:08 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:11:57 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <dan.j.williams@intel.com>, <rientjes@google.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <dave.hansen@intel.com>,
	<hannes@cmpxchg.org>, <jhubbard@nvidia.com>, <peterx@redhat.com>,
	<riel@surriel.com>, <shakeel.butt@linux.dev>, <stalexan@redhat.com>,
	<tj@kernel.org>, <nifan.cxl@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [RFC PATCH v4 6/6] mm/migrate: adjust NR_MAX_BATCHED_MIGRATION for testing
Date: Mon, 9 Mar 2026 12:07:33 +0000
Message-ID: <20260309120725.308854-16-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309120725.308854-3-shivankg@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 165af805-fd09-443f-9ed6-08de7dd5163a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	/q60IY1EV2qGV4PaT1QV6Te772lcVj0G1REw5p8vdasUVIO962FP9z3Es/jqHc4yyf/fV2c1M5B0DIiywyu/Gkz4+5YihmnJx5x14EGsdBBY/hlhmtsDSE2pfNE5Md1TTde3N2LHLdtQhBeJzMvNtMGAz3PSQVC9un6n3jK0c3jfOhXmjFyycxI1y/mtX7NqK1rWVluqJlxzt/plJUl2v92jyLZ1CfmUeTs24bEJOL5iWlxLS/a90bEo/Jj1/V4Us8YruKBtgyaR7whyF9P4FMlVHgKBxRv78HrXHGJL1lvV6KR8Y0jXG7MzlpMlomUTQWpzX5KGIck2RQ7N4QGtqvqNGzBe7U7HQc5nUw3KF/hdoScFe4ZqVLeX9tAnzXsKPvDpuU974VMCGnR8AJU/sUzkfhMkeIhTSTBHKBNeuq6Q0/xeTZ9x/Y/CzBcu7GKvkifGqrw3B2S1NeYTRdFFP2cA/K2Ub1pYqFF70ixJUSs1ap9Uc3dtLDLYEqbII2cWI2wuusdZxADJlFRUwtLLVSJ2SWq/222jqbMgtCHTCNvDRxEQS0aOoYtMQaPZGvJKVDVnwqFkI3um8Lri4uyF3x8ctakVCyHFhMahUkjOedvTR7S/dBlEPZzG7PYIvhdufDSWmQ/Xv4IzCPAONLkTecViwy6XQgHfOBcePma8UJnW9O8Z1GYGZmlHr1hUcZ4ImoUPkqUvP7Os8TOI7g2Ul9TdL+cKa+HZjC4BcZHeDox+rI93eedM2PnDulz8v3CPTkX8J2TPobOlcxcBNp4uRg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KOjcXRNAktEIdm9575be845awg6fXBGch5KCdvljuWdNnBqFGDHPYlsoRRWvH880ElIWCm+wIdNNhyO4rat6yuW246O5by3aWjaqlhLxyUz6mqOyBK2hojpaQr+Ycae0NYUPC+GhXgfcooc5x5Y/LP6b/HNGqbdlMrh9ChcrRyWH1Uny2pS0PJKSzymG0+H1lr+kIbnsaubXskV6EprtLAEthGa8pp4jDG7GaXIDBR/quSlbWq/nZ6qBeYRZXlfror/xmoaOhaVIj/Z1wl0SIAbwyS/DRyCJmxS4oW9mlh1JmxKNbwBT0Mr4eOx74hl2XkZo5LR00FS9NMIT6gVVaynHTFqtKMXaRK4QmbG7V5wO0BLmcKsV0ZmGp+py9/FnH7+/B2xtA8ZxD4dhFLB3Dc+bY1tz7OMdLkbRQvLfRAwq5Ru0N9+z0W/zIF9W0Keh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:12:08.7194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 165af805-fd09-443f-9ed6-08de7dd5163a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188
X-Rspam-User: 
X-Stat-Signature: puwagxkarjoqwste7pe9qzre8ru8ro9a
X-Rspamd-Queue-Id: B22B1140019
X-Rspamd-Server: rspam03
X-HE-Tag: 1773058333-281881
X-HE-Meta: U2FsdGVkX1+0o4990xUJ6SjSErHOph9UIJPHK/d9qE3YheXBvGAzKwPp+VfZmiNV5ZlApshpRD4Na2B4W/AuvRxPcVpn2UZXQnAbJWLas33Wfqji0WCnjLbiCLxFHDAwskCQiVO4ssTFVCO8/uTTdxDHMiQuum+SkDZwbSyrlw0+muX7qSOpiz+4TqHdWDgr/EmuE6J92COrrOiStCJ+HEgLMjIKE5Y3mw9B0zMQtslEYuKGgwZhoiXUhsnA/3Aul3s8PvZPf0cnRSuu3sH4YCTfxsF+ZrZBnuscdKwSb1wRaDUf3hSKxasMWWn9lOjYg1MOzlZvumfDBJWLBU3koOS3qo9Yo/s+ACT7m0eGC3Upr7J5LcWXjulKxdIbrdv95h2EJcmS6QqT7dw/F2cRMqzWVdbl0Ac827PvY5zJta9b7jhADiDSLCi0lPVH/cquy487ZXIxBs4kNn3GKP+kWeIWL4hKnGVbjfqRkbMZkLMhY5jiTsqqK77zrKlnIyW9sCpXT+bBCSxfFq5NkQV8q5nVlui6vq/xbDA0xl2a4JvC/AC6sg4ZTOxXAECydbMC+GJ8K3VTqVLNAMWdjmyGskfIDyjTIZKYKLQbNzW16ycarhqmIWn15bywlN1aezDx9j27Di6n9NiSGXQdFRjhtCcW5vHFhjK2j4rtamsIbLj8dKo9BhZWKP+dYGNp0wEOtOV/GvMPD4UYlzaVcypet3FLZd13xlRcUUqP3AOR3Mavzaef9eJGsICbNGdn49CTOq0yrUWcAL6ZFwUy2iBmhvw+Z7dmc2Iu23oBEpuKRp9RI9d974ZT/+mqs5P8CY2S9aw7b1EuIh5NADbA3u/Cq9hR9eryC/jsGaiMKq7hX8+BfLIaW/PU+twec774eTbEpq2JYFKgWnPIfHBD9GtF1B07fMt1heSIAW9EXbxORcFYYPEpu0KgoUjkLW2DoQRfyuMgAkL/aK7G1h3kVRA
 V6oMUc2R
 MkX43j2GeZrq/EkAYODfQ2xEuyI4XZhPp9ghShuzoonOuomVRFS1DtyvCPxI9VzpF+WJlZpJEdMbW1HJQLB9JYwrO/entGhqLWosQPw8Yq+V1UzeYln9MQWnzV+IqM+UL9bvG+x0/XF18GCcACPGUo/jns7VaD7+Ufw9zrQH8dYm7+PyDRGu15UmqExXBRu7xEWsbhhvEFaFLBgMO2jVDLO3Xm8Gjc9sUpzfOJqmsWyagqzNZMk4+agOFEqRiEVGgq5glakVJw+8IMbFCoXemJ3VoLGxWThI4NL1AZjc261BORXWy/sVST82nxRB1AVU5NH6ukGyBtWEnK3zDp/7q6kUn+sVBTqvc7TAjzUJXqfbGUCyuHYnYLgWF6PMchiQRVbzzVDjgwm5vKMr3OP9jOOCuOK7WQCOaMIRLUcp+8bhROKlULIfgADiC6A5rBou2sCaqjdgngNHCzuiNsbvztA0pEUaI4QIOKkMF54MXqJmB6XCaxNqjJyNFGgeUjgfgRYbapLDWEjxAc727AxEhtcENLDTIN5rbbJGK4jxfxSB+6LGGKE29WqcN5CNgFuDjBMZfdxwyL+M+DWWo8Lr60QFmJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zi Yan <ziy@nvidia.com>

Change NR_MAX_BATCHED_MIGRATION to HPAGE_PUD_NR to allow batching THP
copies.

These are for testing purpose only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index acaaa9cc0d4f..8540e303190b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1606,7 +1606,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define NR_MAX_BATCHED_MIGRATION	HPAGE_PMD_NR
+#define NR_MAX_BATCHED_MIGRATION	HPAGE_PUD_NR
 #else
 #define NR_MAX_BATCHED_MIGRATION	512
 #endif
-- 
2.43.0


