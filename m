Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06471F3C241
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 12:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBBE6B009F; Mon,  9 Mar 2026 08:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD306B00A1; Mon,  9 Mar 2026 08:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584ED6B00A2; Mon,  9 Mar 2026 08:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 496976B009F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:10:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7D101B6DD7
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:10:56 +0000 (UTC)
X-FDA: 84526408512.11.1900285
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id CACC640008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:10:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w51oS2IC;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773058253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ckxzWdnuNZQ4fZmUPlhcSIRDDo0vDlZKadKfM6hydE=;
	b=CZh0RcbZ92Ie8Zte/Vax8zZ8pxrNI/sZpGmZ9JfgfrpCv/6PsNxAByDQrXwGXOR/VObfEg
	LZAj6d2zTSRGqs1JC6hCjChD+FoPnugRXNlZglVXyC4+xcYLnhaNwrcmOZFzN0NPorpxx8
	kLer9FP91e/NIJhezgEMXyg+rs69R7c=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w51oS2IC;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773058253; a=rsa-sha256;
	cv=pass;
	b=1uOSxAsYosuhEOElaJ4TD8j8QhVjxMNHeWuCcd6oJxPCbzQLz073lAGyI417L17k5NQRNr
	LhapGkhwFMmO1b17gzDimC4XkztXXB2f9nFQJ/XvKtTc9OcARo9IX8WeRmQzVoM6V6fpf9
	RXjkOm2375BfitzNKFeDkdYfR3AdWoo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gspqNw3/YWNojasuAG6dNB5Z5fiuObhjWCBmDB7HT3rU5muLHB15J0cZRc6FppNUvE/ga9J+6/jTOkYLZ1xQY4NoSX2kyD/yoSKrOJUcDWeKI/nw8cghdTL0j7G7ijPVTqxrH/PYZbEz9U36/gJ4cgCiE/4LxbfsbTE4+2RV7iLFWZy3eCG34cLquRK7U0bU3XU/jTj6lG0PUA62qs2dRsrHbNEL0w/5Hw9X3oCfuaZBtkZ1CHqvaFzp/O6OQJnIlF473l9HXfeZQmgC0G/RMO8giEWlni+DX8+0ukwcTLxCGKQPPOj8dhSS+VuXCaduWs8yM3lr7dts0ksEJiUvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ckxzWdnuNZQ4fZmUPlhcSIRDDo0vDlZKadKfM6hydE=;
 b=sbjZzMBkKjOSv2qj/0zxf0Bg+jp8w2jFyZUaAGCsbyl+UxqMhl/wkEAUzPPt0xy3Wit+oLQKWKKD2Utp0cKZQx4rhPUzDHRx6KJM4BWJbDQHhXA1AhhJ89+GDVOfxQeR86AKPasxrJTbVx1OcZc9+TXWpkXqAOt7ZrEwJEDIVw+7z7Oh658yGdADMwziurHwhxOhdcEDkncTmkd192j5qN9elLSC+dwDaclPPomJqvgtRRS9TwFQpPbyxqWQ/suYhCj2iou3syAt82locbgST5aGgBPaEkpM9PRaz9AKFCbULepHZXYYARPsFZf8HRePHSCEscWWC/s/9qv+QP2rag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ckxzWdnuNZQ4fZmUPlhcSIRDDo0vDlZKadKfM6hydE=;
 b=w51oS2ICua6DFgjf9y6TxBJMhMrSc4CxKcQ/9aoOoOZpMPzBFY+335Vw9gXCQ/sFBx4ANPwzCmDSZ85/vyGoA/oqi8N0QSC2qDtK4SoJtWn0qxdHheSDCsQvOIjWVcyIOsIVshSr/VlzIC+rHTvI31Xz+f2ZQiGOCmHbBTjtvZQ=
Received: from SN7PR04CA0162.namprd04.prod.outlook.com (2603:10b6:806:125::17)
 by SJ2PR12MB8109.namprd12.prod.outlook.com (2603:10b6:a03:4f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 12:10:45 +0000
Received: from SA2PEPF00001508.namprd04.prod.outlook.com
 (2603:10b6:806:125:cafe::56) by SN7PR04CA0162.outlook.office365.com
 (2603:10b6:806:125::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.24 via Frontend Transport; Mon,
 9 Mar 2026 12:10:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00001508.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Mon, 9 Mar 2026 12:10:44 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:10:44 -0500
Received: from kaveri.amd.com (10.180.168.240) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 9 Mar
 2026 07:10:33 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <dan.j.williams@intel.com>, <rientjes@google.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <dave.hansen@intel.com>,
	<hannes@cmpxchg.org>, <jhubbard@nvidia.com>, <peterx@redhat.com>,
	<riel@surriel.com>, <shakeel.butt@linux.dev>, <stalexan@redhat.com>,
	<tj@kernel.org>, <nifan.cxl@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>
Subject: [RFC PATCH v4 3/6] mm/migrate: add batch-copy path in migrate_pages_batch
Date: Mon, 9 Mar 2026 12:07:27 +0000
Message-ID: <20260309120725.308854-10-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309120725.308854-3-shivankg@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb10.amd.com
 (10.181.42.219)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001508:EE_|SJ2PR12MB8109:EE_
X-MS-Office365-Filtering-Correlation-Id: 49ce63cc-c22e-4d32-0bd9-08de7dd4e44c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|1800799024;
X-Microsoft-Antispam-Message-Info:
	bkn16Fksyow1DK9CkLTVmegDvHDprXzI6QASjAFTBAXklFZdDR0W6Ao/p9DjTs9msHLXOdzSojIDlUl0OpzO4UArBflFF6bA3Wy059eOj9apeuzPyjG7yVi+s6ZdYp85s9wWwZFE2Oj48ZK/aq+4EVkjhoGk/Qjj7U3jnMk793TYEL2CtQfu6Jr4OeZFgzswcszlABnVjlyew3RbQ2vsG5VdwiF+BKfsboOAT1hGUZ+10FCtB/f0U3UO0bzopDyNozFuIGnmI74M0RADzWd5/OJ6N4HzsuSGSWEr/Yu36RQ+Vi9T0STeaQ7m0b+15ziEhfn58yXZIUwQMA6FcnqlU5lQGnTgZzHqNnx+n0SF5HjKebAw7knfEvPZ22dxtCSArJQciLgnQt67Pdq8QB+3CZRLqWVQt070z/GioSG49aPafpKnQ1snXJ6WQsoBz4xsR55T6/K6Ywp2IK35bnFlLj2LZzC9cdM/D0jKcI0H7JxzIUJTirsnipaWTcYij5d4rZNRuVrbHtYXKZpxsFDgbHVGR7rNy1WmT1gm1XR5hfUuSimg8RYuZ/0F+D6eUz4oCTG6LmhPpQUgfFJk7hGJLpeQavcf2woZsk7Bg/VWyewk8oz/tbOMXLj+TnKm1Gid6qRgO7wl5C+GXShTIg8N+3xJP5aAmk5TGeCQoFzdSzz4o+nRkTqEa1wfQN9G0wVG6LXSLvqIJux0xBUrttuuy18nqC91NDHhmeXRNG7jdN1AJw1l6u2TkgbdbVENu+nIGd5ilLUGfP5nb1BIA4tAeA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V5ALtRDgL2OtsDRXVxuoQphbPqd5+Hts0TJRZemfzql3YH4MJ49r1Oo7lsotRVNcFTGBHuqWQ2SuaO25mT+GR5SjRPB5W3kzbxVWoFq34GUoKgofxNECTlbfVp7d5qSlwXj2h5n7kg50pUCz5DCqIbGEby3KWDoT9QuW7xYB+GzzmMEZwoH2VYy6BjH35Q0GCdIDDug3lnORncTimwe0wbANRo0vszLjSVeTktJJWg29rbrpsQKS0ghBoOgV+P7XlWGkfG7KMxNq6yXpwYrH4vPN7LcF0CVtHtGPwe54w2ya5YqIE7kGnDkAo5ZTdHXsfOkbCQ8u464m0u4L9x6xISTXqaHKrTldxQWc2E9QKy/8XovPvyfn7mc+t3BukOz9dmXkA1ucdbyUXZmZH/N719LXaWAZg+eMYG7WBFI5yw+MNvyxanMFKx1vS1/7Tf2Y
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 12:10:44.9259
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ce63cc-c22e-4d32-0bd9-08de7dd4e44c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001508.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8109
X-Rspam-User: 
X-Rspamd-Queue-Id: CACC640008
X-Rspamd-Server: rspam08
X-Stat-Signature: pprfuw5x8qmeapabw77wys7aeq1edej9
X-HE-Tag: 1773058253-245178
X-HE-Meta: U2FsdGVkX19G6/VPDtB32A802c9VN/nbDSeQrk2Q7HeaIV9AVtcGcrkPXcR0zMijSvlfJac5d0He8nOMta6h8IHZRibaAvpL6yD5tBynXBVtJKznIbQbNjw2hsrqafOEXDmkK/HaOALqBZPBA/R/JH97A2R+UbcueFJmY9VGdj9p0GnraXw6Ft44TW4va4t0TmVxucx2IYmlZMoh0C2jP5MNaCeQWk9X6XfRpF5NUdnnEP9vHXjFHBRThbuzwOivLwA2ifXuuR0cZ32ZZWxrlI/kiHVUC8H4AOT358iTLV9Cn+7ADgFd26EwbYM4xQJhWr0ZklreBsvYhkaccMyD0WrGDqn23NOal8i4ydfJ/vhWVDJnhfgv3/2wp1Mb1lJ7SHnP4bXxcWVwx1ukYm17bt17vgDInztXw7kQazY5id9muIEduX5iQIiWW1rPS0V8xhOMrafHobpYkrXsQ2ll8wa9gYxBL5v3JIMdplNwuk2PL88/2Stdq3wuzqkuwAusBig4g6PaH3ng75nCt/VwgF6DUVdhxC/iaWiGimFMGoevHKjqi8Yw+9cbZjz/xcXC/4ANB442tmjLmHBTOI4FRY40swKOIFTtUGU8FICr44wpEF0crDtD6qOLNzLnk5NJNe2HwIXoTovnrGavOt/dlUo7Su+0iEwMawLtaDuynt9rSrVK/okxx1oLhvpHLhS7x/cq/meBcr0glirFAIVPD13ASyvFeGD1zLN9ay3yGxOUmjvX0kdAVi5c1H91HVajvORfoOv78Az8H+qQ20GzovSt31EEsqbB3xymBRVaXjGcD2Y+Q1eVUc6Mam6EGyYJ0Fofw+L8RkNO4BYqGxiykKBl5dHl9zZOx60g8XY/pbV0FCJOGrSRi2SChy1vDeXbpnfJlteswlbS514pmMSs78P3NuWksXBWvRitedimLx7I4N3tQZdhiIzMbeCEztLD51patSOA+/8atXRLDv8
 WEnTNyK/
 kcCqqW66R1d2PXSVh7AVFA7WFhdZc05TfRvUiuHcLzfCxnZcPixaHEHFLRAfQNQNZO3qVZtvXGDzUNGtZKyjzxqbDlxyfOARF/tedsD/rSWocPg0YfQljJqhqKU4dbMLHQdIpRI3sjB7fxQ4aUxlVALc1lsnJwYjsKUiy9aMCNheoGhezO5tmmMy+ROctm/IGrqBegfB14mh54madDWAmh8O1iXfXpyWkmgOawgIZlsujN0n5iceQrY9J1ZIhCt3peMNIIzqxln9wqDBRYUFZ5BuTcjm68THnxIpU03D6QOmKRQ8UojjLJDBV8QM0Lof6itRhM2Qg8P5S8+QGvITXtpA7s2Jb6Zf97gfP2gvLFA07NYXImihQUmqFSBTXOG14hs5TGOrV7rtKgdYJAMwuF8+2FV4glZ7X/HcOHjmm2hBsWpELpSrYaAyYL6GPADw9VPODcQyJH4XZWEO9ftnp5z7Tneg0ZOtWAzUEXxeXfiDnlXCzjf09cccgAhV3fqeoxFrkv6bMsmWE1UW+j5Fw3VVBlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split unmapped folios into batch-eligible (src_batch/dst_batch) and
standard (src_std/dst_std) lists, gated by the migrate_offload_enabled
which is off by default. So, when no offload driver is active, the
branch is never taken and everything goes through the standard path.

After TLB flush, batch copy the eligible folios via folios_mc_copy()
and pass already_copied=true into migrate_folios_move() so
__migrate_folio() skips the per-folio copy.

On batch copy failure, already_copied flag stays false and each folio
fall back to individual copy.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 55 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1d8c1fb627c9..69daa16f9cf3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -43,6 +43,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
+#include <linux/jump_label.h>
 
 #include <asm/tlbflush.h>
 
@@ -51,6 +52,8 @@
 #include "internal.h"
 #include "swap.h"
 
+DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
+
 static const struct movable_operations *offline_movable_ops;
 static const struct movable_operations *zsmalloc_movable_ops;
 
@@ -1706,6 +1709,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 	return nr_failed;
 }
 
+/* movable_ops folios have their own migrate path */
+static bool folio_supports_batch_copy(struct folio *folio)
+{
+	return likely(!page_has_movable_ops(&folio->page));
+}
+
 static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *dst_folios,
 		free_folio_t put_new_folio, unsigned long private,
@@ -1805,8 +1814,12 @@ static int migrate_pages_batch(struct list_head *from,
 	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
 	int rc, rc_saved = 0, nr_pages;
-	LIST_HEAD(unmap_folios);
-	LIST_HEAD(dst_folios);
+	unsigned int nr_batch = 0;
+	bool batch_copied = false;
+	LIST_HEAD(src_batch);
+	LIST_HEAD(dst_batch);
+	LIST_HEAD(src_std);
+	LIST_HEAD(dst_std);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
@@ -1943,7 +1956,7 @@ static int migrate_pages_batch(struct list_head *from,
 				/* nr_failed isn't updated for not used */
 				stats->nr_thp_failed += thp_retry;
 				rc_saved = rc;
-				if (list_empty(&unmap_folios))
+				if (list_empty(&src_batch) && list_empty(&src_std))
 					goto out;
 				else
 					goto move;
@@ -1953,8 +1966,15 @@ static int migrate_pages_batch(struct list_head *from,
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				if (static_branch_unlikely(&migrate_offload_enabled) &&
+				    folio_supports_batch_copy(folio)) {
+					list_move_tail(&folio->lru, &src_batch);
+					list_add_tail(&dst->lru, &dst_batch);
+					nr_batch++;
+				} else {
+					list_move_tail(&folio->lru, &src_std);
+					list_add_tail(&dst->lru, &dst_std);
+				}
 				break;
 			default:
 				/*
@@ -1977,17 +1997,28 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 
+	/* Batch-copy eligible folios before the move phase */
+	if (!list_empty(&src_batch)) {
+		rc = folios_mc_copy(&dst_batch, &src_batch, nr_batch);
+		batch_copied = (rc == 0);
+	}
+
 	retry = 1;
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
 		nr_retry_pages = 0;
 
-		/* Move the unmapped folios */
-		migrate_folios_move(&unmap_folios, &dst_folios,
-				put_new_folio, private, mode, reason,
-				ret_folios, stats, &retry, &thp_retry,
-				&nr_failed, &nr_retry_pages, false);
+		if (!list_empty(&src_batch))
+			migrate_folios_move(&src_batch, &dst_batch, put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages, batch_copied);
+		if (!list_empty(&src_std))
+			migrate_folios_move(&src_std, &dst_std,	put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages, false);
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
@@ -1996,7 +2027,9 @@ static int migrate_pages_batch(struct list_head *from,
 	rc = rc_saved ? : nr_failed;
 out:
 	/* Cleanup remaining folios */
-	migrate_folios_undo(&unmap_folios, &dst_folios,
+	migrate_folios_undo(&src_batch, &dst_batch,
+			put_new_folio, private, ret_folios);
+	migrate_folios_undo(&src_std, &dst_std,
 			put_new_folio, private, ret_folios);
 
 	return rc;
-- 
2.43.0


