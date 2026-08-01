Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BEDC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4346B007B; Sat,  1 Aug 2026 07:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4A96B0088; Sat,  1 Aug 2026 07:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093276B008A; Sat,  1 Aug 2026 07:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5C346B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:49:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E3BD1402A2
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:49:40 +0000 (UTC)
X-FDA: 85052530920.03.AB0411E
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F32C1C0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:49:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+y3Zwgt;
	spf=pass (imf21.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785584978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwR5JXqTMN9zli8Uq7BFLpMJ0Xr4vtGnZsa0PqHGYFY=;
	b=4hYVHxs34LiTbI2WPq95FltmuwAgzdPHgdqyIi0w+Yo1a8/99f8VqkCtagAV0zWcGT0xoC
	9cDi2OVleQBtvYBoR6+Y+fVW1L2g/gx6EzsQ28pu7SFnemCGUJdePR6QGt7dXnn4mLa14b
	RVX/WdAAMVenWV1uQKyUSyobd3R4FPk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X+y3Zwgt;
	spf=pass (imf21.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785584978;
	b=HwjieYSqVdB3mZMsdxbV31/dr+PIxGD6683u7sBQhgEdKUiFMCyNqOh8OQFFp9wMaboUBM
	LgkYWuFfCVc3U63A7RPJwL3ok2tw5TndJtPNWOuQ3sLX0JJPcpwK3JeyzXY8GDCtzE/jE0
	s0VelAX0IMm2hNrV0Sbtjql6FC7OyQA=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a44a3b66so1904598e87.1
        for <linux-mm@kvack.org>; Sat, 01 Aug 2026 04:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785584977; x=1786189777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZwR5JXqTMN9zli8Uq7BFLpMJ0Xr4vtGnZsa0PqHGYFY=;
        b=X+y3ZwgtjhPjrA7B8oelNuPJrDdll8GNpSf51SvWDNGPkamjNeO0NIJRsj0nETPd2a
         DALgS7v8N0jtkQ3IBIvyj2BJYlXa2hh0X8FxIU2iI4Xv8kBgZ9YpQrl38svMrgqa9wO8
         /0Hf5TtGLy2ucJmU2jETB/ZgjUvjhWK2jCw0Dx1lbrfUkoFIIl6HTOmnPVOztqhHWnaM
         G0f8To80vtVSPCkLXDRaIJqhIRizoFVX0H5rnffGsr2Pmo3KrZFdcRAuJ9aMy+iQ5wQd
         X9qJrGRLKH07gpmxTjK19U+wdjcPN/O2rMPmeo71S+wg1jJp2elRdmWYrPubUCWGwDWH
         P42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785584977; x=1786189777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZwR5JXqTMN9zli8Uq7BFLpMJ0Xr4vtGnZsa0PqHGYFY=;
        b=SncdZrUWUdoVxmOKyGeA5ZU1evGQq/Zk5kv1rxSF/Zr++899n68oDsihKpWvri2+rR
         OILoSL1nJn77jnFjBYij151dj3hahfyguZygzNfXPh2PfC4CAZLLbQl1OKGJIgrDBEqI
         VT+PJPXeRqGFvPXqi74rs9Yv934KQlVksU0sJBkFuqJNNenXFGOwSrznloFH2RC6BbzU
         qXhgxjeO8tjXMkGQxmcfr+MU5PahDUUgS/A5k7zMERKLGlD6xnPZMPMHE0MEcblYcstq
         xJPB9q6iN6sFO6tntXNYN8vGkLn4SGCXAZH5n3OO/lMqfvBTpiPf2wSSXg+2EGYbuWNE
         PzAQ==
X-Gm-Message-State: AOJu0YwpaTcAMWMnYAWtqsBcPGcCZNRGCG/7azGnCoHRqOxT2LG1MflX
	bPeam8CHFMlQlQP1Bhw6kkqy2564QhEUAjbLULhS05QuAKuBOAu1ovqxvp3t4w==
X-Gm-Gg: AR+sD13YNDFMQHCrW2L9Ce2LB/aUwsIoFz14dsSmrwEr15Z0J2UThCRPIiyNctSQn/r
	4JjGrTAaEbqLJfrRazpakw4SLOuJ/6IkcyiUTdX0ZKO4VNOBahs6Nz+Tri5KZsCqhWmd8FU29x3
	TH4O/x9oB6q/lSlBqpt2TFQiln7ENOpXE4ZdH2SFZAThmnQZO5JDnqInPTf7oqKA5573wDiFLBv
	JNGcsGR0WpvalXBSmIwTO4IUPXvM4QpYtCB9nqjZR9fGwgQeoJWu/3ZHUF7gGBBlDNDbYaMSMLy
	iqMbSuHA1Wx1Qy2AfHIu5ihcnxn5B/qSAIJ8p9jsjnxMpY0oHrfbYzuhtaCAf4WX90vWVbOmFhn
	Pao4BqqX51QQXNt4p4MKJDWbmbDtvv7fxXlgj+4DsvWLD3l4Z3YPBJLB6G5LcE6ZNbtRz0hvPCA
	ZvbptLYLyFNzW/GHxEcblfNn05nYEuvJgnvcl19IgX96CSzLCqiDgHy6m31R18zJtoyltLjzIyi
	Z3/NsiuO2wUjSOr8c2KHEZTqDiepNeYKvw3XMi/6MYi7n/Hz0wwDtazxQ==
X-Received: by 2002:a05:6512:2347:b0:5b2:9f7a:29aa with SMTP id 2adb3069b0e04-5b2e4bde7dfmr721283e87.0.1785584976590;
        Sat, 01 Aug 2026 04:49:36 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23cb4e6sm893160e87.22.2026.08.01.04.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 04:49:36 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Sat,  1 Aug 2026 14:49:15 +0300
Message-ID: <20260801114915.115224-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
References: <20260730130923.9e71be5f477ee3db333cf0f8@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F32C1C0003
X-Rspam-User: 
X-Stat-Signature: pou9cxunabkdpf3bbpbbdg61eyiaif3p
X-Rspamd-Server: rspam04
X-HE-Tag: 1785584978-989017
X-HE-Meta: U2FsdGVkX185xAUEYhTNSrJyL24B8Q3yknPLiyowK09wGQcQc+v9EbTM9DkblkpsZTinJZmwrjtEmnH/rht6EwMjnje9iYanMxU5hYw3K+vRpHcNxdjcSSAhJYZa80IdQeOij6uERwT3tFbD6GHltWc8yCfRFs1mDUygo2Tf9mlcQFgVXqiH6ZqILAnrOfsqgLRxyMKWJWRUdpIH+vEFHqJDluqgmGRH+SftfWKO6Fvu/mjPxBV1B737MJxlJDSS6KOB7eIQDnbgMJdJlZzjuOuL+Ew4Qj7Htu2gqJ+bc0UMqhHtLAqoQsSSPsipQbHDy5Nz00t+QQo/jq1Qjm3Z6q4g5RS2QjSitDsQpLLWtwxeIxnD/pXNykpsPcGGI1b8JzR/0OJ17MotlthwkW1U2P4ojmLfNCbnBXAMpIsWDJaSfRSmtnrGsF99lXzvzCgpICU7zLCTwH/AnpPGT/HOB5VNYeatwIetU0v51pTYnkIDQGoGqkLb0OYkfRtax3toIo6h+shx3zdKhulss9ffhb7woinwzG9WY8xhE1llL45OUfg0sbPqIuzsrZtVuJZGBo3VEnS6dIfVVBye1eljj+RHHjlRtr+tjJgpWyBoGrWzqBMSUqniNQgi56/+ZOEwl7+xEVttKEom0kmLKOqM4cAIqsHFgexlg+E01b0XEF2PfzdtaPILBSasN6yWuDbrjKNi5z9XoHoT3s7F7tzVMC2oO2YdMSgje5wj1soiPXSOpce8sy6oMm/kFpseSYqbpDjC6/Qyve1CHhUomumlfNNWowVvO3s5zVGkTBC4+a0vAUHS9WUC4QP7T25WfXlC1X0B1CNLKRN9ExswSmipxk59J//qvo6a1omYT69hpZ2dQtswzxDsVlMvLRUQqsCybJVQu1mYJdArfbEaqMXS8Z4insjbGNidhsABFEMZYL6RwYXtL8vO9SP5hgvEmRYeO1WGTgLcA/UTYQzDEWu
 iiCFRbY2
 VyGHojNtWr7mRJRxYDrfn3bzK9xujdPhWhdVrR6hAaKDoleLLulDol0hpPj9Pim4o/M7+mje+RmvfFMOxMwiYrRu0VwKiEBw1Ht66JcLpIwRwUOtZ4Nyn/m0jv/rtkFLPUEK0oaWHySHHt6FwOQQgSKDvCgNA5F024ry5J2A20hzERljNk3aIgxwsSXf5abGQ3NzR7yku023TfYNmhJPTBdI4AmrySNUkUmYetWXiEaVOVVA8OSWQTrwMAETC/DuisfsOpkn4wKUHT0WfmOPrZo0ZHL3ZjJZde6sQcqiwAREPrKB1ZJXKyCVPGfJsi7UeAsQ9g247Ltig232R/ezpSrK84gCQKIPPS52kChshB/GdI1ER6h4NaMpdw59jKRCrRaQQhR4lL7TR0fCWoi5FciIfy6+bWGrYpdKizQePZfUETt+4DHlXWUdOiVVs8ip2ZU9Ip5mJzBtTp6Hl8HPlGA3Yf8OijSTA8wJeIaB05ZfwfJIQVRU+G1sLnxzTmrbMIpIbPxlQwJftucpaUws9ej6Bmg82KCuqG39sMBpgx1MJCTzhgUHcZKqKhn4/yWFTcjlagWTLE7Kyca6/7jYv1Oeq/qQAqahpvPli0keONyV4/MkUNb1IaRkPLsMXHDATohH1
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
Users outside mm/vmalloc.c need no change either. Those handing the count
to a narrower parameter cannot drive it near 2^31, and
kho_preserve_vmalloc() stores it into a 32-bit ABI field that still
receives the same low bits; above 2^32 pages the truncation just moves out
of vm_struct into that store.

sizeof(struct vm_struct) on x86-64 stays 72 bytes with
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n and goes from 72 to 80 with it enabled,
both inside the kmalloc-96 bucket it already comes from.

Cc: stable@vger.kernel.org
Fixes: 0bca23804632 ("mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas")
Fixes: d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc() grow-in-place check")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
This is the single switch-to-ulong patch you asked for; v3 crossed with
your mail a few hours earlier and was already that, only without the
stable tag. So v4 is v3 plus Cc: stable, rebased on today's mm-new.

I left the second Fixes: on d57ac904ffdc as well, since the same widening
is what fixes the vrealloc() grow-in-place check. Drop it if you would
rather the backport hang off one commit.

v4:
 - Cc: stable (Andrew)
 - corrected the kexec_handover sentence, which claimed a cap that is not
   there; the ABI field just keeps taking the low 32 bits
 - rebased on mm-new
v3: https://lore.kernel.org/linux-mm/20260730171142.76817-1-iprintercanon@gmail.com/
v2: https://lore.kernel.org/linux-mm/20260730090628.65814-1-iprintercanon@gmail.com/

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

base-commit: 1dbd7c34bb92dd9c0b0363b75f6ec444299af108
-- 
2.43.0


