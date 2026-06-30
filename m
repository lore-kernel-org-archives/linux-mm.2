Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A03C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EA66B00CD; Tue, 30 Jun 2026 00:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119B66B00CE; Tue, 30 Jun 2026 00:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23CC6B00CF; Tue, 30 Jun 2026 00:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C38226B00CD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:10:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 467BF140349
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:10:20 +0000 (UTC)
X-FDA: 84935251800.04.2D6C302
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9000240002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:10:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMXN+F+8;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792618;
	b=NGh8JBl+maHolpDJMFixd2WQJaYNmb7J6+sQRoqE+P4pKrEFF5hv2sdxcnTP9tamBmaMKS
	ERzSFZv0DdZqgrrWvnClD5uPcnZ9aJoW6tSYmZFrIsur0ys/sjCdI+/SUAMVWH0qcrb28S
	ij++atIqBMamn/NLoBKiOs5CHP3aTjQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
	b=Nkwbm+fMa1qogSHsIAfEcOy8NJNDVyczgSAZCWA2OZzLHRI5DAYl/lMVyH4dJp3EvsYub4
	ZH0Xrm39suvlHK+yeaMTcTDsmyeSIqPr3iDFhhIFzCoOJklBUIdhE+Du+F4Y68QGc7eNXV
	odUmjM18Mf9Ku7QGYu8UfFRVqXJ6N8g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMXN+F+8;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493b5d61302so809085e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782792617; x=1783397417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
        b=cMXN+F+85stcRns4KsbJ4Bpt7qFrSNQJ4hFiYP3Yfh22+f3M8acibLU7vmTNrDQP8s
         kik4SmBAGT8TaeHWSgCcNgkck/EVtMzvgS5rmFHI1uxO6R+qb7bNWthVnKrUrmPcN+kM
         7IOOp20js3rk/Kskraaw+lXEUGivvGvoxmCblhfEvSltPPJOtjqoEfyHLgMpeHhvZF5P
         oEuRTTn3pz+gVGKEp/6jhS6Mx/aOOulgBgsyMizJOi/7dy0OqSvRlPL+P5438taD569W
         OK1MD6fpnJj05yOjaZeGy5ZZL/lULGATkIkN+FQICAeB0jWSAJ5x9vYW9dBsJKnsb+ho
         Ct1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782792617; x=1783397417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfOCgBUYMvXbl1f8j58WJcsxpt1QKz3Glw/S1uy49Es=;
        b=NOMNQE82fvUOoL+FUml15sdz/pVcYToVbvt0Zik1tUOdUtmiGAV9QgjQjCDQeBqgFY
         2WTCx9r8r3grTOh8mQ33ouIxKwO8o0uHOqAjyNcPrVHXT+hCJyhEPRSVP4fYZhL4oQZC
         9kLMRA8QJ8TtQ91cw5e/pxqpB9BcAX7zSFCTo9w0XKa2MPlFIpwphF9NGKBo3Q1i4+n5
         9hZ7TAMUwhG+V5xXv5/4lk7VsRRqNMNzkjqCHVuSIacsnnpgsnEtjriBqKOFVxvhnqhQ
         b001nLtv/oKo2k8fP+J9ntVpo+JimCV3/wXDcxps9AuMkRoL+iD9rQfVbmBLntRT7h/b
         HA7w==
X-Forwarded-Encrypted: i=1; AFNElJ/JwAO5movTRQ4X76uM8SaoEOTiQh4D6g3aBBFmmRMKAN2Nhuh4VG6IUIYRo90G62k2BVaFnaRHtQ==@kvack.org
X-Gm-Message-State: AOJu0Yytin55+NM5dl/2U2zHxEzzN5k9a6LE83kK6jyTtIgrQUWNG/TQ
	0iZGg5GOpMKBvhw3jcqOvxQN3NWCyqJSbzzTdXxlM2/2LCDojzZwFPQ+
X-Gm-Gg: AfdE7ckADD4q8Ukel8xH34F74UW4Y3vEUAGYUW1qw1Y4cjGrhQsuuOp74fmpm3cP35b
	T/gzgxQF3RXK5R1mbm0P7haekloh2Kp7w1UBy9yGfEFNHnuufkv5sYIVzOrkhrQ4sCrMib08cMz
	cG5Nbdx4RFt/fZjMDXNRuWXVJ0fgLCSnYXxo8sgcX944QlTB0gV1+dxsc51alaJhcyq7Z0nypHH
	vef4zTFlUYoBk9ZadmANoJ83YIVmBWAkvGT9uuEfumLlge+Z5Ta4PzrI1J+x/NCqpeGcMAzCau4
	mBU3JsEFArUsX+sV1jHAfOZZkz9AKJXhde+dqa757zu0biRCQR+WPM/ufCbAt+r1ojwU930pCpB
	wMG/YVcb+6tpfmrdvfji4SidU5G0ythymlhKc8QQZSpDtWZ5J85Stibdj9J4uS1jwyj0VNdnoKz
	axvOshPk/g60C51WJyeib0g2Lsx6qzwk+n3Uq0ROEqCGrlabNvHKAomM8inFsmWTRUIBBzW7NnI
	vxc1FU+3Z0=
X-Received: by 2002:a05:600c:83c7:b0:492:4871:7e21 with SMTP id 5b1f17b1804b1-493bc24ab30mr1469935e9.10.1782792616730;
        Mon, 29 Jun 2026 21:10:16 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bc19f4b0sm5675465e9.1.2026.06.29.21.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 21:10:16 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm: pgtable: free kernel page tables via RCU to fix ptdump UAF
Date: Tue, 30 Jun 2026 05:10:12 +0100
Message-ID: <20260630041012.5975-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9000240002
X-Stat-Signature: his6jtttktc8ybj8mr6y19jiq9prbg4o
X-HE-Tag: 1782792618-434236
X-HE-Meta: U2FsdGVkX19eRFRdTrX4xTqgkBZzGbzd3w9pkKuTcZUdVhtMT+G3tkFXcvWytsEjETMyt7c+X8BfO5nw3mqCg9jIiLdYqWeTJ/eV9iIObXV/92yPlZZlQQizyD8tNyTkeJm1HGDDBIuhdbTeRqq/VVlj+qAgWPmB7eAmiaEXvYsHoEgufM59IldShbksb/9PvvJXrxbm/elN4ar/TWoTYk5iRlnX7E9PwxSGI/bD3oKQBSc9gYLYSyO9yN8AkhBE3Y0nR17Mlk/BkHRzivW7MMAB1RZjd6ChRERc4hUhzhKmrQ3CNY4tWheBwG6CPHvWjkRq131hfwWHYrSfUz511kZRGI2y85n7+IG2/8WD2C9TQIS8KJiaKaG4d4ha5Wlo9ieqvXWW7Z+Tax5Jc733qSG8v2uzfMfhHLvjfLBUYS4wfo9Aqb8GXBiPuWFezpArQn9EHKilo9SCu05NGnCiE3fynNOWWpp8chKVdTXxAJ2nirDOv8o2/oExGGBdo4ViPYYpNuNb6v/BGMrySHxUA4L66MqCBZEC0DWpnHoan2i3ybv8Yg2xSsJJ46VObHrbA7c4AKdfApGIEEV9mxsKHqv9xyuKkpsgdaIcai5UBiGyeJYhR5x7LrrRADEg9u1qplvK9CUlewDxfRGse9q6NfzeDYDwho2xzb8Axua/f6HcHvggh1oZ0Kf7h2FoKq99E5W54dbmMB04xlHwvI/xYeusd+fG9XtZckmZ0Y3trYdXWI4taev5tT00lMxRSCSTABk4Z5LJ5Kuvkn3pIsoYgX7SmjPidAwA/Cl+jh3WO14U0HHvtvgXjjaVSUieC/9EXGpd5jva1vvnYIcy4jWcvCLwrlMTv4nto3a4NjTBoBiNIfPJWwIc75rHqdnQ3pk5rMmJoYCDE+dj6EFHyVfVumk3+u5Ngabi5iwussxAA/yO8pKHzZ+tSQXpmBBB4TWEzcgmViWLzNeRb/Lg4hH
 cS1ToU2e
 3sLQkADLXUQ1RzS+BkANHF99LPZqv2wxMItspvOGfIfLgEt45KumFb1/00JaLjnY/5skYz52JPlZkN0T8X89EApYXd6eCwzKBJpJuTvN3BoT7MDecBIDzTg7wFOAqnakl67XAwPAcSgW7l+doACSOSJ4f96HXzXlUFs3C+CCte9EFQ5WOlLzogGeHchXULH1jR5Yi/heOa/mnvGk+1K/c6/z72L1VsnyuotlmyZSxlWx6FCc9Dd9rXX1NQzelQ+9+rU7HF77zxlsNXPtAcLE78oByFcZPzoBT98RZEBLR7mifM1oGtFCb2ETaWxz6/18+4Ie6Or/mQaVdnRCo1+XmwtR8Ts7sLeOMsvRZFu2Zxl8XyS3AJNy2fnHzKQnuv7xB2RcJYhxrWxCwJzy8REQNG5BJiL+YdD8vt62oR9qRWZe57JPBNsbt1CfY0jaEcBRVZuoz2Oe3ImD/QwzswbL4SvEWo5d1kLUIJrNDUvpcOmCqghr5zlUu0iqYulkwQk3fCr28BAYxwkofOG+C31SBl031duwNpVL/1E8JumXeDGZ852Skw5V438gymZ5k3tgZPtjD4g2qu028b/tLnpR560xNol4Gcx8gm7heEU3jmvMLYqGI4lGbH5gBre9lXhtZT/uN725TKmxOciDU1mjU0qUH+A==
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


