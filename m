Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A70DCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 23:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065BD6B0088; Wed, 30 Sep 2026 19:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015936B008A; Wed, 30 Sep 2026 19:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47816B008C; Wed, 30 Sep 2026 19:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD5986B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:07:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87C42C0265
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:07:42 +0000 (UTC)
X-FDA: 85271967564.11.7FF5078
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3795CC000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:07:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vOEddTjI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of atish.patra@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=atish.patra@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790809660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A8pI+gWvdzJTFdCcM705+gHwITEs2Iw/Qqa2jW0Ho30=;
	b=q+I0XASpM5hc+PfnK8A3euO0ExAy6Z6KnlXmMJPC30QB0utBFnxvgu28h/pMhwus+u04RG
	pFbJcofT76mWumXl0WZ3fwdsv+br3hsgMKY76kgJB/qhf1ZAgo6WBjEwqvUxcUcW4odcR9
	QnsVT/OT7UMK3IJcfsoG+o0TTbxVPc0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vOEddTjI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of atish.patra@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=atish.patra@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790809660;
	b=0whatUQC05GaFXCj6uxZ3P/44BC8VOY4QM0Rq0+ayECh/1hCp+k2lrjyzSaVD0dcVy1seQ
	XVU9/q+KwNwPoGS2VerbDfeqSo/iZEzoCu7PAp0VXCY27Zfc2Jm9MyvO2ym8Ia666/E+Rt
	RRjGIcym5vcfvZIs1hm+YrX2CNDil/k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=04ieIlc6aU4Ve4Y+NdGSZT+Urd6ATWlIU5xxlRqKmY0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790809658; v=1; x=1791414458;
 b=vOEddTjIRAERxbVyzBLH+HN1cWKmKSf0/AizpuweP1iO4W4ZkdWQsfTbusJYIvyTOAqxqVtJ
 DK+9u4r7Phxrc5DD7KSG2pJelEEHI75HhCViLOLaKK3gYneVvatD6C65x5MbxKz78dmeaf9CSbZ
 6szyX/lL/22yhFL6mbepg2hw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id cd417db66a4fe8dc;
	Wed, 30 Sep 2026 23:07:38 +0000
X-Mizu-Trace-ID: cd417db66a4fe8dc
X-Migadu-Flow: FLOW_OUT
From: Atish Patra <atish.patra@linux.dev>
Date: Wed, 30 Sep 2026 16:07:31 -0700
Subject: [PATCH 6.18.y] mm/execmem: make the populate and alloc atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-execmem-atomic-6-18-y-v1-1-bd35d4523aab@meta.com>
X-B4-Tracking: v=1; b=H4sIADKWvWoC/x3MQQ6DIBBG4auYWXcMqEHpVZouCPy2s0ANmEZiv
 HuJy2/x3kkZSZDp2ZyU8JMs61KhHw35r1s+YAnV1KnOKNsrxgEfEdntaxTPhvXEhYPV3g4OARi
 ptlvCLMf9fZFp9dQWel/XH6pK1+RvAAAA
To: stable@vger.kernel.org
Cc: Hubert Mazur <hmazur@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Stanislaw Kardach <skardach@google.com>, 
 Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
 Atish Patra <atishp@meta.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: wxbg5ink94ynm4aopcd7jf7ype6xxf1b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3795CC000A
X-HE-Tag: 1790809659-184090
X-HE-Meta: U2FsdGVkX1+SjO7r4CmuRDaus5n+vk2gYDbCMmWyEh6+qZUqnLI7BclcLmOIDKLEl4qNu3HHKUo3Bj8oMs3C6ZX55VR0ntZqmIjsAZ3Cwp7NUgAB+/ZSu+z+hXl1ortPRljVxeFuwTDfemwKpE5ZuvIuHpuuoTYSeYc/zo9Td2u+aRA9WEMZ5b00q2wRqmC3p1lXmQUuinLscbS4qg1ZrMvSHHBfNxeLN1MU+2YKVzH09xPwN6jUFRTM9EQ3cX0Hz/bI/HLk5FsqXg4x3KZuhbn7kobPG8zFOrs6ZySNYQmscdkw/tc6cTaiXRXNsrMqJM/T1cuy1VdZYXVBj+hanzCC0P+LPvb6B12Sypo7v8C83HVE+ZlJg9svayOYXR+SNLGmMApkuo1ewm6g9d7OLtTDnMtc14Fkld9+47mTtzoGGRASCKl1hFE3zhmS/P+dgErLjVV72XEfYtufDcLy6mZOP4Pt4609hztpO/DhS4LpGT46DwsZ0X9eZaSD4RW3S0/PtIMbfAiz2dMtnb1e+/sLhqoeDj7J8nPJEOEXIsZUlVuUbHTrAAS+Eih4gzRrxGfuXek1J3sXjus8U7CyyWOWSMHOXWzkcHGStisdlG3akFM/woN48d6dnMQYp2Yj3lGRWGAYu+X/HNTAHjuiYQmApZoS1Fu5m5cYFc1n6jwE+UW10DQfVaU2gG5MJzAEwc6CrxDE1pCNGqeITXcsPSGo4YsppfGtX+WTeF9M8ILPFNSfLYHdWRIRiLk/RadH/pZSfR6xiOixmbwtqcNI9IKphdEhDBe85a1dDS+xBxdM3TrK4HWHkvUiepnOsHNpErglS5c5KfUCNBKmTw8Xb5LM1IB3MDJPE/PtDPdtQP6XCFGb1DLBJQT+aa8GIX8Csqb6wnmEGKK4n24C3zCKTH1ZEK+0vI4pOYDGTK3/bldxRxm5RIq9mYEuELpwVahX7J2xw8wSpr1PTlPUPtK
 m74y0+22
 LrqvDEJBonhjLJiIKXaI6Siyzz2iUPhB+/VQcskKMqinLX8QKjzUnA3DevAyb8UqaM7dSzX8FoYulXKvXbJWxWFgxibRs45GCbd9l4CXcPWf8+IEsdcn5GgYuJsmSwGVtHj4n3UCfQ9mSqdMyg0LmOlkwRpfq3NgQph8TCF/RG6/n93fQ64MkEn1selNNKoncJAgIvHYkJtMUUtoruuzAs4qLweWiLP9pPt1F2Tw2ljO1KEQck0c0CXAWs8GQZxGwSD3Yn6EPqIHDGFIlciNyezXfl74JvirKj6/s+HfravXoN7dzlhKJ2VfhgkWbkuY/Q0iK/il3MIDtn9nkYs5AHDJcKDLdsfSrk7QTM2JFH4qMM6mDIJ4/7c1pIAwWnjU+NkYjIyC/kqanH3n9osZRmToP5Ievl23NXAtalvk7Kqnt6uU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hubert Mazur <hmazur@google.com>

[ Upstream commit 1871d548fc4feb007644efb6d669c93a4e191254 ]

When a block of memory is requested from the execmem manager it tries to
find a suitable fragment by traversing the free_areas.  In case there is
no such block, a new memory area is added to the free_areas and then
allocated to the caller by traversing the free_area tree again.

The above operations of allocation and tree traversal are not atomic hence
another request may consume this newly allocated memory block which
results in the allocation failure for the original request.  Such
occurrence can be spotted on devices running the 6.18 kernel during the
parallel modules loading.

To mitigate such resource races execute the cache population and
allocation operations under one mutex lock.

Link: https://lkml.kernel.org/r/20260320075723.779985-1-hmazur@google.com
Signed-off-by: Hubert Mazur <hmazur@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stanislaw Kardach <skardach@google.com>
Cc: Michal Krawczyk <mikrawczyk@google.com>
Cc: Slawomir Rosek <srosek@google.com>
Cc: Hubert Mazur <hmazur@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Atish Patra <atishp@meta.com>
---
Please apply this fix to the 6.18.y stable tree.

We noticed that kvm module loading failures on intel cooperlake/AMD
Milan hosts recently. This race condition might have contributed to
that. The issue was reproduced with a test module that widened the
window beteen populate-to-allocate interval and queued the
normal execmem cache-clean worker.

On an unpatched 6.18.53 kernel, the forced race reproduced the missing
/dev/kvm failure in 2 of 2 kexec boots.  A parallel module-load test
running five modules for ten rounds produced 15 ENOMEM failures from 50
loads.

With the upstream fix applied, 10 of 10 kexec boots verified successuflly
with no issues with kvm module loading. The same parallel module loading
test completed with 50 iterations.

The patch applies cleanly to v6.18.54 with no changes from upstream.
Please let me know if anybody needs other information.
---
 mm/execmem.c | 55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c9243..084a207e4278b 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -203,13 +203,6 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
 }
 
-static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
-{
-	guard(mutex)(&execmem_cache.mutex);
-
-	return execmem_cache_add_locked(ptr, size, gfp_mask);
-}
-
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
 			 size_t size)
 {
@@ -225,18 +218,16 @@ static bool within_range(struct execmem_range *range, struct ma_state *mas,
 	return false;
 }
 
-static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
 	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
 	MA_STATE(mas_free, free_areas, 0, ULONG_MAX);
 	MA_STATE(mas_busy, busy_areas, 0, ULONG_MAX);
-	struct mutex *mutex = &execmem_cache.mutex;
 	unsigned long addr, last, area_size = 0;
 	void *area, *ptr = NULL;
 	int err;
 
-	mutex_lock(mutex);
 	mas_for_each(&mas_free, area, ULONG_MAX) {
 		area_size = mas_range_len(&mas_free);
 
@@ -245,7 +236,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	}
 
 	if (area_size < size)
-		goto out_unlock;
+		return NULL;
 
 	addr = mas_free.index;
 	last = mas_free.last;
@@ -254,7 +245,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		goto out_unlock;
+		return NULL;
 
 	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
 	if (area_size > size) {
@@ -268,19 +259,25 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 		if (err) {
 			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			goto out_unlock;
+			return NULL;
 		}
 	}
 	ptr = (void *)addr;
 
-out_unlock:
-	mutex_unlock(mutex);
 	return ptr;
 }
 
-static int execmem_cache_populate(struct execmem_range *range, size_t size)
+static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+{
+	guard(mutex)(&execmem_cache.mutex);
+
+	return execmem_cache_alloc_locked(range, size);
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
+	struct mutex *mutex = &execmem_cache.mutex;
 	struct vm_struct *vm;
 	size_t alloc_size;
 	int err = -ENOMEM;
@@ -294,7 +291,7 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	}
 
 	if (!p)
-		return err;
+		return NULL;
 
 	vm = find_vm_area(p);
 	if (!vm)
@@ -307,33 +304,39 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
+	/*
+	 * New memory blocks must be allocated and added to the cache
+	 * as an atomic operation, otherwise they may be consumed
+	 * by a parallel call to the execmem_cache_alloc function.
+	 */
+	mutex_lock(mutex);
+	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
 	if (err)
 		goto err_reset_direct_map;
 
-	return 0;
+	p = execmem_cache_alloc_locked(range, size);
+
+	mutex_unlock(mutex);
+
+	return p;
 
 err_reset_direct_map:
+	mutex_unlock(mutex);
 	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
-	return err;
+	return NULL;
 }
 
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
-	int err;
 
 	p = __execmem_cache_alloc(range, size);
 	if (p)
 		return p;
 
-	err = execmem_cache_populate(range, size);
-	if (err)
-		return NULL;
-
-	return __execmem_cache_alloc(range, size);
+	return execmem_cache_populate_alloc(range, size);
 }
 
 static inline bool is_pending_free(void *ptr)

---
base-commit: 1b357ecb321392158d507b04672ffee57bfa071d
change-id: 20260930-execmem-atomic-6-18-y-d91c94aedee7

Best regards,
-- 
Atish Patra <atishp@meta.com>


