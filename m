Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44C260A2618
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BrNWbR17
Received: by kanga.kvack.org (Postfix)
	id 8F8C16B0378; Fri, 23 Oct 2026 09:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0706B037A; Fri, 23 Oct 2026 09:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799566B037B; Fri, 23 Oct 2026 09:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50CB96B0378
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:48:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE8F5A03EB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:12 +0000 (UTC)
X-FDA: 85354020024.29.55AA868
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00154C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BrNWbR17;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G051RCtTj/aOitt//0BQMpLgWk+aIYRCuFDvRT+dDow=;
	b=h76uljp/kXZj+O9RpkH7/wCPRMxzdJAb47BqCU/ZnDGll29TpJtcnQHXtaC3GPrT3YkkwC
	G34/JeRPhp3onwpZfc2brPtsEu81+kKq1SRkQqNqyy+Z4g5960xkgoAcSe/Fnu3MEto3Ux
	PrNUwcWS0wLlEj+UFthwmDGZgQ4sLkY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BrNWbR17;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763291;
	b=qNMbReajnng7IeEH9llLPoh4n604LAJhSvxpXZLRlqqoWA0pzERuFukYcaa/7eZv6qoRTJ
	FEHendRBZKlLHTUn1vlImvvH1QpFhq+qkGR2VJGGXXaANqSN9c+wsDTKM+pW7RVqwUXPX2
	Y7Ey7mfjswYkmnoQ/otLj1I28LzDgsc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 379C944517;
	Fri, 23 Oct 2026 13:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B0D1F01825;
	Fri, 23 Oct 2026 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763290;
	bh=G051RCtTj/aOitt//0BQMpLgWk+aIYRCuFDvRT+dDow=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BrNWbR17+oBuMwIuG7dEwUXWBpidc4FPmVZXUhVpfCqgodMj9N5hS2a/deBqIDhzQ
	 0cqK/pf94yEEoZPuWuvHwjYhunsTsxP9o5sl27q6hF7qNQO8GxweATd+OTTbqfmVYz
	 jgdCGDAwVp4i576LPGyxA1J5l58dcEkaaU/SceQmylIcIosYiOEO75mgL+upoGKise
	 2GLGUYIPFXj92BeIpmdTvktLkBPlwf9ninCqpN+sV90q95dtDeKGOGBBHLpStiSM2h
	 +oWN5aemU+1vd77qQKSWecQhhKzzlF6jDfgElXUjs315tPD3NeS3M4+gIttmHKEF/O
	 rM7+LaDxYAFtA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 14:47:30 +0100
Subject: [PATCH 4/4] mm/vma: avoid losing atomic VMA flags when setting
 sticky VMA flags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-fix-vma-atomic-v1-4-8ff4fae1fc85@kernel.org>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
In-Reply-To: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8606; i=ljs@kernel.org;
 h=from:subject:message-id; bh=jnauRsabm7fWTbCZvgqZyNtQKOOPKS6Lkrz/EtjN5R8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJup7b+vWO3komTPaLjemqC/6GzFfw/p9XuM9v63+jec
 u+PHmkOHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZgI9ydGhpcTHJ/qRUw8vEE3
 7HtebcDVy74rvebuKVv67PXqPaW//1Qw/M9dUp76uD9+TmyxsPsMSWmufQcb/1RUrLl5YuYnFt3
 b07kA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00154C0005
X-Stat-Signature: 8rig1wq1nchsmpcyhnceoog4cntzdpc8
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792763290-69954
X-HE-Meta: U2FsdGVkX18kFs9CpMAYfMuLjSACjic+mPKWQvsaN1o9ILXuYUB3v2uZwVR5sTYwxvwxeptrYmqVme2T9UBxXiQAPS9DrlE3NLsVNt/Hz/m9n0h+bpvZlmwCKLcBUxm5Ca+5fyE/O6VTE4YMwK6UAsDLuU/mdu5tv/1xI84o1bAhtQoOx+mN886ysy0Bcpb73k9mWR7+rb3dJbfRmnx+xzv3KJ3ohi/4ws00hGS6FEDGA786f3sC2f4rMFlr2sRT/SjFyglHKEuouJIeBqBcNbI+UZkk7W26zDT0W19pFnaDepqTKGaI11+sipMlJmRWbzJYaZIffOloMAaQoSqXtUyciowdq0wDT/jrY7L69CWD5KYncaMqi0lj6F/2R6A+vVcT9efUyOsimc52FJlN3eDSqAWs4NlSx4zDsy5M5kfpLR3ZYC6ZS/Esl8hx2Hw0msgVYGr0ZGcvz6lS+rQOEZZh5l2i/PKpfF7HIMU6wKFO/bIpwRIwzfB5ER1Fhb9hByxzkrgFSWa4pqLjdIDUVTB8j6hxJmLyTfITq85gF1n7BjKUGuWYZm9SNmsSy4FqLY13HXt9FQL5mOK9+ju6Lh9x1Ol2jMpw1notsCG13qiPH8FFKUXtxsp+COOvMm3V123RM4WT5mLZuCaN4RwtR67mJV6vJLqWokSUp9Af0zKSWlS9rfBTRLjI+j/cxApDEewOo+pSbKtJKi96UqLNPHm+ufCgwjztOy9vOweHyDYOltms1EIzk0YCRCysxwwKe37StJEhzjvTg6I6PUKGwCLtGZX6C8wswqZRgNeodIAiuTS151Qnxqzfio5X6Cl5J27VY3YKkd9zNfBTDBWnteSqNWRrzB6FXFK6y96oqSrIXQXpNzAtQSFOlWUqSnbnHYBBUSJN3ZmGK+Ai5OPOzay4W5BVIgXZgg959fveB/kRmTFRE6zOGNV6dZTGHSJrtwXeTHGIYDRGRZ/Qe9v
 8yVt62Kx
 P6R58wVHnbzgxG6a2a0haz9HfESPQ7E5KvZy1Hn80YS86zEHmIHglIa8FLovKOj8j+JPDUfTG66/7VJIQYBQRdNdX8JDklO1bp4gFMVzrVGn2BXW2hNbnPGaMghjlmrlGoFi1wbFsWUSpJNP3OEUMBnj3OWNXuTXpTv5bBW5z9ZWa8Shufnxixiqi+q2/bgHCvGe2UUm8XOalC+3x/ymbWasvWfI/QyDSTp43U6ovIV8l8oebO7MxPTR5TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vma_merge_existing_range() merges an existing VMA (middle) when its
attributes have changed to match those of one or both adjacent VMAs.

Sticky flags are propagated if they are set in any of the merged VMAs. They
are initialised from vmg->vma_flags, which is assumed to contain middle's
sticky flags when the function is invoked.

However, the VMA write lock is not held for middle when they are first
populated, so concurrent updates to atomic VMA flags may occur, which will
be lost upon merge.

This can result in fork failing to propagate guard region markers and (if
file-backed) THP collapse discarding them.

Resolve this by propagating the sticky flags after middle is locked.

Make life easier by factoring this into propagate_sticky_flags(), which
treats vmg->vma_flags as its base (in case any sticky flags are set there),
updating it as sticky flags are accumulated from merged VMAs.

Also update vma_expand() to use propagate_sticky_flags() so all merge paths
utilise it.

propagate_sticky_flags() also asserts that the VMA write lock is held for
the VMA whose sticky flags are being read, with a comment explaining why.

Another means by which atomic VMA flags can fail to be observed is when the
merge is finalised in commit_merge().

rmap locks are dropped in vma_complete() before the sticky flags are
written, meaning an rmap walker can observe the VMA without sticky flags
set, which can also result in retract_page_tables() discarding guard
markers.

Resolve this by assigning the sticky flags before dropping rmap locks,
factored into commit_sticky_flags() with a write assert on the VMA being
written to.

Also remove the vma_set_flags_mask() invocation at the end of
vma_merge_existing_range() as this was introduced by commit
64212ba02e66 ("mm: implement sticky VMA flags") to propagate sticky flags,
which is now redundant with the introduction of commit_sticky_flags().

The vma_set_flags_mask() invocation at the end of vma_expand() setting
sticky flags only is also removed for the same reason.

Also update vma_merge_existing_range()'s comment to reflect the fact that
vmg->vma_flags gets updated.

Finally, update the userland VMA tests to reflect a previously missed
const-ification in vma_assert_write_locked() which would otherwise cause a
warning when building them.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Fixes: 49e14dabed7a ("mm: set the VM_MAYBE_GUARD flag on guard region install")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c                          | 55 +++++++++++++++++++++------------------
 tools/testing/vma/include/dup.h   |  2 +-
 tools/testing/vma/include/stubs.h |  2 +-
 3 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index aa59005e2f42..a65e397d6f62 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -783,6 +783,27 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 	}
 }
 
+static void propagate_sticky_flags(struct vma_merge_struct *vmg,
+		const struct vm_area_struct *vma)
+{
+	const vma_flags_t sticky =
+		vma_flags_and_mask(&vma->flags, VMA_STICKY_FLAGS);
+
+	/* Write lock prevents concurrent atomic VMA flag updates. */
+	vma_assert_write_locked(vma);
+	vma_flags_set_mask(&vmg->vma_flags, sticky);
+}
+
+static void commit_sticky_flags(struct vma_merge_struct *vmg)
+{
+	const vma_flags_t sticky =
+		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
+	struct vm_area_struct *target = vmg->target;
+
+	vma_assert_write_locked(target);
+	vma_set_flags_mask(target, sticky);
+}
+
 /*
  * Actually perform the VMA merge operation.
  *
@@ -818,6 +839,8 @@ static int commit_merge(struct vma_merge_struct *vmg)
 		return -ENOMEM;
 
 	vma_prepare(&vp);
+	/* Must be made visible before vma_complete() for rmap walkers. */
+	commit_sticky_flags(vmg);
 	/*
 	 * THP pages may need to do additional splits if we increase
 	 * middle->vm_start.
@@ -857,8 +880,8 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
  * merge.
  *
  * As part of this operation, if a merge occurs, the @vmg object will have its
- * vma, start, end, and pgoff fields modified to execute the merge. Subsequent
- * calls to this function should reset these fields.
+ * vma, start, end, pgoff and vma_flags fields modified to execute the merge.
+ * Subsequent calls to this function should reset these fields.
  *
  * Returns: The merged VMA if merge succeeds, or NULL otherwise.
  *
@@ -872,8 +895,6 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
-	vma_flags_t sticky_flags = vma_flags_and_mask(&vmg->vma_flags,
-						      VMA_STICKY_FLAGS);
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -966,24 +987,18 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 	/* No matter what happens, we will be adjusting middle. */
 	vma_start_write(middle);
+	propagate_sticky_flags(vmg, middle);
 
 	if (merge_right) {
-		vma_flags_t next_sticky;
-
 		vma_start_write(next);
 		vmg->target = next;
-		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, next_sticky);
+		propagate_sticky_flags(vmg, next);
 	}
 
 	if (merge_left) {
-		vma_flags_t prev_sticky;
-
 		vma_start_write(prev);
 		vmg->target = prev;
-
-		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, prev_sticky);
+		propagate_sticky_flags(vmg, prev);
 	}
 
 	if (merge_both) {
@@ -1054,7 +1069,6 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
-	vma_set_flags_mask(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1241,16 +1255,11 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
-	vma_flags_t sticky_flags =
-		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
-	vma_flags_t target_sticky;
 	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
 
-	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
-
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
 
@@ -1265,7 +1274,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
 
-	vma_flags_set_mask(&sticky_flags, target_sticky);
+	propagate_sticky_flags(vmg, target);
 
 	/*
 	 * If we are removing the next VMA or copying from a VMA
@@ -1282,18 +1291,14 @@ int vma_expand(struct vma_merge_struct *vmg)
 		return ret;
 
 	if (remove_next) {
-		vma_flags_t next_sticky;
-
 		vma_start_write(next);
 		vmg->__remove_next = true;
 
-		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
-		vma_flags_set_mask(&sticky_flags, next_sticky);
+		propagate_sticky_flags(vmg, next);
 	}
 	if (commit_merge(vmg))
 		goto nomem;
 
-	vma_set_flags_mask(target, sticky_flags);
 	return 0;
 
 nomem:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 815401b19c57..c778fe437993 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1212,7 +1212,7 @@ static inline void vma_assert_detached(struct vm_area_struct *vma)
 	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *);
+static inline void vma_assert_write_locked(const struct vm_area_struct *);
 static inline void vma_mark_attached(struct vm_area_struct *vma)
 {
 	vma_assert_write_locked(vma);
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index f786a585caf0..8d030a3ace84 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -320,7 +320,7 @@ static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
 {
 }
 
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 }
 

-- 
2.56.0


