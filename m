Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A85C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223956B03BD; Thu, 13 Aug 2026 02:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D52C6B03BF; Thu, 13 Aug 2026 02:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026A06B03C0; Thu, 13 Aug 2026 02:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B73516B03BD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3892F1A0569
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:10 +0000 (UTC)
X-FDA: 85095281460.19.05F251D
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B6D7A000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Cn7HRh/i";
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PU5ZgYpnEKtS6Q03rm/ulb+PTqDcRDqoQn/9SvFgDXg=;
	b=50bYeZlcMHDWz6v9MsIWFUJ3sQKszCwV3rNONhwNfF1MQyJlbtUKtEKX9J7Dvl3OtexwBy
	RZXkQV0QkW6tpiSY/dPkDelqlNKVS63mtYGxjwHi10tdpSEhSQJsjibktFuGZZG8/s3d0H
	L8lB8QCqgvu4PbgUgyNVoUoUOIj+clI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Cn7HRh/i";
	spf=pass (imf15.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602848;
	b=eH5GKTmAZYFR0uAop5X55thw8+XBwsAXz8fX+nI2/l4xJhPecF0E5Y43RUAVK3QGlwsWch
	A6ShCcux7vFXGrvDIUachcS2GerfhYa6oDZfzAjmvmPUyWnSJLTrmNDQoNGBUNLu6p1bn4
	o+R5e9BLW07YOBn/cuh5sGpcquko39M=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8484f229529so1510371b3a.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602847; x=1787207647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PU5ZgYpnEKtS6Q03rm/ulb+PTqDcRDqoQn/9SvFgDXg=;
        b=Cn7HRh/iAj7jECecXoi1US3LQjByyAc2QYQs6NquvlAzs7WDXrcAVLx6o7GqLNv/EI
         ARYBVQRoDwSZJ3Ebk5z6K+cCkX3EaEMIATjaLNkkPMgnOSTFd40pKDBGM8+zzWLUiCJs
         jala7DiVpnAMjU072RL34bmUBMbfPTDgzCrpF3lPyBQsdInxrsEvZLDIThOvXHlV/HLJ
         +peRXMZJqSEX71cGbxRTq9W1m47yYSaGApt8u/SLRbO7bD2m+hNQDZEnZA30Y+TQS5Qr
         58T/Bcx4Yhyv24NiasvY3XKjOw55mukdKuyHXy58e/PHser4SNpsQz6WkOS3j6SVQuav
         QG4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602847; x=1787207647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PU5ZgYpnEKtS6Q03rm/ulb+PTqDcRDqoQn/9SvFgDXg=;
        b=fTeiaBdNzcR3yfuLklX+D8UvAfAd8q+82tYUUfh1dgQfqhYKG1aYcewANfEVf2sVsC
         x/oRcCxri/CYiFSOxh0pxb/ef8g6jckR/35SgAU9GqH8XKZkRQXf8ZKlEOzGzGq9087C
         c/uQb52X5U8IiDPfCXtYsgHm57RHRQxjqLuGePCIX4fwBzBTQKdfBpacgYY7iK8COCjF
         veISMeuCNX0IHyf0edY2aYJE4Cw9oLmKKbRFgTdcT+CwDns4KjbFpHa474l1lfYrvwXR
         4NN+8iwXvg3rRzJiqCvgEsCehO6HvdtKaytY8modsFKLslnZqrFoa38//FiYjKWblwC0
         iyVA==
X-Gm-Message-State: AOJu0YzP4bPfqKO5WARabccFGntvWHxZzkpLAyg4WxCdPLj3jhnO+AGN
	7oj7ZusVDpJpsayw55zEJOhFQhUOqBylpOjwN50dG46tLlWuA4x0G33X
X-Gm-Gg: AR+sD13PLAHoAQ1Upa/LK1z7NkDPS6w7uplCuwMl4CVqMbXY5TaMijwpM9dGLH+6RWb
	wODBB4Tm0wskBtOZA9zOvZ8Wgfauw/7sEgciiDqohXE04RWJ1+2JoxRXN6x0KqeYlxWmFrCJdoW
	IkVXBbD6dWFmDatCgtnj/4IGDCONoxw4QpY7YaOGWr71zrre6QeWo9Htur2Wu9kq0nw1EYDKO4I
	yXlmMjrR4VoLe5XPynzFU9rmBgXfL/UtKd5i/BNlcBKQwTQiaPj9SBL8lB+yS6Ak/AmxTMk+nFt
	bfjpuwbooUVOMpAihiueTQ5hF7SwTjitheprMvLJAsTIWXXwnHBF4ojSYfXIC2MZIoPVN9A8gUm
	1+4gSs+BuWlHRO9CSz6qSCC9tAeeSUzTY3uC/k4DToxUo41891eilVAIJf2Lkdh/GrYIazA+JDz
	xZG6pOo52AnDXoQWFGE3/C/P3YImOP7ZH8ym8/C1UJy4deDG5Qv+BnD5JY1OmuzY0uZXbumPM1I
	qf1q7Uxcp3mjuglUWiT+GqY+zopigK7FNkpYMqBw0BMyQs7T3zBUL3UJ9DZ69p+pg==
X-Received: by 2002:a05:6a00:a206:b0:84c:1cd2:142b with SMTP id d2e1a72fcca58-84fc6e56125mr3326041b3a.9.1786602847125;
        Wed, 12 Aug 2026 23:34:07 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbef68487ecsm520652a12.3.2026.08.12.23.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:06 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id C9EF015B042B; Thu, 13 Aug 2026 15:34:05 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [RFC PATCH 1/6] mm: nommu: fix do_mremap() to correctly update internal states
Date: Thu, 13 Aug 2026 15:33:56 +0900
Message-ID: <20260813063401.1786548-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B6D7A000A
X-Stat-Signature: oh3fe9tem6oyxn5xipetiopfdenrbxpk
X-Rspam-User: 
X-HE-Tag: 1786602848-429189
X-HE-Meta: U2FsdGVkX1+cYemOlqHtWpaMrJciEmLxvVq9bdL/dmGbiVReRlZxo8A4H2Dzh7eerDzurRHOj5FteosziQo6tlEMEaHNKpww/6yVV1SDb6Sa5O99ciQngrz+UwZ/yMHWnNENlmmEKAERtnvSjqL7RZGXBuqGs0J7aAK8JcYGuUhBDazptOyRSsQoZOV/z9YoFqYglUdWUEehHqB4kTJAoqCzt4/gfjKiJRl4aOVWPjymjT8SuVYN4n8cfq+zcUOu3ecYzxoN0OZ21wQhFVdCN8bWAiULpktbpotAf/Yki7oxhG4F/zY/Xn4c82wrUaDCVzIJUoD4/QEoFezZXVuxeCrW2IDaC6O6URtHwE+Ton08I/DYuOKaaFMD/ZGcIzyP0FlqDJPJjQ8jfCGRahJ52+CuczFTlh4qchevwi7xcdy1ndMsuHD1Y2ue02gmgMmnCw//RttyzSE1NK0yYQrzpySsyf7YgDPQyO9IudFNuVpps+lGCnipdAQuaHGxqtS0ghs4zC46WDI6C+bu0q8XKk8lTkZnA/BfhsOaDNXP58yHm1okl+bKuMS4wIcyyJy0Snf+lMFXn072hzRUWldaXQ/a3q/nWRX/zpxjy1wpl/29dUgr6WKLKmNAZWDKG+Z5JH/aVBCI7hUT5PXoixCsDAsEuaOzck16XkBqMGxbjNrvCp6wnlknMWi2d9XATwEHCMKS9CI/djXr52NMfGEBncpwXbH+ZUPMuz8hBtTvjT777gNbznu1SDEBLll76CNXZAZZ3gi/9LxLesZ4FebPfV3YRwpN+ZqSa7VNaEZNhJPLEqs4GS4cKCe8re2Y5vG7MvcMC1c/PyyFrGdl5W2GbyPfedDhrCf9LKJ3eGMwAFcXOvLTCfQOY20IyMAPduKDxEg9lJSofdn92KG8R3S4ZVJQNVnZfAZRSZ0ZlQlGjQx/ys/jVsvGuQZCQ0SWqgETm8ECb7AUEXeCZOgRQdh
 D3cKYG7j
 jorLD+aDfrEzbyCB8shuDGCCyVjrw8JFU4NZ92oJUjBF8ttVfhYqAycBrtc2fsyIyYQbrhCHyCA7MmuE5M0FA3b0qjrJUkow7fI2z3lIHW9dVOcVqKVWS1r/HyCs3yPmtC1EXMWdPByHWWyqxZ5nQq7sSh9jkG1GOMMtS+9FOI4fqcvWAgn1OPcDfWzdky11Tg0OP62HWRL5sLuCU2kDNmbDME1lj3NxSYwiXokLb3fPdICzZ++G5bQBFoh9N2b/ZHUX9p0tgXsyeJl865AP0ubXKMXQz18dMWo/2cR8e4rYYmwE44UGnvyL1hBjChVOANFwGE3D9greqPeCbmkyc8a917C3qG0d1Igu3N33sY05ALmWOo3t9rV6+PR22PbAZQGrkXqm3YjOXDXJ/umfDlQIbVl1fHZ56qQ9kk6mg3pJRFEroRqTW4MSQxIsEFLM4P+kETZAAu80Cujm4o1bSQ8miX7hhQYGgmP6PWHxGPiGimvwAcXfa+GJhOoMJz48Iuy7BQJ4bVMIgtivxnPZmkmpkSvLl/b+aTnSv75uLydp/pdjtmRSK6fL3xDOFahtVZpSEbqf/39dNF5d8SQLaAQy7/BolUXBoYk/QO/p0mzWznC69CGGVjvgZhG3ao5wKrPajqdowj/l2lPXXjJxgz2OzTs+4SV51I6Fobe0tt+dECwa43HxAqvqa3H1xprpq1KG6iY/i0o8qbCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When shrinking a VMA via mremap, the bounds are modified directly:
mm/nommu.c:do_mremap() {
    ...
    vma->vm_end = vma->vm_start + new_len;
    ...
}
This shrinks the VMA without updating its bounds in the maple tree.
If the maple tree (mm->mm_mt) still contains the old bounds, a user
process could access the freed portion. The stale maple tree would
incorrectly return the shrunk VMA for an address past its new vm_end.

This commit fixes this issue by calling vmi_shrink_vma() when shrink
happens.  Additionally, if a file-backed, non-anonymous map is to be
shrunk, it reports -EINVAL like do_munmap() does.

Moreover, to maintain i_mmap interval tree, two functions,
add_vma_to_mapping() and remove_vma_from_mapping(), are decoupled from
setup_vma_to_mm() and cleanup_vma_from_mm() respectively.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org
Closes: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
Closes: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v1 -> v2:
- handle error when vmi_shrink_vma() failed (reported by Sashiko)
- prevents mremap() with being shrunk for file-backed one like munmap()
- consider i_mmap updates on shrink/expand by calling newly decoupled
  functions, add_vma_to_mapping()/remove_vma_from_mapping()

v1: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/
---
 mm/nommu.c | 147 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 124 insertions(+), 23 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..89444ee2aca6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -559,36 +559,51 @@ static void put_nommu_region(struct vm_region *region)
 	__put_nommu_region(region);
 }
 
+static void add_vma_to_mapping(struct vm_area_struct *vma)
+{
+	struct address_space *mapping;
+
+	if (!vma->vm_file)
+		return;
+
+	mapping = vma->vm_file->f_mapping;
+	i_mmap_lock_write(mapping);
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	flush_dcache_mmap_unlock(mapping);
+	i_mmap_unlock_write(mapping);
+}
+
+static void remove_vma_from_mapping(struct vm_area_struct *vma)
+{
+	struct address_space *mapping;
+
+	if (!vma->vm_file)
+		return;
+
+	mapping = vma->vm_file->f_mapping;
+	i_mmap_lock_write(mapping);
+	flush_dcache_mmap_lock(mapping);
+	vma_interval_tree_remove(vma, &mapping->i_mmap);
+	flush_dcache_mmap_unlock(mapping);
+	i_mmap_unlock_write(mapping);
+}
+
 static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 {
 	vma->vm_mm = mm;
 
 	/* add the VMA to the mapping */
-	if (vma->vm_file) {
-		struct address_space *mapping = vma->vm_file->f_mapping;
-
-		i_mmap_lock_write(mapping);
-		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_insert(vma, &mapping->i_mmap);
-		flush_dcache_mmap_unlock(mapping);
-		i_mmap_unlock_write(mapping);
-	}
+	if (vma->vm_file)
+		add_vma_to_mapping(vma);
 }
 
 static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 {
 	vma->vm_mm->map_count--;
 	/* remove the VMA from the mapping */
-	if (vma->vm_file) {
-		struct address_space *mapping;
-		mapping = vma->vm_file->f_mapping;
-
-		i_mmap_lock_write(mapping);
-		flush_dcache_mmap_lock(mapping);
-		vma_interval_tree_remove(vma, &mapping->i_mmap);
-		flush_dcache_mmap_unlock(mapping);
-		i_mmap_unlock_write(mapping);
-	}
+	if (vma->vm_file)
+		remove_vma_from_mapping(vma);
 }
 
 /*
@@ -1351,6 +1366,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
+	remove_vma_from_mapping(vma);
+
 	down_write(&nommu_region_sem);
 	delete_nommu_region(vma->vm_region);
 	if (new_below) {
@@ -1364,6 +1381,11 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	add_nommu_region(new->vm_region);
 	up_write(&nommu_region_sem);
 
+	if (new->vm_file) {
+		vma->vm_file = get_file(vma->vm_file);
+		new->vm_file = get_file(new->vm_file);
+	}
+
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
 	vma_iter_store_new(vmi, new);
@@ -1386,16 +1408,20 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
 		      unsigned long from, unsigned long to)
 {
 	struct vm_region *region;
+	bool has_mapping = !!vma->vm_file;
+
+	if (has_mapping)
+		remove_vma_from_mapping(vma);
 
 	/* adjust the VMA's pointers, which may reposition it in the MM's tree
 	 * and list */
 	if (from > vma->vm_start) {
 		if (vma_iter_clear_gfp(vmi, from, vma->vm_end, GFP_KERNEL))
-			return -ENOMEM;
+			goto restore_mapping;
 		vma->vm_end = from;
 	} else {
 		if (vma_iter_clear_gfp(vmi, vma->vm_start, to, GFP_KERNEL))
-			return -ENOMEM;
+			goto restore_mapping;
 		vma->vm_start = to;
 	}
 
@@ -1415,7 +1441,15 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
 	up_write(&nommu_region_sem);
 
 	free_page_series(from, to);
+	if (has_mapping)
+		add_vma_to_mapping(vma);
+
 	return 0;
+
+restore_mapping:
+	if (has_mapping)
+		add_vma_to_mapping(vma);
+	return -ENOMEM;
 }
 
 /*
@@ -1544,6 +1578,9 @@ static unsigned long do_mremap(unsigned long addr,
 			unsigned long flags, unsigned long new_addr)
 {
 	struct vm_area_struct *vma;
+	int ret;
+
+	VMA_ITERATOR(vmi, current->mm, addr);
 
 	/* insanity checks first */
 	old_len = PAGE_ALIGN(old_len);
@@ -1567,11 +1604,75 @@ static unsigned long do_mremap(unsigned long addr,
 	if (is_nommu_shared_mapping(vma->vm_flags))
 		return (unsigned long) -EPERM;
 
-	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
+	/* vm_region->vm_top != vm_region->vm_end when sysctl_nr_trim_pages is 0 (default: 1) */
+	if (new_len > vma->vm_region->vm_top - vma->vm_region->vm_start)
 		return (unsigned long) -ENOMEM;
 
 	/* all checks complete - do it */
-	vma->vm_end = vma->vm_start + new_len;
+	if (new_len == old_len)
+		return vma->vm_start;
+
+	/* shrink only happens addr + new_len and old_len are in different pages */
+	if (new_len < old_len) {
+		/* like do_munmap(), we're allowed to shrink an anonymous VMA but not
+		 * a file-backed one
+		 */
+		if (vma->vm_file)
+			return (unsigned long) -EINVAL;
+
+		/* vmi_shrink_vma() needs from/to pointers to be removed,
+		 * (mainly used in munmap) so, specify them.
+		 */
+		ret = vmi_shrink_vma(&vmi, vma, addr + new_len, addr + old_len);
+		if (ret < 0)
+			return (unsigned long) ret;
+	} else {
+		/* growth path: grow up to vm_top should be handled here. */
+		unsigned long old_end = vma->vm_end;
+		unsigned long end = vma->vm_start + new_len;
+		unsigned long grow_len = end - old_end;
+
+		/*
+		 * Initialize the newly exposed portion before making it visible
+		 * through the VMA or i_mmap.
+		 */
+
+		/* read contents of extended map from file, or zero-filled if !vm_file */
+		if (vma->vm_file) {
+			loff_t fpos;
+
+			fpos = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+			fpos += old_end - vma->vm_start;
+
+			ret = nommu_read_iter(vma->vm_file, (void *)old_end,
+					      grow_len, &fpos);
+			if (ret < 0)
+				return (unsigned long)ret;
+
+			if (ret < grow_len)
+				memset((char *)old_end + ret, 0, grow_len - ret);
+		} else {
+			memset((void *)old_end, 0, grow_len);
+		}
+
+		/* The backing contents are ready. Now update the VMA bookkeeping. */
+		remove_vma_from_mapping(vma);
+
+		vma->vm_end = end;
+		ret = vma_iter_store_gfp(&vmi, vma, GFP_KERNEL);
+		if (ret) {
+			vma->vm_end = old_end;
+			add_vma_to_mapping(vma);
+			return (unsigned long)ret;
+		}
+
+		/* vm_top remains unchanged; only the logical end grows. */
+		down_write(&nommu_region_sem);
+		vma->vm_region->vm_end = end;
+		up_write(&nommu_region_sem);
+
+		add_vma_to_mapping(vma);
+	}
 	return vma->vm_start;
 }
 
-- 
2.43.0


