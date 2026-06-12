Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF682CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7506B0092; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363536B008C; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B466B0092; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 121856B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5D1E1A02AB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:43 +0000 (UTC)
X-FDA: 84869674806.09.4C51CF4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id ECD66180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7OlTz3G;
	spf=pass (imf06.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781231262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rnxGR0B6+PGyTAZIojjMa7xppAB2J31XJIy8wkmbfs=;
	b=Dk4znxNphiqE+S3VE2sU0eIpE041ajFVFbJzJIxNbmfKeno2iC7RDoOyp1+psgFBHXKlqp
	u04oHEbcTMqCscgglJeLzyCD123il7eUclW1orD1UOnAjVXkGTtKF/a2uONLXWep9p7t9L
	wsdbIsPKsWrxOaL5G+HK1OU5EqAnO9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781231262;
	b=g2XWT1mBj4T/rgpG/MZ8bGPgG1wg3sF+W2xJxx13MUjy/M/pQ55JOv0aXgBvf3U8X+UoL2
	3W4kQFfkCCTb8Da+D3/8fAhNEzVjnicbR1p+3wBUbusInNrLyRw6WosmaerWmKtQ57WhMN
	1Rqrq3zBCuvIxW13TsmFrg99KXHEEH4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7OlTz3G;
	spf=pass (imf06.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781231258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6rnxGR0B6+PGyTAZIojjMa7xppAB2J31XJIy8wkmbfs=;
	b=H7OlTz3GZdT+97dlSASQyZ/Coe5wEFEuw/D1Ow7sM+Emlkjgy9l4JjSPAcN/08GmGpSBFi
	fMDsllyGBS1KRg96K8bcg1V9b6tbZLaPiVechr3Pvw1IQY222uITqvjVaAodqgm/+LOeGd
	uwracgj0MSDAgVrlueq5VPJif5wZunI=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 1/3] mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
Date: Fri, 12 Jun 2026 10:26:46 +0800
Message-ID: <20260612022648.13008-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260612022648.13008-1-kaitao.cheng@linux.dev>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ECD66180002
X-Rspam-User: 
X-Stat-Signature: ipd3fb8k6q79z6noze7bdk55rjoc4hr5
X-Rspamd-Server: rspam08
X-HE-Tag: 1781231260-393700
X-HE-Meta: U2FsdGVkX1+bXXhvdKHb1NX8NmdGpnutIxYQDVUS4cWAYuCUrVrqFoUk5Hp1xBbS13HFm3FabH5f4uxmVRmUhf4f8gFTPoNXQEMn8ZxXek+p4A+w5GJ/boq5rkxaL9tjjciZeY9mJALSk8gyMxSjqtQWi4YKtAlqJ+TmiQceqJdpu8GWCzy8uxU3aKymTUri5xlQc//2p6HC7scw+gbyPSBGvbkbg7lzXfZP8yCIxW8GyxefqTmXpwwfaJjUgyZLQw1Xgma1DyKhu69ksxCWnB63kqFpQt2dRziVv7Ii6y0d1xUdHVBMhMdzjz0wb5wvzy3p70Db5Mcmotd/1qulytUEiwTE7KOYgkfWMpQ9+v6yzHrm1jTBCYujdrIJWAPECvOYuH4BhfhZX+bfiiBCrZQaxhp1jvAq76lOtwLhQ0q2hFo+f/tKgXJ8aOOxWYfo9Uj5/JdMMI5R9Q3V+Ba3HwxbzVvfu+iHHOPDJ5vVO343NtFKoyVPW1LHeNfu89O7qRadvqpoeNz+aJn6jarjTROAPXwMH5Jr0b7D3KwV3pT4QhbptpxoRH2HBB6Htu4nVatSFmQyNqJeW3ukkUMfmIsMAPdkFf0uKXNCO6c9v3tjfm5h8bgb/RVUg+k36YxsKpWyivv8OqNDwvOz2i+GvjRazM6jiY8SsEyBJZl7IyN0VG+PpShFyipujz7SRlxZlh0ziinUtGwUS5jepBfCDsABL3mFiS/39BEDkr/9SZXzdx4paKLDAJ3AA5t+xoZWd37CMoEBrpfJu7S3qCN395GbAFwqBUjEXbdTCs355yJXPrMSGciECpFpEcAYPG1bNJiFvmHOFrcKk7FQaGnhaRuq85CC+18GNiuYCyC2gqQ+HWFn5Oq9ijxCMKXmhP1EMaSIbslnVbBYl3R1OTlWOEFG7J4+BWI8Yf8MqEIJZjKZuxVNGop2vDshshNdumxIaoJDiz9Bw4SUW6iBGA8
 9Td+TAGE
 o6s4KDYJwVIMCIe0o87OMKkn/cnTfTSt2q6nw6HO5u9Uv8M+iP/0rbLOkwy/fbzdFbT1ILz2AdiJD1H+ymLchbEipCfXg37cijeXkEpHvlK9Uy6NiLtJyzIY3NV+5lC3PernEMl3gvNNQJMEiZtTbIIELlDoS4OSblcvCBwvQv2DCHXsC8qVc+aBDUyUvZDZbDMIKjyGaFeK04IGCMT+Pq1siKYymYFG75vA9cTO+VqQby0J3PeEKbaOjPSPhCCY4bnCtk4LnF00Rjc8=
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
2.43.0


