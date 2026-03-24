Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DF2FEC0F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 19:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336936B0005; Tue, 24 Mar 2026 15:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7896B0088; Tue, 24 Mar 2026 15:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6606B008A; Tue, 24 Mar 2026 15:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE606B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:10:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C45808B699
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:10:44 +0000 (UTC)
X-FDA: 84581898408.23.1CBF66B
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by imf12.hostedemail.com (Postfix) with ESMTP id 987AC40008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:10:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3FjW5Y5m;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774379441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L42njNdkn0g2Z2EwxODJrKHlsvLi4r74QZXuLpsoVWY=;
	b=JXJ1I4ET1alIU6iKTtCr+6LjLAwAGX7VTJmmsB/sjbObsegAO9i29TxSkJmxJL6eTwWBn4
	reESqVzkMC3/i92y/pAsnPuD40O3K75WU3Nvcj2P9/dtQhjjQROVP0TjcISgDq7QDmDsbu
	Jdg0MEpl0S4Tw+vnHbRF0lYWVBlfBYA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3FjW5Y5m;
	spf=pass (imf12.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774379441; a=rsa-sha256;
	cv=pass;
	b=2N2wLeOq9FpICtSrHLQigi8nrc4wJgsI8ny4v49HMNXCbDOlrfI3R9NoxLLxJzA6LxJNLe
	4Zh6jEdoaO75aEPr5B4v1GOG5RpjiatVT4kYnlZfSVCwKvK7h1Itehn+P1Wq+ICkgqNqcU
	yKcsamnfB020ueGQAWT+UzKa7tdxcrs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyydmWCua/+i11tpxISqwF2xwtQdEk3h956RAMtdNzgL2WTVoOriWn8r/xusobaMtFi7XJhiLHWirAe5OJwxmQHxOIhYKV4bvkTomRK0supHcN79UGwkgue9oH4NeFCEA/LT479SgbW9kvuRt5x1SupYA+oOC/XydTL3Oj/axVyqFIlawmwJizhoSv7wFjsJtGmw6S7Uy4jAKr/vtroNKmwPpjzUHUOg+ixtxE05zfDENPS83HPjcHe2KHC3nrxOUxEv+W/pv+KmnRtHrrV7qa2z64WkKPDeNv5Qkum5N+PAswe4o+GyN7EHJtgVU8kui1kLmf2Vgj98lgKOs07ZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L42njNdkn0g2Z2EwxODJrKHlsvLi4r74QZXuLpsoVWY=;
 b=QZKxkkztsHwj5qDQNOkFySHuoq4E8inBb7cSmMPsIRFw/PBSDNmmYwbGks7/pitycMVl6GKNjw/LskiQYFm7eEgzvKWm1ofvHBf0gsfwl4Z5S+bX/uF8az4/ZM1H2vDipD4+Ik4dbxeiyxlD1gaIcpKpXfBCdfbHXXtC/opi+pt34GapzSuaHyk3bdKFy8RDzQwCKSXV40oEA1GPbikAoFHPsT0qZN7v5rz5EeLVNQT8frGRrCBIAilS0Xoe2sCGcWjPBbmW6/kGuKto5HVT/Ef9Bs2nWYfEugy/PXu00l4gnfchm5xeXDMdnLU9JiM1IJ0afWd7l/nOyt82A79b7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L42njNdkn0g2Z2EwxODJrKHlsvLi4r74QZXuLpsoVWY=;
 b=3FjW5Y5mUCBUUdCCF+MgQqA9TafbOddIHQNFPmPpFBKqVn05PgAG2O5Srj3aIx9hbg81lEyTDCumpI6+N63g3mVWYUytDQrXCjiDHAt0N/GXte1CNuZPkqONVjME6GV9c6esl4Ua7fczXNEYGrGqXszA48SrzSILWvZ6lPGbiZA=
Received: from BYAPR11CA0042.namprd11.prod.outlook.com (2603:10b6:a03:80::19)
 by SAWPR12MB999139.namprd12.prod.outlook.com (2603:10b6:806:4e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Tue, 24 Mar
 2026 19:10:38 +0000
Received: from SJ1PEPF000026C7.namprd04.prod.outlook.com
 (2603:10b6:a03:80:cafe::9b) by BYAPR11CA0042.outlook.office365.com
 (2603:10b6:a03:80::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Tue,
 24 Mar 2026 19:10:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C7.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Tue, 24 Mar 2026 19:10:38 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Mar
 2026 14:10:34 -0500
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>
CC: <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
Subject: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 24 Mar 2026 19:07:09 +0000
Message-ID: <20260324190706.964555-4-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C7:EE_|SAWPR12MB999139:EE_
X-MS-Office365-Filtering-Correlation-Id: 6223ff2f-289e-49eb-2168-08de89d9090c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VwJ+c9iTxJvpJxzn0YPVy56diRIP63+xZo23gGQu6HdIOKxDSs+CECH5zZhusCfZjVJ4xd7Xh+wXlr/HXWaILARgUBfnO2OIBWqEDzXAcGWOfNTOk/UrJnrgI0kLtFFTR57IXTkYRSCL0L7k8oaZM3v7UHwWgzcpuW7a4WtaaWWNalfQY71kpuRuYqdQPNfzI3ibcgtrYXc5vfgRiuYgT2SBrOcr0EfR3pJSdT+s+MEIf/1H29FL5QUM2tIJKlc8/2JAVFkUO0aGYgyZ+In4stu+EfSjd6+NuFk5UzemyJBQFaO+lq7t+O/H4IHmayzC6V0ZkxSn2362FIWxeb5pSFRh0zZEl/aC6YC1G5/NGLMhVQ6+CIZG9WMBQhGNkwGr49hDBmNIPijwSqAj1fB7lcmDjPfgesNxijIZLCNvZ4VGg3JeBPCc4Hfsm9N3jTR4QJU8203/bqQA1sf/G4+Y4D3qy8Gb9EAjvmlS0nDUoAN1sTzHno/d8AOunF3OAPNr+Y03YV5bvRop4EK4O9Ky2ujMRspOHKBnUCRCJwmrffGWr2IN7EFL2WLt5A3it0ZPqAmBtj2z52eTlCpX92+TXYcWq7JhiHXMCepMW9W2Q8RFaIeLfkw/EnDYot6Inn48n+EjirtpqqZBBwC3TGuQ7+Pmbg3xRWRrbZc148wfhpl8WI8rG6GduV3KriKMPub0bd2XK0xT184OcA66lhOITzm25mfief9v//DuFKWlR1FwtR01E9fImCQld4ViMImqcG/1ci9nb2V1K9oHvqjjDA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5Kd+BZuidaDi9rMM7raJ/65/0iCLYEedvFYjA5hnPpmiMbCDpSf1OoOL+H0w2a5GKXJi71Iegb/6cZ4IrYItuFSyqo+0Sk0yZkRjWHM/DqaAOLGiW/k+PW9BdDTMBNRYSXcdIS1iJAtCl888UwN7TyXK5msoexGetfFKcgfCsDLk4+R8at/dwTOBg+2QzRMUuT2BDuuMgkFJWFXGNfTZICR7O58WIkf/IODdrLqzbHTIOGuDMe3eVOg2n9CH+JnqpOho0uo7TXQQG3il+ETem37B6hx0UM2b8tn287EuHRrkxY6vk0s20vkkUpJoR8ereioLAHEwFwamoEJZYNE7wB9uyzpWIg8Cxg0GdVeKHh0KIbhPWuacQMQYavDUUooTANahYq+8LXRpwtVm2OvRHFVhIGBJhmGNqo/HW72Ql7X0UZucwQMuyeBovdrKagBD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 19:10:38.4803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6223ff2f-289e-49eb-2168-08de89d9090c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999139
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 987AC40008
X-Stat-Signature: ipqa3bi1pcn5psyfo3w4ezkrzs9xt3d6
X-Rspam-User: 
X-HE-Tag: 1774379441-87226
X-HE-Meta: U2FsdGVkX1/lVjNI4dimOXQ8Qkgos8nnzHF86oVMxRUfXu6tCICcJi0KsMFzvVOClh+/fwjYmU/4ifOgFE4+lSb2Lnm7z2eX0I9gavYfwY3mKC7HW8K6RVjNdmmOOWs+Cu/Iz5HzbmL3Zcm8LJ4Gpr5MoSn5QD5mX/sqGErXfSNTerywOKkKyHS29JonH715isreyKwC9fzM1AsLuw9/ciQ4RArgxGiGsN73NRlWAxD68jVbxhHHfarA/3WLdKVua9QOf3aW1ei5hLb18A3hVq28p3GqWJ4EZNAuP/knuFIzda9TChG/u/DGNfErYNYnFDbpv70xL3QiKWkPdYMx/IL5l6UqMvAIAh1eK/xPBDUHTZe1sC4WI6bvLpWeJUTOAjoICNn6nZsZ4IXQbEAmFT6FeBTbesQQkB6ajP7mBh/vzJqdTAXAHMk336FsQ8rzP/24q4ght4BGqrYbCUCyB+u6a4rP+3+Pcl/L8XgLSRHIjjrcGWtGjcdRX8+2PY4Vwl66OBAO4Qlgi0p7qc9RrfPCrCS25tXm+x9S7FWum7lOs3F5I8TXKshww1DflFwy4Tf9jcTu/d9V4cU3G7Oc/whaZsE5n7b71Ez1NVYnskEq9izHBpPoxgkFuiIL4rwNusnto5OMxdv46+k/5FNaGDbRD7A6Uc8IYCmMd6ADN6tABAGuQ7q4sQioxfTgBd1lPaAmvbhCqcLrEkzPI3SIyFSXhAY6GEjqcu+fmNXxlIZW6J+jIYRKjMF1hrmn7hVL/8WRZ0yk/turFQe5+KLOCBHDYAATOydaAcehy0canhFZbCY2GwiSRgKd+mwuA7DLxkzsA2N71wiyzGupfURiSQctvSn3ojn8hq9IghGG7Y+6yrcC9qimidWcPZCWukddC/K/uWydsJ9Kgx3JULUnkDd2Z3Welj1NzgF1V4K7l76pK7MbLGi8tgo7WA1fLYR+ZQ9JtSqc8Lo6jChvr1D
 31yU7cTd
 DeVpUk55q2IcOTm0VzHuOcRgek5GGiJxgdkKD9YP8hSxr6qn2yNYgx09SQ4/KggUCM+w4mP/H2EStLeml0xKlcgwp5bm11S9rrcqjYdiEDlh78bp14FrWMwxIaL6CrWtb+CkG5cuSMxTTVaLYmPQlGfLqrD/J1FKOnKGnptnuQ7+R1eaK7YlqiPyy7oLjLGajCQXg6NNeaHi8JN8Za1umXe1O0FqYInW2L+wHbKG7EQTHrSl/i9IZx7kytFeDLerEKknzg/4nQyYV7TqFR5A21vpPKfLY21+CBgvQmvDwqrITfwUouUSOd9tHoWldwtjC/PD7Pp/lUv6VmKogbTjcOiEzXL3NMIVUL8TVzRgdxGkBdobmTvwXmcOEYqzCLimZMUORjbEc1JMs6kPSeSeCDHt9SIdTYZov4WclNtO+cDZbh5iQI6lHGWqne5K4yYTS8Tgj/hHVg+VawYV1MOE+kaQ6JFx5SOCyUOIbpfAGKICc3zc9I4KgOx4ysSmE81tgOB0VFUSAyu4LgOw0h5GKfToxHwLnAYzKnsYV2YbT7ggg4qrHOgIHYsEiNTe6EMYfWYTAeM5K9ENz4UWzWEXSxf+twuwkU0VN2Uf/gsw+ev+9HXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These flags only track folio-specific state during migration and are
not used for movable_ops pages. Rename the enum values and the
old_page_state variable to match.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Applies cleanly on mm-new (02b045682c74).

v2: https://lore.kernel.org/all/20260324114720.864478-2-shivankg@amd.com

v3:
- Change to two-tab indent (David)

 mm/migrate.c | 48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..6d4a85f903d8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1135,26 +1135,24 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_WAS_MAPPED = BIT(0),
+	FOLIO_WAS_MLOCKED = BIT(1),
+	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
-				   struct anon_vma *anon_vma)
+		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
-				   struct anon_vma **anon_vmap)
+		int *old_folio_state, struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
+	*old_folio_state = private & FOLIO_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1209,7 +1207,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1253,7 +1251,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1302,7 +1300,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1328,11 +1326,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1344,7 +1342,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1358,13 +1356,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool src_deferred_split = false;
 	bool src_partially_mapped = false;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1395,10 +1393,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 	/*
@@ -1439,11 +1437,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1777,11 +1775,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);

base-commit: 02b045682c74be16c7d1501563f02b0e92d42cdb
-- 
2.43.0


