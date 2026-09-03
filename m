Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BF7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21166B0099; Thu,  3 Sep 2026 11:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAABE6B009B; Thu,  3 Sep 2026 11:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6B76B009D; Thu,  3 Sep 2026 11:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24266B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A88BA4672
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:25 +0000 (UTC)
X-FDA: 85172888010.11.3AED938
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 388881C000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq53Txo2;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450623;
	b=FQJ0TsIIMSxaHeDIBGYlX6TkQzyjztRUid8i8dPVdGs4AC0LcS8ViDrOZ15fKNOAhHfLhy
	yxULt35mbj4rSrZB48s4ZmkgJ5FDXXluJaKpDMmvuItM3RkOUKR9L1Uv0dWDlzulP3LLwK
	gtuhMQx0jn/NtrWQMULLF91TH9szPMA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c57DBNEt0+woR56ZuvNbkfIrlDXYh8oKXIQm/KMduWA=;
	b=EpQFhBHIKAOS7inloyk6FeGyn8ESSpHmmIy6ryXYQTYq0yEw1HSzbNfGs2Ate2QoCXFeBf
	E49RWPg5w0+/dyvlIehHcWXw4syyE26dS/QPFaXZdlT7KBEbr0o5+oMKqQ67RwxBPf37sr
	HFetzz6W2FMSBtPzDAv4cPJ/aPKZv3o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rq53Txo2;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8594A41208;
	Thu,  3 Sep 2026 15:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA251F000E9;
	Thu,  3 Sep 2026 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450622;
	bh=c57DBNEt0+woR56ZuvNbkfIrlDXYh8oKXIQm/KMduWA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rq53Txo23LaqkMe5fufGOjTXt1HCpC3UBmUOtCC7iNt9tPfm6kTXXnPSDCAk9nxFE
	 lwemGFrATyN+XAg13ALbLeKBqqCnEFjZCIw3m+OgJcoF6R2o55nl9zlR2nD0eTX5GV
	 5WP02yiztn4pzZBwyYJctDQamuvIJP/ix0ISO8UHAZl1Jm02IkgCxK2aY27CDvv6Hc
	 7QDyJftBmqBtwrh6mtysocnwg4FnJVx3Sfz+AXJds6nDGeBfsYx3+pfkjMCTK3jRpK
	 /JYp0S0gnBA1SSNnCmI0CtvQhXnnUR5Tw1Fd/hwLuWwcoJS3sNrNTSUndJiU/wpXbY
	 mJG5w/QHSQw6w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 18:50:02 +0300
Subject: [PATCH 5/5] mm/execmem: use cleanup infrastructure in ROX cache
 functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-5-11beb2a3d249@kernel.org>
References: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
In-Reply-To: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 388881C000A
X-Stat-Signature: 7e4dewjm7uh9okuts63o3iutgyb3m61h
X-HE-Tag: 1788450623-301374
X-HE-Meta: U2FsdGVkX1/Uw6EjPwI6A/RHlqs3BnG4K15DwGU0hu4z4pP11o6hO7SXzsu9U6QSaqLeESGC4vYV5BUbCWta5WMDHYp3qkDAU0sCD7kL7+54dSqErw4J8MJQcPlFkykvF1F3szS0BjwSUlQUTm4zZhafsRh6JrMkuZFB27YbSqV08Eak+6GwoN6U+y3/s24xrulrBTmt1+0Qj8+So1YiKNv0O3RonVGIThvVIM0Hpsyqivq4RMAIm5kIIyTCrFpqKiaRplfDTembL0YDb1wa+T1t1uuNneIVqVA3lp5kWwv473vCfYGWUL0fTT7pPwJlfT5LEymFBbufT3MKfLTZareVJSysMxA47gSGVHovcOgSgjBdaVRvMoEdcmgU5KLr7BF/nacuMO6sMg3+AHVTAbSwo31QeA/6+6X6wuqQoxh0ufz8RSLbvrtGjMmFgvrNmM9chj+PM7FjcQ7+kkAXHs80U5xJV96no2rJ6bDOI1cBD0uXCM9AJw7lndUAXctcOJKngr8KNu5RuG27Xk5hkUibaajRk9d7JEw0IRuqxnk4BWS/L9w+SX+SbJk3veVbTLn3MkPq8qGc5gRKmFm581FlpLRjyA/N/rQT+Lp6ee2/Bi7GVAS3ecBCqdVJ9Vaqb/0jZTjv/1ukdzdD/u8lPmrEUZMyLf8Kp4TZ9yFXLKvx5WxaFBvhOY8ZcvOco23BqLPGyzbql9SQlV9hFLnngFu+AsvgPfa0bQuhaT7jHWwPTrzgLj1h07RuU/h/YshF0sT5HrvXWOxZ/8M+4REMGsySLD2qZ0hO/RpEr+FZy+dmGpm4Y9Pzn6zQrRFAv/n6Iu8nWqP8UAIiH172zposTApltQKgtFEzn/kUyjmx6gqQxNP4Cd3O8Dj5ZYMka4yRpNlRJcvWjURzdx6oKraYgqVIHelbKiBm25bmZ5Tan9cGmS3/fDWOii0+M1e+koQNdt/REicZatGYtkd5Ahq
 tpcZ7gGy
 ilvfEM0HWZ6MEVcP+prbMnyRfl+nleJkY2GZWzzgbUIbsyWLn4Go99g28M8hI9IKn/6eZhQfs4IwjKn+hjOArhJ7YO7fJI90aI53zCgcOszTSdmOz/2nKkx3McuoRSAk1Q0Yarr2LClyb1ae9Og9HV4D5qYv4upVG8HnsdILE3G/7pvuavFACYGarPooDw0jH09E2aOXSbsHM3ymyVT9aUjsqvthRIhgCPpTST63lRhHv2m9uAtsGhSv/vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After splitting out execmem_alloc_rox() from
execmem_cache_populate_alloc(), the error paths of both functions became
less complex and can be easily switched to use the cleanup infrastructure.

Use __free(vfree) to free allocated memory on the error paths and
guard(mutex) for synchronization in ROX cache functions.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/execmem.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 77653b7f163dc..349cadd874863 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -138,11 +138,10 @@ int execmem_restore_rox(void *ptr, size_t size)
 static void execmem_cache_clean(struct work_struct *work)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
-	struct mutex *mutex = &execmem_cache.mutex;
 	MA_STATE(mas, free_areas, 0, ULONG_MAX);
 	void *area;
 
-	mutex_lock(mutex);
+	guard(mutex)(&execmem_cache.mutex);
 	mas_for_each(&mas, area, ULONG_MAX) {
 		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
@@ -163,7 +162,6 @@ static void execmem_cache_clean(struct work_struct *work)
 			vfree(area);
 		}
 	}
-	mutex_unlock(mutex);
 }
 
 static DECLARE_WORK(execmem_cache_clean_work, execmem_cache_clean);
@@ -269,7 +267,7 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
 				 unsigned long vm_flags)
 {
-	void *p = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
+	void *p __free(vfree) = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
 	int err;
 
 	if (!p)
@@ -280,22 +278,17 @@ static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
 	set_vm_flush_reset_perms(p);
 	err = set_memory_rox((unsigned long)p, size >> PAGE_SHIFT);
 	if (err)
-		goto err_free_mem;
-
-	return p;
+		return NULL;
 
-err_free_mem:
-	vfree(p);
-	return NULL;
+	return no_free_ptr(p);
 }
 
 static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
 	unsigned long vm_flags = VM_REQUIRE_HUGE_VMAP;
 	size_t alloc_size = round_up(size, PMD_SIZE);
-	struct mutex *mutex = &execmem_cache.mutex;
+	void *p __free(vfree) = NULL;
 	int err;
-	void *p;
 
 	p = execmem_vmalloc_rox(range, alloc_size, vm_flags);
 	if (!p)
@@ -306,20 +299,15 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 	 * as an atomic operation, otherwise they may be consumed
 	 * by a parallel call to the execmem_cache_alloc function.
 	 */
-	mutex_lock(mutex);
+	guard(mutex)(&execmem_cache.mutex);
 	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
-	if (!err)
-		p = execmem_cache_alloc_locked(range, size);
-	mutex_unlock(mutex);
-
 	if (err)
-		goto err_free_mem;
+		return NULL;
 
-	return p;
+	/* the chunk belongs to the cache now */
+	retain_and_null_ptr(p);
 
-err_free_mem:
-	vfree(p);
-	return NULL;
+	return execmem_cache_alloc_locked(range, size);
 }
 
 static void *execmem_alloc_rox(struct execmem_range *range, size_t size)

-- 
2.53.0


