Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA825EEF313
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1756B0088; Thu,  5 Mar 2026 02:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA90C6B0089; Thu,  5 Mar 2026 02:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF0D6B008A; Thu,  5 Mar 2026 02:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB206B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:26:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37B7B140814
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:26:59 +0000 (UTC)
X-FDA: 84511177758.30.65DD8FF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F28A1A0003
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:26:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772695617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=qOWsCuHFCcn3b3neSBl9Kufkh3tqOq/hBEXTcCFQxsQ=;
	b=vGXrgm4lbrLRGM5Q1lJ78J+tdCw/UGIz8B86abRhpwUT7/iAss7nEgtrulQXz7lu/Bw1N5
	8WZztcACFP1Dzjwrtikxj0qYq/NFESOk5US8KgkoYp3Qz1hxJKlGmxZBp5cqPzr4NiBufE
	89ZuKmQWzFWYA+NMwX37BkOMBiBuCU4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zenghongling@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zenghongling@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772695617; a=rsa-sha256;
	cv=none;
	b=ZQpiFn4FSbCraD5Kh4nxhyrOuA8NRE7EsW3CeJmQ1x6G0WUq8lwiuJpahRHeHKbXR3NY31
	9Wdcbhv+Il23s2l4XzczwfZeA7yAhtwRSS/TN7VNMYftipH8DK/QgMKeDZAvzYSKJ36Vug
	tQVr0vWAX+mdHSu2tr/2FmdBjWLf/mI=
X-UUID: a8220f20186411f1a21c59e7364eecb8-20260305
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:3ad0e231-104a-4498-be29-821f3f3b453d,IP:0,U
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
X-UUID: a8220f20186411f1a21c59e7364eecb8-20260305
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 826623739; Thu, 05 Mar 2026 15:26:42 +0800
From: zenghongling <zenghongling@kylinos.cn>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	kernel@vger.kernel.org,
	zhongling0719@126.com,
	zenghongling <zenghongling@kylinos.cn>
Subject: [PATCH] mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
Date: Thu,  5 Mar 2026 15:26:36 +0800
Message-Id: <20260305072636.570130-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dd9x96bkuewkqyj9c1tmxg47rxd136pj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F28A1A0003
X-HE-Tag: 1772695615-138414
X-HE-Meta: U2FsdGVkX1+7+ZG3XuRaaOXENAfuZHIC5t+O8R2z/ADmBtDUQ81l7160U+IZN7zXlmIkwuoPgecJTT95tWuU34ZNgR0JW2yvYCTQkdp4neTuHAXelbM80/+MBU5JuFsvxxv5Tcol7fxolwFvdGD62bfUma54R1uQ3+QnupSj1E8sW76jz1s2pguuSrw49JCR+xY1BduzUikFWcGLLHiDKLPdTE5fyI6JNiXsvmMQE/KLWSW9f9VbHb7tQvHo6nLkqN6d3/S/NWhezxaWHig5MW+ngsyYxI7o9wquSM0JCP8Pz32nlLXJfRg50rUmzwEpJoEFuX8mIcgzKIOfx2GYQd3Ckx4jTnaHWS09L5FCzukz8rJ9sEsQHfJjyqe4h+lcTOPO8K8rLrLMgT3R+RpJY+J0tQIgsUA8fb50vZcrXHOh7qlf2i1UlMt2EV1KB+OwyBudc3Rkf/ucPp/5bsbK6x3M3177bpcZsXIYXBe2/+a7nbiWlWXEJ6MpqzaqagKc+tviqyUYBK1R6M8yjH053z0v1dY5C84WX8ThQaQsRL49evCfaLBrvn3piLJWtr2CXya1hla0hzvK6+oiJKayfosTnKxl8+H89il7jce5ES/ILtizEhcm+fJwNKuGjTQF2jyjvLsPqYdO8OOxqVyAWvFHgwIRD3b2Dsah1y94DKpQUzWeEkQ/h2tIfR0v2DNBxAXY/pSffAwmpDcr5KcDGXAV2Y9N5HTHnBuI/1MP0zRO/zbotS3Q1TeBtPOcT1Jes9N9EFIe6+14Ip7ySGt+UjQMxjFsBCcBaqid8ScMJux8c2tnhZa5CePjh4jFoK0BQK7RvY7JYqlO64p/VGDTJRNvqGkJyqtojJlsTRx5qFUPuVoqXznKE0BljlsjP47+yTsvRzqTXFiO3SlPm26EplHdN0Xmjy6OQjmx2Iqau/WwJe57RHWGGLONPAX06a4rbGelegz3ECbvrBCz4Kx
 xBPCjUL3
 6NwI+3o/o4Rd+b81qOvm3a8XoVZ3IpPW6RvqatF3hrhXChJM=
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


