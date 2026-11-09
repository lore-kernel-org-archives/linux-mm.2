Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A9B606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=H2qI7m/H
Received: by kanga.kvack.org (Postfix)
	id CA90C6B00EF; Mon,  9 Nov 2026 01:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32996B05B0; Mon,  9 Nov 2026 01:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD35B6B05B1; Mon,  9 Nov 2026 01:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEAE6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:51:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0421F1204F2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:51:40 +0000 (UTC)
X-FDA: 85414660002.27.264C174
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id C22DB40006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:51:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="H2qI7m/H";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794207098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GRYMVgY7LLZLdohLNTD198CyzBzgVMBBYs4VpkOhRfk=;
	b=J/EDNIEoWTi0XG4IKxyjw73n75uY71aliHEnOhBp+LcGapBdS+emo/qPmFRzkdExGEDUc6
	1eKceGRzke2gJbfsYBxVq7CCoeIB58u1x0m+msD4n0mSEECZccTTOqXuXNZSInxVQrt0ts
	NN+j1ygeu2UUdP6OPElOD0i7UM3d8WQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794207098;
	b=aUBYwXhcg3oVU1/znv2BuYddxtrD0nasrH0YdnBwCKHyEUwuUTVjVvnIMwinP8w0PYTvM5
	piOiinC4WMFx2I/7xkhSEXduR7pOCRm77twu8TS5XL5st0ZzHypix7tCAcQmq/L62uzkLv
	7y6nGQsdiS25hi8A/QAiwOy7EbyBOU8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="H2qI7m/H";
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgU9atx5TO7UJYPRHN0N+U40HnGX8GwVxyIuSLYmE7nJs60+EGE2S9938XdLivyBFoCPd0dWappkKX983ei5xz/+SUuvHNxNRWHh+wEkX0ugWVMqigQfFQiRO2KE4CDXq3nIc4UoEiUp8uCbsxDK20ybxdiByjpQiMNnnhP8mQXKTOyHyMXicz3kDUsDgMhFMIK8KVffb1Wl1avL5k2OLVsIpD2Qww2uEnTCANNVGIrkSt5uDIAiCEEH9Ww9Fag60FAZNX9hgOc/3ya2nIruoIwUcMV1/jeQI/uMWMHnWY2sKuQKOPe3/UYQ1MOwLUdR1VivXdgFhSnpk93TXgrzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRYMVgY7LLZLdohLNTD198CyzBzgVMBBYs4VpkOhRfk=;
 b=muxGTC5zfF862XrMnfVOAS30RCeEQAkkortXy0MMfV0zunOMgnIoEKKHqS7EW9UpeCPoYygYGtORnwlcX0Ro2ewLZ+jisKhxZdzsKRUCrcm6sKb04TEryR30eSJMpncMkWBVxu/GYYJT5hghOonUuMfN6ONBQiIqpnHcydLFlRpG1fXrMbXa0lvA3Q7JRvG2xVL4LouzFXxhG29KA95eRhstPIiwbf2QG+PvGjne9LgHqHxHyknlmiqncifPtCyLeJESSG49DE8His20IgydjqTaJalBYGlmwkWyQOxgoSVy41qM2pjdnSxclGWOd4Ph6sgXDK3IG8KgaZk8b4yzBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRYMVgY7LLZLdohLNTD198CyzBzgVMBBYs4VpkOhRfk=;
 b=H2qI7m/HXdV8Z8V9lb9NCRLRRyQHoXmUgQhn9k/03ePZRcN4fwO0Z64u/+uu9hx/yRiucrv8plrHY/dpVFeAbYi0K8w9Pr5/zGW6/pyUSuwKfis8LQIOaRHIaN+SPru5IfUBjuPhUQuzaBH+RDlj+V75p8g3od65ce1S4nvLpRc=
Received: from MW4P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::26)
 by DS7PR12MB8082.namprd12.prod.outlook.com (2603:10b6:8:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 06:51:31 +0000
Received: from MWH0EPF000D8951.namprd05.prod.outlook.com
 (2603:10b6:303:80:cafe::14) by MW4P223CA0021.outlook.office365.com
 (2603:10b6:303:80::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 06:51:30 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000D8951.mail.protection.outlook.com (10.167.249.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 06:51:30 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 9 Nov
 2026 00:51:25 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Mon, 9 Nov 2026 06:51:07 +0000
Subject: [PATCH v2] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261109-clear-pages-batch-v2-1-2e62c4f84f94@amd.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NywrDIBREfyXcdS1qSpSu+h8hCx/XKDQxaJCW4
 L/XBrorszoDc+aAjClghnt3QMIScohrA37pwHi1zkiCbQyc8oFRzoh5okpkUzNmotVuPBHCCY5
 OUok3aLstoQuv0zlOjX3Ie0zv86Kwb/uz8T+2wkhLb3ttqZZiwIda7NXEBaZa6wfcyRnesAAAA
 A==
X-Change-ID: 20261021-clear-pages-batch-77f72ef808e4
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, Pedro Falcato
	<pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov
	<bp@alien8.de>, Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke
	<hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>
CC: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794207085; l=5798;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=VNe8x8Ob0mAwd6pZ9p9OSSpfdUNhMscllgbnWCzcy4Y=;
 b=DLmLWcuAjWxv7oVtTAAcDqPpxeLlFKxKYXddpxXde/0zKA04voSCsGmjfG+kS2vknyM/t6sX6
 61rg6Hxg3NxAfshcp5QTl0Xc97WWeEq1BVTyrpbUEdrQu8s67XT0CPy
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000D8951:EE_|DS7PR12MB8082:EE_
X-MS-Office365-Filtering-Correlation-Id: 787bce45-1f19-4416-8eb1-08df3e2de2b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|82310400026|36860700016|921020|11063799006|5023799004|56012099006|261021123027099003|261021121427099003|261022075727099003|261009223027099003|261026121527099003|261102123227099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nnKgUHJ1adgF+TFaD8P0woIETl499TGNuB1P7btBt2kW2utxef7hBGUlyqNaNT6jaGNfGrUn3oCf8Mv6PKmwWXKe6J4hjCEelBusjZw97oIgwXJ5Nai8qbEQoJj1WT7GXvXPgsNLSbkhJoxLYCKQVjKE7ECnzbWRynVBH6EW8pbIlnsmu8gl3/ztRkQYh1jbJgbaL6/jBNl+TvFqam1QU37P9uT04xqT2pXTbh0YDTvHaHrjbBp4eufYZlna4ZI7esyY5ydJSwd5p/8brdfPXF0HpbxHaAxlYTocpHADDKTsYZRkjCJTac7rqm8M9+QTUL22OANIdvks0V2LLReaRpYBKgBLd/yDhGN60dDYkNKpbmRAA1J1RtX7VR/GfzKXWs6NP2YOfxE9tUhsTnaQOfd1DGbJz7upf7HAxnznYpnR83gEMh8KTe0lnif0TtFKI9wVMB/vXyLosczsrPOH2jQvFFNx7V3KdX8vQv4jDQfn1oZ0C6gsOzUku152u/txN+uEMaZZMYCRsxDMJH8BeiR/LdshR0axT5bXsyKSiCWfK9NznmWv0oKkOoq5MlB7KlsyEP6f9klhWVEo6zURbwpamLhXWYDxLc/MXaBCkGsNPA61x6WHwjfwEeTJ/h0fUregJSix2ji6voR1UXxjTMKVDLrNdaoXSEXhT4U2reuDoCqoWx5A1zPxqIupxQDC+xSvwnVx+CFtwKEEwlBGhw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(82310400026)(36860700016)(921020)(11063799006)(5023799004)(56012099006)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(261026121527099003)(261102123227099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wMSJxw+90Vdo4nlGdv+Yz9bnNDRgClQMI6bJIcuW0p38GGHBovvBlCsg1Qkyhi/db9fbkAZ25qY4Ok/IAX/HqFefMQpA9l1jM2maPTCFKiM8hA2T0DXwMH2Juf+75UUEgCgxIW60qLVPXD9Q4Ncex7hc5szfByKAxYJ8CcnI37/Ia8yzlR2VEucR9trgiDQ7eYOw95RvxF/CwyA8nId4r0oSPQMDT3/Icd4bpfkpQmvlG11rOVK4Y0brQ+l4GQLE2NNkFSstuvWWZ/aP5K4BiOlKmdyzE4vLoNPIBHKmG0H3DWgl/KG/7BqJClsrH4oTPkK80Xj4mjLjxzHxmc94AsgqQAAo6KmhSrbW2FAvKlEztnLk22zORHshphJepjj0+2nS9tjStsfsVbRxuUWMDSXsN50Jz+OeSmHeVQUPF3IarlTKDYYiFcRPOGvEqzc4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 06:51:30.6264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 787bce45-1f19-4416-8eb1-08df3e2de2b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000D8951.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8082
X-Stat-Signature: bz7i5grr3bacpehyobf8kjoobz8k1kr4
X-Rspamd-Queue-Id: C22DB40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794207097-680165
X-HE-Meta: U2FsdGVkX18iSc6VXrMejoSS/rnYpZKmPxZImOxjKUQFQRAhBfeHg6+XJfD56o8zvS7T32JTYqCR5Q4ABZUXR6tg+uBCT4vh9wBZz4ZC9t+gjcsyk9K15sdmHv3+wHiQ8rrfJy1jJbm0QENedJGfr32ohSkqzjJPqa84m8avokNIWRN7re7RXhOdoh4uhbmWRXAQUjFTVCM1C2EFttGV1onMSyAyLKYsCHrFmksSNKmgjQEAdz2e1UjRjgv7L4Bc7GbPsauS8czKY5gShUK2Gky9//qtLcn/ojusURI5lFpAxRb0p9S9Ir6mj5qZse8cKNZ6IZxP08wDYfHiyzrPTdbdeJAYr6mBNofm+j4DT1YAR4IyytemONCAaksmR6GEZn2SSSrRx5E/vcF9aSdk75ISnSwiy3ijHEXxIzBjCRxtWfPPzi0Yk1BmeneAWmudQEhNfduCvrE9wRbZyFz9MWJgXE9prS9cm09KPJlh/PvSi/BaW9zLBJZkR24Cg63Ek66moC3AJqB+4q5LNHtwWqyhA09XUlKKJawbYG/VSv/94ljUitRwnlnF8bHpIugdJssb+JzEsfPVpcuVtqVQzkSWRK2NuHIM9ppPL88aBQry+li4j/PBpvqDi0F+AER62buVcFU0Xd8X0JuictpYoBNy+L7Y3ng2uwpXjA9Ej/YDXATqPR0zGP1CRtfArCwOjbERxd6tcowWX6riSQRsEci9lp1ShdIiVKme8E+EKWQw0ZTm0BdMgteYP739lc/DopUrzpftfth+cuvf+iOhCMSEPB9PAIK96gmbtV0C7at+AvIPIW0GtlMRIBuofL+EHsVLPROLbxNuwx5jubRHf+XoxSif1GIDDeP46bTtp6c4HDBcCNDkWdNGbDlO175cqyzpxdmt867hr8Vrvy27ADNjYX5IgZk/Ou1uo28cES6ZtyhXDtprBnuMOt2A/jXnTn4coahg1k1b7NDRb+a
 gaSYR2Y9
 aqo9qBMRVhSLI3XAK/6WbqjVw1QTXhAM97UJMRrfmujcR3orIiHz7CeO/kdjAxauC+eItFXl1VIc78inKCoHNzG67hrhHwHNSKLqWBGsv5mbkXmBVw0QAhl3gj/HpdgJ7kziXBwPHqVGpMd/alcXZ7naal23rK5n/kjgwFBx/chT1BVuaYEIdxGm65xlxSvRx71vdbEZLV/1vqyRNtAQr6ev8VTNPh32P/Jlgrp1M20LUj7eMCiiudU21zQ+NtYvx4uSdpkg9dJziARZsxQehI1Qew+8GXAQ1T2YqTNJem/XUP+GLO62uAVJqVu3I0lkHGiHaQcggkdBz4V2xKF3zs3zax4KDJwme14UwmCA4g8CUcNenBZeBuiQblj4pqKUrodyyS1Oz8Ylam2SSkbyMkl0wOitCtxSnvkOp8dURB+KzKdUgLfEwL+GgpFhvbf8aXeMy2YyIPcvlIl6T2ePU4YxyONb8wsmcd5SFxqsGQm6jAVIrM2xjC12EANcjzkm7rlGNRY2vigLGG0UwUoJYsAhe6nRQ0geE/7Wc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

clear_contig_highpages() clears the whole range at once under
preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
pages at a time, with a cond_resched() in between. The batch is 32MB if
the architecture defines clear_pages(), and one page otherwise.

Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
modes"), architectures that support lazy preemption only offer the
full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
one of them, and it is the only architecture that defines
clear_pages(). So the 32MB batch is never used: whenever
clear_contig_highpages() runs under a cooperative model, the batch is
one page.

Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
set, and one page at a time with cond_resched() in between otherwise.
Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.

PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
cond_resched() does nothing on any of these kernels. So a build-time
CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
not needed.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
This came up in review of the copy_mc_highpages() series [1]. Pedro
pointed out that most architecture run with full or lazy preempt, so mm
does not need to check the preemption model at runtime or batch the copy
for cond_resched(), and a simple per-page fallback is enough for
non-preemptible models.
David suggested doing the same for the zeroing path, and this patch
does that.

[1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com 
---
Changes in v2:
- Rebased on mm-next/for-next, and drop RFC tag.
- Link to v1: https://lore.kernel.org/r/20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com
---
 include/linux/mm.h | 28 +---------------------------
 mm/memory.c        | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d89e6f823c9f..59bc3685aac5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5242,7 +5242,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  *
  * When running under preemptible models this is not a problem. Under
  * cooperatively scheduled models, however, the caller is expected to
- * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
+ * clear one page at a time and call cond_resched() in between.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -5253,32 +5253,6 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
-#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
-#ifdef clear_pages
-/*
- * The architecture defines clear_pages(), and we assume that it is
- * generally "fast". So choose a batch size large enough to allow the processor
- * headroom for optimizing the operation and yet small enough that we see
- * reasonable preemption latency for when this optimization is not possible
- * (ex. slow microarchitectures, memory bandwidth saturation.)
- *
- * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
- * result in worst case preemption latency of around 3ms when clearing pages.
- *
- * (See comment above clear_pages() for why preemption latency is a concern
- * here.)
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
-#else /* !clear_pages */
-/*
- * The architecture does not provide a clear_pages() implementation. Assume
- * that clear_page() -- which clear_pages() will fallback to -- is relatively
- * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
-#endif
-#endif
-
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index c46482e35418..9bfd49ea990f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7612,27 +7612,30 @@ static inline int process_huge_page(
 }
 
 static void clear_contig_highpages(struct page *page, unsigned long addr,
-				   unsigned int nr_pages)
+		unsigned int nr_pages)
 {
-	unsigned int i, count;
+	unsigned int i;
+
+	might_sleep();
+
 	/*
 	 * When clearing we want to operate on the largest extent possible to
 	 * allow for architecture specific extent based optimizations.
 	 *
-	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
-	 * clear_pages()), do not call cond_resched(), limit the unit size when
-	 * running under non-preemptible scheduling models.
+	 * clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()) do not call cond_resched(). That is fine on
+	 * preemptible kernels, where the scheduler can preempt the clearing
+	 * at any point, so clear the whole range at once. Otherwise, clear
+	 * one page at a time and reschedule in between.
 	 */
-	const unsigned int unit = preempt_model_preemptible() ?
-				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
-
-	might_sleep();
+	if (IS_ENABLED(CONFIG_PREEMPTION)) {
+		clear_user_highpages(page, addr, nr_pages);
+		return;
+	}
 
-	for (i = 0; i < nr_pages; i += count) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
-
-		count = min(unit, nr_pages - i);
-		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
+		clear_user_highpages(page + i, addr + i * PAGE_SIZE, 1);
 	}
 }
 

---
base-commit: b1efbb50cfdfa953cb1335ead2ef93954b496bc5
change-id: 20261021-clear-pages-batch-77f72ef808e4

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


