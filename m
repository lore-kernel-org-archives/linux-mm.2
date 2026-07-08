Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE154C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B69D6B0088; Wed,  8 Jul 2026 01:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486736B008A; Wed,  8 Jul 2026 01:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E536B008C; Wed,  8 Jul 2026 01:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01B0D6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:28:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F3671A0673
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:28:28 +0000 (UTC)
X-FDA: 84964479096.25.AC99EED
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id A251740003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:28:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E0mTuDJE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783488506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r8c658LFrC5kUpw1BBMNZ+UryPir01aUoDyxaQYNE1A=;
	b=n0NgSyv7bizCdXCm4aKz02LxdUgjvKknZIpdHlm1+scZTbM8/K05tsrrNrXqT1g8U565Rw
	hJ+XTkG6LP/y16lCVk7bVCmKKMV49LgZp/PVXTIAG6y3y1UEStGKwNS6R9BVYd/tr2U9MB
	AdmEjFH3z2h4DrkFk87IfW+R5LsJhi4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E0mTuDJE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783488506;
	b=Ebl4ETcrhVEG8sYBJ52APCE/vg8n93HjivA1y1xkq674rJ7sDf65b3FeuaA6VNwiQfYet6
	usEwzO9LEVUXLJF2GgCT1cG+DvtXav4nNBTcLc5hE6/QgsXBYMBSU81QDK/cnEIjja17/d
	fufuyhRkkc29VO7bH527a8uJt4OD9M8=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso3483765ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783488505; x=1784093305; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r8c658LFrC5kUpw1BBMNZ+UryPir01aUoDyxaQYNE1A=;
        b=E0mTuDJEj50Vomu594HsfUAVdpwpLeIXKS+JkmFaLqSY4t8HNRpaQl1i6ZxaZ9T8x1
         uLn9PNeiA2sLx6job2dI3A4iRYWA+4j5HCpCaTvRXj/UZbr0CePpYEhN5ZwG/3lluuUL
         Ddc6+gPkBOoYVy53hodH0S6mNRrVoNJbNAA+Flu1tBOBrTexsHLxTEItUsXAQAEZOOrG
         BsNCP3haC2lJWmmm5zOSnIJeodEUHqgvznVQ9ipAt0DW3Kq7npl61XgjL7hIIX4Ppoj5
         o7MHnBdv1gQOht/N8xM2DNrwTDyk3IpVFFkSWTi6chUl3tu7UdSoNewGH+qTvDaqSDsB
         9L3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783488505; x=1784093305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8c658LFrC5kUpw1BBMNZ+UryPir01aUoDyxaQYNE1A=;
        b=ojoq788Tj6ha3prWpa1WL1vjgTlk7e6oPz0wTkIK/ybSe8muErWB/uSyNxEtDgpjvS
         LFSOFoxTM5Zcc+Uc9LhfECdbkBmj/QIaZEnYWC6HdUvucvj1EhU4eC1OFPHoj691wM1A
         UsdWrvPOf4pZ57O2XC0cZEGZ9oxoS4bQtmHaovUqBBoanfjU/l1RJQlYEIbZAT8avv0R
         nN6PWc+4rYFlvoLa9JQEi/xTXOz8yK3qEXef2Jt/t1+MA10r9IP+FrCgV2RWqXLTHKIB
         M5YtycDuAWrLue3hz/L+5PqgIpQpuEwSnVeZjG+3xWBN/ewTb2WIxnAIVypb4DnxxNEb
         WeGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLTZ8Gh5nDvNVCNXhSi64aAKidcpBr82keHZ2ta7J96fNsRxdL5uI+W4x5CDvLyONMEMEKbYlA3w==@kvack.org
X-Gm-Message-State: AOJu0YzmYGXOOU+6g9LUNjQbIhhQUgcYQkdwrx7VHmknV25dDt1+lGki
	z2Ns2Kx/oToUGsygPOosoyRDglXprsT1KhsxQDjlNDfvQnUrDqSbQvsA
X-Gm-Gg: AfdE7cke72Qr8Ot3e+1aqkcJbvYKhNEaktiVmzgUnPf34a3zQg2fmK4L7HwF5nvmZlw
	vHfYJvD3fJiT9XkVRqmfvbl5N934dpHqEydNo7U9jx3rKjwe3M9fnQ2izOGtsj91pmEpJK1gBOP
	JWoCIP5pRgenVqKfnzVOI/qSI+WCl6D4G8LTscFVfSJYGaiQlJJo+P5WIaGqlYwqef7TyBv/RGq
	hqm38LTpkJKA/1w+C3wsWuaGkdSHsjI8bDAhQCSPc0JuYc2e8skPhPVqcWCZEYhTDalGdEPBCZw
	n/shEVFFy8WFHRjqnkkiAJDzMb0mu3aXFLGWUbrLZsG3a67eij+PA/lsDSBKLUTV6ehYFDeAGez
	kG/s+LSGCCH7J0bJiTp5zPB9Nmkk/NWj8g47DsY5LCUScFzNvPBbzAl4eVa0IaMamADkgqyM6Lx
	nNwnTwIzUZ9aw+/x/td7HNYpp2t7RrTsllhsVz+mEvHAXF+rBX9lL6s6LSNecMcBj67knD3KBaU
	H5xjzkmLD0KZ4SXgw==
X-Received: by 2002:a05:6a21:4910:b0:3bf:b08a:cded with SMTP id adf61e73a8af0-3c0bce9caf9mr1052310637.37.1783488505083;
        Tue, 07 Jul 2026 22:28:25 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca75ef0c30dsm181962a12.17.2026.07.07.22.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:28:24 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 34172148FCB3; Wed,  8 Jul 2026 14:28:23 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v2] mm: nommu: fix the error path when vma_iter_prealloc() fails
Date: Wed,  8 Jul 2026 14:28:20 +0900
Message-ID: <20260708052820.556085-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A251740003
X-Stat-Signature: np18d85pgeix7owzh9z5mfq3uu4c4psj
X-Rspam-User: 
X-HE-Tag: 1783488506-518775
X-HE-Meta: U2FsdGVkX1+S1xRq0xbYB82JCsZ9DDCZNe2zTyNiswLMWnoxwKR1cMIw1H+w8RCGqZ5cI0fATg8s5txmzoNr2JMhE+backzMXUQTZfths3rNdXi8boya3Te0iy4LEs1zpJzC8X9g76OPU+g4/IUUdQfhfmbU2KL2pngyWWJ7tRX5lC+t8GihBFpcavwxFM5xCE/mBKOMyVwlqmMWhXPISCkV8M7Yafzbyi7Tw3IJs4N1t9hG+mjnec61MQ9IkKmt6FL+HR6P+SfhCk7mKUXNgJ0HBJuaGcHRjw4PDXXMHmqk7Ta2wg9hxfsedlc6y5lV4FGjjpi6/kPWOamAwNpNkOfKLOBn24RN+zU6yk5D9Nxin2w8I3MkyIwNOqn3UzET+zMiYQw6TngoRp5sAp/8DDdqXASAOhYF/hA27aXzKwH9zVivi/I0veJUx56WKDSfuynGjofazAj/9hixJC5yw9NA6P4QSGWULu1NnAwjA4fP+qL9R2OCP+qZcmhH/+lb5CcCjIx3azcK/rUJr1BalA/6rThC3vmGbEK6UHcQI72Xo1pwOqok3RoFlurATI/W3RLdO0Fqkwg6/dn7oROJJNh0jOBvrHKFfrmz2LIjf1MH1mWpZ1Ur9Rah/LBK9Po0TifdMA/hShExbMhZPx0Bqm8NjjXpG78CIkBxjyQDjUAA//La6h5JSex0QdcBH37cfRM58dSunGPaIgkL93ftHtzcnl4/uZTxAUsS7kduc43hD32FD6HHwT79NidueqxPtgLEuf/jm2h44gC2GjVeGpByo9MvwMnq8DTZhtou8+mYQYCbovUeLUnxRM+aWqAhG99LophfZhZjY1w9nAYymfv6QIKU4nffseX/qsiDGw/FkrgHPjNhmk7Ju5pnNpSVRlppGMB5Z19Xh2wycglnknznjg2SegfoQ0PhllUYwAXgBxoT1UufuNsLBqfXQ74H3/C/OHO6J4EEgW5cc0N
 dav46lz2
 CyHw4sg9PmS+QAhrkfToNye4E8w58OV9Ca7G5hGHNo1BMynQO2wHTrsnhyFCTafkViFtkl81qZY7ZbHymAAXzfhQeI07xgxxD/rNHTbgbYL8Oj7wtPdWakPdeuLUuWISCHYmPOTkFzZlxOrUhbxcT/OO18NR+sh8I1J6kHfWygFzaKC8Pa2UZWpP5Dp8NZd5OYM0oHlnB9wXUdMERR75O5+bLAR07xgmxkImMqHY2oHQsz/rPb26TfGHPVau2e6RkIM+tN6SGDprLRM0NivcPV0IK59njgQGY+NGYrgSVQBGQh8P4NhzJ2fKcOADRsT1QVfpozVs7KvWdSZK4uiMxU67sj5k++tSIx5E7nJrodPTfQEV68LcwSJ3xAOHGO0jHLMm3UWrjIgSYBTNcutARqc1dMZRo02NC1sYGs0ua9254m82H/PwgIO36wftOWZv/VzmzkdEbjFPjti1+MxRYdUPNwYJdC/GwkOXClHI5TXxNyGuVlMKqfQRQwnJDN+JZUJQQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vma_iter_prealloc() fails in do_mmap(), it jumps to error_just_free
as a error path of this function, but there are several possible issues.

1) It jumps to error_just_free without updating ret to -ENOMEM, meaning
do_mmap() will return 0 on failure.

2) The error path unconditionally frees the region struct.
Since the region was already added to the global nommu_region_tree via
add_nommu_region(), leaving it makes a potential dangling pointer in
the tree and may cause a use-after-free on the next tree walk.

3) If do_mmap() finds an existing overlapping shared region, it
increments its usage, sets region to this existing pregion, and jumps to
share:

	region = pregion;
	result = start;
	goto share;

When vma_iter_prealloc() fails and jumps to error_just_free, the error
path unconditionally frees the region:

error:
	...
	if (region->vm_file)
		fput(region->vm_file);
	kmem_cache_free(vm_region_jar, region);

This potentially leaves a dangling pointer in nommu_region_tree and
causes RB-tree corruption.

4) When establishing a new private mapping, do_mmap_private() allocates
physical pages and assigns them to region->vm_start:

	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
	...
	region->vm_start = (unsigned long) base;

If we later fail at vma_iter_prealloc() and jump to error_just_free, the
region struct is freed, but the backing physical memory isn't freed via
free_page_series().

5) In the error label of do_mmap(), the vm_area_struct allocated is
freed by vm_area_free(vma) but not called after vma_close(), leaving
potential memory leak which should be handled by a custom .close handler
of vm_ops.

This commit fixes those issues by introducing new jump label,
error_vma_iter_prealloc, to correctly handle the error case of
vma_iter_prealloc(), updating ret value (1), and move the region updates
after the place that the allocation is finished (2).

Additionally, the commit removes the existing goto label, error, and
consolidates to error_just_free as existing `goto error;` code blocks
always release nommu_region_sem.

Moreover, it only frees region allocated in this request to avoid
freeing the shared, existing region shared by other processes (3), and
free physical memory when do_mmap_private() allocates (4). It also add
vma_close() before vm_area_free() to fix the potential leak (5).

Those issues are discovered by Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime%40gmail.com
Fixes: b5df09226450 ("mm: set up vma iterator for vma_iter_prealloc() calls")
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v2: consolidate commits into a single patch, address additional Sashiko
review (sorry for the noise: i have no working local environment of
sashiko/gemini)
v1: https://lore.kernel.org/linux-mm/20260707235137.498738-1-thehajime@gmail.com/T/#t
---
 mm/nommu.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 815ebefddfae..cbab1fe22be9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1181,7 +1181,6 @@ unsigned long do_mmap(struct file *file,
 		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
 		goto error_just_free;
-	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
 	if (!vma->vm_file &&
@@ -1199,7 +1198,9 @@ unsigned long do_mmap(struct file *file,
 	BUG_ON(!vma->vm_region);
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
-		goto error_just_free;
+		goto error_vma_iter_prealloc;
+
+	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
@@ -1218,22 +1219,41 @@ unsigned long do_mmap(struct file *file,
 	return result;
 
 error_just_free:
+	/* if the error was from shared mapping/existing region, don't free the region.
+	 * this has to be before releasing semaphore.
+	 */
+	if (region->vm_usage == 1) {
+		if (region->vm_file)
+			fput(region->vm_file);
+		kmem_cache_free(vm_region_jar, region);
+
+	} else
+		region->vm_usage--;
+
 	up_write(&nommu_region_sem);
-error:
 	vma_iter_free(&vmi);
-	if (region->vm_file)
-		fput(region->vm_file);
-	kmem_cache_free(vm_region_jar, region);
+
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vm_area_free(vma);
 	return ret;
 
 sharing_violation:
-	up_write(&nommu_region_sem);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
-	goto error;
+	goto error_just_free;
+
+error_vma_iter_prealloc:
+	pr_warn("Allocation of vma iterator for process %d failed\n", current->pid);
+	show_mem();
+	ret = -ENOMEM;
+
+	/* in case that the region is allocated via do_mmap_private() */
+	if ((region->vm_usage == 1) && (region->vm_flags & VM_MAPPED_COPY))
+		free_page_series(region->vm_start, region->vm_top);
+
+	goto error_just_free;
 
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
-- 
2.43.0


