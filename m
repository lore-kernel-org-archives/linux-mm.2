Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36DEC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C416B00B1; Wed, 19 Aug 2026 05:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB886B00B2; Wed, 19 Aug 2026 05:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA496B00B3; Wed, 19 Aug 2026 05:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B78496B00B1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54BC01A04F7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:50 +0000 (UTC)
X-FDA: 85117557420.15.D011CEC
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8552FC0006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HD+Fha9L;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
	b=2MMOs1jJIJ4L/VpS4QEzawiz2l54KXeykpQniIbj9bSlHnC7V9PzYA/nf2jd7DY47+A7CW
	8kE6ebHJtQ56L7sl4nCBFhBUeQOebLsWi/F6VEl2HMttGWJDMiqJoAuCdQP9WVfiqMRhJr
	3tODePbPAOzAl16ZgnaAB7eCSci9WAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133228;
	b=uquP/fKuu0VQhdyfGaa/GmVKLxH5/7inea/gPw/TD0U0+npKr7mTvhTKaJDa70HBUYzB2K
	fkywdYzHWlej1j6khyL7W8EhCTRjG77E1yDjs7HBUNmKW+udcmzs0O97Gy2adCtTFnAQ9X
	TNwnrYp+bX31PROXpA0Mh7WUY5DuMaU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HD+Fha9L;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cacf197759so11010345ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133227; x=1787738027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
        b=HD+Fha9LyHCrRFbetCDMB92nCJYdB8Od1pAPw/FOdAEmsCqHuvYdsLLwfBGQiaJet2
         6CLU0OrRwRKxGf60OlAfrBWTHI8P+ppgJko6kPofe5B3FRDNKDaQH5w6eQTNopCAGTtb
         soP7KK8Irfe9RGZ7sFdMpAOzfMImX2NxcMbRIkOCiqjP2BzyEMXaqNM9uRnIMp0Y6i6P
         vQZkbPQZI2lf3V3FPO13kS9thbkMRscEQ7sqSwDQOf5YLIz5T95VTh9KrACaofUJcLd8
         +lwxv4GX5OYT0k1OL4YRhJVmg+QlxS0uoODKpgMiqGAlH0kGie0NDuwKaibS5XdLGFBk
         B9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133227; x=1787738027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
        b=UegzWiNvD3/fzHx2CFRJhDt32R2vq4/Fb+ySKG7xmTXVcs+AG+YXXWvy/fFhFZCefg
         74mOoiCTMsuSE8XwLlnzYz0VFhKDusXvpBVadg9YlBcQQFvGixqXqd2QgRgzPbwNzG7U
         dC6vCaL5eUYcyP+tKH+JyN0kTdgzHgtHF9HrwCsGL7s6+bt0gtub8W0IekdULTCoKPWT
         +gsLsRVwkpny/ut8jo7abO0gLyJMKARUos/CCuwaZFQbffHOysV1Vt5I0rLGpoG0P1U0
         MSANpZNHfuffbiVLtxkL/MpJhqAVJ7mO6W5TIBbGCnH3+fVxH/Kvu/PQFz8Hug2Y2zfX
         k9hA==
X-Forwarded-Encrypted: i=1; AHgh+RpPOJUvsaN9hXcKpr/Ajvk6xk1o/iLugllUs37dMCiodb5OgBbbxuoAck63hFM8yZoN9E02O1ey2w==@kvack.org
X-Gm-Message-State: AOJu0YwqhqJipCeSv7PXA3YIa6jbdEzndRMCIrTMMVMrBKS3cFBSieP1
	svRoSr6oP6/ZO4IFhtgQQqaEwe61LZjmYqdTSnQ2KkBajSNTwMyFqTjozkXLqqd8mNs=
X-Gm-Gg: AR+sD10upKiatd6CWLh/nyGfpONaRBpPQAn6WwIUtLWzCh+0Z+0Xo0Mxf8cwyDNmYFE
	Vp6BccbKtvqLPqt5tajfDsB+pTtGjNSM+1BFk7+ZCengpmfdhyvHRcdLNNC4xzopqgTlGaOQso2
	O2pJfKdgTGhdKdfeCUcID3Ad6EDRz43UEMf0utzzWfxFxoqkxb9Hcca94galcQKfdGZyqWzuL6e
	cpcKfEei/nRanX0I6G9TIXudqIyYKag8ZtNq4y8ATcR9dTCF1o1rTi4+kqX87kT/5/2XqFmZFic
	Syx/hPKobZM142w8gSsJBQ7MPTosCmuilwo58nMvlsMdNZ1n84Jawmay7XvNeDiE3lidHiFVlu/
	0BaEAHJUDuvGW6wOkHULxp2f6CjQ9Hpo5dOQnF9DOpiY/w2Fcysk0+GQFmm7RyuXwEoqDqoIM0r
	/DbBdY6JYfzqS9JygrflRbZMVxX25HsdPLZljLoJziDw1i2zH9UJVxXf6h0x8jFu5ABPSQTbIEC
	TlZspmtsRN0tGlFWxGKgtBL1cuQ91Uoq+fC
X-Received: by 2002:a17:903:26cf:b0:2bd:c925:3a16 with SMTP id d9443c01a7336-2d5fd684b75mr61834225ad.2.1787133227279;
        Wed, 19 Aug 2026 02:53:47 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 12/17] mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Wed, 19 Aug 2026 17:51:34 +0800
Message-ID: <20260819095140.17252-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ifcg5ebyfd3izse37o6pqzrifqn9nbip
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8552FC0006
X-HE-Tag: 1787133228-871015
X-HE-Meta: U2FsdGVkX1+puaORN01u8FNsbU54ubLU7E4GoxZEV2xUFLLnaYfioLuW7tFnml8Jgk2FtUWVOd8jKshCO69TUR/0Uo8gZgJc4QaqSx7JCAK4ErX/Nj61rH8sgoM0TG/c6QyXoRb2YjSKMJzL/KUA+NqaSVh9Xc/Ub7pZUm1Dq3X7iPPaoBXMO5vsmS9d5v3jaKnNrGsrlEjIq9XVdZsNsRsulN3B07vgC+uDJrta00yW6UPJABsklsmrf5Ej+v1J9M87mhrOmjMFjTGLzZeAaU4UX55hpSqr335sXYYosDl7Dw3oK2HQqCSWsGY+ZytBFrLkL33Brxi8kBEDl9vF/KyhS1eo9oDFfYK1oo9LrOo0PmLfhza8QnvDPAp2DWHfd72TW4oDD1yJHhyGHLVac5QwXglq+J3M7zNkqpFGpMgEtmyrrLeJKUH4KEmAbr9RjX7nIzeMHBZRkIvux8qVWc6bII4TV79qDfTr/Hn8cEfbCyui14GOJ2ldi/zFcIPWZjQS/e+3VHspTcpcsvaExqXzF1FIBBe5kI5lQZLrZTGma7biIfjKHs+2xtuI6a9ro7ZbqsKHRFz/kMvRwvJVNCofMthtr/Y8kt0Aa/9RNE2to5FtLdIwBuof22GoxxbfAOxJ7cf3nz9jWA18CIv6xk4k7Ad6EkVIr4ymeckBBl/9nU74oimpBQMIvOhkQKHt0SMjFudqbi1dMqmmljmo+/os4smG+noeAvXZkW8uerWxh7e2Sh+wGDewp4MYlZuM0Zt2pzXjLSTF0ftbR4czipY/jFCGz1Ce/393GP8Wue/CN8LXREz7OnXMULHp9r4XFBXNDS7/WIBkK6QKb2jT/Ev3tAa54wpM/Phx+MvZjkwqzoQ84w7zyGHSnCemx9ZNOAGWjdf1qkBhp9G4WpM0r2cN6qbA4Uc5Yf74WF7x5c6dwfu6+zPWoeVXBfMelz7ta0zxUvlX0Te6b092MeF
 1a/0IwzG
 6i/3lZXze5UcwbwHdPeF53hXmVc4TsXkU28DP+1DzoHPoZiIRTPzIZDwBTesLWZC0jLpboHKrTHiHqf9eljDtJD4EUnI10BGj8nrU9O0Wrvd9F00zYUxrL+EMfKcYl8OPyx0m8mJpUEnQBsiQyIxBq0CYgGwZXyXcDGdXYsMF1e66+Ge5DSSuwHha5Fe6dWibteojtXJGd8Y4D3y9aG1dpu9D2GCur5tMrYP4RD7mJZT28016H3mGMwQvRpzV/S2/DuDDp7u6V25KETSbyaP5TqD6yMxCR6ddKk5FtGJYru6GFoDgPOR6cL62YluG4g9ZK/um0DBMWtoFRqayqth7IkNjx01THvepCiJsyizlhs55PIS9o2hc+qL5vvJPJnrmRix/swTaXPRY5BLKRpZTw8P3fT5/dSjSNT7Cfkh4+Wd1c+KGvR21QMXpMXicPiC9gqVFXzFzVeeDMWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h |  3 ---
 mm/sparse.c            | 46 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8bcb522645ba..67c84a8a7258 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2223,9 +2223,6 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index 948839621f83..7096d8e13802 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -235,42 +235,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __initdata;
-static void *sparse_usagebuf_end __initdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -280,8 +244,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -297,9 +264,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
-- 
2.54.0


