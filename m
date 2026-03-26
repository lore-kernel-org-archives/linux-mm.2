Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E4910A88D4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2353C6B0088; Thu, 26 Mar 2026 12:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5276B0089; Thu, 26 Mar 2026 12:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D49C6B008A; Thu, 26 Mar 2026 12:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBB696B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:26:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2B1FE14B0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:26:21 +0000 (UTC)
X-FDA: 84588741762.20.F1869E2
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2EFF80010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:26:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWgKZpSl;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774542380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/cqQrfIeVRKhirbOTonOVGcajNoS4JNy4y1RyCuZwpE=;
	b=8Oovp2DI7KlKojAeLrotXEMhn/83c6OrdeMD8Jhg2l64DremMz7i57ngjsbtdSR6p4TqKS
	QppOKvBc23wosMkqoqEljp13JdWBYXJz8ezIWi6emoDjFlL6yhf0ObSF6nxP+Rbk22J5qa
	o1v+Z0/DXXAhnUkcoxEeIlLWnkb4xUU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IWgKZpSl;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774542380; a=rsa-sha256;
	cv=none;
	b=Au0HD6/6gaQbaGDraKBIVQQZuD3CEf8+YLYYvzo3j/DRCcZeauAuzFJVb8eqXV6E/+1LJ9
	pN138A+3Uvc89t7oNr72GKJtd5XlRP5Z4GnZerBEuQc889xUB2+Tcx00hx4jV7KP4T6MLx
	QsxUt2ejfW9Ym/BxN2PBaXwZBYEiwcw=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb40149037so137455785a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774542379; x=1775147179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/cqQrfIeVRKhirbOTonOVGcajNoS4JNy4y1RyCuZwpE=;
        b=IWgKZpSlxaRxAchHyDIejhZE6iwGLNd5OoiKqCfeCmQRXv6mvDtSc72tYl3qV6qmKe
         /mZZd03sRkQhxqEBJRGhD7N2sABQvXv2/pxwyOfrPLs/0MZN51vcBooA3BE05ONsXS5r
         qxZ+P5+T4bXHhMp+5Qs2JCTCH0GMJBkFrd32sY1kplsnKz6LPz9QUQp+bP/kO0zFlDsX
         u6p6uNKVWI3wtsvq4zDW7+8VU+rVpJRo5tMPzUEgSAya53VT7OC3uxV2px812dClqSDW
         z2WWx9M8xgUXMMjdmQXI6s9urXHaASC3OHqufe8mv8IjVQAGbdhJ+DTj1WwLwq47fCE9
         2RJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774542379; x=1775147179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cqQrfIeVRKhirbOTonOVGcajNoS4JNy4y1RyCuZwpE=;
        b=Z4WNjrInnFjfmc1BHR1ph46T6BdlHGCYVxdZ1gjoz4t815qPqKHilnTnoIOblu9gT/
         G6BlxK7LmrD8eBYDPrx7PWfKk/k/LmpVyB38B0GQOJ4jDyQGP2MMrUU4fPUF3VzOO4XI
         AcDNEYxpgUJwMToS6bgLiKrdTAExS/tqZ4Sde/+P8q22Uxi0zAdFPDA3nOaLp453zJTt
         4qWFwckQbGF+cOLBlCoRKDqjWBUf7KOU8Hx1aCFGPGKCG8k8dRAcBJQ1hXnlYFWnk4r9
         VsF+xhPDeXhKuX7ENM1wlxZCCQNf94E/h9whl2uxlCgW949zlBPzJn87nNgEPkLHScGH
         Fm9w==
X-Gm-Message-State: AOJu0Yx57JG1seA6a8Ac/817pmcDxHCn4tyImU9Q9GpPnRLf+vcOjuXs
	2a9AvC4qda3cQNEdww00tI6Ev9Rbuyw7I1WTfUHtQK9kUJdaQ2gqpnb2msW/imP5nBZBWlLa4yE
	+Zxs5
X-Gm-Gg: ATEYQzwVbtcWq6nRtkeh35VhZIF2FSFiJU4BZPigGWZp600WxIfNP/SGtGRvzmsTLzh
	Tazw+YRk2w5MBGhSzOIkw9D5P+j1j7prkPTCPp0/oRq0wkBhzziWlLkZeQgMwRP1GVzDMeAx63v
	FdqJ0BwQ7U5P2QD4WnzO9A3h+9OVGFvzfoiaytpO4vAgBwPpwoJ+0U1lAs6A0KvL3xfq5NjeEvX
	y5ioOubrQ/8OE5mIaDFVRDWVEl20PTzZbgGOPfDHU5IfKqLk5FlXEYu9aXv1X/pxvI6hmvxYyzW
	SK7WS/CuZkEJRQ5ywNWPwd7PTfLw1DI/IA4hK9yzVqhf4LyJeWH0JKEre6QBC4VTFD0RwCeLog9
	h4Cq+YtoHFYo4h0jqpocd5XNQgwLJkSzWeW+nFxRHAukxEO4pHP2XtmSBHQMH6J9OlDDlbqbuSx
	x4auddcN5m4FaFAQTKFGo1OySkLvV2ztOPnCaH7GgRhQ==
X-Received: by 2002:a05:620a:700b:b0:8cf:da76:58ea with SMTP id af79cd13be357-8d001003c8amr1290364085a.25.1774542378652;
        Thu, 26 Mar 2026 09:26:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e3c3a18sm297378885a.12.2026.03.26.09.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:26:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	hughd@google.com
Cc: david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/shmem: use invalidate_lock to fix hole-punch race
Date: Thu, 26 Mar 2026 11:26:11 -0500
Message-ID: <20260326162611.693539-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2EFF80010
X-Stat-Signature: gre4rns34eycz6pdo9yxhzmeibm9tkzm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774542379-792832
X-HE-Meta: U2FsdGVkX19F6uCbCpLiejaDVWpxZgUfxOycVFsFQ37O6fzfzFQii4pWxUtcu7bd5clt2ZjuS0pD2x/y0zPTuB7+ycCd9TnY+p3GhrwzWlpbkrI5+8/EpZCHGee7qzTufxDE1CNJTBb2aE+GksMLNDsYVwUe74BigpxI8sj40oNmUovLbg26zV93ZOdJZC/ac5sr3JkkI4Ukl9D+ii1RNZHVPpiFo8d0zthgYuYi4WRiBoK9ohrdxLEczVK4834ySIVaTAujg+m6/EyB38E/F6B0vegCHvRltNX+J9Owbwskmu0igLVqyjN+RVTXcH/dd6QSaJtcrQdOaQTWy9h0ESzkPI4h8NDYPDympoLUotIiuwpwR4RjBuu/2FXpujZo2IPJ8agwMmv1dZf9VSN2HWKMwTLyqF2eqanKl7rkjFzhE3KU1QgsDWkJ1i3rLakbsvJmQ7Osxt4NQtFX7HzWLg6GOyBWILDj/Wq78zgGDtVuRjCa8mAEeIUHxT30TvQ1HCF+oIclrl1ouuFdI9NVKmDZn7OqcX20yBvCj7NX6Ixu3mD1QNVkMEsXsUkZf2wLX+uBrO3/Au1x3Sb+kCBW6fkeiobvZRPSQgxm7Dpyz/BuGFiFUBAN3/IFJPIeoIoROg0LxeqoEm5CV8tfAUgLfpdsrIO0qQ6Ft49ncalhxjxIGdBwmOMnw1Po5qjHKJmfjnc+ox4RlbCQ4n6BYKpW7b0C30n1uhxqNuWJ18qy6/hlF6dz+2qMg4UC/D4rv8OXLa9BJjHzWUGx74hhCX9/g2DQLCPJ0+ZmxPYnARQSc6z0va44Wf/sCTyCiehRvl0ff35MY3otXN3XT6xwsFaxz1bAk+Cl8YIVa112i0exU/ARZeSxaZpFTWjAcxKNH2SAGQK4ymYtbcReKdB77/yiwTwWebzNrrVKy4JXltmkMlRW1X/KrZNRu++YfojsqC8IwijD6jiRpvXst+AR134
 xMFWSuug
 LKr6Rp5H5+4Wqgv9F+eakWdcMk6xusGBvNGNFuXVGcoxTgcQuV8+Widc4HlEslg5wH5G5D/y31ElJVOTGdstv//TE3CEKwB6CKgjQm2WpdOx5HxSnmyTEgMrtPgNCIF/fXRvyywCZP+0F7oYmG/4j6wjmHMhmEhEH8axpVu4jqGP7ye4lRS/eoOG3cKDzL7ig8UHLu4cWSM2AY3DQefIyuPgj+NbO/IhGS7uX3nqxWLOLZoir01x252oORiFHEhfpxbBxLaFJhp2kwxj50jW1LR/tzR3Q4kb6hjvVr5BgRh+e34owAxlF3Tzbwr1dv2fVvQVf7QRWWNnDIUZN+DbEYU1b2vIoKcur6OzM0ICtrIx7Dc/K84wHLGkEXbsAVsMDtc9xB188/ix3uAa2FVd7doAhBwI+2dUKWIZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inflating a VM's balloon while vhost-user-net fork+exec's a helper
triggers "still mapped when deleted" on the memfd backing guest RAM:

  BUG: Bad page cache in process __balloon  pfn:6520704
  page dumped because: still mapped when deleted
  ...
  shmem_undo_range+0x3fa/0x570
  shmem_fallocate+0x366/0x4d0
  vfs_fallocate+0x13c/0x310

This BUG also resulted in guests seeing stale mappings backed by a
zeroed page, causing guest kernel panics.  I was unable to trace that
specific interaction, but it appears to be related to THP splitting.

Two races allow PTEs to be re-installed for a folio that fallocate
is about to remove from page cache:

Race 1 — fault-around (filemap_map_pages):

  fallocate              fault-around           fork
  --------               ------------           ----
  set i_private
  unmap_mapping_range()
  # zaps PTEs
                       filemap_map_pages()
                        # re-maps folio!
                                              dup_mmap()
                                              # child VMA
                                              # in tree
  shmem_undo_range()
    lock folio
    unmap_mapping_folio()
    # child VMA:
    #   no PTE, skip
                                            copy_page_range()
                                              # copies PTE
    # parent VMA:
    #   zaps PTE
  filemap_remove_folio()
    # mapcount=1, BUG!

filemap_map_pages() is called directly as .map_pages, bypassing
shmem_fault()'s i_private synchronization.

Race 2 — shmem_fault TOCTOU:

  fallocate                   shmem_fault
  --------                    -----------
                            check i_private → NULL
  set i_private
  unmap_mapping_range()
  # zaps PTEs
                            shmem_get_folio_gfp()
                              # finds folio in cache
                            finish_fault()
                              # installs PTE
  shmem_undo_range()
    truncate_inode_folio()
      # mapcount=1, BUG!

Fix both races with invalidate_lock.

This matches the existing pattern used by secretmem_fault(),
udf_page_mkwrite(), and zonefs_filemap_page_mkwrite(), all of
which take invalidate_lock shared under mmap_lock in their
fault handlers.

This also requires removing the rcu_read_lock() from
do_fault_around() so that .map_pages may use sleeping locks.

The outer rcu_read_lock is redundant for all in-tree .map_pages
implementations: every one either IS filemap_map_pages (which
takes rcu_read_lock) or is a thin wrapper around it.

Fixes: d7c1755179b8 ("mm: implement ->map_pages for shmem/tmpfs")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory.c |  2 --
 mm/shmem.c  | 33 ++++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e44469f9cf65..838583591fdf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5900,11 +5900,9 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
-	rcu_read_lock();
 	ret = vmf->vma->vm_ops->map_pages(vmf,
 			vmf->pgoff + from_pte - pte_off,
 			vmf->pgoff + to_pte - pte_off);
-	rcu_read_unlock();
 
 	return ret;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 4ecefe02881d..5c654b86f3cf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2731,7 +2731,8 @@ static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
 static vm_fault_t shmem_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
+	struct address_space *mapping = inode->i_mapping;
+	gfp_t gfp = mapping_gfp_mask(mapping);
 	struct folio *folio = NULL;
 	vm_fault_t ret = 0;
 	int err;
@@ -2747,8 +2748,15 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	}
 
 	WARN_ON_ONCE(vmf->page != NULL);
+	/*
+	 * shmem_fallocate(PUNCH_HOLE) holds invalidate_lock exclusive across
+	 * unmap+truncate.  Take it shared here so shmem_fault cannot obtain
+	 * a folio in the process of being punched.
+	 */
+	filemap_invalidate_lock_shared(mapping);
 	err = shmem_get_folio_gfp(inode, vmf->pgoff, 0, &folio, SGP_CACHE,
 				  gfp, vmf, &ret);
+	filemap_invalidate_unlock_shared(mapping);
 	if (err)
 		return vmf_error(err);
 	if (folio) {
@@ -3683,11 +3691,13 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		inode->i_private = &shmem_falloc;
 		spin_unlock(&inode->i_lock);
 
+		filemap_invalidate_lock(mapping);
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
+		filemap_invalidate_unlock(mapping);
 
 		spin_lock(&inode->i_lock);
 		inode->i_private = NULL;
@@ -5268,9 +5278,26 @@ static const struct super_operations shmem_ops = {
 #endif
 };
 
+/*
+ * shmem_fallocate(PUNCH_HOLE) holds invalidate_lock for write across
+ * unmap+truncate.  Take it for read here so fault-around cannot re-map
+ * pages being punched.
+ */
+static vm_fault_t shmem_map_pages(struct vm_fault *vmf,
+				  pgoff_t start_pgoff, pgoff_t end_pgoff)
+{
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	vm_fault_t ret;
+
+	filemap_invalidate_lock_shared(mapping);
+	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
+}
+
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= shmem_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
@@ -5282,7 +5309,7 @@ static const struct vm_operations_struct shmem_vm_ops = {
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.fault		= shmem_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= shmem_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
-- 
2.53.0


