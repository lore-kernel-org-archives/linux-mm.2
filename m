Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AA7DFD8764
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B09F6B0089; Tue, 17 Mar 2026 08:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9604E6B008A; Tue, 17 Mar 2026 08:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FDE6B008C; Tue, 17 Mar 2026 08:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 725586B0089
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:50:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25699560D4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:50:37 +0000 (UTC)
X-FDA: 84555538914.07.4F4D0F7
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5BD6F100017
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:50:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q2efUdLM;
	spf=pass (imf05.hostedemail.com: domain of 3GU65aQYKCO4XcQpkhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--hmazur.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3GU65aQYKCO4XcQpkhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773751835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80bKeW1QbA+rd5FHvp3sCEKth7+hZO62IH1Tt9MSVyQ=;
	b=AhaqtT7HHRkiYzim/0YfWhbtN4kxzHUNz97dQPwv53rSKoz5wGrzHPVKwa37hJaXYTkFDz
	mQuY/kzf5a1oQgmfMUK6TKq4++YZc1nClL+DmXuC8yg9UeWEJYd2LOevXnTyD0l+dgVsik
	prdga+G1lZ3yKZOe1JSc7aRaibxs69s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773751835; a=rsa-sha256;
	cv=none;
	b=VCBo4nY5seHMCJKU9UO1WIRwl0+MC8jeJIM1unPOgo3bssX6UaL38coothKIGMeeiHEhK4
	G9L9RBVMIEqOrg+KNep7FnQMLUNM7ElSaDpaqoSwphC4v3wmYGBJ+vlUfyvQVvIY49OFiB
	IhVetMg+4uTB4Bd63Uk+yPOSovUi3IQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q2efUdLM;
	spf=pass (imf05.hostedemail.com: domain of 3GU65aQYKCO4XcQpkhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--hmazur.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3GU65aQYKCO4XcQpkhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4362197d1easo5803948f8f.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773751834; x=1774356634; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=80bKeW1QbA+rd5FHvp3sCEKth7+hZO62IH1Tt9MSVyQ=;
        b=Q2efUdLM/KcQFRHRdBCIWdyWGDiklqZUxvEqwOrQ88b0Qc02UikuyadoukoLLppocU
         wUQAvazE0031N7W0rO2VXmJ+lAo4Jn9JPX1a2LAmLsva1DYUpLzCoAzBwp8aPqNzEmjn
         d2QcNMCO2R7znoVjfAj1fbavyD5xq2N9e+U0jPFj4s4DIuFfXcn2baEvtSPioHRkNpZh
         kbyTqvwx6IYogEuubpwzKGrcYaLI0mUpMyF2j174Az2Os8Ou0UOW7+aQu/2xvvbGe04y
         4VwI36gButqPezfRBGyrvmMCWGnLax3KHJZc2KUmtWUYt2IQ0mYevS1L25Q1ofjHMpJI
         zmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773751834; x=1774356634;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80bKeW1QbA+rd5FHvp3sCEKth7+hZO62IH1Tt9MSVyQ=;
        b=DCYuryqZeTydzIPF47Hvt/AA2KKt5jLLHIvgD67eGVeKs0kN2JAqHpwx64JeuNDrmP
         sRqU99VHXHvwdpcD1l3v3xB7wbKNl+9NRhfBP2iW7uOjaWTBtMmAhmcVz0uExFwJCyH1
         3C3w/rFgt3GBEFJS3eU+DmjMjmyj9tBsz2WOoUlL3KJH9JPCyPh2Te9tBuswfbobUU86
         CRlNGGbKC6UleU5JOAOF6M78us+Y4ShJJNGPuoyglI7OcIxZSZOiFSi1NVBK6VXDksrs
         VXhFYj1mzrmF+xhfKbIHqW1gOZqNdPyxnEp6g4s0gDoTYjf1hcigMymSMKU7bTiwtNqW
         SLWw==
X-Forwarded-Encrypted: i=1; AJvYcCV7YvIl81WN9hdaFKNFE1ElPoAOFDi5Bqy4oatD9xRY6pE6DDKAZkf9ovDJv4vEalTpF3XgkW82qg==@kvack.org
X-Gm-Message-State: AOJu0Yx/ZUTaYItziRdqiwuo+L5zbfHblvKv05DSM6TD4elxtSShNOq7
	E59Ipm3ti2VVubNafYUtCHdrALlDnpxRl5dB0SmCrwLMSxk31M3KH5HrZo4o7jtR4qsgBk2AFW6
	SnpzRWQ==
X-Received: from wrj13.prod.google.com ([2002:a5d:5a4d:0:b0:43b:458d:a320])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2086:b0:439:b791:f920
 with SMTP id ffacd0b85a97d-43a04d88460mr31112421f8f.17.1773751833804; Tue, 17
 Mar 2026 05:50:33 -0700 (PDT)
Date: Tue, 17 Mar 2026 12:50:20 +0000
In-Reply-To: <20260317125020.1293472-1-hmazur@google.com>
Mime-Version: 1.0
References: <20260317125020.1293472-1-hmazur@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317125020.1293472-2-hmazur@google.com>
Subject: [PATCH v2 1/1] mm/execmem: Make the populate and alloc atomic
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Lukasz Majczak <lmajczak@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5BD6F100017
X-Stat-Signature: p1jnc7or91jynujkxbbsw3msgrqg9jfz
X-HE-Tag: 1773751835-689270
X-HE-Meta: U2FsdGVkX19Lq3MahEztOMrVxXiP+TycDQ1z0/PYsaElGSGn8g3jL4YOU6jXbAqFE+4SddXiDy24zv3Sl5FiAikV6pd6zanBEA+COTYAdE6HioIZCJ/Do7omngZw7h1qdAABnSt4Wc0JjdAXpM0reIEncVr16jX5N0Ta4iHxNeSGBYvJQZgsp2050LHx0XuLRqB3xj9I7f9gRt4Nom3OMo3CNRpwu93YBWP9q9jHwheAo5r2D12i1v1Mv/SlKM4/mEdeFJLJuYa1WB44nnebgfAf+uav/m5dX1+Uuv7TUHlVG5o7bFT0rkCA/7XQcZRTdNLaO3rvf/ZS2Eg00F/EHOxBfOT9O7hHwxhaDNoCaEnfrfGpwBLCYT49lWbmWx3WeYUR777W3mQCf+MAB7kNr+CqwGhb4r9G5wHg7ZzrApfX95qug6k1j6mB9sLtQ7wEDL1JMiTlTAuZHqbLjHn3v+0ZKIczk0dA5IgFxyK18zPGn2q1KR2O8T2UQoDveuozE0od5vIzim7JfzzpYsQO8atYAWbLAcqLXrlMDUmmdFJuO12HjVmFxmnTRMhVAQOw+8lz0BuQyPU37SKR7oR6AUui0OfZhvBTeiEJFm1Ikr+6Esu5oPcxenQIkv+0B6G/qn96JUH7bVneyS9ipasd9aaBdkRn+VXVhjQoyVkJOGfmsikvgF47BzETC5LMnXxIUt8AYxw/Juq6svxF1fLTcXWlUDBZjWZom4o+8h5QKXXggvg1Yb6fQetw0vKPFAK9gqJzysOxE0ilmeBjaJ0anhT6VF5pztax5Z9jWNMoNOKQRnUHfYaadGxzGHAYhiwscF5E2m3rblFxmTVZDuDHjNVMbPq9fUID3RWa2UV9WNzNCzCGOiI8YKfYst62lzLuvRoU6ADmJquuvB8dXrSGdHUMqqDJaOMx01V08rSitNWtA4phNcpsFPQbRTKI12eW7qyDX/Mvfv0H+Zj49cE
 X2bk/xpf
 gY9FnppVjeeZKnQNwyuLTSeoNf/ngWUL9BQRHos0COW9Uq9jFIHJVeeMjIZu/xwqBgxpzjN9X06/db+9Wrb0Oih2V/ELAaXSYL52d4bvXNMlrVpVgz0ThLIzwuLqz0LvztC2pcZ656yzIvgJ3EzE7R0qLzsrrHiqXVTJYQ4MkwxrE1MjkHPcQvX9s1ynlMbnxwbviA065CDHdVoc30gqwEFZDx5F2veke6K9Bmk2AGpvbFSRcZPPK3GYheUvKskvO3XcDUDNykjp3rbEVssrtuo6I0u50ghJP6FXYoBZ+jhG/WH04HMtZGN5sc/u4ziDSz98QM9N3Tl91BWHPGmaQyyV6/vIlRnLhgC2/5BZzfmFKFfTzretqM8KaAgPY+0/wBJNyloKz+4AKGogV1q0LLCZFpRZOw9mveIenx8AhZm/JmPdHPmdpzo9jjO21rcSfLkpdB0TuZjGJNgw+Llu0VuQJ6ir7ECnZ600FlKlk52lqOGsKV7foPV3RVuwy1CW2MxGCUrK7VpfljEKn7etr4n9qVMALSb90tpAr
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
to ensure that no other memory request consumes it.

Signed-off-by: Hubert Mazur <hmazur@google.com>
---
 mm/execmem.c | 61 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..9043f0f8f61a 100644
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
+static void *__execmem_cache_alloc_locked(struct execmem_range *range, size_t size)
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
+	return __execmem_cache_alloc_locked(range, size);
+}
+
+static void *__execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
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
@@ -307,33 +304,43 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
-	if (err)
+	/*
+	 * New memory blocks must be propagated and allocated as an atomic operation,
+	 * otherwise it may be consumed by a parallel call to the execmem_cache_alloc
+	 * function.
+	 */
+	mutex_lock(mutex);
+	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
+	if (err) {
+		mutex_unlock(mutex);
 		goto err_reset_direct_map;
+	}
 
-	return 0;
+	p = __execmem_cache_alloc_locked(range, size);
+	if (!p) {
+		mutex_unlock(mutex);
+		return NULL;
+	}
+	mutex_unlock(mutex);
+
+	return p;
 
 err_reset_direct_map:
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
+	return __execmem_cache_populate_alloc(range, size);
 }
 
 static inline bool is_pending_free(void *ptr)
-- 
2.53.0.851.ga537e3e6e9-goog


