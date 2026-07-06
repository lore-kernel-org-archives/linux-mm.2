Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DF8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 20:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DCE6B009D; Mon,  6 Jul 2026 16:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEA16B009E; Mon,  6 Jul 2026 16:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD1D6B009F; Mon,  6 Jul 2026 16:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6036B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:31:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B76111A020C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:31:35 +0000 (UTC)
X-FDA: 84959497350.11.112D685
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 041364000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:31:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N18yntDi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783369894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ugPZ92m+aFMHhNOmVGeaijiQe+M746A3aeO/aRZ15xg=;
	b=7JsED+RDxTXHLVLmam1uyvETbF7gzWKIC64/7JYI6GJaj9BQVi+UPbLVwwcgl8pagdw6To
	goZDH+k4RNSNONPvdjc+dDVj10aqpKj0vw0W4uEq4dq1dO340aPuF1V/sIhMplwNhe1G9l
	Qx/UmkjFBSFyD9KNbnb7hQ6qNR1X8aY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N18yntDi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783369894;
	b=X9i7mGZ7aQKtxo/evlj0tSSL9LSmL1xdOFjgqbEXa3jPyAQ82DqZjvt/xT93GaxAXlVTgu
	vV7siaW+fzcH6IX8VCT47/UAgZAJ9RaXC6q0paE1IsJfgk6zCNTYgXGJNse0lne24o04/2
	tCJFQ7HyXIc0lePRjDwg4RvSbzi6WQU=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so1116895e9.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 13:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783369892; x=1783974692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ugPZ92m+aFMHhNOmVGeaijiQe+M746A3aeO/aRZ15xg=;
        b=N18yntDi8Fy9SsTTxm0BFDKFqD2yC0zcVEa+46XhkxtVRwD+pCMJwcGFYhxfjdi+t+
         Rk1QfqGvMIIrXt+Jz3FiILnXpYZ7rX6D/SQ7F1Xb4rQjVAK1br3mOVgT8ssoLf9mP2M2
         tYr5KTk3NXaYPwPoJlba7iiBKgMYk7E/weo3weXxKWqQt3qYrS/gpZcmhlkUmmF8M4Bn
         0c37HrCW0Ut/rHJr1RK96WXk/nlTSX7nYUFxWwDgqRUkgvxeRwI3oXipAXVNC31oxMNT
         BbMs3dW8Hn1qZ6nBJBvx+szAbpXXiXVsoMv5HsMDPLk/R7Nc9P+To/zSaHHo+AoiddxU
         KdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783369892; x=1783974692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugPZ92m+aFMHhNOmVGeaijiQe+M746A3aeO/aRZ15xg=;
        b=ZnrikSsKYDqCaXo8RICZz6OonA99URcs3fX04XZl+PQAi2+zxU0ZjrSVcJvfsEqthv
         doY+qh1RPS64TgrCMOefDZ9GOhHMTX698JXD90dSNWySXBZuyXrco7oA4OVLQuN50Swt
         1xl5AIBYIWios3ul+iBoPhnBqRhz90ldUocid2FfNva+2XPWhuakT5Sorqzu5DBfCvp9
         kSY3QqEYP7h5gf9O930Qeouvl7w0ZRikaKRTOGj45CKFteyBx9qGEeRyW+6XhSVVEyCp
         xtZhjNNmQQPwwVukTv268ovlAWXJwk6qMDZUoP6ZU1fKouU/LLZMr2rQq1i6Zd06Qd15
         0G7w==
X-Forwarded-Encrypted: i=1; AHgh+Rq64yeuENDyWkwJAOWB9dS4CxeBEGs6l54TZU1AEEO7dqGXpPFggG4X8sPkJiHuIFnwJm5iQNsIAA==@kvack.org
X-Gm-Message-State: AOJu0YyyHNMd1b4aE4Dlu65jQuZSSrdvpZqWeEs5VCI1HSu/OD1tXmoD
	SOiGSJfnwEsY+F1fSR197vxJVD947Z3N6hGEr+lVOghH1Pk4GWS0kOkk
X-Gm-Gg: AfdE7cmoYsm9HkUEK1Zxr0bGoZD5Ek79xxBHzZ/VPDe7k1UzVeDz0LrUSR+rx7QS8Es
	yU/qNYqrWtVzyL7j6fNJ5iy+qkWm7MP2XW5S501m6Gc1VuTC2DYiSqbSTW9nAvw3MNNLhKEqMT+
	56vlwx9bP1FFGDF6CuIQNcXOXcDeSsfpSppNzw6xBje8tUrVgzeaqmZEc1G+2+0YIJIgpqA0QZ6
	ILMlFDA4vpbPqQmzEaEvbo3DysT3/KoKhMZwB/O8WvmD7Fi76dU7XfooLgJG2sXgMzuH3e+st1l
	wq+/0cTGbGR7iCA1hS/OvsDeJ8uXnOgV8kGwrUxMChBKWUBKsgDCTeiauBoh/oNONVFCr1VfM6E
	1H8EV4dKWn/YUt4d0u1aYax3/ZByF0bu22eUiGPfNQph1W/ugV2Ecqv/ZS7lNO3XsUcYz95n/02
	1iq96NNWWEJ+Mll/wtWd0gQodtcmtKQ0Q81Y74p6U6w0IGkOQ0HZzSCOlwA5OPdHbinXg3E/8B
X-Received: by 2002:a05:600c:530c:b0:493:b4a3:5ab0 with SMTP id 5b1f17b1804b1-493dececd3fmr23211625e9.13.1783369892019;
        Mon, 06 Jul 2026 13:31:32 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e006c47dsm11447725e9.1.2026.07.06.13.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 13:31:31 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@kernel.org>,
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
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v8] mm: pgtable: free kernel page tables via RCU to fix ptdump UAF
Date: Mon,  6 Jul 2026 21:31:27 +0100
Message-ID: <20260706203128.162335-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tr17foxtz5qj6pny9rbn75qymcpaa31u
X-Rspamd-Queue-Id: 041364000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783369893-906143
X-HE-Meta: U2FsdGVkX1/NYIdhQvGw8vVvx4hNgN9jAfs2Wq4Phf5a5pxCKanyexnJWmyItgiZafj7Y5FP9J0VawZwEMTDYja6YS6UhfHbefGGjpJZjHgK2IL+G39dWAybKJ5vl0sgIOD9nZ8u/e5u2tgtOn53SMjlSLSm38bMsov1n3eXnoa0Mvie+W6CGLbB2jEED00iBae/Hdr5wU1bg1PLjrV6Dog+CVbqpF/UiEj8QhATFwStj/fgacZsQtTOdfOh/uVRTQhXcrkTMG9ieQ6DD3oIrfpaGuxxnR/f/U9S9hEGGaNH8Pl3LPktrd1sGMbCAEQGOsPVVnRN2S3juv977Reua8xtfOmgdqbW8O5ZlDSJtsLHp7R+zRzoaXy00OJ3Vir/rBIQewhRtkZ0tSUd2JWzGYOHZYirPq3QbV/W5r7Kf0C6dxB31qSHc9FaEXIAIDQ6F2r8D1IraWI+bd/IOiRqm5JM5ssU/H/nXTQHj1J54sck2dQILlUzxkW8C9aGgCXSDdPVaDn5CwZyzpcB386FHWGHRtbOTyT+aWhDBplYXZ6Q+mUCAlOS/ueP5u+G4KREC8ba4dfJHXMyx/mPpNrIfC4+hVhEOCA004AaJF9vBMg0Cl6BxNZC6auKmtxBgD0mZrYKPL+0oLTY8kyF90clt6aA03c/0YQvYcNEprPoOz9la9/kdx1UapUSUZyfAzfYisYKp27c94EeL0uqTLSqhc4FOVy++xDcBNnSkZyQdiwPyI8z266TsKyimtdVbALfw+DsxysLj4mqVW3trDicfJZtuaMWttvkUX1RDrjvdN6CMfL3Qf4UCHI7aXRDmKpf3HzHXmNwwO/NhagHkleze2C9/9PUuy5SoJoZdE7A0dNr+CzmIc8HmqSVSukWWE1N44X4MWd4y0WlLjRy0d/Jpm4vXnBOZSYxLAMFMrxhBAjTHLuXauIdpxldYFCeNeaGmUDZNE9F1ofsW6v95Sd
 aigaheFb
 EsunqiHTiDU5s1CB/9XYsclBbjBxrQq5CjQjn1XiQ0vc/YdK7+jVzwrbtQgVmoZ6rTTdiF5ChMOj7jQEhIsUCvZKlRxrjt3CukQCB2YXpEG72haChkc9ww2905/W0cA/0LxtUlmL16Gfgdu/O8V3FUvfbs0TjGYv8+6tEciEPFA2bYBhADSIBjINcIhBphPsJNpgB4rfF4JLb9w3OZ0o5JcffNG6H+JPi9D16SaAFcuhPHeFkh69t0Zs03XM6I9VMwYZ3sOWqAHu73B85MrK1RAnuKOvmghVBoiGCihNAsKhtJAoAzYF/Gbe9VhhJV/wz19G50u2lYavJJdsvsyl7Qr+oTQp2ZtnL6aAQIYJ3nFvCDkorAD1KNvIvk8yxUKJkVJOHztgf/dpciVZ6oMExSCytY7uDUdN8mcQw57SZrZ+wK5za1qZMJhA/04UJ79b+avIHtWBJmj1ivLG0wLWGHJMlsVlFKXY2Dm9i/QdtheKEyZ0EqYVQ18e1eK+KV2hVRo0RzNKeP8VVpLj+LY2vl6p0PX/V9M9mT7v0I2n06N5tOeaXiZVMOZ97/JYlLKAGDmmIHAZ5kR5I8mZhvON/cfFCDpml7CGdcYOf+aRhib/KwfW3Or6uR2z0zVJNSPtxmmZAhEVrP2yTfdTn+W0hrgodSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptdump_walk_pgd() walks the kernel page tables under get_online_mems().
That does not stop vmalloc from freeing a kernel PTE page underneath the
walk.

When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
powerpc this runs without the init_mm mmap lock; only arm64 takes it, and
not on the block-split path. So ptdump can dereference a just-freed PTE
page, which is the use after free syzbot hit in ptdump_pte_entry().

The race is not new. ptdump walks the whole kernel address space, including
ranges other code is actively mapping, so it reads page tables it does not
own. Commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables") only widened the window; the Fixes tag points there for that
reason.

Every other walker works on a range it owns and is the only one mutating
it: set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
concurrently, so they cannot race and do not need RCU. ptdump is the only
walker that traverses ranges it does not own.

Defer the free by an RCU grace period. pagetable_free_kernel() now frees
via call_rcu() in both the async and non-async configs. The async path
still flushes the TLB first, then queues the per-page RCU free. The page
stays valid until any walk that may have observed it drops its RCU read
lock.

x86, arm64 and riscv reach pagetable_free_kernel() for the collapsed PTE
page (the ptdesc carries PT_kernel), so the deferral covers them. powerpc
uses its own fragment allocator: pte_free_kernel() there frees the page
synchronously via pte_fragment_free() and the ptdesc is not flagged kernel,
so defer the kernel case in pte_fragment_free() as well. arm64 also takes
init_mm.mmap_lock around the free under a static key; that is now redundant
with the RCU deferral but left in place.

On the read side walk_page_range_debug() walks the init_mm range in bounded
chunks, taking rcu_read_lock() around each chunk and calling cond_resched()
between them. It uses the lockless walker as the mmap lock is no longer
held, and pgd_addr_end() to bound each chunk without overflowing at the top
of the address space. A walker either sees the cleared PMD and skips, or
keeps the page alive until it drops the lock. The owned-range walkers are
unchanged.

Stop taking mmap_write_lock() in ptdump_walk_pgd() for init_mm. It never
guarded against this free -- most architectures free the collapsed PTE
table without it -- and RCU now provides the synchronisation. efi_mm and
current->mm page tables are not RCU-freed, so they keep the mmap write
lock.

ptdump callbacks run under RCU within a chunk, so they must not sleep. The
arch note_page() and effective_prot() callbacks only format into the
preallocated seq_file buffer; the only GFP_KERNEL marker setup runs before
the walk, and cond_resched() happens between chunks, outside the read lock.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v8: fix four issues raised by the Gemini review of v7 (relayed by Andrew).
    - the init_mm walk called walk_kernel_page_table_range(), which
      asserts init_mm.mmap_lock -- but that lock is now dropped; use the
      lockless walker instead.
    - only stop taking mmap_write_lock() for init_mm; efi_mm and
      current->mm are not RCU-freed and keep it.
    - bound each chunk with pgd_addr_end() so the last chunk does not
      overflow at the top of the address space.
    - powerpc frees kernel PTE pages synchronously via pte_fragment_free()
      and never sets PT_kernel, so it bypassed the RCU deferral; defer the
      kernel case there too.
v7: no code change; add version tag and per-revision changelog (Dev).
v6: chunk the init_mm walk in walk_page_range_debug() and take
    rcu_read_lock() per chunk (reverting v5's caller-side lock + assert)
    so the read section stays bounded on large kernel address spaces and
    can cond_resched() between chunks; drop the now-redundant
    mmap_write_lock() in ptdump_walk_pgd().
v5: reframe changelog around the pre-existing race and range ownership;
    correct the mmap-lock description (arm64 is the exception, not x86);
    move rcu_read_lock() into ptdump_walk_pgd() and assert it in
    walk_page_range_debug(); drop walk_kernel_page_table_range_rcu(); fix
    the pgtable-generic.c comment; document the no-sleep audit of the
    callbacks.
v4: defer the free in both the async and non-async configs, not just the
    async one; add a walk_kernel_page_table_range_rcu() helper.
v3: take rcu_read_lock() in the init_mm branch of walk_page_range_debug().
v2: use call_rcu() instead of synchronize_rcu().
 arch/powerpc/mm/pgtable-frag.c |  7 ++++++-
 include/linux/mm.h             |  7 -------
 mm/pagewalk.c                  | 36 +++++++++++++++++++++++++++++-----
 mm/pgtable-generic.c           | 22 ++++++++++++++++++++-
 mm/ptdump.c                    | 11 +++++++++--
 5 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
index ae742564a3d5..1e1e88f831f7 100644
--- a/arch/powerpc/mm/pgtable-frag.c
+++ b/arch/powerpc/mm/pgtable-frag.c
@@ -123,7 +123,12 @@ void pte_fragment_free(unsigned long *table, int kernel)
 
 	BUG_ON(atomic_read(&ptdesc->pt_frag_refcount) <= 0);
 	if (atomic_dec_and_test(&ptdesc->pt_frag_refcount)) {
-		if (kernel || !folio_test_clear_active(ptdesc_folio(ptdesc)))
+		/*
+		 * Kernel page tables may be walked locklessly under RCU by
+		 * ptdump, so defer their free by a grace period too, like the
+		 * lockless-GUP case below for user tables.
+		 */
+		if (!kernel && !folio_test_clear_active(ptdesc_folio(ptdesc)))
 			pte_free_now(&ptdesc->pt_rcu_head);
 		else
 			call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
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
index 3ae2586ff45b..fc2fe014ac8c 100644
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
@@ -692,9 +692,35 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	};
 
 	/* For convenience, we allow traversal of kernel mappings. */
-	if (mm == &init_mm)
-		return walk_kernel_page_table_range(start, end, ops,
-						    pgd, private);
+	if (mm == &init_mm) {
+		unsigned long addr = start;
+
+		/*
+		 * Walk in bounded chunks so the RCU read lock is never held
+		 * across the whole kernel address space.  A kernel page table
+		 * freed via pagetable_free_kernel() stays valid until the walk
+		 * that may have observed it drops the lock; releasing the lock
+		 * between chunks is safe as no page table pointer is held
+		 * across the gap. The mmap lock is not held, so use the
+		 * lockless walker; RCU, not the lock, keeps the table alive.
+		 */
+		while (addr < end) {
+			unsigned long next = pgd_addr_end(addr, end);
+			int err;
+
+			rcu_read_lock();
+			err = walk_kernel_page_table_range_lockless(addr, next, ops,
+								    pgd, private);
+			rcu_read_unlock();
+			if (err)
+				return err;
+
+			addr = next;
+			cond_resched();
+		}
+		return 0;
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
index 973020000096..537be9995e1a 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -177,13 +177,20 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
 	const struct ptdump_range *range = st->range;
 
 	get_online_mems();
-	mmap_write_lock(mm);
+	/*
+	 * init_mm is walked locklessly under RCU by walk_page_range_debug().
+	 * efi_mm / current->mm page tables are not RCU-freed, so hold the
+	 * mmap write lock to keep them stable against concurrent teardown.
+	 */
+	if (mm != &init_mm)
+		mmap_write_lock(mm);
 	while (range->start != range->end) {
 		walk_page_range_debug(mm, range->start, range->end,
 				      &ptdump_ops, pgd, st);
 		range++;
 	}
-	mmap_write_unlock(mm);
+	if (mm != &init_mm)
+		mmap_write_unlock(mm);
 	put_online_mems();
 
 	/* Flush out the last page */
-- 
2.53.0


