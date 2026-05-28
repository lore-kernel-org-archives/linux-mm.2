Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EC2CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 22:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B956B0005; Thu, 28 May 2026 18:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D134F6B0088; Thu, 28 May 2026 18:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28CC6B008A; Thu, 28 May 2026 18:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2BBC6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:20:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B4EF92DF9
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:20:20 +0000 (UTC)
X-FDA: 84818248200.27.57B9759
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 744694000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:20:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGX20CsK;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780006818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lzY/wX1m+wTmdwzLRFfROd6PO1yLrCOxW0YfULxOR4E=;
	b=TuvZqNXWYV4iopbmirUWPEpgZLYvaVEWbcaS37aoi4wb01Vbnybmu95Fl6YJEmbWK9YOM5
	N15kSFQqRN/Jq3XTANXaJnGalVCU+MaA5bIy5DPATZcMVY7L8Trfci27isN99oblLKw/ZT
	YUtIOYd2JJbvuPPaKa40yn7qflGuA/4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SGX20CsK;
	spf=pass (imf11.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780006818; a=rsa-sha256;
	cv=none;
	b=RIKq/PhHDrKTjCDIoAK9qW4kB+5fdDR60aeVfIHCOPHldF708V8q+B+zzWalEiI9vSL0va
	ZUt4ZGuI/4wW2yjvV2MQ0Zs5zPNIhKC9YljYpBrLLujIGIHNtwjHpgzQ3Y3uXXjRucH95n
	yp2xUVc7EQjgr+ddjsEFMO7bPgsOlPc=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bcd3ac3307so77726765ad.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 15:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780006817; x=1780611617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lzY/wX1m+wTmdwzLRFfROd6PO1yLrCOxW0YfULxOR4E=;
        b=SGX20CsKqBaOWH0SgCyOgWCFFi4rd/rcTS4pC4rtP8MK0zX8AlbGXFeNt0md0zCLyg
         wbq8B16LXW2vk/lhNv/KPOpdswvGZ6q7lOObxWfFny4mYmY7CjiAssGlCJ/6PPep+8L7
         k2IGxhFDCZqAqlg2laFKWobCTjCx4/AOjnlQGj/pR+JJV2nCy3gb7d/YyJwePJxP9n9m
         TwXM9yVzgsuimNgedx+BnjEoe0uEsaB9EylNoyV92a4ZkmI9X1057lTQJy2MPNUAqlYy
         zGTGT6PDEbj6uajVPjoWmauZh+WiSUd1zcM0Zx5Z3EYWm3sw4HLhTTeeGdwfnEP4OZ5i
         4W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780006817; x=1780611617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzY/wX1m+wTmdwzLRFfROd6PO1yLrCOxW0YfULxOR4E=;
        b=r+QkTjKnxc/dDOBwIqBgoEXg3GHNveKHl7Ku2JNd5n10ZYq9WOBmiDmf0EJ3OeIxsx
         nOY/fX+W0msntjzmxDQ1+m4RZxoI//75a1ZsjXEf9gyu+jJ36oHSBwyACQYTGwR9oHKK
         lzySTK/eO3nJWRnwzaD6kzsllaN3VLElWhlBfK57aGg6rY9bnluAj7X9H6Hp/cnetZ9P
         dslGW1ouHtZWubodFQaprF7L371dK72Rc7lR9qijsC+0yMD/X6tgJdF9LFeaVXPnPV+n
         H8ftBlwmBIYcXwyU4NLIHEi60m/CG5IgtoA0Ya1llcqW6+CGnD45kfHdnElDRbhyScuX
         I4UQ==
X-Forwarded-Encrypted: i=1; AFNElJ/9J8PHUWhtPrgq3azG5kKz4CrMKqF+z8v3z+756JemItXtlmrESc67RqTv1o7oCmR1IXuPqtyw0Q==@kvack.org
X-Gm-Message-State: AOJu0Yw2NHXdmfbUnkUrSVmjkXuu3sLUOZTveh7XLZoF8YIDtSc2GgJx
	x+jm84EOOz53SlExag21J999INk1EYAVBhIL6/UBKh3vhnVQ40pZSISM
X-Gm-Gg: Acq92OHdOF96oi0phmBhlfqU6Ccn+Iu6oAojAAiT4KuvhCmCeENb4lTcKATcaToM6rv
	VE9vGRavYYeqt28JQQJWfgbysiGuO4wlUQa+PXsl2srNYkcJxcdJwx0FayJz4sGxnqBkx0aera0
	D85bcqOW1Z+4oq8zvgOC3p1ov/oqbxHl6iCxUM6MXcPhhlVznDPrXinT0dhpmEu3rJNOLZdaFUK
	rpMsIgPeYRnl1l5d5Wnk3inuwfm1NxrxSKvS5Pg5UG4aWQnGk6jrvCKvm7SHrIRs+rnzkU5DjkJ
	Br/1d56TR+tqcxifUDjxUOFIs0TUeYCT4pjKdeZ1mdqWuS3CaX5fHEPKeKQuRr9anDN6PWIRVlu
	Zfm4CdkC1ODaHbkDljko8CT1XrIcgJsbuy/5E6EU6gEegp6ed3WDb4VJ444VY4GYRCVU+nz1WeK
	TFxK5it21LBlVA5FFbVPWl+CxV/0D9D5UVGHzVJEOOM+BpTkG7yd7EqQB1eqvMPZQf/uM58HuAk
	+vJ2W9K2uHjvoKspYWrvPSCHvOULDyW0PwVwu8Jbi7jZGI6JgqktjFfDPF7095A3gh4absk
X-Received: by 2002:a17:903:196b:b0:2b0:5ae9:ee4 with SMTP id d9443c01a7336-2bf204d9ea5mr3890855ad.5.1780006817097;
        Thu, 28 May 2026 15:20:17 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf21d297fcsm359455ad.62.2026.05.28.15.20.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 15:20:16 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	david@kernel.org,
	tj@kernel.org,
	linux-mm@kvack.org
Subject: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
Date: Thu, 28 May 2026 15:20:14 -0700
Message-ID: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 744694000D
X-Stat-Signature: ybzq7gc5i36ixbkjdsx67y4gh11g9dgr
X-HE-Tag: 1780006818-338298
X-HE-Meta: U2FsdGVkX1+WFdI71ZyNwqX4i776lRJMJFKueUjdM1MgqNEiIFE1LMGaRVYG4UunBiqBGVw0aAI/Bu+5adCSwPoCakDxFCFgz1HAXl2cpgIvUJo7HGqLpS8LgL4pA2bJJkuuEVYjVNb2vs4jU7EIFDIRpoPq7p6JPnbEOUbT8QlgNvyd5zkObLfvRfubV5aACuTuSxB4TtJTrJ/ygFH+D7712gNINvvnu8aZWb8THTu0IRsGI99uLgLOvH216BXB7875s2juiHf6DCqqfMZ1mX5z5ttw82mqoIx3A3uY6Tkyk0EW6CRhmvu/tmPFabCcD8r4Qs2wrJGFWt8waxLHerPFMY7Q8PxMAUYScSBt4CT/45KcLqYswtjzyaK+5/+aYnxi1yhAVFhHK9/FMXHobQIneCLxX3tYAvau84LAyUGy7b4MERbpAcZ6+9t8xX/w3yxDWOu/d+itZBS+r/wsQW2/mtCO3vchlrF7DoHazSxW5tpK4N47bfE/85YC5DKANYJQrTrZwQIhIDV5FbnVmeScWUR2IySpxDpqxjXtCBx90Nb7VkD1KEOAyQ3XZQq1Q101Hq0t0DLtf2d55adRVKquj+1E4IR4bM2omK4X4mBdJRl1gTTRrG4Y0fNcTXkGIIXFl9H/zZZbEoNyP+7dEKnY3hH9csWI5LKjs8+KJA+G81dYybhuexj3ffUBx22qGH8JkTTjdHdKIxHW/xV7jOUjWgHGXZy2pu+yZwu4InprTJbotHqSe2tmcOGjESJ0xstR19ep6vMuNxbJcwptp/4NW/eo/BI6A8r387YEimbhnt5os3I+f2B/WHxLvl+fpKpj3gslbs0E3pINrwPslUnunSZIFqzsvfadzxnow3KTVdVnecItNWF/OuBuf/2DwRXyyG5P6J3Zbjl+q++Ns4Y9GenxsCBvY6LsCR3zgwJs9UKOb05ZCq5QMcVReE4lCzGqZxfJDW5Mj7AAjqy
 ouNO/2YX
 viDQq+mnSOXPv+hW/e+XhIk2FO7ueuALebvXL9uiySQv+6eGv00zY6pDiORbwwBYSEATHvEmvDfnM0HSNLbeuefHVtoFX2O5BK0gRvFL3o2BlUhYD6COYK3EItzAvqyfVPBmceUzm1eH+meCJXRE9bWOH5vUWydTuKcGZnAuJOEYokXbkr81YjPLEXo1Cv8DnsdlJ/MrnO2myUV27REYvn9kxhXOkZfF59bdEh2jtLFXidDLvU5DnhTuLDj6wEIesIPHe+9ZhwsTt6hCUpu93HIyUx6j10hS1uxWlB4nBlfVSmAb7LtHFN7J+xtFhcUbfSyRI+thosmWCHaKhfHgkojALupP4yoTUnHcoJDTeMbPqdbam61W/kHmFcj90F3474oG5jf5Gw4Dc7va94MDHNcV+lCICs9NM699iKQSfRrztucGWSEQXXYyehSRvBLYachaCthWSZQ2rHlJUKLQCx7b7d5iWLj+LlZvRg00Wn/tycRHm64CdzJmsfqiTiDa+X99JP/+kn70RuvSBPiG/ksqCVbg5yeYlBoJv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

zap_vma_range() requires the owning mm's mmap_lock to be held.

Taking mmap_read_lock under arena->lock would AB-BA against
arena_vm_close() and arena_map_mmap(), both of which run with
mmap_write_lock held and then acquire arena->lock. Instead drop
arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
re-resolve the vma via find_vma() since it may have been unmapped or
replaced while waiting.

Track processed vmls with a per-call generation in vml->zap_gen and
serialize zap_pages() callers with a new arena->zap_mutex so
concurrent callers on different uaddr ranges do not mark each other's
vmls processed before the zap is done.

Reported-by: David Hildenbrand <david@kernel.org>
Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/arena.c | 61 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 1727503b25d8..9b2dea229b38 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -60,6 +60,8 @@ struct bpf_arena {
 	struct list_head vma_list;
 	/* protects vma_list */
 	struct mutex lock;
+	u64 zap_gen;
+	struct mutex zap_mutex;
 	struct irq_work     free_irq;
 	struct work_struct  free_work;
 	struct llist_head   free_spans;
@@ -289,6 +291,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 	if (err)
 		goto err_free_scratch;
 	mutex_init(&arena->lock);
+	mutex_init(&arena->zap_mutex);
 	raw_res_spin_lock_init(&arena->spinlock);
 	err = populate_pgtable_except_pte(arena);
 	if (err)
@@ -391,6 +394,7 @@ struct vma_list {
 	struct vm_area_struct *vma;
 	struct list_head head;
 	refcount_t mmap_count;
+	u64 zap_gen;
 };
 
 static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
@@ -403,6 +407,7 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	refcount_set(&vml->mmap_count, 1);
 	vma->vm_private_data = vml;
 	vml->vma = vma;
+	vml->zap_gen = 0;
 	list_add(&vml->head, &arena->vma_list);
 	return 0;
 }
@@ -746,12 +751,60 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
  */
 static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
 {
+	unsigned long size = (unsigned long)page_cnt << PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	struct vma_list *vml;
+	unsigned long vm_start;
+	u64 my_gen;
 
-	guard(mutex)(&arena->lock);
-	/* iterate link list under lock */
-	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
+	/*
+	 * Taking mmap_read_lock() under arena->lock would deadlock against
+	 * arena_vm_close(), which runs with mmap_write_lock held and then
+	 * acquires arena->lock. Drop arena->lock for mmap_read_lock().
+	 *
+	 * Use per-call my_gen, recorded in vml->zap_gen, to remember which
+	 * vmls this invocation has already processed across the lock drop.
+	 * Hold zap_mutex around the whole walk so concurrent zap_pages()
+	 * callers cannot overwrite each other's marks on shared vmls --
+	 * otherwise call B's mark would make call A skip a vml that A has
+	 * not yet zapped for A's uaddr range.
+	 */
+	mutex_lock(&arena->zap_mutex);
+	mutex_lock(&arena->lock);
+	my_gen = ++arena->zap_gen;
+	for (;;) {
+		mm = NULL;
+		list_for_each_entry(vml, &arena->vma_list, head) {
+			if (vml->zap_gen >= my_gen)
+				continue;
+			vml->zap_gen = my_gen;
+			if (!mmget_not_zero(vml->vma->vm_mm))
+				continue;
+			mm = vml->vma->vm_mm;
+			vm_start = vml->vma->vm_start;
+			break;
+		}
+		if (!mm)
+			break;
+		mutex_unlock(&arena->lock);
+
+		mmap_read_lock(mm);
+		/*
+		 * Re-resolve: while we waited the VMA could have been unmapped
+		 * and a different mapping installed at the same address.
+		 */
+		vma = find_vma(mm, vm_start);
+		if (vma && vma->vm_start == vm_start &&
+		    vma->vm_file && vma->vm_file->private_data == &arena->map)
+			zap_vma_range(vma, uaddr, size);
+		mmap_read_unlock(mm);
+		mmput(mm);
+
+		mutex_lock(&arena->lock);
+	}
+	mutex_unlock(&arena->lock);
+	mutex_unlock(&arena->zap_mutex);
 }
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
-- 
2.53.0-Meta


