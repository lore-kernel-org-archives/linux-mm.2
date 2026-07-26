Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F82C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984286B0093; Sun, 26 Jul 2026 18:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B756B0095; Sun, 26 Jul 2026 18:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870706B0096; Sun, 26 Jul 2026 18:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 407306B0093
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB5481205D1
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:27 +0000 (UTC)
X-FDA: 85032355254.01.7E26021
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1C944000E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="GnwFk/NQ";
	spf=pass (imf11.hostedemail.com: domain of 33IhmaggKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=33IhmaggKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eB8OI+MlZTz5D3APUhcjArQ/zs3ia39JBatnu9AogOs=;
	b=ZWceT6FaczHNN7MgKko/qn538o4QgZ3TbzetC7sFLV/5r8VqRSPPDnsI1ioSbaUDXyHDgV
	EDooccGaBaCHgU49KXCODe0GpcZq5vK0Heu+jFwrFv9TvNf6Yaq+OO/+iO9faNxgcJRsbl
	p+ThnelkfdVz6Pt7SKsu5hwl8s1QmT4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="GnwFk/NQ";
	spf=pass (imf11.hostedemail.com: domain of 33IhmaggKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com designates 209.85.221.71 as permitted sender) smtp.mailfrom=33IhmaggKCOEMDFNPDQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104605;
	b=3Vu7dB+t3t+vGmBg4bprmZOUZM9o3Mtu4oszi6svLWikTrsGWmOXiuACg2f2DsFXXpzPHC
	uv5kRoGbcBnGmT2kX3RW8HfwTGOQfMsZi3K+ln05VeXRrKSNAUDeo0LO3hrp1s1sPvHzh4
	WIeh/GkrIa/ziOybhHPen+uC4ddoDJs=
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47f6d70223dso1304585f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104604; x=1785709404; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eB8OI+MlZTz5D3APUhcjArQ/zs3ia39JBatnu9AogOs=;
        b=GnwFk/NQF6aq/PdgQaLBp7ynmz+S4JtM7jLCgug6s4XVmqqAi7ZdRSzxc53od+cjuu
         0geE4drXUbqDIwbOHAoeWO8jbDJlIyDjiH8/IVArreJTzNnOmp15Vmot9jfVbjUqwQQH
         FZqt+2GfRZ2WVJuy+e5msidsUYP8rp9q4bDU6Hox+t2wQmKxD1/7SFDhYs9EzD7JWF76
         9/gN8D1SSPO1FXnZQoqD9/kICNzp3pdqJ8klfyfEoH0kZgHOq1DpcqShsBG0hNYOQPpi
         nM8Ak2wGrdi8QsHPbLICo3Y5qdakgdAnCYW8TP/asWHhsCsyQWlGpMwqrP3WUS5LgzYz
         DHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104604; x=1785709404;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eB8OI+MlZTz5D3APUhcjArQ/zs3ia39JBatnu9AogOs=;
        b=ky+byYsLZj6yNVp6LCi1M6elUCn8MD5PtZP9LWE4jJ2fu7mNaVGYrgPBI++YXWteBk
         pO+JY2B4TX6QzT9DFz7hdusB2zr9nZuXouZPQISyt8e2JTMf2xDwaws9cUFIYiBncnSZ
         uLe9eQTNJYXfvgORgxbhcPwY3nXn1BfmMauEumCKpUDNbaSJclr3Oeojqb3MlcmXul4p
         uPF1oHMwG6nAC2KUNZMPMIxSAg8rPrR/QuivaoWLMzuIV2bcmyjINzB+q78frUY0R6Lw
         kVsxRI/BmT0xnqnwI1O0q1mqOHjNqr42ZR6mRZ2IV42EvAkXZN4OfFgGgbUqzbz9tzQG
         DMFQ==
X-Gm-Message-State: AOJu0YyYNh0SmxA1vHmh6CRCx/BaqgSzekGX94Rmdt0TbBFmHVO5lU+2
	Be45dUJL+qFAEaH/s9njCadm6Nmq+Z+VzwV+ZxiMv6IJuWP35OvZ+PVBwSRumMkFMtD+jn+UZtt
	MDsT3Jf34LqKFqw==
X-Received: from wrvi2.prod.google.com ([2002:a5d:5582:0:b0:460:2d58:857f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1887:b0:47a:b86f:3ed1 with SMTP id ffacd0b85a97d-47f9fc8fa65mr7892542f8f.21.1785104604220;
 Sun, 26 Jul 2026 15:23:24 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:36 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
Subject: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D1C944000E
X-Rspamd-Server: rspam01
X-Stat-Signature: cdx6k9xiz77t6iub7dx65iqaoyp38e3w
X-HE-Tag: 1785104605-602183
X-HE-Meta: U2FsdGVkX1+OOT4GyGdpg/F+0alP6d+Q7cPuaR7sybv6RgKBghAFYMsr0JGcWC56rBaCUlTgURsLJd15Z16MHmT5Z5AviK0LI9nrYjpkUFsb/sr0JlsLP+WAUNV0N8uuuyPixZP6GANQuukUIete0xA67LY+mZDOFnoQCyZ+6FnSJRKffptybxPc/i3b6kacZiW9P9nHKppKHlC8PLUFWIq4NBk37UseWMk7OlaXOWlcBdXdJXPwzp5rtVvWosItCf1l/xYBN7Vg/wUempc7XeSTfR11T7sUHA60MTIu/MQ11r7ZzkeBgY+TZRew5EShbe7SIW2OxvATzaKvW8f3RbpGEpDUVh6juq6XOYPP3w4Y7Q1kyq0o5CH7Y/24KrPXt6gt40hpfRY8bChN3flo+wAgzP4DJOBZS1mfL1dQov83z4RBZKsBrbIUFQ19jyHf6lNiHGKUbkRRxS+ovvCVAF033e6wIcz033cv+t6QIwh7cMKNjoXU/BaJNYxhKDcleA5orqsmgE2L3QX91NjGx4lR+tunT+oA3sF2vroNVvww7hlq6GhDweP0ZktLuP1cEqINDDMUH9Gnv6obEe1LpKyoxTb9sPc/AcAsJHgKsfjqHndLCDWnPjjplsryMQmyPDJnhU1j3N4oQ+v545jm5CuFYmR2ET95SrCjmgLXg+TQBBLRo1YyS198AlxBmYzQN2fhrtKMxdwSk/OInpki5y6VCOtzoFUxymb2pHOSCZ7uZPcfOZmhyo3OE8eTwcqgYblgcGlUTqNkUhz2ZqWO82eVLTKGkGjR6dLqYKuHi3RjOU60lWDjXiArvynWZ0Vokp3CVBdlAbSJxip0+5jbSIzXaN7sqQtyUO4fAiG534wOdCqKg0iJS07Cpgpp8PGAH8AjXFDe22dOhRNFBqYgMEtilpBEdJ1ao2DZjYo23HhpLhNKXlW3FrxVtVJslEUU61vVwAG5+NsiUaPpbnL
 j3Z8tUkY
 9U2ILI5q76bSwNaEbroLveFdACV+ALlBWFkMHNVNUJ7s4GyGiyaXpWk/9IFciE/+kaBoFynPxopD1NXrbWePTAfLtoYJwWazoBDjvJd7W079b5txlGtmFnNYca9oOgOF8KI7uoYu0BvAU4PKxigEYuWYqZ2pjNEt59hc8/D4wozT6wLwMT94xWcvFyyZJma4CXxKrcadhG5kheH4LCJzOPRhVTeDI90FhrGKMBYrvnVCyJ5/Pwbt4jJe4S4izHJIcvQHcxn92nUnz4fuM2ny0fUTTATeI8iUsc8a5+8lxwxsMpWJ0UyvvuMM4dhwMwfdy5vBuBWBKYhBIZzYoqMsNuYWxPArkXbNHJeVunXiL2L8CIchvewV5MR9iMzfSyyAlfiXjVIoXaS9eYgl4zFRAX6EmJ/eTwg9KHA/DjR6Knv1zr6FlXXlmppeiKFJwGC5fooOPV/05LfMm+8hQm67vmmJp2M4zg/mZBKE9UqN91s0aa2vOxEO29Jeq8z/7CJe6yE+vzWPkPtOXkIv3hyFZJkaLEjg+KfPLnlMd32gVHk4eQhbt2oErJ845Rx842XlWXQ9FKQWU5AxszgOSdwqYxC7fbDXMG2AqOWc4NB+TwI84/wg0OtEvoGzN5TyjLRoQm+lOmN5x7ucELF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>

Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
set to not present. Currently, mappings that match this description are
secretmem mappings (memfd_secret()). Later, some guest_memfd
configurations will also fall into this category.

Reject this new type of mappings in all locations that currently reject
secretmem mappings, on the assumption that if secretmem mappings are
rejected somewhere, it is precisely because of an inability to deal with
folios without direct map entries, and then make memfd_secret() use
AS_NO_DIRECT_MAP on its address_space to drop its special
vma_is_secretmem()/secretmem_mapping() checks.

Use a new flag instead of overloading AS_INACCESSIBLE (which is already
set by guest_memfd) because not all guest_memfd mappings will end up
being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
can be mapped to userspace should also be GUP-able, and generally not
have restrictions on who can access it).

Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
[Moved zapping to page cache; removed review tags]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pagemap.h    |  25 +++++++++++
 include/linux/secretmem.h  |  18 --------
 include/linux/set_memory.h |   2 +
 lib/buildid.c              |   8 +++-
 mm/filemap.c               | 105 ++++++++++++++++++++++++++++++++++++---------
 mm/gup.c                   |   9 ++--
 mm/mlock.c                 |   2 +-
 mm/secretmem.c             |  46 +++-----------------
 8 files changed, 128 insertions(+), 87 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4e8b2b29f6d3e..011f6e34859cc 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -15,6 +15,7 @@
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
+#include <linux/set_memory.h>
 
 struct folio_batch;
 
@@ -210,6 +211,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_NO_DIRECT_MAP = 11,	/* Folios in the mapping are not in the direct map */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -345,6 +347,9 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
 }
 
+static inline unsigned int
+mapping_max_folio_order(const struct address_space *mapping);
+
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
 {
 	return mapping->gfp_mask;
@@ -366,6 +371,24 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 	m->gfp_mask = mask;
 }
 
+static inline void mapping_set_no_direct_map(struct address_space *mapping)
+{
+	WARN_ON(!can_set_direct_map());
+	/* folio_zap_direct_map() doesn't support large folios. */
+	WARN_ON(mapping_max_folio_order(mapping));
+	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool mapping_no_direct_map(const struct address_space *mapping)
+{
+	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
+}
+
+static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)
+{
+	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
+}
+
 /*
  * There are some parts of the kernel which assume that PMD entries
  * are exactly HPAGE_PMD_ORDER.  Those should be fixed, but until then,
@@ -454,6 +477,8 @@ static inline void mapping_set_folio_min_order(struct address_space *mapping,
  */
 static inline void mapping_set_large_folios(struct address_space *mapping)
 {
+	/* folio_zap_direct_map() doesn't support large folios. */
+	WARN_ON(mapping_no_direct_map(mapping));
 	mapping_set_folio_order_range(mapping, 0, MAX_PAGECACHE_ORDER);
 }
 
diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
index e918f96881f56..0ae1fb057b3d2 100644
--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -4,28 +4,10 @@
 
 #ifdef CONFIG_SECRETMEM
 
-extern const struct address_space_operations secretmem_aops;
-
-static inline bool secretmem_mapping(struct address_space *mapping)
-{
-	return mapping->a_ops == &secretmem_aops;
-}
-
-bool vma_is_secretmem(struct vm_area_struct *vma);
 bool secretmem_active(void);
 
 #else
 
-static inline bool vma_is_secretmem(struct vm_area_struct *vma)
-{
-	return false;
-}
-
-static inline bool secretmem_mapping(struct address_space *mapping)
-{
-	return false;
-}
-
 static inline bool secretmem_active(void)
 {
 	return false;
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 1bf2a15bca118..0eff85b6d3980 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -53,6 +53,8 @@ static inline bool kernel_page_present(struct page *page)
 {
 	return true;
 }
+
+#define can_set_direct_map() false
 #else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 /*
  * Some architectures, e.g. ARM64 can disable direct map modifications at
diff --git a/lib/buildid.c b/lib/buildid.c
index c4b7376406215..ba79bf28f7e69 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -47,6 +47,10 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
+	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
+	if (mapping_no_direct_map(r->file->f_mapping))
+		return -EFAULT;
+
 	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
@@ -87,8 +91,8 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 		return r->data + file_off;
 	}
 
-	/* reject secretmem folios created with memfd_secret() */
-	if (secretmem_mapping(r->file->f_mapping)) {
+	/* reject folios without direct map entries (e.g. from memfd_secret() or guest_memfd()) */
+	if (mapping_no_direct_map(r->file->f_mapping)) {
 		r->err = -EFAULT;
 		return NULL;
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 08cb1efe665ac..341c7c5b28bc7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -14,6 +14,7 @@
 #include <linux/compiler.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
+#include <linux/set_memory.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 #include <linux/capability.h>
@@ -239,6 +240,54 @@ static void filemap_free_folio(const struct address_space *mapping,
 	folio_put_refs(folio, folio_nr_pages(folio));
 }
 
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
+static inline int prep_add_unmapped_folio(struct address_space *mapping,
+					  struct folio *folio)
+{
+	if (!mapping_no_direct_map(mapping))
+		return 0;
+
+	return folio_zap_direct_map(folio);
+}
+
+static inline void prep_remove_unmapped_folio(struct address_space *mapping,
+					      struct folio *folio)
+{
+	if (!mapping_no_direct_map(mapping))
+		return;
+
+	folio_restore_direct_map(folio);
+}
+
+static inline void prep_remove_unmapped_batch(struct address_space *mapping,
+					      struct folio_batch *fbatch)
+{
+	if (!mapping_no_direct_map(mapping))
+		return;
+
+	for (int i = 0; i < folio_batch_count(fbatch); i++)
+		folio_restore_direct_map(fbatch->folios[i]);
+}
+#else
+static inline int prep_add_unmapped_folio(struct address_space *mapping, struct folio *folio)
+{
+	VM_WARN_ON(mapping_no_direct_map(mapping));
+	return 0;
+}
+
+static inline void prep_remove_unmapped_folio(struct address_space *mapping,
+					      struct folio *folio)
+{
+	VM_WARN_ON(mapping_no_direct_map(mapping));
+}
+
+static inline void prep_remove_unmapped_batch(struct address_space *mapping,
+					      struct folio_batch *fbatch)
+{
+	VM_WARN_ON(mapping_no_direct_map(mapping));
+}
+#endif
+
 /**
  * filemap_remove_folio - Remove folio from page cache.
  * @folio: The folio.
@@ -260,6 +309,8 @@ void filemap_remove_folio(struct folio *folio)
 		inode_lru_list_add(mapping->host);
 	spin_unlock(&mapping->host->i_lock);
 
+	prep_remove_unmapped_folio(mapping, folio);
+
 	filemap_free_folio(mapping, folio);
 }
 
@@ -339,6 +390,8 @@ void delete_from_page_cache_batch(struct address_space *mapping,
 		inode_lru_list_add(mapping->host);
 	spin_unlock(&mapping->host->i_lock);
 
+	prep_remove_unmapped_batch(mapping, fbatch);
+
 	for (i = 0; i < folio_batch_count(fbatch); i++)
 		filemap_free_folio(mapping, fbatch->folios[i]);
 }
@@ -963,28 +1016,38 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		return ret;
 
 	__folio_set_locked(folio);
+
+	ret = prep_add_unmapped_folio(mapping, folio);
+	if (unlikely(ret))
+		goto err;
+
 	ret = __filemap_add_folio(mapping, folio, index, gfp, &shadow);
-	if (unlikely(ret)) {
-		mem_cgroup_uncharge(folio);
-		__folio_clear_locked(folio);
-	} else {
-		/*
-		 * The folio might have been evicted from cache only
-		 * recently, in which case it should be activated like
-		 * any other repeatedly accessed folio.
-		 * The exception is folios getting rewritten; evicting other
-		 * data from the working set, only to cache data that will
-		 * get overwritten with something else, is a waste of memory.
-		 */
-		WARN_ON_ONCE(folio_test_active(folio));
-		if (!(gfp & __GFP_WRITE) && shadow)
-			workingset_refault(folio, shadow);
-		folio_add_lru(folio);
-		if (kernel_file)
-			mod_node_page_state(folio_pgdat(folio),
-					    NR_KERNEL_FILE_PAGES,
-					    folio_nr_pages(folio));
-	}
+	if (unlikely(ret))
+		goto err_restore;
+
+	/*
+	 * The folio might have been evicted from cache only
+	 * recently, in which case it should be activated like
+	 * any other repeatedly accessed folio.
+	 * The exception is folios getting rewritten; evicting other
+	 * data from the working set, only to cache data that will
+	 * get overwritten with something else, is a waste of memory.
+	 */
+	WARN_ON_ONCE(folio_test_active(folio));
+	if (!(gfp & __GFP_WRITE) && shadow)
+		workingset_refault(folio, shadow);
+	folio_add_lru(folio);
+	if (kernel_file)
+		mod_node_page_state(folio_pgdat(folio),
+				    NR_KERNEL_FILE_PAGES,
+				    folio_nr_pages(folio));
+	return ret;
+
+err_restore:
+	prep_remove_unmapped_folio(mapping, folio);
+err:
+	mem_cgroup_uncharge(folio);
+	__folio_clear_locked(folio);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(filemap_add_folio);
diff --git a/mm/gup.c b/mm/gup.c
index 1d32e9a3dc79c..5297f0f84101d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -11,7 +11,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/secretmem.h>
 
 #include <linux/sched/signal.h>
 #include <linux/rwsem.h>
@@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
 		return -EOPNOTSUPP;
 
-	if (vma_is_secretmem(vma))
+	if (vma_has_no_direct_map(vma))
 		return -EFAULT;
 
 	if (write) {
@@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  * This call assumes the caller has pinned the folio, that the lowest page table
  * level still points to this folio, and that interrupts have been disabled.
  *
- * GUP-fast must reject all secretmem folios.
+ * GUP-fast must reject all folios without direct map entries (such as secretmem).
  *
  * Writing to pinned file-backed dirty tracked folios is inherently problematic
  * (see comment describing the writable_file_mapping_allowed() function). We
@@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	if (WARN_ON_ONCE(folio_test_slab(folio)))
 		return false;
 
-	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
+	/* hugetlb neither requires dirty-tracking nor can be without direct map. */
 	if (folio_test_hugetlb(folio))
 		return true;
 
@@ -2812,7 +2811,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 	 * At this point, we know the mapping is non-null and points to an
 	 * address_space object.
 	 */
-	if (check_secretmem && secretmem_mapping(mapping))
+	if (mapping_no_direct_map(mapping))
 		return false;
 	/* The only remaining allowed file system is shmem. */
 	return !reject_file_backed || shmem_mapping(mapping);
diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfbd..045b6779440b1 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	int ret = 0;
 
 	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
-	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
+	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
 		/*
 		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
 		 * count.  For secretmem, don't allow the memory to be unlocked.
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 4a4934769f8ba..c043c53687d95 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -52,49 +52,20 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	pgoff_t offset = vmf->pgoff;
-	gfp_t gfp = vmf->gfp_mask;
 	struct folio *folio;
 	vm_fault_t ret;
-	int err;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
 	filemap_invalidate_lock_shared(mapping);
 
-retry:
-	folio = filemap_lock_folio(mapping, offset);
+	folio = filemap_grab_folio(mapping, offset);
 	if (IS_ERR(folio)) {
-		folio = folio_alloc(gfp | __GFP_ZERO, 0);
-		if (!folio) {
-			ret = VM_FAULT_OOM;
-			goto out;
-		}
-
-		err = folio_zap_direct_map(folio);
-		if (err) {
-			folio_put(folio);
-			ret = vmf_error(err);
-			goto out;
-		}
-
-		__folio_mark_uptodate(folio);
-		err = filemap_add_folio(mapping, folio, offset, gfp);
-		if (unlikely(err)) {
-			/*
-			 * If a split of large page was required, it
-			 * already happened when we marked the page invalid
-			 * which guarantees that this call won't fail
-			 */
-			folio_restore_direct_map(folio);
-			folio_put(folio);
-			if (err == -EEXIST)
-				goto retry;
-
-			ret = vmf_error(err);
-			goto out;
-		}
+		ret = vmf_error(PTR_ERR(folio));
+		goto out;
 	}
+	folio_mark_uptodate(folio);
 
 	vmf->page = folio_file_page(folio, vmf->pgoff);
 	ret = VM_FAULT_LOCKED;
@@ -129,11 +100,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 	return 0;
 }
 
-bool vma_is_secretmem(struct vm_area_struct *vma)
-{
-	return vma->vm_ops == &secretmem_vm_ops;
-}
-
 static const struct file_operations secretmem_fops = {
 	.release	= secretmem_release,
 	.mmap_prepare	= secretmem_mmap_prepare,
@@ -147,11 +113,10 @@ static int secretmem_migrate_folio(struct address_space *mapping,
 
 static void secretmem_free_folio(struct folio *folio)
 {
-	set_direct_map_default_noflush(folio_page(folio, 0));
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
-const struct address_space_operations secretmem_aops = {
+static const struct address_space_operations secretmem_aops = {
 	.dirty_folio	= noop_dirty_folio,
 	.free_folio	= secretmem_free_folio,
 	.migrate_folio	= secretmem_migrate_folio,
@@ -200,6 +165,7 @@ static struct file *secretmem_file_create(unsigned long flags)
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
 	mapping_set_unevictable(inode->i_mapping);
+	mapping_set_no_direct_map(inode->i_mapping);
 
 	inode->i_op = &secretmem_iops;
 	inode->i_mapping->a_ops = &secretmem_aops;

-- 
2.54.0


