Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6513CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0115E6B0088; Mon, 11 May 2026 03:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04456B008A; Mon, 11 May 2026 03:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A556B008C; Mon, 11 May 2026 03:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04866B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:03:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7417012060A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:03:28 +0000 (UTC)
X-FDA: 84754248096.11.296946F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C1542000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:03:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778483006; a=rsa-sha256;
	cv=none;
	b=eXee+14W/gkGqsrZ/nsn9Ib1rzfVOYKLtLNudKKzQ0kfxo/FA/dEt/fzdLKAXXgor2Q+5u
	blSSYzSrLQVgOtVgKvSAMajPCXtNcKeCatSNZGxEOnT82rZClamn324StCN9bHGOG3zxLD
	jQdDrCgzJAkO1jp5okMZK4yxOoi5wJw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778483006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=11IgLQDRPt/7hIUjoDRIuU46fp63jSkRfWMUAwno+8A=;
	b=WyOWhg/KGyChbIYq/9GyvVWbO1CkgAIKy3cuDhsCq8aGX3+NVbbRpqIaXW7Q4FGnapOCmh
	Zgcw1M1vqtycDrstwxG3SJJXqhpxnJqdvvSlxgjIHGjW90BTcS/nRcbQMZiljU6He4kLM/
	3CzaAsNLDhI2xGzQIatO8yDs+U08cw8=
X-UUID: 7bee9f544d0711f1aa26b74ffac11d73-20260511
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0e8638a4-a6eb-4dde-aa47-570e9ea5bfd3,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:c4c0cf2d43dba92e791a1ecc0126712e,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7bee9f544d0711f1aa26b74ffac11d73-20260511
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1858563739; Mon, 11 May 2026 15:03:16 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH RESEND v2] mm/percpu-internal.h: optimise pcpu_chunk struct to save  memory
Date: Mon, 11 May 2026 15:03:09 +0800
Message-Id: <20260511070309.44044-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5pa8xhdr75fywnz63xexc8afhqy9k7yk
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C1542000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778483005-708608
X-HE-Meta: U2FsdGVkX1+9Gn9sVvESbIsuZB747y8ohrBwNhlpe0mqGI4kH4bRBHnlX3PZa7YOtBdOi1KuR80SXruTEr2mpDd92BvbL/T5H/B+0RpJIAoIJRFnW/TDPOvDkTlwY9e7oFLv5ouAmfQoyeYoQhGv22Pn2fcmdYja6z1q/5ojmx+z1RlrbJhrmbEGZHFn1e7dnQss4Y7ygWLA31xhvc00fi5zIHNedCRO1nG8pJlU5QgDgYQhMfv/dYyn12My1fBsbDAtBps0qdshFsOEehZu9lQqw+tChsDWOKoQY1q/5lFL5IRj7KQQwGXTJ2t9gK1AgYZlx/0of1L+Vsv3xZTxwFthO4WClwPtTP4Dfv+S+P09riutX/ojEJn5Ta4PRzhf5Ptb8e62RDQoHtoX4a9BGyqMqBCYgUbbTTiY4wz+4LjtavKXXYt4HTfNTEU9rvBwS/9u5gBHn1TjBpK1SAkrZBVKoiY0VaFLNFEwrajOEk0cARhQwVkti+Wbo/7QpYN/zwqEuBo8Enk34knUY9+5HkTQFsvEuv7xbm75M5O+VZ9FTDc/NQ43ml4Oc0Fnq1d6yvhfNZSN7N4rmTO/nAuathjMCjyD1Ld/P3EkfPdIaJGyZVm5xsdaKpHjSoEFyAJRHRmsNkwEit/FCCHNlBWAzROrb7Ikdn5VZWWw9d5DcYD1OxCB26Gcg5DE7fAwmSlx3l/n0e0kclBDYooQw0A1V+nvqqUQSDRigI/Fj7f/ALGTfVgikAUBms2tmY1oIRfrQuD77laAm4ueg2cXX26XZEKlbV4dj3WekcQPPytvoMz+XVz8iSnUSkejX+UWmZF+VLShTTXnVa3dhGjSpiHwLSCld/javSAk2BOsJW8JiUzPAiBstQXxhzcN5Yk0XDW7z6VnjLZvpqzdV4oFYBJpV5cmdneMGpX8QXdcUuwIalubTEZg+slQf8HelX+S5eD9h/+7ThPCtOVdQ8nuAAp
 Tu6pnvgL
 lBVvzA5a1VZb9j13wpudUVo8vZF4YfgVSl41utXgRrjAdlD4OrMc4r5GrrHKVF7QhlxSv
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


