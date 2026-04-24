Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863E3FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3936B009D; Fri, 24 Apr 2026 15:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FDB6B009E; Fri, 24 Apr 2026 15:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BBF6B009F; Fri, 24 Apr 2026 15:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEEDF6B009D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 994FD160181
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:00 +0000 (UTC)
X-FDA: 84694407000.10.BACBDFA
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id D843D40007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m0y7YVqt;
	spf=pass (imf17.hostedemail.com: domain of 3qcHraQgKCDIghSjSbgRUccUZS.QcaZWbil-aaYjOQY.cfU@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3qcHraQgKCDIghSjSbgRUccUZS.QcaZWbil-aaYjOQY.cfU@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oo/pdV2AAzpZoUJTB8KwJow4oYxSpXiK/Ch5kfUiDOU=;
	b=vL1XpXMzbel5BqM6UvZFXG4YYv1DOyiAK8M6k4JgXILCz+/iPEt/qeedAsrEkfc+GSsYhy
	8s8Zx+xVOMra8o7NLvD+ekhcZcbNOgLdhLXvlv96hL5OLBPQDORdCWEB23KZnjbjLwRs3Z
	p4gWeHTx+lMcV05lAK8soYPnxiXkGxw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m0y7YVqt;
	spf=pass (imf17.hostedemail.com: domain of 3qcHraQgKCDIghSjSbgRUccUZS.QcaZWbil-aaYjOQY.cfU@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3qcHraQgKCDIghSjSbgRUccUZS.QcaZWbil-aaYjOQY.cfU@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058218; a=rsa-sha256;
	cv=none;
	b=fjSU/EG/1vIU9h8jHeFQTi4y+2sy+cAvIzfj3NtdJHnwKneRlIilmKAEQv4qbeC4lOh9DP
	0XAVm+EYaszsXVIkCEE8bxa3Mse4aHhsMlek679zNnlaMZ80wydBqYNVvAUPbE24uvblZP
	hTMiGIoDqAm/lc73Qh4uYHGWtRfP5/w=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12db37213daso12313052c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058218; x=1777663018; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oo/pdV2AAzpZoUJTB8KwJow4oYxSpXiK/Ch5kfUiDOU=;
        b=m0y7YVqt7NzeTmQf+ASpGu5xjPzU1FdwM+WbtYA/u0o25D4dodREckkTx5jvaN8UXZ
         JgeFEIRpb4fKYiHrzIUXuCpSBOfZKqjDWffCM0/UQLfkvN8H7nICV3OOVi7SdrYexYtg
         IKguix9XVFi28hhFbZUG0VUdxAMZU+VssDp/UCAQ4trWcbnOnAEXHkRfTE/soKo2cznH
         3USx7mEqHTvQQebDovb3eBB6EXPJv0xaqhl2ilV5pEC2AsuVJ8o+Rv4G0XIBYbUP/hT2
         2GvGF5QWLOZVCTdvF6kZR5uOC2dgRghBOnBj9wR1JhdyC8HV8VE+N3N0gPuoxCB824Xv
         5aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058218; x=1777663018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oo/pdV2AAzpZoUJTB8KwJow4oYxSpXiK/Ch5kfUiDOU=;
        b=W5pySREHZOwYqQlO9t/xpBLGs080gYkIaHxenIPJD9+OSxvPaSVpdbMSZA2XX8/4Dm
         H5Irk9O37W28w9QDpb5WrScgk5/CpvJ9uTrv0RZWYQyrkIzkOz3FzY6g59OL22S3FtY2
         7OCXi3AfAOue/6ltxk4ny8F0QDrMHlPYbsIgCmYQ5wOVXzd68hVdCUaWfpvARlc0yWIj
         EAA3nwaHWmoa+0ciNQ1Rme7Cyc3B4DmN4QrGNN74YQNYCnOVXKoOhnI/qg6h2coP7ofX
         mgt3JtefXXrLOSIX2xY6YkE1Zj9LjjvOCK8CpoV7hfdZprgJBLocRM6f5oUIggOiwAUj
         pZ4g==
X-Forwarded-Encrypted: i=1; AFNElJ8AmstBjQV4AKo+gzm42eXZm1idXLWCrntnvEwDqDtlf9zNvf7QxFByuSAin1S5OUmtA638GraR+w==@kvack.org
X-Gm-Message-State: AOJu0YwpJkSnwi7KdiO1xGyI/hXuratXZtx7iicymPsCK+mQf9/A+p18
	wv8U05R0K+685LAvI7gGdVu105E6F+LNjT9FQg/i8mfeVCtPGTt8dOWH4sUpCFEpjHeT7kZhtdD
	MaGoeWwNFIvXwUw==
X-Received: from dlbcf24.prod.google.com ([2002:a05:7022:4598:b0:12d:b2ba:b551])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:270f:b0:12d:b993:c68f with SMTP id a92af1059eb24-12db993c9b2mr4770751c88.4.1777058217479;
 Fri, 24 Apr 2026 12:16:57 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:48 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-6-stevensd@google.com>
Subject: [PATCH v2 05/13] mm/vmalloc: Add a get_vm_area_node() and
 vmap_pages_range() public functions
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D843D40007
X-Rspamd-Server: rspam06
X-Stat-Signature: yx8e5iju6cyepzsd6ugsum5k8sjahddf
X-HE-Tag: 1777058218-487116
X-HE-Meta: U2FsdGVkX1+PYgQXUZxSlN5z0id3kcyu20dNUQb/3b0C36crikQlUTN31FlwZ5V9ydg4/e0Vso1JaGUxytY93IAtY1TQad9j6OmfGlWxpRNxR9lR9Jaeg0o0eLQ6X3sd+zQMRu84R3J61VTfNVmwZ1FLnM1o7+htI1sHqB2Io4h1mQ0PIylIEDRExBwnE3RNuylf0J1WdKE/wWHiTA1DfyANsecpeX4wo1dH9UuUfWCO+zdwvDFUzRHtVrcMhvVaSNljOY7zYYmnKSolgqNU7m9qfqn2kR5sbRaMrtwLKnk1EdV1Vx9X1N8gwwxTp03uWbt/aHP7pj0pso+ULS9Jp8bNrKrksEXS3jL4/4WYccNek6ogB5A//x7h5zLbKVVnFmR2vxZmDPeWP1mf5egulnXogDiShg+adTtm7xn7CAOAh2m5FEeIk5+dK559J+stLEdDlQI7gX/TQ18qeRK0w/PMuYLmzcBE+TSvW/GMYurwznkkP/J5xSKNBxkwr0uFbQnBwfOtwyEvSyqbyb1DuKUxjWH97zDQ0JTqsra4kwg51J0olqr8snHAHPTeykzShKdaDGXEb4qb7nQS7F8Z0hRRKmZKFOKnz4VEUB+FcUsUAtUE4sP319ZqqKEu2i7LblvvDoNCHVQozjs+yvmRiheyqtw10wW4RS536sXonOtZI16ynkY27V0WudCIVFgNU5FSXcdPzgtP66icZOwL9eiJmuXgTKNeomR5RFsuQMPcmFJNFYHHWKCK4ejKdJwmrOp9BNUx4UajGQQKTXaHu81LCrfrbNRMOCY7mJ/7pnpa3B6tQbKtdrpCnK/bMOBNVV7o4ST3faKth6O/JJzxfKmwT0YtAdaDNrGRo54fxxm5Zf5uxpBeRfijpw9RKZmHs5kO46oPXcyPI0Rc6kI2JO97TAjlabN4eG/m86HNSbmKi8YlqASrbkZa2fdCl4plrh2QT7VPpHZyYkNG/fv
 Lcrd3mY3
 8AwOuZB9QDBMQHXPbe/GgGIkLjTSvjV2Shsc/qmgsNGzAr3bvWid1S/VjY4fJfUXbBos5ZT49pgRC3tvEbTdyGUbt9+LarJhmvfiD9/5/GSPE4IzxkgwYOfmwYtf9CVu0E8prE1hw3ClBWIcbs5G9MrA9BGyRMSYQ+qJ5PMOw0layGqhBk8Nxfg2HhouHrsK9El/cQbxyASqXr+zOYIySbTxCwCXkLwJxcvxJbWByfSQjR4pBHpJD0MhqGygDnnCwD1UkxAtAkmrLTgs4EtUgeyqJUoTHgJXyc5lxr6cv603svydtoRi7Djrrj0cnQXHcJ9m3TJcZZMNzj8LJRdTETdxxBIUl2F2pk83ksfFh0BKgjd5fpPSjkJCGZvrkuDRm7jzdMQShfx7paY/gLP2k0FcOPJr3CAs2csfPf+MOcj2m05NG01AWMG/dKEeRoavRC0YikXq3iUh+ASQlNiDysMbJpyT0SmGMI+6tfGeIEv6AZPQwbqrI6PkDc7yTgc2Cnxozm/eTjaZ2D8KQkcYlQJarK3miJ7VSCk8B1B71LxAsDLi4/ZoyRsSwCVR4Bikbe3Y47kxY83Rvm/O+lWrskE5iXQ0Gf+2ORQGhpvJykAU2D5UtyUhVYOIx3cvRWPEYcE7+TAGK6ClyoEV7xBR68z4cLPQVY3phLSSnHnC1RmnpPHLEpDG/uPyEaiFN+uScofmOMI+x8TXm+9BN3QEBG52TrsNQhMttLcKSrs3g4VKu38cDdlYyjLktCEWgVnGrLUx+eXfJwZyC3zEvQKC2aIV8Aocu4jKPrOUYKrlBKabacBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

get_vm_area_node()
Unlike the other public get_vm_area_* variants, this one accepts node
from which to allocate data structure, and also the align, which allows
to create vm area with a specific alignment.

This call is going to be used by dynamic stacks in order to ensure that
the stack VM area of a specific alignment, and that even if there is
only one page mapped, no page table allocations are going to be needed
to map the other stack pages.

vmap_pages_range()
We will need it from kernel/fork.c in order to map the initial stack
pages, so export the function and add a forward declaration of this
function to the linux/vmalloc.h header.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Switched to vmap_pages_range instead of noflush variant, fix typos]
Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/vmalloc.h | 14 ++++++++++++++
 mm/vmalloc.c            | 25 +++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e8e94f90d686..7b56a0b998ab 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -250,6 +250,9 @@ extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 					unsigned long flags,
 					unsigned long start, unsigned long end,
 					const void *caller);
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+				   unsigned long flags, int node, gfp_t gfp,
+				   const void *caller);
 void free_vm_area(struct vm_struct *area);
 extern struct vm_struct *remove_vm_area(const void *addr);
 extern struct vm_struct *find_vm_area(const void *addr);
@@ -301,11 +304,22 @@ static inline void set_vm_flush_reset_perms(void *addr)
 	if (vm)
 		vm->flags |= VM_FLUSH_RESET_PERMS;
 }
+
+int __must_check vmap_pages_range(unsigned long addr, unsigned long end,
+				  pgprot_t prot, struct page **pages, unsigned int page_shift);
+
 #else  /* !CONFIG_MMU */
 #define VMALLOC_TOTAL 0UL
 
 static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 static inline void set_vm_flush_reset_perms(void *addr) {}
+static inline
+int __must_check vmap_pages_range(unsigned long addr, unsigned long end,
+				  pgprot_t prot, struct page **pages, unsigned int page_shift)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_MMU */
 
 #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..39b7e118cbce 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -722,6 +722,7 @@ int vmap_pages_range(unsigned long addr, unsigned long end,
 {
 	return __vmap_pages_range(addr, end, prot, pages, page_shift, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(vmap_pages_range);
 
 static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
 				unsigned long end)
@@ -3285,6 +3286,30 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+/**
+ * get_vm_area_node - reserve a contiguous and aligned kernel virtual area
+ * @size:	 size of the area
+ * @align:	 alignment of the start address of the area
+ * @flags:	 %VM_IOREMAP for I/O mappings
+ * @node:	 NUMA node from which to allocate the area data structure
+ * @gfp:	 Flags to pass to the allocator
+ * @caller:	 Caller to be stored in the vm area data structure
+ *
+ * Search for an area of @size/align in the kernel virtual mapping area and
+ * reserve it for our purposes. Returns the area descriptor on success or %NULL
+ * on failure.
+ *
+ * Return: the area descriptor on success or %NULL on failure.
+ */
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+				   unsigned long flags, int node, gfp_t gfp,
+				   const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  node, gfp, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


