Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F21CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 16:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736316B0088; Tue,  6 Oct 2026 12:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F646B008C; Tue,  6 Oct 2026 12:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624356B0092; Tue,  6 Oct 2026 12:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F61D6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:02:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A7DD1A0257
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 16:02:14 +0000 (UTC)
X-FDA: 85292668188.14.4EB2622
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 84FA8A0007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 16:02:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Oq2T8Xsy;
	spf=pass (imf15.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.53.45 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791302529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d79TqB0Mh6GOENO1NfAmMDznzg6KUxg3Q2hO1HRZ0L4=;
	b=LeUZkgT25JiMYfFLSpMeEmYHkSVTgba/2KqpYHF3XOLk8kHcPGpH4CFGkYzdzlmOFilWNM
	f8mevPlER5dmrE5eM4KGWM1ChBCUD4EBWz95KvgkrLJbxUSvrMF1UhEkUoQlPCn+Kxbww9
	tca69UeXqFAYNpEuz56EqW8OF2YNvIM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791302529;
	b=w9eUaugp0+jm7SVtIz3NVTSMaEpwH6EESLeb+kMDEMekdLUspfTh9EXDRTp4gos8wVp7Tk
	atvFFlenYZK3uDxBXDAHKI/XHmHo2HVy7rw+BEqvz3Jzg8jMLhgUypAs/WJT6umsHwTO5R
	rtdXjrOIar5443E5cDoAV3wIXY2fpN0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Oq2T8Xsy;
	spf=pass (imf15.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.53.45 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gv1d7FriYnjuXRm/t9zHWANUEYJbArT4k1YshfX5MmjUYlfZJDxt3e1wVoyOsqX2rWCwErNhSmTflBJWOYzK9KI6gA10F4yPrf/C1z4a6e+DHzhmg+4Qmhzym/f/NuZpn3hW8TIwoMnnA6yvArrWuI/RoaH5X9Cpsj+lJXzI6GAGvvHxJyCXJxIq6bkVor42+P5LKXpLRYIs2qW3gdtJyQdx7NhjGsJsPm5JXLE2UYPX4ytigfMEIvb8lj/E4MkTyxxzC2gUfxOJ99FjfCs5UOs9Dp4j+iH//o79sjhawyJ8CuJvXyXG7SzlwZxshnh4xVe8LcIBHORwAleVCNvv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d79TqB0Mh6GOENO1NfAmMDznzg6KUxg3Q2hO1HRZ0L4=;
 b=SL+5poGXGSSpMSMy7Tpd9Z3cLuVubZ0aF446TLEOi4/QKDR4EEXkldc3fUFozm2e0g1oFQqjyXLXMt0vd9fTerwjWYoAsZJ6uTRi8OxgtnYbrgKl65G1oQMctbhl6o1q0KFlyWAcLRPKVdnQr4+kptAqRqjOntJhhzY1U2B9Y7CsrMOup1WwNIWdvAcfQhmYZFXdNxGuVUfFsvJYNXIq24Rb1AqSz7FAPNbjnfSQqkG0Z2Jms2TdMygOpvqxCUz40HABiO7JGPaHW7LhAn62SowqGh9nLC4oJVz+JnSM96x+WIcYzqlYUr1i+EYjcO9D4IdUQjGNAHmre0dME78DYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d79TqB0Mh6GOENO1NfAmMDznzg6KUxg3Q2hO1HRZ0L4=;
 b=Oq2T8XsyqW0j75i6DvNMP343wVMX5HR84lTNWvwQtfXcD2iNtuvMw7AxTeoUV9Uk/Z51/nLcDb9CiK+n6RlPHBvszve+b01hpM8N3SZVqxkOO4X+fk2vetVPyUZjM5Svl+N8Z3w+FiySAVbAuF9slVfv2mhIlmTd0MtmD0hmeDw=
Received: from PH8PR21CA0003.namprd21.prod.outlook.com (2603:10b6:510:2ce::14)
 by PH7PR12MB7937.namprd12.prod.outlook.com (2603:10b6:510:270::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Tue, 6 Oct
 2026 16:02:03 +0000
Received: from CO1PEPF00012E63.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::50) by PH8PR21CA0003.outlook.office365.com
 (2603:10b6:510:2ce::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 6
 Oct 2026 16:02:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF00012E63.mail.protection.outlook.com (10.167.249.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 16:02:01 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 11:02:00 -0500
Received: from BLRDHSRIVAS.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 11:01:57 -0500
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <davidlohr@hp.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <dheerajkumar.srivastava@amd.com>, <Vasant.Hegde@amd.com>,
	<bharata@amd.com>
Subject: [PATCH v2] mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
Date: Tue, 6 Oct 2026 21:31:28 +0530
Message-ID: <20261006160128.31447-1-dheerajkumar.srivastava@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E63:EE_|PH7PR12MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: 3256f084-e39c-42fa-b038-08df23c328bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|10067099003|11063799006|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	+Z0WxXTGJ4OaP7hNgh5ciZXBPcmWnN8V572+K5D7kyNL3yppx8Z02WJDraUS4QzK/myC6buAUWQuBW0dYkZj6IpEbeef8vjXmY5Fecv4r9MwtnLhMZes3N99Sig/2vZOX0iu7V4qEHlwSsPcRFKWCKnfhWdy02e/SPtdxv6Heqt+I0znkRWQ+CBByRif7RJJ+IGCDH3onlmu+7xz+KzctpcfzmTymYmRhOpU3zxKI/iRnyblmYNuXSBgCX52a+wb8gpfx018VsYsXvAl27qU+shPBd0woY/vi8LQHHxooeB6YbJDwmMa31G6p9LdQiAYC5ReOV4IRnTyUcSKRKdiqTUjByTMypt9zAmmbie4wuJ1XNcsrPPRwXoE9JxqsKa4CJ1KD56TvEcwcsZg3yLFPhTYSlS7o1d3N08lw19YJPRRo6QcUO5dU0wJDjyZImcERExEgBGZgluk8YU6FWi8FW3Fylkg1KN1Ik+AUiVVCcQKtplKrktQN5L5NonGV8HBCzeDhhYAzLc+Eo+/rQNxWyYU4jrCw1tUay/hDiFYTg9XRN8c7yPcczfh7gOADPehee4+PCZWeK5eZ9yYn8idRtUvoUppyBzpM5hZvPk2LIjGFeD2DT2aYQjthry7Uwszi35Baq+qOSr3IaNxuLKR0MDkLC3oKsaub5MFAVKJnQ4aO2/llOnc/j4Uohp7KjEtC/pEzVXm4tYL91EO0NA4CQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NWBw7QC3AkMmGz6xqxGLiGyLX0FycHNzCmwVkLvxRrdAqi0sPX/eSEHv2qKS3b/tW4VS0S65Vr5/GHkddRSPp7S5fEnHhsxX4eFB9oA5p806MT3eQocq9tDAhUmgUSo7slL7NPqwLNKdZJNPprS76e667cVMdkxj2gK8jEzumHs3Dogs3KHqHvoCBoD0KwkoXwmcBiG+fDLRYj/9Afrv1FRHsmO22DdCbu47mbL1h8Tl25pdQkbN7jNryXnut1Y9Qc/AMvcCTBvJ7w+WxVRHvX8RyV/EdZOfsAibu4VC5EmOSF/BoSKwzohdi1axbfHfRQPeR9SRvodMCeIw0Pw3k714LiP3JSecaS5I6vPvH88E+zhOlplfcfZRXRUSccA5n6N1EPiYEleWJFOBKSFA+VSv1YUDwwGymTjMlIjYQ8ljRUhR5F7uwdVuZRU9uShQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 16:02:01.8265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3256f084-e39c-42fa-b038-08df23c328bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7937
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84FA8A0007
X-Rspam-User: 
X-Stat-Signature: 1dngtj4kniit6jueiafcncbqhzpsskcq
X-HE-Tag: 1791302529-326851
X-HE-Meta: U2FsdGVkX19kK9p2E7EBK1gUCLUjhdGdeSkcSIt+cipEAp/c0vJzzh44LkMPGdU/odH85kokq8/scmVxJ6abJSvLERb+5emXT2vFFIiQNa9inxptAlMt375ZMt8Q6O/BDb66lO6ettHMPZvnCUBBkIogYzC1HM2VGteild+eciT98VCX7CuzEzN1V8u20A5GgwuVP+zYphRJ60K+8d59+iZxH9ZOghWKuwif7qyfi3xNh0+5M9k74Roh3FzLYRjIeJrZrN708lW46OH9AgdgjeNY51hOdVdx6qC/kM+xjajv02nVorPbwFOYTmmqnLxBSeqvFQYtpkeLakEjNwHWF9xdarsYGtk/QlLDI8iAVie3zEb/rFC5/IDHzc0yEw4VALFNLnEbyC3+vAKtxndqtDhLxQllBLZiNr9OC1FxH0Jy5iS2Kgi9fOHv/OaVAxPrzZfkGPkrGonFK2UVbYGsIA8y+rMPtvkneHYeyZKKLWnJZQnmRkKHcLZb0dm63lUHSYXCFgz2p2A+Gr/nszAAr6vsCIpivkbTQHmN2eVaRXcIBcFMqNM0zuRiYZ9r8yzOsIkKC6mRuyiOI1qYHNhG5hpo92OdbQGQ4QHuuMzVb65aRESYQ3WzLf3LxbgPlpcWKHRmfF/e/yTqBgMtVGV0pcOCTOW5lczNKIQXgmSHrDXq1zVGxUVcFVsdq4SpsSLQQ7s5GfuJqq9iSPrZpiXfljm1tabc5RC0t0Ef4ZQrGvXxEbeRPs9AhxGQcsjRaYGhn+lvyDJsgbx6j5+Q7Cq+mFqjlr8ARpxSh7XrE4e8E0JtxZ3kxxhU+M0f5M2t4xN2XrApKccn3CqV+f7dNd4YNAoYdZql4Kk1CcFeBD/QHMSQ+gQkEaq0DuTxfrLHPmkVRYjdHt4qMbE65SoHgz6Ddihx0BcyXiTH1vLhLOkLkHzL3nEsMt1PRseUry5iwPNZK9e8mjAm+W8xNUJHSwY
 BoNzfPJF
 jpEhkcH9Wbxe5cpbUV62uBNAjHOPAMl77F9qlBZCTFqPeIsse7wl/r5s0f8m9UcQpF9dIFtAdAXb0OajNz2RibiBUQ1y9+IVOT2UcmnmbFWkCc517JbS9bvD2xosOqg5waCuicEZM40UZnkN99lMchJzaMDMpZG9IpszG6Tw2FUA4Zr1TLvt1m8IK8I63EfWxuCQVHQfCou2Pu9PtbZCr9mkpbROSA9b7wytEF4sDw9X10x13ZtGAdvVsqbgOASSpHnn7E/b42n6acpKtQEQftv0Z5JCXZ+Vvr79yyubTgUYumVbDKjMRlN9bt4khhpBPyrq3sKHqdGA3uyp/fKaH6IG4VtvB17Vpkzl92PZOzcedmwNUHBqX3Dye0+2CG/7ZHyAyF/UVY8neDBpc5c3a4BrpuWpOcDYHFX6JtlLN8VoK6D/Okc5X3CuJHMN8QQBwEABNpfeZtRL2SpSrQOizKe8vVKiWgXSrpRe6OYaHFpuikXhB+Gnu6khL9VKLNtLwt3x5tHXlnm9/XhLEQ5w5zN81JIwRduEAz3fIcSU7v9EMOoPjUxAza9mWZmWDmufS6ZWf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems/VMs with a large number of CPUs (e.g. 4096), hugetlb_init()
computes num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus())
= 32768.  The subsequent kmalloc for the mutex table can exceed
MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:

  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
  kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
  Kernel panic - not syncing: Fatal exception

Switch to kvmalloc_objs() so the allocation falls back to vmalloc when
the contiguous physical allocation is too large.  The table is only
accessed by index, so virtual contiguity is sufficient.

Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c9..6fc5c0bdb500 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4177,7 +4177,7 @@ static int __init hugetlb_init(void)
 	num_fault_mutexes = 1;
 #endif
 	hugetlb_fault_mutex_table =
-		kmalloc_objs(struct mutex, num_fault_mutexes);
+		kvmalloc_objs(struct mutex, num_fault_mutexes);
 	BUG_ON(!hugetlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
-- 
2.25.1


