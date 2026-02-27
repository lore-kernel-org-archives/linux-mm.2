Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862BC1039892
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37DE6B00D6; Fri, 27 Feb 2026 15:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10706B00D9; Fri, 27 Feb 2026 15:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F0D6B00DA; Fri, 27 Feb 2026 15:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B922A6B00D6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:09:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF1813BEAF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:45 +0000 (UTC)
X-FDA: 84491327172.07.18B76BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 580E440006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:09:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQHY4VRD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772222983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKsxamfwDZY3w3hGJq5MlXOZuo73MhJ/MeAQLw6AQi4=;
	b=T+jD5OLL/pvNG0joWikHKfG6Id/MFy2fGNpi9ZOvLRJfv/3tSFmFljZ5noSIff1BiEt/ok
	GO1wP58UFSwRu0JvqR0mbKJNYSZH40NzOfWWqziKWee9uUzEXpmgklETmeTA6cOxlmrxXJ
	VCul0MKX77n7GVt9lFTfuHQUSl/j/Qk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BQHY4VRD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772222983; a=rsa-sha256;
	cv=none;
	b=RWcciypqvyfFhZP3hzRqUumVdsCaIOiPOc/giypS++dmmLyWVQiPZgCKXBZE4Rp8mwqRz4
	pPbcIVyWW2sci2rk73a+zgqslEwbBwT20ShRkvqZeiNt7lX9qQabnkXrP6Ordnf/GX6VrU
	WFs/4ARXW+b9F/NDuwS296NncZ4nT44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A4A4401D8;
	Fri, 27 Feb 2026 20:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC1AC116C6;
	Fri, 27 Feb 2026 20:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222982;
	bh=6rt1gIIqFtg8jcYMpGLsIsLBZas8CDATuKxsRIDKO5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQHY4VRDSRTvpeKP+Itjk0UhkFl4s6G0uWMMDvYg1M2w57rF10GCj3c7odrrE5wWN
	 VjrTpoY8Likic/JjgXgS14dJIl3eUZ+6M5FwyltQNCNf2ZuaYyTOBZf69RquFDnukC
	 /4wLEeUtMJTFa/NRhc7WEM5x4w8QBOkBoTOacpxlvIgCCK+7PdgrNRjoDeCbwwYTJy
	 FrznIcjK8BKOGMZ+Q63lAvvbNqww0pS1F9QN17GlyDPjQCPwrahp30ffoNjNZsJBgM
	 IwdPAjvbaRoao5DNrG4O31TKtodgkmB+weVPUOBXFPAp6h+0N6Lq2+n4vSxzms/JLJ
	 4LcC9G37N3BFg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
Date: Fri, 27 Feb 2026 21:08:33 +0100
Message-ID: <20260227200848.114019-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227200848.114019-1-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 580E440006
X-Rspamd-Server: rspam07
X-Stat-Signature: dz9etnybjuwn37o6c71p8zepbxwe1hcq
X-Rspam-User: 
X-HE-Tag: 1772222983-407817
X-HE-Meta: U2FsdGVkX1+mgOf9ZDr4bWWaDlanwDrRlI73GxXiZQeSc4HmxhFfyV0+cBQmuQiGicQjP23YiliXpsJC9tCdVnC9a5gRR3PrMZxdW1QIwHdMLiAybtuoEFRhq2wUPnL/ONfdGMbdmIzSWrlcitPeo+5YgeUyIsfFxOgkIRi5y7moDAsaB4cUAW/h4vSCJFk7vJWCBYi28KzNMnQMaUfDTqM6j48vJGMq9cLMxiMGw2EuVpzAN/lSVSX+J1dPBZ0wkE9QxvGrq4k+UBVgC7Zkp2pXpFAXYuDbaaYHVPYt4M4o7/rts04qjT9HCDRwWZstUNeWrjPiTjVdne02L40+K0XIBs1wdaZJ3f9+K9UZgBDhWFL89qRV+LZXk1eiwp+q4bRXNmGtk7tLPk0HnQjluY2oUikTtHUfS8zYZBZb/MHFmxEuEzHWJIgrBXUw7RdG9xtjpWPBuRf4e/TgvDW8ivXI7LKeHFv+QlfjFyMjBLjbYQJo1H9cCuOXDl2TBEh+K+/Es0InMcUiBCKiHnv9k3P7RdDhjgll25Uc7cLarcAzXX9KvZdI+b8cTo29r0AnPeed34wwxzaBB6e4g2bOCvNy6ROJZsMsDd2/O1YsO0je9akOg1aAIMf0JNW1+JfAgmlwZiBsxV4oFLJEwxi4CvOFEQ0CPS4hFPHFwhkp4PAz987PpHoApqJ8Zw7NvZGI6iT7zD83GH/7LvusELwejls/bCxurCc7xBxoMkmcydtUvk50O/dYVdaQoE+3sQM2LHgjlVZxVxWPZDSMJVRM+iQNPtI+0Rbv3TNiW5+fj/R54WiVHuFnmCwOqDQpYKmxKV8WT9MBeXj6hT+MrDB/AiziGbn0CeHh/BmgN1A7ZfC5/BkbDqmdMLHaed8n9qZPnCCwGV/jK88JeABgD+eimGGgMUuT1P876xoUc3UgjLlLYOd9yvnDVMfwhDcMoug1nAUHrNpGcthcdcd8ReQ
 54Yqb24A
 CR2Pd+Qai6VzgIL6ljbAZ442rA1jmr+5Qa9b4YErg7aEuyJDXL8snziw/h8rZ6H0Cfgrs4omuFdgG5lPCN5oUvxyhskAT1NmnYqaP6TsoRErzUssxXXV240TZiSjI6yzqB7hwBvZmH2QomHEFJ8jKc12bQUmCHUHr6hg49ZsbQtHSfNKhKN2E471DoJFsQbl9c64WabrPs2/L4IfJWPX5ez8dRI8QiH79yCH7sy/F+DVM6H2rd7umowSxF1jMHE71MaVLdKon7Qv9YyOVlcEE5+CM3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody except memory.c should really set that parameter to non-NULL. So
let's just drop it and make unmap_mapping_range_vma() use
zap_page_range_single_batched() instead.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/s390/mm/gmap_helpers.c    |  2 +-
 drivers/android/binder_alloc.c |  2 +-
 include/linux/mm.h             |  5 ++---
 kernel/bpf/arena.c             |  3 +--
 kernel/events/core.c           |  2 +-
 mm/madvise.c                   |  3 +--
 mm/memory.c                    | 16 ++++++++++------
 net/ipv4/tcp.c                 |  5 ++---
 rust/kernel/mm/virt.rs         |  2 +-
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index dea83e3103e5..ae2d59a19313 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -89,7 +89,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
 		if (!vma)
 			return;
 		if (!is_vm_hugetlb_page(vma))
-			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr, NULL);
+			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
 		vmaddr = vma->vm_end;
 	}
 }
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 241f16a9b63d..dd2046bd5cde 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
+		zap_page_range_single(vma, page_addr, PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecff8268089b..a8138ff7d1fa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2835,11 +2835,10 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-			   unsigned long size, struct zap_details *details);
+			   unsigned long size);
 static inline void zap_vma_pages(struct vm_area_struct *vma)
 {
-	zap_page_range_single(vma, vma->vm_start,
-			      vma->vm_end - vma->vm_start, NULL);
+	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 struct mmu_notifier_range;
 
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 144f30e740e8..c34510d83b1f 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -656,8 +656,7 @@ static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
 	guard(mutex)(&arena->lock);
 	/* iterate link list under lock */
 	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_page_range_single(vml->vma, uaddr,
-				      PAGE_SIZE * page_cnt, NULL);
+		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
 }
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ac70d68217b6..c94c56c94104 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7215,7 +7215,7 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
 #ifdef CONFIG_MMU
 	/* Clear any partial mappings on error. */
 	if (err)
-		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE, NULL);
+		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE);
 #endif
 
 	return err;
diff --git a/mm/madvise.c b/mm/madvise.c
index efc04334a000..557a360f7919 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1193,8 +1193,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		 * OK some of the range have non-guard pages mapped, zap
 		 * them. This leaves existing guard pages in place.
 		 */
-		zap_page_range_single(vma, range->start,
-				range->end - range->start, NULL);
+		zap_page_range_single(vma, range->start, range->end - range->start);
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 9385842c3503..19f5f9a60995 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2203,17 +2203,16 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of shared cache invalidation
  *
  * The range must fit into one VMA.
  */
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-		unsigned long size, struct zap_details *details)
+		unsigned long size)
 {
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, address, size, details);
+	zap_page_range_single_batched(&tlb, vma, address, size, NULL);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2235,7 +2234,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
-	zap_page_range_single(vma, address, size, NULL);
+	zap_page_range_single(vma, address, size);
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
@@ -3003,7 +3002,7 @@ static int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long add
 	 * maintain page reference counts, and callers may free
 	 * pages due to the error. So zap it early.
 	 */
-	zap_page_range_single(vma, addr, size, NULL);
+	zap_page_range_single(vma, addr, size);
 	return error;
 }
 
@@ -4226,7 +4225,12 @@ static void unmap_mapping_range_vma(struct vm_area_struct *vma,
 		unsigned long start_addr, unsigned long end_addr,
 		struct zap_details *details)
 {
-	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
+	struct mmu_gather tlb;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	zap_page_range_single_batched(&tlb, vma, start_addr,
+				      end_addr - start_addr, details);
+	tlb_finish_mmu(&tlb);
 }
 
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f84d9a45cc9d..befcde27dee7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2104,7 +2104,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range_single(vma, *address, maybe_zap_len, NULL);
+		zap_page_range_single(vma, *address, maybe_zap_len);
 		err = 0;
 	}
 
@@ -2269,8 +2269,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range_single(vma, address, total_bytes_to_map,
-					      NULL);
+			zap_page_range_single(vma, address, total_bytes_to_map);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index da21d65ccd20..b8e59e4420f3 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
         unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
+            bindings::zap_page_range_single(self.as_ptr(), address, size)
         };
     }
 
-- 
2.43.0


