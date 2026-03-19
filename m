Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C63107527B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEAE6B0446; Thu, 19 Mar 2026 04:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957D66B0448; Thu, 19 Mar 2026 04:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846FC6B0449; Thu, 19 Mar 2026 04:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70B506B0446
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:59:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 281711C766
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:59:14 +0000 (UTC)
X-FDA: 84562213428.10.4C56E2F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D950140013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:59:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kIPlorJT;
	spf=pass (imf09.hostedemail.com: domain of 33rq7aQYKCJc8D1QLI7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33rq7aQYKCJc8D1QLI7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773910752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8r9tlNwMYzq4cthZppbvjBNc7HbpE7plIlyORF+br+M=;
	b=s8av7ANmFiEtdS0x2bvnM2XIQ3lsMIgGSm4eHfpW0cbqgS2llvlCW7yF+NdNZ7mOyn8OsM
	+EKq5WJQRYFu9tYI2ls6vsBi+qivpCKtLPqwffRw6JlSUNATmP4IQRTj3r3pZ8nXrg1pgh
	8bOxXOhwO6mbn/RTaQQm8XChFvKaqnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773910752; a=rsa-sha256;
	cv=none;
	b=M2U97AiDvIxRDX9J5H84z7bnP6xIEMW2Xf73ZpMHIvxICjuaGy9GaG4htjaqe04/dWvSbh
	JyOuFE/Te015Bz/sMIS29aUU6NkQB6VvmsmWaLBrPeiQOlbkuQ+/CVls0fixaczOQDwxrm
	tLtTiuiF9y5Vfxee/UO6tbMs9Rr4Umg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kIPlorJT;
	spf=pass (imf09.hostedemail.com: domain of 33rq7aQYKCJc8D1QLI7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33rq7aQYKCJc8D1QLI7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485355493aeso4916985e9.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773910751; x=1774515551; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8r9tlNwMYzq4cthZppbvjBNc7HbpE7plIlyORF+br+M=;
        b=kIPlorJTLIXsg8IBG4YB7gLUK4XaflHLKrKQVtzIsjRIOBr+ZkAWPy92Uyg4gIWUn+
         s31i18TbKJjoEIB+YAHr1T4YesOwWg2IOKIjTKKoU5wd4lBfVURm4OsSLHDoziE2ofT5
         lSnvkdfZz6axCtunUtF4TcPs1FGPovMhlasiqyIUzM3aQ+2WcUH0ooZTIu7TOVbIjjT+
         z1+yNheveWBwfHO2IzisPOU1iM9Mws4qkLEdYiqQnE1YsoCw3y+/0067n79oT7rrM3Rx
         4Tioaofw4kGx7yFVDWYTjK1ZO1jJC9uVZohSVri/AXstZMO7rbstwn1kzs6fvmB68xdX
         y15w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773910751; x=1774515551;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8r9tlNwMYzq4cthZppbvjBNc7HbpE7plIlyORF+br+M=;
        b=UvjUxSEeYKJoxqQC9DtsJuyzzeQa/Ah5js0Is21jFChSIi4mk6eK3Pk8AZSDFbPoJl
         MGPawWn5ZAjE6fYzcDmoxqT9WeHAnT8TtNnQu9qSatosApri37hAogxM35YVEMLhvQtn
         JTKSw9RJIGloUFi4g5zXSXpVniW64HlJc9iX2paRT0meKkjhpDJ3UsCoi+bXu1qoG6h5
         sjjGopjVcNOFuK338L42wODq4K4mOgmoJ3gjmLZBTp8gWdSDbCLsJ3/+Gag4rO3VS/GB
         iWe2OzRu953oeECsceeUvyWqdXrOscHX4Z9JwCxhrlRGbtIIa/VMavTjTj0Bj9z2WL40
         VDfg==
X-Forwarded-Encrypted: i=1; AJvYcCUE7hXPkOYi2Ya7QA1x0gYaXm/B3U9SKl7TWXDvcOdlp9d9zZpHIZgmRtl28lDLO58t5Dov638eng==@kvack.org
X-Gm-Message-State: AOJu0YxYw/z/cdRgWwbeifL5EZ7GZFHgAYT0ExWptwvcdWfLeDyYXpHc
	gvt5KF6OqVwKww97EYX81oyK7SPm82w9YRyw2d9y6kCkW/oA0bzRkPzzusn7uvKg+BBImshsAl3
	P058M4Q==
X-Received: from wmok20.prod.google.com ([2002:a05:600c:4794:b0:485:3ddc:f27c])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e09:b0:477:76bf:e1fb
 with SMTP id 5b1f17b1804b1-486f4443e8fmr93435235e9.16.1773910750524; Thu, 19
 Mar 2026 01:59:10 -0700 (PDT)
Date: Thu, 19 Mar 2026 08:59:07 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260319085907.3510446-1-hmazur@google.com>
Subject: [PATCH v3] mm/execmem: Make the populate and alloc atomic
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: e9w38y849okswinrpsy8po7e1g18nuwr
X-Rspamd-Queue-Id: 5D950140013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773910752-279065
X-HE-Meta: U2FsdGVkX1/INDrXezjJNmUOVmi+UiPZ7t5QUkJEoZWttVRmTSn0LFSEbv5zKf0boKOlh0BijEy58pw0TL9lG9CmLQfJui+mpmRyYw9FgEU9houpgoWkkd25P2TuSIugMFzyRBIfthZK/JNbyObpUNdhFvWtNZ8hPVoe0jV0FzUbKYqi8OJFzsfapSSmjXQoKpG2iQJFLaCs361DLTsXTHYr1YL4t9Rq5fC+1oD85egjdWvI4+0QcDAKRDTpORWc9oMtnSN0ME0Z5ad0nptMD2Yit/XGCdr3c7eMM8yKnGH5qP5czrmsXVQ56kOomMc6V3mVcIdJg0MseRugwX9AiTzS0ElSyo/VNy6TysrBIUkyIf0wPHvSn8qEmZgGXI+ys4cBU3sxDn14cTDA5Bkzs6nB9glQ2bMmiy4IGmWs5y6mFvpaRctdQbCEhzx3/yDlkGD5AeHwUuHEgAEAWnxgdB2z0Ija1Hls6kmodPtlfkFu9z1TGxg3EDUJO1UZmNiKs/PyoX1o24qp11T/Egout/x+3ERrIBo6dk9w50Xu9uPFW2vc9IwSV4ItdoLVsHXTj9A+zMz5yPVq34cd26uWjrXnUUaJ7M+vSPRVMhLUMyz5fAoZ2nuAbHmizwiq0rq+OTfaCALtOOQ9laPz09cREJm0RIYxF01uFYwgrR1Bg1tu2PFkSBp9+kAVIoBmG2zp6bVNxo6sujTJhknIu37zTpn2ffgXMvZ1nHqo6nVpIWL5SQNnIZ/JQ/ezmJ/tdCwVd6fKbgDE4uBg8iycRAYMjz5T+Qtrtw4R6C0tr5pft8NbTv/aA9JJBoBL2+TzdlthuJNDF4NlA2AFGBbBT2DcxLmD09H+G4GBgzGI5Ao7H3pP+BAzinWnOoOolVz3fJYdGtXym6nZEwj0xGP/+IuZc7YaQku5ZIRL4P0H5XsGKY09AgwttsM2HbQA9DZmz1loAzTNZTU5g9P10910TL3
 mFcDdkkc
 unJSW2lCsPchufHwksSWLfbjFzi3peJedXvOv/wOLbqqZNxavOSkaz/xY9EvwiCXT5hhMg9c1Bsitjd3i8/7ixkNpcpbePg1cwDoIQnJi4KeipqFIBbVZagb3l0ISK5waGXNAEJNL5YweWpqYQvgkEgPJe0c5HN7fho7ChTVSuhd27dMYvofr55gogZT38+IhzWWATf4jWlZva+yVRce/Ltc9gEkGFEBE6haqQqez3fPRnw9jrLjK1gnZMUbzKloi3Erm7BnHExazuHGexK8BC8tC+FqtQUmeO0ZY7JDgeY1xclkZpzjGDx3Zme5wpq/cZGXONgZFRpuVVuYqrj/T9PKmCk857ldUBlNtEmZjEZne+QyBTU+2G2ng17DHxcQRf3I7+b/91g+5LIRuLy95CpgIhVGKf9DUFBWDMakSEiYqbLDyqrXUrVEh5VNkdJQJtPdZY9yBfD/VKzjRA/uSrwq+Ljw4Cp3o8r23uzdX60tAwNzDdkEhjr+mE8SoLA5stkUJAcLUxU3OP5OHVEpbvIr8oFIN9oV7qZmBkZifVTs7XqU7TLzWBeaQsyWa+CSi9DyQKXI1DohmOFTJdgj424a/jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a memory block is requested from the execmem manager, it tries
to find a suitable fragment in the free_areas. In case there is no
such block, a new memory area is added to free_areas and then
allocated to the caller. Those two operations must be atomic
to ensure that no other memory request consumes new block.

Signed-off-by: Hubert Mazur <hmazur@google.com>
---
Changes in v3:
- Addressed the maintainer comments regarding style issues
- Removed unnecessary conditional statement

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
index 810a4ba9c924..4477bb9209ab 100644
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
+	 * New memory blocks must be propagated and allocated as an atomic
+	 * operation, otherwise it may be consumed by a parallel call
+	 * to the execmem_cache_alloc function.
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
2.53.0.851.ga537e3e6e9-goog


