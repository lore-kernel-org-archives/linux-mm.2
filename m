Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EDEEEF313
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0316B0089; Thu,  5 Mar 2026 02:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87E96B008A; Thu,  5 Mar 2026 02:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4AC6B008C; Thu,  5 Mar 2026 02:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CCB326B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:30:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DDAA1A080A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:30:59 +0000 (UTC)
X-FDA: 84511187838.10.CDCCE9D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id BC970C0006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:30:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772695857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=qOWsCuHFCcn3b3neSBl9Kufkh3tqOq/hBEXTcCFQxsQ=;
	b=RicotJfH4qC94j+gAysqZvfu48fq49FSVnCsKw9gtjSLeHycfsaVgvmszUX6jQe0afgZn/
	0xSSaacraUBhzZBiTvKct93dzyDVIFuHGZefh96BFtCToJjxdkaGPIVCnY8CRddP9L6vz8
	NFlnN3d0dr+yhsYLmdimve00LtdTFMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772695857; a=rsa-sha256;
	cv=none;
	b=l8tOdbj3tMBQ08g1RS1faAA9kGi7eSed/QIeWlOcIG5WGQ4RJi5YaDpGpFLThWN2o7DCAR
	HdpQvKs2YsMNHqPQdMEqRzn8W7ohrT8gNMdOtcHBi6a8ed0Rc5TLFwG2K3pPlSkojmVGAX
	fSsedKGb/eJxTFPeM4CQLp7F+mSERe8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
X-UUID: 3ad8bc1a186511f1a21c59e7364eecb8-20260305
X-CID-CACHE: Type:Local,Time:202603051526+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:e0ff7001-2385-4aae-9ccb-3c63d89b13c0,IP:0,U
	RL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:80015e11db1ce3bae87d07a51a425f03,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|898,TC:nil,Content:0|15|50,EDM:5
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3ad8bc1a186511f1a21c59e7364eecb8-20260305
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1300980276; Thu, 05 Mar 2026 15:30:48 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
Date: Thu,  5 Mar 2026 15:30:43 +0800
Message-Id: <20260305073043.571691-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC970C0006
X-Stat-Signature: dd9x96bkuewkqyj9c1tmxg47rxd136pj
X-HE-Tag: 1772695856-80022
X-HE-Meta: U2FsdGVkX193Zqy01UnXcClYm6aouI9NFzZKORm3Wqwi2COMEEc/MapYyKTtb1Y4Huha35iX8OQlV+P8t7RSRjN3gbAb2yQAZBq7ZDC8srKTT+hZKaD+Ey1N6jue05Of6bxKi/nkpxuGGalQVKOpMCCI6hHScsI0+rfhuEZgQjCC184mfteV8ub2nD+++ZPS0vR/hT8+bSll3SICwUiCQNSoejWgdk7n5PbfHXajsb9x9cP3qlGaqwSVqTMrwvRSujwX7ShLIcPMZj+DQrH5VJ8Eo5cPkCwOaTmYiMS5IcRedI67i/cWnp1+JuZIk0/ELSylzOUYIFU9apGdHSoAVcRBhf+OLYtbYRsa75iCMiabXXGYHZEysiG7K7+sR0uuPRlZzXKDCkHc0TxO2P6qmsduDFCCMefr6Ra8O19Dk8izwGj+plOAyu9rfBJRn6tdhl1t7l3xGL+3MeHkaUVxxohWt1MpJ4p8FphyLBZjmWJM1iVohiWuMteqr8ehoO0nUjH7a8fznLdvw1pH39DaQbKQTaYxAV1wDbDDYrCC8G6OTyZMl8odl6mObsiysYjrj0/BLLkIOk9rmrWm0amlumSZ1NrEC+QlrEpdOplKj+/WXdcqmJN8PBPYJ84QIMRMFmZJL8R8BW5OehwMh6VW7Rca+gTuzUYFg5AfKdMigAkEe9zmCjIYG2hc9kZKs80pzkOc+4ZfGj07uVHk63Y0NrOpS5A0GUIC+Jhca67FcFV/EhfcoBJAOPPe7lCwxwHUPIR9PDoxKwX3cZK7qmQFTOg3phK1zPZ3wJ3p2GJ7sdw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pcpu_chunk_struct has a hole of 4 bytes and pushes the struct to three
cachelines.  Relocating the three booleans upwards allows for the struct
to only use two cachelines.

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
        int                        nr_empty_pop_pages;   /*   108     4 */
        struct obj_cgroup * *      obj_cgroups;          /*   112     8 */
        int                        nr_pages;             /*   120     4 */
        int                        nr_populated;         /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        long unsigned int          populated[];          /*   128     0 */

        /* size: 128, cachelines: 2, members: 17 */
        /* sum members: 122, holes: 2, sum holes: 6 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));

Signed-off-by: zenghongling <zenghongling@kylinos.cn>
---
 mm/percpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 4b3d6ec43703..26f3ac39f8c3 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -77,13 +77,13 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+	int                     nr_empty_pop_pages; /* # of empty populated pages */
 #ifdef NEED_PCPUOBJ_EXT
 	struct pcpuobj_ext	*obj_exts;	/* vector of object cgroups */
 #endif
 
 	int			nr_pages;	/* # of pages served by this chunk */
 	int			nr_populated;	/* # of populated pages */
-	int                     nr_empty_pop_pages; /* # of empty populated pages */
 	unsigned long		populated[];	/* populated bitmap */
 };
 
-- 
2.25.1


