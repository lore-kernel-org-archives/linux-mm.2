Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747E1FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AE96B0093; Tue, 28 Apr 2026 11:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1DE6B0095; Tue, 28 Apr 2026 11:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8046B0096; Tue, 28 Apr 2026 11:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDC96B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:53:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A4D0403D8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:53:20 +0000 (UTC)
X-FDA: 84708408960.23.58A022B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D85C120012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:53:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TWKdWPvP;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KL+QP1qDwV2Jdt/D3PbFBW6EvKUJ05LbyqoktAEQxA=;
	b=tagplv2FQxuQuLbKmZrny0FjkOctpW9lUzQd1hYu24v+nKrXQ9oJisSD3rdrPCv6SVheR/
	MVhLZGpnO73pZxWog/TE/QGc3JOSCEXV+0HR8W3ybTCuDFq008/YUVC8eycz4yJPpWgt2i
	5l9EDsMIJJ2mOwSL3g4UjNZF2gSL2xA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=TWKdWPvP;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.23 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391597; a=rsa-sha256;
	cv=pass;
	b=JPOT0gaRl8rNYWzvxjnKjUcaSLV790nV+yk0+6H8ve5/1jfEbXBJmRvlsvoIIGFG5XZ4r2
	MSQs+yedeyBYs+GWWTa8yqAzBVTRtPGJOs64jhb4MGtkCx49BWy6Z6DjzhrOEMLm9WUZ1X
	VgDlbuprOOQV87Ex9UgqwKWbUGnexAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vi+92PYisdE+z+r3TabivKsF77UnyCIuynjkquaWCJIpkFvhhsU+Ul3wN4hAVJ+D99jM/edBwXGhlSlUka3vg/rkY7LhBt5+1Ekqp9mpeC6jinY6waQ+w/aC6ZZslcKm2GR5vtRsNK0QraBAv9vd+xNjmG2wtO1lIoousicAr7O4gyhxYx+zmo9K0/xBMKpaPmOnxsEPSreTAcdAbrXn8Pf2AmnnxCWQ7/GxWAHLVJHEcLllhI6WAChshFpfm91q3wWp2oxotOS3wRFDHboy0tZ+raj5nN5DXzie6J6uwoVPknVxDmN/xJi/H9LsC9IMyrg1Bg0jkqLF5ALS/06tzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KL+QP1qDwV2Jdt/D3PbFBW6EvKUJ05LbyqoktAEQxA=;
 b=r9s66Guv/Hm649GJxfD09nn0KgtAYXjIJ5hC98lzugyhpVZuaBK3Jo0qnDPBL2gtAhcyf6l/ddoNRqUojRPIA8irp+9Ijckk9tM7MWXrYANPOKKuO9Hv7Ylp0J55653qIg8O+OpBA9qULLwk9yDSk94mToQZ7i5qdMNfCWVDmQrNKY+j3lh779nJQ2cBMiME4lLD1sP9P9VIPAWjP3GsOWYeSLPL8qp0iBCXh1hxj+cF5Rxk8Ky69361GisxmpuMMGdBJkRqtZSKLw2NzGVrhJN0/2VQuzGjv0yZNEGno+KgG7E1p8pBwFAPiyMTMsGaM0pkcV99/9kAEdMeqxWgUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KL+QP1qDwV2Jdt/D3PbFBW6EvKUJ05LbyqoktAEQxA=;
 b=TWKdWPvPnkio/LrDs2vzf9JVZ10zj3LeOuR6G7mWL2XDqxnhIC27BP2K34gXOtLngl0XzLZTaGQs2P+5TWXmm7BRt5EkWbBi2R5XcvHqHwEknBoETLftrepYSz1MAa7GwZUApqApXEl6BI6E8YT+cbvJF1XT28rq3j9vlQ5ThpU=
Received: from MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::10)
 by DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 15:53:06 +0000
Received: from SJ1PEPF000026C5.namprd04.prod.outlook.com
 (2603:10b6:303:8b:cafe::cf) by MW4P221CA0005.outlook.office365.com
 (2603:10b6:303:8b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.28 via Frontend Transport; Tue,
 28 Apr 2026 15:53:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C5.mail.protection.outlook.com (10.167.244.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:53:06 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:52:54 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <kinseyho@google.com>, <weixugc@google.com>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
Date: Tue, 28 Apr 2026 15:50:43 +0000
Message-ID: <20260428155043.39251-8-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C5:EE_|DM6PR12MB4465:EE_
X-MS-Office365-Filtering-Correlation-Id: 195495c4-9261-4a2a-ec13-08dea53e3cf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4Umv66NnVeJoHfKG+jQOjGkqwkFR4nihm0Mc2nOa2wvXfkrL136aQQLKyMGhNnEBbJ3NP9wu6o0Bi81oIJ78Ap0WgiEQTGj3lYxOMe4/Edbx7wsase9bcvUXAHEX76LfPzWuljVtEy5Ms6PtHMvsxJ8uJomVDEH9foLkxLxDg5JkTbqYN2Z6/QaQfLa0wP6UVgRCN1xIaIBMO2CYmkLNOLFuQTDx+dIw62QFKhY3B1ec+EWwZvtdNE6w32FC3pbjjrqZy5sxDPMA40vw1pIo/ll71Og6/4lJbqgDLA7rlvSD2aSi7cijFZ3TCSwfiKiBA6s3CcSmSnZwFIyXOo9hbSNHIeXSvJzNsv32Cuw/X/e7TCPoIphFIpUB5lS+3lxXmalxV+MRvyl6Rx8Wlroq0ChE+onh2eg2ZKayoFDj8DMxE+a8/hQaMdW5Fqlf/qfd0ORpIDuiUoUOjeZ+Ut4TRvhGoDycBlrJ9l6SEBpN+h6eZW3spQztZrX+gMeNY0xnDiEnd030c+HMyMRqew1Y5WwSqCdy8/xdOfhXFx135DVVDs3E+9YyXsziSC/xexLOFAn7WCuKu6ZsW2nkfnJ9Hn+XG0OUbkVhU3z8HywQ3I0e8xojXc5+FNG5srfO3Qk+r57d9RcYv7bn+A0trKG6KbiFVtAOuj3Ovlihlth7dSoTHuUAuNUe61HWKC7xYaqoSRa8JhyZCtq2e4dX7CuT/Acc4bJ5S8UNNKA2Vb2dOV7/fXbZOjydiJdEYe1J0+ZZuneqTqcBWTmGwO5EGyGAwA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QRIMIhXAh5wSW3vBCc/qAwF4h+UpOe4U8O/NAHXQW1bR00jFdlVMzY6KD3fsH+GBAzPGlQBU8Sbq7Oht3udynIsiIqYjmBpYayq67YarX5aC8coq1mb0dgpqZemAjr7OqNBZ/Z3qsbkk0VxH1jCTqnPdWW/LsRA3nAAY7+xsRtLgq1brd9rN8kUbDbcIFdFOZXn+LavQ4TlF7J76fVYE5wjUeJrEnSRHp/gSQtWvvLFyKKIeYOI7ijB8v62eOKK5ZU/LngXpGLPLRekm49oCRsVw5WdF0N+vIB3ypP+U+0cvltQHc0zohhBrHBMXxSXt2rJQACKyEyM2olsyxbjJ8ilc72KHCWrje1qDMIMUZCxDQkxOfssUGUrT7FH0t5teqQ1HgN3O6UM7CraOrWsNPu+3iyAyVF4VIdOyLHrAcJixPgNys7OD4ugvccwHCtMW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:53:06.0968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 195495c4-9261-4a2a-ec13-08dea53e3cf3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465
X-Stat-Signature: zgprfn8geabw3k5epdoauwi6wjfu5t6o
X-Rspamd-Queue-Id: 4D85C120012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777391597-522874
X-HE-Meta: U2FsdGVkX1+KzKgthAKxK6IH1+UAybgeyO5DjtxtPrBYRAT72YUWbMbDyU70FWYmU35j5ZiWJPB1hU7BwQaZgpCRa0k+/sEm6NNg5pNDPIsK7BO0zNu1YExhwmUeMdkVP7pRxGTa2a6F143mt3Oa08ht9h0ylNmku7ponXnB7e2lDF+cnsPVHFwRnvUzZ/8rB7ZWfLsunrqPrTwGnxf7coC0ZUEqh4HrIkhVOTrT1UnltzHGucOc0TaX+23wXjhHAqt270Sa23Yh9VmBF2bNe3pgs06UKPlrIJELIFcrFVhrQzliK/Nd8Yk1WgmXT1IfgV/PslSYylFPPiuVkoQpzOsgSGmjj+6khWyu26tcGVypwBoxe3iYljO1HDxZD1v4ggQUBqO7kBqlCm1g+FrA4nKN5KodghwAkTok7l/kMSO+Dr51qIlHYUvTNZMGRk9JzuJQ8+kBhlpq1sVmDgUE6hAgsCM262029OI0eyWJ38l3Bkmo22rlzCqZIO1SyV5MvfxgctjBa3RobfYS+VHeMATbgEy5oVaaX/ENmf/IVe+3yQ0wxYExiIcSe2qHy41gscvO5kYduaZilpVsethdrKkIkCo2OuuHRRvTe6naeiN5yVt1pKXniDfnYhabcb9gaQsOnVZKPjHsRKInaiammWWpEc1lrr8nl+YeP7g2dX1IcNj7VxW8zs6aIKCFAA4xDMBNPGLZkWvkMfOwFW8z0MVo4kmxHXx7GtU2Vup1HVcs8oVKOuP/9oePGlWSLVD1PtprjHdg6Mzddbl0fBgLtjNF87+gTCGk/DUOK8VYj8547lO+RZxDFPnVqS5132hfjIFMs3Bh3Zt/cNo9FwhNmeijfHu7ijQXO+FFjbymdqCGF+ZrA2u2Rrwl3LSTwRaFDK7869uqG5cUslZjIFqB96uTVoBCqZk9dWo0pUXY33uNXWjYXDl1kutFWzUeMxUC19XwtOup7yv1yhHxWIH
 I2VNozb5
 N24OFLQ8CDaVCIm3GBaWWZ5y5aIug9na9Uucyefo1BcEgM/ZDhJ2L0pQEVaJ7fC0WCeTkqX3NvHocM8h1XcyLoc6gS1Rww+nJs4LgFFkm9Z08wRsLVZLgo0I0Q8mptKvcEZz8WfOCNhxAfTY8lU74YHGKwzjMmwKRAX32pPR86RK+7ZllYXXE9gGKOkMYF0IOd3q95WvCk2JdLS6TFqlc8IMTJnLz9Sx5wRd80j6+rhT89cfjJ4UUD5fKC5MSCDNSI2uJQvkVZLyFy56n8yi94VreeR/5vVuA+yrbNSqET6tETGqJPO8X8PQeyTs7GN0anTXF5c+XRS9/G7x68w5HJI+mvCTH8205TBOcOVLgogno4upp6nyz2s0g8VSZlAAR0C8d28596RHsVYzD0tivMUXoLlP52//CLxyMbFL6TX5UhNgv3nAnvmJpQvNqW73BsqFuUf301q/hmnP5I27QNcmwNh0d01HdCGod78Qckq2xqm9XTJNNj8EgxpxjD7HPW0RC0oAYCbwvujBtHfqzzT7vKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a FOLIO_ALREADY_COPIED flag to the dst->migrate_info migration
state. When set, __migrate_folio() skips folio_mc_copy() and
performs metadata-only migration. All callers currently pass
already_copied=false. The batch-copy path enables it later in a
subsequent patch.

Move the dst->migrate_info state enum earlier in the file so
__migrate_folio() and move_to_new_folio() can see FOLIO_ALREADY_COPIED.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 53 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 03c2a6f7e5e4..c493e67e359d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -850,6 +850,19 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 }
 EXPORT_SYMBOL(folio_migrate_flags);
 
+/*
+ * To record some information during migration, we use the migrate_info
+ * field of struct folio of the newly allocated destination folio.
+ * This is safe because nobody is using it except us.
+ */
+enum {
+	FOLIO_WAS_MAPPED = BIT(0),
+	FOLIO_WAS_MLOCKED = BIT(1),
+	FOLIO_ALREADY_COPIED = BIT(2),
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED |
+			   FOLIO_ALREADY_COPIED,
+};
+
 /************************************************************
  *                    Migration functions
  ***********************************************************/
@@ -859,14 +872,20 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 			   enum migrate_mode mode)
 {
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
+	bool already_copied = (dst->migrate_info & FOLIO_ALREADY_COPIED);
+
+	if (already_copied)
+		dst->migrate_info = 0;
 
 	/* Check whether src does not have extra refs before we do more work */
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
-	if (unlikely(rc))
-		return rc;
+	if (!already_copied) {
+		rc = folio_mc_copy(dst, src);
+		if (unlikely(rc))
+			return rc;
+	}
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc)
@@ -1090,7 +1109,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
  *     0 - success
  */
 static int move_to_new_folio(struct folio *dst, struct folio *src,
-				enum migrate_mode mode)
+		enum migrate_mode mode, bool already_copied)
 {
 	struct address_space *mapping = folio_mapping(src);
 	int rc = -EAGAIN;
@@ -1098,6 +1117,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
 	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
 
+	if (already_copied)
+		dst->migrate_info = FOLIO_ALREADY_COPIED;
+
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
 	else if (mapping_inaccessible(mapping))
@@ -1129,17 +1151,6 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	return rc;
 }
 
-/*
- * To record some information during migration, we use the migrate_info
- * field of struct folio of the newly allocated destination folio.
- * This is safe because nobody is using it except us.
- */
-enum {
-	FOLIO_WAS_MAPPED = BIT(0),
-	FOLIO_WAS_MLOCKED = BIT(1),
-	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
-};
-
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
@@ -1353,7 +1364,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct folio *src, struct folio *dst,
 			      enum migrate_mode mode, enum migrate_reason reason,
-			      struct list_head *ret)
+			      struct list_head *ret, bool already_copied)
 {
 	int rc;
 	int old_folio_state = 0;
@@ -1379,7 +1390,7 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 		src_partially_mapped = folio_test_partially_mapped(src);
 	}
 
-	rc = move_to_new_folio(dst, src, mode);
+	rc = move_to_new_folio(dst, src, mode, already_copied);
 	if (rc)
 		goto out;
 
@@ -1536,7 +1547,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	}
 
 	if (!folio_mapped(src))
-		rc = move_to_new_folio(dst, src, mode);
+		rc = move_to_new_folio(dst, src, mode, false);
 
 	if (page_was_mapped)
 		remove_migration_ptes(src, !rc ? dst : src, ttu);
@@ -1720,7 +1731,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *ret_folios,
 		struct migrate_pages_stats *stats,
 		int *retry, int *thp_retry, int *nr_failed,
-		int *nr_retry_pages)
+		int *nr_retry_pages, bool already_copied)
 {
 	struct folio *folio, *folio2, *dst, *dst2;
 	bool is_thp;
@@ -1737,7 +1748,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 
 		rc = migrate_folio_move(put_new_folio, private,
 				folio, dst, mode,
-				reason, ret_folios);
+				reason, ret_folios, already_copied);
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
@@ -1994,7 +2005,7 @@ static int migrate_pages_batch(struct list_head *from,
 		migrate_folios_move(&unmap_folios, &dst_folios,
 				put_new_folio, private, mode, reason,
 				ret_folios, stats, &retry, &thp_retry,
-				&nr_failed, &nr_retry_pages);
+				&nr_failed, &nr_retry_pages, false);
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
-- 
2.43.0


