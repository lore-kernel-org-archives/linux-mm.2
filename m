Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19226CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E7B6B0092; Mon,  4 May 2026 02:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE826B0093; Mon,  4 May 2026 02:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6970A6B0095; Mon,  4 May 2026 02:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5572A6B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02566A0991
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:25 +0000 (UTC)
X-FDA: 84728712852.07.8AF0D91
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13912A0004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0rmesWSn;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 52.101.52.41 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUI21Zifl1UAAP7nrPJamaThQ27hIf9osVGTGa13JOI=;
	b=1ORBVJCIGNR7Hl+wzcq7RGsB77IAhW4A5UU1ScC5eav0byv18M8JjHs8BxAosNKuf8yrm4
	ed5LeUUvvxuoTrrIbEdRYp4UxoxPAcyw35nyMM0WGPGMRurISxNrKxGNDsAHKDKW/7hIAv
	iMXq7Bdx0E+bhPZJYn3kmu/nSdAfTAE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0rmesWSn;
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 52.101.52.41 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875023; a=rsa-sha256;
	cv=pass;
	b=nWbSWeJIXDF0IQw5/Ih7niaGOd7c9R/FYj8nyIlGU4ADhuay/++ZBtUzsIMq00WeUzDjcg
	Q+hsSW8OH5tKDRFCVtsiYk/PYXfdQHjR5n+2y6eyt1V0Rub9V0m5wYZx4l+fkQMDCw3Bf+
	Pn5xSv6XiTVXRLEsdsxCpuLGM7o1vvI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzXuSidyHeY1ClcQDPqUpalZAAzRmoN4k5OzcOh/JpOJ30G8kKuukFP4VvVSwZLtaVwX23TN780tWO3EmGAanSlgXyqrtXO4ktokljY/0O0gj4qkcvDGM8YzRanxHQx8rmgjp8/hwUiVlfggmM2Iajixyv9AxrzReJctf4J50D3XCm0yppOF28ryEWzAvv9jt09oNWRWec6408TftkVYic26nZXHa0t33319qdLFbEg+SPEcV+4aHUxUWvbMxLJfi2+VjLRw8zUbuWzVlhu95Axw/CrBmwxJXQInufhQPROJ+ByH6D4Rh/JEOF1ImGjnj+FSBh945q9LlyPDVHXp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUI21Zifl1UAAP7nrPJamaThQ27hIf9osVGTGa13JOI=;
 b=SSX3gMOs14CLJ1Nbg7Lga1xSVcdGMxT+BiquMcw54GHVucIwpgV5MKfgf6TuQbUKwr2r/VuEkT8Vt2ZhvuoxKNbDaw7UlLutqgL6L+jAyGkut4ePk8Flnfzsz/1tD4JQbW4ewcFNTeW/jvqn8rOeUQUP3LfaelcT1RntcbED2TV/QPaXDVBUFMCkkn/Sw8N2GFWLMtKC9A50JIxXUKmJ4JRwJGohMK6XHDcJyBHMEAvcYq64NindQ0kSzCqDSkrHw7oiRWSeSl52EiTiYl88j7QqW9kBqoPRrcgiU0zYeVdJ68DZJ/81KPEWpkjVPnpgE+wUWq7mMh/PY18bgH8hbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUI21Zifl1UAAP7nrPJamaThQ27hIf9osVGTGa13JOI=;
 b=0rmesWSnV8TSgT4H2BNy5rar2R66C/53BehiYGeX4bWs0N0h9hUA7XxcmWYFLz5Hq9ilGVr5rCtJlftivd7ZQ5xvyLuK9kDQ5brB2Y1mb+bZslaaV8e4l3cVOdyuTUo/ufkrdtehDLiDFMtEd/hvqeaCk0AaevPyP3Ajlex8GFM=
Received: from CH2PR12CA0008.namprd12.prod.outlook.com (2603:10b6:610:57::18)
 by IA0PPF64A94D5DF.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Mon, 4 May
 2026 06:10:17 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::65) by CH2PR12CA0008.outlook.office365.com
 (2603:10b6:610:57::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:16 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:08 -0500
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
	<shivankg@amd.com>, <donettom@linux.ibm.com>, <bharata@amd.com>
Subject: [PATCH v7 2/7] mm: migrate: Add promote_misplaced_memcg_folios()
Date: Mon, 4 May 2026 11:39:19 +0530
Message-ID: <20260504060924.344313-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|IA0PPF64A94D5DF:EE_
X-MS-Office365-Filtering-Correlation-Id: dcbc2e91-a113-47e9-c88a-08dea9a3d028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bZoubtCICSFcbgsNZ89h12ZODMPlZzVH+2POEPdZzynxMKH+zFrrp/FbCNssEaA5A8bbRBy1H1OFkx+dlwHIw/aMTlKPcjsPKK0ESOZsecsV62hQ/XMQrcBIiQDVKt/A2GtaqzIoAoeSYGL8KvCPC27/LXXCv/hEOj+4uCVUAVcKmqAQUEKKF85osBZ137u3cjcyktmrekxIqzxSFwtEVS1G8JcpT5YlzFkH6eO+/KLj2nshBH0NALFc3yaYmI1sk3W8iyQuawxNzy9oAazZhT+8UZbWpOkVCLToQgbSWlcSyorJsMwUcZ4y5Fn2FRnCcjycunClUr1ATgLbO7G13BS6h2h0E6pVDvoeNVQ60ojoHaAISEOipQjSTcv3d9iUjkcjd1jJokYZp+kWT78GBm2ee7PswA7X3m2ZDTr56zY8WihrVvzVz+/GYXG3rdAKUNhAZelKPl9GI2qtx4We/uD6SRipVzev2ZfQlROK0od2L/xU/l0KmDNtBRe1A8U1p2PFkuQyZMLrY0DwD+N1BJ88Y5W+0wpt/joaj5H5L+fbiDf69ESs5EE7zMbS1klzaZH/XqYIkokKsmWomUIzhroMxBka4xeeFXXUZA2sbkZEYqzNgZc7L7EK2+obDSPcl7XPUxxDfS8CgBvGMNP4prjiMqlJ9LiFiCR2pKiq+OxCmP3/4kZy9MYi29tkAT94xbeoMFOqCA3/zfnGKz484k5F0QSOKDyP+Rj+29Sbzmk=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m3gboqEHfqlI4pWTleXvRSZgoDIBV0wHJoWftDeD4pkFSQh3vHswp885XUy6LDPnUtCe2HLUQIC26meNu0nlgCQGti8snIdzq016RrYe1YCOttrAvaAM7Yg0N23PLnWO5OukJt2lBwCHeCNqZYv740XPTHUe5UGBEoZ1KEEYiZXUmF3hTQZu8JcXdxTil0SaNQ3WCjKQqBVf6IQEL73tvb0wzLn9R6pQCDPAjezhCXVqCZJvrfZAkVJOLoSMExD5Qti/SG+bvHsk3EtHLesySxCpTNaZ80rRCg0LIlGpgy8tIKQOQvrzUA3WIw3q2d9CfukDBh0WK9IhQf9s4W3xFqRYdOLxtN49sz/VpdtbDE3TthSYEnSxkdoX9QGYqe0oxUV69we5i1b5WRVX6jmYRCvbgG64PMXSjkf3Uzt3J+ZliB9HtX6ofHW/7QxRsTzW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:16.9686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dcbc2e91-a113-47e9-c88a-08dea9a3d028
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF64A94D5DF
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13912A0004
X-Rspam-User: 
X-Stat-Signature: xrcr4sucg7yu1ynym5wcg9gh85knohyd
X-HE-Tag: 1777875022-293550
X-HE-Meta: U2FsdGVkX19hO7L96uvPURByCazdiq1LfiBn8ZLrHKBK/rvGtzwjVRV1v9qeHtPCZvymR4julZ9LEqZcxf4rZnCjoJqLyuDEaKbxeGRXLwv92L7lyzOubOBMLrYMhgp1SAImEFAiWe7CXv0x6fnTHnejBnb1QGGSToEyrcPM9GUXkRjBFCs6aeLDs843m8JabovP+egki9h2vd7zUOzE5EQgR6TDbDSoYWkjcPVvzRgPpwJheV3TOnw1xl6vSDOPRJo9sO5o7gMz2hJW2lGdsoeb3F4HJ1ddsr/C2DxYeaNr3xDFjTLC/j7/Kw1Ez+4Fu/hDi9ojUhCwggVCzeCVZ5zsseGVSiphSFXWaODvgu5Rsw2Vmma2YvrmhLVoIHkCoiZzjWJdChyCD55xnrTJtpQgINSTeQiHr/hdxi/27o7r5Qa8iCfeATYmKbcyqRHYjI7w/UqQ5bgJfxU9DHcUEuAAnjLsz13auDYFhjmlhz1niCKrQyDLXFqO3LyMpV/7Gzk00WlbBSJ2GzLJnDxpQ/ARFMVBbyZJEGEKH/NM5yl7GemtVT2q7slSP24JTF2TE1tqR4CXbRNPAtyfyaA2H9tg4s260Y3ZMf2g+Jo4kSEs+qE1sDpsGSwIhn8mDhQ2J/I7Xuup1O4JkErELIThcVuuLv0F7OeUM1Kvq4KE38xm2mQlLOPf7WT9rXwBwBKzVBukENIaUjR2wxFFN0sU0KliRO54FVLTc5eSZlIdKNdfBFVftadS5O7K2n06rWBw46YZdlF8HfOKBsAnieL39wXZGmJ9hTF4Cgeogp8WFpkXt6TArLuGbWUbEpABKYTH6Pl+zza3YC0tS/k5iEtjOkqqO4RyOWyjeyC0NXa8z24Mf+tokiThBsobbTNukCnybeKX0VE7LYXzZfsAYnMVtb3Z6sgpTQrljLPcoJDgldWcfL/VMX22l1jGwmC1ZdVhA9nK39v6jO4bfA9dy3z
 2vDMDZj9
 hqurIK/WgckkzyLo0roZQQEDPDl8VK4SAO6i8CVr+L59qT93Na3oNgakDqtNjvYvdftNDUXCaQc8qljcqOG0QkSSqj5XSeqLjGIEz36VTPIPlyA+7ioT2vMXosm9A/vzYMxJxdW4xZ/gVuae0norbaIiaqttq0ctjda5KK5e/3KUM+xiR89+JlKAWXy8dwkoxMaDcgxtlkulyO1H4btGTcJ06AeNfdTZk/L6fP18h7CGkWV5IaOB6dyyoQxunzhN9Ag9OdCnYQxHGKLq3lTAj8qpjhTqOnS5pjPFAslsg8qjVqEoLJ+cAlPb1gWzVfzln228I3w0VwLO9l9DUvf0N3ZSuUl+vd6dQ+kNSlncmCLs8XQF20nHQ4sp5Nn+/0GosaATyr/AON5pTkGKLyxoBQ1vkhCcducwzuFoQikNJ7pdjevJEEdHbXv4BU7jJSSRt0Py5zatGL2DOeq35H6wCtqtsQtKKVs+mEMKbwxVhgxoSASGaP6FjCE+9n0kSEylcSXFn0Iq4f1P2t0EXB2fh8EHe6vTOjY6vDcJHJzVJ/xLCWnKEK78QYlQJk2hzfTMV4fyCaHqp4ytpQ9+ONaHO0MgoAIVz/XrNP8eytUVGhldpYpsoDYrB224fFZp3ylhPaUfI4CdI4C3gZxrRIimwNOhyfuKWxAFRwM4p
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
 mm/migrate.c            | 57 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

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
index eb21a02fade0..747277aadf19 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2770,4 +2770,61 @@ int migrate_misplaced_folio(struct folio *folio, int node)
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
+		list_for_each_entry(f, folio_list, lru)
+		VM_WARN_ON_ONCE(folio_memcg(f) != folio_memcg(first));
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


