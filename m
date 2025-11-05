Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE311CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340F28E000E; Wed,  5 Nov 2025 12:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFB58E0002; Wed,  5 Nov 2025 12:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0278E000E; Wed,  5 Nov 2025 12:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A49A8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:30:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA5E013AE83
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:34 +0000 (UTC)
X-FDA: 84077242788.29.DF2F778
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id C36F3140016
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iplf5E/h";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363832; a=rsa-sha256;
	cv=none;
	b=nhrid7UKG772iXX1wrBUJK3H+r1AeL8eED6njW5Ys/1jCneDqk6TByrqSWgsS1clYkHzhR
	4X9iEd18AKCPS0B7yKRJRc3S3pH+L6PfCun2PU3PgCI/bWZ9tW54bAT4FBS+6uC6cG4NfF
	z6m1uSKrxHGx8v2g6Lk5NTZo2LPfH0Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iplf5E/h";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9T7mC5XsBejwVN/MD7TteppoeD76dolBCKVexUhUEGA=;
	b=EImugWG8RknteMmRNJPQliquX5FEuSwcrjskvu76i614wCjbqBlND8Py5/M0T9MoFKvQfx
	qED2qVo5t4imTxiQVBO4ggG9buqIRtVfo8PJqwzZ82fYVpzKRJcZzBr/ivl1bbCzyJTSqX
	RdCq95zgdTRAS+Ca+yzCjbcjGx7iMO4=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c6d2ec149eso58052a34.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762363832; x=1762968632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9T7mC5XsBejwVN/MD7TteppoeD76dolBCKVexUhUEGA=;
        b=iplf5E/h+aDV2QQ9CVdbAZRdI7CX6Cm4QC3ONlUZanQb2W2FxmzWTGKdq3SW5XTWf0
         VjpfyM8f2Gj2jD7h5ZpG4HL+MYSH3LcgA4IzASC32Uzn9xGpcmJGCOyQfIca6jlyjC+P
         O7XyLTF1TayTXwT+hXhJ/tNUhMIOjCRNe8XIC2uYoMBRAnFiHnTbnBFZax6Y3jSx+rwS
         x+Ss8ZpeGj9ab2DTSKUodgABumoBkSZqBalpu3c7ILqMBMCKl4yqPhyIWvhXMYA4EFcE
         HRaxnp05s12vCFikedh2PDEEHTIOjS1F5ticEV5UblRK2cKI8mcfJdXccq6wGHKJGaw4
         sRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363832; x=1762968632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9T7mC5XsBejwVN/MD7TteppoeD76dolBCKVexUhUEGA=;
        b=SGVTGpLrcjaD+d5EKlE8YwxUHcU0ZQG6NGcLF3GvJbCOyI6Iy4sWCM/ZbcP2ccpBoi
         9e/MlOpJb8sJsgSFXOqRq2PpE5kFFrXYfNLIYpdP0TwNgC/91QMSa/O0pZ991T+QMu4m
         HxABFAsIHmtzLTZ6myuC6T6LF/omJyKyweO7YOFjhLOxHovU++oaZ/Fe/KVpgDLK5zqI
         V1om4th+ambyJGRy1EnUrklS+jXenU6l2x1uqfNsAdpIstAhBGXtr9MQI6d+LQdaJKZO
         aQhSSEdbdOhvL1wr5j5gzWfNrwE9NFlgmieUKWaU9wpHlU1/Rg0Ot9pvofGaQzBKE5GL
         7hdA==
X-Forwarded-Encrypted: i=1; AJvYcCWUAdIq8RUXRYaFltvHvkNy9mAVnfyt3yjuLlUbtQs+cRbSyKm3HoowJN0rxVsr4G1vSH0KuJGEQw==@kvack.org
X-Gm-Message-State: AOJu0YzK9azcyNWRK0njfy1hIKYImhY7W45w6g5Q9WnEjMlEZ7rATNLs
	ACUZmGSu/u2u7jV3KXlyKVys1A3NRD6JoLFhvQ5KwoBoFQLBd8iH/HeD
X-Gm-Gg: ASbGncsMvz3IxKbt2P5+P9Nc7ItREsAENH2qvLTHwJhn/zgJDJ77x0XuPsKLZaMMfo9
	PewJRahGFHeyBZ/zveeQSxWEtR2QMiEliXib7jPd53jjFH+wjilWATPmEeIK2cHEO/+3BlLDcia
	tDpp2Wv5wI19l9+PqyTcwactk9RiyHkcFXjXRM7XsGhVGq3ve1MZIrxI1CpuhgdLxeC5w2djBI2
	yc9jHwMhxopQIs3lIuP9Gv0oOpUitZGA9EmsXpAQpmRu9J5FsdT7ifDkgPaltQ3HE6zoMgEqWgh
	3/++U+LB01WltLTlzYh8CBTEYoOdCqHH1NnfGJhaWbMPIfXQgkkHezqGQrmRKx26vZUPd5RHOE3
	SFyPKlG0XQzAEln+aXD/4VdcEJJ1d3Nx/2V2JUatCPwAGKeYG0LnJglxydH5qV5K+3Kjdggv510
	kpggHk7y9d7TmBbUOLvXXZy8mvjw538E+nMzl6iZgC5RCHpqD53fRZciYw
X-Google-Smtp-Source: AGHT+IEBiljDpXhOdYTX7ZvPWxKHLbWSS4eTdnsshXb5F5CF5p8DGEANRiLmMLmNxqqbwLiDoOJOfw==
X-Received: by 2002:a05:6830:2a86:b0:7c5:3b4e:3020 with SMTP id 46e09a7af769-7c6e1404c5emr168244a34.12.1762363831770;
        Wed, 05 Nov 2025 09:30:31 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6c25108b3sm2248313a34.30.2025.11.05.09.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:30:31 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v3 2/3] ksm: perform a range-walk in break_ksm
Date: Wed,  5 Nov 2025 14:27:55 -0300
Message-ID: <20251105172756.167009-3-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105172756.167009-1-pedrodemargomes@gmail.com>
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C36F3140016
X-Rspamd-Server: rspam07
X-Stat-Signature: qnpo4gycrn3pi7wbtq6x53d9n3mp4x3o
X-Rspam-User: 
X-HE-Tag: 1762363832-252482
X-HE-Meta: U2FsdGVkX18X/Oju65Di4+6vIbJZj/CvGLtGM8hRjk0AtEdKkXy7b5LW0u3HSfZvsQSf8VMi7LxtBybhkJ95RqQx5t4+pfqfXDjpLfZmf913IrHtPSMfj/zL+uUEkJFv+MJnSnSdEpANN6lst+TuRhZlP98iW0Rj5CoK1B4VD4Pq9fQ3dvxDBWcfQ3zpGJe5ordMieM9qixJfRDLteBR77JDmmJ4Li6WhqZC+lpuD9N9ADfrQyvqipP2KQ+U8vMwCO1v9835a8S/bbaPuwL/Cs5QhdRce8VILkX1txnZ8GvBu+Px1fYqOpFUkBZ782rjckgWbpx+UQSI8STKIzRKGe2iwNBsU3cs38dr4LNj1nrLOqd+4g6wtfCWIru6JnZZJcC0bVenwuf+0uIfS3S0LX0R9at3u/YF206ozrU6GIaE2SjsOlDzm+o0d78KLpmJ5NGHf+Z+gxUOtY1nqls31vzJFynhFbB4jFqAMgIDTgz7spjDIghTivVwHdCEWL07tf/hJ3oJ07DfXEOb7jFClrfyrbZIC3Zk6KG9TNaBFZ55t88q9+POoH+0CZ708Fb5y+dLn61I54HFzscbDIBPEQpzOQX3H5kCh6+mv+SfeakN0VOC6B623GkSLl8bA7hWey77RYx6hROONzwZdAzbYKCYgDPV25pZ1qoDDPoRvDQsIVSUTiKC+ZA614/gllMo8XvvcF9K980K4SUOH2R+Zmf7LzKHy1kySMr1lYnJ/qpzFLHO6ZdQu1da/AjhL/Jq7T2edNKIqzdCxrKmvl5Sdm6HrVgUrovxq0fwjqa3ZOe8aBlFduws1QEkUs6VjSMt9SerVY5hmgzj1unMYB+s4QqVjjrw3pI+6GBeFbe+r7xTjxSPGv3ZPgE7fqbWyIZRFp3RcWposkmZrqDRUL6jaq6qtqFTxadTcGq6gYKFIs4d4+YcaDavyl3MHBjwk0ecX0zSMHAMDYTAdqfQTCS
 UnEN4rTS
 e0gpUlvWcMQaIifDL4bF4oem4oijSK5j5EFhQNDFIUHeP03nMj2HKSaqEbu29CO6SUGxW7fpfyFPwN2vBBUHPYcHZgYSLoIG6CZNfJy6J64+2oxRK+tlEvsllLADhVYrue3+Uv7od2cRl5EJCBLDiw/SmxIE8p78IA2+NOt3DdVA8b2g0KWrSRDtgg0o0tM6w+YutAKFpRkRKidG6/zRSDgPiQJ6B0S+/3+YuqOsDU0u0MwrSS7IkZQeb4mEFMTgY2d8KdJIl+Q4l1d1/hELqxosc6IsLXgOZxZmnJes4P6IkhseGf8rOEX08zdNDS9ULwSpUjYwGi0+jWtdwL5RDRaB2CavWyDJm9OZOcmejKp77bkqWITpkBb4/xDYdXHqmDnLjyxuULcqQYUHSP75usBh/LBnkCPU5qI+KIrTFl9pEmYo7RQ9Y4bafZKOk0pmxXk2qqmUbMcHpA4p0wAtR1NSmKh9bAeg3DYFC1mVhsF44XKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make break_ksm() receive an address range and change
break_ksm_pmd_entry() to perform a range-walk and return the address of
the first ksm page found.

This change allows break_ksm() to skip unmapped regions instead of
iterating every page address. When unmerging large sparse VMAs, this
significantly reduces runtime.

In a benchmark unmerging a 32 TiB sparse virtual address space where
only one page was populated, the runtime dropped from 9 minutes to less
then 5 seconds.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 83 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index de10ebcf3509..5fe3d9c2cd20 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,35 +607,50 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
-	struct folio *folio = NULL;
+	unsigned long *found_addr = (unsigned long *) walk->private;
+	struct mm_struct *mm = walk->mm;
+	pte_t *start_ptep, *ptep;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int found;
+	int found = 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
+	if (ksm_test_exit(walk->mm))
 		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		folio = vm_normal_folio(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			folio = pfn_swap_entry_folio(entry);
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte_t pte = ptep_get(ptep);
+		struct folio *folio = NULL;
+
+		if (pte_present(pte)) {
+			folio = vm_normal_folio(walk->vma, addr, pte);
+		} else if (!pte_none(pte)) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			/*
+			 * As KSM pages remain KSM pages until freed, no need to wait
+			 * here for migration to end.
+			 */
+			if (is_migration_entry(entry))
+				folio = pfn_swap_entry_folio(entry);
+		}
+		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+		found = (folio && folio_test_ksm(folio)) || (pte_present(pte)
+			&& is_ksm_zero_pte(pte));
+		if (found) {
+			*found_addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	found = (folio && folio_test_ksm(folio)) || (pte_present(ptent)
-		&& is_ksm_zero_pte(ptent));
-	pte_unmap_unlock(pte, ptl);
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
 	return found;
 }
 
@@ -662,7 +677,8 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
 	const struct mm_walk_ops *ops = lock_vma ?
@@ -672,11 +688,9 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
+		ksm_page = walk_page_range_vma(vma, addr, end, ops, &addr);
+		if (ksm_page <= 0)
 			return ksm_page;
-		if (!ksm_page)
-			return 0;
 		ret = handle_mm_fault(vma, addr,
 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
@@ -762,7 +776,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1073,18 +1087,7 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
 static int unmerge_ksm_pages(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end, bool lock_vma)
 {
-	unsigned long addr;
-	int err = 0;
-
-	for (addr = start; addr < end && !err; addr += PAGE_SIZE) {
-		if (ksm_test_exit(vma->vm_mm))
-			break;
-		if (signal_pending(current))
-			err = -ERESTARTSYS;
-		else
-			err = break_ksm(vma, addr, lock_vma);
-	}
-	return err;
+	return break_ksm(vma, start, end, lock_vma);
 }
 
 static inline
-- 
2.43.0


