Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E22DC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 17:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431936B0088; Wed, 29 Jul 2026 13:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BACD6B008A; Wed, 29 Jul 2026 13:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285ED6B008C; Wed, 29 Jul 2026 13:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E24F96B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:57:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EFFA120755
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:57:33 +0000 (UTC)
X-FDA: 85042571586.09.661E8FB
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id CEAF620006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 17:57:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RHJjWzub;
	spf=pass (imf13.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785347851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mhSA5XspJ7J1QMTT+GAfybOgMSS1170SbWNYCpn86sc=;
	b=4zcfBYYql76cmKOfajA9AqaFc4TKPfDmPe1ditycakhCDPdRYmukEry4ec8/9vMn9sF8Ci
	Y9a4ndBHzduJVLIEYi/XKr6/5aTuggDd/S0o02IAJdCZ9Zi4EcLej+lovnrPVCsw+sGzCi
	xuUrGyK+XCdVCXVAp9015fJSdRbw7CM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RHJjWzub;
	spf=pass (imf13.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785347851;
	b=OLGc3NRj8bmr40DjEc7kb3bsXADPcxWauNihH1x9hUD3cp2whW21683eubKCKd30wihtQb
	qlBMOZb1bQTgvF1a59QcW9Ey5hPp9AHE8KDCw8FeHxHQQyyP115f13QQSsvX1JnJ5wb1yJ
	jcd7IbEmMx6hHWNXmEM2MUqHRjPIqeE=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so1156288e87.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785347850; x=1785952650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhSA5XspJ7J1QMTT+GAfybOgMSS1170SbWNYCpn86sc=;
        b=RHJjWzubKzrEeNku7LBpIdEIk+x/KDRpWnz4nEYg/F+mUSK1Zttz8uOTdFYWMaDdpj
         yDWAbsop8FDz8oQLt1TNM/W726+Z1gAzJcJGIGnxrTtT11Aeh3dkYs6On0Bx8rkIcwmz
         WujQdE1EFEXSFoSecp9ZPcoHKBgi0n4Y767Jk6hmXD35jVDhs6OTNJlCF014GAsvLpjA
         S9nwRGsuPmAm/XO2bfrdsdRu4Rs53srEZGM/bbHruSuPBP5ugMjyDGy2l1Se94DMLcaU
         vks53rccHPQ8Ht4//ga9gZrgSsaOj867aqSKGyUFBYHyxhsvEFzo7WPOpWXe+0fDsWwF
         dRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785347850; x=1785952650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhSA5XspJ7J1QMTT+GAfybOgMSS1170SbWNYCpn86sc=;
        b=Tal4XmIDmq67OzcFVbp2QVtdaFJzNfjFUudk5hEtlzDusXoACgR/3MkJLRRjxJpPaR
         6Ibx91aDbvsYPQ/0M+fd3Yo09Qc8WCxwDyPk8g6lRs6EBfI5K5zhb+W7hmZemLUEOtPd
         xZUvsp/KPJazahWxctvwoi6Xn2kUsWKflei9HTTp4wtWTF10rKEU30MckM82wdbTX06z
         2/4s1v3OtBF9a10W4AgI2WAFFqHoMR0XA/Jhm1hVsv9EM53EWwLa2iqlG+q02Ko/YBSW
         Q9hId+Zq15BzLur00O0AAa0emZcYGclD3/HW5dyxwZuorxiosa17+XoylE1yWR7Wz6sU
         bgQA==
X-Gm-Message-State: AOJu0YzUz29gBR4mb2OudYUncWWKUHrDQh+MuY8Rp4k3ZSN06Cx5puy+
	4YhxUF5xqJ3Gsg0bZV+xKoQEkxSx2YLDZdVjZP1WMi9NoaEI66Uiy+ZlIHaQnw==
X-Gm-Gg: AR+sD10kka2H87odqJkhOKpBmTQMcJ2xAC/3PE4Zcc9dtxYixog8+tzJWy/O6ZxmuK9
	tM0JqVcqpia58GvclXeIaNVKRF2EF5dQ7WyQzTq/Osml6/PoTnDeaXf2FJ4G+WvQ1GsgoYoaAoK
	TPMOelfrDVPZ/E0ovZJpqWEj6lN/YcJnNGkkvjcdbU/iVt/1qg2fxmmOSde8e34O6INdcp2xykj
	FBKl2gIGj3XWe0Sm8t6K/zR24cqYu3VdaHFBezhM/mXJlDvvcs7ClsgeF1VHwjW6StZkPj5M+si
	2ET2b92kZXSji7T5mLn31RlIrh2UmtgTNWsoloMt7Aj334oWM00ri6LGBP76qWZXC6ODFjc7fJ0
	jruNW+4R38ZCKwDTSmb938CRa3hkHxvHHmBCh7FvKwapANwJVFpTOZuitQ8dEm5EbdkSQlmpQFG
	F1BBlmSv/LTKkiZSr7mdwqJqVcdATzrUaHSUjWmo7jzNFsWMvWd1AxSQ17TsDrAVPvFet+AM+k9
	PA4hbRhdldosgVpw3l3b4TG4vPdIYPczk3TRNWCGuxyv9rnOVDA82xinQ==
X-Received: by 2002:a05:6512:3d21:b0:5b1:568d:971 with SMTP id 2adb3069b0e04-5b2d025dc53mr1561787e87.49.1785347849754;
        Wed, 29 Jul 2026 10:57:29 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2d78eaa08sm507610e87.54.2026.07.29.10.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 10:57:29 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Wed, 29 Jul 2026 20:57:08 +0300
Message-ID: <20260729175708.7074-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CEAF620006
X-Stat-Signature: w99nyjnbpdcf3pb9acara8bz7ds6hbfj
X-HE-Tag: 1785347851-295572
X-HE-Meta: U2FsdGVkX1+NeB5y2CYhcQqU0JFndlXfhBKYWM3jTOUhJwbDrLQUdOvZBp6GWeis4Hswhc0+7mKbEc2jO2z/2+etSeBAMR+7s6Ve++UGNx9jTfG/Z41xZwlLzg3KnHbxIBIH3bUpkRlDKkYmdCrdAPL6A6FIeFUVnItMl6P5Jx+zAgNzXrkBxdOWl/K545gIiuA/WPrwLPhXKfCz8R5IkgkmviA/IxMfX11QMqyUaaeCCD1o1fdlMWxsyLgRtf269f3PhYudmxUH5HtUAlxZTAb6R8V2kppOdU1TIM4V8GZ/a4nBEQt2yWIxogxNq3DdtWt16Nes9PTqWlW96kBoS9cPdblMrWowTPwhBZaBRl6BKwxvN3fktvM0/2NCcecSNhlwk8Bq8JsZfBEWM558BVlFcvVD87lg5RFZpY2NBfTZUHNc+78plpzoLDs8FXLf2C7SDwvnTX4VFa5NFtpjlAIPZUV0Eopdk4YtI9T0vWp8KewYq85weAj+uqY/8MgUYmrO6Y2OcxCu9CHHyeZ/Z7Ni3vr4NxdJRZjXG/8ZJYOfVPlH4hTKPOsf84tZzwmg9A0yc/gOUzDbWcSR2pCNA513oEk09z9DhkHXBNuHyNtPYXz+Ikvj/z0keDc0Q4qOlB4JIPCt1qgZlPBDBQfVDq/g3zLsmulPdDrL4hqshJRNBC6b5nofmvWKD+ewKaHLpzcnSQcCVmvhAPXdQSRrkjWNpcTkBvPE3DuTTYdHbSPGP/K2ewVglgaVMV2J+ZI71sXDcy4QOu8UdqTeAXkjO2x/g0WmxyjH3M29qdhTzFSgNcHgtENOXOeJApXx3TZmB3EhiIPjDJMztoYjrBB9/qCK7xp4MFWZxudN5dYmQQJk0OMqMLZfg1nheTi4lJfHaYdVx/zkKn2gWxmlsFpx7Vcva8pANx5lSddLdDhGz8uq8VB+WE1YTawSMTUHPn2a4tuztSs7MVafJTTwcxG
 IiEoprcK
 pS4BOnOF89d2Mcdlgor6gr4bmUdravNa/v8aIrrVLGG+B2v6cWK6HxccNc2B1ZAW0jhe2/eO+fGxgqVsHYKKgYxitUAda8gGtfEc8hLQkpk05bBi3ejSrLAJAaruss8r8ejDrUmWKbPW2lEbbWoHFHBs/lj2RxNb2SOf1jFt2y9yhuTib5Fruj/MBF694Ilf56BVdRoZrsTZZLHbyCy5Ka9RrFi5VIY1scrdF94HzmkGZWFvMAffd7iQjRRNuER3I9mZYuQF2R0GtsaiXFwU0e5aX1g7nh/IOMw8PCRSaZsr51d8CvpeFEoCosGkLakY9UBlWAQoHy9U7HUFAMz6kMOXam2nc2DkwCAqDElaPOeqcx4JJwHNJobDvqBD/4KZ2BBEH7z5F8gD664k9Fy404iFEBEsw/sfS5MNl8QTNCFj+ZGjchcpnT0ttkCrgK2W7Z/aEBC/EGI4kneqrKbGNCgH0KCsFnXk6M3e2SoORLY3+g6m8+edUMv6xPlRi4JjaR8lKxvUp8e2rgFY74OMbkAx+rsebkd/2ZNU+kiF5h9GnfDYddlXpXzgG5IK/FGdik1zO121VSWvWS+1NG7or5WGLRzHGAek8HjRByOSutgnwxGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A vmalloc area can hold more than 2^32 pages, but the page counts
tracking it are 32 bit. That has produced the same truncation bug twice
already, once in vread_iter() and once in the vrealloc() grow-in-place
check, and it keeps the casts that hide it scattered around the file.

Widen the field and everything that feeds or consumes it, so the byte
counts derived from it are computed in 64 bit arithmetic without a cast
at each site:

  - vm_area_alloc_pages() takes and returns a page count, and the result
    is stored into nr_pages, so its parameter, return type and the
    nr_allocated and nr_remaining accumulators widen too. The 100 page
    cap on a bulk request stays narrow, only its literal becomes 100UL.

  - nr_small_pages in __vmalloc_area_node() is derived from a 64 bit
    size and compared against nr_pages, so it widens as well. Before
    this the store truncated for a size of 16 TiB or more, which sized
    area->pages from the wrapped count while __vmap_pages_range() still
    walked the full size. The cast on array_size next to it was already
    redundant and goes away with it.

  - new_nr_pages and old_nr_pages in vrealloc_node_align_noprof() widen,
    which drops the four casts on them, and the casts added by the two
    preceding patches in vrealloc_node_align_noprof() and vread_iter()
    are no longer needed either.

  - vm_area_free_pages() takes a page index range.

Three loop counters that index area->pages were plain int and would have
overflowed at 2^31 pages: in set_area_direct_map(), in vm_reset_perms()
and in the bulk allocation loop, where the index is seeded from
nr_allocated. They become unsigned long.

Printing needed fixing in two places. vmalloc_dump_obj() used %u, and
vmalloc_info_show() printed the unsigned field with %d, which would have
shown a negative page count for an area of 8 TiB or more.
show_numa_info() used a single unsigned int as both the page index and
the node id, so the page loop gets its own unsigned long counter.

The page table walkers are not covered here. vmap_pages_pte_range() and
the levels above it carry the page cursor as int *nr, so a mapping is
still capped independently of the counters this patch widens. Widening
that cursor touches the whole walker and is separate work.

Nothing outside mm/vmalloc.c needs a change to build or to behave as
before. Those users either index the pages array or multiply the count
by PAGE_SIZE, which is unsigned long already. kexec_handover stores the
count into a 32 bit field of its own ABI, which caps that interface
exactly where it did before.

On x86-64 this leaves sizeof(struct vm_struct) at 72 bytes when
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n, since the existing padding before
phys_addr absorbs the change, and takes it to 80 when the config is
enabled. Both sizes come from the same kmalloc-96 bucket that
__get_vm_area_node() allocates from, so the footprint per area does not
change either way.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
 include/linux/vmalloc.h |  2 +-
 mm/vmalloc.c            | 62 ++++++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index d87dc7f77f4e8..a39c20c77efcd 100644
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
index baf7e396e3fc7..efd5e42c64e2e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3338,7 +3338,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page))
 {
-	int i;
+	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
@@ -3354,7 +3354,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_dmap = 0;
-	int i;
+	unsigned long i;
 
 	/*
 	 * Find the start and end range of the direct mappings to make sure that
@@ -3427,10 +3427,10 @@ void vfree_atomic(const void *addr)
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
@@ -3642,12 +3642,12 @@ static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
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
@@ -3695,7 +3695,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
-			int i;
+			unsigned long i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3703,7 +3703,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * long preemption off scenario in the bulk-allocator
 			 * so the range is [1:100].
 			 */
-			nr_pages_request = min(100U, nr_pages - nr_allocated);
+			nr_pages_request = min(100UL, nr_pages - nr_allocated);
 
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
@@ -3849,12 +3849,12 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
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
@@ -4352,7 +4352,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	}
 
 	if (size <= old_size) {
-		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
@@ -4381,7 +4381,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
 		    gfp_has_io_fs(flags)) {
 			unsigned long addr = (unsigned long)kasan_reset_tag(p);
-			unsigned int old_nr_pages = vm->nr_pages;
+			unsigned long old_nr_pages = vm->nr_pages;
 
 			/*
 			 * Use the node lock to synchronize with concurrent
@@ -4394,16 +4394,13 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
@@ -4415,7 +4412,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= (unsigned long)vm->nr_pages << PAGE_SHIFT) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
@@ -4722,7 +4719,7 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
 			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
-				       ((unsigned long)vm->nr_pages << PAGE_SHIFT) :
+				       (vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
 			size = va_size(va);
@@ -5228,7 +5225,7 @@ bool vmalloc_dump_obj(void *object)
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
-	unsigned int nr_pages;
+	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN((unsigned long) object);
 	vn = addr_to_node(addr);
@@ -5248,7 +5245,7 @@ bool vmalloc_dump_obj(void *object)
 	nr_pages = vm->nr_pages;
 	spin_unlock(&vn->busy.lock);
 
-	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+	pr_cont(" %lu-page vmalloc region starting at %#lx allocated at %pS\n",
 		nr_pages, addr, caller);
 
 	return true;
@@ -5266,16 +5263,17 @@ bool vmalloc_dump_obj(void *object)
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
@@ -5333,7 +5331,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 				seq_printf(m, " %pS", v->caller);
 
 			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+				seq_printf(m, " pages=%lu", v->nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);

base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
prerequisite-patch-id: bc462c518eb9ddcaccad5e1f5fed7cc24512b117
prerequisite-patch-id: 891688c2e93c570d1c9c7802b46aaba974002684
-- 
2.43.0


