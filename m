Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A43BD116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D906B002F; Mon,  1 Dec 2025 14:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DDA6B0095; Mon,  1 Dec 2025 14:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEA76B0096; Mon,  1 Dec 2025 14:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877136B002F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:02:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F56A14039D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:02:48 +0000 (UTC)
X-FDA: 84171824016.07.8D99CF5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	by imf25.hostedemail.com (Postfix) with ESMTP id F37C2A001E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:02:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vVuKsy+8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c2uLqR2dN9UnkNYLecZ5ys5SiKZvFufZ5u1JjVGV0uk=;
	b=hfBiwwqniNEZDiBdXYH6PyumbnNWFI3S/71SRwWv9+AOKuFQ+eKcSTY3errpXvDR85MQfk
	oBLj+Yy4bI87UaTHi28UwKi3fUcQT/vQKguFf2DNNvBKmiNUCbuimEtgW4Nq+S0eM6VCbH
	SI2c7bgviY0M8No2ElSkxIjK8WG8VKk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764615765; a=rsa-sha256;
	cv=pass;
	b=UVd25wqvSRFEyeVdWV8IV0nG7T2//TO1boCZlceFrpdtQqXj3jU1vdft9+a38kCI5yKEgK
	Gq/KccMEu/gfDsNqpOFJaLWP1KWW/fQkSCL0icAwYPLAzhgpDuNMZmHeAII3vjkbhk+PN3
	qRvFWibHqJgA5cMdoguPEwv+WWFcb/w=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vVuKsy+8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CQhukMnxdnT9ZxAZBU5lTefNCzTnpCvOJwy48SeeqGF0/VqQSatsJOuFRO97tUxK4QUwKDnkZ0hcRyjHWqBRuFaAOvmubsRjjnQWd5zMdaD8GjjgjLmeHXFKoAtTH0IUuEKlZ/l7ADSxIKcQuPicKlGF0p8bKUA2THi0jaNI4iKXbo8QN7ObNTT/GqUdWhVt4uwP8mmdBjKaYac7pt0v/DUSHiRZFIpvTMq2ignU6ejWoJ8tTCET5E+BbIMuV3dDxWu/F7fuzjKhVBpl79wH9bAgputOhrMHfpPnuGr582iO9dHiAf4qTAmOgYER1KUc8MVhwUO1cG3URJswECVhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2uLqR2dN9UnkNYLecZ5ys5SiKZvFufZ5u1JjVGV0uk=;
 b=mQxVxt/2nD4i459zBr49MIqdrNIED+QeT2TyiRaimqtA4vJlDPldbMIMWtZXdNI6Rb6eqwAU9H9yOxQkauCntO+jftumV6iPdJkI1qNJUHwlSfAq3Wwb4e9zUtPLk9JdgLpNiy/CQ6Fmi8OWkGOUhqJqwLc1A/kZZe2OEIk3faDTc7fXI7fi8PrvzS+tB6V3gJV/mZnrvwYJ4LI6xd865BZ/rNV0ZiOeIaFyRrP//gSJD/jx7YOEj7r+SVRhUDI/0JQSlEayImCbDXUrmOisxmxgbN22eovG25FhA1uD5xMJFX4ZehKLK3Tw3ZQy6gNPChes4QYdMnxs8676Z0LntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2uLqR2dN9UnkNYLecZ5ys5SiKZvFufZ5u1JjVGV0uk=;
 b=vVuKsy+8Gxeh/KJY/1e/3jqBrHpyvQj9ymwalRhZ+18i+LXAzQLJeni9ufWRROZ6oR6GScSdGGxWxGomLCIaBV1mBZ2ZywA8IsaN8UP4tqrbs5NDZLuBaawMRGYrHDf4o8iElUfNhCP0FNlBYTOZ/1d8g6iK8Z2/5kdGK8dbdlA=
Received: from DS7PR03CA0211.namprd03.prod.outlook.com (2603:10b6:5:3ba::6) by
 LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Mon, 1 Dec 2025 19:02:34 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::b8) by DS7PR03CA0211.outlook.office365.com
 (2603:10b6:5:3ba::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 19:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 19:02:30 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 13:02:25 -0600
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Zach O'Keefe
	<zokeefe@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 0/2] mm/khugepaged: fix dirty page handling for MADV_COLLAPSE
Date: Mon, 1 Dec 2025 18:56:07 +0000
Message-ID: <20251201185604.210634-6-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|LV2PR12MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: 93f1d753-7742-40de-2135-08de310c2d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700013|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6mMABaRSnbpLJmYyi09f1UTZpIQ0CypO1bxsdoE0gwghnO8nkk5dQkU9KXT1?=
 =?us-ascii?Q?ApDP0GTFJ8fsx91OlOy1zVL7sorDON/3B6G6zHBZ7b8BLJFRcp8ALPTWkPFy?=
 =?us-ascii?Q?ysnSsTy1ACSsGT+CyyhF8HJ7n/5LqpsJZprlmcRO5ZVArcJ0Fyw66gKkV8rI?=
 =?us-ascii?Q?Y1pT43lZzDpuqdPHAohxjS3JXgOY8nBj4Y9XdcUwwbmMefZQDnVWrPppN4tA?=
 =?us-ascii?Q?XI6ag8vhVrtmC1aj0JlWrt0OkjE+kYq4iXVOgXxFyng1Wn27F2vYGwwm0yK3?=
 =?us-ascii?Q?RKBTGn6T/f37GVdjNVoQgjiCgb/hWoPshQzXMSf2DrgYdf4PC/2PCfTGUz0h?=
 =?us-ascii?Q?6rW9knuXgc+AY5tf+DqfCWX+LVggxHiSqlQcZwSi34sDFilQxgxYIofhGq7H?=
 =?us-ascii?Q?gJlf4ZbdTgfpzmCGEy5lUkz7sCRNLG+7Wg/SAYeRKioefkuLKRP6lK8qqyH+?=
 =?us-ascii?Q?mQ5Gb2/hJISAvasZ6pzgnQFyVfSbNMQoljfgCghytZZcB2miMh27KO6TQTtB?=
 =?us-ascii?Q?4lQbDqN4TJacxwL7yPsxhUaD1iGycTMeb8svbI4EvVUkd9jeOC3iq9q92Fzq?=
 =?us-ascii?Q?KHeP5ueZM97hvfgHL0aLWn+iafWuQv9EarbDT2RL9PD3pa2Vi8lhPi9txCoX?=
 =?us-ascii?Q?PGxGgTN9I+hVRgp8iuNY9TjQxDcdQLvpAP0GOSXvgwe2s3Lr0cZyWRNI1mNO?=
 =?us-ascii?Q?lmbQW9DOCQBo5vdv3S77W8oceVafwoYHxaCOQJzlvVMr6Kv5OPgJfjCt+bmx?=
 =?us-ascii?Q?TrrW/xiC1b8bDCPBXZr8r3dWATNs2Vvb/Vqk28ocQCfQ0a0KSJ8goxbmuqfW?=
 =?us-ascii?Q?y1qTOw1jdQNmcdekzbc5xh2yEh8Ohbg8xeJB+VPsfjpgG+erDjX7OBxYcoss?=
 =?us-ascii?Q?RhhNvq/y6mbXJohg/Re/AUl4BcQRXLDiZwpypKFNpUhFIt/gtpb6fFieaG4s?=
 =?us-ascii?Q?b6E4lWvWgATzgU27U1/eb8lgDrRcEAFs0qNw57OzdWCmAgZD4UZZ+yQDCOda?=
 =?us-ascii?Q?r9MQ/DIEXh6/7Iyab4INO9dovrBFhQ841hx15u7QtXhxo8MiWipFIdSG4Tfg?=
 =?us-ascii?Q?PAAaenGW5iXBRZfO2VinowzspB3OwlgZPN0vY8m2C2ZbCWhqXd6TMzdQBz+l?=
 =?us-ascii?Q?af4E+B7JpJkOhqbYu0bO/vBvrZJHwRuN8uXcAaP5jIT254KT0VaoE0g/FnTb?=
 =?us-ascii?Q?kfpxyrEONwqPhevmT2arPRr8L+zMg4nr8bL9i6U0o22ep1LVawSXeTr4Qps5?=
 =?us-ascii?Q?PtNyt5XOLTmMCU++FoqQMGNd+AYNZL1La1dZy4I2Ao+ELC3pL4eKPRbV/oUD?=
 =?us-ascii?Q?Yx8+0GZC9+KQu8QG9Xbei4AXBYkW2vatZ766hjGn3kDpQtGabSDSmUzxu9n4?=
 =?us-ascii?Q?SPJSEfqd02Xadn0ELz7GtXA/Zv2RklGNdFJto4dHOT0WC6BzO83w5sWZ90J2?=
 =?us-ascii?Q?HO+SFviJjl0UjOcnPkfnK91LGi3QHsZiQfDqaoUSW80OeF3VhPPQfSA+fuJB?=
 =?us-ascii?Q?CsuS5gh5nJnOwl/bFumci7Z01FEblGJ8pTCT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700013)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 19:02:30.4217
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f1d753-7742-40de-2135-08de310c2d73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F37C2A001E
X-Stat-Signature: 19seiptd861kaacrshoofe7hkx5zftsy
X-HE-Tag: 1764615764-618768
X-HE-Meta: U2FsdGVkX18a92arV31RYiFdWuO/NVglIVmEBYqgXqEy8wOpFOGSumXaf2nqDtk8yHw3ygH2AS0l8No8ZkyblJ+m23847mTaDLqYXuIKfyBXgOjLl4LQC/3XJtls6yHOEVUpOoft4vHumrEmluk7sqfPBGgotDlSrXPX1rkasm+3aK2QIbiFYvCHGh1K/baCWQ9v2wghboZVL0Kfpcmk2RafMg0c/ADPmngASorN6475oBjKS0ueShttiVbidIzgMR3DnszORRAkXGWT8p1S2TXieoYlpPXcQATodZxpRG813Ki5oEhxiMQ1bV4HGVPg8XwnlcI0fbdY/visZaYdIwLOc3IOLvdMV9vnpi5pSI2WEHCIWAGXhuP0TbqtQ4sWYPDBHnhQEOZQhu3A7FMyqfCBC43BF6Vbvx8g+IecUXMLC4rwDVtXaHxenlfAirtABvKrqKpKwVmVHk5p6b8QvfxOcxdekngSwctfaIbZAUfCPTNC0Rdfz6eaBPUYvZNmgKOj/RsxEdD5+zaoHDS+kCNN4oNjrJtpturYJ1iyK5u/0sRMd8Nled2XKu64wU9KHrQj68Ptex7S2uo5c5aiWwXV/T+1GOaliYXlfgzSuIhcus9fImzH5oMqBGPIF2M0Cf6ANSfRJTWgQFDoX4ciNi6UXwSYaoOMTolVH1ThO2Nhlz5nKszXRrAPyr/gwA09Z/8Z7VloVAjHnugPD0oNkVyoBCnoy7RE12uaMleDXDM93WruuwWVSs7qnqyAE54gJmDPHqrB2d8Af+ngXuddumheLuQc4KXumiRX1N+wkeFXiiec38FXsfMkNKEcxWNfjZBktl8rvkClxj5rNgxHbnqw8rnKhsYkuGL9k4wRxbp6URmH0gz9MlmYQBh5pap+6ERBbysot0Pbr8BHMxp5/Impza4I4vRnm9cWDz7WBePCm4HbHhYBRcN8B0CUdR/Y8EiuFdsQn+iIkzlIKXL
 viptb2eQ
 E1QOh2H9SbQo1NWX//ZLy0IQNeZy+q4FnvoaR5XjfVaE5XSf1586ymOGsn0LrBFsU4nGOQQWcUcAIYpxgCxCnRvFH9SnT8hPqFTiSX83e6vLLgteSXWEzBgKtFIBPjrbKi3oXh5q7tklLfgXTgKRFT44gqaavBHIw9HkbvRPtkVZ7WshEzaL7vleOrjbJapvDaB+DEzx7DdU3rHW7uMQn6LbuH4szlt+ixSZNuNuOY/sfjcIgQrg6KT/6iOLmCC866WstvQ1j8P7U5oRJaC+0hgQ0Bgdy6Ly2sfYeEH4Gw83Tv0Ql8tz37UibhI7x9hZisbUqMl9PWNCXAIC7G7pozJksGp0xoGTaidEORrf3EnCyzJY6JvkDVI2vFtmOWfxgtUuzT4L/No5FrJ8y5o+Q2krGnBvW3A7I2TAVousio+MgcENjp6TkJcMbGf7NFeTgZs4ZN4svNei1ON6SBQQo6+DPcClxznRgAt8PFXMGJN6upkBZVRQDOmINiCzqKiPaJEv2BVfT/NV2iUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLLAPSE on file-backed mappings fails with -EINVAL when TEXT pages
are dirty. This affects scenarios like package/container updates or
executing binaries immediately after writing them, etc.

The issue is that collapse_file() triggers async writeback and returns
SCAN_FAIL (maps to -EINVAL), expecting khugepaged to revisit later. But
MADV_COLLAPSE is synchronous and userspace expects immediate success or
a clear retry signal.

Reproduction:
 - Compile or copy 2MB-aligned executable to XFS/ext4 FS
 - Call MADV_COLLAPSE on .text section
 - First call fails with -EINVAL (text pages dirty from copy)
 - Second call succeeds (async writeback completed)

Issue Report:
https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com

Changelog:
V3:
- Reordered patches: Enum definition comes first as the retry logic depends on it
- Renamed SCAN_PAGE_NOT_CLEAN to SCAN_PAGE_DIRTY_OR_WRITEBACK (Dev, Lance, David)
- Changed writeback logic: Only trigger synchronous writeback and retry if the
  initial collapse attempt failed specifically due to dirty/writeback pages,
  rather than blindly flushing all file-backed VMAs (David)
- Added proper file reference counting (get_file/fput) around the unlock window
  to prevent UAF (Lance)

V2:
- https://lore.kernel.org/all/20251120065043.41738-6-shivankg@amd.com
- Move writeback to madvise_collapse() (better abstraction, proper
  mmap_lock handling and does VMA revalidation after I/O) (Lorenzo)
- Rename to SCAN_PAGE_DIRTY to SCAN_PAGE_NOT_CLEAN and extend its use
  for all dirty/writeback folio cases that previously returned incorrect
  results (Dev) 

V1: https://lore.kernel.org/all/20251110113254.77822-1-shivankg@amd.com

Thanks,

Shivank Garg (2):
  mm/khugepaged: map dirty/writeback pages failures to EAGAIN
  mm/khugepaged: retry with sync writeback for MADV_COLLAPSE

 include/trace/events/huge_memory.h |  3 +-
 mm/khugepaged.c                    | 49 ++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 4 deletions(-)


base-commit: 2178727587e1eaa930b8266377119ed6043067df
-- 
2.43.0


