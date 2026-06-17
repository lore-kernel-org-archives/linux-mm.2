Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAA9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0566B0088; Wed, 17 Jun 2026 07:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987DE6B008A; Wed, 17 Jun 2026 07:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E526B008C; Wed, 17 Jun 2026 07:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE806B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:53:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA8671C1F6E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:53:50 +0000 (UTC)
X-FDA: 84889245420.17.2068F7D
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id F170920003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:53:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEGwopih;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781697229;
	b=ot+PELSgHkzNmzIDEucnALgZOHZe1GCdWfLzza8jn9oyhiu/XPkYZv6Ru9Y1MsFdN6IjCj
	vRUUPm4EHyorl+ueU1Li9xQOo5OXGEn2knNK+1V75cPEC4MBj8NSnmAQjD7So/ghPqyk6G
	ntX5M1vi7gHUNGD+HipR4MC0r2LN6Yk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEGwopih;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781697229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
	b=hrcXsdB3sSeyF/glr1qJ5xyr5bS5MYZ3kSequ1r24506FPDbRtXvpY800wQxQaTWr5Krfv
	jqU/nScMq197xs8NpjlSE90C9ggC1GoJgwQV3gjIObHvNlFe/ff5oJoV4laWsaAQYGJTXo
	O6shg0fl+X95W25PRZO02Nb/n+ajU+8=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so27141315e9.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781697227; x=1782302027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
        b=GEGwopihPa7tXW5Ad8jv82ikcY6ABL12tRlWmFgVUp124DrUrJMUO8fl8LL9HUUqR5
         /3AxEXYXKgDBwnmGI0wqgIrNXeLrb5jgwc6uwKCKCTKN0aG7KRoTd6BJqFZvqVgM8Cet
         sjWaDgAerHNjZuFY9LvzzHDcgjf9T7p7l6DUoL76iiKlIae/LMPha5zD1SsEknAXtIDl
         MoqUvsXAyBzyh6rAon78kFXe9wx+KKrqGe3TtAhpAJ8KWtDldSPkHmbc80hwT6zLT0Wi
         q2wsSpeeA/bBjj6uc1J8M9dCXA2zG5VEjsc4NT4+ntGbiMJcdTvbUGVR3HzIrtQleW4A
         GkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781697227; x=1782302027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
        b=bdp2r+uOgT1ohKSA7rIu23dDM9PVXOefp+1Bu4fBTe7uMuqnO9L1/uY5ajaUIhIF7r
         fCc4dsFEi9EZirv71UQjQuDXBP1obVJQ+ulUHY8AlxPI7PKqI19TYj99UDS8SABkLTnG
         RjAArpkM+BBB0Aza58jKma6pG3JzCfzqsh+mJf7riFjcW86il17NkRfwWy91ffLNadqy
         SV8hFKZqDzvJ+OTri5pumwMmBTGN2iNyrqeobVWLG2lH9FS4rX0KL4riBvQ160WLJNCU
         ajJ76jw46tmlJKg1NAc4G0G12qQsdfEYLdpmrxQrqOJqPqgKS1/uSbv8aYxgadts0Aey
         FQkw==
X-Forwarded-Encrypted: i=1; AFNElJ+/G30M8TCfQrgvde1kDpNRqvZa+diuiTD6SV+CUXxMz4pj9slmCGfrC0VQ6YpdHTc5H6odJtceNQ==@kvack.org
X-Gm-Message-State: AOJu0YynV/WAFt4No+E1xcgW2A7PsV/rF9kxPoPxeglXYVLPrE0Yl6LQ
	Wg/U3NKmHCPV+7qrdYIISre0ervuy+OzXCTZDbkhHSE6GCYeJrGY1/hZ
X-Gm-Gg: Acq92OFU1oKvia/ZZpAc89PJywEfa4QjYywxzvaxzdtLYu0tACqc4hQijejuHmIeGCd
	cmmTPSUVUSXPGAcE0PO/4fBHgwaVaON6p7eAwHATDWkixehwXAsvuNLcj9UKOBY0mmb4/DNdkiN
	U+TuHRJX1YKSKgH//G3bZ/DPNHPi+xhNOlVIjYxddbPJCgEWrZPX1f7REKV26vhPZqnCyrDWWTj
	jCwscNn2ZvL9nhK53CKLgRGLxQEgr/BXtZla6NYAB2XtEE1KAfxDuvQ9KcgXGKsVtE1veOtEEdw
	rdUivc4wuiGjyGUX/HTZN73fjuLFmbU7dVW4nD74rEwGGSl4eB3jhJXIpB72sTjI7AVjFMJ8asQ
	PzwVVZDAGv7kddbQG6ipBeJMtc5GbpA+q3z9vguylefYJ44dLcrMF8AelXoQaSVaRESjqdBBpcx
	XqtqICNib114og2RxRHgbsfM/RxOYUJj1nxL42BVGfWMCMoNlw6AHeaL0li2fcwky36oHHba/9
X-Received: by 2002:a05:600c:8b43:b0:490:bbc4:76a6 with SMTP id 5b1f17b1804b1-4923341fdb8mr72118915e9.21.1781697227028;
        Wed, 17 Jun 2026 04:53:47 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a58becsm143702955e9.7.2026.06.17.04.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 04:53:46 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH v5] mm: pgtable: free kernel page tables via RCU to fix ptdump UAF
Date: Wed, 17 Jun 2026 12:53:42 +0100
Message-ID: <20260617115342.156775-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F170920003
X-Stat-Signature: 45dr6qusqmzazb3mg9kdffmqm7rmcfm7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781697228-678374
X-HE-Meta: U2FsdGVkX18GZcrG08dpm6+gbsVWcdh9wZEVy2Hc+exGKW+7DnsWuR2A8UUNPrzon9cJ3zELb+SanK8EV6a49g7aF0evJNZ3QiNhKr6ZwJlxi2da6WBYc1SY+7L/8vOPNyd/bKKrpnf0Sj/aX844LVassDYNG1GWDsVdxtzmt6rXjvZGgJjVoNb5fllH2jN9DyFzzE0Ea6yht5HVKgsOQ4n4KO45wGPzdw/VJfy6NBfFa6CXjQf4rC5PUgfY2NJx4iDzO5ot8oF0sPHIQXXztuKR+cfDpfz9NCutIEeJQIFIAd1srCXZGn1eGywxvr7JUHXt3hE5OLDei87bbHzrd4i4BcLS6qJKgOrXMFfOTSgfVqOTi9GIQdMjJCSgHK5M3QnfrKXHeqrbwuumQ2nugsFKDCjdv1Zg2zWLD1KNU1XdLFzOG8bFeVX0JvsEM5IwAuF3LbXfD14wzFPqkYR3gaC04BGWBp78/8niwRxiaMvAWotITLC8ApLdQv4zrbqiFFQDFoE/Z54nFvdNcvpYCC+VmUDaPwjesdwT8DlFj+/cmDbhT+qGA6XuZ+lYALHyQJZmb94Dp44f8LNa+Z5ueyHbWiOm6nGBkv8hm71i1/rb5ckC92CBAQRntPRpuz0XC+d1LEsO/0y/AcCToq3sSP5Z49s3SzEUSYA2yyMmV7ZHrlhC+oCl8ANUqOd1zjFq5xhDrmXtq3LAyyszd4SagUdABqeEVdrjU4Y5jm344xoral+YRSunHxe0M78Iv3o+j8dZozKrC/b/e4SfvUx2pqwu+Vce4xwPrLud8X6uOBJqZkrzsnx7X7r2mNYDj7PcLL97RBeqf2elhDqxMvCSf4mlpeIH9tXJu4BEGtTka1kWFsNe+CMRYoRPvAByAvX8fEfdYpFBZJBrf8OXXFEiq9LvRyCM1Mzon1iKrROsR2fIlzUADr/uvYNCS1LvLRJT3mEpFIfbTTmS0lhcNx9
 E/SEOS4b
 v7+HOCXYgDO6ESdqzhHSNKUoKAn2vxbqK4J+waNlOvgelSbKCnPwLYS5fPCRUOXxhNF1OfgvxkgQTVY0wdSa1YOlECIryYSa3+noWaMrau2XRTeZJgG3UScP4aof6KydSld4wE1QJqwgNSOC9iKUpuD3rW48O2Dw99DZzxhgSNAjHM8jZoGmFalZx0+zCGEWUrzvFVyhtJyNauvbAV0UADz0/Q+GfKGD4U8gEJz0TlZyAm1j4Vcgwh5/iSATiBsbqdhG5GXI4w801IiDuinZmNjl4Qayk/mJJJGlCeJ9/mOj78XrSMVa424eHMH8/IGksEiSoTea0wWSkALftGCpwXtbbt6qJCeO6P1Q1Ljgnup/Z7VKHR67h8YI+IMKkfbiZz1WyIm4oKJ1JXpQQc9ecpY4XtpJRoHyMQdl8NgzJKKcKtpG8YiYVxT3mBWoPa12NyetrGr7RCw3qZwFlmQURdvnFzOj2qu6Ij6D4GOH2HSNhzoq80xJUVrUxZ9vf3d2/L0Anhi6/UTTOfADuyXA8GIKVXiv1+a4VyIxLT6PFCjtinTI2s5iEusfKWD56+qWiPXdBhXF2LZbK6omm10cHDarmwl4R0ASgFI3OLFwOp1gw5nOIOUM5CccqMZZz3tzKFpnOPHcR+jEsRXra0eqR3eLWDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdump_walk_pgd() walks the kernel page tables under get_online_mems() and
mmap_write_lock(&init_mm). Neither lock stops vmalloc from freeing a kernel
PTE page underneath the walk.

When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
powerpc this runs without the init_mm mmap lock; only arm64 takes it, and not
on the block-split path. So ptdump can dereference a just-freed PTE page,
which is the use after free syzbot hit in ptdump_pte_entry().

The race is not new. ptdump walks the whole kernel address space, including
ranges other code is actively mapping, so it reads page tables it does not
own. 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
only widened the window; the Fixes tag points there for that reason.

Every other walker works on a range it owns and is the only one mutating it:
set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
concurrently, so they cannot race and do not need RCU. ptdump is the only
walker that traverses ranges it does not own.

Defer the free by an RCU grace period. pagetable_free_kernel() now frees via
call_rcu() in both the async and non-async configs. The async path still
flushes the TLB first, then queues the per-page RCU free. The page stays
valid until any walk that may have observed it drops its RCU read lock.

On the read side ptdump_walk_pgd() takes the RCU read lock around the walk,
and walk_page_range_debug() asserts it with RCU_LOCKDEP_WARN() for the
init_mm case rather than taking it, matching pagewalk.c convention. A walker
either sees the cleared PMD and skips, or keeps the page alive until it drops
the lock. The owned-range walkers are unchanged.

ptdump callbacks now run under RCU, so they must not sleep. The arch
note_page() and effective_prot() callbacks only format into the preallocated
seq_file buffer, and the walker does not call cond_resched(); the only
GFP_KERNEL marker setup runs before the walk.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v5: reframe changelog around the pre-existing race and range ownership;
    correct the mmap-lock description (arm64 is the exception, not x86);
    move rcu_read_lock() into ptdump_walk_pgd() and assert it in
    walk_page_range_debug(); drop walk_kernel_page_table_range_rcu(); fix the
    pgtable-generic.c comment; document the no-sleep audit of the callbacks.
v4: defer the free in both the async and non async configs, not just
    the async one. Move the walk under a named
    walk_kernel_page_table_range_rcu() helper instead of open coding
    rcu_read_lock() in walk_page_range_debug().
v3: take rcu_read_lock() in the init_mm branch of
    walk_page_range_debug() rather than inside the lockless walker,
    which the arm64 split paths also use with GFP_PGTABLE_KERNEL and
    can sleep.
v2: use call_rcu() instead of synchronize_rcu().
---
 include/linux/mm.h   |  7 -------
 mm/pagewalk.c        | 14 +++++++++-----
 mm/pgtable-generic.c | 22 +++++++++++++++++++++-
 mm/ptdump.c          |  2 ++
 4 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..79408a17a1b0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3695,14 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
-#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 void pagetable_free_kernel(struct ptdesc *pt);
-#else
-static inline void pagetable_free_kernel(struct ptdesc *pt)
-{
-	__pagetable_free(pt);
-}
-#endif
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..c0be87580989 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -620,7 +620,7 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
  * Note: Be careful to walk the kernel pages tables, the caller may be need to
  * take other effective approaches (mmap lock may be insufficient) to prevent
  * the intermediate kernel page tables belonging to the specified address range
- * from being freed (e.g. memory hot-remove).
+ * from being freed (e.g. memory hot-remove, vmap huge page promotion).
  */
 int walk_kernel_page_table_range(unsigned long start, unsigned long end,
 		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
@@ -643,7 +643,7 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
  * Use this function to walk the kernel page tables locklessly. It should be
  * guaranteed that the caller has exclusive access over the range they are
  * operating on - that there should be no concurrent access, for example,
- * changing permissions for vmalloc objects.
+ * changing permissions for vmalloc objects, or vmap huge page promotion.
  */
 int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
 		const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
@@ -692,9 +692,13 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	};
 
 	/* For convenience, we allow traversal of kernel mappings. */
-	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
+	if (mm == &init_mm) {
+		RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+				 "RCU read lock must be held across kernel page table walk");
+		return walk_kernel_page_table_range(start, end, ops, pgd,
+							private);
+	}
+
 	if (start >= end || !walk.mm)
 		return -EINVAL;
 	if (!check_ops_safe(ops))
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..7a32e4821957 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -410,6 +410,13 @@ pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 	goto again;
 }
 
+static void kernel_pgtable_free_rcu(struct rcu_head *head)
+{
+	struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
+
+	__pagetable_free(pt);
+}
+
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 static void kernel_pgtable_work_func(struct work_struct *work);
 
@@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
 	spin_unlock(&kernel_pgtable_work.lock);
 
 	iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
+
+	/*
+	 * Debug walkers (ptdump) may walk ranges they do not own and race this
+	 * free, so they walk under rcu_read_lock(). Free after a grace period:
+	 * a walker either already saw the cleared PMD, or keeps the page alive
+	 * until it drops the RCU lock.
+	 */
 	list_for_each_entry_safe(pt, next, &page_list, pt_list)
-		__pagetable_free(pt);
+		call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
 }
 
 void pagetable_free_kernel(struct ptdesc *pt)
@@ -446,4 +460,10 @@ void pagetable_free_kernel(struct ptdesc *pt)
 
 	schedule_work(&kernel_pgtable_work.work);
 }
+#else
+void pagetable_free_kernel(struct ptdesc *pt)
+{
+	/* Defer the free by a grace period; see kernel_pgtable_work_func(). */
+	call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
+}
 #endif
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 973020000096..50cd96a33dfd 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -178,11 +178,13 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 
 	get_online_mems();
 	mmap_write_lock(mm);
+	rcu_read_lock();
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
+	rcu_read_unlock();
 	mmap_write_unlock(mm);
 	put_online_mems();
 
-- 
2.53.0


