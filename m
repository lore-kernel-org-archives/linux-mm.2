Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A4DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2107B6B0095; Tue, 28 Jul 2026 01:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1AA6B0096; Tue, 28 Jul 2026 01:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A786B009B; Tue, 28 Jul 2026 01:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3FB96B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:44:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EF3EA130C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:50 +0000 (UTC)
X-FDA: 85037096340.25.72E844C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	by imf03.hostedemail.com (Postfix) with ESMTP id 062F120004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1bNT4Ru0;
	spf=pass (imf03.hostedemail.com: domain of bharata@amd.com designates 40.107.208.24 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J502XQJDRsIxQjpcELPH2NFLWogWtpNDZikjbH5afzk=;
	b=DfGQbKvMrXzZVlzwKxGaYywxCF5NUY9Q1ui8NxDU/og4q1CJP1CG0NCWD0wGXKnsr6UQc1
	mD0gl/7spVi0kS0PWS80LbfVtg6hEJF9Nn5IaT/RR7cZcEhrfcJSDq2fzEvnyEyOPRPvKn
	o/aUzBu4uUXptMlQbj0wGlM2ENGuDqc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217487;
	b=6JRzfEm9DQTdUPlcCCG6LR4x+dQcN4/MjdrNvcu4PMkwBfa9JzYSv4RwkUJ5k9bT+SSZTV
	by61AqNLhtYdX5mRd4bNIiUPLRz/4k+ZiJ4q7H9r1HSnj++G8hQEiy5xvveAERIisA3Zg0
	P55ngPYGioYSm8mPda2AMgDJ03Qi+Bc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1bNT4Ru0;
	spf=pass (imf03.hostedemail.com: domain of bharata@amd.com designates 40.107.208.24 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKiXcaeur3sIEVrNTtVczCi7zmqGXsE8jPMwFf3jbqBKCL2i1oUClvbbGa1PUI83M9p+7EU3ZR4BHi7QrsCZ79w2EhnbwVnyh2VFEmTMJMB3HpRZXX/b6jjYWucEAMi6SQ1KuynANDqjQ9I6hDmxsnZ5lsKUj6hxFL339cCDpL1gyepPPg97GHrjGhfsAut2m3p5awnN9qJvZP7fgLtpNMMULiF6/3WtIQthTvZAE1V0VRef4rS9/QLg5gIE8IgTDbv7wQP5Q4MyTVagpWPQ2bq9vfF0IBaYNjaMSrRUrPVr4r8ph9a+j3Y6u/9KnMleB0TKU5QBySEjfI5taSUEHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J502XQJDRsIxQjpcELPH2NFLWogWtpNDZikjbH5afzk=;
 b=wxtjqMnxD2Xfv8t9p8iqee2y1OZQEO9M+g6BpWrHXgpXNdzhmQAMdZZrJkILvAIjROFcb/9Pv8XuMxQ1N2IVDRH1jjdQYcmORSSiRmTrZ4PW8usb2A0tf8965Smqb6pW/7evP7+9D3+YxEaP6lrNshKUmEFqa+swJegP6x4iDI0W/gq0Tk4lE97CcuDHYbC8QMLO79/STU4cLOHZx0jKOpcP1g5OpKYFembqa59ohwnhQFoiMir51Uo31+eJ3iri09Qnecu2fw7tyo5jLb0EQdv7Iq1/JgUQnkpQS83eEzl03olFDaJctwdSGnrdnzOlbeMUpEelidDpsNLmi5eMqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J502XQJDRsIxQjpcELPH2NFLWogWtpNDZikjbH5afzk=;
 b=1bNT4Ru0CN8p5tafJAjhZcA/lwa/s4MuVn26q0PM91OrLuwlcYHxVpXY8rdN1NBlTyYw6xHmFSWp0ZnQbjwLxpDL7QLE2Da3AKD9iXoxq07UMWORday6KER0FmxvJXqJAikzBxy/MFJCEdU6wzpuNtAmQUxEgXgBgj96ucYLkRQ=
Received: from MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::10)
 by BL1PR12MB5803.namprd12.prod.outlook.com (2603:10b6:208:393::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 05:44:40 +0000
Received: from MWH0EPF000C6190.namprd02.prod.outlook.com
 (2603:10b6:303:8b:cafe::34) by MW4P221CA0005.outlook.office365.com
 (2603:10b6:303:8b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 05:44:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6190.mail.protection.outlook.com (10.167.249.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:44:40 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:44:32 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>, Bharata B Rao <bharata@amd.com>
Subject: [PATCH v8 1/8] mm: migrate: Allow misplaced migration without VMA
Date: Tue, 28 Jul 2026 11:13:49 +0530
Message-ID: <20260728054356.291998-2-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6190:EE_|BL1PR12MB5803:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d826529-ecd5-4fc0-31f6-08deec6b5188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|376014|1800799024|56012099006|11063799006|5023799004|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mNxxP5aM0Z5//+k2pXgb56C2P1+2eIXtUfUgPtxKktTvj2yDs2j758yDwg1qDrLzMk576koNf151U0pSjuCqdcMWNI8lnjgmSprlEHyidOuq7pf+u9NW/5ZoqNfLPW0jgabUlgpPW+hMacjZsEZeENnihEFHqIuTyArcoMzh20ittv3ujpFWakxhxF3om0kdWeJWDXJwbKk5GP9O92pxFFBvAN6w+p/bag5KJFmiQRuopMn8OZ5/qn769UC20tO0oxUnEAbTlzQrTwz/VmpP8lCNfLhxdfJrVBPv/nJi1tJRGUZeTYlIaAwJmag19cReXFrVgEkq7m9MwbJEJfq/FyTXveZbinrMR4GEPjw8HuyHOMdZ9Ddm8ZqpQ7wak4FqXk8JgGzvElD6unnRqJtWESBZ12h7QEO66MC3IpgyqJLIaGgb6nfM4SpIvzTEpJtXbc+n42A4lOrtr7peLNf77kXLrcStw0fpiSQ0pEgtDjKptzQRzPLN0tOV+wWvWJoPR8JNGriEo5OKR2i1tYld62dQZSat5XpMamTfNox2r4WP+M2FVeS/ySGv9sO/zjY/YdfhmJziuIWpiJLvs1CW4xqUKOwtLSgH+S0DVO5uohU03I6rvTmFISt2y/BjVVmKy13LqG3ugKZPcliTVfRk0I3Dfqg2lUMyEB7hjdFIKvoSQRtLYZTC9j0XDUGUP7iPKNfYzz0QYEM00uREdPIUFg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(5023799004)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qZFkoQ5fgbQchcKbr/vOjkqfXgagOBM+MEhSKdP2ro2kw8qkMPbTgcdG8N2sohxg1WPItxKSIcHaFu60AUNTZ4tL/vqjdntLHLM9/vLnMBW5lTHcyXqj0+33Pr6SH8Btb3QgfBGmUgA5Mr7Ede8GUIzSKsijfRrKvdFD+KNDUlT8YwtoFO2wzsX3eeOvu2NvpJ6sEz4+RsAFiWcwds0q7TmGyl4G4VpAOy0Y/oUyvMl+UoqyIYevTbFkdGER6AWP7Q0KZ0uv7qoF2L/1CiTQzQ7N3IGSjsby5732EI8pHXuPwZ9T2LlRWhy9ZprRATWqdjQO0idAyS83V54SWlajZw/Q9zQf0Iu5GIpAKl6IjyMLyNaMBIDHC31BbA5/66EOwjYMRE/fxlRQ+8Rz9nSjCDRRj0Q0RLGW7OvQHPzsQSqAhg9X1yPg+a2TI7gRsViD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:44:40.5393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d826529-ecd5-4fc0-31f6-08deec6b5188
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6190.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5803
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 062F120004
X-Stat-Signature: na7ez8xniomho8rb1ejshcnfizaqmghw
X-Rspam-User: 
X-HE-Tag: 1785217486-400704
X-HE-Meta: U2FsdGVkX1/8tk7QWwxSogHQ95VZXQeqjjOqgzez0s3LYc8QlWhZzfDycD3OkXJHH7CHMBC0IrEmy23He962OP3/1IRmH1wmLEQKNiVRJJUUUhqJv2JJlkQ+AjubyP3Q43JtSiSZy5g01IbEO14rUC9ynnTHQj8Bln5Qqw4KhNJ7XNqGi7XWyhfEFS4k5hc8vl94WtNLQU8Q+wpE2r6o8ZFnwKBHrrH/KwxKF/SAFCXDg1/+wwyRa/P1mTJYUXRA25Cc9MzfMOBXU/ebVk4LQ5uWtAiwg0MAGl7sv138aLo7I2xuJ2RRjGTk7eMaYeqpbPv88Vv3XLpkvObpN1q7GwvFml4QvZ33fkAc6E0NLpZc/AZZMF2gI0BOUBVbtD9RXqatKILQORYgXCK6T0j9unn0x52bdm90uRpyf80bFqGxN8G2PDLpC4GRfC2B6+o4jyua186krYlK382PxO3LQR/aq0h6/pNg3PAkWEr78o573QAdojXja2xRj3jpwSfGjyKhfA3rSTajZpCaH6/IrJMV4MDCP502UBy9IAAx9oSCaNKRj7m46Zf5y17T1pYROgkNRNJ/CvyVAyGdiAcgEE/JsRc0PburiGukqNZ1vmSKTm9dEjAkNKUkf/KF0zZKFLLwNsBzdJoKTCU71WbOqMAItBogqQ7I3JrhulH3U1J4TV/7S6D/+T0kHNukaD+wbdvQLPLcsCU4Tolk2LyTBL2xd5h/5RpYq8MgDx0qdsY/oX8W9q1ZqJEpmDyw/aLH4Uo5wbpafxmeVcoakFE2SoMJ+6iFCvPkd1KHHLA8+BuQCmZVI9y07h+wl0sPvLZX5R+S8NoJ4O+XLIDPh4dM0H49TSSaFJ7sZIwygA1B4zr+qFEyCW71OXTbgRmoUmwIhNEvzpGfBPtLdDmiCRXQS1Dz7OXlNi0XYej7mU4dnX4d7jmcTQkpgfUNM2ji//d/tCgE8gWE0/nfpj8NAXE
 tONM4sQh
 eUNpHP0EZ/MRxPN072B4z06IK/XfJRRk1QYx/TmK8Xye6EgBa9dMep6Qq6XQHpkIZJ/eio3opCCFcCioiAox9u/csBIDJJlT+C73TL1aI2TPDV3nWo1jAGdgoRXKi5/ZmhBpohio2VTEzORD+XAVeieNIELSkGgQG+SWtusw9HLqn/bvd8Yk6D/e7aOJQb87IQNHFXx6xSsvq1jkep86u+IwzqzHSy9qh4vp53DL8XzrBREzLQfSKhCWnv/js1ATGykBqK8aAD/CKwfRGknreHByzyt9CnCe38ZGsML02Ua2ua25WBhkuEhzASgIX9ete4HFlH0gDLoyoa2ctOe0vE+ZpSy56PutCsw+uQRqyekwGbSQrM+gvwOkuEZlQxb5O60LmE8Na40X417X0caquMoaSY/PCgPsV9m7yk8pMAyAF6/m9O8KpNpAU7oYF4i7/HQKm266Rmdyn/R4bc+dOxzJ43RqE5ejzJgS9beOyHIEks/RFLQIUf4sc3uapGv+47Ee0nnppOxVAK3BT13IsPVRjyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that,
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Therefore, when VMA == NULL, migrate_misplaced_folio_prepare()
does not require the caller to hold the PTL.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..ab7227376757 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2674,7 +2674,12 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
+ *
+ * When called with a NULL vma (e.g., kernel thread initiated migration),
+ * migrate_misplaced_folio_prepare() will allow shared executable folios
+ * to be migrated.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2691,7 +2696,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


