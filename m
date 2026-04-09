Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60FF10FC466
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95DAE6B0005; Wed,  8 Apr 2026 22:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DEF6B0088; Wed,  8 Apr 2026 22:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823CB6B008A; Wed,  8 Apr 2026 22:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6C36B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:30:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3457887CAF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:30:25 +0000 (UTC)
X-FDA: 84637438410.04.FC12175
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9261F80011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:30:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775701823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=DNbM1dW0sygxZ4tdqvsd97F30tCJgImZUniQv0vRTK4=;
	b=LF3JRy/ZcY7AuYyXALuw0cHgsqM1r/d9HC32YwbJWqUSuekBG4nmbJpt+kN14cV25qnfuo
	xyo9b96Pid4NXkWeMP1+p5nMZGDyZZ6HYYtlzzhXI4pPOwuRrqVszApf2sFOrenbQeHXiN
	PJghE+JJhuQuJM91/pm14I36f9s2AqE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775701823; a=rsa-sha256;
	cv=none;
	b=TXWVeW/G0J79ppj4f3JD8XsJ0a6+AAagAm4YhJWBooK2JxlNQ5o1fAixT+Z/BiyGX+drKd
	8XIAVqSKIv2HdcIj+FQh+5o4v5XYxTkluUBluMCY7eB+K20/4BcVDSVkg6pQ9ZcTj29jnS
	v4QvNT/4RQUXkBmSwy9rFnoFMbR88rk=
X-UUID: 0a9157c033bc11f1aa26b74ffac11d73-20260409
X-CID-CACHE: Type:Local,Time:202604091025+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:29359778-258f-4ef3-bbfc-06fb5b1b6bb3,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:45fa8da2f672d49430258e355d67af85,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0a9157c033bc11f1aa26b74ffac11d73-20260409
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 894210101; Thu, 09 Apr 2026 10:30:14 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH v2] mm/percpu-internal.h: optimise pcpu_chunk struct to save  memory
Date: Thu,  9 Apr 2026 10:30:10 +0800
Message-Id: <20260409023010.10493-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9261F80011
X-Stat-Signature: tnre4gocwzrxey73cq4459ribrx4pcec
X-Rspam-User: 
X-HE-Tag: 1775701822-948146
X-HE-Meta: U2FsdGVkX1/ilY+UtjXOzQ98i9DBssvPqfuQiOgfLQm6dWSlf/KcUMCCtc3+DoMkXweoqPhoSiuYW2uJYBHfb2897Xs4/nDk85FOlxBQhBdEKCrUmG64DJcRcQoFqiBw/IY5ZuZaX8UHNGeBPgB+2M98jiKROCVaUR/EDIqlYqLUFZA2yG9GcrjV6rj06rguiIUFukSiMFpZ8ivRYWHmLqiF/kYHWKTfGg4We+MXXdOOrtg/GoxuQ1Za1M3wqxdLlqDbSjYl6/l+4V1uELYjMszSQeUnKMA1pzRTvZbSPBIidKFeZHeLb76CTfE1cqET/RkC7+luILOG569d6/6R1XqBJoYzIDKRFj75GUwje/WQjMBDDbYI+FiLKNtwRNPD5GV7OT8fC3JVmyd1nFP1hGFMj53ggUehw6kT7xQ0RQiucS0RSSDQJIY4NI4/NaKFOZDygFXMoPdVQXwGqRArlF3FxQWq1WRdfYWbUsB1nuqKY3dXfRmqS6qAgoUyRg6ZS5Q6aaTBnAXqwfDtsMi58SswSA79u3+mEhhUkhK9nOX/hU6r6hTreI6GIBtvKBEtxEwuoA/b5wvfaMJ/SDmYGOctSxcYNY11UpMjJ+si3dVTShnzVUydGFkWQxfaSO9Y39in32oIv5Xoev4Sa303h2xllbuRn/BHK28vJU9fRXccuyyV0CdaZCwpg3cpLT+TOQMvcRKbdvILZ4AQcpfd47ZDZQOaXdxHapISyyGJ6WDAVT+PURmDm5qwSydo2xnu11uMnrXyIM4+hi9nU4hmdZi34a41V3Yho84Nclr0wfn0/FWqNayPUTbqK42IqJkgs4zort4BSTANiJ5PdlTKeMGJmux//DIwPCsu1jkQmxLoUKKM7yJHksQhVgUQJ6hczEQaM19eOD/0cAFajIj13HEcbTF/gXUOQ6J7mhV7iLaJiIg/gF+2CJt/KYSZCx0floFD4M3wNhd2e5lgekn
 +UYzgmp9
 cDH+ETFMPl7ZjeAOp5pZgePVmCBpxvKgWTYoENlOCn/86BSQv8ztGUYhWZfGEGS5nbXLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


