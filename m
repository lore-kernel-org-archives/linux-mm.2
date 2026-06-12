Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70205CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860676B0096; Fri, 12 Jun 2026 15:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D0D6B0098; Fri, 12 Jun 2026 15:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5518B6B0099; Fri, 12 Jun 2026 15:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA396B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFD68401A3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:51 +0000 (UTC)
X-FDA: 84872270742.27.B5732FE
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A2578000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r1E6P5Nl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9s95lWNsssGrexKzc5Gk3WQ7Nfn1S6PBNhKxMACOqk=;
	b=tXfJABAykLudyCDhG9len6k/eqFPJ5bhfh6Xn78Hkfmj5PpcumZ0TiFMBMta/Ip0CX0vur
	QQylwW/rmPFVOuy4GrY87tD4teXyHFTze3w6vyeUzDS04vRQRoNfZwPEqHtfCU0O5jxvsi
	BO5fxx68j1lFY4R6gHOzyeBIOPDC/Ak=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r1E6P5Nl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293070;
	b=HcacD2qptX7MORtemEH/OYI4tIUg3rbbXngqyJwr9LGceC4169McSMiX7GbwELMSNf9V6t
	LLzy6WRrtcO7EGFg+Am9onsNRQiWxWH/FI/QKLq2Y2oQsJcvqF+R4zJEn9pOitJzM1O3yS
	DknH5xHiABpwBgfQiw4CHgV9QUbDfb0=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6cfdc8382so1038631a34.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293069; x=1781897869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A9s95lWNsssGrexKzc5Gk3WQ7Nfn1S6PBNhKxMACOqk=;
        b=r1E6P5NlvA52QOoJD80OLNn2lxrZ/Pc6CuOr2VvqWm3pHkXMQ4YOYMpTdICKoWC3Ri
         Kx20IgaJUqss3tpT0B+sSoucFZ0HFQwKIKd3N4N38J3p6d8yuF4krEHHmMYELmYE0/Tg
         ZmS0MfM53VmPzZ52cEy3eEWjbNyMZe51eGG2Y3yQOSKIMgTtPFgtgbqM3lBFyaKizDcv
         +SYdBBz65+PsyEyeALccxKbfaXR6EXPSTtArvHTucGaVovmOw1K2TLv93+YpqwbrQXkz
         8K1uLxkQ6h1qXS+1YC7xTt25nNsUwQXYYlCuZMoUEVyQoZL4LISIrKwLf6DHnrp8g+Vp
         oS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293069; x=1781897869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A9s95lWNsssGrexKzc5Gk3WQ7Nfn1S6PBNhKxMACOqk=;
        b=NH/woN0pi97kEs+LzeEeaLnDR0PsxsS/o5hoPextjQGaBhBMkQjK8n2jH2aAT6p+6M
         WRza1UMpkbEeNJkI8gOO59VIus5GU4loL0LzaqiqRtnLvbdof7UMwFeteDFge+P6K3Yg
         qazLhenV+1UvJOwulntVU898S3HcOSpnezdd2rVzp3iua2ZhZG+V3jhcP3PuTAy0kSC5
         amY5jd0tk31xeQM1UhJEQ8Qb2EyaWkTLqCSu45WSGRMOCfccNJKgocASG4tLrwWvxYMd
         bra7MunKL0jT77+NCnvRIviN2HBU3edXuk5n9jluMEoS6P+EMRZ0xk898m2tXhjxhusY
         00hg==
X-Forwarded-Encrypted: i=1; AFNElJ82mTiS6QqH3BX+CEzxYJ4JlNVRnqBMd88NoaxdKPLfWNCrbMFhM2J1txdnSj8ooxqNm4woHZ5pNQ==@kvack.org
X-Gm-Message-State: AOJu0YzvdY7UYQiSTMdoGoXH+oAkNSh2bBOD0A/hhcR3A956p6Le6AV+
	o6+/1/2p8X6xKWAt1w6JqXrf1BkmGdk1WuJi7IgYsPi3JjzD8t0nLdPK
X-Gm-Gg: Acq92OGS9HLWxLegOp+E5jVqWGdR0Q/pLfVpgSQo4zYbgT7qSjGN5hxsKTUqVTS9yol
	H7ab6j8RdqEEz/LScVPhumg1kOqUFiOl+FNqplnCcfNsjOWLc4mdLo3XZ6fwXC9q8MrUWBxRDMn
	9Q5WGJTqe+Lr8hWUb+Ll/99J+3ransUBCs6b34V8O96lvW3KkaqE3LZxO2kOrQRhRIQZt3uvFYG
	cS44R/XLBm8CZsdoUdhK8GjPB5Lt733T8QpITQuS0rNKL0pvPO+87BBtCWiIkgZ8ceXjPioX0GG
	0E0++3N75Xnfq1Ktd8Ry4okVVBNrNrW3uXAODHKqh50X6xKH3RGAKpftPi+WSdwNJGNO+fKOoUs
	OE6a1rZhAhpspzTH5sNodKsCaMofjlWeW7H0AnLWRub93ju3eE7pt3tIMdMViEWj2yR2emizp0k
	vwj33CDLypPfaCyMVuqTlnBAvBbbLw5XFaBlQNxsSb+EUgbQ==
X-Received: by 2002:a05:6830:8389:b0:7dd:b184:1338 with SMTP id 46e09a7af769-7e784746779mr3206503a34.6.1781293069064;
        Fri, 12 Jun 2026 12:37:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781444b81sm2573874a34.4.2026.06.12.12.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:48 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 4/7] mm, swap: only charge physical swap entries
Date: Fri, 12 Jun 2026 12:37:35 -0700
Message-ID: <20260612193738.2183968-5-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A2578000C
X-Stat-Signature: n8ic48cjgd3wyt57twxenhxp7nx8yoh5
X-HE-Tag: 1781293069-646971
X-HE-Meta: U2FsdGVkX1/eNUWDAnXyqck9cfEOm25I8gMZHRDJkgYmDr/YUK97NaqvusDP5berT0SsJyWVdXjQF2Y6VXzweuoIT3QyqtFzz6f04Sb4DVKg/RwBrCjA6c+Z9z0wmv0WHeEqr6HDynulQKewQLDhWE2HeFkB+b5qHz2xbmqRFxV/r4fIyKFw7xugTqjzyzoQwD7Fl97GdQQSkSZhlFl2DV582kkSjfB/H52BtMhBCl3/8Htpjb28lqOLprjw2FZ/3AnQZNBxzA0QoHN88K/NZ8KOeS2Q2mxlqfiH9oQvtQ277guVkQwubIkD6pdrKTkfTesyvh4DI/FyT4XfxzE2QXxl2UZsqk0Jx1PCf5J2aYje17SzBw2HoWn4HQKQ0zW8FZ6yTFyHEdMct042bewMLk80mjcvDq8Bz0gqX2ybHrC4DGFdV301y/klV8kFlQzxkes2PtOzsRGvnmkrraNVAAMZfYbDoov600JFoSb1+O7ZC8GxAJJVAIoMxJmeqWx0rtYWkw/X7eZrNPPG6mkRRQHJQOfDe8qDm/z0rvnn90trpHsC+bOzpYbodIEaAH+pheciSKPsnTtsLzP32nTPotkON1GfyF3FRfv6eoBJmJIGUpEt0wJaCQSj8BYEq3qPo6CwC3XHRUDJFYA/lHjgykGLSwTPnBWDc8onZ94vLmjcrmOyinfw2gmmrtW2JlkPi6UxKba94E3SSDHw700XhZtE4ovWHxZDJLgoT/i98ZdkctNMtR+lg/DvsZWe+6FVh8VGWb2mtbp7sRg/eInVxiAMMPNuQ+aIh7gbQgwz617sl9EobB/o3auAl+fOC7jbDwHDRn96Nz7TvM96opvzTijwdfM46Xbqp4tKpJNeK6yG7jmAmJAIXawFEiq7oeSRJuBrKwx2RjAIMwUcCJxI8uKG8pqaOFek8N+IKy79cDlbF669vXN1yvvV6i7E/vm78f7NisOq5ZdDYqBS2zc
 t4CIrBJE
 sYe4OQmDYT5QZOWflsgfBQPNueG+QlTSxdpPOx/wRlZvwPtlRELKWU0xCYh57/fyrfM0lZggWDQjEe4uRewpkUkWcODeQKeMuopTz3NXMqobH8P6p9/xbJS4pB7itzqW5vGEWIxnnZuviiBP5DjlOUxHzaTn48S/vVPwOjrO92u6YN7BLEub6kitFtRjqDy14SJVFV0CXIHglRHz9UHTTx1DPMttK9GmsDdgNwb0pi4KOCDBXzE2xgftLNHB0loi+WCqHoTfkIQJKFyd2kSXGJgO8/CEZdCcEofNtodI1zdN3tNqT37XvGiQE7u3IP+maaCWvmdjvCxNVnMW6pNtlnNoTYmhDvx3hYO4ia2M0fMIXwtoQ6RmRdJXO+7pgQIboe7ug5Tmf5dMkKt5uRPsMiQ3fZ0fYwXiYTmv1vpGkVTgxvsodUS0+vtpvDPcK9QpHNLCfLxTOz5bXP1Vaz3+mWlkE8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Defer the memcg->swap charge for vswap entries from vswap
allocation time to physical-backing allocation time, so
memcg->swap reflects actual on-disk swap usage rather than
virtual swap reservations. Previously, vswap entries were
charged at allocation via mem_cgroup_try_charge_swap regardless
of whether they ever acquired physical backing (zswap and zero
pages do not consume physical swap space).

Split the lifecycle into four operations: record the memcg
private ID at vswap alloc without charging; charge memcg->swap
only when physical backing is allocated via folio_realloc_swap;
uncharge in __vswap_release_backing (only nr_swapfile entries on
v2, all nr on v1 memsw); and drop the ID ref at
__swap_cluster_free_entries without uncharging.

Direct-mapped physical swap charging is unchanged.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/memcontrol.h |   5 ++
 include/linux/swap.h       |  57 +++++++++++++
 mm/memcontrol.c            | 166 +++++++++++++++++++++++++++++++++----
 mm/swapfile.c              | 123 ++++++++++++++++++++++-----
 4 files changed, 313 insertions(+), 38 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..3e3a3619ae7d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1846,6 +1846,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
@@ -1854,6 +1855,10 @@ static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
 }
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg, bool may_flush)
+{
+	return true;
+}
 static inline void obj_cgroup_charge_zswap(struct obj_cgroup *objcg,
 					   size_t size)
 {
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5162404770bb..2d6bc4cb442f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -595,6 +595,43 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return __mem_cgroup_try_charge_swap(folio);
 }
 
+extern void __mem_cgroup_record_swap(struct folio *folio);
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_record_swap(folio);
+}
+
+extern int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					 unsigned int nr_pages);
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					      unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return 0;
+	return __mem_cgroup_charge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+					    unsigned int nr_pages);
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+						 unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_backing_phys_swap(memcg, nr_pages);
+}
+
+extern void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages);
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_id_put_swap(id, nr_pages);
+}
+
 extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages);
 static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
@@ -611,6 +648,26 @@ static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+static inline void mem_cgroup_record_swap(struct folio *folio)
+{
+}
+
+static inline int mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+					      unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+						 unsigned int nr_pages)
+{
+}
+
+static inline void mem_cgroup_id_put_swap(unsigned short id,
+					  unsigned int nr_pages)
+{
+}
+
 static inline void mem_cgroup_uncharge_swap(unsigned short id,
 					    unsigned int nr_pages)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..61c322b2e8b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -48,6 +48,7 @@
 #include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/swapops.h>
+#include <linux/zswap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/seq_file.h>
@@ -5623,6 +5624,116 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	return 0;
 }
 
+/**
+ * __mem_cgroup_record_swap - record memcg for swap without charging
+ * @folio: folio being added to swap
+ *
+ * Pin the memcg private ID ref and record it in the swap cgroup table
+ * without charging memcg->swap; the charge is deferred to physical-backing
+ * allocation (vswap).
+ */
+void __mem_cgroup_record_swap(struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
+
+	if (do_memsw_account())
+		return;
+
+	objcg = folio_objcg(folio);
+	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
+	if (!objcg)
+		return;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	if (!folio_test_swapcache(folio)) {
+		rcu_read_unlock();
+		return;
+	}
+
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	rcu_read_unlock();
+
+	ci = swap_cluster_get_and_lock(folio);
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
+			  mem_cgroup_private_id(memcg));
+	swap_cluster_unlock(ci);
+}
+
+/**
+ * __mem_cgroup_charge_backing_phys_swap - charge memcg->swap counter only
+ * @memcg: the mem_cgroup to charge (may be NULL)
+ * @nr_pages: number of physical swap pages to charge
+ *
+ * Charge the swap counter when a vswap entry gains physical backing. The
+ * private ID ref is already held (pinned by __mem_cgroup_record_swap() at
+ * vswap allocation), so this only moves the counter.
+ *
+ * Returns 0 on success, -ENOMEM on failure.
+ */
+int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
+				  unsigned int nr_pages)
+{
+	struct page_counter *counter;
+
+	if (do_memsw_account())
+		return 0;
+	if (!memcg)
+		return 0;
+
+	if (!mem_cgroup_is_root(memcg) &&
+	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+		return -ENOMEM;
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	return 0;
+}
+
+/**
+ * __mem_cgroup_uncharge_backing_phys_swap - uncharge memcg->swap counter only
+ * @memcg: the mem_cgroup to uncharge (may be NULL)
+ * @nr_pages: number of physical swap pages to uncharge
+ *
+ * Uncharge the swap counter when physical backing is released. The private
+ * ID ref is dropped separately via __mem_cgroup_id_put_swap() when the
+ * vswap entry is freed.
+ */
+void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
+				     unsigned int nr_pages)
+{
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
+	}
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+}
+
+/**
+ * __mem_cgroup_id_put_swap - drop memcg private ID ref without uncharging
+ * @id: cgroup private id
+ * @nr_pages: number of refs to drop
+ */
+void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	if (memcg)
+		mem_cgroup_private_id_put(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_uncharge_swap - uncharge swap space
  * @id: cgroup id to uncharge
@@ -5649,8 +5760,21 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages = get_nr_swap_pages();
+	long nr_swap_pages;
 
+	/*
+	 * vswap charges only physical backing (folio_realloc_swap), not
+	 * allocation. For a zswap-capable memcg virtual swap is unbounded, so
+	 * the swap.max walk below would underestimate it and starve anon
+	 * reclaim; report unbounded. swap.max is still enforced at
+	 * phys-backing charge time.
+	 */
+	if (IS_ENABLED(CONFIG_VSWAP) && zswap_is_enabled() &&
+	    (mem_cgroup_disabled() || do_memsw_account() ||
+	     mem_cgroup_may_zswap(memcg, false)))
+		return PAGE_COUNTER_MAX;
+
+	nr_swap_pages = get_nr_swap_pages();
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
@@ -5822,8 +5946,10 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup hierarchy can zswap
+ * @original_memcg: the memcg to query
+ * @may_flush: force-flush stats for an accurate check (sleeps). Pass false
+ *             from atomic contexts; the check is then best-effort.
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -5833,15 +5959,13 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *original_memcg, bool may_flush)
 {
-	struct mem_cgroup *memcg, *original_memcg;
-	bool ret = true;
+	struct mem_cgroup *memcg;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
 	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
 	     memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
@@ -5849,20 +5973,26 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 
 		if (max == PAGE_COUNTER_MAX)
 			continue;
-		if (max == 0) {
-			ret = false;
-			break;
-		}
+		if (max == 0)
+			return false;
 
-		/* Force flush to get accurate stats for charging */
-		__mem_cgroup_flush_stats(memcg, true);
+		if (may_flush)
+			__mem_cgroup_flush_stats(memcg, true);
 		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
-		if (pages < max)
-			continue;
-		ret = false;
-		break;
+		if (pages >= max)
+			return false;
 	}
-	mem_cgroup_put(original_memcg);
+	return true;
+}
+
+bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = mem_cgroup_may_zswap(memcg, true);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 18c53117503d..abf6414c01c9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -46,6 +46,7 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
+#include "memcontrol-v1.h"
 #include "swap_table.h"
 #include "vswap.h"
 #include "internal.h"
@@ -2088,8 +2089,15 @@ int folio_alloc_swap(struct folio *folio)
 			goto again;
 	}
 
-	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	/*
+	 * Vswap entries: record memcg ID without charging - the charge is
+	 * deferred to folio_realloc_swap when physical backing is allocated.
+	 * Direct-mapped physical swap entries: charge immediately as today.
+	 */
+	if (folio_test_swapcache(folio) &&
+	    is_vswap_entry(folio->swap))
+		mem_cgroup_record_swap(folio);
+	else if (unlikely(mem_cgroup_try_charge_swap(folio)))
 		swap_cache_del_folio(folio);
 
 	if (unlikely(!folio_test_swapcache(folio)))
@@ -2178,6 +2186,26 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     unsigned int ci_start,
 					     unsigned int nr_pages);
 
+static void vswap_uncharge_cgroup_batch(unsigned short memcg_id,
+					unsigned int batch_nr,
+					unsigned int batch_nr_swapfile)
+{
+	struct mem_cgroup *memcg;
+	unsigned int n;
+
+	if (do_memsw_account())
+		n = batch_nr;
+	else
+		n = batch_nr_swapfile;
+	if (!n)
+		return;
+
+	rcu_read_lock();
+	memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+	mem_cgroup_uncharge_backing_phys_swap(memcg, n);
+}
+
 void __vswap_release_backing(struct swap_cluster_info *ci,
 			     unsigned int ci_start, unsigned int nr)
 {
@@ -2188,12 +2216,36 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 	unsigned int ci_off;
 	unsigned long vt;
 	swp_entry_t phys;
+	/*
+	 * Per-cgroup uncharge batching: a single __vswap_release_backing
+	 * range can span multiple cgroups (e.g. __swap_cluster_free_entries
+	 * batches across folios), so we cannot uncharge with the first
+	 * slot's memcg for the whole range.
+	 */
+	unsigned short batch_id;
+	unsigned int batch_nr = 0, batch_nr_swapfile = 0;
 
 	lockdep_assert_held(&ci->lock);
 	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	batch_id = __swap_cgroup_get(ci, ci_start);
 
 	for (ci_off = ci_start; ci_off < ci_start + nr; ci_off++) {
+		unsigned short cur_id;
+
 		vt = __vtable_get(ci_dyn, ci_off);
+		cur_id = __swap_cgroup_get(ci, ci_off);
+
+		/*
+		 * Flush per-cgroup uncharge when crossing a cgroup boundary.
+		 */
+		if (cur_id != batch_id) {
+			vswap_uncharge_cgroup_batch(batch_id, batch_nr,
+						    batch_nr_swapfile);
+			batch_id = cur_id;
+			batch_nr = 0;
+			batch_nr_swapfile = 0;
+		}
+		batch_nr++;
 
 		/*
 		 * Flush batched physical slots when the next entry
@@ -2217,6 +2269,7 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 
 		switch (vtable_type(vt)) {
 		case VSWAP_SWAPFILE:
+			batch_nr_swapfile++;
 			if (phys_start == phys_end) {
 				phys = vtable_to_phys(vt);
 				phys_start = swp_offset(phys);
@@ -2250,6 +2303,9 @@ void __vswap_release_backing(struct swap_cluster_info *ci,
 			phys_start % SWAPFILE_CLUSTER,
 			phys_end - phys_start);
 	}
+
+	/* Final cgroup-batch flush. */
+	vswap_uncharge_cgroup_batch(batch_id, batch_nr, batch_nr_swapfile);
 }
 
 /**
@@ -2342,7 +2398,10 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	swp_entry_t vswap_entry = folio->swap;
 	struct swap_cluster_info *ci;
 	struct swap_cluster_info_dynamic *ci_dyn;
+	struct mem_cgroup *memcg;
 	unsigned int voff;
+	unsigned long vt;
+	unsigned short memcg_id;
 	swp_entry_t phys_entry = {};
 	swp_entry_t pe;
 	int i, nr = folio_nr_pages(folio);
@@ -2351,9 +2410,18 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	VM_WARN_ON(!is_vswap_entry(vswap_entry));
 
-	phys_entry = vswap_to_phys(vswap_entry);
-	if (phys_entry.val)
-		return phys_entry;
+	voff = swp_cluster_offset(vswap_entry);
+	ci = __swap_entry_to_cluster(vswap_entry);
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+
+	spin_lock(&ci->lock);
+	vt = __vtable_get(ci_dyn, voff);
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		spin_unlock(&ci->lock);
+		return vtable_to_phys(vt);
+	}
+	memcg_id = __swap_cgroup_get(ci, voff);
+	spin_unlock(&ci->lock);
 
 	local_lock(&percpu_swap_cluster.lock);
 	phys_entry = swap_alloc_fast(folio);
@@ -2364,10 +2432,20 @@ swp_entry_t folio_realloc_swap(struct folio *folio)
 	if (!phys_entry.val)
 		return (swp_entry_t){};
 
-	voff = swp_cluster_offset(vswap_entry);
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_private_id(memcg) != memcg_id)
+		memcg = memcg_id ? mem_cgroup_from_private_id(memcg_id) : NULL;
+	rcu_read_unlock();
+
+	if (mem_cgroup_charge_backing_phys_swap(memcg, nr)) {
+		__swap_cluster_free_phys_backing(
+			__swap_entry_to_info(phys_entry),
+			__swap_entry_to_cluster(phys_entry),
+			swp_cluster_offset(phys_entry), nr);
+		return (swp_entry_t){};
+	}
 
-	ci = __swap_entry_to_cluster(vswap_entry);
-	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
 	spin_lock(&ci->lock);
 	/*
 	 * Install PHYS backing without freeing any prior contents of the
@@ -2560,19 +2638,13 @@ static void __swap_cluster_finish_free(struct swap_info_struct *si,
 /*
  * Free physical swap slots that were backing vswap entries (Pointer-tagged).
  * Clears the physical swap table, decrements cluster count, and does
- * device-level accounting. Called from folio_release_vswap_backing.
+ * device-level accounting.
  */
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
 					     unsigned int ci_start,
 					     unsigned int nr_pages)
 {
-	/*
-	 * Caller holds the vswap cluster lock (asserted in
-	 * folio_release_vswap_backing). Nest the physical cluster lock under it
-	 * - same lockdep class, so use SINGLE_DEPTH_NESTING to silence
-	 * PROVE_LOCKING.
-	 */
 	spin_lock_nested(&pci->lock, SINGLE_DEPTH_NESTING);
 	VM_WARN_ON(pci->count < nr_pages);
 	pci->count -= nr_pages;
@@ -2590,10 +2662,11 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned int batch_off = ci_off;
+	bool is_vswap = swap_is_vswap(si);
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (swap_is_vswap(si))
+	if (is_vswap)
 		__vswap_release_backing(ci, ci_start, nr_pages);
 
 	ci->count -= nr_pages;
@@ -2613,18 +2686,28 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		/*
 		 * Uncharge swap slots by memcg in batches. Consecutive
 		 * slots with the same cgroup id are uncharged together.
+		 * For vswap, only drop the ID ref - physical swap was
+		 * already uncharged in __vswap_release_backing above.
 		 */
 		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
 		if (batch_id != id_cur) {
-			if (batch_id)
-				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			if (batch_id) {
+				if (is_vswap)
+					mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+				else
+					mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+			}
 			batch_id = id_cur;
 			batch_off = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (batch_id)
-		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	if (batch_id) {
+		if (is_vswap)
+			mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
+		else
+			mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
+	}
 
 	__swap_cluster_finish_free(si, ci, ci_start, nr_pages);
 }
-- 
2.53.0-Meta


