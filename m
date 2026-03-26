Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3214C106F2FB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651346B0092; Thu, 26 Mar 2026 04:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628BA6B0093; Thu, 26 Mar 2026 04:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F086B0095; Thu, 26 Mar 2026 04:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 368056B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 040F55C701
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:48 +0000 (UTC)
X-FDA: 84587487978.20.D172371
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3DC9A140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RrVVZc1y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3jenEaQYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3jenEaQYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+yXmhx3uKy+6G9q4kJM+us9QDWjdFJDAOgDq56Y4dE=;
	b=PfIwZiR+g4fGIJUkQKkRI1EaVl4HjchYLlP52Dgeikz91aCxsdtqvlWaaYtrEMkxyaYNlv
	dpIJY7EfjnBHXl49xnvfgEQsPGDq8h1DLGXUeHBBUYvfGn8Wd4N58uHCC6zeHdNzGnpiny
	ulqC3GrlZk/Knrll57+/usyUgo1Oe7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512527; a=rsa-sha256;
	cv=none;
	b=A8AtG+1L/aYhDJeOndDokoBM9iwymfLzUqrtEZC2SF1lfvk0xB+U3VLELNjlpobihj3feB
	UgS9ZYJ7XTLOr6+S/8X31dYX1yzsjfZWAn+1230uPwy8G3yzHKDYpNBmRCaOgIzMcr88aQ
	t2fMXpNdhnCFvygMGnxtHnQ2y7Tijlc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RrVVZc1y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3jenEaQYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3jenEaQYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c0ffce2570so4640865eec.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512526; x=1775117326; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C+yXmhx3uKy+6G9q4kJM+us9QDWjdFJDAOgDq56Y4dE=;
        b=RrVVZc1ycPDI2TQddsptjuwOJmHaK2r6v0CxQhXSEOmFaIlHjzYmSxxxfmSQZFl4Y4
         NGsS0cM0xR2f4OzUEuvkDBwLO6Ggovo5vycd8jZHfCurKxEd8+cz9/RmbhWoIVTGG6RA
         eJZTZsAMvfXGS6862vILoLD+G7y5XEl9LLK2l5ugvdUbU816wa3V43nIp4l0NAWIAb2z
         hf8ZlR6w0jvwmEsCn2xhiMm3sQlJoSTommFbJdJtLc5OPZccRPvgClVL1QlvICdD6rOj
         7PJjLVK3NI16ie9ZPq9ml6v+oYlOVm18RQ8lk+rQ2Zk8kJT/SeQMAUlSmt0D8g/8vu71
         hsbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512526; x=1775117326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+yXmhx3uKy+6G9q4kJM+us9QDWjdFJDAOgDq56Y4dE=;
        b=pWh9y5EoPxHJuJJIYXdG+icTrdONUf9KKWPhx9GRhRaaf1z23zdAPDYTeADC/NiEbP
         hkW/6aaoEsps4s5Yp11/eyESmra7OEg3VgvldRdhYQZX3190xZGXuPuFH5D/6WzvgZ6G
         i7eiqwsoh5f3iWAX5++YcEUyTk1ZJ2DCu+ZTCONe3huXmD+nByFVhAymAyPRg0XuC2Uj
         wNFJolMCzZ3aecPKqThW9tSDmpvxdUZzOutym+y6bL5ZsJKS7vizBGeyoYs/XplqE6wi
         VU6ywF3S9m6kjepWrxiOJ455igTA5SI5oCv1UsreMBcG9o/eVkmdFD3exBfGIaE1D0tg
         /TfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEmOqLVyp4XQEYQIdJJHRPJiTzaNEv7qbRtx2Ic8hCvi4Dn76zcDiUKR8uxmxlGHTjS6FUyajXTA==@kvack.org
X-Gm-Message-State: AOJu0YwO0gd4Lu6URuhNwapga8vDKSsmCEEJ/0jEcx3YF9c0GkVo7fyY
	sM2Wi831ZELNVd5EfmYPG5hfOyO8dsKWeyfs6kNwXn+L02Jpp9kPZRjGbfQ11JMc3u59CStx0NV
	LHLIGMA==
X-Received: from dlbvs2.prod.google.com ([2002:a05:7022:3f02:b0:128:d36e:eb6f])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:402:b0:11b:c1ab:bdd4
 with SMTP id a92af1059eb24-12a96f04f69mr3338876c88.38.1774512525642; Thu, 26
 Mar 2026 01:08:45 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:32 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-3-surenb@google.com>
Subject: [PATCH v5 2/6] mm: use vma_start_write_killable() in mm syscalls
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3DC9A140002
X-Stat-Signature: 5y94de7tsktcz9tiw33ijs4iio9a5kah
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774512526-679359
X-HE-Meta: U2FsdGVkX1/nL8dmPXdRmJx1HrksG37jfC8FQeWepKi3ma8aEoeQvdmQsL27mCeccVoLqzSIYwc7u0cBy9qJLUosvVlGSC3vW2+FUix/yOV2W0AnKW4zwfSywNffuX0fSiWOGREbbVrWI8J9Hf31/MVgRyvb01/XAp1eBrqBO01jzbEUF9ktHIRP5B3FxZUt0+hD0ZgAzRZK2EafDhCs/bwROKBmrOyvJ7JtmKfahLr3o79xgk2M0RvIFPFLtrZtCfLiU61F7NJ4W3FeKdHhc8YarFQ3d4w+pJxTBZPUVygQZlCZO/lIs1oOkDc9++hnYnZ2rPDe3BYPVeX39/qP5niQCGJ0X2vvUCl/JXi+EeAIydjsGmpnN1eZCbt9gq6wv8xoLqj+OJBAT/E4K2rEcWNQ1EgSwjYH0HlqyhOywmvGWYmtv2V2ZegvO4FrNeOqA7edtvOWG+UdMKu9XCE1PuV8k9N/bGDLAFxbuWXMmhvNu+5tQiZOy2tRQQ4tlyjKpY+lPLI6TMb9ge8MaeLwuqO/LL08Ert1NJJ2uOF5l9K4qkagLFCKyKFoeJmkpIUUMzK9JZ1rns7wPxirhOqB2KYMZC/e4HINwUAW8U+56S6CvuCs1va4sU9W7ZqGCTkNwAoValYAvBz0/N9WUUfRdLCCueotC7vhGKESHCnIOGjal2RQNe7qatjdtR+P0qxW4u57z2Ic+kSzHOH+Au+oUJHvSoVr4EgHh/lW8fy3aZNUSxUslvNxXMdFiK5Blv+eWky+rOJK5s7K0oKo4G7byc5LhaJvr/Sd9vZOz6nymuqCqE7KvIIadav8G7dRPjF/dvWKehoM7s1CQAgufp2UfWBu3o29dIiiK/ADK8zjwuewOZ7GnL0Q2Ggp+Mf9K/oNhpW/dJTmJ5GvhVOI7HF3nGMQjKlygsWx/Cl0BdahrsdaYv2MQL1M1XcvL2arcnTJod/9R+C1v+zB85mD47J
 NUNtZyu5
 BKHi0tH8ZwKok6seXW9Xp49m1H38cWHRDMxF1jJvPEFMsbYXtQUXReVISL+fU6XaSXgdn+UeTZwJCJK9U2XYqfxx/enh9kYu0jTxuEnFp0sNeAh/+4A1X19kKuYH5OYvWC/PXRSRvO7fF6XZ8Gn1yOql+ILaMYz+9BWV8raXZT475UC7GRdPbeDaotgWfqFloVdO8p2Ep4GZfxBaTas0Cza48poen1jg3jaz1duM8/31nM3LxHD/qJJldUWQoScJf1hKla55pThcMSHZCZUOXAZw/BjE9SITPy3poX5dq0VdxCxAy7U1oRo9WOkfiXy7kY0AEpf9sOI5GLdaXsKwQHpXss8qmVqo66Ildki7XKPzfMkflV7wIJVSgnJ6BFfpTi19KEiYzMGWzdHawklndiiSmDJCHdu4ULPQ5OSFURzBaEjb2Sc+hQRJhrlO0eLKWdeBAnYR5AcXHQ/GuWevop79sqwmRn8wcYtgr7odKr11iXcF21HEjfI2iefBKse+CnecF7ddJQVFnd83wilmBxYiTTBOHe/6g1BcUCOTlMODzWimqID3U8qoHXewYcGLGFrnotlUY2HCqcUu7/04eMgYLV0wb12HfPqqL28+qjVPJb0kk5lmIR1aTKeGXBwLOP7mCVqUwqBGlmvkxsPjfwKQ8AcGqXECmSKDqm2IOwUvMs5N6qgKtdW+R0StsoUqdKYpMMZfAO07F3E1O2HLA3XTxrIn8jjbGPMW04sbg+HIJMVYcGKK7y0qXjCWw5vODKW+YFUpXlhro3Z3dmHJO1OfWLdNuWm/e2d//Tf8h6DKGfVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable() in syscalls,
improving reaction time to the kill signal.

In a number of places we now lock VMA earlier than before to avoid
doing work and undoing it later if a fatal signal is pending. This
is safe because the moves are happening within sections where we
already hold the mmap_write_lock, so the moves do not change the
locking order relative to other kernel locks.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/madvise.c   |  4 +++-
 mm/memory.c    |  2 ++
 mm/mempolicy.c | 11 +++++++++--
 mm/mlock.c     | 28 ++++++++++++++++++++++------
 mm/mprotect.c  |  5 ++++-
 mm/mremap.c    |  8 +++++---
 mm/mseal.c     |  5 ++++-
 7 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..feaa16b0e1dc 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -175,7 +175,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vma->flags = new_vma_flags;
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
diff --git a/mm/memory.c b/mm/memory.c
index e44469f9cf65..9f99ec634831 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -366,6 +366,8 @@ void free_pgd_range(struct mmu_gather *tlb,
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * We don't use vma_start_write_killable() because page tables should be freed
+ * even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fd08771e2057..c38a90487531 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
@@ -1801,13 +1802,19 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 			err = -EOPNOTSUPP;
 			break;
 		}
+		/*
+		 * Lock the VMA early to avoid extra work if fatal signal
+		 * is pending.
+		 */
+		err = vma_start_write_killable(vma);
+		if (err)
+			break;
 		new = mpol_dup(old);
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
 			break;
 		}
 
-		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..3d9147f3d404 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -419,8 +419,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  *
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
+ *
+ * Return: 0 on success, -EINTR if fatal signal is pending.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end,
 	vma_flags_t *new_vma_flags)
 {
@@ -442,7 +444,9 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 */
 	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		vma_flags_set(new_vma_flags, VMA_IO_BIT);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
@@ -453,6 +457,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
 		vma_flags_reset_once(vma, new_vma_flags);
 	}
+	return 0;
 }
 
 /*
@@ -506,11 +511,13 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out; /* mm->locked_vm is fine as nr_pages == 0 */
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
 		vma->flags = new_vma_flags;
 	} else {
-		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
+		ret = mlock_vma_pages_range(vma, start, end, &new_vma_flags);
 	}
 out:
 	*prev = vma;
@@ -739,9 +746,18 @@ static int apply_mlockall_flags(int flags)
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		if (error) {
+			/*
+			 * If we failed due to a pending fatal signal, return
+			 * now. If we locked the vma before signal arrived, it
+			 * will be unlocked when we drop mmap_write_lock.
+			 */
+			if (fatal_signal_pending(current))
+				return -EINTR;
+
+			/* Ignore errors, but prev needs fixing up. */
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 110d47a36d4b..ae6ed882b600 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -768,7 +768,10 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * vm_flags and vm_page_prot are protected by the mmap_lock
 	 * held in write mode.
 	 */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto fail;
+
 	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..0860102bddab 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1348,6 +1348,11 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
+	/* We don't want racing faults. */
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
+
 	/*
 	 * If accounted, determine the number of bytes the operation will
 	 * charge.
@@ -1355,9 +1360,6 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	if (!vrm_calc_charge(vrm))
 		return -ENOMEM;
 
-	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
-
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
 	/*
diff --git a/mm/mseal.c b/mm/mseal.c
index 603df53ad267..3b7737ba7524 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -70,6 +70,7 @@ static int mseal_apply(struct mm_struct *mm,
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;
+			int err;
 
 			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 
@@ -77,7 +78,9 @@ static int mseal_apply(struct mm_struct *mm,
 					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
-			vma_start_write(vma);
+			err = vma_start_write_killable(vma);
+			if (err)
+				return err;
 			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
-- 
2.53.0.1018.g2bb0e51243-goog


