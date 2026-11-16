Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9260F606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QgykT0qT
Received: by kanga.kvack.org (Postfix)
	id 1C37E6B05BB; Mon, 16 Nov 2026 06:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B296B05BC; Mon, 16 Nov 2026 06:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A686B05BD; Mon, 16 Nov 2026 06:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C87556B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E15CA08C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:11 +0000 (UTC)
X-FDA: 85440697902.12.B39ADEA
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id A4E5F1A000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QgykT0qT;
	spf=pass (imf19.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
	b=afsedPI5xxwyklauYQKyI/4IH1PqKVBh3HBOM7QOA/YbGikbvmSMHkg1pkUqzl6xFkIVyj
	kTdz6YmZ8OyxedVXMTGPTAut/Bn+J2WpvxVy6kbDvnLnEUiCIBbaihWhUczjiWjxXC1baI
	85462+zYHlefm3fWeG9h+eKqsMkRUoM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QgykT0qT;
	spf=pass (imf19.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827049;
	b=Sxh+WMQPIyVQ2LTSNGCTrGfYsG8LtcwP73y75DTM+Z+SkOrcWHF47yJZf4GMd1Cf2A/TOT
	N5pYAmvlErQSvxe2Ft8rjNtc9clo9QiezeqvlhrkVACORXaQ3exXL5IarnlcGclcns5Ds6
	g48h02ZFWKHjXBvQUL2O7mHsn/udP8A=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-14394530ec6so3921071c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827048; x=1795431848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
        b=QgykT0qTpb9bovKQoALkBmkb2EV4PLXlmG8Zk40o2SCeJUNwLbdiHnVKc8GjagSqFF
         xw+5pWfBOTsGRSaG1o/vIJJmPjS5OfScXUvFAjNeNFBwKJ9ndtLrviPL5GlGrH5EkSOB
         +Yi7OWqmrau6XFESqy2iZ/5GJFe7d5pqpq34k9L13B/Rm6NNpX8wUmaQvMeu/5RJeK0u
         hWo9vs4ncuOshCwGxSEXzi/lOWb+0UqmtshfaxRZbMpM4rh6dDU6DRwTq3YwnhmaEzex
         kTMrtEN6NJzn7F/VtXPmfcH19k0hMzvBGuRHOL9YaVkHDzoeaA2ggdw7bSKmzVokduph
         sGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827048; x=1795431848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UFkLx8K70zbjJh9fnPavuCyXoMHBI/rMam1c7UmStiE=;
        b=Twk4RUCPD9XPyj6CZtvB/cLvKhx393poyQndpeL2SQE7fLQki/6Zgq/BzdN5cTdUjq
         bexE1Pq4fNoE+LgXQigsb/pWoTcSgAXdKytVyq73pVUeXflb/JtSsGHQUczghdmrq0aH
         LvY6LLOHhnRF3Z/XLxn9zvRMWBFuHfYJdCtB2Hq5tYLsUqW+mY19DS2W3qVfORk4lipf
         tDRqNAtZhEmscAVJWx/LuLL0c77ssi2nQzxzbRGnMMTKcGDIQ8kk/+6F6iVNPSxtWis6
         QfdMcd2dd8+UyistVhIw38fMT2NXZkJSxgJvDCBFXoVpSvboQWeeUW2ghMS2f1LKC/xh
         hzsQ==
X-Gm-Message-State: APuU4Z/cgYS5kbsRIpaUJy7imavUIjS4G4i++o6ieOohDbscUVUce/C4
	ivX2ebxO3J86ObS8tPl5SSyJJVqTwrH1wPLI6UQKRDP0hveTmeTGxnk/oSa2D8RqpojQ7sjf
X-Gm-Gg: AYBFou1M5TM8xH/ehqTNYY5hlP4X3OLpMPvcBwwtIXg5fDwGDRYzeyCtdbI8FQcmn1O
	9372JiINwnEP2bMM+NAQVDM0EXaG7z5jTVuFi1ybNH2SVGvhiqFoaGnIxrf0UxVvXKMSgzQZUzv
	Znt4kHU6ulZZvscKlqm5TbzBAEhnkPl2vmuo0q/BEkzoA0hIgsXi+4JBYsu2zfw7ICP+PXHo6FA
	5n1gs5yTK+fswtV5xkCHRuqV3FNEOm/NFyA58M9vJdffEr1mIs0p4ikWJId9mDeQeqgHDLix3Ns
	2QeN/ZrDwdjo+IBzBm1ZPYLSRqp5M/nwTqnOINsdW7GQCZWB7EHFiDO/PmJbOxoaYmy23PDRdXw
	r2qp1DthUHmb8mXPl1zqv/j4ur6PyBuIZPoT1e9WVtxD2o24Tv2HbjeroKwkle3HDG3Hewg/Jrz
	4eOYtCKIok8FQkRsiACVLlzaj183VZ9a1/ls+3+CT5S5AWx8PhggqC0GHJnF22brXPQiiHr5Y7R
	v5dj1sSmUQ6WKyyruwhRuCw1SbyD5we5Q//v9qsjkQMln56iY56duN3xbEDzp+JZ9sU9ferWOg3
	lrsw4gz0s7lSvkw7iezmKMO83+wMrH5Nal97SWj5AQR9yMk=
X-Received: by 2002:a05:701b:4212:20b0:179:a1d0:be39 with SMTP id a92af1059eb24-1b50312449emr10434131c88.29.1794827047944;
        Mon, 16 Nov 2026 03:04:07 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:07 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 06/16] mm: memcomp: store shmem and tmpfs pages
Date: Mon, 16 Nov 2026 19:01:12 +0800
Message-ID: <20261116110122.309748-7-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: arew5kjwnzdwbe5jh9pgrephq4ima5ua
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4E5F1A000D
X-HE-Tag: 1794827049-875225
X-HE-Meta: U2FsdGVkX19ilRwzGvpWrYdTuJk+XHeoJlp7HW87Uma6EYD3SsVbPXutxtoLuCLBnZDEW97vT/kKvL/hE1WlqzCWMs3g+95kfSNKuL8jxVxxvzI1jtpuEqCHDSG7waUjtW44KQ4irhsadoVsA4EzZIkngmMMVM85+xZpsGWLiXODQi6zzGTtqWoC0vL9fcGrWe66okd/W+Zp3buUQ1VwCsbKtKZ+cfnKYN7wrnosfdQBr5mKLfAqLLgIQJz9Bc2rheukgqchbAQtn2pS3avQQ3WMORRyQRjH+oCJs2m/smI8B1qISHfrPXlcVNbg+5im1wC29hqgKVlzhzqtzE6WOdoF2LecVt4oZ9Sqd0RP31T22Uyu8U/IJbpCI1Bg8k5xOl2T4nng2Hx9w4PiFOU9j549sGRA/JvK08qIzkF5vNROvGN9xxvpc9JQ82wNcp4Muk+BwhjRfl80aDU1E7kHuLKHA8ONcruwUrs9JZLmCXgq3M1POMW+Gc+EPs35obmhciiH4700u2nD5pz2Il2nxsSlm02LAyBKpFsl2thv6JWmRRoFZKw3bFaSkWrSqLL7BFR8UIdai2A18gPGr2wqzw7VRwoVHAcqn2MiH/kozfhrNSiQdglGKdzLUL5m04ztH4Qc+LC28S8dT9jq1bbiyJViTE5VTtLLZJJUWgaBeZ/i3zCHqujxbEKaTRD0B99RdjpiEjAr35lMs0vNof5unHaTDk0BP1W1eX4uEDbiRaIE0OGvzlyMcwjkUunM5iBcM8jagsHq03LSy5knE5HDCBM5uN8+t5E7r9d+JKwV2rvMJYoytq0dvsJomqiS6Afx7zS5L7XdOsI5kw/A/2spOx7trq7la3ieIruduWuEoQKqC0EsFFVJJ5C7L2sqcOREYjtaF49Mspqafr/z1kVokCI8yPPy/gJVwiU/oqwCAQKrBvuQg5MCct5QRurIWs+H2Acr/7tJTX5qkMnbsD2
 2U5rYBFY
 CfX9VDky6fXH7n8aeKEulAgqXuxLDelP1jUNBgLKZGmkrqKeQmxYOPaXj9st8opXYLO4FZzT9WFDoFINS02gabjg7tOJGyJtXD2rrF2Q9HryDwK9vLTqaNqRkl+V5dgvgIeIo/IbdQJiNURy0GZS92+V3zCVc2fhtWKmIMubxXeR9PGE9Kdoq5UYVEN6Cq5WojXKjVRe6j60Y6NMCXjjl9GlVcpNmqrRpIiiEPJwTCvFcCl/ZhIRfHS9EWb02+njZEoltmTHKlBIoFr7CLa/uvHmb+7n7gfpZ5OkisA+jCn7i6sTYzI1Mfwog1wdSigfIpqril0mwPatC7FgfcakKQg998yk98ubrudjr4LODy9rWphRt0+oXy67v7Ek4IirTBsXaXdUZDyr+RQRmv2tMKHsNeo9IsT8w3mea7LfULvgtjIXnbOYC9/yiCg5sSmKJbyjRexuFC9fLbKjatQpqPidy3qD0TnQKVgvIBGZFpFEG8XFCYkzRSEtGQC9/m+gbNwa1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Anonymous token PTEs do not cover shmem contents held by a page-cache
mapping. Shmem needs an exceptional entry that survives eviction and can
be replaced atomically when the contents are faulted back.

Store eligible single-page shmem folios in memcomp and place their
tokens in the page-cache xarray. Reserve per-key slot storage with cache
ownership distinct from an anonymous producer's resident-record
ownership. Prepare payload and accounting before activating the slot
references that the published shadow will own.

Keep a lookup reference while allocating, charging and decompressing a
refault folio. Confirm that the expected shadow remains installed before
committing the page-cache replacement. Only the winning replacement
consumes the cache owner; an aborted load retains it. Balance inode
accounting, memory charges and temporary references on every exit.

Publish a zero shadow's owner count only when the expected xarray
replacement succeeds. Keep that cache-owner ledger separate from
anonymous zero PTEs, and do not allocate slot metadata for a zero
shadow.

Retain ordinary shmem swap as a fallback. A successful in-memory store
needs no swap device, and truncate or swapin races can retry without
publishing contents from a stale shadow.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h  |  80 +++++++++++++
 mm/Kconfig               |   3 +-
 mm/memcomp.c             |  46 ++++++++
 mm/memcomp/api.h         |  34 ++++++
 mm/memcomp/cache_folio.h |  70 ++++++++++++
 mm/memcomp/cache_store.h |  70 ++++++++++++
 mm/memcomp/consumers.h   |  55 +++++++++
 mm/shmem.c               | 238 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 595 insertions(+), 1 deletion(-)
 create mode 100644 mm/memcomp/cache_folio.h
 create mode 100644 mm/memcomp/cache_store.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 20b553d12151f7bc0202c25d52e4f6832c6ae0b6..20e81dee9062b97274910a1ed3451dd0089ce235 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -103,6 +103,9 @@ void memcomp_entry_resident_put(struct memcomp_ref *ref);
 /* Consumes and clears the held guard on every return. */
 int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref);
 void memcomp_invalidate(unsigned long token);
+void memcomp_invalidate_cache(unsigned long token);
+/* Called only by the winning zero-cache XA replacement while locked. */
+void memcomp_publish_cache_zero(void);
 void memcomp_invalidate_nr(unsigned long token, unsigned int nr_pages);
 void memcomp_invalidate_folio(struct folio *folio);
 bool memcomp_release_folio(struct folio *folio);
@@ -125,6 +128,30 @@ void memcomp_entry_clear_refresh_pending(unsigned long token);
 bool memcomp_entry_get(unsigned long token);
 bool memcomp_entry_present(unsigned long token);
 
+/*
+ * Page-cache variants for shmem/tmpfs pages. A zero store result prepares
+ * a value only: its winning XA replacement must publish the cache owner
+ * before unlocking. An aborted zero preparation creates no owner to drop.
+ */
+bool memcomp_store_cache(struct folio *folio, unsigned long *token);
+/*
+ * Pin rejects token0 with an empty guard. Explicit zero load consumes no
+ * owner; the winning shadow replacement drops its cache owner separately.
+ * Pin must be resolved with exactly one abort or commit call.  Commit also
+ * drops the shadow owner and is valid only after replacing the expected
+ * shadow in the page cache.  Failed pins clear the output; abort and commit
+ * consume and clear the guard.  Load keeps the guard on every return.
+ */
+bool memcomp_load_folio_pin(unsigned long token, struct memcomp_ref *ref);
+int memcomp_load_folio(struct memcomp_ref *ref, struct folio *folio);
+int memcomp_load_folio_zero(struct folio *folio);
+void memcomp_load_folio_abort(struct memcomp_ref *ref);
+void memcomp_load_folio_commit(struct memcomp_ref *ref);
+
+/* Check if a page-cache xa_value is a memcomp entry. */
+bool is_memcomp_shadow(void *shadow);
+unsigned long memcomp_shadow_token(void *shadow);
+
 #else
 
 static inline bool memcomp_available(void)
@@ -225,6 +252,14 @@ static inline void memcomp_invalidate(unsigned long token)
 {
 }
 
+static inline void memcomp_invalidate_cache(unsigned long token)
+{
+}
+
+static inline void memcomp_publish_cache_zero(void)
+{
+}
+
 static inline void memcomp_invalidate_nr(unsigned long token,
 					 unsigned int nr_pages)
 {
@@ -301,6 +336,51 @@ static inline bool memcomp_entry_present(unsigned long token)
 	return false;
 }
 
+static inline bool memcomp_store_cache(struct folio *folio,
+				       unsigned long *token)
+{
+	return false;
+}
+
+static inline bool memcomp_load_folio_pin(unsigned long token,
+					  struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+	return false;
+}
+
+static inline int memcomp_load_folio(struct memcomp_ref *ref,
+				     struct folio *folio)
+{
+	*ref = (struct memcomp_ref) { };
+	return -ENOENT;
+}
+
+static inline int memcomp_load_folio_zero(struct folio *folio)
+{
+	return -ENOENT;
+}
+
+static inline void memcomp_load_folio_abort(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline void memcomp_load_folio_commit(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline bool is_memcomp_shadow(void *shadow)
+{
+	return false;
+}
+
+static inline unsigned long memcomp_shadow_token(void *shadow)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/mm/Kconfig b/mm/Kconfig
index d88c27e0235bf8ac79e05e009b8a4625d9d0c693..61356d7e375b4ce4bcf93b5d37108deb8dd655bd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -195,7 +195,8 @@ config MEMCOMP
 	select XXHASH
 	default n
 	help
-	  Enable direct in-memory compression for reclaimed anonymous pages.
+	  Enable direct in-memory compression for reclaimed anonymous and
+	  shmem/tmpfs pages.
 
 	  Pages are compressed into RAM and mapped through a special
 	  non-swap PTE entry type. This does not require swap block I/O as
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 8944fa081f3e35bfacf00d3a1c09c8bb32a9db18..07242de736f6771d4a6d74a6182b2cad4c9d150d 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -2234,6 +2234,35 @@ memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
 	return 0;
 }
 
+static int memcomp_prepare_payload(const void *src, unsigned int src_len,
+				   unsigned int *length,
+				       unsigned long *handle,
+				       u8 *pool_idx,
+				       enum memcomp_payload_mode mode,
+				       bool allow_provisional_raw)
+{
+	struct memcomp_reclaim_ctx *ctx;
+	unsigned long element;
+	int ret;
+
+	/* Same-filled shmem pages do not need a compression workspace. */
+	if (page_same_filled(src, &element)) {
+		*length = 0;
+		*handle = element;
+		return 0;
+	}
+
+	ctx = memcomp_get_comp_ctx(mode, NULL, MEMCOMP_RECLAIM_DIRECT);
+	if (!ctx)
+		return -EBUSY;
+	ret = memcomp_prepare_payload_locked(&ctx, src, src_len, length,
+					     handle, pool_idx,
+						 allow_provisional_raw, NULL);
+	WARN_ON_ONCE(!ctx);
+	memcomp_put_comp_ctx(ctx);
+	return ret;
+}
+
 static __always_inline int
 memcomp_arch_prepare_to_swap(struct folio *folio)
 {
@@ -2242,6 +2271,9 @@ memcomp_arch_prepare_to_swap(struct folio *folio)
 
 /* Allocate @nr_pages consecutive tokens, skipping fragmented free ranges. */
 
+#include "memcomp/cache_store.h"
+#include "memcomp/cache_folio.h"
+
 /*
  * Core store - compress @nr_pages pages and insert them into the global
  * entries xarray under consecutive tokens.  Returns 0 with *token set
@@ -2455,6 +2487,16 @@ static bool memcomp_map_resident(struct vm_area_struct *vma,
 #endif
 
 /* Check if a page-cache xa_value is a memcomp entry. */
+bool is_memcomp_shadow(void *shadow)
+{
+	return xa_is_value(shadow) &&
+	       is_memcomp_entry(radix_to_swp_entry(shadow));
+}
+
+unsigned long memcomp_shadow_token(void *shadow)
+{
+	return swp_offset(radix_to_swp_entry(shadow));
+}
 
 /*
  * Shmem/tmpfs variant: compress a folio and return the token.  This does not
@@ -2468,6 +2510,10 @@ static bool memcomp_map_resident(struct vm_area_struct *vma,
  * abort.  The caller handles locking, page-cache insertion and rmap.
  */
 /* Explicit zero transport: no sentinel guard or owner consumption. */
+int memcomp_load_folio_zero(struct folio *folio)
+{
+	return mc16_cache_load_zero(folio);
+}
 
 /* Fill an existing token span after every mapping has been removed. */
 
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
index 5e49d8484f0a303533f5ae04e0477960775c3512..4cc192fba3af9cd858f5752a8e5e931ef4e3af8f 100644
--- a/mm/memcomp/api.h
+++ b/mm/memcomp/api.h
@@ -29,6 +29,16 @@ void memcomp_invalidate_nr(unsigned long token, unsigned int nr)
 	mc16_pte_put_nr(token, nr);
 }
 
+void memcomp_publish_cache_zero(void)
+{
+	mc16_zero_cache_get(1);
+}
+
+void memcomp_invalidate_cache(unsigned long token)
+{
+	mc16_cache_drop(token);
+}
+
 bool memcomp_entry_present(unsigned long token)
 {
 	return mc16_entry_present(token);
@@ -146,4 +156,28 @@ int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref)
 	return (ret & VM_FAULT_SIGBUS) ? -EFAULT : 0;
 }
 
+bool memcomp_store_cache(struct folio *folio, unsigned long *token)
+{
+	return mc16_store_cache_folio(folio, token);
+}
+
+bool memcomp_load_folio_pin(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_cache_pin(token, ref);
+}
+
+int memcomp_load_folio(struct memcomp_ref *ref, struct folio *folio)
+{
+	return mc16_cache_load(ref, folio);
+}
+
+void memcomp_load_folio_abort(struct memcomp_ref *ref)
+{
+	mc16_cache_abort(ref);
+}
+
+void memcomp_load_folio_commit(struct memcomp_ref *ref)
+{
+	mc16_cache_commit(ref);
+}
 #endif /* _MM_MEMCOMP_API_H */
diff --git a/mm/memcomp/cache_folio.h b/mm/memcomp/cache_folio.h
new file mode 100644
index 0000000000000000000000000000000000000000..b0b9f154b42f02f54720f44f5c1e15dd2bf4140a
--- /dev/null
+++ b/mm/memcomp/cache_folio.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_CACHE_FOLIO_H
+#define _MM_MEMCOMP_CACHE_FOLIO_H
+
+#include <linux/highmem.h>
+
+/* Include after cache_store.h and memcomp_arch_prepare_to_swap(). */
+#define mc16_cache_folio_arch_prepare memcomp_arch_prepare_to_swap
+
+/*
+ * Caller holds the order-0 source folio lock throughout preparation and XA
+ * replacement. Output is valid only on success and unchanged on failure.
+ * Positive success transfers the initial cache ref, without another get.
+ * Caller drops it if the expected XA replacement loses.
+ * Zero success is preparation only: the winning XA replacement must publish
+ * one zero cache owner under its XA lock. A losing zero preparation owes no put.
+ */
+static inline bool mc16_store_cache_folio(struct folio *folio,
+					  unsigned long *token)
+{
+	struct memcomp_ref initial = { };
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	unsigned int nr_pages = folio ? folio_nr_pages(folio) : 1;
+#endif
+	void *src;
+	int ret;
+
+	if (!token || !folio || !folio_test_locked(folio) ||
+	    folio_test_large(folio) || folio_mapped(folio) ||
+	    folio_test_mlocked(folio) || folio_test_writeback(folio) ||
+	    folio_maybe_dma_pinned(folio))
+		goto fail_eligibility;
+	if (!memcomp_is_enabled())
+		goto fail_payload;
+	/* The arch predicate includes tags, unlike a byte-only zero scan. */
+	if (pages_identical(&folio->page, ZERO_PAGE(0))) {
+		*token = 0;
+		goto success;
+	}
+	src = kmap_local_folio(folio, 0);
+	ret = mc16_cache_store(src, folio, &initial);
+	kunmap_local(src);
+	if (ret)
+		goto fail_payload;
+	/* The arch hook keys metadata off page_swap_entry(). */
+	folio->swap = make_memcomp_entry(initial.token);
+	ret = mc16_cache_folio_arch_prepare(folio);
+	folio->swap.val = 0;
+	if (ret) {
+		mc16_ref_put(&initial);
+		goto fail_arch;
+	}
+	*token = initial.token;
+success:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_store_ok_pages);
+	return true;
+
+fail_eligibility:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_eligibility_fail_pages);
+	goto fail;
+fail_payload:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_payload_fail_pages);
+	goto fail;
+fail_arch:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_arch_fail_pages);
+fail:
+	memcomp_debug_add(nr_pages, &memcomp_shmem_store_fail_pages);
+	return false;
+}
+#endif /* _MM_MEMCOMP_CACHE_FOLIO_H */
diff --git a/mm/memcomp/cache_store.h b/mm/memcomp/cache_store.h
new file mode 100644
index 0000000000000000000000000000000000000000..ca2d6097b491aeaaaf2807e367d37ec3f6b8cc8b
--- /dev/null
+++ b/mm/memcomp/cache_store.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_CACHE_STORE_H
+#define _MM_MEMCOMP_CACHE_STORE_H
+
+/*
+ * Prepare one cache payload, retaining its initial cache reference in out.
+ * The caller keeps the source/account folio alive and transfers that reference
+ * only after arch preparation and the expected page-cache replacement succeed.
+ * This lower-level helper does not choose the separate slotless-zero path.
+ */
+/* Private reservation -> counted initial cache ownership, infallibly. */
+static inline void mc16_cache_publish(struct memcomp_ref *ref, unsigned int bytes)
+{
+	memcomp_stored_bytes_inc();
+	memcomp_compressed_bytes_add(bytes);
+	mc16_account_state(ref, true);
+	mc16_cache_activate(ref);
+}
+
+static inline int mc16_cache_store(const void *src, struct folio *account,
+				   struct memcomp_ref *out)
+{
+	struct mc16_initial_payload payload = { };
+	struct obj_cgroup *objcg;
+	unsigned long handle = 0;
+	unsigned int bytes = 0;
+	u8 pool = 0;
+	int ret;
+
+	if (!out)
+		return -EINVAL;
+	*out = (struct memcomp_ref) { };
+	if (!src || !account)
+		return -EINVAL;
+	if (!memcomp_is_enabled())
+		return -EOPNOTSUPP;
+	/* Independent source owner, never a borrowed registry key across X1/X2. */
+	objcg = memcomp_objcg_get(account);
+	ret = memcomp_prepare_payload(src, PAGE_SIZE, &bytes, &handle, &pool,
+				      MEMCOMP_PAYLOAD_BEST_EFFORT, false);
+	if (ret)
+		goto out_owner;
+	if (!memcomp_payloads_net_reclaimable(&bytes, 1)) {
+		if (bytes == PAGE_SIZE)
+			memcomp_debug_inc(&memcomp_raw_reject_net);
+		ret = -E2BIG;
+		goto out_payload;
+	}
+	ret = memcomp_objcg_charge(objcg, GFP_NOWAIT | __GFP_NOWARN, bytes);
+	if (ret)
+		goto out_payload;
+	payload = (struct mc16_initial_payload) { .word = handle, .bytes = bytes };
+	ret = mc16_reserve_cache(objcg, folio_nid(account), &payload, 1, out);
+	if (ret) {
+		memcomp_objcg_uncharge(objcg, bytes);
+		goto out_payload;
+	}
+	/* No pending/resident/OWNER transition or record/member RMW occurs. */
+	mc16_cache_publish(out, bytes);
+	ret = 0;
+	goto out_owner;
+out_payload:
+	if (bytes)
+		memcomp_zs_free(pool, handle);
+out_owner:
+	if (objcg)
+		memcomp_objcg_put(objcg);
+	return ret;
+}
+#endif /* _MM_MEMCOMP_CACHE_STORE_H */
diff --git a/mm/memcomp/consumers.h b/mm/memcomp/consumers.h
index 929c046bf98d52c878e727e14d859d81c871b743..03aef9ffecb6df83b6314df43739677120fdd8f8 100644
--- a/mm/memcomp/consumers.h
+++ b/mm/memcomp/consumers.h
@@ -46,19 +46,74 @@ static inline void mc16_pte_put_nr(unsigned long token, unsigned int nr)
 }
 
 /* The caller removed one cache owner, independently of any PTE owner. */
+static inline void mc16_cache_drop(unsigned long token)
+{
+	struct memcomp_ref ref;
+
+	if (!token) {
+		mc16_zero_cache_put(1);
+		return;
+	}
+	if (mc16_get(token, &ref))
+		mc16_ref_put_count(&ref, 2); /* lookup + removed cache owner */
+}
 
 /* Empty output on failure, including token0; caller handles zero explicitly. */
+static inline bool mc16_cache_pin(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_get(token, ref);
+}
 
 /*
  * Keep this same guard through load and the caller's xarray transaction.
  * Failure leaves both the guard and cache owner intact for abort/retry.
  */
+static inline int mc16_cache_load(struct memcomp_ref *ref, struct folio *folio)
+{
+	void *dst;
+	int ret;
+
+	if (!ref || !ref->slot)
+		return -ENOENT;
+	if (!folio || folio_test_large(folio) || !folio_test_locked(folio))
+		return -EINVAL;
+	dst = kmap_local_folio(folio, 0);
+	ret = mc16_load_page(ref, dst);
+	kunmap_local(dst);
+	if (!ret) {
+		__folio_mark_uptodate(folio);
+		flush_dcache_folio(folio);
+		memcomp_arch_restore(ref->token, folio);
+	}
+	return ret;
+}
+
+static inline void mc16_cache_abort(struct memcomp_ref *ref)
+{
+	if (ref && ref->slot)
+		mc16_ref_put(ref);
+}
 
 /* Only the winner replacing the expected cache shadow may consume its owner. */
+static inline void mc16_cache_commit(struct memcomp_ref *ref)
+{
+	if (ref && ref->slot)
+		mc16_ref_put_count(ref, 2); /* same guard + cache owner */
+}
 
 /*
  * Explicit token0 branch: no guard, lookup or owner consumption. After the
  * expected zero shadow is replaced successfully, caller must cache_drop(0).
  * An aborted xarray transaction leaves the zero cache owner unchanged.
  */
+static inline int mc16_cache_load_zero(struct folio *folio)
+{
+	if (!folio || folio_test_large(folio) || !folio_test_locked(folio))
+		return -EINVAL;
+	clear_highpage(folio_page(folio, 0));
+	__folio_mark_uptodate(folio);
+	flush_dcache_folio(folio);
+	memcomp_arch_restore(0, folio);
+	return 0;
+}
 #endif /* _MM_MEMCOMP_CONSUMERS_H */
diff --git a/mm/shmem.c b/mm/shmem.c
index 5960e5035f983571fb806313855f74c61abf8354..a04e68d445d37384b02b56e791586d09b392fcfa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -80,6 +80,9 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/uuid.h>
 #include <linux/quotaops.h>
 #include <linux/rcupdate_wait.h>
+#ifdef CONFIG_MEMCOMP
+#include <linux/memcomp.h>
+#endif
 
 #include <linux/uaccess.h>
 
@@ -847,6 +850,15 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 
 	xa_lock_irq(&mapping->i_pages);
 	error = shmem_replace_entry(mapping, folio->index, folio, radswap);
+#ifdef CONFIG_MEMCOMP
+	if (!error) {
+		swp_entry_t entry = radix_to_swp_entry(radswap);
+
+		/* Publish ownership before any reader can remove this shadow. */
+		if (is_memcomp_entry(entry) && !swp_offset(entry))
+			memcomp_publish_cache_zero();
+	}
+#endif
 	folio->mapping = NULL;
 	mapping->nrpages -= nr;
 	shmem_update_stats(folio, -nr);
@@ -864,14 +876,29 @@ static long shmem_free_swap(struct address_space *mapping,
 			    pgoff_t index, void *radswap)
 {
 	int order = xa_get_order(&mapping->i_pages, index);
+#ifdef CONFIG_MEMCOMP
+	swp_entry_t entry = radix_to_swp_entry(radswap);
+	long nr_pages = is_memcomp_entry(entry) ? 1 : 1 << order;
+#endif
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
 		return 0;
+#ifdef CONFIG_MEMCOMP
+	if (is_memcomp_entry(entry))
+		memcomp_invalidate_cache(swp_offset(entry));
+	else
+		free_swap_and_cache_nr(entry, nr_pages);
+#else
 	free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
+#endif
 
+#ifdef CONFIG_MEMCOMP
+	return nr_pages;
+#else
 	return 1 << order;
+#endif
 }
 
 /*
@@ -893,8 +920,23 @@ unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 	xas_for_each(&xas, page, max) {
 		if (xas_retry(&xas, page))
 			continue;
+#ifdef CONFIG_MEMCOMP
+		if (xa_is_value(page)) {
+			swp_entry_t entry = radix_to_swp_entry(page);
+
+			if (is_memcomp_entry(entry)) {
+				if (memcomp_entry_stat(swp_offset(entry),
+						       NULL, NULL))
+					swapped += PAGE_SIZE;
+			} else {
+				swapped += (1UL << xas_get_order(&xas)) <<
+					   PAGE_SHIFT;
+			}
+		}
+#else
 		if (xa_is_value(page))
 			swapped += 1 << xas_get_order(&xas);
+#endif
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
@@ -904,7 +946,11 @@ unsigned long shmem_partial_swap_usage(struct address_space *mapping,
 	}
 	rcu_read_unlock();
 
+#ifdef CONFIG_MEMCOMP
+	return swapped;
+#else
 	return swapped << PAGE_SHIFT;
+#endif
 }
 
 /*
@@ -932,6 +978,15 @@ unsigned long shmem_swap_usage(struct vm_area_struct *vma)
 	if (!swapped)
 		return 0;
 
+#ifdef CONFIG_MEMCOMP
+	/*
+	 * info->swapped counts a memcomp entry as one page, which is what
+	 * shmem_partial_swap_usage() also reports for it, so the whole-object
+	 * answer is still exact without the walk.  Restoring this matters:
+	 * smaps_rollup is polled continuously, and the walk is an RCU pass
+	 * over every entry of the mapping with an xa_load per memcomp one.
+	 */
+#endif
 	if (!vma->vm_pgoff && vma->vm_end - vma->vm_start >= inode->i_size)
 		return swapped << PAGE_SHIFT;
 
@@ -1321,6 +1376,10 @@ static int shmem_find_swap_entries(struct address_space *mapping,
 			continue;
 
 		entry = radix_to_swp_entry(folio);
+#ifdef CONFIG_MEMCOMP
+		if (is_memcomp_entry(entry))
+			continue;
+#endif
 		/*
 		 * swapin error entries can be found in the mapping. But they're
 		 * deliberately ignored here as we've done everything we can do.
@@ -1459,7 +1518,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	swp_entry_t swap;
 	pgoff_t index;
+#ifdef CONFIG_MEMCOMP
+	unsigned long mc_token;
+#endif
 	int nr_pages;
+#ifdef CONFIG_MEMCOMP
+	bool memcomp_attempted = false;
+#endif
 	bool split = false;
 
 	/*
@@ -1475,8 +1540,84 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	if (WARN_ON_ONCE((info->flags & VM_LOCKED) || sbinfo->noswap))
 		goto redirty;
 
+#ifdef CONFIG_MEMCOMP
+	/*
+	 * Only an uptodate folio.  The !uptodate handling below is what gives
+	 * shmem_fallocate() its backpressure - it counts the folio in
+	 * shmem_falloc->nr_unswapped and redirties it so the fallocation can
+	 * give up with -ENOMEM - and what zeroes a folio whose contents were
+	 * never initialised.  Jumping straight to the store skipped both, so a
+	 * fallocate that should have failed ran on to OOM, and on a kernel
+	 * booted with init_on_alloc=0 the uninitialised page became file
+	 * contents.  A folio that arrives !uptodate takes the swap path, and
+	 * the retries below reach the store once it has been made uptodate.
+	 */
+	if (memcomp_available() && !folio_test_large(folio) &&
+	    folio_test_uptodate(folio)) {
+		memcomp_count_initial_compress();
+		goto try_memcomp;
+	}
+	goto try_swap;
+
+try_memcomp:
+	memcomp_attempted = true;
+	if (!folio_test_large(folio)) {
+		if (memcomp_store_cache(folio, &mc_token)) {
+			swp_entry_t mc_entry = make_memcomp_entry(mc_token);
+
+			mutex_lock(&shmem_swaplist_mutex);
+			if (list_empty(&info->swaplist))
+				list_add(&info->swaplist, &shmem_swaplist);
+			mutex_unlock(&shmem_swaplist_mutex);
+
+			/*
+			 * Raise swapped before nrpages is lowered, as the
+			 * swap path below does.  shmem_recalc_inode()
+			 * compensates for exactly that order - see the
+			 * comment on its `swapped > 0` clause - so calling it
+			 * after shmem_delete_from_page_cache() has already
+			 * dropped nrpages makes it count the page as freed
+			 * and hand a block back that nothing released.
+			 */
+			shmem_recalc_inode(inode, 0, 1);
+			shmem_delete_from_page_cache(folio,
+						     swp_to_radix_entry(mc_entry));
+			if (folio_test_dirty(folio))
+				folio_clear_dirty(folio);
+			/*
+			 * Leave the token on the folio.  The folio now has no
+			 * mapping and one reference, and shrink_folio_list()
+			 * only credits nr_reclaimed for a folio it frees on
+			 * its free_it: path.  Its recovery arm for exactly
+			 * this shape keys on page_swap_entry(), so without a
+			 * token the folio takes keep_locked, is dropped
+			 * unaccounted by move_folios_to_lru(), and direct
+			 * reclaim reports no progress for work it did - which
+			 * __alloc_pages_slowpath() counts toward OOM.
+			 *
+			 * The entry is owned by the page-cache xarray, not by
+			 * the folio: memcomp_do_store() was passed no
+			 * owner folio, so it carries MC_SHMEM rather than
+			 * MC_OWNER and the memcomp_invalidate_folio() that
+			 * arm performs drops nothing.  This is the same
+			 * handover memcomp_reserve() makes for anonymous
+			 * folios.
+			 */
+			folio->swap = mc_entry;
+			folio_unlock(folio);
+			return 0;
+		}
+	}
+
+try_swap:
+	/* This is the regular shmem fallback, not memcomp writeback. */
+#endif
 	if (!total_swap_pages)
 		goto redirty;
+#ifdef CONFIG_MEMCOMP
+	if (memcomp_attempted)
+		memcomp_count_normal_swap_fallback();
+#endif
 
 	/*
 	 * If CONFIG_THP_SWAP is not enabled, the large folio should be
@@ -1541,6 +1682,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 
 	swap = folio_alloc_swap(folio);
 	if (!swap.val) {
+#ifdef CONFIG_MEMCOMP
+		if (!memcomp_attempted && memcomp_available() &&
+		    !folio_test_large(folio)) {
+			memcomp_count_initial_compress();
+			goto try_memcomp;
+		}
+#endif
 		if (nr_pages > 1)
 			goto try_split;
 
@@ -1573,6 +1721,13 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 
 	mutex_unlock(&shmem_swaplist_mutex);
 	put_swap_folio(folio, swap);
+#ifdef CONFIG_MEMCOMP
+	if (!memcomp_attempted && memcomp_available() &&
+	    !folio_test_large(folio)) {
+		memcomp_count_initial_compress();
+		goto try_memcomp;
+	}
+#endif
 redirty:
 	folio_mark_dirty(folio);
 	if (wbc->for_reclaim)
@@ -2110,6 +2265,89 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 	if (is_poisoned_swp_entry(swap))
 		return -EIO;
+#ifdef CONFIG_MEMCOMP
+
+	if (is_memcomp_entry(swap)) {
+		struct memcomp_ref mc_ref = { };
+		unsigned long token = swp_offset(swap);
+
+		if (!shmem_confirm_swap(mapping, index, swap))
+			return -EEXIST;
+
+		if (shmem_inode_acct_blocks(inode, 1))
+			return -ENOSPC;
+
+		folio = shmem_alloc_folio(gfp, 0, info, index);
+		if (!folio) {
+			shmem_inode_unacct_blocks(inode, 1);
+			return -ENOMEM;
+		}
+		__folio_set_locked(folio);
+		__folio_set_swapbacked(folio);
+		nr_pages = folio_nr_pages(folio);
+
+		error = mem_cgroup_charge(folio, fault_mm, gfp & GFP_RECLAIM_MASK);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			return error;
+		}
+
+		/*
+		 * Allocation and memcg charge may reclaim or wait for OOM.
+		 * Pin only after both, then recheck the page-cache entry.
+		 */
+		if (token)
+			memcomp_load_folio_pin(token, &mc_ref);
+		if ((token && !mc_ref.slot) ||
+		    !shmem_confirm_swap(mapping, index, swap)) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			if (mc_ref.slot)
+				memcomp_load_folio_abort(&mc_ref);
+			return -EEXIST;
+		}
+
+		error = token ? memcomp_load_folio(&mc_ref, folio) :
+			memcomp_load_folio_zero(folio);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			if (!shmem_confirm_swap(mapping, index, swap))
+				error = -EEXIST;
+			memcomp_load_folio_abort(&mc_ref);
+			return error;
+		}
+
+		error = shmem_add_to_page_cache(folio, mapping, index,
+						swp_to_radix_entry(swap), gfp);
+		if (error) {
+			shmem_inode_unacct_blocks(inode, nr_pages);
+			folio_unlock(folio);
+			folio_put(folio);
+			memcomp_load_folio_abort(&mc_ref);
+			return error == -EEXIST ? -EEXIST : error;
+		}
+
+		shmem_recalc_inode(inode, 1, -1);
+
+		if (sgp == SGP_WRITE)
+			folio_mark_accessed(folio);
+
+		folio_mark_dirty(folio);
+		if (token)
+			memcomp_load_folio_commit(&mc_ref);
+		else
+			memcomp_invalidate_cache(0);
+		folio_add_lru(folio);
+
+		*foliop = folio;
+		return 0;
+	}
+#endif
 
 	si = get_swap_device(swap);
 	if (!si) {

