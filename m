Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3DCF3C240
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A896B008A; Mon,  9 Mar 2026 08:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A466B0095; Mon,  9 Mar 2026 08:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FA76B009D; Mon,  9 Mar 2026 08:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69CAB6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:12:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CA7BB42C8
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:12:04 +0000 (UTC)
X-FDA: 84526411368.25.982DE29
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011045.outbound.protection.outlook.com [52.101.57.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 10B5140006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:12:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eyVneOux;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.45 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anzeTeLieTQNE724hLeCdyNgyUWdCBnBwzbDi1FBssI=;
	b=SfyrHKY9O01cFXmMwB98otHhyUwLuXAtJ5/b8exnXGt/UW5Hw0ljPkm5NEFfJO9AVJZ+Gx
	F+hcI9/NCzGk0XAEyFwvrut8ohhqx7pcHiK1cSoKZ73Oulur3ugSaD1abNfqfn6BY/FfJo
	ANVAnpdqbNb0KHNFAiUg4+usH3qS08g=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=eyVneOux;
	spf=pass (imf17.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.45 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058321; a=rsa-sha256;
	cv=pass;
	b=SqLq/QdcJR4NiSY9PCVWKsHA8RTCkSYYcd+RZE4ah5Pw5dfbQBwIcz18s5D4B0swYJz6+Z
	eS4oQXv9rjDHjeNYhz/4PiCGYqzvMZbbZqvUnszM9s1rrZcvh4YVFK7K6Xb6RZl1MTrT7T
	W6Yi2GJxrLFFnI3TkGngtkgDlmrkFKM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHDH+WkgPz9bC7zjQirkLqnIQnR3AuYLYpQMYLCcKouYo77PEP3anaMG3gBuf/JY+DXsa5Svs4X48Cn+biMqwsfSJBNhA5ydgiDlSWiRGEYCZV/EjXqSIZBr/2QFw1VYYyQUa3D8hUI9RbfrQ3yU9kkb1v3k/q1AzZdNk+Vh02qowYhyEYYVFDkYTzdkznuaXWMl4qh1rRFTTI/+bIFGg7aefrdk2W6cEaqA5X4gfFbmf/4u2nrT+qAhdMjJwVW2hdBC46+Juwc/Iug01h7eyyNSWPERjWDBPq4kfvuX2CbQDveaxGWvy48icz8yim/xbQo6CNtxYRpSUdr85pn4iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anzeTeLieTQNE724hLeCdyNgyUWdCBnBwzbDi1FBssI=;
 b=C+xX69SnXoGSM0gCo/YrPIQ38ibNAQNqBA7mIgUBRTJwVdtnlDVX01YgcNEIKJ/7vhOJpjCeDezHx7o7AcON1MsGYU4butH13ggbkRnwMA04N8kIS1fscx2TxpLEOgm21uUjdHT505GJ17gfzzf5ON9rMFQq8uA6PulxdA+0mESUm+Xv/8lsxjgegBdtwLPoLf0n+PXrTwyOVdvi07pBJpINDiZ98L/fA1zFyxL+Kb5nXf/93qlAnZEFcaoaOPz5AjbUwyTHAiy7mnhyMZRebmsXnGyN97W5/XRu+yvf3IP/26BuD2B0AtuCalQ0/Ojgflyqw3GRlxZ7ox4+GwbXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anzeTeLieTQNE724hLeCdyNgyUWdCBnBwzbDi1FBssI=;
 b=eyVneOux+A+OJJOONRu/ym2sP7K3zStgs7gNLj77i7LTSo/mg29UqwQY+8IH2gnl9a33ZBqONLJN6uJ2GAFICkZp7UHAfI7Ljs69lmasHeJoeVDSmmKgJPx02UcdLqytIy2p7G8QMMxgQZiJ/pmqiNxyilTBh0B+6XLKzfHiQbU=
Received: from CH0PR03CA0320.namprd03.prod.outlook.com (2603:10b6:610:118::25)
 by DM4PR12MB7744.namprd12.prod.outlook.com (2603:10b6:8:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Mon, 9 Mar
 2026 12:11:54 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::d5) by CH0PR03CA0320.outlook.office365.com
 (2603:10b6:610:118::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Mon,
 9 Mar 2026 12:11:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:11:54 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:11:54 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:11:43 -0500
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
Subject: [RFC PATCH v4 5/6] drivers/migrate_offload: add DMA batch copy driver (dcbm)
Date: Mon, 9 Mar 2026 12:07:31 +0000
Message-ID: <20260309120725.308854-14-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|DM4PR12MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 644dac95-d683-4618-bf05-08de7dd50dcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	7RW3hqrCdSZKsVeWlqsPm1LV82XtdiOMqS1SLZPTNtp2hS1Mjac19gXez2lpkQJBM7Bq4QYl/5zGQIpGevdrhhPDngA5DVu2ORAXU869/MLdj8aF4DBSjG/ApH3x6eex7TMruy3tPgVgeoOvw1u5KGyhFBRKNIf1gWTmt+Yokgzaa7ipj9n4YS3VQibazRH40tAfNz6vLuC7g5lFYMjoqxRCL+d5ly8Vu/W23Qp3sW6x3Lp+kLM+koRSGVb9qdzNLyZQNYkcABOEkXWqsy16xTQ02GKsI9Koe955VTMbD+gbdiNXbWNFfVOKGpinDcbMhV0JEvE1t+YxO804Irgg5RSpFh6RQm7LbBa9PlMSD91dAJvb4MXDWj/DdZflCC7sjys5sEliuC7SGf/ffzPWLnwB92cTC2EFuTPLyRSQAra+CGpFsup8pFi1vSY3FyActiRZmfaz4xcPfYoNHte+gDYB+d/Wo80fRY535YcKti4tBaHSfWf3NTRzaQmRo6hodRGKByh7wKGSsDxyuc7fMcQKhr/wxuBl33ykqD+nmJShdrGs2ieryBWDGFcqMRQmeTFcqI2vwMwYxOnMMf9TG6g+ESdZiuRvAPjYRIlZnXEruOnv49J02zQLuQma6XFXLJRJsJryAVZj5sOJouL1EK7O77IrD1HG2QPOeAmyw1cHPmOqL3w3Vunz3yvPBU6TwHEDHar0RzLVW9fL3bo480ikT7+Z6tBODvYmcAfhlZYRCGXYM8O5RhNoSEDCpkJsY/Uj+sfuObv0fJQgUH8IHA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rZN+7itx5mdCyLfki9kYUkMqalAkpwYOhWyEBVq3I+w4fnBso8vPLW0EYujz0S1ws2VtAfk/xIezrb1WphXQImPUtWyDTeVrbPEs1Tu2JRP7T2I3FyfPlI+qg2+K9oZvDFWf64t7ZlcTseO5oFCQVV+vT3PCqZMWwUXEEhUXjGPPV+dVhVBHCNMgc3xNdhAVOs9v31Lm5YbxrzDJOsSC0Sec4qzg8QgVj0EHzUTA2Cx6xp2zdSowL8cK17iluib26SdoOQmVp5XQNQPjHbiNM4B9CMmLVxZvm3pCvvfGFe6GiaSOtub5BZrsowP2zmQEbdQRcDufG/F/yI1lYsCFNzrB/o0Ki9qopUCAA/fCN3EpeoZZqtt1w77gjT9HO/TXV9oPNOaiZQYsyzEivjSxIhu322eJv7CAGqLB0tNZz/dIL0qqe5bY9dG7ur041hHy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:11:54.5757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 644dac95-d683-4618-bf05-08de7dd50dcd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7744
X-Stat-Signature: 1uaef5xo59maabye8iruniz16hndiksk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 10B5140006
X-HE-Tag: 1773058320-759558
X-HE-Meta: U2FsdGVkX19H3H4Y8bAvgS2Typiv7YWqTEuzKIQliqDhBTAGWVnZsjWkemw5zheJOpFNc+yXJj2KytV5YKMuOxfFURKWXt7vEpG/0nm4iKkIl4zV2w2k8NDZYnnrsLF6jDgZ+3cQJD3F2vbGW+nGuVrYYePGoAE4CGbY/pksM+x0KeBJrLNmz4hgI6dbN4TfNJ8ufw2Blf1eFtqlcZbeIpcFO/7ifFdxU6CDOCvJE6hE4Kpqbj55Qh9MYOtQWKt0qoC4W+JIl46WLII9ieRckf1nyDkSeMTg0R07TG43nrNhTX12krdfJuTUAWLI4k4WhPijCYesp63rpcm8HFdxC88WIIym3fB3WVlNCXeA1rxdk3BI4TU6Wfcr1sMEJAoVP6uCSdpsz7rVZxm1BEdQSQ2M2jOc8keSR7/XymwbjFe95fpkJMFu09eVshN8rmUpGPmem5Bgd4ee0CLdIk0mafA+Ex8789E8t0AlwakErpPQ1yavSuUJikSGCw5pVvKkfYrmFR9uP3gHgUKvUXgAnccxWQzGVYqsDf0179SdAOJqE6YCOEYu7PFdcRILYlYHuCwoDpB0/t6KojqtvkBJnHoyJ3SksPP57YEJiCDTtQ77IpGO9HKfNWWITlEtKPedr3QDd/KEuQjDk03ZUsVJn2tnLTlyhZqvncLMScS84aLXgkOOfZEJ3fyN7ffeA7goE6Rv1cqteEhxObOXltiX4SPW3JMc/u+xaDYdGENQ00rFT7TnE1fN/ibwjEp1F4xNIH/YS5fXOBf5YvE5K9KN4KK79kkJvZy/G7aHmnkElXgD+LnJBRbz351QYh6uzWVoTjniyokW+cPwKgZ7IZgHlnwQKQbX3CSJ1VgsQsupRQK/F4xMGRjRmnGJBOSey0aBIIPYOiMHpSDn12wIXAvAT/r3ek5pdQcr13T0BuPu4t10QoSfjgIrLI3q4i+TpVPqU39kxaSDjB4WBs5LJWQ
 piOZeasb
 ji5WiPm6LYpsbfr2k4XW/CZ6ROKu0kpNNvvO0nuQ8bo3O4x+lHLtJ2MGPoAXvIuXn0lceaVZSL4qnquinn5YmtO5ZAkuWlQGkKNwce0PGOewEcIXXLGb/wbyJxCWTHrqdScV8Ztbvtjw3OeQs1CBvzJ6IDSQB71FKWwiOGKfxM03p+4ShOY2rWoaLdpxFtDsrFd5MHtv+dVyldwx+xcR1hGTurO51g6OfRd5ozTJvS1MvV7jtwBooBuRgh+25QL6Hx/nOobi3D5c8mlSaG6fU6K2D8OwrAzJn+JIQc9+MjZinZAswJm48ztIZiQ11gl4AeKHeWs5TtJMBgryK9YTviB/ZkRerHcn3RbuwIK3aoYF6d9//Z1tUxcqM6j2QhYOBUVjPtWEVuKu9eXS6padYkSlramH2nXp8uybGwASs3TsRwx0s3PVvtgoB7LTp6O5Addz/Rh50GUfOf8hIHpODrNb1UghuTqU56zOwJxSfrR5idwTc9EuyWHgip37uWioIgrvDVh6207ihhNslZit3G3ceMWMwZUtpSoAT3A40fUEJaccKg9IrlsMg72qAIlCjs/4a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simple DMAEngine based driver that uses memcpy channels to batch-copy
folios during page migration. Primarily for testing the copy offload
infrastructure.

When DMA fails the callback returns an error and the migration path
falls back to per-folio CPU copy.

Sysfs interface under /sys/kernel/dcbm/:
  offloading      - enable/disable DMA offload
  nr_dma_chan     - max number of DMA channels to use
  folios_migrated - folios copied via DMA
  folios_failures - fallback count

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   8 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 457 ++++++++++++++++++++++++++
 6 files changed, 471 insertions(+)
 create mode 100644 drivers/migrate_offload/Kconfig
 create mode 100644 drivers/migrate_offload/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/dcbm.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index c0f1fb893ec0..3dbea1380603 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -255,4 +255,6 @@ source "drivers/cdx/Kconfig"
 
 source "drivers/resctrl/Kconfig"
 
+source "drivers/migrate_offload/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 53fbd2e0acdd..f55bddf490cc 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -42,6 +42,8 @@ obj-y				+= clk/
 # really early.
 obj-$(CONFIG_DMADEVICES)	+= dma/
 
+obj-$(CONFIG_MIGRATION_COPY_OFFLOAD)	+= migrate_offload/
+
 # SOC specific infrastructure drivers.
 obj-y				+= soc/
 obj-$(CONFIG_PM_GENERIC_DOMAINS)	+= pmdomain/
diff --git a/drivers/migrate_offload/Kconfig b/drivers/migrate_offload/Kconfig
new file mode 100644
index 000000000000..0bbaedbae4ad
--- /dev/null
+++ b/drivers/migrate_offload/Kconfig
@@ -0,0 +1,8 @@
+config DCBM_DMA
+	bool "DMA Core Batch Migrator"
+	depends on MIGRATION_COPY_OFFLOAD && DMA_ENGINE
+	help
+	  DMA-based batch copy engine for page migration. Uses
+	  DMAEngine memcpy channels to offload folio data copies
+	  during migration. Primarily intended for testing the copy
+	  offload infrastructure.
diff --git a/drivers/migrate_offload/Makefile b/drivers/migrate_offload/Makefile
new file mode 100644
index 000000000000..9e16018beb15
--- /dev/null
+++ b/drivers/migrate_offload/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DCBM_DMA)		+= dcbm/
diff --git a/drivers/migrate_offload/dcbm/Makefile b/drivers/migrate_offload/dcbm/Makefile
new file mode 100644
index 000000000000..56ba47cce0f1
--- /dev/null
+++ b/drivers/migrate_offload/dcbm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DCBM_DMA) += dcbm.o
diff --git a/drivers/migrate_offload/dcbm/dcbm.c b/drivers/migrate_offload/dcbm/dcbm.c
new file mode 100644
index 000000000000..89751d03101e
--- /dev/null
+++ b/drivers/migrate_offload/dcbm/dcbm.c
@@ -0,0 +1,457 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DMA Core Batch Migrator (DCBM)
+ *
+ * Uses DMAEngine memcpy channels to offload batch folio copies during
+ * page migration. Reference driver meant for testing the offload
+ * infrastructure.
+ *
+ * Copyright (C) 2024-26 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/migrate.h>
+#include <linux/migrate_copy_offload.h>
+
+#define MAX_DMA_CHANNELS	16
+
+static unsigned long long folios_migrated;
+static unsigned long long folios_failures;
+
+static bool offloading_enabled;
+static unsigned int nr_dma_channels = 1;
+static DEFINE_MUTEX(dcbm_mutex);
+
+struct dma_work {
+	struct dma_chan *chan;
+	struct completion done;
+	atomic_t pending;
+	struct sg_table *src_sgt;
+	struct sg_table *dst_sgt;
+	bool mapped;
+};
+
+static void dma_completion_callback(void *data)
+{
+	struct dma_work *work = data;
+
+	if (atomic_dec_and_test(&work->pending))
+		complete(&work->done);
+}
+
+static int setup_sg_tables(struct dma_work *work, struct list_head **src_pos,
+		struct list_head **dst_pos, int nr)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct device *dev;
+	int i, ret;
+
+	work->src_sgt = kmalloc_obj(*work->src_sgt, GFP_KERNEL);
+	if (!work->src_sgt)
+		return -ENOMEM;
+	work->dst_sgt = kmalloc_obj(*work->dst_sgt, GFP_KERNEL);
+	if (!work->dst_sgt)
+		goto err_free_src;
+
+	ret = sg_alloc_table(work->src_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_dst;
+	ret = sg_alloc_table(work->dst_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_src_table;
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	for (i = 0; i < nr; i++) {
+		struct folio *src = list_entry(*src_pos, struct folio, lru);
+		struct folio *dst = list_entry(*dst_pos, struct folio, lru);
+
+		sg_set_folio(sg_src, src, folio_size(src), 0);
+		sg_set_folio(sg_dst, dst, folio_size(dst), 0);
+
+		*src_pos = (*src_pos)->next;
+		*dst_pos = (*dst_pos)->next;
+
+		if (i < nr - 1) {
+			sg_src = sg_next(sg_src);
+			sg_dst = sg_next(sg_dst);
+		}
+	}
+
+	dev = dmaengine_get_dma_device(work->chan);
+	if (!dev) {
+		ret = -ENODEV;
+		goto err_free_dst_table;
+	}
+	ret = dma_map_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_free_dst_table;
+	ret = dma_map_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_unmap_src;
+
+	if (work->src_sgt->nents != work->dst_sgt->nents) {
+		ret = -EINVAL;
+		goto err_unmap_dst;
+	}
+	work->mapped = true;
+	return 0;
+
+err_unmap_dst:
+	dma_unmap_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_unmap_src:
+	dma_unmap_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_free_dst_table:
+	sg_free_table(work->dst_sgt);
+err_free_src_table:
+	sg_free_table(work->src_sgt);
+err_free_dst:
+	kfree(work->dst_sgt);
+	work->dst_sgt = NULL;
+err_free_src:
+	kfree(work->src_sgt);
+	work->src_sgt = NULL;
+	return ret;
+}
+
+static void cleanup_dma_work(struct dma_work *works, int actual_channels)
+{
+	struct device *dev;
+	int i;
+
+	if (!works)
+		return;
+
+	for (i = 0; i < actual_channels; i++) {
+		if (!works[i].chan)
+			continue;
+
+		dev = dmaengine_get_dma_device(works[i].chan);
+
+		if (works[i].mapped)
+			dmaengine_terminate_sync(works[i].chan);
+
+		if (dev && works[i].mapped) {
+			if (works[i].src_sgt) {
+				dma_unmap_sgtable(dev, works[i].src_sgt,
+						DMA_TO_DEVICE,
+						DMA_ATTR_SKIP_CPU_SYNC |
+						DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].src_sgt);
+				kfree(works[i].src_sgt);
+			}
+			if (works[i].dst_sgt) {
+				dma_unmap_sgtable(dev, works[i].dst_sgt,
+						DMA_FROM_DEVICE,
+						DMA_ATTR_SKIP_CPU_SYNC |
+						DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].dst_sgt);
+				kfree(works[i].dst_sgt);
+			}
+		}
+		dma_release_channel(works[i].chan);
+	}
+	kfree(works);
+}
+
+static int submit_dma_transfers(struct dma_work *work)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct dma_async_tx_descriptor *tx;
+	unsigned long flags = DMA_CTRL_ACK;
+	dma_cookie_t cookie;
+	int i;
+
+	atomic_set(&work->pending, 1);
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
+		if (i == work->src_sgt->nents - 1)
+			flags |= DMA_PREP_INTERRUPT;
+
+		tx = dmaengine_prep_dma_memcpy(work->chan,
+				sg_dma_address(sg_dst),
+				sg_dma_address(sg_src),
+				sg_dma_len(sg_src), flags);
+		if (!tx) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+
+		if (i == work->src_sgt->nents - 1) {
+			tx->callback = dma_completion_callback;
+			tx->callback_param = work;
+		}
+
+		cookie = dmaengine_submit(tx);
+		if (dma_submit_error(cookie)) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+		sg_dst = sg_next(sg_dst);
+	}
+	return 0;
+}
+
+/**
+ * folios_copy_dma - copy a batch of folios via DMA memcpy
+ * @dst_list: destination folio list
+ * @src_list: source folio list
+ * @nr_folios: number of folios in each list
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+static int folios_copy_dma(struct list_head *dst_list,
+		struct list_head *src_list, unsigned int nr_folios)
+{
+	struct dma_work *works;
+	struct list_head *src_pos = src_list->next;
+	struct list_head *dst_pos = dst_list->next;
+	int i, folios_per_chan, ret;
+	dma_cap_mask_t mask;
+	int actual_channels = 0;
+	unsigned int max_channels;
+
+	max_channels = min3(nr_dma_channels, nr_folios,
+			(unsigned int)MAX_DMA_CHANNELS);
+
+	works = kcalloc(max_channels, sizeof(*works), GFP_KERNEL);
+	if (!works)
+		return -ENOMEM;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	for (i = 0; i < max_channels; i++) {
+		works[actual_channels].chan = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(works[actual_channels].chan))
+			break;
+		init_completion(&works[actual_channels].done);
+		actual_channels++;
+	}
+
+	if (actual_channels == 0) {
+		kfree(works);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		folios_per_chan = nr_folios * (i + 1) / actual_channels -
+				(nr_folios * i) / actual_channels;
+		if (folios_per_chan == 0)
+			continue;
+
+		ret = setup_sg_tables(&works[i], &src_pos, &dst_pos,
+				folios_per_chan);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		ret = submit_dma_transfers(&works[i]);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) > 0)
+			dma_async_issue_pending(works[i].chan);
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) == 0)
+			continue;
+		if (!wait_for_completion_timeout(&works[i].done,
+				msecs_to_jiffies(10000))) {
+			ret = -ETIMEDOUT;
+			goto err_cleanup;
+		}
+	}
+
+	cleanup_dma_work(works, actual_channels);
+
+	mutex_lock(&dcbm_mutex);
+	folios_migrated += nr_folios;
+	mutex_unlock(&dcbm_mutex);
+	return 0;
+
+err_cleanup:
+	pr_warn_ratelimited("dcbm: DMA copy failed (%d), falling back to CPU\n",
+			ret);
+	cleanup_dma_work(works, actual_channels);
+
+	mutex_lock(&dcbm_mutex);
+	folios_failures += nr_folios;
+	mutex_unlock(&dcbm_mutex);
+	return ret;
+}
+
+/* TODO: tune based on usecase */
+static bool dma_should_batch(int reason)
+{
+	if (reason == MR_SYSCALL || reason == MR_COMPACTION || reason == MR_DEMOTION ||
+	    reason == MR_NUMA_MISPLACED)
+		return true;
+	return false;
+}
+
+static struct migrator dma_migrator = {
+	.name = "DCBM",
+	.offload_copy = folios_copy_dma,
+	.should_batch = dma_should_batch,
+	.owner = THIS_MODULE,
+};
+
+static ssize_t offloading_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", offloading_enabled);
+}
+
+static ssize_t offloading_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	bool enable;
+	int ret;
+
+	ret = kstrtobool(buf, &enable);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dcbm_mutex);
+
+	if (enable == offloading_enabled)
+		goto out;
+
+	if (enable) {
+		ret = migrate_offload_start(&dma_migrator);
+		if (ret) {
+			mutex_unlock(&dcbm_mutex);
+			return ret;
+		}
+		offloading_enabled = true;
+	} else {
+		migrate_offload_stop(&dma_migrator);
+		offloading_enabled = false;
+	}
+out:
+	mutex_unlock(&dcbm_mutex);
+	return count;
+}
+
+static ssize_t folios_migrated_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", folios_migrated);
+}
+
+static ssize_t folios_migrated_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	mutex_lock(&dcbm_mutex);
+	folios_migrated = 0;
+	mutex_unlock(&dcbm_mutex);
+	return count;
+}
+
+static ssize_t folios_failures_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", folios_failures);
+}
+
+static ssize_t folios_failures_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	mutex_lock(&dcbm_mutex);
+	folios_failures = 0;
+	mutex_unlock(&dcbm_mutex);
+	return count;
+}
+
+static ssize_t nr_dma_chan_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", nr_dma_channels);
+}
+
+static ssize_t nr_dma_chan_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 1 || val > MAX_DMA_CHANNELS)
+		return -EINVAL;
+
+	mutex_lock(&dcbm_mutex);
+	nr_dma_channels = val;
+	mutex_unlock(&dcbm_mutex);
+	return count;
+}
+
+static struct kobj_attribute offloading_attr = __ATTR_RW(offloading);
+static struct kobj_attribute nr_dma_chan_attr = __ATTR_RW(nr_dma_chan);
+static struct kobj_attribute folios_migrated_attr = __ATTR_RW(folios_migrated);
+static struct kobj_attribute folios_failures_attr = __ATTR_RW(folios_failures);
+
+static struct attribute *dcbm_attrs[] = {
+	&offloading_attr.attr,
+	&nr_dma_chan_attr.attr,
+	&folios_migrated_attr.attr,
+	&folios_failures_attr.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(dcbm);
+
+static struct kobject *dcbm_kobj;
+
+static int __init dcbm_init(void)
+{
+	int ret;
+
+	dcbm_kobj = kobject_create_and_add("dcbm", kernel_kobj);
+	if (!dcbm_kobj)
+		return -ENOMEM;
+
+	ret = sysfs_create_groups(dcbm_kobj, dcbm_groups);
+	if (ret) {
+		kobject_put(dcbm_kobj);
+		return ret;
+	}
+
+	pr_info("dcbm: DMA Core Batch Migrator initialized\n");
+	return 0;
+}
+
+static void __exit dcbm_exit(void)
+{
+	mutex_lock(&dcbm_mutex);
+	if (offloading_enabled) {
+		migrate_offload_stop(&dma_migrator);
+		offloading_enabled = false;
+	}
+	mutex_unlock(&dcbm_mutex);
+
+	sysfs_remove_groups(dcbm_kobj, dcbm_groups);
+	kobject_put(dcbm_kobj);
+	pr_info("dcbm: DMA Core Batch Migrator unloaded\n");
+}
+
+module_init(dcbm_init);
+module_exit(dcbm_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Shivank Garg");
+MODULE_DESCRIPTION("DMA Core Batch Migrator");
-- 
2.43.0


