Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48E01093188
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38EC6B009F; Fri, 20 Mar 2026 03:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C108A6B00A0; Fri, 20 Mar 2026 03:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25E36B00A1; Fri, 20 Mar 2026 03:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A08656B009F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:57:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E08CC299F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:57:40 +0000 (UTC)
X-FDA: 84565687080.17.41CFD07
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E8D41C000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:57:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3Bb3Xiw;
	spf=pass (imf20.hostedemail.com: domain of 38P28aQYKCDUYdRqliXffXcV.TfdcZelo-ddbmRTb.fiX@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38P28aQYKCDUYdRqliXffXcV.TfdcZelo-ddbmRTb.fiX@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773993458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sH3eNdN5a36zAeWkkdWtNUuBUS2xJvF1FweZBpquDLE=;
	b=S2YdT8l6ZPyhwUyOpDN3e8C0uq4Aug4JWsgJMhrPlh3454SekOwkKH7HAz/ge9zi5lS5vr
	PLRWuW/KgHmSR2zkS0BMrfN3CYTL7nrMcE1uoazDNn35Nyysb4VAXOJioRHj5Mxmx/VJoC
	k5BJpHAjfiSPsyeyVgEmAqRT2cBaqrg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3Bb3Xiw;
	spf=pass (imf20.hostedemail.com: domain of 38P28aQYKCDUYdRqliXffXcV.TfdcZelo-ddbmRTb.fiX@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=38P28aQYKCDUYdRqliXffXcV.TfdcZelo-ddbmRTb.fiX@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773993458; a=rsa-sha256;
	cv=none;
	b=zoQGIbinDngwrMZsq451yQVwB3FWW/FnmeKKk/M4n19/bSAAi2N/7wGVV4Y/BjuddXIHXV
	FDXZtYNgIrLGup++zZH4WT/Uwlq/kNLl2XOZ4+g72IaWk6sFlX4XDLp/Yk3JWYFNuXsp/H
	4+vcEUIhPdiRrZlN0LiRAjhAtmzd+KU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486fa9ea1ebso2114045e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773993457; x=1774598257; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sH3eNdN5a36zAeWkkdWtNUuBUS2xJvF1FweZBpquDLE=;
        b=l3Bb3XiwfsoGO2JecSHn8obA0DkLLf0WCsEVYh79ydf5oDqw2sOyunbjGUHFFJQLki
         A2sP0RDxr+rjPrcAMkqhE6gjZMH6RezfXrr09uPF0J6rab5mgkNik2AoW6rVttuyiYtw
         1RWqL4FahZI4JOtlJrY7urBI8giPkfpgN22kqd87oA8xMZIdD/cV0DizbcGjSONsBlEf
         6Bny5VPVy65+naTGTAzy2fvRS/EsYfTx5qiSY4PdQ+AtiL0PKH1Lp0jYZnW7qcFHtX7h
         Dms750dF2UE3nm6NYB8S3GswxTpJn6B0EC0P88Ox9GilXBm3+Lnqeb6Hck5DpkKipHp+
         JvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773993457; x=1774598257;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sH3eNdN5a36zAeWkkdWtNUuBUS2xJvF1FweZBpquDLE=;
        b=oizCuZ1ZUnS/GUWT+dAdyEh2dBe6+0esJdGbChegulOSfyxN5YRVaP/7b+k8wVtrZt
         O0GyuTHwwiRGzKUx4vmQ3dxriGo3IwBM+eGaQu9NNm0LCXWs6O9X6WKJxS6tALi6yZF3
         mBdsjSDD14KEmckVXU5/bnj7hjvYq1QfFZ8aX/AQaVq/g6+Z1uw/5v8qgfLvQmp9WJuU
         6YzeXCzr5H9DJ7AHtPcY8rPlodr7ErY7jehJ870ojO3uZYqjQrynkJHYvZHMo/B4K9ii
         pFOyTSBUEIEQbE6kQDUhpDQCCyuDU9xRMH5tBig3xDLrBjDx/eMmytPuVKzEAd/2EsBQ
         pi0A==
X-Forwarded-Encrypted: i=1; AJvYcCWUiwW784O5AV1X8D8p0BxKrCfZSloExmBk1ozBkj3oU26XZJ/5CB1aMz/LKyp8IOUPEviE3M6GHw==@kvack.org
X-Gm-Message-State: AOJu0Yy7aEA2IAI4vhkjS5V0lrrPfT4yHH86YFG4IMOlWbiP0kKMOV0v
	Ul73ZDM8H/X1X50WW5LnmaRkEFgzecc9XRWw2+vAEw042QeoT2p7zGARAtJrur8E+XPvlSOE/lb
	PWgQ7Bg==
X-Received: from wmlu26.prod.google.com ([2002:a05:600c:211a:b0:486:f89b:7f11])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4a13:b0:487:1e7:8e7
 with SMTP id 5b1f17b1804b1-48701e70a2fmr3341125e9.33.1773993456420; Fri, 20
 Mar 2026 00:57:36 -0700 (PDT)
Date: Fri, 20 Mar 2026 07:57:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260320075723.779985-1-hmazur@google.com>
Subject: [PATCH v4] mm/execmem: Make the populate and alloc atomic
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5E8D41C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: ycuxypnoih3wtuan1oc9gs1mjd36b8h7
X-Rspam-User: 
X-HE-Tag: 1773993458-572688
X-HE-Meta: U2FsdGVkX1+MDqZmhJu34g8FZ6i2WXgkZEhzxPZrbwwhB6ixL8psgXpGpEu6Bx2+KfKBFi1VJqsIshN6lFLLr6se8kQwjq/sOku1XFhtA0dWxPPZEHRiXMhRVbjGTbba/JxRv2F1kXcbSHmNpaiTXMs9hhR3zUkR5EIYBQyELKgxff17YFGMsqnW757lZfLJfKioPFP38wtmALEsn23cSdBhocQTZR5tPOwT77ELVCjIdBg8ZYg71xmsV6ivHCLyLM71M7ukGNaMG3z1/Af28yvBaXLQWnG9WpYtCOKGX1DMtMF2n2Dl1cxCuav6ioHC46eAYceapVhwiZLAnbrzgNY7mY6MyA9KamKGvvb+Y1HkpNfzAFau5405jmPKde5qS8ds6LS9fbx0dCU80WYsYJfbyxCqTvb7c+m1Pe+J53NYUUt69s6gEtwrrSSNITDEGi96goPfElUySfWBs/J8j1JOrrizcPCyxHFbkrbBUID+9frcKvllv9cmBjveKD/9jjjgVD/BvZoodxHW/2g3xtJtdlvPnKKYYwH4yAKMEh0Q3yD6xzH8j0wBi6a1os83K6nr6FiDwJKSlWnQQKI7w6UIQqk80uftZtv4FBgspyxbEfmYgqw/z30alz7dCJevugGz3RA1YwYX1Z+Um/6M/2km0N/UrMKHBxFFlv5s17n8LjzxS32qHaSl3PSQe2aA0AJ8UxBPaOuUCeun1echJg4vOTUHSwa+s4PCvh3CC+H/TfO5M1ZPV3D/9QpckwrIYloDLbG4zDyrpC1YZUTfhbhH3qmpZazCetVi1vzRstvonNBX1PoJVLhheufyXwR4HQuwi+0JAVXqcaINLXkDIGQ0eU1nSeB8+8DNo435T7ARsEohBOnC56CoN7IMpqt9mPIImu346lnRucZFuo9nSUO31DtqChmiFVSh9MDDfZSM7P9VlH07ScMTz6RwRrkORuYu91NzRlRueVBmaaK
 GLNsUYAO
 LcSqayGmmxrPizNf09d+Q8EUvwdvuYBJXXgfqckl69yQhcYP5gCguv0vWObVXI7XXy0o2Dib1QTT5Gr34oK13f8xzTvkIB0vlZ01iXxbTr8C0HQF6LAd3t2qeLH1ZoVVH3m24Txx0MNJSIyGbTTI6kDxqAdNrt40nYsfixtozl7BC47GZxZ6snheV82xuWx4Bi7kFuQw0EAGe47vPjR6ixM6tJhtUzMqBPHaXiCFfXXUkQ4sJCANBTMBh2YEK889Cvrd3RVUGG59xXRJtyTNEqWYHObBZ5VYOgbVGykkCmKXKekMgaHh4wogTXhaPIij0QpKqk4+VuU2VZanBod9hnsYozAVemuS68ImeUiMrue/rs1I4XYO54D6cWISUaj7jjsUGWRBUYvp+0+VokCTuS8avNKxwtSNpV/opzlbKKlgM9Cc0wbRWtcKhpcE1/ngZp4z72XpReY6AIu+EGGVkUPIcPrHszjcay20d+qS1uFs0QHN5ISFCoHujgWKPFU6JZHOmflAm5mzUTw1W1ecQIgoYgxuBoC1kJE5GARdgV6GKHuMfzEWaB4InfKqryp3di4ThUdZhDP8NVuBVmJWiNKgq6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a block of memory is requested from the execmem manager it tries
to find a suitable fragment by traversing the free_areas. In case
there is no such block, a new memory area is added to the free_areas
and then allocated to the caller by traversing the free_area tree again.

The above operations of allocation and tree traversal are not atomic
hence another request may consume this newly allocated memory block
which results in the allocation failure for the original request.
Such occurrence can be spotted on devices running the 6.18 kernel
during the parallel modules loading.

To mitigate such resource races execute the cache population and
allocation operations under one mutex lock.

Signed-off-by: Hubert Mazur <hmazur@google.com>
---
Changes in v4:
- Fixed typos in the source code comments
- Extended the commit message with rationale behind introducing the change

Changes in v3:
- Addressed the maintainer comments regarding style issues
- Removed unnecessary conditional statement

Link to v3:
https://lore.kernel.org/all/20260319085907.3510446-1-hmazur@google.com/

Changes in v2:
The __execmem_cache_alloc_locked function (lockless version of
__execmem_cache_alloc) is introduced and called after
execmem_cache_add_locked from the __execmem_cache_populate_alloc
function (renamed from execmem_cache_populate). Both calls are
guarded now with a single mutex.

Link to v2:
https://lore.kernel.org/all/20260317125020.1293472-2-hmazur@google.com/

Changes in v1:
Allocate new memory fragment and assign it directly to the busy_areas
inside execmem_cache_populate function.

Link to v1:
https://lore.kernel.org/all/20260312131438.361746-1-hmazur@google.com/T/#t

 mm/execmem.c | 55 +++++++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..084a207e4278 100644
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
--
2.53.0.959.g497ff81fa9-goog


