Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802E5C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F906B0096; Tue, 28 Jul 2026 01:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E0576B009B; Tue, 28 Jul 2026 01:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4815E6B009D; Tue, 28 Jul 2026 01:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1BB6B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E04CC01B0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:59 +0000 (UTC)
X-FDA: 85037096718.06.5C9B593
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010021.outbound.protection.outlook.com [52.101.85.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 69D0680006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dlsOxNpo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.85.21 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217496;
	b=qn95sSgTkkW6LpB2Wj9UU1dvWQEdwTvVMcH7FztYGxGfs0rygRRB14ktOm4+I/8VJ//fRM
	OI3QIpfeh7TgdS8kRR2gI+ELl8duiO2Wn3rsW8f5UgN6iFtfF1dZ1anw7KhMDX+R5P4O+E
	/EOepK5/JkpCxBwjdD1HQS0NoDnvqYY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dlsOxNpo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.85.21 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1PK61HRureeKQSYvN19m/2LoGoH37cf1UOtTFuu4G0=;
	b=3Pk+2AIeEl+Z29i0rK9FaCH0BbOLGWDsjCI5IkKvvTO+RuJ7fg34ag80uK2YCUE6im6YuW
	wE7U4D98Rp5pF9mlkXeF6VG2gZSqadf7OYBPnmkrh0qxOKxxqkl0pAX+BaVQlACtnQOgfU
	inmE7P8OT0KzYzASMbt7qPKtpELhtg8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v3hF38g6g92yqPlaY9vLO4RJMXLzGxB9k9bHasXPbeozq+kIJijv/JWuVBzCQmQBbZc1ISnP30QpeKbGPVmW15sLlbuaoUedsIwLxvwez2CsRLKzorBL55boWZy1ah58oHsfC2dtrf7r6IsGT5AT/RMxPU+EUzo4Oauumg/7xbU4UosvPXQzwmWhSl/+1ItFReSzjAtABBfk+T6W9QJ/sPeydKnictW+uE0pIZYmaknTJK64eTGipW9QwHHE5E375421FzCiOJ4pjkef3YeVt47uqvr+FGrVaWkk7mSR/uI37T3YKBxu7Oed3UDwNgS+RFIjkNzLvXzxHDoYuFKteg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1PK61HRureeKQSYvN19m/2LoGoH37cf1UOtTFuu4G0=;
 b=osUQFfN/56JyoTZXcC2nfOzDjGt/p3QOseHqV8E+bML6DE1wEby8iKq0qqX+4jQ3hwOx2yUP8iYznOUKJx5df3l8zIjUrHPTbKVEqKp2wxiQSw3zeMhhA/OzSu6aZCjNb0kXToHuwDJC0e8oV9zQdYTYmeSSepobIzHczKqakJhylObex+KzBl8FL86YS5dtrGljpG+YIDL5Aftir6N9YKE5jdl023zMUSWqPvbCa4zpiu2lPIJZplovKSUgedL7jsdyb+lNf12O6aCK8BoNFwH1/idO6YKpSifc7Sgw7ZeWRhudjR3uYXT4MybcUplrAVAL+PvSbJ9FbzLDHjwIuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1PK61HRureeKQSYvN19m/2LoGoH37cf1UOtTFuu4G0=;
 b=dlsOxNpoNSgJA+lkSylL2Sqk5ow7So67Ztkr5RiYbCUDgNng7XvL8MZsPzdjEQxUQGLjD0M7pHGgaxKjY9OqYdG14VTgDwhlEjfTajOINjCE8NhmuEQCHtaqNXiOIiFwDrEiukfaTMPE9pAcVUH0gYt5Fi1FIOhk98zcq+hdLb8=
Received: from MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20)
 by CH1PR12MB9599.namprd12.prod.outlook.com (2603:10b6:610:2ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:44:48 +0000
Received: from MWH0EPF000C6192.namprd02.prod.outlook.com
 (2603:10b6:303:81:cafe::5a) by MW4PR04CA0375.outlook.office365.com
 (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:44:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6192.mail.protection.outlook.com (10.167.249.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:44:48 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:44:40 -0500
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
Subject: [PATCH v8 2/8] mm: migrate: Add promote_misplaced_memcg_folios()
Date: Tue, 28 Jul 2026 11:13:50 +0530
Message-ID: <20260728054356.291998-3-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6192:EE_|CH1PR12MB9599:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bbe339-c780-4e58-3da5-08deec6b5619
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700016|23010399003|1800799024|18002099003|22082099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	K47B4vT0rCpgXyWG3KI+DIssxp8IhUi8OboCUN19DrjGOs/8LTd3k+ZNuPIA3gU8cDjtc0k2my6lR3dy17P7ZTLbS5HS3CbLOa03MUTCC/DJcyz3FPDgsvQu8FrpBTfwI1ToX3Fvyvjbx8c+QsBslY3QBHcmEgf0UQdPotlkQxC0kA8IlFphBUepfuwG1vtlbPX1+RgVumOcLPQVT/5WIlLU2cyqQtGeJjSdVycLPR2VyOD4sRXNTiQZL1n0zba6IigNQQQDaSyUyQRLH5O4yZjifDwDwd8BM6P9W4lRvwF3Ska9Mux0YiukR2gSZHc1fcyG9PcQtL7pzgivHd/GqxGKD5tzCOlwdbIhsRh1qI7dJfiE3dQU8YRWwO3wd1b79IQMOBfyT/8ljXYfPMddhHuzpZ9ZBlR/8h6LYbWqgI8gtJwh9qo+awhvT7x4bXUvh9lmuDsVAugBkmiNtsoxinP8IiZRIcNUTC0qxuMF+e+9ZLLC+aXd9gSf8740ZdLcTSexoJfAh6eozUNbf8fBaEtkVSkXwJCy+w68hrp1GO4uqNTf0AKlTVO0mwUcd7Uu2RVBT012dUisKoIiwsNxHN6Lfh186pIaZffg5zOh4CyCHVye9nhdEVvl+9diftEslQp9xe0smd8YxpoL0uapQJUsoP5FjFYPnWzVAVa7fgrr0iICiXNISB1KRzSLkgViHrbYMCnztqmJUmihsEB24g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700016)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X7PjlZTUNaLK6kIkKzl45J6YB1LWrmA1iwkC49wbRBvyI1pBSThLwEZro/qOnzgiGydeJ8H47UAsGuw6qbjLc9A1KHn+KvhPJOjsgapT0w3g8jBzywFjdntbSUAKO8BNYTd9rpWtJNeXYJqWP2sggThkL1YOGY5v+EbQC8gxkn19x4JigaVQuL2ZZczmzI4kwWuXctW1isvt/Xk3EZ6OIaFpmsULl/pTcCH/F8c/SU2v0i8IG/E/vsFjddsaSWxBJLkVsCy+ykD8fotSOj5v/5N1/yp8EQZ22uRtlo8aQm3JLnsusgzDLo5VdUSFmFEO0lo9yhCK9BNcDUZEg9P1dKQ8TC6wIQl3y9vnaoYq/x/Pohiq2Gef+Aiq9JQxoHwxLJN6KUsGrjOsNJCoei1RdgX9wdUsXWVr8ui3/qLwQNpXYwUZs7pB1paDO40TMgeW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:44:48.2002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bbe339-c780-4e58-3da5-08deec6b5619
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6192.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9599
X-Stat-Signature: nztpxcm34gdt968hawhniawbf4orwdgj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69D0680006
X-Rspam-User: 
X-HE-Tag: 1785217496-928502
X-HE-Meta: U2FsdGVkX1/+AzB6RGPsV9ZxImgqq/4emPzYqVXq/pTy2yyCM0CebQAETMzc5Mq3Bv/K8FowsSAUScdBORrTVfp45ouL7HfbYy5OxZMY3fEdbvFxWIybKJp2tH7QnWHwhS/7lVA6veDarOgH0GRyf2dDJ0ElFYbF1eg+rq2AYxjd26cngZyYT2/gkGupXOLQuZs3C+1YxQz3cSbCfMF3Ts4ZJ4VMQzth2aBEK5HnbJRmerAPqOSdQEclWL/Ie3X8i0dwoOQIew+SOZmZ2IDczyzPEhpIbKj2bOMczssw/VwOhL6VDm4wvhMYqXxSA1mOyINEkqbqAQ6Hbb3TnriNhsFcjggG4v58chAZYO6+KT+4n3VVuPwlNs1coFd/dkgdg5NOSuPC7ow8TRF2+/bWcKUNDUNPJm1Q2hB6kfYD7vHp9LS3aX6KjJ0isxKvt8FMJEzqKlmqykQbrTfCabJJhxacDvF1FtB6/B8tPATuuaai9r2t60FZwqktG4Nc0c0pixMqmqvdhY1e7JbpitbwsAJ2iJXJPI6V2IbnuCzUZz+HhFN1hdj2N1X2yYxFi+INqTbCL+xOIP9DZeXFet1Y6iRuxLI9F8DahXVMRdXJgywiVUA6RzjxDnl8WrvpUIDP2gisYyi17l/z3qOFXN4Mq08agM7qLME9dM4oLyKpM/9gMFOJ3Acz+L1B33EhrCn3pG0spUpm97s9R5xyv0itxSjwYXzpcKoWKt24F86xzBfXZ0TyIc5UhZXyg0jW2l41IOI2UrIOwLvK/DxQFvYYaKFNzUVV3mRgSdLzj8tZ9YM3Z8GOY00S75bYtYQFHvg51sGL5de7cVrRhUDeaUnGqdsfAmuEtPGkEngDRUyN0p8TnofUuQJAokB+tuIw1B/Idg8tSf2eUHIINdDI0qZndzi4HRdKYyZwbvQZ+fTmV6x+OeqGFcUQA8HKQuVJWcApMq3PE5mHUpL2G1PSzCc
 EjDnl4f3
 34Vp12PIonkGWA5sKu8VOskKwMgEFFf3JDQ/7W/yogrm2cc9F4mifgJoUiZoASDEQP7JAVLEiQfadRsJqlCEOEnYNA3t45LiAacD7s3vkDSgusLW/jskmWhDDIMf5bTlHicTF1Yl+sFwhMS72F7KsEJF7CCaPh05Yoyk3LgQXqgyWFo2kuRooURRjVRA3SQon6WLqI2bxnman7Th7DbmFSGDW4Jx1Taa4y8IUYlU6bPvEhKyz6n+85T3CUyi7ywq+9bhCNlar31AO4jfC9PHDyX1W6liQC+eLxdLUqZLFifZtZZ/BXf7dBaVQzmDKEKlmx6Dkj4x1fP8i+4Pm/FB6hoW/65908GupQ6kicro6akJTTWjoCvAivfhUrNJAGFvPy7FPJVyobdbW3Ef7AgM0RBheOhcCXin9nvmEA85iuFBjWha2R40T70dFI0zxum/DN+DzC8q8lSZiOkjaXNCcTI+SIeo82LiyGC9eA8nyhYJoA/2J2nCZrWOuByxLPnbBsc34V0lAIiXR0eZsXr2StpwLQclSYJ6TacsKf5YdxIW+2UH5BL+wOn9SphwYM8e3YxZm0X2QGGOypjbHYjBiVSG11w/Ei0mxnEZkUoHHsKvNiKaCZyixi7ajAh+0TwstbBC4
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
promote_misplaced_memcg_folios(), a batch variant that leverages
migrate_pages() internally for improved performance.

The caller must isolate folios beforehand using
migrate_misplaced_folio_prepare(). Additionally all the folios in the
isolated list must belong to the same memcg. On return, the folio list
will be empty regardless of success or failure.

This function will be used by pghot kmigrated thread.

Signed-off-by: Gregory Price <gourry@gourry.net>
[Rewrote commit description, memcg awareness]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  5 ++++
 mm/migrate.c            | 58 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d5af2b7f577b..d136612eef9d 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -111,6 +111,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int promote_misplaced_memcg_folios(struct list_head *folio_list, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -121,6 +122,10 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index ab7227376757..58a8a0cf6fa3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2773,4 +2773,62 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/**
+ * promote_misplaced_memcg_folios() - Batch variant of migrate_misplaced_folio
+ * Attempts to promote a folio list to the specified destination.
+ * @folio_list: Isolated list of folios to be batch-promoted.
+ * @node: The NUMA node ID to where the folios should be promoted.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folios. All the isolated folios
+ * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
+ * stat can be attributed correctly to the memcg.
+ *
+ * This function will un-isolate the folios, drop the elevated reference
+ * and remove them from the list before returning. This should be called
+ * only for batched promotion of hot pages from lower tier nodes.
+ *
+ * Return: 0 on success and -EAGAIN on failure or partial promotion.
+ *         On return, @folio_list will be empty regardless of success/failure.
+ */
+int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
+{
+	struct mem_cgroup *memcg = NULL;
+	unsigned int nr_succeeded = 0;
+	struct folio *first;
+	int nr_remaining;
+
+	if (list_empty(folio_list))
+		return 0;
+
+	first = list_first_entry(folio_list, struct folio, lru);
+#ifdef CONFIG_DEBUG_VM
+	{
+		struct folio *f;
+
+		list_for_each_entry(f, folio_list, lru)
+			VM_WARN_ON_ONCE(folio_memcg(f) != folio_memcg(first));
+	}
+#endif
+	memcg = get_mem_cgroup_from_folio(first);
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
+				 PGPROMOTE_SUCCESS, nr_succeeded);
+	}
+
+	mem_cgroup_put(memcg);
+	WARN_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
-- 
2.34.1


