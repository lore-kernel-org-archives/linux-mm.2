Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C56606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltuI0pYY
Received: by kanga.kvack.org (Postfix)
	id DCBD76B00EF; Sat, 31 Oct 2026 14:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D206B05B1; Sat, 31 Oct 2026 14:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B8E6B05B2; Sat, 31 Oct 2026 14:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9690B6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:14:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E2E11A097A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:14:11 +0000 (UTC)
X-FDA: 85383720702.25.C38558A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09AFD120005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:14:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltuI0pYY;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793470450;
	b=CLB/RvZdkw1EeOcGj6prEDpvPvCBMoKUNPn2iAA7IXJgwPdSq3H1WpFUp32PX6b7m/W/om
	q3w90Xj7+dHXiMDatPC5ztNB5jTdnpMUAorQRrDC2IjNwaX7C9AjUMkw2iGykLgUSFkyVG
	Pl3x2eoXasYviPn7uUShJvcpcdfgoTo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltuI0pYY;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793470450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+lDk8EHYpV0tgsYzdqpx9pkwT/VF+dJgKPq60hbaEBs=;
	b=79sgqgFw5joKynoCGfecGb4HH96PTq3JblXL+Gl+Tt8+hvykDk4hXqM19rcv40p39MwxEF
	VcIIhtbFeKHipYoKEZzzhrkkBUkyo+KWSslpRFadVikE6paoKDgt0ua3zxMqRkb25mm48C
	MimOAvJcSxDqnJ6oFu/BrvgyWUFahMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C00160619;
	Sat, 31 Oct 2026 18:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759D01F00A15;
	Sat, 31 Oct 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793470449;
	bh=+lDk8EHYpV0tgsYzdqpx9pkwT/VF+dJgKPq60hbaEBs=;
	h=From:Date:Subject:To:Cc;
	b=ltuI0pYYmAHP6jr8YvI2mcaCXAy0wGU5zNKYgobO5roa0kNXxuUoMEEude3X1Oq4d
	 pnZ6rPf4P5Q0Djz4L4HwBBa0lmBC8KylvWV6TxldJ8n0+tp0eErvLDiFw44syJo/zT
	 YGd9IvxWzwidEgr6jBR4i+xlbk+TTUp9TeU4qIzSX+Cd11FYtzuWFx5JPUjvYkdls7
	 J0zOx4QkwphnwTGLhkTmZx4eAhdOKxZAs8jsk4LzdFkEcTGAYj8n4F0yKCwxUcUp/X
	 F6HzCiGlbWJBU+G9pJfVX2NpaojdLGGdvG4DA4uBFeOrkuXUZz1KWEfssK9NMkb51M
	 dkW21P9pzLrBw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 31 Oct 2026 20:14:03 +0200
Subject: [PATCH v2] userfaultfd: clear uffd state in child PTEs if uffd is
 released during fork
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-uffd-prot-bits-fork-event-v2-1-c448e57df417@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42OTQ7CIBCFr2JYO+rQtP6svIdxAe1gUQEzUKJpe
 ndLvYDL7+W9L28UkdhSFKfVKJiyjTb4GeR6Jdpe+RuB7WYWcicb3FUIgzEdvDgk0DZFMIEfQJl
 8go4OErumRqUbMe9fTMa+F/fl+uM46Du1qQhLQ6tIoFn5ti+RcyG5rXMw+JiUflLp9DamwJ/lY
 Mbi+udLRkCo6r08SmwlIp4fxJ6em8A3cZ2m6QtNamy8+QAAAA==
X-Change-ID: 20261031-uffd-prot-bits-fork-event-de821d651ab6
To: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Peter Xu <peterx@redhat.com>, Tal Zussman <tz2294@columbia.edu>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 09AFD120005
X-Stat-Signature: nrpfney7nqjp4trangp538k9azdocb8i
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793470449-243470
X-HE-Meta: U2FsdGVkX1+Y8zKe1KnJeDagOZXFI7w85ACX5Lk+GZIERMee17BfL7hgf0aT7aZ1qnMjj9CgMeikPeqI/HQGoPWPPnzV+oOIDFa5uhN5JN+Z7FEolwMaZDebWkP5MCa6ogwV8xoGhqgfMJihvJ8Pi1XJU2VdPBeDQcHAtjjiGJ+NLi6N3KsLYbBaRaox33Ffyzr9Y1ELrP+WVB0ckcjnuxMxMSTDyXw8GJZnQdIsjrDXsRzKY8myyyA353OAZ2dHphX49ou738rmuVfhrg2HMEm91y9MWDxJ39tbhbPnoyD3qa/nNshZPBicYf7zJJOOw3kqaOtkQmtzAKw5DSTGCMme9Y0JWYPocmaeL2+PUmNpK8XhwPW4aSK9KyEWLujRPMk7gswTn2T22AqwcnT6DmFfzAvkpmh4vHMazK5QGJm/dfKWIfa3K2gd2SIqy106OzVQUgqT4ycgkRDpw9M1rFKAlPpd8p3qPbD5lHeeIXJ6sjbknr6G7p/cEZ6sXIoG7X+3hy6p5sJnHUkIvhR/1xIQf1JbE6dyhhwqtIzun2JMIgMRZ2LBbfDVcoYruPbLO6A97zBiBsE1aPptYXvb1TF1mZlFYffd+izOLI8DDTCXT8Mr7zjc41/4Kj1NjeL4E9QFhYN5DRJ2kMzqGpVvOJidWCFyByLvYqet0hacKLnZ2VJNw+u9PT1Y8+/R37q3WG8sByb6BZvnmk6O0TP18jFqaooQmTy4E0HfEnTphUKIHWPtHge3Y6QCg/J5IsDT1f4RCf6SEWH0OD9fNbS49MPXzlR0kOjrxDCM/EY40Y24ZyNgEjYU5BXo3w4FFj8W4r7L3FGB4132xMpEibXHtieYdgV6jQEuF2oGzDekPY9wHHMpNLdNBRR8ekYMWQP+SyEX2JpSLQEbs9sAcYX6990B9xXCDyogzVUUIYxpQh6pKmak/JeARCxEGODzN6InjhovdhGRWWwwK/BUnYj
 s8Y9qck/
 k+5igy8PnjB32OHPvQsvCJanPAvNszHTPnIHiqtUjhhMRzUSCDAqsp1awy6l242LYm02M5TygkULCqOoH3tcrgmmSepIgUjmHNatLGWgXblVefHmI+QbnPlr37opUaAOCf6pWwW5MRtvoIsHOS7XVDIvZVbzWM/gX6hTq40FN1ecY0eIVzUMi4v0LfyuqzDi4MTGO0q9HzPHGx790i3R0GNg2SDCXDrIORmarQvINAKOXeoN/xvAqd7OLlptUKU+Ry9WNP3I92L2AFxhXDqfRbHe7sbpc8PAs6Tkvn0XfS6t1gHs0OIc8DpIRjjpMeH55bVOASgSMQOqOu+wYtw6EJov5xY62iKoGBT2I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
child process, the child VMAs are registered with the new context, and uffd
protection state from the parent PTEs is copied into the child.

If the parent's userfaultfd is released before the fork event is read,
userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
child PTEs.

This leaves the child's VMAs in an inconsistent state: they are not
registered with userfaultfd but their mappings carry uffd protection state.

If the child registers the range with userfaultfd again, the stale state
turns into protection the child never asked for.

When a write fault makes such a PTE writable without copying the page, the
uffd bit remains set and page_table_check_pte_flags() warns about it.

Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
call it from userfaultfd_release_new() before resetting the VMA.

Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Changes in v2:
- make comment about what userfaultfd_clear_ptes() does more elaborate
- Link to v1: https://patch.msgid.link/20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org
---
 mm/userfaultfd.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4c..087b66260d04c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2220,6 +2220,32 @@ static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 	userfaultfd_set_ctx(vma, NULL, 0);
 }
 
+/*
+ * Clear uffd state from a WP or RWP range: the uffd bit, WP markers and
+ * RWP PAGE_NONE entries. Call this before dropping the registration, as it
+ * needs the VMA flags to know what to resolve.
+ */
+static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end)
+{
+	unsigned int mm_cp_flags = 0;
+	struct mmu_gather tlb;
+
+	if (!userfaultfd_protected(vma))
+		return;
+
+	if (userfaultfd_wp(vma))
+		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
+	if (userfaultfd_rwp(vma))
+		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
+	if (vma_wants_manual_pte_write_upgrade(vma))
+		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	change_protection(&tlb, vma, start, end, mm_cp_flags);
+	tlb_finish_mmu(&tlb);
+}
+
 static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 					     struct vm_area_struct *prev,
 					     struct vm_area_struct *vma,
@@ -2239,22 +2265,7 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 	if (start == vma->vm_start && end == vma->vm_end)
 		give_up_on_oom = true;
 
-	/* Clear the uffd bit and/or restore protnone PTEs */
-	if (userfaultfd_protected(vma)) {
-		unsigned int mm_cp_flags = 0;
-		struct mmu_gather tlb;
-
-		if (userfaultfd_wp(vma))
-			mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
-		if (userfaultfd_rwp(vma))
-			mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
-		if (vma_wants_manual_pte_write_upgrade(vma))
-			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
-
-		tlb_gather_mmu(&tlb, vma->vm_mm);
-		change_protection(&tlb, vma, start, end, mm_cp_flags);
-		tlb_finish_mmu(&tlb);
-	}
+	userfaultfd_clear_ptes(vma, start, end);
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
 				    &new_vma_flags, NULL_VM_UFFD_CTX,
@@ -2353,8 +2364,10 @@ static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 	/* the various vma->vm_userfaultfd_ctx still points to it */
 	mmap_write_lock(mm);
 	for_each_vma(vmi, vma) {
-		if (vma->vm_userfaultfd_ctx.ctx == ctx)
+		if (vma->vm_userfaultfd_ctx.ctx == ctx) {
+			userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 			userfaultfd_reset_ctx(vma);
+		}
 	}
 	mmap_write_unlock(mm);
 }

---
base-commit: b61fa14ce6bcbba2cb9a96feea31b760226d6b43
change-id: 20261031-uffd-prot-bits-fork-event-de821d651ab6

--
Sincerely yours,
Mike.


