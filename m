Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA70FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F356B0092; Tue, 28 Apr 2026 11:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667996B0093; Tue, 28 Apr 2026 11:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E066B0095; Tue, 28 Apr 2026 11:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45D516B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:52:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9ED45160369
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:52:51 +0000 (UTC)
X-FDA: 84708407742.10.571629E
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 963A040018
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:52:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IVMDBok5;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPEBg8P1WzTi/oSWfHVMqGKa/e05YHT1uXS9J9s75CY=;
	b=m++RFoLnA7V0aC5jwSZdQB6AYw/lDsGFfG/r/i72yhf3WkWQs4RyYCp7KAzrS7DyU1IWxm
	nTy5bRddNak6Wi2Eey0xIT50dY89p9iMX22atEa2vvEtLVCzfuzKEXzcHuuPp8RLzw3kDQ
	wGzLmCqIagog2pS5PwB5xk/GRSNZGj4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391568; a=rsa-sha256;
	cv=pass;
	b=cL1l1IKHlb7tu0/FERUWeiZrMHbWQMahp2u8VzbBQVySvv1bbhswvwB4paOks01HuD0W0i
	2G4UduwMVLc8mGoq2aYV4JZQtJ5uim2ptWVQa6ftnR8gArYeJIeYkJka9uBZZJiZIFJAs1
	YjXwnb1ILx2u/3kZzEeVbFZj6iVmJLU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IVMDBok5;
	spf=pass (imf07.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.53 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNPamv+jQDkYBwdPBnYqvJ57p/8/bBj3/jMyohc47z390zoKVKHae58OesGV36seFj+97cQT5RyYIcOtVsv6ZYsXgXhaqtuU2xA9R3e11HkU2w2sxI5Zg6iL8RiGwYTwnse4YBAyKU6qYlU9/ZUNYCiJilGRKGQ0KTIYdZOWj7So2KFasgzn94HoR3t4bMoS+wH2XyEqqvWVPPiPsPdZC9OCWCNYdpVwHX+HYJvAg5+8G9+iipAUKgjbQpU527E7ptxo0rhfZHhbHuBxLcXiyS7Cavw9XZu5Rcxj6VnX6IWhOn1g11aHWX/behE67t6CX8/XESFrO6iGDK/4EN8R6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPEBg8P1WzTi/oSWfHVMqGKa/e05YHT1uXS9J9s75CY=;
 b=khf3WUiix1aE2Zp5ue7TICtmobqwuiLg2jqOvnb+hHEP/ZY8F8WIE0prpKkUO8cjX2/niFdjbS+Fr71eGORALejhwjAZouDknAGsb1Jt4+eIHymApVlJQblvf+gz5/Ce9sF2FF+mpJP4HCYpIOJ0yrlS06+E5rq8Zram08LPf6+g5OmxcPrkcjjTLn62xRZhotAYEBKRKeJ9b6Ef3L8Rr+Ikd1FCR8QvWaWP0yo+HUtwWIfm7d+gZjUuzTga3jiX7eBd3TQJLIPLwIhwEFab4TM3Jgb/NYwZQzXQQzRFO99PXr7i3M5ARkYflxoDn1B22F1sxOloyjfwNB3E4JzqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPEBg8P1WzTi/oSWfHVMqGKa/e05YHT1uXS9J9s75CY=;
 b=IVMDBok50ynmLJZ43lNVjsDC7FH00gLhULZwb9PZUQChYQ7J41vAUBfoMYtZxlozcQGOXZWrY8lgma+w4T/Zwc2630/3bHu0TWfDiqv9joSjR5Om3zD1hgfBYnCAy5lXP7wKlfVEp13fxQDkCbchAmDqieCHDxP/eiYzTOfw3pw=
Received: from BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::16)
 by BL4PR12MB9483.namprd12.prod.outlook.com (2603:10b6:208:590::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Tue, 28 Apr
 2026 15:52:36 +0000
Received: from SJ1PEPF000026C7.namprd04.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::62) by BY1P220CA0021.outlook.office365.com
 (2603:10b6:a03:5c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.28 via Frontend Transport; Tue,
 28 Apr 2026 15:52:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C7.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:52:35 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:52:24 -0500
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
Subject: [PATCH 2/7] mm/migrate: use migrate_info field instead of private
Date: Tue, 28 Apr 2026 15:50:41 +0000
Message-ID: <20260428155043.39251-6-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C7:EE_|BL4PR12MB9483:EE_
X-MS-Office365-Filtering-Correlation-Id: e86c1940-6492-4b3b-74a6-08dea53e2aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700016|82310400026|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Kk/oovJeNUg3Y+ALijfkmoRu99Mo154uNHUdTLCB3e6WBVsUD18VsjQoYuO+vmHP1g6EUQy8rp0BC5gScCBnYeqg0Hrip+fE9LlTkWZ7nLJK2kXvNRRaxBbNvfXpWXPAm6dR0NVTGDVdgkaD4GyBeukA/kDmkIgaACO7MQ0bOg/ElbhgBTSh+wRYMnhy1R4pSF53mjXV9osBVH4RhC79oGNbs2eSQP35mHdEoIvG5L8zFeSYlyn+h9P10QW3VHkh1v266S8Bfy45ELPqj93U275xXr88cXOn0jvl8MOKAuWndHie5mn/UUInWjaHm67f73myArFo+RUat7SRh2x7yFHmDtiHnfyNCRzoHEuDwkiX+uOvOMztq5v4V3aoIZdHPaKRKoWfgwF3gnP2K/hgFcZw8KqgtKJjWHIFMS5QM+RGTsG6muIdMKve9T3lJhiYN8Ts/J6Dz6KL6W/WaXBNoltUH96bVitWSjvgI3/mg7xRdBJDxtH5g7skJGlyYb999rOiF25qvC8tjJ+9PiVTRUnE9A2waazz07IQuyvjvQdPycsLUbM3ik0gcJ6f7U3pSCY4FvF7KnES8ncXOqiHGd35O515TPBizcV9s+imeGuRoIesN3e1ARfNi4HNmVHke0py0WCTHtLw0RCWQV8UoNx1YvBkiTPiabgyd7X5Ik0JMlBPwP6MXi8uQe+Nq4pHUI7qNM5m0gx5+L/hNsa+XyOnliEYOpXXvEE4c6CnK6cIwTuhw1L6SWRp9bOaXiVpM4/Hj7vUcGc5sj9v34Rgpw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700016)(82310400026)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TurHvNUM5LwQw8rVwsUM5wE/Grlto9UpDBogP/c21/stf/zYte62N3806+b6WAxjezALYtnc4lCo/54+aX7K1mVKpJuqMg3SW62u6AFzU/ZAyJxKggI+Ke0mkdXE+lYQ1liFZy0C2zYvhJirFA5kXXy8i61Nza1WGGTULa8/gdAgAonb4yXJryDqpueKJeEqzmzpSAcpFSKQ3xECxf/OLWP6qEDfRvc9f/VtJWnZPB+UOclwGYMqdpguMFLuwRfOjAiBath4yphGw9KCnQ/ezbSAVmkb3raa4ZpJJFUljzwZRpO32xM1dLURPMrXtHJF5FuDq1ceLgh6xRnwZLYBAi4/EzHNZ68VyI4FHPNZG/ILapdPslULFYzct+huOBYt1w+Y7Xmg8eZBYknfMlIWE7fLymrHFqffsXoesEm10XvgP5BYVeCByTyx4ON+KZPv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:52:35.8475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e86c1940-6492-4b3b-74a6-08dea53e2aec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9483
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 963A040018
X-Rspam-User: 
X-Stat-Signature: hshmskwkyg5cwhxmwkitobukos3p8rbx
X-HE-Tag: 1777391568-851852
X-HE-Meta: U2FsdGVkX1+yFp82ZqRxb46i8YvOR++Tkff9qTKkRIbJvsyf1+F2WuNMCHCzAdkC798JmgqPLnj8X8+20uh3FpRlh2yU3DmISnB9sN2zbxB5UKkwMnI+uT21hp+qNtGG59YUDDn3llizgGzmU933TgCeKrswGJKoeOTEVfIpoK7dkFxg8GDxcHslXYBFEO82sSEP/jQRFJg+ebNVo/LRbDLDtR+KL4Is+kt0Ii2FjnVGp81RK5ETuDuFUhPVzx11YjMaRwVNE9TOEOAQGuSq687lQ564bkhe0UHZksfXzdSy9ThLuhg2PYfeg2MGiAkc4XfDKIw+cppbgUUVlfoDj+0bz3E4zXOXVeY6s3PfdNcWMEAro7AbhTB7oPOByt9hdMEAMUe3xhcBXZMotq7fIhDs2NZw7cztkNs1h/tlHOHZsXqcuv5/APZCXU90dxgmPIOifOJzvhMYxXkq9WtnwHDH3WbMkm6KRv0R/kve+IiSP8QTXp3SlIxesWyE64dyKDg7RGjdPqgxUetIab716ztAa24GMDeMWJdtP8WUvruRjzqr4F3QXRcAk5Uu3dmde+bpJW5tIT964iFhKLClze/ztzMgQzA1LqdwSMx4QZRkFa7WcB9JLre2iB46P2Aes6zKJt4cLuVNYyDvMqlxI+ZGjBa8sFanKk1696q4u0S8VhdXZ8iiPPNYTvvI2doAvc7Ia6AKs24Ex3+XuSIoPnjiCiPlJdVVn5fMs2N4BhiWCeMoTIWB8XxzN70VnVWuWxNKu7w6fk32rGYYDFmrn/knbxI5jzLPs5WVdWp3Cr9fU7HTGYyzFwY2ZMD6MwaL2TTSES8MDPSndhYiFzGUKvGhuMgl7yJHRin5lWnCbwWpqIiykO9auY3xWL9IIdkoksWQnKrPN7IvJWpti398zKd+59MDbuV/4jCfKGCyg4YH/vZgsQukuYtBQkpASahkmKVzCijx9TcMDqPjMbn
 EfPkidFO
 0CkbPsU7+vL2Tr5CYTiKqOfgZ1EjCR152/IHK3KypKJ6P95Q0NPZv6mgFznzQqQ3Mp7BX5wuW3W4q0LQCTvVu8RKofJQFVddAF8RnRilFHHW7PpjfdNaE2bFzSntKOitd2J9FNoU1ZLgv3g/Cx5WKAZnTU7uE9hOOSwoyhHFkhsmeKSHwbTk3IcjLy0Cu7EOUb+SnzJ1tPvc2x7vSZlMjBcE4JMRZQ3RG9QCwBJGfBZ8elf3csqy4Kpy1ugDlqNsjJVMh/zx3iBQVlgf6kjt5VHel2/RuyNFiCuzsiovKN8K/t2D5FgSh8vJ5W/m6viG5eIoQggjg2MUsPxdwk6o3Kdbb6DMrvr293+kgxmS6P4APFMa80a4mb3oJIcc7L7FXm0uJFczwAkKVSPA6BJPQSavP2iT3VsmCTq3CCu4/hSoFzkR66ACMvUanxDVHpsCEgWb0CQ1s84cydJAdcZQlzIB/NWq4/n16J7kVSSUf1eFnXZVjFvlKvxeTYs4VZXHR/eWNHI/WQtmLt6E7GshsqVoU7lYQVB6u7k4y4vfLkrGvhoQTgKLqP2Lvjzm3rCNWZRpI8F8C9Mh7HHTLgLCYj5+ak5OKR5ahE9GwJPuc5JzQMiUqBd4mjZsK0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an unsigned long migrate_info member to the struct folio union and
use it to store migration state (anon_vma pointer and FOLIO_WAS_*
flags) instead of using folio->private.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm_types.h |  1 +
 mm/migrate.c             | 14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..f52818dcf4d2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -426,6 +426,7 @@ struct folio {
 			union {
 				void *private;
 				swp_entry_t swap;
+				unsigned long migrate_info;
 			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
diff --git a/mm/migrate.c b/mm/migrate.c
index 0c6a0ab6ecce..03c2a6f7e5e4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1130,7 +1130,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 }
 
 /*
- * To record some information during migration, we use unused private
+ * To record some information during migration, we use the migrate_info
  * field of struct folio of the newly allocated destination folio.
  * This is safe because nobody is using it except us.
  */
@@ -1143,17 +1143,17 @@ enum {
 static void __migrate_folio_record(struct folio *dst,
 		int old_folio_state, struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_folio_state;
+	dst->migrate_info = (unsigned long)anon_vma | old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
 		int *old_folio_state, struct anon_vma **anon_vmap)
 {
-	unsigned long private = (unsigned long)dst->private;
+	unsigned long info = dst->migrate_info;
 
-	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
-	*old_folio_state = private & FOLIO_OLD_STATES;
-	dst->private = NULL;
+	*anon_vmap = (struct anon_vma *)(info & ~FOLIO_OLD_STATES);
+	*old_folio_state = info & FOLIO_OLD_STATES;
+	dst->migrate_info = 0;
 }
 
 /* Restore the source folio to the original state upon failure */
@@ -1217,7 +1217,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		return -ENOMEM;
 	*dstp = dst;
 
-	dst->private = NULL;
+	dst->migrate_info = 0;
 
 	if (!folio_trylock(src)) {
 		if (mode == MIGRATE_ASYNC)
-- 
2.43.0


