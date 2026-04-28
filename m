Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EA6FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD716B0096; Tue, 28 Apr 2026 11:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD53B6B0098; Tue, 28 Apr 2026 11:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBAA6B0099; Tue, 28 Apr 2026 11:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3A86B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:53:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DF9F160378
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:53:43 +0000 (UTC)
X-FDA: 84708409926.20.E8FF74D
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F306C0011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:53:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FHWBosiJ;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRnnMzgr6c+7+Zgh/jXAbYOfZG0nWIYRW9JUzke/+x4=;
	b=8UQuLWf45HEFfPj+Og4MCujQM5Uk46PrSIDCs51r1x/9+SJSDG/8wsC4QosDcIzbO/+Iuu
	GC+0DsXdjIG0hb7RZK2UGLrNQoUYJiOU9eIii2GePCyntZ+T5+9jr5vZQMgWllJIuvJhmj
	6/0fFQGg1XU/1Fzkr+Tcdjx4JipWXng=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FHWBosiJ;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391620; a=rsa-sha256;
	cv=pass;
	b=EkeHbPtbo84gADN4JTZ50NMPY740Lp1OVr+mDKwEBJ5t5bt2S2ap2wIEVWbFpDpuPZvaOM
	+ekdHtN+4VovH/Xixj1pEalt/IFP9Oh5LgobljyOZ5XXduUCrX69gnZu3idu1QcgH/zx5O
	s2IKLyuf/55T/FgFLEqRc7MYRrJDA9A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/CipOQbAiKjAjrC42R3MM3lJqUAjabVka6hXTxbtOymTLYT1D2nhcGbAbAQ3ffwaTUq5dnySc5kVdDaGjvfTu+QjbBs3OaunMrWTHkuQ2ZY/7+JJEa3ueylPAbgcNLeVSG1hmzEDw14qybBeDREJTmEa4sHjSewZUEoXNzANgCBlIdQGzeNwW/h4t7vX3SpSwvjvjdVXDBZFKecwYZKs34KuV/N0frgSeb0FW+p2fwaeJE813YdIfiWz50FK/7Le31mtdW3dmr+wnDiBVuWLyZJQpDql5oE8FisCKivGevWgOr0fOdemRjmvA31vsN0mzKFWfCGK1NjX0ueSdzDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tRnnMzgr6c+7+Zgh/jXAbYOfZG0nWIYRW9JUzke/+x4=;
 b=RpoBjcitGSH1EMIBl/vxtoWo7akhIpJz8JoBYq1KLClLbohOCVWx0nlCjfKEkiRi/FZyfLnWQWrvjcMjY3+XwdtytYCvrMc603VQRw3zdSomYvGPjBC610DoSRGhL7vLNqVtBxLxBLrZitzTJGMpqPMEqkhUoveaISSRYQuFiMbP5eLu1mD0U5CFYySGvQ2RNtOSq8tDUsd0m0aVWV11uZrfhDRpxIyalWP6f2nF5rv4WHgsnu/wiAnpCpTdAZ+pF6oohZDlwXj2zMpbXBBsPRCc8JG6kVan/GV/g0uOQgZxVsxpY1E9MWfOooDaImHHRPj7a0dkmvaBRU37Mb2+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRnnMzgr6c+7+Zgh/jXAbYOfZG0nWIYRW9JUzke/+x4=;
 b=FHWBosiJLzdD7lyRy1C1aG8u52+2F/KxTdzCXbAxvUXRcdJAWCLcsC7RV11Q+Q1fu6xsTjCY6phQ3YfClfsZ9ZmCQtk74trAmnMc0e6MP129P+GWaRuESQ2hR6N0kj19d7Nswh2XYmWOVNCm+gFqY7n1AwnRihjlc8EJXxOvFbI=
Received: from MN2PR01CA0029.prod.exchangelabs.com (2603:10b6:208:10c::42) by
 DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.18; Tue, 28 Apr 2026 15:53:34 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:10c:cafe::f6) by MN2PR01CA0029.outlook.office365.com
 (2603:10b6:208:10c::42) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 15:53:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:53:33 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:53:23 -0500
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
Subject: [PATCH 4/7] mm/migrate: add batch-copy path in migrate_pages_batch
Date: Tue, 28 Apr 2026 15:50:45 +0000
Message-ID: <20260428155043.39251-10-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 13d2c0be-c7eb-4ec3-cb28-08dea53e4d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|22082099003|18002099003|18096099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	guZFqto26DkCopFTcRxpiX8nKE8tsxqJIqAF8YdhA/jQ8oJl7LHMb+grZmT495BuX7KsueqGl2pUhp1lgmWAVzlviG2Bz9KCNSAte8C15jaOxC3U6SJYlib1HgQhT+IbJGPIja0pydRo1/L1y+kU9iQb7Yd9iIczf318xr/d8JnRkzRk3thXz4xbSN3oVAMTXYiTRnhgCoWX7f0G4EbmBLcg+XMjOAqcRKEPSBnFm3M5MYUE9EGIvtuSeJnA5G/osGCDJb/U97MHpKqsxZ9WZqr6tcDBNkAY0DCaAWj6Bm7okM98k8kh7MS/i3yW6H09fjIVuhf+UUzRe/IzN4IqRg1YVN7uGwi3WJ64K7/9aXzeBa3oTcyWcpaMqjZ/MYk5LoAD+B5qO5qFdR6WQcWrJSHrtYsnv/uI5e1sF9usxbVTImDpgxX0a6PW+gxsF3btl/H+OGAsCK/32EzYWmreeGStVBVoMb9BAAPUyNzOQUZo5QWrWzOC7nz2ppeeVFCZ85H6+TgGc5tDuGtefp8CP5DYuI5STyUnoYOdMC5iB9hX9/rawndG6I6tTJ/5UiyseginIUOD+oLhP5He97DhGVz3hzrWp+PMxgH4IaEmOrUarU/w31sa7XF8esto7pvY0jD5JZOoCDaT41WIH4BRm1YN9+k/SNDT+YtxHcB/epRrn4Zlg1j5poC3khioUuJaNwoaRspvb/quw9vYM3ZOblv6Yudmzq61XfVCNdHL9ZMLsOLLZoPnbov8hdUPyohrjW0Gd4GsX6TefDyxrDvYZQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(18096099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YN/O/J4/5agNb9fdu8/2uSC8mfB9MojehMKblSn/+203uKPWmF1nyUzp8miu3mVhTmh8v9Rq5RStsPyGCL1MjeSR2O9pKF/C3FQxxvGWgm+UO+B01eG92pxMzNLfljiNW8kzM88mBbSbpi5hLO2eeyAOY2xHLt5HK6tnIPfpNA1I7EGwMxsR9KNsWLtwatThG2RN9plhqk5cDSYXR+s9GwgXjsHb0IQd3M+1xJyEqBDYnCNfCaBfNgg15CSnSDSzn6tCyiplrGqSP46YMReuXiYAqO/zvYIBHAAWVB49gx1FLuG7v2MrfAyiCCSYY5HZnbT5gwulR6RTF3NzdQ6AaQr68aEthC48jRGHYWL9LqSY5cKLFwDYtQEQNunP3bO4IwzxavStlwKcNXYuv9b0yFeKHjuoMDC1GdGuZgyKR4kb5UqISwCdgNyLnJZDKgmS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:53:33.9458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d2c0be-c7eb-4ec3-cb28-08dea53e4d7e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F306C0011
X-Rspam-User: 
X-Stat-Signature: xnf4ypswquy5cyi4zs9g1i3yx7g6reot
X-HE-Tag: 1777391619-223318
X-HE-Meta: U2FsdGVkX1+9Dnd6jLN4X7YEESXiRU2ENpFdPCEgQ3+oBQ9Oe70zKXHYHgkZ2cyJGW8uebhOHFPWqsLBlkUpUhVCib8pmHoTz5iWlmXbeW2Yhz9TzH4w2sK8+F46tv7WNmQjtgZ2bBV2ZJk9YmMkRpV+DZO6ujro+MvSdUOsCq8NmWc/3fuJoEOBlW0geVghjWeEeoIivwhD4a/b+YLdbV2ImX4qQQ7zynRJcS9NfHvoi8ToQ89MlVk/N8h+H9Xs13LLyBxCMzoN6h7AXS11KHDc53TLE/33rOhb1CvvVuWsWwWnGS2VYTlK4kxAxWGGpWJ2qZLWw2+Z3KDM9IwBMAGVjNgW2qFmEYJHOS/bMgm7KBKfZJyqTNx03TvX800wNPd7ZuO4Vov3n+rZ+daKUArN8TKVqYbDHqQGAZc3MuxAwyaWXMPVEMuXX+PTALHXo5WypGK0dDy+Lp3XOfCdB9H3xZQ0wGTsHu/E1AL1PbFI3PHUSMXj2liMQsNIOIYy5TyHOH2sZ/j1wqTJnRSeJoyPCtwogf1BnpuH7ZcBviHQ4+N2ZddMUtEcQi5UpaN8d6Tgr9EAO9znd1l74Z1YQnmpzYH+wxzH4Q6tLfCLT8i85dligIAZ/nMceDBFvSnR5h0GOjVcFAPR1lPqoFtSrwCoMlmlfEBpFP1X6+5QC/tcR/5i38IX0kApl/cYrrFO69UxzGUAygJiQMnmrEX02Ce5eGQiAsfaS6VEQHKUsCzjd5zDjrApnrV9n+UZJqrE/4ZhM3zZHEtlER12szaWw/FfcplxRDjq3AmG7Fmh4GK1at1Qx+Mlgai94McPgxs3XPw+eP5mNQ7rDHHNgvuPJ0pL7QKkVNO69Wc4vEXogpUwFKmI31FA1c4AkDo4s8PJATvpx0bqGT6fAb9e6iJt/G9Io3mIexlYFg6d38FzyX6qYlry37kdMldwPqy1jlvZFjqDmQa6vGWvu53b4Fl
 gbIuHHQR
 bZ1qoeIDGFmCID0Te/2uaD6PjNhs5n6pVbNsA5DfZ50+6FSCIx2TcT6a0OeN/36hFzHvvvoRCthpmlZQVDJrH1XjwPEWMmMj4AyOVr3wSMoDgXfY2egee6OE6Bzd25LotyW9iwJx/UpoLhxz6XPg3KjAtub3L4UmlfC9L05LGQjwYUPh8Q24SnKZzuvv8Vwl0kyfZTj7ISNHOmjlc6MoYUi1OPEW9qJn1Jnaeh0AU+U8HkalWFWRTLvW/cz/mhOFlDqoV/7++f5km1DgGUEj6YaOhDtvvXzhheoQPvQDFlpJH3XsOegh2RKznyDFPny029YdoeWJ6ox7/rxkxX3kV/qe6mjLPFCA7EdZAQorrPsaWBpcyM0heyb7KLP0odTCGZ3jp0vmTUMKFtCYwNgEh507G2b0EukGV46zhJc2x/A3kwx6/V4MpKogIZmbxQwfUCqBNCeKWuyTtANCVCIyclHfsWgUxQ140qjSSazeBZlknkfrTDbPJ5Jbj887Z4AHUkHhSSsta00/WY/Vn9NeYMjCz4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folios_mc_copy() which walks list of src and dst folios in lockstep,
and copies folio content via folio_mc_copy(). folios_cnt parameter is
unused here, but is part of the offload_copy callback signature used by
later patches in the series.

Split unmapped folios into batch-eligible (unmap_batch/dst_batch) and
standard (unmap_single/dst_single) lists, gated by the
migrate_offload_enabled which is off by default. So, when no offload
driver is active, the branch is never taken and everything goes
through the standard path.

After TLB flush, batch copy the eligible folios via folios_mc_copy()
and pass already_copied=true into migrate_folios_move() so
__migrate_folio() skips the per-folio copy.

On batch copy failure, already_copied flag stays false and each folio
fall back to individual copy.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/mm.h |  2 ++
 mm/migrate.c       | 61 +++++++++++++++++++++++++++++++++++-----------
 mm/util.c          | 30 +++++++++++++++++++++++
 3 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..e6ab9bc3de8f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1917,6 +1917,8 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		unsigned int __always_unused folios_cnt);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index c493e67e359d..6c2f1cb66f96 100644
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
 
@@ -1724,6 +1727,12 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
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
@@ -1752,7 +1761,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 		/*
 		 * The rules are:
 		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the unmap_folios list
+		 *	-EAGAIN: stay on the src_folios list
 		 *	Other errno: put on ret_folios list
 		 */
 		switch (rc) {
@@ -1823,8 +1832,12 @@ static int migrate_pages_batch(struct list_head *from,
 	bool is_large = false;
 	struct folio *folio, *folio2, *dst = NULL;
 	int rc, rc_saved = 0, nr_pages;
-	LIST_HEAD(unmap_folios);
-	LIST_HEAD(dst_folios);
+	unsigned int nr_batch = 0;
+	bool batch_copied = false;
+	LIST_HEAD(unmap_batch);
+	LIST_HEAD(dst_batch);
+	LIST_HEAD(unmap_single);
+	LIST_HEAD(dst_single);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
@@ -1919,8 +1932,8 @@ static int migrate_pages_batch(struct list_head *from,
 					private, folio, &dst, mode, ret_folios);
 			/*
 			 * The rules are:
-			 *	0: folio will be put on unmap_folios list,
-			 *	   dst folio put on dst_folios list
+			 *	0: folio put on unmap_batch or unmap_single,
+			 *	   dst folio put on dst_batch or dst_single
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1961,7 +1974,7 @@ static int migrate_pages_batch(struct list_head *from,
 				/* nr_failed isn't updated for not used */
 				stats->nr_thp_failed += thp_retry;
 				rc_saved = rc;
-				if (list_empty(&unmap_folios))
+				if (list_empty(&unmap_batch) && list_empty(&unmap_single))
 					goto out;
 				else
 					goto move;
@@ -1971,8 +1984,15 @@ static int migrate_pages_batch(struct list_head *from,
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				list_move_tail(&folio->lru, &unmap_folios);
-				list_add_tail(&dst->lru, &dst_folios);
+				if (static_branch_unlikely(&migrate_offload_enabled) &&
+				    folio_supports_batch_copy(folio)) {
+					list_move_tail(&folio->lru, &unmap_batch);
+					list_add_tail(&dst->lru, &dst_batch);
+					nr_batch++;
+				} else {
+					list_move_tail(&folio->lru, &unmap_single);
+					list_add_tail(&dst->lru, &dst_single);
+				}
 				break;
 			default:
 				/*
@@ -1995,17 +2015,28 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 
+	/* Batch-copy eligible folios before the move phase */
+	if (!list_empty(&unmap_batch)) {
+		rc = folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
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
+		if (!list_empty(&unmap_batch))
+			migrate_folios_move(&unmap_batch, &dst_batch, put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages, batch_copied);
+		if (!list_empty(&unmap_single))
+			migrate_folios_move(&unmap_single, &dst_single,	put_new_folio,
+					private, mode, reason, ret_folios, stats,
+					&retry, &thp_retry, &nr_failed,
+					&nr_retry_pages, false);
 	}
 	nr_failed += retry;
 	stats->nr_thp_failed += thp_retry;
@@ -2014,7 +2045,9 @@ static int migrate_pages_batch(struct list_head *from,
 	rc = rc_saved ? : nr_failed;
 out:
 	/* Cleanup remaining folios */
-	migrate_folios_undo(&unmap_folios, &dst_folios,
+	migrate_folios_undo(&unmap_batch, &dst_batch,
+			put_new_folio, private, ret_folios);
+	migrate_folios_undo(&unmap_single, &dst_single,
 			put_new_folio, private, ret_folios);
 
 	return rc;
diff --git a/mm/util.c b/mm/util.c
index 232c3930a662..77eeb285def1 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -778,6 +778,36 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+/**
+ * folios_mc_copy - Copy the contents of list of folios.
+ * @dst_list: destination folio list.
+ * @src_list: source folio list.
+ * @folios_cnt: unused here, present for callback signature compatibility.
+ *
+ * Walks list of src and dst folios in lockstep and copies folio
+ * content via folio_mc_copy(). The caller must ensure both lists have
+ * the same number of entries. This may sleep.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int folios_mc_copy(struct list_head *dst_list, struct list_head *src_list,
+		unsigned int __always_unused folios_cnt)
+{
+	struct folio *src, *dst;
+	int ret;
+
+	dst = list_first_entry(dst_list, struct folio, lru);
+	list_for_each_entry(src, src_list, lru) {
+		ret = folio_mc_copy(dst, src);
+		if (ret)
+			return ret;
+		dst = list_next_entry(dst, lru);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(folios_mc_copy);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-- 
2.43.0


