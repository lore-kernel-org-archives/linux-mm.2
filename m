Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50EFD6101C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAFD6B008A; Thu, 29 Jan 2026 09:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3554F6B008C; Thu, 29 Jan 2026 09:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2572F6B0092; Thu, 29 Jan 2026 09:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11EC96B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:42:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1D45D3132
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:42:22 +0000 (UTC)
X-FDA: 84385266924.03.49B2F11
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09E0D100005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:42:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rTjKr8ER;
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 40.107.208.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23eiGBoQVc5DDMfaaIZ6YGesXKA5XD1hR5itk5/FwLw=;
	b=cdrWcY79Q3+0p35HypSMmfL4Fhe6Ox6h701hz3oEtHfheasX9H8vcwHK0fKCmwtcnVdq9v
	kewJnFrdVt0aW6mYXE2KiyZ2qAl2B+Pe6s+vK+uWjjGz1+v8xRtYnTMMF5Uy33kbrofGPs
	fb9R2Nj8KRhu+C5vUv5pRrUwSPupRVs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=rTjKr8ER;
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 40.107.208.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697740; a=rsa-sha256;
	cv=pass;
	b=VKAAokzcWkNDvTOYzsxwGmnWl8W6dbDSANPC/fh4emBlFYT/3ymiJ3D2PYaRQrwjBqFtON
	JvXrzaJ+eI3kcqJzjFYcvEx/5nwyKbd7P+oTiFLB8EQ1dSP4TzboShfxtLpcm98P6ZZ2TC
	7/XFIb7psBg1OQuNjl/E0xOpFRl8hsg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cgqm3QmZF9AyeXXQPEDkvoWjJuYbBE2Q9ajSLCwH/CupS5g/5fdEye/57BoerOroGJ7CBDCqIE3sdpNvL+0QpQtRf/f1p1ecKgwknwRl4GqSNcQssKrM95/ouCjiv3TF6P2kRYr/tyQO4geMd54a1RQHWkn/5qNxc2mDO4ix6WW4ypOy4kOLM2ggyZeiWjg+6Svjp2wUuoy/k/GQdaL/9S5J+RWDTamH1CFk25RNdRxFfuab42WhhuhSAKPokJKMbxOkCV6SpswbG45NbNdhFlRrt+OgYVN5DUAWjslaLVwlZ+FuGHcnpg12VzLdGqvFErzfKcI3VYzjQMF6MYC7sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23eiGBoQVc5DDMfaaIZ6YGesXKA5XD1hR5itk5/FwLw=;
 b=t9fD/bYa6PjTkWpQ/X14F6zR3XhIffJVYJeyXYc1Jen5kfXLQyTdDGIuUAxe7lSisFpxgr45AMVnxl8lRkcl9g5JCLMI4LJmxa4k8T7PRHf2Uu5Nm1xQPmSWyhGpC5eS4P1F0De9gg64PJZIH/K+ZtrMIj7QAV8I1iTO2PE/RbIWqpQNSaXyB1QK4Y4KpuSVz9MUDy/STSxovrAhwXBhvjcZ7SQu9rdGuI5VlAhrm5XymEv5Gear32hXthN47lHu0/eEAiq53HPpkH//wtHvVexOnk69uFlr3wKzaTKSg9V4Yzj0dVuqqffBpoYXw/EwzlKrz6qOHzBOsSdfwosQqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23eiGBoQVc5DDMfaaIZ6YGesXKA5XD1hR5itk5/FwLw=;
 b=rTjKr8ERxN1OyLWV+0J8K9+AhctjmFEL1YL4icKMqxyxB101g+xWVaeCsMMF67E+fQ/xzLiJtRNTx5Ar6b02Dc1dTN1JEOFFfPt+Sd0CbnrFc3GfsZN5sMkTOQD0QgmclolWPQA4TcChw8+T/h2CqJ26UQ/p7mdVhgVWElnnl50=
Received: from BY5PR17CA0022.namprd17.prod.outlook.com (2603:10b6:a03:1b8::35)
 by MN2PR12MB4488.namprd12.prod.outlook.com (2603:10b6:208:24e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:42:12 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::15) by BY5PR17CA0022.outlook.office365.com
 (2603:10b6:a03:1b8::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.10 via Frontend Transport; Thu,
 29 Jan 2026 14:42:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:42:11 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:42:00 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 02/10] migrate: Add migrate_misplaced_folios_batch()
Date: Thu, 29 Jan 2026 20:10:35 +0530
Message-ID: <20260129144043.231636-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|MN2PR12MB4488:EE_
X-MS-Office365-Filtering-Correlation-Id: 7458435f-10da-47c1-c673-08de5f449648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gb/k+LXknIEAlNMeYLRRxocUpehScyMPpxywUCnOzM6mZQJkdhl/DDM40OG8?=
 =?us-ascii?Q?4vGze/KJeIvd1Io6XqdRC+0/4guM0CPN8p7ZAkZOFcm44SN0AIa2OLjXGZVX?=
 =?us-ascii?Q?6yk3UHhfqSz3Tm96cZx5uWPcEvZMInxASmozQNntjhIwrhQimfAJmKbR1J2i?=
 =?us-ascii?Q?Kzrbtm6b5ajPSYTEurSKQT+aZkqy3SpUxcQCkjzhOy1tpAHyz8p5ErfuMePb?=
 =?us-ascii?Q?wgeAm+c0gcBm3iK/k9Cu1pucV2lUofsnugawKBeOGi8lSUoWn3YojT/BxC4/?=
 =?us-ascii?Q?IwThiCssSsXTQlU/C9sZprI8zYna9O8Awiyajx3SRij0ooKkQ75Jgp7R5TpW?=
 =?us-ascii?Q?bjlXb/QHvmtobRqIo85i/LN0acPG3LvZEMYWhx/3ZRLIqEcDCHSt9z5Hni9A?=
 =?us-ascii?Q?FgSaebqktt6xj85LDeaJ4KWYNy98g0zB8S4eGIFd+4/DJlt5Q/mSoeETrZhp?=
 =?us-ascii?Q?IAwodDKinwv32cB20PouOZ5N+4p+oOGlao4S4TcccV6kcnl4UrRMTze7nF2t?=
 =?us-ascii?Q?sL/lBxv+hf8b49JJaSpKRIKZ9LcURqZtcuPNtreoXhmHQv4U9f8HUaALULDJ?=
 =?us-ascii?Q?Gfkb3hg8LkHYmGe9Q9ddD+dqTu5M1MpUr5xUTSvCqR15bupNyXTQFtPYB2GP?=
 =?us-ascii?Q?w0UvJq/tmoA9BFuqr/lswaPYzMhXBL+XiQjklR+f3R1590qAwP+cbsHwNgRl?=
 =?us-ascii?Q?NGSuHn3arYoX5moDcfi8w/YL19PUenYYnx4tBjR+mR8fG+46ey9oEhXNd8jF?=
 =?us-ascii?Q?MgSJFEAKSf+OF1vtOyHHjTg4bB57dJcVySTqb93VRiyj8gflbnOotWlDofCZ?=
 =?us-ascii?Q?1q/vOD09DuRg+9ZBjOIvop3NQU/uVTXADS0cxnolb5q4jVRnbR1jlzd9HgP7?=
 =?us-ascii?Q?z0t3svlTd301VX2iTKFfDvF7QLTjJrcWqE7zimEVbkA6cqk2GDu9oSVR9oKP?=
 =?us-ascii?Q?F+tV6r9nDHkq8VzDDXKF+DabE7MQyolK1ramZm8r+jizijl8MX8J0Hl0K/rx?=
 =?us-ascii?Q?inFUe/MK7LSQ8tff1nTS+4HxM1Vef7Z1AMOyQJavp7lcrXFWDnv6od6hmmI/?=
 =?us-ascii?Q?fh0TPRVjJfn8pFnfO00/Vcm72rwj6iTRHjvy6TL7CQX2NxnqQIxHZP94/npA?=
 =?us-ascii?Q?bHIY9YQS5UwWn3cxMYXSVIIsE0f1ob57vhFJsr/tcWwDZuMjGpmGS+2IA9Om?=
 =?us-ascii?Q?p5lxD88UIAgf7cVTY66UvyBSibs8Tndi1lTO/Qo0z401L3E2vRHJzKf2jV8i?=
 =?us-ascii?Q?1bmjt/VDNuscwhqq6K0721WLuq05eohJTdGZnmC4kOoD/G2+iDfF5cySlrvj?=
 =?us-ascii?Q?3Pv2j3TjrVO52UOdYEtVm1a9ZntR+bS4T9CnkP3NBdEv+ehEOW8avmdYLA85?=
 =?us-ascii?Q?9zKmIoAW9+TRYO3xlrMXomr8P2bKpOjNlU2gZVJ7LD6eYdJ7gQp1fURPAIwB?=
 =?us-ascii?Q?U4L/TZD+WVlDOf4llZ8jBQock5FIhRjqunoSa1u3ovEL9QP46bkdo+7HIn1Q?=
 =?us-ascii?Q?8yWOIJZDdxHOHe+YiIte8Rp4Rcnrgh+JldHleeXGjIYp7kaYodjFQh8PZE7F?=
 =?us-ascii?Q?2EqQm3DGm0HGnUqEdbD/jcU4YMx9TkkNZcvVraWtavTEpuJIVujI+x6lR7gl?=
 =?us-ascii?Q?aoDuMByt7JTgTASamEQrQ/ryadrZlzgtQuQoSEJVqnI/BJI3KB++NMVzOhd9?=
 =?us-ascii?Q?BAXHbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:42:11.5615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7458435f-10da-47c1-c673-08de5f449648
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4488
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09E0D100005
X-Stat-Signature: k8jjuhtdtaqd53wjoz8w4iyuhzofjuoe
X-Rspam-User: 
X-HE-Tag: 1769697739-156694
X-HE-Meta: U2FsdGVkX1+ZpM4YyygEzDXezk6gMa8X9WuWd2iJGMzSkSkv29G2RbGVGJf4qpqcykitxF8usNUuU+u8pnzs1uNDtibsxqvo+p9ApgJQX+1rjtDViYe9/V6OSacPNWNuXjHdb44faXVOb5uTzZ0HK8aMy+IE3vk1ra1ojccOrIXMqhfLxm1T3nwoY11VcTwgIauT9TOHU5RUmHGg+/JrRwljv6l5te4Jad4bsFrcGR9MQseCL82yrBTPrT3XeXPpKgiyn2Yr9D2BV4jI0gVML3ogUMNZy6ADZ/ETr3TNPvQ56aE99DFKR3v5Wka12I6WQIuCR9vPFGp1Jtqy93oibqlXNMH6+/iYzC1SYcVqZyzqKvIQIJaICNXrttgrWPIbomJYX9+eZ3IhcZ8WcnWexFuWu8TU9c0r/J9O/UlREkgX872/N6fFAeYDMNZg/meqeFiduuPah5Fze+U0Y840Z5sLloNJkrGq9gJ7tAdE19S8n2Kf55fBHCsVRFCDeQH6zk2HHDYIyyn01mfJ5aHrKEl+FmGpnyVDR1dlDcnJX0byCIzakYBZFUy3ujytmd/HwB+GOFGBldc7jmcd/itIRTUteuD12aMtcqLbiRut59VT0DbcitktJ15iA2By4yU6H+1WXFxWr3WSvHGXz8i59CVuzvduKsz95us8yuKDAv3msNdjAhjbjUR0aRg4RCSXICGUrLI/A77w4BXVNRNyieAsqNMQc73U7A4zxvACkxLFaCdIjL1OhZwfj04hzsubUk9PdJhVZ72Gi2e54C89Uh/yYLPGp7FV0/Z6SrZ1oPv64PqQ2EafYN1AAz95fuCAWOVDhv9J2LyCni0Kt9DJ8KZb4ypoDRTg2dJi3oA1ASQq9OZvlWEMPOJ25h45WHcAqtbRXQ1TVaD6pli1F53DZWXbd4mGKdwpdawS89q+PDB+90aQdaP8J5YoOSqrsaOp4OiIjwtU5Efw6rP/S/u
 puYKjImt
 JL6nabIYAQrCo5GAhJrtVJ+EiqbEUEshC1vyzZ4+ug5NxlumQroFrm3MNx8Rwu3KYN0QeUljU0GUjXfJa3x3VC1+Xv67k4VPpoBwaCKbq9LLjrgpvrDrfTcY//RqBe2nPeoRqnOcXOw2X35gmqFRRYQaSIW55nSLcvyAyMn831EGm2qNNQg1PFMSqLk5cCGQtrJT1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

Tiered memory systems often require migrating multiple folios at once.
Currently, migrate_misplaced_folio() handles only one folio per call,
which is inefficient for batch operations. This patch introduces
migrate_misplaced_folios_batch(), a batch variant that leverages
migrate_pages() internally for improved performance.

The caller must isolate folios beforehand using
migrate_misplaced_folio_prepare(). On return, the folio list will be
empty regardless of success or failure.

This function will be used by pghot kmigrated thread.

Signed-off-by: Gregory Price <gourry@gourry.net>
[Rewrote commit description]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  6 ++++++
 mm/migrate.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 26ca00c325d9..f28326b88592 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -103,6 +103,7 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -113,6 +114,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int migrate_misplaced_folios_batch(struct list_head *folio_list,
+						 int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index 70f8f3ad4fd8..4a3a9a4ff435 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2747,5 +2747,41 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/**
+ * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio.
+ * Attempts to migrate a folio list to the specified destination.
+ * @folio_list: Isolated list of folios to be batch-migrated.
+ * @node: The NUMA node ID to where the folios should be migrated.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio.
+ *
+ * This function will un-isolate the folios, drop the elevated reference
+ * and remove them from the list before returning.
+ *
+ * Return: 0 on success and -EAGAIN on failure or partial migration.
+ *         On return, @folio_list will be empty regardless of success/failure.
+ */
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	unsigned int nr_succeeded = 0;
+	int nr_remaining;
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
+	}
+	WARN_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.34.1


