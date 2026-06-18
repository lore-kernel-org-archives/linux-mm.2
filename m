Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1022FCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3506B0098; Thu, 18 Jun 2026 09:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6F96B0099; Thu, 18 Jun 2026 09:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904FC6B009B; Thu, 18 Jun 2026 09:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBE66B0098
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:13:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8867B12071A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:09 +0000 (UTC)
X-FDA: 84893053938.29.9A51B41
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD94D20005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QmrJfII3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9XCRSXj9/f1R7nasriP4imZqAE/sq2MzaClqoZq5k8=;
	b=rA5EC/ZqGxeptJWzQNhrb0mMJ/CkSgTdZncO1wqoaNOmtxOBO0z0DyeNTpdc2QZcyg4YiG
	yfKQ3udRhjDXBq8t21I6M0Bx/AesGGlroaLz4xDM/V014fHQ2woioubeiOHvKH2LegHl7M
	Up87o/yLLsik+RUxLCdozYLuh1LsQFI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QmrJfII3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787908;
	b=rPC3EOofibiMhIEZxhTy1GNpnr1tqljPSroBu/ZFI2+1y055cAzkFWLIf5jiuvcRGshvFF
	W1VIXWW7I1ImvSKOfQYn8kQLi67x2S4Ot5wNjXMlUi4A+f1YHyGetzBqvdGFjMe/N+AGBv
	oqD7OnedpjQoE8oPHMI0N4rBZ3ULoto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781787906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9XCRSXj9/f1R7nasriP4imZqAE/sq2MzaClqoZq5k8=;
	b=QmrJfII37rx0M9ATGtnucjQGnVE21TKh1ziDi4lBMTCozuHCnJLoI/2JlfbJk9euP1xAau
	zJhxBJfg/5EcOUr8yBFk8N4ceWgQcRA00mwgybevvN0oQUqSxIcWqqOM+b/u589ia4P505
	M0iw3RaQ/JmLZ0PvQTKgY+v87xKY1Nc=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: [PATCH v4 1/4] mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
Date: Thu, 18 Jun 2026 21:04:11 +0800
Message-ID: <20260618130414.96383-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260618130414.96383-1-kaitao.cheng@linux.dev>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD94D20005
X-Stat-Signature: nmm9e7unijh6h5rgwu49rngb1ereyfkg
X-Rspam-User: 
X-HE-Tag: 1781787907-60495
X-HE-Meta: U2FsdGVkX1+DxPrPpLUeE8yWyTZhwx9Zttl2FChH+YSkt9nP98bbS4RKAIMV8R6N6BPPAB0tjduwT91rplXnBWqp0ev8VPEkdFvkpRbWK3Tkc4d/8vO4qlpm+AHSaraIkAgjSFsVxxoDrlEJP+vrXBgmMvi0z8FI8rpwvvTNgF7/txSyLI+CkL2IjTWC6SL+7k/ggU7zLE3SqRyJ/sNWb7hnQt/77w46BxVB0Jeqw1aD7etHuX3XtSI3LZFgwms+owMV1yVu46t9QI8k6W/IUEg0SJbakHNEnOuLojqxBphqKiXLiLjF/VgpUV/TI6ChWnC35n60uusYbXKHmBHljIXH4/P5RCJeBvqs2W9VuFE4/S+N9KcILyARwoXS7sE8wT6CPd6kAEQTWV9dNfXibNYqStiqERhZze4losyHAXtqe1gLUvDmqFkecZewd8AZqgsF/yGtPjTVOzFW8Wz4SNyrejAoMLici0S2snVghv9jtrdfKFV8NCNmOYvWpinmONxn5DJhtGQILFdhM4BryMEEcc83SVD9t4nAororSpMWM37s6dXTGNFDLMSgpNXyyJYFgYA2UtlyC9d4Ss5L7C/vDKAeflU6u+qFRQ5vzFcZLagbhPWf26CN4GoRzDYfaIs+D46rfZN5YUmloNmwjbVKSH7FvGbi5HVIGowQQ69Nv7P5BgwRsR2/vMN6KpEzmgnKdr/lxUAX//Pw73XM8pQ3urjZltYmemfLbij9ilB+EEc7XcgIDy88c/H5RHex9G+xFyeryoDL2RiEqp71Kxkm0k8KmZ2Zietl944AlkVeY9DnV/iladvIla2soy2oZSrOfX654RHgx81rcJWQc/31PXv3fyJ0qM2tQb2PaTaipRQHzWJu0dAdpI19qN8LXVR0nEW2UYicwtYcprL7X6szRV0Gzfnjjpq6JeQg/7uvgF13BP2k0AKwcDLi+iPwsCtIO0lZL3zFT/GRtmc
 qeEWGFY0
 QSJ5ZoWHBUt2MBQ2p+C7z5HffUGwnFExZRexTwRIK2cgZtXkvfodni7KthWOUNNlU2kPMJspdgmjU7Zbc/Xz8xnKi8Cgp2Khk4yPvDu1TZKtjkEMS4qP16/SZyS7UZn9fgKWskycFoL6ekQLxqTGAM47E0LySHnm9I39HIoIXWhJAZbZBrXOCS0Hjte7X0L5YkkzWpG42n47GZwlD1gvnArmx1Q2XX/1Su7wQvK7gkeDPpPL3urdNke7wDyf7zRZ7UoJDNbC7eCMeapM61E6KYAZ+qw/R04lOQuQ7SVV/L91Ce58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask
and passes it down to the backing percpu allocator. However, when the
percpu vmalloc allocator has to create a new chunk, pcpu_create_chunk()
calls pcpu_get_vm_areas() to allocate the corresponding vmalloc areas.

pcpu_get_vm_areas() currently performs its internal allocations with
GFP_KERNEL, including vmap area metadata, vm_struct metadata and KASAN
vmalloc shadow population. This means that a caller which deliberately
uses GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while creating
the vmalloc areas for a new percpu chunk.

One possible case is blk-cgroup after commit 5d726c4dbeed
("blk-cgroup: fix possible deadlock while configuring policy").
blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:

  CPU0: blkg_conf_prep()
    mutex_lock(q->blkcg_mutex)
    blkg_alloc(..., GFP_NOIO)
      alloc_percpu_gfp(..., GFP_NOIO)
        pcpu_alloc_noprof(..., GFP_NOIO)
	  pcpu_create_chunk(GFP_NOIO)
	    pcpu_get_vm_areas()
              -> if percpu chunks are exhausted, chunk create may do
                 internal GFP_KERNEL allocations
              -> direct reclaim / writeback can issue IO to this queue
              -> IO waits because the queue is frozen

  CPU1: blkcg_deactivate_policy()
    blk_mq_freeze_queue(q)
    mutex_lock(q->blkcg_mutex)
      -> waits for CPU0
    ... unfreeze only happens after q->blkcg_mutex is acquired/released

So the concern is that the caller deliberately uses GFP_NOIO because it
may hold a lock which can be acquired after queue freeze, but the percpu
slow path can temporarily lose that allocation context.

Pass the caller supplied GFP mask from pcpu_create_chunk() to
pcpu_get_vm_areas(), and use it for the internal vmalloc metadata and
KASAN shadow allocations.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Shivam Kalra <shivamkalra98@zohomail.in>
Acked-by: Dennis Zhou <dennis@kernel.org>
---
 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          |  2 +-
 mm/vmalloc.c            | 23 ++++++++++++-----------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index d87dc7f77f4e..e4d8d0a9f30f 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -310,14 +310,14 @@ static inline void set_vm_flush_reset_perms(void *addr) {}
 #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align);
+				     size_t align, gfp_t gfp);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
 # else
 static inline struct vm_struct **
 pcpu_get_vm_areas(const unsigned long *offsets,
 		const size_t *sizes, int nr_vms,
-		size_t align)
+		size_t align, gfp_t gfp)
 {
 	return NULL;
 }
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590..69b00741dc68 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -340,7 +340,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 		return NULL;
 
 	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				pcpu_nr_groups, pcpu_atom_size);
+				pcpu_nr_groups, pcpu_atom_size, gfp);
 	if (!vms) {
 		pcpu_free_chunk(chunk);
 		return NULL;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 1afca3568b9b..08f468135e4d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4946,16 +4946,17 @@ pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
  * @sizes: array containing size of each area
  * @nr_vms: the number of areas to allocate
  * @align: alignment, all entries in @offsets and @sizes must be aligned to this
+ * @gfp: allocation flags passed to the underlying memory allocator
  *
  * Returns: kmalloc'd vm_struct pointer array pointing to allocated
  *	    vm_structs on success, %NULL on failure
  *
  * Percpu allocator wants to use congruent vm areas so that it can
  * maintain the offsets among percpu areas.  This function allocates
- * congruent vmalloc areas for it with GFP_KERNEL.  These areas tend to
- * be scattered pretty far, distance between two areas easily going up
- * to gigabytes.  To avoid interacting with regular vmallocs, these
- * areas are allocated from top.
+ * congruent vmalloc areas for it. These areas tend to be scattered
+ * pretty far, distance between two areas easily going up to gigabytes.
+ * To avoid interacting with regular vmallocs, these areas are allocated
+ * from top.
  *
  * Despite its complicated look, this allocator is rather simple. It
  * does everything top-down and scans free blocks from the end looking
@@ -4966,7 +4967,7 @@ pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
-				     size_t align)
+				     size_t align, gfp_t gfp)
 {
 	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
 	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
@@ -5004,14 +5005,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		return NULL;
 	}
 
-	vms = kzalloc_objs(vms[0], nr_vms);
-	vas = kzalloc_objs(vas[0], nr_vms);
+	vms = kzalloc_objs(vms[0], nr_vms, gfp);
+	vas = kzalloc_objs(vas[0], nr_vms, gfp);
 	if (!vas || !vms)
 		goto err_free2;
 
 	for (area = 0; area < nr_vms; area++) {
-		vas[area] = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
-		vms[area] = kzalloc_obj(struct vm_struct);
+		vas[area] = kmem_cache_zalloc(vmap_area_cachep, gfp);
+		vms[area] = kzalloc_obj(struct vm_struct, gfp);
 		if (!vas[area] || !vms[area])
 			goto err_free;
 	}
@@ -5101,7 +5102,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 
 	/* populate the kasan shadow space */
 	for (area = 0; area < nr_vms; area++) {
-		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
+		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], gfp))
 			goto err_free_shadow;
 	}
 
@@ -5158,7 +5159,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				continue;
 
 			vas[area] = kmem_cache_zalloc(
-				vmap_area_cachep, GFP_KERNEL);
+				vmap_area_cachep, gfp);
 			if (!vas[area])
 				goto err_free;
 		}
-- 
2.50.1 (Apple Git-155)


