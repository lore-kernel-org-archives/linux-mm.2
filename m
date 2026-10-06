Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76A6CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 14:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFC96B008C; Tue,  6 Oct 2026 10:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986666B0092; Tue,  6 Oct 2026 10:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875866B0093; Tue,  6 Oct 2026 10:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAE86B008C
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:02:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39ABB1601DC
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:02:58 +0000 (UTC)
X-FDA: 85292367636.24.B01965D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1138D40007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:02:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BXRUpDlx;
	spf=pass (imf04.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.53.30 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791295375;
	b=wkeKyPHSifd+xZ9e/26879HNvUZBAvVOY2z9b4RQDM2njnhNulxHv1xFgD/xC1OL2XsN46
	MRuu3ILJGHEiZUcKtDjhvtqaD/ucn1lBRQCVzthp9HUAI9E6LTIRgnZ3S3hUduZsTRGET5
	39jw7eqAG0SFS2PMdesXx+jMLuQ+7ho=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BXRUpDlx;
	spf=pass (imf04.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 52.101.53.30 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791295375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gnc1DXH3z+94CkqZ0Vgycit0j0yjvcjP4WFvDeMMum4=;
	b=k8Y8PZcblA9h1Mw+2fzcmRTwX/xL3xxdYWg67p1flvIBtfkLwD6yIJZZX7MACdP4z98ZF+
	xqNHS8Idvyza3uikvSe9JU1zL7zXV2RP/hvUVnZjlnfZ0w1J38H/lGB3ZMPLGtcuGcsj0u
	lJLqBGUxNHYKS3Ilr9szbRYrvauLSTQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hB/Nz5ekQpv8kMee66f6EbI0akPFJ1/e+gxQJgmfocsFAk3pzIBwx84Gs8JF+z4+3qP2hS5YZHJw1CNYeyRyC12tU5hC7FmOK+yQj20ntKDRWDwpitz35/KWrdsTDHwumKSmpYX26gw8VBI+V1BPG9VJayibPpdWaEbl3oZd/VuLCO+K3O4ILbvr4KvvJEg8XaKo9A+VKTWqhKymjGiUXq7zOKnIsn2gzTmDE92jYMHyKfxAYhYWivfGuCUY33UC/1/enA6w0IkDwX2nZJfYZ2s15jDr7mn2gg74ACLk7gGs6UhaPC+3OEnd4OYDsVBLkKIIXNGySZ2yN+FQo6GzEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gnc1DXH3z+94CkqZ0Vgycit0j0yjvcjP4WFvDeMMum4=;
 b=qKhG5YH9LnWcqlWo+lQo0UG/sJ2wzinuf3XmWGPVynUc3ESa32fhdneVlt6Rk1kG+KrVjKnnZVEOR2WOZU5Clgl4mFuuy3aLijZjVSg5uEqsY35LUEwSWC9/Ru+rlqLmipzaqr9RX/3hHJC5A1ownpgRQXGP1vLn/MH86W2P/8cqh+yH8bolv9aQsZhWbknyHR5Brp3GWLbrkokgFyHNMPbWInaJyr4bPK0hwCQC8YrovkpdPrqwix1ueGtKi69a9Rg7bYCSz7SDpYC9JUm7RS/w4NhaLszaoGDEygMyNBZ3+ZuGBbeHOKeHVnufWTafCeX6K26/h3N28/AI4JX6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gnc1DXH3z+94CkqZ0Vgycit0j0yjvcjP4WFvDeMMum4=;
 b=BXRUpDlxEYoFpNo7PU48O8g7hBorBB/KLqxb/BkOV8noDzbsm6OsDvkG45WIkdCh1e8NFOo/gKU6O+M+lEF7BzNetkuiBRCeVh+33ytrY38hAJ3nHuR6UVwF6EKS3fcr813ovOcYmF4oUmnYEgogycgaNlOMbpK5BDz0czrf1gI=
Received: from BN9PR03CA0875.namprd03.prod.outlook.com (2603:10b6:408:13c::10)
 by PH7PR12MB6441.namprd12.prod.outlook.com (2603:10b6:510:1fb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Tue, 6 Oct
 2026 14:02:49 +0000
Received: from BN1PEPF00004689.namprd05.prod.outlook.com
 (2603:10b6:408:13c:cafe::45) by BN9PR03CA0875.outlook.office365.com
 (2603:10b6:408:13c::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 6
 Oct 2026 14:02:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00004689.mail.protection.outlook.com (10.167.243.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Tue, 6 Oct 2026 14:02:48 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 09:02:47 -0500
Received: from BLRDHSRIVAS.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 6 Oct
 2026 09:02:41 -0500
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <davidlohr@hp.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <dheerajkumar.srivastava@amd.com>, <Vasant.Hegde@amd.com>,
	<bharata@amd.com>
Subject: [PATCH] mm/hugetlb: use kvmalloc_array for hugetlb_fault_mutex_table
Date: Tue, 6 Oct 2026 19:32:26 +0530
Message-ID: <20261006140226.11684-1-dheerajkumar.srivastava@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004689:EE_|PH7PR12MB6441:EE_
X-MS-Office365-Filtering-Correlation-Id: 8291b661-ca3c-45aa-f590-08df23b28122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|23010399003|1800799024|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	4MseebFX7g7hJ9zrRuv4HMshSYKCbok06F3AdhIrK5MmdHHQcheV5hrpUfFxsU5tcbmvgJKLjRqSa35KYoAdKmNskJdT2Bz/dh1wg+3wjKnn3PnG6uSLautJ1Ne3nBKqejMHPwZPHKx9YUiWZzZRePebHL3hrNzfW7Uhn0lhRxW0PSaH9H7X/P2lp7Eh+jE/2LtBTtgdA21aCN3gk4CszxFed3o42wk1AN5XnbrEqR0dDRZjm6MdPY4L93KGnnIbWGg1DbxRy5qvpzSMZIpg+7NSt0Jk1n1gIMPe7zH7sDlKqG86GDgnbSeYa0b6xcaSpzgQQHa7L16Ruc99mmnzfI/Hs249Yrm7YtnVJxKzx+YOqe/1lA+E1+C4ahin1V7wkkXHdVOTPI5NDybNf0VVGwdyujQvLJFU0PEkC33Dp5cTLSeTZZKRzewVGt315Bk3M6KAzjzJgX5EseIDRVlRN4IGI2hVadOvCJQegrL2MF9nLUaMUFXELJGCF0jUG3WJ/P1X9oFykcB98WYRY0IppsSPzTNYutGwz9shtGDBDRzuKdvYKUB3R8s0frI6BRuFaO8h20Q8UaBwrYjTyC1l268aMF9oDt88ZjCpAutUOPWHGa0ujvz1YEnolwIbnslTFrfnq5M+hjKYmvxHJm0i8E0T4HArqXrjCkQahX+AFbgSSwLxznfMjwt2Z1Nmg5mscBl3mkqAGuGG9OaD+7O+uw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gBDMMVQb6gY24cj77fcs8teYLmSaWIKgWBVjCIEWsgWTsJbVQUuv3EboAjaMoHKiSfPOEOy1elDBYLdcK/KysXmcpPIREyi1TiKMDkJLgureAiuKcc/yMd59heNx7DpFs3+5STycCA+BwPp6f66/1cV0My0RZusmX/7ppeYRmCLWoksvpYi6K2Bz/SqRRh7xGkOU7v7thVw0cvNsDG8eUg0lNp+WHFhCNEKPbqwfNKVMxeHF3L8QNxsSuEfugw9PRy8nzlZbajnzVh2K3Zw7jAexWB3yBhTp6BTg0ojmAhTTPK21TJ6AWYaro8X3hIH0P7dACcQrVyH4qXc60oJxdCyfRFADcOMilJlMa0zJC6DKTXBeO8m2X7LOaXj7TP5J8hhYz+0FlBCLZflMXf5C6ThDF2G2SpxkUnFEmPO9cGMETwLs7QMBO+sD9g6XwpIN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 14:02:48.7132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8291b661-ca3c-45aa-f590-08df23b28122
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004689.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6441
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1138D40007
X-Rspam-User: 
X-Stat-Signature: a1sb5phz6x54omkws6zom8smtmnshki9
X-HE-Tag: 1791295374-72630
X-HE-Meta: U2FsdGVkX1+F9io7rGKwSkc4Y4CHiUBauuDjNro20HfOXEVfFtK2R7hA0BqUbApmjn9kSiOvT5nFv2sh17nZ5TE2JYANFE5ruMswSAx4nBKyv9ZkwvXW9GGWnwHrjX7R+Cu7ZxXIMvyvku64X2y1yq807whTkgVUh+o5LYM9GIy0WzHEkFkbO5OoIXjr9d0A37jWaIDJyVImK1vum7EO5aTonMbKsaeXWE5DZNxkf6FuCGuhW4eR58/4mDuHo4IBTFbc9xHUV5rx2o5zVu8bdvXfPXo0HHjYoWwbKKUfygIGxmdxx82neaPX6zmyegvcAlTfZw9bpTzcWnHTC3rbfQF5CoeF42hqasuMSXYt0xn/O262bMJ3GbuAc/gHum2v7iJ4j26qGA7pBbSqWnn60M6pwt1GNuuXyhvMvKAXm54MYKpK/DfO2LvEqbfnhhcejZjsqUKL9L5UTMvJAboMFVyHsLcZSq5tHtJ16tSgra0scEaQU84BecdKUGetIzs1D3/XNHJ1wDO2cR1Ykqe0CJwrfqntQEGwXyg9WNK4R7wgVxy1qnvWmVrdZCpId3FpFi+VQOs72SrvHWijFVX2NCY6zNw3KTYiHzGRlMMF+BBDM4Z1Y+ax/zZnfBHtFX6ZlFeso1eAawcjoFsMjp6akvi7oXz5Ae9Wg1noo4a8M2VjfINlB9kajE/SC5F2o3zDGHHb84CTKw41zJPNNFBhj2oH6cgUUqQR1GEedWwT7YoyzfzmQLH0Cnnaq9BzOs0o3AD3Jm5+xPOEOyEB4C83ms1brMm06IQBtcPScoUgtyquBoPvfF5mxdAoZs4hk4Z1b0qkXfoNR/bNUrpqnwmQ3R+I0I3gQHf5WEK2B07AWNqyuJtHMbvApFFuVuZIlndtp1qKnjokr84UsaPOKCRBg7UMxgR4yzxkiqhsmYJZkKdNkXNasuVlI1/E89AvQDZGm4dXGmPQPF89+3KfNZ/
 mcZy6bpJ
 n1Egx+J6b0bVuvN8LjNUnixxMw8qUtcmDLm2LNdQgB6/1eQSIL8Z9V0apWhdRSEFF+pMCbdyH7VF2Y6A6jVBoOUZ8S34l1Fy8WuQlEiCKey56EnvOukmP9tC12gxRfw84HoAriXGlpv+xf+5521RSxSytJ8SHVDzTS/qdBgvGlaxav80V9Ct+MxSuJLgQATdwOGRWWz0N3CENnerPPgNyISmbOLVsvtrDIsz7l6SiHASkaXnIgMMkOihzJAupVvzdVX1iJ8EXYDoK3oc6OTZCKI6YHKbNJeVCmLet/FDXIKxrnWzX4m8YRb0MtaktO0viRNXNPqAzZa7VW39MWeYdmzdrD1pCxr3wPKT/SCNvGUIZ4/DWO6JVOWIf5Ws6YYPq4YN8Z6DcuEKgxLBsrMo+HyQW7vSNU8A2fDYNKXN665EoyroF5l3H36hHnfQ5NqgMbi2QiL04i9Vx74lYApLMaFhgMhmwLaUDCBrXI5RcgjRqqcZUmSbJoK0/Tx9mKtLUOwLUitX4tkoAlbeMXCntzMLk+LzQEcnG5DZcpVnDMSfHm5yWt7dFppT7lFcWAo9bUNlF
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

Switch to kvmalloc_array() so the allocation falls back to vmalloc when
the contiguous physical allocation is too large.  The table is only
accessed by index, so virtual contiguity is sufficient.

Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
---
 mm/hugetlb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c9..f1b982595151 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4177,7 +4177,8 @@ static int __init hugetlb_init(void)
 	num_fault_mutexes = 1;
 #endif
 	hugetlb_fault_mutex_table =
-		kmalloc_objs(struct mutex, num_fault_mutexes);
+		kvmalloc_array(num_fault_mutexes,
+			       sizeof(*hugetlb_fault_mutex_table), GFP_KERNEL);
 	BUG_ON(!hugetlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
-- 
2.25.1


