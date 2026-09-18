Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06ABC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3016B0099; Fri, 18 Sep 2026 14:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155846B009B; Fri, 18 Sep 2026 14:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CAF6B009D; Fri, 18 Sep 2026 14:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1A746B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:02:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FD9312078E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:58 +0000 (UTC)
X-FDA: 85227654036.08.6FB9CA9
Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8970C120006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XupSUF54;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754576;
	b=5u+Ux4mjOLxdGCw3RF9087w7/2XV7NIQKRSUp/cB85kYQQEyAWueVpeEu4c2GP8JhkPaZg
	PWBzU20Yyo/9anz/FiqqPL+KtHmoLQcXMS81NxAvo/hjCPJ0pTpIKqz//ssgvFvmbWXShm
	POVzlBXZ0GDs6XtfBF4R1FyULOd/qp0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XupSUF54;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.166 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKzNgqV0ZA0AZzF6ydZQcV12V6+MZv1Kiypu+ZDENgo=;
	b=cIKNK6KIy6QQ53ESynNx3ajYUPNK/VKz4F7eqSINIRPnVC1FrO6VIsSmgHj2XyJy67IGfZ
	tRAYeqZvEjef6u00bu4j026IU8YAArN32Q1TAaC449GLFfNhRffW9geUrKhHzvTYsRT/in
	HERLv27RE1XzHcOpzJ1PQjBcDcOnkbk=
Received: by mail-oo2-f38.google.com with SMTP id 006d021491bc7-6c901f4bfffso598604eaf.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754575; x=1790359375; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iKzNgqV0ZA0AZzF6ydZQcV12V6+MZv1Kiypu+ZDENgo=;
        b=XupSUF54cFUBhTZWiZ88qAaT2Ml8oJ2LzFK3ct5Pd/keAcMwKn4hIqmaeLGrhWejgZ
         wNjxAAEtp/JSkjEhSPs/QjdkQz0dJYPnHaw1mEhuOWsK1l58FUAZXE6kwkpW/JlH1Nju
         Km40cs6zrmKohOKlsKYOfS/vtke7IdtE5OUvRpQB9A8KS1tmNkbpQ3c+6e2uGCehVaEr
         SoM36s/peGGx8IKqipdac61W8A3hKCoMv4I6N0J4/+c2Oc202ViAUc3c7dylfb34iSJz
         m4EKPsnbu8R6tlwYvAn03EOyYBjnPBAK/Uz62ACzUJDhxfidtFCfKG1ylcd9AtTe/oIu
         MoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754575; x=1790359375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iKzNgqV0ZA0AZzF6ydZQcV12V6+MZv1Kiypu+ZDENgo=;
        b=1zO9Y/wLgDT2DgLNB/TBdfptgQXz4du2Wyt5neMNkpRDOMZdZg8P/wmfMTcslhqPDg
         qiYgDkxiq62yOVfIspDyQHnAmGt0ehdpfhRM6Sef2PWRJGQ31vyM9PlZ0OEp7O/o9SYy
         uliW3VKtu1Vkr+ABlXGc2A0m8oZShUPvVtBI7hFuv0LILxk0RiuB4zetlqIde4laRDuP
         DbmrQ7nfyrfLpHa60QQV3BUlIg1ELijFehhq1cCOiAPMpAT52RohRNOJcD7DnOK90j6C
         DNb2eFwv3wVy2HqqrDjdAf8JSeo0jFGUW1ijsCbmCkDTTO+T4h2hCZ810RZYCgpkQawo
         mPzQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwAdtzuSftpS+SKhiiWbA6ONBo6KkRpscvJFd0Fyprt9MMYgQGscepcUZv/VuLDrtA86R/yqndsQ==@kvack.org
X-Gm-Message-State: AFuF++mMuWS/kCDaB6UG4oHH/AJk0vGLKzxmQAYrVb5Q5BsZZ7x/Mu4L
	CC1uflCO3Agjstnx8idLIj6Cg1/yfRrB0N7WBZKuzYGeYvPgCwZDzBWo
X-Gm-Gg: AYBFou2j5eK+XkOrZ2Mjaox/Mr6WcDOZAyO0tTxC8sy7MuWbOWb4xbm/0FNOKoj9ifL
	L/pvKNAE5B0p1lkjhnCU2m+3F6PZNu+t8Yok0meIu7q7pkPyDBe0tN4dCKamgtKZk6w7/GCM0Pk
	0sJyQsa6xAtJw105l71VfTH76iGY92Ly6nokHK6utc/fBwuP0rhqdtbXaNUEfCw+TqhOGp2eDmL
	0EFcQigIAshcmbqCDhIAd5QRtoWY8A5YGE32PwpxJoa/BQnL7BDHLjh2mCYIHF7GjFO7NMKw98Z
	IyEnaT2qUtaeckJKTi9+MK+Rk5/wFHEKTnSom1QQ/BpE/Y7CWmihvh3l4PJZLS1Oy7pFTTGC2Et
	4HfTE06uqgYyV8QZn/2W3QrYrPxn9aq7GO2jfidAy02/75OcgyYgeOGLnhle+XHerObOcH0LW5O
	h11RTq6wFvtjj4RDmeK6VopPYtUCEjiVXGpqkE/ATKhvexSF3DTEZ7A4dPzNrjRJdBHIS1YBKk9
	37P0u6HPJIfv30JpouCfw==
X-Received: by 2002:a05:6820:190d:b0:6cd:3fbd:1d5f with SMTP id 006d021491bc7-6cd3fbd2951mr340212eaf.73.1789754575416;
        Fri, 18 Sep 2026 11:02:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:12::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6cd34b35d71sm522300eaf.7.2026.09.18.11.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:54 -0700 (PDT)
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
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Fri, 18 Sep 2026 11:02:37 -0700
Message-ID: <20260918180241.3424851-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8970C120006
X-Rspam-User: 
X-Stat-Signature: 4ujh51i5wgnqr3d6c9rkajqyfqhajmhp
X-HE-Tag: 1789754576-606842
X-HE-Meta: U2FsdGVkX191W2+1UJmCJKUZuOhmwhbq3ktpuKl9lWnDJvl1SDiEK7/MOemy2f55KpAGib9kEkCCAlPNXgB3Ddmwcad93qmpoeV45YSEx2uEGkgq5E7vXRzmivFR+qGQvZa66T+wlM9FCHvBMRa0U4u4uMB9PYFtVVfcOHYE9m5BuNCFy+38NCrJGf5v0rwcgU3uF6qsrIAMuk/caMkE0D/Zukz7jj8T6GORpG3aWhIKqnB62hmhwYKh2ydzTRHfb9VD70ITYWWA+yrSUXzYHEzV2r95ZQe5pSlYVtKtaR6A4ORZJplDy2VKSjtGP1Pt+mXpZ6UeEscoZWqjAFnlsGv57pjffXxRKAdeDCQLOsFs5Bnxirgx+97Qiy4tW8PDbNZLRVWcGAsZrZH2K3MQxgWopkeH2lPNZCk2dZkLPEWbgpSDTF4XRObkAFIWwilKuE2LjlRPV9h8c7aeeKmXfMOKUm2j6SW72UZs4+oCowAflpKcRIzFsiWCScGoNGCIV1w9d2+o8AQ8o1UIMVEqX0HoAI/tZVlmeWjz/S40O2yVWZLxOzL61pj3veLgwIFu+8myCmfyikI14bo/dHKswowgRXKDZ4OwI17PBR8fZyStNJWWIIo08XLFKGo1zJIZI/bkg22vhFR39tHTHVepvyeGm5WNs9wcTjxKmRVZ8RErW0CdXiel3Qj47jzrh6iJKem/6Nus5g8WFtKbFSCI3PX+HA/VFvFx17U9h+/B0Li2DfT2Xbmmzv0HTfjpImSuwC6AMkLHVf5FgyIQkdzc1A9tA0sYDkWn3HPBd9aW9sIzaVhFzh9FgiZGdD+ihdDERQKxj/VlGhBE7Z/pFLQPQSinU/mZ17MH1oi+UF7NUJxAGUzEk3d8VHAvw+0wMpTV00V/qb8JfG8bNR7qx/BZGD08HJC/li4YBX4pcQN2I+pCfejuBbLXApdQufEtwtSb0SQoOeu00+mIzmHBxw/
 BA8x4Iki
 MHiJMyWzgrLQOiJ7NxC/KTvbPV/HCFRgWYl2IqbIrGMpyXTGOJzsCmNx4Z5HPwSRQFh/dFxEhMmkrc2UE93V/c5eirz1tcqRO95uYHpWrG5GyLahVqZOSNdokso9tPKBz/ccl099xhUS+dRqvro8HJXg8JbDiA1wZ+XRw2DqXe3QDi9ztw3BUHCnqqe+AJL9DcjdtkO8z5yBnlckVrc+Ei3n9uINgPYbKI+OlDOfyL5jRorG757L4jKltZ+WRf1sfQvJoD3u6HuTIR7t0T1u/fp+GjU3lDTf02o0LVgzBUk1lDmxDIan6jhDmjgFZPZlEo28xXhW8PUhtvgkU8svsacAFXzyQhsZeM6mg+aFpLpWBRzQUtFMINp7cQubn4Ruf4c/HgGpaauO8aj5cq1xVA44pARlAbPUcOC+wGKM9ZIBBxay5Awp/WS+WMmdycs4fldncdb2kH1eQ0tTJ9xon7WfOHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a vswap entry's swap_count drops to 0 while its folio is still in
the swap cache, the entry is cache-only and its physical slot is
redundant. swap_put_entries_direct() tries to reclaim it at put time, but
folio_put_swap() does not, and even the direct route can come back empty:
the folio may be under the writeback that allocated the slot, its trylock
may be lost, it may still be mapped, or swap_only_has_cache() may be false
on a partial run. Nothing retried afterwards, so the slot stayed pinned.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations. Reclaim goes through folio_free_swap(), which ends in
folio_set_dirty(), so a reclaimed slot costs a re-swapout if the folio is
dropped again.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  12 +++--
 mm/swapfile.c   | 117 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  31 +++++++++++++
 3 files changed, 156 insertions(+), 4 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 7d094694ec37..79f06642a553 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -31,7 +31,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |-------- vswap offset --------|100| - vswap rmap
+ * Pointer:  |C|------- vswap offset -------|100| - vswap rmap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -399,14 +399,18 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
  * On physical clusters, a Pointer-tagged entry stores the offset of the
  * vswap entry that owns this physical slot (the reverse map). Only the
  * offset is stored; the swap type is implicit (always vswap_si->type,
- * since there is exactly one vswap device).
+ * since there is exactly one vswap device). The top bit is reserved as
+ * a cache-only flag, set when vswap swap_count drops to 0 but the folio
+ * is still in swap cache.
  *
- *   Pointer:  |---- vswap offset ----|100|
+ *   Pointer:  |C|---- vswap offset ----|100|
+ *              C = SWP_RMAP_CACHE_ONLY (the top bit)
  */
 #define SWP_TB_PTR_MARK_BITS	3
 #define SWP_TB_PTR_MARK		0b100UL
 #define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_PTR_MARK_MASK))
 
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 13d2ae60fe4c..2efb47b4cc4f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -142,6 +142,11 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
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
@@ -874,6 +879,55 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
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
@@ -1155,6 +1209,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1179,6 +1234,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+			} else if (swp_tb_is_pointer(swp_tb) &&
+				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
+				vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
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
@@ -1749,6 +1817,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1855,6 +1925,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	if (swap_is_vswap(si))
+		vswap_clear_cache_only(ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -2004,6 +2076,51 @@ int folio_alloc_swap(struct folio *folio)
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
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
 					     unsigned int ci_start,
diff --git a/mm/vswap.h b/mm/vswap.h
index 6f952b2591d1..b79866d5999c 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -44,6 +44,37 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
+/*
+ * Rmap cache-only helpers for physical cluster Pointer-tagged entries.
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


