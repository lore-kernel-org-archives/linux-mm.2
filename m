Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5B0CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131026B0088; Thu,  4 Jun 2026 07:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108C16B008A; Thu,  4 Jun 2026 07:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EAE6B008C; Thu,  4 Jun 2026 07:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAD816B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:31:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5615CC1DDD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:31:59 +0000 (UTC)
X-FDA: 84842015958.13.8CA781D
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3991C120009
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:31:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYZ9U8Kh;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780572717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UgAkBaY/d/7ezqgbIeADZSgUpEbmYU0w3siNBffvvc=;
	b=tpr2ATqvmARL8iDpuzgiGoAedUTXprTe9JWL1cVYk9I/6avmevxhpUzJbcnT6PORKXtHCu
	vSQXdHtoH1PwJja9MHJFYgGrObZcoFY9ZlwqPm8jvvi0ZDgxszevjHIwsEoCzyt3sxbuJO
	MwVwmWMECd3GvORJJ/4tCTP43A438B8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYZ9U8Kh;
	spf=pass (imf29.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780572717;
	b=L3QpPG522AmeQbPFVjYXOJZ7ohtRW1ojZ8wK8KYLpLfNEwdg6wZ7bzLgipZdIKKKT8cAjv
	Kl7sAWg1k4Es55R/t5PSkat/n+m5CELfKxKz7oMdi6VQBkEzB+2rDHLRhAofxbXFZPqt73
	JZh2SzkZhBs08QqFSriHvSdkbzCLhus=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780572716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7UgAkBaY/d/7ezqgbIeADZSgUpEbmYU0w3siNBffvvc=;
	b=CYZ9U8Khray64pOp693cftUUp4vB3ZgNwkX1LXln+EDnb+eFbn6FJAM0Lljh/cImZvHzri
	wz1iNunqsUXPuoRf7OpPGiYDvWQTtObS+MYyknGp74jBvX8CokpefVlwqpQHm34CweoTWx
	5mcDoV3VGQVc26v0kCEl5Ejq+l1Ta78=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>
Cc: muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 1/3] mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
Date: Thu,  4 Jun 2026 19:30:59 +0800
Message-ID: <20260604113101.89510-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260604113101.89510-1-kaitao.cheng@linux.dev>
References: <20260604113101.89510-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3991C120009
X-Stat-Signature: nexdx4mn14kdupit3ex97btkfjppam7b
X-Rspam-User: 
X-HE-Tag: 1780572717-802273
X-HE-Meta: U2FsdGVkX18OqgHKWexu4QiiCTz8S9f11ty3FLaJ2JXoGT4PvTQXJTBVNuBaJaBJyaeiB7+lQ6O7rejZwQWAKx2gxMnrC58/SkML/93/cjcJmuoNmexU0YQzZg7Xpx8sTrzQlKN+pBm40wR09PuXTlv5Ae1AcSd+Ra0ADKHuxOB0fNJiPTl6QBV7D4hIe1WmfJVDRQkowr0pr9e7YGOM+AHidntrpaa367D6y7J33gLhmHZLQLp8Jak0G/RQSzcQzVVWqEL7hXbhDJV6/nWuiSu9alXdkfnZW3yN7aIlt8BIh+2YgqsLTkIbzzRaP8Ffx4zQ18j9BEXXhDnjUqoXhDy99aQbx9Tgv8Cwyx8+/zpKDh6tVaJr578WHh7yOaimMJwdZXt7hd89nBHBzZnY6iD2tFM9HnQ2+XBwZF5yDznh1ST9PakNOn2hgx+HMXArWAk/wjuMdEZ7MnUzfdxp4wy+Gp35KUMhc3khXSldZJgCZy+UJiBjTNHNBQ2H7Axr/o5P5r1on5Lad8fAsGu4xx1E/L0xxKPD2z55VIz6Aqz/le0m3mCa2wpM0XZeHekSJepojz1DLCZb0ok159hfAagNJzi7CnnbzH0zoRJF/mk95pu7fae5ZrTYiU/dVrb+jsMx5/CykpH0oH6k19w4yDpXk8vX2HGabvQMy7rJ79tiUfUZaFcjsZgSi0q5i9IPLS4vFcDlLINmSU6vmfc14fTTv3y6sn3PjoSiSBvv55vfJmXfAvt9UmY4CnkY1NjHwz2wCQhWMHb6abjVFnPvcSmjQxKBp1UJWVXrsp6vHw+fxGo6lgnWGSpIKv9cr5CGrudqtQWalra6IvaxVLoK8zTMRcqWBYYPpWawZbm1fpNnqO2pGohKuhoFolRMM80VqOysosBScTRqJA9H557ixlrqDMEOXW4LLZhFVw3E+X6Qu3UTn7WXuOKTyTZP8KmttkVbpQqX/H84NklrYOL
 btgZ9ABY
 j8a1Ft9KW4hSswvLezr9oy1dNCeC1V42i8Ry8zZM+S0AJRvdXQyOyjYxWA38yCc7NB+xGQHM8MK6Cs7AcnlFAkuTH6pJrKgVKhauDsWQ5BjYpd4HJDbNCYzNYHVSug0JOdTAQhUEw5dEBuZI7cSlcprwhT+nrhLpDVDd6ZbX/8d93ZCJPxWBvNU+ofp8gwhJ+vHXDKZjRWKvCsw5gSPRimoXKz6lk0V+Bmq/Uocc5FBmRWRnbNUMFWHoSOA==
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
---
 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          |  2 +-
 mm/vmalloc.c            | 23 ++++++++++++-----------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..9601e06624c8 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -308,14 +308,14 @@ static inline void set_vm_flush_reset_perms(void *addr) {}
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
2.43.0


