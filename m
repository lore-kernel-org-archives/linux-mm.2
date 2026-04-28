Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3CBFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D709A6B009B; Tue, 28 Apr 2026 11:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D489C6B009D; Tue, 28 Apr 2026 11:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37E36B009E; Tue, 28 Apr 2026 11:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFED56B009B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:55:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 825E7403CF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:55:20 +0000 (UTC)
X-FDA: 84708414000.15.AE21813
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	by imf29.hostedemail.com (Postfix) with ESMTP id 743BE12000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:55:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=2BLsKEUU;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLV+myZqiJhgtZuZ2oncD5LtNGMPg1yB0LDSwCOUPqQ=;
	b=D2FqoGBzpi9FdZiMC65sb5Dp4/zkNNujM4X7nzcOUoP6UKMLTglkXDB8Bqc2U8wHBif19i
	6rMJRkRpXB/0TOlhJabofRaNw15MX+/R7k7UoxEsmOnq9vw1PcQykrdAGHpd767cX1qGcH
	wkkR+ZlDIHP9U+tY49JcaSJVqjOTWRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391717; a=rsa-sha256;
	cv=pass;
	b=GWpzvssBIiw5/Pu1cy0WRAoNDflCnn8y8eGasJIs5nI/9++oz8jEGiXqwlHNFbTG/47E7L
	yKCEhwrp980JxVjkiSua4nD8k5rPCNaGDRLXzyGp3EA2TlYqSjAf+3oetjY/o2MOwkvFa/
	/hA9IDCbPQvQsU/Z2fzNAThGVip+gtM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=2BLsKEUU;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.67 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMU2mzX1eNkjXFsCRTNvfZ2cJ+LLa2wBpXZmm371hYaBkfHzrX0YtUb9Za9tWlkRUdNDjXFSoJhYbwZgtlWLoHb02vbPaK0pOutej2mx8omfeJXPxlnP1VTuhlhd4iZeImO6kyM3ULykylvglXREIos4LkSznd9IVWw/cKsXLvJuVA14I9IAtHSDmnTgxjBtrl3OJtDXpDFXZ6pdRZWU2UV8SalL/FoF/SkUU6hyj3Az/ZHwqziuP7aAtcyIu8BmW6gBcoxTvbf9qFRNbZXLM/R0JmTiBsiSM83MsXUz7E+vxrhsBAjmh6TpJCtRqfMlIhYhagHyPgXAuL+Fb6jaXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLV+myZqiJhgtZuZ2oncD5LtNGMPg1yB0LDSwCOUPqQ=;
 b=AzkWfdAWcGScq3ye+XEm/7+lospG4loAj+ys08l6ubbtk9y3kZ8HYGZXCqTiYgvx9uPTcpW5E8BTkFjgzogLHIqqeVcXsMeXjykWKgEsJQLwVS1Q43fjZSHRV8v7QAvkif7U0DYNihLv/cl0gmo07yJG7yMJKX7FFW/+yyIJhWuLSOm0Nnkc/y4EAtSjvQNVcNmzrGlYyb2/GpTk/34zX4XMY9iVjIZakdDtqyIXkiOQHSghfPKIDdeJuKywLRKeeOFSbhvBvnQnRkpFFCSupj1UnM2hZThxnYvSLiLqIkUDR4RZ2Q7NiHWlxS6l33yUkTBniwVwHz0d2zfq84MG+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLV+myZqiJhgtZuZ2oncD5LtNGMPg1yB0LDSwCOUPqQ=;
 b=2BLsKEUUoJ5MXIc1rJyKuWm5oAsBaYK/RnmqNWzv3kzmWv+4NONKLgD1Z8B9sXnfpDx4FHKf6Ttbk4t5UhH1OdjoB8pltDmtwQyirtyzYUYDK2Pu/i7AY14Qnqv3W++CpSo4Xm8y8eWNIdn/HwSoN/zLYaKeasy4+H1tCXhjFpg=
Received: from BL1PR13CA0174.namprd13.prod.outlook.com (2603:10b6:208:2bd::29)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 15:55:09 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:2bd:cafe::ed) by BL1PR13CA0174.outlook.office365.com
 (2603:10b6:208:2bd::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 15:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:55:09 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:54:58 -0500
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
Subject: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver (dcbm)
Date: Tue, 28 Apr 2026 15:50:49 +0000
Message-ID: <20260428155043.39251-14-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|DM6PR12MB4250:EE_
X-MS-Office365-Filtering-Correlation-Id: a29eb70a-b7fa-4a2d-298a-08dea53e866c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|82310400026|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Z/+rMGUAOuO+Iwitu6KmMdkwiAEkLkIagKFfeGq3PfaXmEmBpdnRl4RetNerDY9XCwbr2S8fK2g1O3KmCTeM8RQO9J8LoALaeXDkiQ3jea9EbVyMAlttYUccow9PI4I+oeQ0RAaYHr0O6kDSpXJ1rAMQSO++J96piAjLuEx+73GERLCJUUdsjm4GMcERFoUj0F45Z7h3zSDHIlF3QwiW+zwxk5+vSYx3CKLpuyOFC000/gihTaUyDZn3GrJb+/sj4lw5pQFhHS39QNDHd3e0fb9V57YXx203yWQOPSZ/Jt5RsNl9t5u4EIrGFeMTk+72D65c5kZjI3t7d4/ZD83CVIsX5GWbl84FhpbTJeYJ5T4E94ngiZ6LozDDbhgbqCL1ecF8pY/IFo9E0jSr4iB76ad1QrdyILcpALxjMdqGB+9Mt9qQPwYSwEJ/0yj17bEa2IfMrTYanRH036z04/8vkAW/nkYOj5iopBX1Utt6rPPZy7ENrr9VGjUaFq9qZmLEUVDlbWwX4s/i0rzDB/FEhrYMeWPLRfVI9Ys+ShMA0WUiqX/cv9FxbDGLB+9+wzA6P2G2QeJ0fAWY0oMZsioz+RxIa5EkKIzN778rRYqT0o+yy3J1TaQuSjXr4TVHUmTQd8hfzXY9Sz/oGaDBGhvgJIrGFxuKDOX/z2yOIX+7y4sxIqSSLlHyeueTXsaidzgvcToPIZjywXJCsvNzz6OeC7W0umGAc27y9eljZ+V7rx102yOn3r+C0TKRqjagIHqWKVQ5pU1UqxQ9HSrndfGYtw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(82310400026)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dggU02yw0L+0mjuzLyf3BqW0Fnc6caot1XUuaag1Js5C0Zm95fz+EOUtlsAMqKHkRJsiMtE1MIQt6G5wixVW2H9Wi3oUBsplP3ZXkN03hFZnaDV4hVNK/FBQO+QrQv5dIdAvunHSn068/dj8jrWbHy6JQmIKqmM9dxrZupQap8mswfXMCUUxKwG7uOrQGeJnEnKJ2REWB8YrnKHWxY13cdloTQfRuyN9EsXMB4CJniA8WNluTOUgVOjjtNq1T1uH3nzlwc8usSkn//p0yARMm9tnqJa/5oY0P5ytHSq8jyWBo5jmgLiNaL2JMUfYZaS80nHhBkwCF3+LciReUZ/JkILxGLuKcb7/2+ddZIUPEmgZ3576giBgoLStNBdRWT+Rb2kLt5cOZHe4IWtAUNYctaBnftHYmi6MTZeFr7sydF7VCUeBONjn+KHXI3HAybas
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:55:09.4542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a29eb70a-b7fa-4a2d-298a-08dea53e866c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4250
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 743BE12000F
X-Stat-Signature: 6tmkuaebcx94z5gpfr5hxk6bfbbpy1j1
X-Rspam-User: 
X-HE-Tag: 1777391717-839869
X-HE-Meta: U2FsdGVkX1+IN6+tsjmb+G+we2A1gT/Ynd2VqwAuPahGMSbu+q+DsPdtfCrGmyGEMbmRdhABG3kY8B9Tn9Xv1eJYv5hb+mtY7LbuLbflFwzlJbf5IooAXzedshxIIvTkAeHOOBrL0Ac3Zw+pEa0KQJWiBihKOJFz/u66W9VFAlnFYrCcx56VaTeADlhF+fM1uRmmbFfKJw3s655WiZfrlNdhJtvjIl+08Gt+c12UQgeBUqj9rioCNu/4qSOph+yyPxrLedB2oQO6fBOHgz+4R2s7se2XU0W8cXLi09WH+wCrcwYzarK6oGF+/ZNYzZrsqytS3Bie0dWjQSSf+2NKED265O1H0CHW67T44Izbmw8egEPfuP12vPZpzbdaM1VvD63ydD+j1xUcsVZpJq6fsJ444bYZ6Jt6yxZhVPu1lDmUgpknSxu87tWhBBYdR8ie7mjAZkUumCJEryJ/H8BhJqh8YEYwZYo6pPs0SHY5jtlabkq7G/PolKc0hHhRS8GU/inCVsRo0tujOGuCSbnrElQqBzSsq2mgZnsfdcTbLHAuv8rDleD7kxp+So05GpsglzVNG6KsAEYg2TdCbvFZCfaFUdHrv8pxrwN0WSfEweApLDytYrt5XhqHqfbHLjf4Nfkf51nikbNcrBNuiM06KkwjMXOxZmBNP1hu3wFVL32EEf0/EFXrs1DSCZ3Y3et3qufbcl0uDi1SCNGDhdZCXqGR99Odhb0ryAgT9M2OAMuuE1UyWSMmjCt+x4xcgnrHDw6EXixAWzJIrcvlZvQZxkLJYLDrpDo146cXxSCfHtnsfP0puedE5Y8etWgLYWej5CuQng+ZIdmwe0/NO2hHwpiCjyZLnvh5PaAb+r1/738iImERIees6duXD1ddjh4O7jaAVQJVRjteDozn0JZ4qbhkj+RJiD5DAG6f9k9OnVJzzW3iZn6uJM9SUPRBQA8C/xwzsTZ6OXCzoCNv/oh
 558Pe/d/
 DwRDJPOPYKfrC4hVSxPYWaf+l8DbLo14yFaUPJqBDal7crZwYi0dgENSk5kj9dEs1UXS5Ybh7t8wEMhppFBsVrPbMGYTE9wH1fiMmzmvEYCFEzm2JOvhgUw7N9KZZsuEuvdS1YZCguM93YuSoSCPXBeNp2Z5PS7BJMZ/Yx1yQoWPGoIyhu73qIRLvJkf2SurW8Hi47pfVgCymZvSqNn49kvlFAnEXeF7juWh74iVpivRQTgBumYNbtq7tNOIyuAg9hNMotzkV+OfLE+87cRw7741WresHjPNdxEl44CqTwWCAeVD/P2f/yE0DYAym0U7Z4ES6FmdGzBTKzknz8+I9xqpqzNO+nlpaOnULRxBVxpkwl7NJIauf8QInXYCXYJr6bWGXrizMI7XCzYQ/K4oDiNcdx0yt9t2RZ5zZ1VEt+Ke4ygAp1RLbzj4qW+369/P7cCY/mFFwd9BhOLvMtnm5XvjFJ44aVujBw1CCU24y5dVG4XGOyQgPgLW+BzAw7JVurbk5i0rQ5xspScs9Lw8B/gUaCMFhdCjMRyiTV0DoeHiBLqeBBOQmopzV3UE8wJlhbiOa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simple DMAEngine-based migrator that plugs into the page migration
copy offload infrastructure to batch-copy folios via DMA memcpy
channels. It is intended for testing the offload plumbing and as a
template for future migrators (SDXI, multi-threaded CPU copy, etc.).

When DMA fails, the callback returns an error and the migration path
falls back to per-folio CPU copy.

Loading the module exposes attributes under /sys/module/dcbm/:

  offloading      - enable/disable DMA offload
  nr_dma_chan     - max DMA channels to use
  folios_migrated - folios copied via DMA
  folios_failures - fallback count

CONFIG_DCBM_DMA selects MIGRATION_COPY_OFFLOAD so enabling the
driver pulls in the infrastructure automatically.

Channel acquisition uses dma_request_chan_by_mask(DMA_MEMCPY), which
works for providers that set DMA_PRIVATE (e.g. AMD PTDMA). Generic
mem-to-mem engines that do not set DMA_PRIVATE (e.g. SDXI) should
acquire channels via dma_find_channel(DMA_MEMCPY) or the async_tx
APIs, which can be added in a follow-up.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   9 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 440 ++++++++++++++++++++++++++
 6 files changed, 455 insertions(+)
 create mode 100644 drivers/migrate_offload/Kconfig
 create mode 100644 drivers/migrate_offload/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/Makefile
 create mode 100644 drivers/migrate_offload/dcbm/dcbm.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index f2bed2ddeb66..3e83a1475cbc 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -253,4 +253,6 @@ source "drivers/cdx/Kconfig"
 
 source "drivers/resctrl/Kconfig"
 
+source "drivers/migrate_offload/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 0841ea851847..88cb8e3e88df 100644
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
index 000000000000..930d8605c15d
--- /dev/null
+++ b/drivers/migrate_offload/Kconfig
@@ -0,0 +1,9 @@
+config DCBM_DMA
+	tristate "DMA Core Batch Migrator"
+	depends on MIGRATION && DMA_ENGINE
+	select MIGRATION_COPY_OFFLOAD
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
index 000000000000..893580cb9fac
--- /dev/null
+++ b/drivers/migrate_offload/dcbm/dcbm.c
@@ -0,0 +1,440 @@
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
+static atomic_long_t folios_migrated;
+static atomic_long_t folios_failures;
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
+	if (!work->dst_sgt) {
+		ret = -ENOMEM;
+		goto err_free_src;
+	}
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
+	/*
+	 * TODO: IOMMU may merge segments unevenly on the two sides, fall back
+	 * bail to CPU copy. In practice, I have not observed merging in tests.
+	 * Handling unequal nents is left for follow-up.
+	 */
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
+	atomic_long_add(nr_folios, &folios_migrated);
+	return 0;
+
+err_cleanup:
+	pr_warn_ratelimited("dcbm: DMA copy failed (%d), falling back to CPU\n",
+			ret);
+	cleanup_dma_work(works, actual_channels);
+
+	atomic_long_add(nr_folios, &folios_failures);
+	return ret;
+}
+
+static struct migrator dma_migrator = {
+	.name = "DCBM",
+	.offload_copy = folios_copy_dma,
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
+		ret = migrate_offload_register(&dma_migrator);
+		if (ret) {
+			mutex_unlock(&dcbm_mutex);
+			return ret;
+		}
+		offloading_enabled = true;
+	} else {
+		migrate_offload_unregister(&dma_migrator);
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
+	return sysfs_emit(buf, "%lu\n", atomic_long_read(&folios_migrated));
+}
+
+static ssize_t folios_migrated_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	atomic_long_set(&folios_migrated, 0);
+	return count;
+}
+
+static ssize_t folios_failures_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", atomic_long_read(&folios_failures));
+}
+
+static ssize_t folios_failures_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	atomic_long_set(&folios_failures, 0);
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
+
+static const struct attribute_group dcbm_attr_group = {
+	.attrs = dcbm_attrs,
+};
+
+static int __init dcbm_init(void)
+{
+	int ret;
+
+	ret = sysfs_create_group(&THIS_MODULE->mkobj.kobj, &dcbm_attr_group);
+	if (ret)
+		return ret;
+
+	pr_info("dcbm: DMA Core Batch Migrator initialized\n");
+	return 0;
+}
+
+static void __exit dcbm_exit(void)
+{
+	mutex_lock(&dcbm_mutex);
+	if (offloading_enabled) {
+		migrate_offload_unregister(&dma_migrator);
+		offloading_enabled = false;
+	}
+	mutex_unlock(&dcbm_mutex);
+
+	sysfs_remove_group(&THIS_MODULE->mkobj.kobj, &dcbm_attr_group);
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


