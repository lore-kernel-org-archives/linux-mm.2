Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4A8606A329
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JORs2xfg
Received: by kanga.kvack.org (Postfix)
	id D73BD6B060A; Wed, 21 Oct 2026 02:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C881C6B060C; Wed, 21 Oct 2026 02:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01A66B060D; Wed, 21 Oct 2026 02:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 745336B060A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6652C402E9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:51 +0000 (UTC)
X-FDA: 85345592262.05.CF680B0
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F95E140004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JORs2xfg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9sAzGLg/w6ld0X6rea65eNki+SZx/1duzekqGZ4zFk=;
	b=ywvML/8kMbzKqahuGe9Vcd7skSGbUQO+v/3HpL92Z6ywmMdN+atUo6hSBsXh4DnqKKn5ek
	QFYVixbzuTDlId5GHR3WNi+1VJZTzR/GvC99bd5oTL+g9TddRNijmxVc+7Eh+BKGwR757X
	frQI8PXhVHTxevCqDVAfPttxjfL5FN0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JORs2xfg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562629;
	b=zyWDNb3cYm8VH4XwDn58skIYhPNvf87KJRELkUvJUJrdTR4sQhjSCzs0BMAyV+U09bF1UB
	TBVKZ9V+lztEwrvSOXQyr6aBW1wrsd7djNZWH8Kt774XtmHetzj0AGBUSrNc3GkDtsVgL/
	P4FUb9G8rAUevZYf2LWnQLQQ9WGl/Vs=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b0f59a5fdeso3365387b3.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562629; x=1793167429; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9sAzGLg/w6ld0X6rea65eNki+SZx/1duzekqGZ4zFk=;
        b=JORs2xfg6hkV7vu50X4GuINQmRFJMLeOnZM7WTa0JkZxCEExw2ClL4/SNEEXPnXWhs
         EQUoD4TblzzhhWgPJQUgBL9HMwUHtwC5luUYBZvLtDiWMIi8ob9XBK7L7cgu5cpzd/LJ
         vNLZ67lY/4IOzgwRtH0WSLB2liy2n2Tm4oYLSnN2jNOagN4EG6chaI6N9CCpP0g9zJCU
         GeDKoZRSHXk5s1SkdpA14MbpCEEp73LG45LWePBz9/nCVZgLeRf8aKZmLdI1J7ELSKGq
         eeLgDNFiUudaUefY6kQdIkPoQUdiTocAOP1VKmAahYFN+4K3QJyuRmnPb7Iop4FO6hZI
         TQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562629; x=1793167429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v9sAzGLg/w6ld0X6rea65eNki+SZx/1duzekqGZ4zFk=;
        b=cUOC0Q4p7uHMX9g4LWHQPzT2ZKDuCfnPV5zsOHgumcMzzVh8w5faNzrYPb+pciL6Oj
         54fGo7qmZFePepJ2uyDViZQNmCoaKeTpe2KE9lWX28S7uZBQbkkSQcRDhNFFzZkWZiGc
         ba7KkktIC/HzWsUeIx/t9Pnx+bIPKYyKy3lzjOl7oSr+dCx6LvsHC3hg9XXH6NjWqzEL
         KZtc0zyoIC5uRniMIPZ4u15hflD7nEOZwxBCOABw68/a+6YtRmPDOdoT81VH4CjtWBew
         ADAcfeX+qMk+JkL6EgSMadeylfLdn4y9OqyXUl3Si78jxPE/GfcheppkhXmD+Uzj9959
         PYkg==
X-Forwarded-Encrypted: i=1; AKwUvBwDaNMV6zX+ITglHcBgKT0d9wsY6ya4UM0Tvjbmht8vkI3oeYsv4q8B6b8hooXcZrYXc0ZkoVSvIw==@kvack.org
X-Gm-Message-State: AFq9FYLUrJqFaU6e4fLkVxFLgJRLrh2WNEugVHLR2e9e0/lykZQDVwxE
	3S+dm/UQcuW98MV0TEhvjwuqd12cgjSPKXbM1Ihh0H3FnguoENavKxnM
X-Gm-Gg: AYBFou29aaf82XMEjmF/bRLedQD6PCJEXVjov6ZHINjHoAHekj8jj9HgdVYUeeG30Rk
	neErZQBClRPQZuWGjWEsaF7ZgtAceUgliQrG76IUVLcI0SwD3iwLZl1SgfcR2jRCd65Vv6DavaW
	xHXANUB4z9411aE2KRDsQ/KPDYtljmh9hmiyXtQw0yswCWF/ye/QRlMirpkO3tPgaYD0R2Cp5PI
	WzdnWpWUMAXx4LS/B9NTNjB3xqPt+IucAzJgxBnx+20iPnJjmWvjRNq0A80yZfjUCc/9RGZv50s
	5B/g0JvjDWSbz0PbBYgKhHZDlZFSu9GFJ9aKLCIzCn2baKWLa9AeAcNqGCwtF6jaG3wRxFxfiLE
	YkB+l5RsEbBQy0ENfq7MthTSm2hrSf6csoprmbHIrgEZEX3VN0EP9dxX26cFEgSb81FcngVaUwJ
	ry6fxz5harrqJZupUu9awufJafeOm1CoLCw3ciI90/toAEQpySL+XamqTEBpkwmnDrgZPJbmq01
	lMStb5NPmSzldXFeLhwEEN3PimxEGVEGzRJJ0lAPr/IQ5RU3rcxXLqCRXiApRgin89S/39/5Aic
	R4frEvrzDjmo4ITwkFQyhbyZKv8S/yi6CSGUWPtPjibQ1J7Pe+DdOKNEJVVSCuA=
X-Received: by 2002:a05:690c:c4e9:b0:854:b86b:d206 with SMTP id 00721157ae682-8b133c87ee5mr5494447b3.12.1792562628567;
        Tue, 20 Oct 2026 23:03:48 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b13016fce2sm7251347b3.40.2026.10.20.23.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:47 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 07/12] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Tue, 20 Oct 2026 23:03:18 -0700
Message-ID: <20261021060323.553433-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F95E140004
X-Stat-Signature: oh85egj38b9mbmzsdnp7qshtbb5tb6ku
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562629-286649
X-HE-Meta: U2FsdGVkX1/+Ge/UCWPPWluii4/uZua9JjQOdw+Of+iQid1Mj9ePNP9jGUofMOyviK6AdguSN9tXxb1jbxxY6L+aDPEdS636JXth5DnU+J2/DsqJd8Fj0sA3vMb27je2ae5WjHcPGegmHW1TdJd0pRX53TDDIQbvUgxi9LLRXfmsNI8oeiy475aARcq7ax7Cyi5ehy43L3eGLfzJx/pas60G+Jr+kqGWDBUncZR16vdOaj85pNmN1YMUnS9f0x3ABguz5O0aOxBxi6QwHUUaqevoohG2+3kIv4N6hIE69SoYxnvWEZYDl9D6CYFXXFo3WqCMB274xqrBwPrCueyjME6vAAZkk5oCSc92ZGaETgWA1KBZuedxjKP5tM8+acVuAF0bABZ/8DtwNiMTjCRcIS6lnzdTA/WLv71wNToaZ9da8RVPUKLZLV4/CylYIa2XUSRtMWInEpRak/A4OzQl4Twg59X8NkPbcDGyD5mfWZXenx3QIgnhDuaJ8+LiKslpf0N6rLerSQSofwrhAruHLD8/8IzJzzwwjF6BSlrrVscsCroaU1Z8QOdmga5mnxuce1lePO7tm12FpCRdy8c5zSylXXa9N7OIgqyAjHMVkcv7uhtGPFMoYdW/FGRloLHi/dN50CzWk2h3HSoi4yucGbWKhPWFSqHHgPHV2XnAzGCyFjApM4IBw0xW6BiHzBd5VNa+DUF4+peF25HRK5ifgoxYlGIh/YYyviljWtz08O18Kl8TI4rdZ0PWPd5vXdkC6EeRrnSQGZG33nJZjqWWJ4bQyyX9FhMgFz5GcC2vIZB+ddcAbo+NuE3TTqNrkiHw/7nBkuVsTyRKWSy/MmOjDTy6hvStiZ0iiKW7Wkr0OwqwtLYIb5b9rrqYsPHQ3vvtfc360RWezvfSEUodLdc0MSsVopoiZ+7u6/ehhal89HYGRgfnXvLG7UCDBFR1qY4bIEu4EXSgU1NqiKnOTkv
 1/jJ7Ffp
 PX256fml1MNjMMSj2y4TVMMaOG58Ecn1LIo0UZKzzEg/NIQQyaXtQmv0s2bf7Jw4DJbYaf2UbLHL+8Ibt+scRE0V9U/99VG9WMIGRk26UG5wGu0yMQU6ChAwqZHoR/Y+y1flTUKvvVpw5k1ELfyN2+H9GRT4iGfnk2gntnaEcDVmQG2w2NuWtNz6eQV9v0ABdQBvokfhLhGac6n9LQHj4WnCupuiDDw373eYFFMgo0YtrrS9mHHgzYhon3DP7xAizRdz8IPVcTql4lAWL8zbWW5c/LQ8lGD3okPoicKGOFeAamVe3HBvWvf9jl+OgBTJpIFqS7FktirS6v76ZXOR1KOTmyw9nYnGyRKxrWA5nrbqo+7d3BdKYtvHXUT8NdzZDCHitl/GyrQpX92qbaSCKwRxIJy1Ko2uMchwYZvUs90vBD5UFlpyMcQOoszBVhZw8IYZjWvCB4ix3C9QxFr3UiZArDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A vswap folio can keep physical swapfile space after its swap count
reaches zero, even though its data remains in the swap cache. That space
is often scarce and valuable: retaining redundant backing leaves less
capacity for pages that need it. Put-time reclaim is best-effort and
does not reliably recover these slots.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  12 +++--
 mm/swapfile.c   | 117 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  31 +++++++++++++
 3 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index a5e65ddbd2f8..88d1bb0e65fd 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -31,7 +31,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Vswap:    |-------- vswap offset --------|100| - vswap rmap
+ * Vswap:    |C|------- vswap offset -------|100| - vswap rmap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -399,14 +399,18 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
  * On physical clusters, a Vswap-tagged entry stores the offset of the
  * vswap entry that owns this physical slot (the reverse map). Only the
  * offset is stored; the swap type is implicit (always vswap_si->type,
- * since there is exactly one vswap device).
+ * since there is exactly one vswap device). The top bit is reserved as
+ * a cache-only flag, set when vswap swap_count drops to 0 but the folio
+ * is still in swap cache.
  *
- *   Vswap:    |---- vswap offset ----|100|
+ *   Vswap:    |C|---- vswap offset ----|100|
+ *              C = SWP_RMAP_CACHE_ONLY (the top bit)
  */
 #define SWP_TB_VSWAP_MARK_BITS	3
 #define SWP_TB_VSWAP_MARK	0b100UL
 #define SWP_TB_VSWAP_MARK_MASK	((1UL << SWP_TB_VSWAP_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_VSWAP_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_VSWAP_MARK_MASK))
 
 static inline bool swp_tb_is_vswap(unsigned long swp_tb)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index be66ac79313c..640e38a55497 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -145,6 +145,11 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int ci_off);
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr);
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -877,6 +882,55 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Vswap-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns the backing folio's
+ * page count, negated if the slots could not be reclaimed, or 0 if the
+ * folio could not be shown to own @offset (i.e. there is a race).
+ */
+static int try_to_reclaim_vswap_backing(struct swap_info_struct *si,
+					unsigned long offset,
+					swp_entry_t vswap_entry)
+{
+	swp_entry_t phys_base;
+	struct folio *folio;
+	unsigned int i;
+	int ret;
+
+	folio = swap_cache_get_folio(vswap_entry);
+	if (!folio)
+		return 0;
+
+	if (!folio_trylock(folio)) {
+		/* Unvalidated: the folio may not even own @offset. */
+		folio_put(folio);
+		return 0;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	i = vswap_entry.val - folio->swap.val;
+	phys_base = vswap_to_phys(folio->swap);
+	if (!phys_base.val || swp_type(phys_base) != si->type ||
+	    swp_offset(phys_base) + i != offset) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	/* The run is ours: skip it all, whether or not the free succeeds. */
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -ret;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -1158,6 +1212,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1182,6 +1237,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+			} else if (swp_tb_is_vswap(swp_tb) &&
+				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
+				vswap_entry = swp_tb_vswap_to_swp_entry(swp_tb);
+				spin_unlock(&ci->lock);
+				nr_reclaim = try_to_reclaim_vswap_backing(si, offset,
+									  vswap_entry);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
+					continue;
+				}
 			}
 			offset++;
 		}
@@ -1752,6 +1820,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1858,6 +1928,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	if (swap_is_vswap(si))
+		vswap_clear_cache_only(ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -2008,6 +2080,51 @@ int folio_alloc_swap(struct folio *folio)
 	return order ? -E2BIG : -ENOMEM;
 }
 
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int ci_off)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	swp_entry_t phys;
+	unsigned long vt;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	vt = __vtable_get(ci_dyn, ci_off);
+
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
+/*
+ * Clear the cache-only rmap hint for entries re-referenced from count 0 to 1
+ * (no longer reclaimable), so the physical reclaim scanner skips them.
+ */
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	unsigned long swp_tb, vt;
+	swp_entry_t phys;
+	unsigned int off;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	for (off = ci_start; off < ci_start + nr; off++) {
+		swp_tb = __swap_table_get(ci, off);
+		if (!swp_tb_is_folio(swp_tb) || swp_tb_get_count(swp_tb) != 1)
+			continue;
+		vt = __vtable_get(ci_dyn, off);
+		if (vtable_type(vt) != VSWAP_SWAPFILE)
+			continue;
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_clear_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
 /**
  * __vswap_release_backing - release the backing of a range of vtable slots
  * @ci: the locked vswap cluster
diff --git a/mm/vswap.h b/mm/vswap.h
index 6f952b2591d1..fe2068d85b65 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -44,6 +44,37 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
+/*
+ * Rmap cache-only helpers for physical cluster Vswap-tagged entries.
+ * SWP_RMAP_CACHE_ONLY records, inline on the physical swap_table entry,
+ * that the backing vswap entry has swap_count == 0 (swap-cache-only, so
+ * reclaimable). The physical reclaim scanner reads it directly instead of
+ * chasing the rmap into the vswap layer and paying the cluster-lookup
+ * indirection.
+ *
+ * Callers hold the vswap cluster lock, not the physical one. The rmap is
+ * only touched while the vtable holds the slot as SWAPFILE, and that
+ * window is opened and closed under the vswap cluster lock, so the
+ * allocator has finished writing the entry by then.
+ */
+static inline void swap_rmap_mark_cache_only(struct swap_cluster_info *ci,
+					     unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_protected(ci->table, true);
+	atomic_long_or(SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
+					      unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_protected(ci->table, true);
+	atomic_long_and(~SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
 /*
  * Virtual table entry encoding for vswap clusters.
  *
-- 
2.53.0-Meta


