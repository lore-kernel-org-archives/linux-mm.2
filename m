Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD5EFF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2B56B0088; Mon, 27 Apr 2026 01:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63516B008A; Mon, 27 Apr 2026 01:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78986B008C; Mon, 27 Apr 2026 01:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B7F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:58:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27415A0775
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:58:08 +0000 (UTC)
X-FDA: 84703280256.18.351DC1A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E9B8A0003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:58:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777269486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=11IgLQDRPt/7hIUjoDRIuU46fp63jSkRfWMUAwno+8A=;
	b=lH7nE97PVZ+fU5wMp0nnJ6H4nMUC7nR2/GXB5E1r+AIW4/7xSiXj2V5Cnd4GHE5hXXjzKK
	rPoC7eRlOzCkj8VAcipRkzv4K2xqgLcZ4CzYKeWtSuzRxlF+iHLjPcqnezp7G4gpLJsp23
	2zGRd9vbIdq+zQUyS2tm3J3iGMHHXo0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777269486; a=rsa-sha256;
	cv=none;
	b=6lD1pc4nvZGLv4OqHPysYNcVgznX9rHcxv764y/tR5DdoBzkgt8Przjd96Tq+R4sqvmOzn
	ZAD8Y+x3LHUkaZN7GSAH8VR3QzHhXg/XlH4OmP4OMTHJl9RTrSaWTrCdKIuRH9YEk3546e
	o59J8jAB2+wwEoZqwKVutTpqmUgMfrw=
X-UUID: 0b74039041fe11f1aa26b74ffac11d73-20260427
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:819ba16d-b8cd-4015-b281-96f6075d7a86,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:be69ca2d8678bbedb9066af9f8a41e4f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0b74039041fe11f1aa26b74ffac11d73-20260427
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 891455403; Mon, 27 Apr 2026 13:57:59 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH v2] mm/percpu-internal.h: optimise pcpu_chunk struct to save  memory
Date: Mon, 27 Apr 2026 13:57:45 +0800
Message-Id: <20260427055745.6938-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E9B8A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: cs3h6kyw6dhjun79kkf8rzqm4zunx4wm
X-HE-Tag: 1777269484-386502
X-HE-Meta: U2FsdGVkX1/gNOOgCg7myZSE2FWQ80/9Yvtjy1pVwY4WsQAhXRJeeN5E8+m1xo7+TnpmFMTWlDvRT4s06IgoVy/uH3PLZ1TAoa/N58OSvThUe9aFmdtijHIYf2r09e9O071hw7t079zNSK4nQpfAbpKQn5Jr0kvSMQ7KTAPWx4JgM2Ojgadyljw5xKFV8oy1hehnnPbERhgrzqiiYLMXY6X9mQzStlERWjhC46QgF4zofn1H82iBdiSQ70WmbbmVz7TWV0KTFuRVOd7J/dE781DM0Pl12fIeXbTZTCeDNZATP35weCYK6JUgNtUH09I3sqz+TMyA1IJWsZZ6meCfxqSZGADKkIA+8Aiv5RRlzsp3pBGPZo4QSTDt5cIIopawaGzenqvSlciEZjGIV/R1Als8mJQ2J0mrzFwIGmvbBJHbxzmRdF2cxXgi2mupH5/EQg2rp8raflGuf28NOKdFwFrmAUO9kdR3lep8wqAHpIOHtRn90gskJ4QdZUnrPUxHA5upWeef8FcyDr5Vk1/SDLNcS2iH9TUvcEj7eSn00kIg5i5HN2sKDFJuvUauyDgrThnktjxyVbo7YeYQYdGJhvQ/ydfhUXsgjrDZoykEeybDqDqW+gVRWEVr6TJ4/AaIKeSFqT+BzV6bfvE5FBKo2AZaYZ/nU330cnCXQtlLcKfvENA6dOkyxOaA6IgsfOO2dUU0m6TLXDBZAkZDgMfN+htlUITVIlz0Ke+kZJv2Bxefk52whl8SHr81AOMo3u/6SAjJsgr6jtjA33yjnX/ZPFEiXCW+23E1GsUz1rInCZkjbzAAmYMxfBIvu6JNqX65DOO5OpapFH7xCZfvDJ5GBGFvlv9Hk2tcIjzNsmI/CtPvDqqoiT26Q8UZX9wYQ0Cl3sWAmYEKNYjABAf74nhvpMw03BIfaZlNykN95SwJ2wVC+ZT5GhBzyrBxCbz5jY+b1t+vT7d+nx3x3nJIX2k
 Ico/sDxH
 uvazxqeAiMZ+8gftoJKYFaB0EzNq6f69/0qHf1HRWzrSqHOOeoX+PR0xMkCVq9uj8m+Cj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zenghongling <zenghongling@kylinos.cn>

Using pahole, we can see that there are some padding holes
in the current pcpu_chunk structure,Adjusting the layout of pcpu_chunk
can reduce these holes,decreasing its size from 192 bytes to 128 bytes
and eliminating a wasted cache line.

With allmodconfig (CONFIG_PERCPU_STATS + NEED_PCPUOBJ_EXT)
Before:
 /* size: 256, cachelines: 4, members: 19 */

After:
 /* size: 192, cachelines: 3, members: 19 */

with NEED_PCPUOBJ_EXT
Before:
struct pcpu_chunk {
        struct list_head           list;                 /*     0    16 */
        int                        free_bytes;           /*    16     4 */
        struct pcpu_block_md       chunk_md;             /*    20    32 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int *        bound_map;            /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        void *                     base_addr __attribute__((__aligned__(64))); /*    64     8 */
        long unsigned int *        alloc_map;            /*    72     8 */
        struct pcpu_block_md *     md_blocks;            /*    80     8 */
        void *                     data;                 /*    88     8 */
        bool                       immutable;            /*    96     1 */
        bool                       isolated;             /*    97     1 */

        /* XXX 2 bytes hole, try to pack */

        int                        start_offset;         /*   100     4 */
        int                        end_offset;           /*   104     4 */

        /* XXX 4 bytes hole, try to pack */

        struct obj_cgroup * *      obj_cgroups;          /*   112     8 */
        int                        nr_pages;             /*   120     4 */
        int                        nr_populated;         /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        int                        nr_empty_pop_pages;   /*   128     4 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          populated[];          /*   136     0 */

        /* size: 192, cachelines: 3, members: 17 */
        /* sum members: 122, holes: 4, sum holes: 14 */
        /* padding: 56 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));

After:
struct pcpu_chunk {
	struct list_head           list;                 /*     0    16 */
	int                        free_bytes;           /*    16     4 */
	struct pcpu_block_md       chunk_md;             /*    20    32 */

	/* XXX 4 bytes hole, try to pack */

	long unsigned int *        bound_map;            /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	void *                     base_addr __attribute__((__aligned__(64))); /*    64     8 */
	long unsigned int *        alloc_map;            /*    72     8 */
	struct pcpu_block_md *     md_blocks;            /*    80     8 */
	void *                     data;                 /*    88     8 */
	bool                       immutable;            /*    96     1 */
	bool                       isolated;             /*    97     1 */

	/* XXX 2 bytes hole, try to pack */

	int                        start_offset;         /*   100     4 */
	int                        end_offset;           /*   104     4 */
	int                        nr_pages;             /*   108     4 */
	int                        nr_populated;         /*   112     4 */
	int                        nr_empty_pop_pages;   /*   116     4 */
	struct obj_cgroup * *      obj_cgroups;          /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	long unsigned int          populated[];          /*   128     0 */

	/* size: 128, cachelines: 2, members: 17 */
	/* sum members: 122, holes: 2, sum holes: 6 */
	/* forced alignments: 1 */
} __attribute__((__aligned__(64)));

Suggested-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: zenghongling <zenghongling@kylinos.cn>

---
Changes in v2:
  - Add pahole output for allmodconfig (CONFIG_PERCPU_STATS + NEED_PCPUOBJ_EXT)
  - Fix subject to use "pcpu_chuck struct"
  - Reorder nr_pages before nr_empty_pop_pages
  - Add suggest by

Changes in  v1:
  - Fix the error commit message.
  - Move nr_pages over nr_empty_pop_pages.
---
---
 mm/percpu-internal.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 4b3d6ec43703..8cbe039bf847 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -77,13 +77,13 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+	int			nr_pages;	/* # of pages served by this chunk */
+	int			nr_populated;	/* # of populated pages */
+	int                     nr_empty_pop_pages; /* # of empty populated pages */
 #ifdef NEED_PCPUOBJ_EXT
 	struct pcpuobj_ext	*obj_exts;	/* vector of object cgroups */
 #endif
 
-	int			nr_pages;	/* # of pages served by this chunk */
-	int			nr_populated;	/* # of populated pages */
-	int                     nr_empty_pop_pages; /* # of empty populated pages */
 	unsigned long		populated[];	/* populated bitmap */
 };
 
-- 
2.25.1


