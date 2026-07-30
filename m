Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E28DC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A146B0088; Thu, 30 Jul 2026 13:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA356B008A; Thu, 30 Jul 2026 13:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82AB6B008C; Thu, 30 Jul 2026 13:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7452C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:19:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9F41A0260
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:19:51 +0000 (UTC)
X-FDA: 85046105382.22.C6A2432
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 340FB40003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:19:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=imFznwkq;
	spf=pass (imf04.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785431990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDBPGVDJWrnywuKgG1Cti5x+qeb2gthsYs+EL+eew3o=;
	b=LIaii0QtRBdfYrSH2bK+Wo5lBhrsxSMU7lQdpAWHX+o8D66J54idcyWwpYMh6653TLf3Vy
	D2IYGcJi58iP6DLFkJ8UcHKNr/vI/ohPighNOkKtXYAeI5uefmySdgkIrQa5zW+5amUY+z
	lhEypyZoznRZzy+CsCP0v4X1CusAvK4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=imFznwkq;
	spf=pass (imf04.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785431990;
	b=xSDD2W8/YvPIc9WKgwmto91/m/jHyzU0+F3meypwAb7OJoyqwVvQWIGBeufBVBN/VCmDfE
	CwQY+XtM0S+WlTjZ6OYagCzw3h39BzOGK5lBcfXx5fx9yREdp1NtS91po8737qU55CBVB1
	zqiBRXjCnUtNRz4VdkghSprGKy8H+ng=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15cd3fd760so289607366b.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785431989; x=1786036789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yDBPGVDJWrnywuKgG1Cti5x+qeb2gthsYs+EL+eew3o=;
        b=imFznwkqhBaLn2pNepWQY3obybftgcuKSDHxxqwlOjqGQL7Qyfb9RGIqcIqJkpzwj/
         rHmXVn40j1ETlqgaL9YCMx/oVwopks8qNrlju9wDGVmhITyzyuCHmV7ve2BR/jVBOpGC
         sWff4PryVq2ZjWAyg2nITIUud13lS9o8PZ3s8iuOcIGI52uP+vFxMe3N7Bg4LqfFfX/j
         IYjXGki/o0zCHiqDDedDMrhu9Zxxx7Bi1T9K5/sW0SY94wyNErsZdPs/X9ki2/8jnwrk
         1Vs43xuFIYPae7MIn03JFCRLoHy/qmnzwGGkvPBMpcyz8B39yGd9EP+OZvvBPTBrhSpD
         9JWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785431989; x=1786036789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yDBPGVDJWrnywuKgG1Cti5x+qeb2gthsYs+EL+eew3o=;
        b=JgIYKpUf14Y5MwrcwCzUqvkZC+mvxRZfvsRFQDkURRRLms8/vW52OUu1YTuNo69hUk
         qds5DRppbc/lGlAEKMPcJqPeTWA7L07T3muoRhPg7tj8Hx6Ac0yCbOfLzswVhZbUizMP
         b+ZwMMKWwaMgqKxpBJVX2HkJufO/TKu08cv+ZvNhtoERJuwc77F41fMD/p7IWqAEjks4
         a0/EabWZWJbMteVUGw65BsralRL2zi+VvFI2ZnHp7pS9PT5ZiMJS56adICjjwmh7hxGI
         Eq/UgwVidTMEA8/a6XWmW9NlhhHk+I51ZnTh+wX68HF5x3M4m0MG3Lz9nNN++71hYOuk
         UIVg==
X-Gm-Message-State: AOJu0YwrZSPOgcJGeiw6gmS2uJ5YB5CBsfnbzWYnTU11hLKgOoMs7bHW
	JMKYgqmb4LiKu7pvEMIRzK7FxE/hl3KTTbQvAdyCzDo79W61BfMEngj3F2ET4A==
X-Gm-Gg: AR+sD13GqSX1s2eZgO0C7ugn9eA48QDh360tXyX1HnZdCeBxbdiPup3WgGI5HvbXCh+
	X9yeXeO2aheGLg9X3PI2qGO6LJG2gQQoJPiP5Pd2bnOxaY9GNO1mlz6YHSEqKP3kfcRSd8tlb/W
	K2/PwhqNPSS+arAJboMcLPrhA6BuWev3svD98xrp8BM+bQntzG0U77Mq5xLa2JcpFyPKO7KrZeZ
	WPTibtR+E+IvHjTU62F3mXpY1ssnBNgKFS+0wQhB8CPwY/Ta1+Jiysf1+8MC7lYyu1+xNAFFJ2u
	zyApSIfRbM6lXaluZHioA3ezf22Ju8qYDN+h7gLm/EO9h7HKMO2N4sY6i77O/r3z0vhQvw1VxjU
	eVj2Vz/osivW9yrYj0+eROUcIV7TJ75qeiFEPz3wGBa4N0FItDHQpHe8ACBi86/P1gesF6Rb8YY
	1hs0uEG64WgJDc9e69j3T2amAyjInEiLupO7lIdRdm53u7Keo7NZlYBdo40a+42dKQ5AseNh16w
	lQoqNwVfX8RYgsK/ZsaCDIcSWA3tMlsofvGGAXAwsXReXU36aJpDarAcg==
X-Received: by 2002:a05:6512:688c:10b0:5ae:c926:fc18 with SMTP id 2adb3069b0e04-5b2db36e9abmr408754e87.38.1785431527552;
        Thu, 30 Jul 2026 10:12:07 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2db94ff55sm469966e87.18.2026.07.30.10.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 10:12:06 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Thu, 30 Jul 2026 20:11:42 +0300
Message-ID: <20260730171142.76817-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730090628.65814-1-iprintercanon@gmail.com>
References: <20260730090628.65814-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 340FB40003
X-Rspamd-Server: rspam01
X-Stat-Signature: 9n9r1biysjx3cjdrxxu9xceopo8dxckq
X-HE-Tag: 1785431990-989736
X-HE-Meta: U2FsdGVkX1/xlTVYN0bpCtkiMBo7WchihyPd5A2b62pCACdAAp8Gr2uWjOzn8TXDbb5Pecs6QVR1iRNH1YKLIk4RdDhhxdhn++WCqCAXU6uja5UnLRpGeh+jA6TtlEGCwauU01iYryG5P0wxqJC+/HFqe9oTUyS855sg9OlS21EfMs9EnrC2pBu6wi+ySjU2csGq9K+F0N4xECfHAqrCTC5104auQsCBW5wa2asWupn4bofzRz6MGzQxeuvh6riYAUhe5jk+dHl1c9ZLpIhyVqVnUVyB9EkPGZTTUduEaMhn2tQy9UUyAJBCNvewr47nQSjQ+kIapcFgd+urf2JeU0ij9HHl8sl6R5/9gs9bmsrwDaifAs3wUYAbjbPTQo5arZ3Bxa2ND7pKVUp3oHDapr/G8F95QV0vqRFWgwSQO+PWO9mnD9Pe80fi5UP6Scaps/ReyuoYfEsAEIKAig6LtaSgdAeKm5NaX4crQtGH3qskXyNr3uXAX2b1bIJvPld9+Zk3YsoHqco/Sz3AxiL61krcfJm+eLqVR+pfXWlJsWkf+FrQPm5t1Xg+8ATDNz117B9Leu9MGxqLK8K0hSDsK5bPa9X9AsOZqGxHXnUL/dUiIYFlm0LnpBGGHgKrCcAObBJzruqvnMq9JEkHt7uB2j1dD6F/EzKA9Y4mdo5y+GffaIvGdHjZviTjzo28bytlR3Bzq71NGlWJQUEvgR3dwVdLA1Vi0zROlCD0Q5uN2GDUAp2T3zGSkqyYC5Bk67Fcuo5hOdcSZBCEwoZKFnc8BJid28RKsOo5p+CoKpcKWgvGF4Ix0/xn5fj0huNA7aFOub50BhysrDMCgSkke+AUWmQ1Mu+SGYQPihg3DbcocozJghXkOStBydj+L23BaUcU5rMYV4X4hCSzlJVbNle2ZplRe9KT01DwULc8x+Y5h24WpmNGPXNYtnfiah+KWdAKX0Q/aS6gjrh4/APTjg2
 MaB+B1+X
 xpW2VMwbThejTwYi0V4cNeFpHMC6Tit6wbhHLacLxo4Q9y8RIBPrMKcTq7nQtDDD2nZidhiMnZ/nXfClHc3CooB/gqS1cXCjNq2W9nkRC6hlVqQak9LYIIm/WPczA2gjEcvu9jtdbPi3+RI0xkGWz81c3oLWNhX5lbwEQr4rOm5VXLvZDMRHffLPQmR0UgO7uR04dEI4TGzPQWzi65L0Fj3YmdEqYZ0AnxqGUQEJkrZr5ANNYrvvurOMPWllFLLuFSW8PBBJy4Da6pj0GhMCrD4gCiNhCllbMkRsxPBrw+STrLah4m0wK8Ys4R+9pSwmB6rxQu1z0cQ8QGj0cepyXfiz257NjewcoBC9EN6r0xr/mqj4lSug+7UmvhSePkR1N5KvQicmQ5L0DpCseTl4K+NAQNUZFh2CJfMV6ClhzRr3xR2ic9tyL1790i/kQFx680atNHsjPWrgG/Agtwayyr9rsAo9woWdu33VaQskg1KRFbV+/nQOAC0l80Oq+3xLRgw0bfPJuTAjYVuKVqxevQS2keKh+8CJisNbvu4KvizR2iJDnLpETtEtsJvH+XYRjHq/rC7GzH8RJXQpf5LEj+8Jd57wpNN4tCpJjxh+cvrVW2XXOmpxsnyJS9RNfTn+lfkKo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_struct::nr_pages is an unsigned int, and the file keeps deriving byte
counts from it as nr_pages << PAGE_SHIFT. A shift is evaluated in the type
of its promoted left operand, so those are 32-bit arithmetic and wrap at
4 GiB of bytes, which is 2^20 pages. Every site depends on a cast being
remembered; vmap() has one, two recent commits did not. vread_iter() then
computes a size of zero for a 4 GiB VM_ALLOC area and /proc/kcore returns
it as zeros while reporting a successful read, which drgn, crash or gdb
cannot tell from real memory, and the vrealloc() grow-in-place check
declines a request that would have fit.

Widen the field so the class of bug goes away instead of one site at a
time. Everything feeding or consuming it widens too: vm_area_alloc_pages()
and its accumulators, nr_small_pages, new_nr_pages and old_nr_pages, the
index range of vm_area_free_pages(), and three page indexes that were
plain int. Five casts go. Two prints needed fixing as well, %u in
vmalloc_dump_obj() and %d for the unsigned field in vmalloc_info_show().

No bug report behind this, I found it reading the code. The 4 GiB wrap
needs only a machine with over 4 GiB of memory. Neither larger threshold
is a practical concern: 2^32 pages, where the field itself truncates, is
16 TiB and beyond what hardware can populate, and 2^31, where the plain
int indexes break, is 8 TiB and larger than anything in the tree asks for.
The int *nr cursor in the mapping path is unchanged and is separate work.
Users outside mm/vmalloc.c need no change either; those handing the count
to a narrower parameter cannot drive it near 2^31, and kexec_handover
still caps its own 32-bit ABI field where it did.

sizeof(struct vm_struct) on x86-64 stays 72 bytes with
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n and goes from 72 to 80 with it enabled,
both inside the kmalloc-96 bucket it already comes from.

Fixes: 0bca23804632 ("mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas")
Fixes: d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc() grow-in-place check")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
v3:
 - collapsed to a single patch. v2 put the two cast fixes ahead of this
   one so the series would apply, and this one then undid them; widening
   the field fixes both sites by itself (Uladzislau)
 - shorter changelog (Uladzislau)
v2: https://lore.kernel.org/linux-mm/20260730090628.65814-1-iprintercanon@gmail.com/
v1: https://lore.kernel.org/linux-mm/20260729175708.7074-1-iprintercanon@gmail.com/

 include/linux/vmalloc.h |  2 +-
 mm/vmalloc.c            | 58 ++++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e4d8d0a9f30f9..aed121d729b01 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -62,7 +62,7 @@ struct vm_struct {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	unsigned int		page_order;
 #endif
-	unsigned int		nr_pages;
+	unsigned long		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
 	unsigned long		requested_size;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 26f32949c2f2e..196da8738cf10 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3404,7 +3404,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page))
 {
-	int i;
+	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
@@ -3420,7 +3420,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_dmap = 0;
-	int i;
+	unsigned long i;
 
 	/*
 	 * Find the start and end range of the direct mappings to make sure that
@@ -3493,10 +3493,10 @@ void vfree_atomic(const void *addr)
  * Caller is responsible for unmapping (vunmap_range) and KASAN
  * poisoning before calling this.
  */
-static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
-			       unsigned int end_idx)
+static void vm_area_free_pages(struct vm_struct *vm, unsigned long start_idx,
+			       unsigned long end_idx)
 {
-	unsigned int i;
+	unsigned long i;
 
 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
 		for (i = start_idx; i < end_idx; i++)
@@ -3819,12 +3819,12 @@ static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
 	return flags;
 }
 
-static inline unsigned int
+static inline unsigned long
 vm_area_alloc_pages(gfp_t gfp, int nid,
-		unsigned int order, unsigned int nr_pages, struct page **pages)
+		unsigned int order, unsigned long nr_pages, struct page **pages)
 {
-	unsigned int nr_allocated = 0;
-	unsigned int nr_remaining = nr_pages;
+	unsigned long nr_allocated = 0;
+	unsigned long nr_remaining = nr_pages;
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
@@ -3872,7 +3872,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
-			int i;
+			unsigned long i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3880,7 +3880,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * long preemption off scenario in the bulk-allocator
 			 * so the range is [1:100].
 			 */
-			nr_pages_request = min(100U, nr_pages - nr_allocated);
+			nr_pages_request = min(100UL, nr_pages - nr_allocated);
 
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
@@ -4026,12 +4026,12 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
+	unsigned long nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
-	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
+	array_size = nr_small_pages * sizeof(struct page *);
 
 	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
 	if (!gfpflags_allow_blocking(gfp_mask))
@@ -4525,7 +4525,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	}
 
 	if (size <= old_size) {
-		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
@@ -4554,7 +4554,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
 		    gfp_has_io_fs(flags)) {
 			unsigned long addr = (unsigned long)kasan_reset_tag(p);
-			unsigned int old_nr_pages = vm->nr_pages;
+			unsigned long old_nr_pages = vm->nr_pages;
 
 			/*
 			 * Use the node lock to synchronize with concurrent
@@ -4567,16 +4567,13 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			spin_unlock(&vn->busy.lock);
 
 			/* Notify kmemleak of the reduced allocation size before unmapping. */
-			kmemleak_free_part(
-				(void *)addr + ((unsigned long)new_nr_pages
-						<< PAGE_SHIFT),
-				(unsigned long)(old_nr_pages - new_nr_pages)
-					<< PAGE_SHIFT);
+			kmemleak_free_part((void *)addr +
+					   (new_nr_pages << PAGE_SHIFT),
+					   (old_nr_pages - new_nr_pages)
+						<< PAGE_SHIFT);
 
-			vunmap_range(addr + ((unsigned long)new_nr_pages
-					     << PAGE_SHIFT),
-				     addr + ((unsigned long)old_nr_pages
-					     << PAGE_SHIFT));
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (old_nr_pages << PAGE_SHIFT));
 
 			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
 		}
@@ -5400,7 +5397,7 @@ bool vmalloc_dump_obj(void *object)
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
-	unsigned int nr_pages;
+	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN((unsigned long) object);
 	vn = addr_to_node(addr);
@@ -5420,7 +5417,7 @@ bool vmalloc_dump_obj(void *object)
 	nr_pages = vm->nr_pages;
 	spin_unlock(&vn->busy.lock);
 
-	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+	pr_cont(" %lu-page vmalloc region starting at %#lx allocated at %pS\n",
 		nr_pages, addr, caller);
 
 	return true;
@@ -5438,16 +5435,17 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
 	unsigned int step = 1U << vm_area_page_order(v);
+	unsigned long i;
+	unsigned int nr;
 
 	if (!counters)
 		return;
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	for (i = 0; i < v->nr_pages; i += step)
+		counters[page_to_nid(v->pages[i])] += step;
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5505,7 +5503,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 				seq_printf(m, " %pS", v->caller);
 
 			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+				seq_printf(m, " pages=%lu", v->nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);

base-commit: eee677bbc48890b2bcaa42ea7942478302937a09
-- 
2.43.0


