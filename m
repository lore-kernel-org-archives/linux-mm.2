Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEFF7CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 21:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5888E0012; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E7A8E0001; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2AC8E0012; Fri, 26 Sep 2025 17:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED9758E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:17:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA2DABB885
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:07 +0000 (UTC)
X-FDA: 83932661694.08.0A0E805
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87A9740004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:17:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JEP67Lss;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758921425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hVqOG3Eh1Yx9eqpcK28/avvzNcMaSdpE9ANunBKEMM=;
	b=jzBz+bF9YTgn4OkeqOsiHo8gkB0c32T0iHyh2E9ImxWNmax4SA9jjpSvpU6uN90jIgtfkr
	N41v2eU67MRGzjMqcNfA3BvmFkGLLkc0+T0ceEU2LTfJ2d3Kxvfz2y3KXDvYvIwovxt7yT
	6tls77CNxgoTIeKol6r37q99wJkGE38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758921425; a=rsa-sha256;
	cv=none;
	b=hQO7FuG/gfAQBUVuaY8844L69SaBYoGnmwui9RjQXCJlXNpKtRa7po57rt3BURmk6NRiLj
	gfrBqOukut0rDEh9FM6G7Ox81aqDaifGg/0lbkTicY1ityNXNnLu6bjsSV/r7+owiHNfIf
	MSNz6BsBUV4C43xR3P47sjLj9P7xIOI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JEP67Lss;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758921424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+hVqOG3Eh1Yx9eqpcK28/avvzNcMaSdpE9ANunBKEMM=;
	b=JEP67LssHoGE22fArdTVLonJWZp43oR2m/F8ylskJVOCs6OzxfY8NuoNgY/UsC9k/CHiSh
	TsX6aieZX1BCgHQsbmAwC3xaJNFfOhddlSVPCQCXd74trRSkb+yzRSFl2pKlshLxZ8mvhO
	5YAGGnvmuVcaWY1FVcZKoywLNkuqnlw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-BdOfJxjDP-C1ahnJt4J8vA-1; Fri, 26 Sep 2025 17:17:03 -0400
X-MC-Unique: BdOfJxjDP-C1ahnJt4J8vA-1
X-Mimecast-MFC-AGG-ID: BdOfJxjDP-C1ahnJt4J8vA_1758921423
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-856c1aa079bso564851085a.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758921423; x=1759526223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hVqOG3Eh1Yx9eqpcK28/avvzNcMaSdpE9ANunBKEMM=;
        b=LLLYg5NJeamYWYsUU8oB6DfVVVH0dOxHmV88qzx+K17svnEe2EFyOyLAR0IYkCDT4j
         E3+XAZ5hoG3MRGkgpc0ZyVO7F7qqBuU4+BynZK+Tnkyxsc0Vkc7/Gmxb8XvB6SGNxK1O
         d5dCKLHPOeQ90vVatmZzN69rMRhCCzG4t3moRk+tIm3T2ClE490dpLQsN/pkwgFuS+Rw
         3hEt9Z9fOmrMf54UQgXIkdAVCkZGZNLwaF2lKS1odyN2QCaVlQdyUeyeRZnsMVq+ZKU1
         fuWNcGDHlmJedGYfLm1HMbQ8jUfJZ3HwjEg5ZgY52dLLfVZ/Vw29YEzD2seR5SKMBg8L
         2esQ==
X-Gm-Message-State: AOJu0YyDSpLMJeDJA54RvMeQj5sbm//jhZP7Wv8RJ+r2mGYPkdFcOlQN
	GSM4scYQH7Bd6czLTzrCV+5sKXxDq5/w/rjawBI+em3OBZrfZA3tNjuGMvcPMAnKMCXztfV6Hxp
	qzbhqehuGRQ+ivp49AE1boyqSCijDnDzX9+mvQG+/cFghEUXbk4K0GYwJ2+3xNsqyWXrh0ObJ7z
	6GBj3BpFa8DxA0nO+Iuyjy4mel9yqATJ9PbA==
X-Gm-Gg: ASbGncsKkGskbhW3T14LIKccb0oCxjws+P2qH6Gb/V6DXmdoL5OdYXRyZEMBRBxtRDQ
	9EEqIiDfcDk8ww5XPAeHeMsspRtR/m81tgRYp72jFbbKIGJlksVGcgDOi1iLde90xWL+y2fq7TT
	oeP3HYK9P8st5lmgPGSDd1puhxd2lcrqYBdL5N2E5OhpCBvlvIK/7L24C8ltiEghPt49o4nSRPM
	q1N02ULAKAQB/RknCimXLiovlp5cLqfKgslkA2nCfIKglptk5Uwp+uky+dr0okwmUvr/TrMsHVs
	Pre0OdEziFyDMUpBpRUsdsSF7WugtA==
X-Received: by 2002:a05:620a:458b:b0:850:78b7:f878 with SMTP id af79cd13be357-864545bb641mr128787285a.0.1758921422786;
        Fri, 26 Sep 2025 14:17:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYPzTHVPardWHZo24HN+Lu0mmZZ7m+h0eutm0YjD7rOSGFq9rS1SwsPF9Di4dBBVvxySTv0Q==
X-Received: by 2002:a05:620a:458b:b0:850:78b7:f878 with SMTP id af79cd13be357-864545bb641mr128781185a.0.1758921422125;
        Fri, 26 Sep 2025 14:17:02 -0700 (PDT)
Received: from x1.com ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-86042e32249sm210604785a.44.2025.09.26.14.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 14:17:01 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	peterx@redhat.com,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v3 4/4] mm: Apply vm_uffd_ops API to core mm
Date: Fri, 26 Sep 2025 17:16:50 -0400
Message-ID: <20250926211650.525109-5-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250926211650.525109-1-peterx@redhat.com>
References: <20250926211650.525109-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kV17TKaeLh6iymQlY0trYZJVPzETL017OM_4m7CGJ24_1758921423
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87A9740004
X-Stat-Signature: y7btob84xma4ffte54h1knrymmfu7s58
X-Rspam-User: 
X-HE-Tag: 1758921425-54255
X-HE-Meta: U2FsdGVkX19gxHiqTTESNkh2BhPWsBEdzb2MTWkwyt6MRF6W71q1XXJRwEEfcoruhtK4iP0Qcs5Q9GWZZiP7y9G6Lm3Wkb0xIKX8jtg03KlI5QnrXjCCAQHXLnJAxjR2cFrSzyxt4nLOodTBH1ISJQ1/2+lM+lzP/G+wWDE+BgLV2/vY6IGw5e5oP2mXC8Psl3BYiQz80IwLatwfWSnT4iDXL6L60wZHdaZebVG10k9XB79Tme7vocKuXH1JsMSJhBh0le7CoQgzaSeurrrV2QknqB5x/rwgRn2Z/zlnqDMtUksDVa/J0fM/44nnmkgD7yjInCXb2x31QU2mLEfKbK1RO9KrcjQAuTtJl+uqB4sY/f9CQAp2bZvNhYUmZaQvHVqJDYoRhwmOphZEfYXxf3MMI4UVnZkn517gcuP7VviOyJzvdVCvf20VvCuQBYKvJSJMmbgmP3IkkroDA6qMKCAZg3wKExvhNvpjzmESU0bL3qHv1QMzBCqwLfv157qYjJXTV324IwTny3dSJJB6TMZvbAfGbLSWTUdaG5goQfuKcg8gRDtVu4QQKF7cp5Dd7HZxOp2hV0TQMqIArG0Rs4FHFn9GuSVqUGFL2xxZISmQI2X6zvcSQhitiiXYImjYxr/AwjBB1i85ryDJdbOPwMnJuGLh0qKuPk/tKuyVRihjGBh+0HvSi0hjJ89bTmFejXpDdEir2EoZvx3X+U2mOwjIKRIYSSKAXRP+75pOKzPR6QSjLpmk0DiOTik85H5kXAvxqkI7xDY+Av5RbDUIWkTIROEUUjHwQ3WlHPw9w/TdYwPo5I3TT3TJSUtbvz3a5yQH0FTMDL0hxUO18/eZo9Ru4thRS1DFeSx5FWAEy/B7u4uRvT77b9NgMeREm5a6VnSWXvL1+JfBFJeWlQtVuAA8iCAOnznNVkWvP0Z5c7QqJiWctpT6zf0czDvMHOQ6SpQcXF3cJM8l7xQ6EAE
 NdYRs/TC
 At4woi0zoIkBXH788+wCWaqY+NXZI2wVoPRlyaLYKYruMeKzB+kI8RScDjvfs/DqoRep1Fa+/wew2QiYvZYskwgAq6CII27Sd0ZTk9MoG/eJ6MLGa2Hn0lzJ0z9KrqQRfs82B6VfUD/tBbylZr6q2aF4l+hMSndCKqsg+QfTLwcDtBnIXMWvO3jsoC5R0f6IRXO7ZMNH+7TbsvtQOJfvdWxTPXvVShbKZW7wNlIaSs0WeHc/X76dM62X91YL2exp3/tDWhBfeMNIZQQlllTW06M8QlDB5hsAY49bJ75F+nsr7n8Su+TS5eunwxMk6Z9GNVD5NTzjzxBYyEYU263rlTyk5xazHTMpgekT5l6+sAr878t8j2mSAzNu3AB8pqRtHCmRvIDe0Io8TJ+st/mmzyng5oJYC9y409lxmaDsJbkRXnUOXTdL5+K3uRdKpNL0nYRPOQQ3w0P7Naj5JunB4FxCedlzBjgYZ0EqmvUy7S6/lqusurhlgyFTw1Mwz5iLeaa0WxChDw6jazwiVQVzabgEIe8BNN+SodlUakkIaD8rfP+am28zb+aaf9chAGdWeYWmIqbVMdagwzyEKY6OieUAZdwcnVKCBFt6P6OfkM2pDjXQDzQcbHSyXqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move userfaultfd core to use new vm_uffd_ops API. After this change file
systems that implement vm_operations_struct can start using new API for
userfaultfd operations.

When at it, moving vma_can_userfault() into mm/userfaultfd.c instead,
because it's getting too big.  It's only used in slow paths so it shouldn't
be an issue.  Move the pte marker check before wp_async, which might be
more intuitive because wp_async depends on pte markers.  That shouldn't
cause any functional change though because only one check would take effect
depending on whether pte marker was selected in config.

This will also remove quite some hard-coded checks for either shmem or
hugetlbfs.  Now all the old checks should still work but with vm_uffd_ops.

Note that anonymous memory will still need to be processed separately
because it doesn't have vm_ops at all.

Reviewed-by: James Houghton <jthoughton@google.com>
Acked-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/userfaultfd_k.h |  46 +++++----------
 mm/userfaultfd.c              | 102 ++++++++++++++++++++++++++--------
 2 files changed, 91 insertions(+), 57 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index b1949d8611238..e3704e27376ad 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -134,9 +134,14 @@ struct vm_uffd_ops {
 #define MFILL_ATOMIC_FLAG(nr) ((__force uffd_flags_t) MFILL_ATOMIC_BIT(nr))
 #define MFILL_ATOMIC_MODE_MASK ((__force uffd_flags_t) (MFILL_ATOMIC_BIT(0) - 1))
 
+static inline enum mfill_atomic_mode uffd_flags_get_mode(uffd_flags_t flags)
+{
+	return (__force enum mfill_atomic_mode)(flags & MFILL_ATOMIC_MODE_MASK);
+}
+
 static inline bool uffd_flags_mode_is(uffd_flags_t flags, enum mfill_atomic_mode expected)
 {
-	return (flags & MFILL_ATOMIC_MODE_MASK) == ((__force uffd_flags_t) expected);
+	return uffd_flags_get_mode(flags) == expected;
 }
 
 static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_atomic_mode mode)
@@ -245,41 +250,16 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-static inline bool vma_can_userfault(struct vm_area_struct *vma,
-				     vm_flags_t vm_flags,
-				     bool wp_async)
+static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
 {
-	vm_flags &= __VM_UFFD_FLAGS;
-
-	if (vma->vm_flags & VM_DROPPABLE)
-		return false;
-
-	if ((vm_flags & VM_UFFD_MINOR) &&
-	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
-		return false;
-
-	/*
-	 * If wp async enabled, and WP is the only mode enabled, allow any
-	 * memory type.
-	 */
-	if (wp_async && (vm_flags == VM_UFFD_WP))
-		return true;
-
-#ifndef CONFIG_PTE_MARKER_UFFD_WP
-	/*
-	 * If user requested uffd-wp but not enabled pte markers for
-	 * uffd-wp, then shmem & hugetlbfs are not supported but only
-	 * anonymous.
-	 */
-	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
-		return false;
-#endif
-
-	/* By default, allow any of anon|shmem|hugetlb */
-	return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
-	    vma_is_shmem(vma);
+	if (vma->vm_ops && vma->vm_ops->userfaultfd_ops)
+		return vma->vm_ops->userfaultfd_ops;
+	return NULL;
 }
 
+bool vma_can_userfault(struct vm_area_struct *vma,
+		       unsigned long vm_flags, bool wp_async);
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4e..0a863ac123d84 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -20,6 +20,43 @@
 #include "internal.h"
 #include "swap.h"
 
+bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+		       bool wp_async)
+{
+	unsigned long supported;
+
+	if (vma->vm_flags & VM_DROPPABLE)
+		return false;
+
+	vm_flags &= __VM_UFFD_FLAGS;
+
+#ifndef CONFIG_PTE_MARKER_UFFD_WP
+	/*
+	 * If user requested uffd-wp but not enabled pte markers for
+	 * uffd-wp, then any file system (like shmem or hugetlbfs) are not
+	 * supported but only anonymous.
+	 */
+	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
+		return false;
+#endif
+	/*
+	 * If wp async enabled, and WP is the only mode enabled, allow any
+	 * memory type.
+	 */
+	if (wp_async && (vm_flags == VM_UFFD_WP))
+		return true;
+
+	if (vma_is_anonymous(vma))
+		/* Anonymous has no page cache, MINOR not supported */
+		supported = VM_UFFD_MISSING | VM_UFFD_WP;
+	else if (vma_get_uffd_ops(vma))
+		supported = vma_get_uffd_ops(vma)->uffd_features;
+	else
+		return false;
+
+	return !(vm_flags & (~supported));
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -382,13 +419,17 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 				     unsigned long dst_addr,
 				     uffd_flags_t flags)
 {
+	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct folio *folio;
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	if (WARN_ON_ONCE(!uffd_ops || !uffd_ops->uffd_get_folio))
+		return -EINVAL;
+
+	ret = uffd_ops->uffd_get_folio(inode, pgoff, &folio);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
@@ -504,18 +545,6 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 	u32 hash;
 	struct address_space *mapping;
 
-	/*
-	 * There is no default zero huge page for all huge page sizes as
-	 * supported by hugetlb.  A PMD_SIZE huge pages may exist as used
-	 * by THP.  Since we can not reliably insert a zero page, this
-	 * feature is not supported.
-	 */
-	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
-		up_read(&ctx->map_changing_lock);
-		uffd_mfill_unlock(dst_vma);
-		return -EINVAL;
-	}
-
 	src_addr = src_start;
 	dst_addr = dst_start;
 	copied = 0;
@@ -694,6 +723,41 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	return err;
 }
 
+static inline bool
+vma_uffd_ops_supported(struct vm_area_struct *vma, uffd_flags_t flags)
+{
+	enum mfill_atomic_mode mode = uffd_flags_get_mode(flags);
+	const struct vm_uffd_ops *uffd_ops;
+	unsigned long uffd_ioctls;
+
+	if ((flags & MFILL_ATOMIC_WP) && !(vma->vm_flags & VM_UFFD_WP))
+		return false;
+
+	/* Anonymous supports everything except CONTINUE */
+	if (vma_is_anonymous(vma))
+		return mode != MFILL_ATOMIC_CONTINUE;
+
+	uffd_ops = vma_get_uffd_ops(vma);
+	if (!uffd_ops)
+		return false;
+
+	uffd_ioctls = uffd_ops->uffd_ioctls;
+	switch (mode) {
+	case MFILL_ATOMIC_COPY:
+		return uffd_ioctls & BIT(_UFFDIO_COPY);
+	case MFILL_ATOMIC_ZEROPAGE:
+		return uffd_ioctls & BIT(_UFFDIO_ZEROPAGE);
+	case MFILL_ATOMIC_CONTINUE:
+		if (!(vma->vm_flags & VM_SHARED))
+			return false;
+		return uffd_ioctls & BIT(_UFFDIO_CONTINUE);
+	case MFILL_ATOMIC_POISON:
+		return uffd_ioctls & BIT(_UFFDIO_POISON);
+	default:
+		return false;
+	}
+}
+
 static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long dst_start,
 					    unsigned long src_start,
@@ -752,11 +816,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	    dst_vma->vm_flags & VM_SHARED))
 		goto out_unlock;
 
-	/*
-	 * validate 'mode' now that we know the dst_vma: don't allow
-	 * a wrprotect copy if the userfaultfd didn't register as WP.
-	 */
-	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+	if (!vma_uffd_ops_supported(dst_vma, flags))
 		goto out_unlock;
 
 	/*
@@ -766,12 +826,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
-		goto out_unlock;
-
 	while (src_addr < src_start + len) {
 		pmd_t dst_pmdval;
 
-- 
2.50.1


