Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4FA10BA451
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4EE06B0092; Fri, 27 Mar 2026 05:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C269F6B00A1; Fri, 27 Mar 2026 05:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63B86B00A2; Fri, 27 Mar 2026 05:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A836B6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:00:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48927160F9D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:00:31 +0000 (UTC)
X-FDA: 84591247062.08.157ED69
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id D167CC000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:00:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Dlwa3+gBi+ejDZwGMaYoZyXndw5cA8xzyAwUoRSy4y4=;
	b=0rzflOhbLBqjLXa4KCwsuSQMGc6293gF9+ESMr8K23e6Ov8DG/m4nzrYNT4pANGlyUDUYi
	1ECe7yW7/H4r+vhpsPG/sY8lm6I2GfTiGIbQAQrKiq40UudZeLzBWG92wjZEhTE5IGW87m
	Sp6a18DwyxXE70bMhW22sPHnwqC3Ccc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602029; a=rsa-sha256;
	cv=none;
	b=xQ/y4hfNXMhDTQ9TA8c2WA22BDAYja9N+9rTqaWPJa/ohMskLuw8pSvwoWZoe8B0bYoLDD
	Qmehdfpl/XOzN9q7Xs2DgpDZhiv86/mi1MNrmGER6ieDV3pYaRczC94GWUkYy5iYi6s4RE
	lBVvPI4nACp/e7ewluj7ipJt22zM9TY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
X-UUID: 60b1341e29bb11f1a21c59e7364eecb8-20260327
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:9dd417ec-2cf5-435d-ad91-c8f5439c006a,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:89c9d04,CLOUDID:5e8302e75c77d1f93fcf8fc6eac4642b,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 60b1341e29bb11f1a21c59e7364eecb8-20260327
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1799876405; Fri, 27 Mar 2026 17:00:18 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH v1] mm/percpu-internal.h: optimise pcpu_chunk struct to save  memory
Date: Fri, 27 Mar 2026 17:00:13 +0800
Message-Id: <20260327090013.38042-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D167CC000E
X-Stat-Signature: gjdjy54xmf9qt954q35gd9bi39dtijfd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774602025-519516
X-HE-Meta: U2FsdGVkX19uLgAJStkmYzO6Th6wvNOR/HNrjblV0/nDwphd2vd8TyKploioskV0KBQHrDc3pmcms7GC6XzoTx2dkfFkNs46v5DVsLVtrlbEyYJctt83VhBcABH3HqzpvOEFdTzAj06XfCsAxzPf6/+hbGVmO1Jd3bSkJv8yVbHlpayNB+yQObDJfipQT1GXGEj+iK4JCQcI1bXc0pgFj5yxrqwrmdS41vHXvHOvR16R7VXkBNutWkk7EZUvEwotlNCtBz83IF9c2U/cHhxz32hIt0oE9TkVeQN+UFRZ423vBh0ZDGZI+sSrZBoRBDMSKNmwg+GYoUqPgG2QgbuLF6jRIZum6k931udIpVwgCK7lHz3O3EK92f/CWlE0AwX7sRe6n5/P5TWTHnvtm7nh36eNV8BV0hy7uznyk/xYC+OBzHspMF/sIv7+Jcm68jFQk2o1Ckj5JWyV10SnJEgeHXKV1qGIa849cMLBDdU0tt+k0h8mTb/BjEeT+jtMONCtCD/wWB6QTQyFKwnmkpQLYULXsvYZaAWhr/7morQpGZjekCpPsvVSiUivu+IZKS9CMeXXM/SYO3gEvpxHTCKYaExiIRU1sbcskOpfy8M0mpbv2BqScHdFXpypnkdZhIs8n6CB4x+o1rrLV6vT0gyK+uzyAMwrxfufTW3Fn1tWb1oIVeFjbf8x13MVCHXsDWvfEEJTsNx50EYVIph0jOBL4cTtfATdC5hI/cKRaq7L5spBW7j73Vv8s3+bZZFgiY6fx8nybqfo4kqGwmLPoIGEeI9jdxM2tURJ1doYDL3JnLyj7GuzHInYD2yf+x/YbYJDlj7A9ia5zYtMrD2u+Z+Kvk9zWazycabvyzpts1k2SiI3AUqZcECbgAyepLdeBvM4gf4mkRW999q1ok9RYDp4ADVZHrKcENnOR10GGdHj8bbKaIoMPIEKa7hsI5LUsAi5uQlimtSTG5adedufGQV
 X9YB8uS5
 E9VlB5Zj++ufO2yZ+zjiQIP7DO0V9b76K2FIuCqtDTCyl9MQ=
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

Signed-off-by: zenghongling <zenghongling@kylinos.cn>

---
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


