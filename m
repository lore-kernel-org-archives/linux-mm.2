Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBE0CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC056B008A; Wed, 13 May 2026 20:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E39A6B008C; Wed, 13 May 2026 20:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFB66B0092; Wed, 13 May 2026 20:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38ED46B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:54:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE59B1605F7
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:54:53 +0000 (UTC)
X-FDA: 84764205666.12.9DB5A4E
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id E22E240005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:54:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qr8qEex8;
	spf=pass (imf04.hostedemail.com: domain of michael.bommarito@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=michael.bommarito@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpHT3HTZZtG1cBkUUFs+hcciHpVVjeK0Jx3pQ0mUXQU=;
	b=6f8IEQYua+OzXlmoioyCQhgeaBb/8wUI0jpbu3+DqFvm01N8R/Fj6dUzgJfRdP2wPeybiL
	WCtIjQrYGqUJN0xV1jtd7Eu5vOx2uYnDUY9jwojf89Vq/23E0c2qXRxe/ORThwzpykXNas
	8/YIosKJAFd7lQkvBYpb+XeC7WnNMqQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qr8qEex8;
	spf=pass (imf04.hostedemail.com: domain of michael.bommarito@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=michael.bommarito@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778720091; a=rsa-sha256;
	cv=none;
	b=PZmTk6iTlbdj7WA7Ohb2c2Ycfs5c7cvdx2EDkhYej1eT6htd4rvz084dpvbsso5etrHHdT
	VG9o+RJsyJcXnfZbKi2zf+SxFdRAb2JUoW0A+BwHp2su4uPUTYxz13CL+fRqGxWNgmIj4+
	z8g9bCGPTlVCGdJSiXO9ySwMXqd+nKY=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b5cda2dab9so68836866d6.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 17:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778720091; x=1779324891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpHT3HTZZtG1cBkUUFs+hcciHpVVjeK0Jx3pQ0mUXQU=;
        b=qr8qEex8z2QwRsDWRGOHWsSv7SbCIGxQiOPmueI0LpYXFLhDiS0dr8qxbtM+fCMR0X
         2jteL6c469n1B3wOsJvmgbDAu3qk5NN51NcMJ9DtcXa7LBmWyfX3oROSAHwL1Fxna7QB
         aVU2putrCwz60yjiUBhXV1trTpbQ3IqQJsgNciwvlNUg9dJWcEoBWtVTtwbnWXM/KLiM
         RRZeW4zLmJqCCf6uHsFK9XCCemeqmmtk8Hug2lZt7/rBkKbloycnVrUEf3Snf7ZsW+ak
         8WY+s5iR5QBZ6S2SY/Ene4QtU+crdKszkg2bEIeFcf6MiAsxcsyovDPVenM77IIXptSc
         ihrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778720091; x=1779324891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OpHT3HTZZtG1cBkUUFs+hcciHpVVjeK0Jx3pQ0mUXQU=;
        b=pXfvyrIXAPm4lx1Elrx81ZWEIGE3jLwtu2wUR1t0kEa5J9ahObmFjyli7qPnUP43DW
         vmKyiZplNHbZ/wjGL6x30/fZdqQyyt+c8sZVrfu/mLvZuOLLf55/29hGw5W+bs9XNpG5
         Hjm2pR5j76L2/EsBb1abUB6OImcwf6iu4ZAbR80CloCChet0+EZGSYzz8aPbH+FE5zYU
         /3sij50C7h5q9ZXF1sRnYBkZcUK1djJJjELB5Do32D52OB81wNPDlOhAlsyGrY2krYvG
         RVjN1f2UWG0AiPIYlVZC3eH64DTBmLr3S8x7lzbX5Nw/IPVLW5I2z6Xr9xNX6cblTvxV
         VtEw==
X-Forwarded-Encrypted: i=1; AFNElJ9zyIAA1c5UE9zqZvuqCrZ1iin4u4P8oU0yQpurdTJqAkQ7o8ioO9NZSieqwV+Oy+S1a/evc1ybog==@kvack.org
X-Gm-Message-State: AOJu0Yz4pc9uMHmzNcY28V4CU0VltLopfupAq+HJJDt1IFGXarECNg+V
	MLCqko300e+LngEzYge5sCluwzXgWQNyEQ9FfF14lOvTvmZDZVqOmgyV
X-Gm-Gg: Acq92OFxzMBBvy+KteP8cQR6Mme7/ooPwLnCg/dR1QXCHoD+/IuV616q+C6bZOsmjhg
	PzuBYYlJNZ2T5dR+QgnID4Yit9b7OJWldn6PaJ2DX9EFeROCFyllhQcG/9JAH3foSHnIuvddz6a
	/uq67iMbDiYhYPTObZ1Eiw2h84eZu6lnBf/RgH7e86o6EMoowVGfP6tFbfhEJLVhqd4bCxdKU+X
	TZ8/Mf0kOxkVnOhWrjjTbNk3VncmHKoYIHBIJQB6/amsPae6sgbCGGVEJE5TM7P+FJ46OgzMH/4
	/IQLoqd8ZIG04q5F4MU5Tr2E6bcuX3Rgelw8tgV2cSX1kZcdJ5W2+X5JCV8eSB8HTKiLGITOVTv
	jBwrfYXoJ/SyMPlFY5mRh/ik/phcF/xHYCdg4c5SthSdC9pBFbOX8J3CyMlnbfOHruuAMg3xPwi
	5i351ptHlW1IyVQREeH0LrhFJ9BYQkn53/lEKjo2sBE6ulA///fLe7jWCK6BHZ8fnriGzBkjiwf
	4ZE0RKJPj+tun222dRf0dXfc2y9wVm9JGFuDDqMXHs=
X-Received: by 2002:a05:6214:4a89:b0:8ac:b2e1:3793 with SMTP id 6a1803df08f44-8c8fdef72f9mr27057886d6.25.1778720090993;
        Wed, 13 May 2026 17:54:50 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c908e11929sm10399986d6.14.2026.05.13.17.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 17:54:50 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: David Carlier <devnexen@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mm/userfaultfd: validate effective UFFDIO_COPY ops after retry
Date: Wed, 13 May 2026 20:54:40 -0400
Message-ID: <20260514005440.3361406-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514005440.3361406-1-michael.bommarito@gmail.com>
References: <20260514005440.3361406-1-michael.bommarito@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uoa8p8iqc57wap93ese8zhxunf99ha9p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E22E240005
X-Rspam-User: 
X-HE-Tag: 1778720091-949527
X-HE-Meta: U2FsdGVkX1/HPz1ZYWNCmDmboHl7UuQp/Zy1i0SS5lGwm0p+ilDl6SBl/HKsLVS7HCfqa7mzds2YpSDfH4+i0CDAeUYK55UK3rD1N6OeYa5Q5pws3CNvUVVFyckw1jw2ijoRkm2PyI6KwQXYgyf41DriVA7vm18qd/hGs6Lzbiz3EYgE3O7IAU7dAz85XCv7wBNKt9c57t+xnW4Of8aZ49KQpCNJEOrsjUQ0AnIzmUoWNGdxBOa1LLntoROIO2n2A969GCHAClwg78g6ha+Cw/rz+c9mkR9XOzNdMYmVUjPtP42hCrFJB1/8f7ko9kvrurb2zOV1LDogNmE8XHVT+h+/7Bn1iQllhMlNSYgkztEP8gHKLyH2IXWNLfax5nLKza5AhzysNDMY+wWrOhvUsvC2qDz32d8YMTaUhXV+Njj9/msFhv2pRGpNgu2CqBA6RNUp6ZgHV8rBNuNefjjsl+gNoYKQ+dPrAP6hBA05bTj1KU6YqZXuN3wOxPpOcwg10R+QbWWTkV8+eYHbbf7Qj8jUv1BuZYzktThV6jKvw+L/51V5zTcfI8u8ok4FrXv79El9afIAaO/9ykJh6CjDRaZpQvL037XrzsdmlhGPzUVJklmHCzE/Nxp7/WnJJD4DEMEfxY5nNokcMXRdnQ2waByICo30FZNfuTHalG1g1t/rmGJJauupTqOhvrl+rz6LtruRQOLiWk6O1wz8pxU1sqjN0Xcwn6WhfXtLJ+lGj9cz/KvOJ6MJuXfQcbS7BccxOpN82ipK3XRQMCW1FmRI8BSgC2OLzTU7ZADQsXc4o2ExH++dBUB3QQQ2bVpX/8u//03kumUeEU+gAx3jmE2YZnLweJZCh6vX3U9CkC1gZbsDPRTbwxFyifOMu66u5z0zGkZmQAtkT90aA4NA2yJVTLG/P1NWJJNgiiqmeB/SWq/Wxv4DmFFXdMOG+iV0xa0KNJehVj6kaTNcRN8rb+S
 5jlFBry7
 36Cq17UxDGIiY5p+jGUd6iDTUJ/yLUoIyrTSKjQGUDq3WH7kaj4MlUnASZFF0uQoIVrmGIdxGUMyTQn7bl7q69COBKmr9gsoBMeFJ7INF+wHrErJqCr8j+Nt5v/RhRq+kDN7A4f1q8SZZdrXjBwwd62DjEbqHYFmRA0b3tjeHq2zR/6+AKS2gayLYGoZruU5d07YTsF0wECr7AagFURmPJIr/5DcA9wt6QwTEECqJ4styYAfrRRtiX30PqB+g5GJT9pCO5j2A22fChZ6CBCdthbMwAFAPgOh0dopxl9yTCG/om2uyVOAk/gtU+yEhPQFrKzQP2JB0p97nTJWLJEPAlEyPNkdyaOPeMZlk192um6RCGp7HgemTuh5rm9GTnSb1bW0MhteMpS++K/8Yc2zTwkxxFxyy4C0lbfjVxTCTaBGI6qK46FenJmitiVS/fjrZ00DJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_COPY fills MAP_PRIVATE file-backed VMAs with anonymous memory.
mfill_atomic_pte_copy() implements that by overriding the VMA's uffd ops
with anon_uffd_ops when VM_SHARED is not set.

mfill_copy_folio_retry() can drop the destination VMA lock after an
initial copy_from_user() failure and reacquire the destination VMA. It
currently checks whether vma_uffd_ops() changed while the lock was
dropped, but that is not the same as checking whether the effective
UFFDIO_COPY ops changed.

Private and shared shmem VMAs both expose shmem_uffd_ops through vm_ops.
If a private shmem destination is replaced with a shared shmem destination
while the retry has dropped the lock, vma_uffd_ops() still compares equal
even though the effective copy ops changed from anon_uffd_ops to
shmem_uffd_ops.

The stale anon folio can then be installed into the new shared shmem VMA.
mfill_atomic_install_pte() sees a folio without page-cache mapping and
calls folio_add_new_anon_rmap(), which reaches BUG_ON(!anon_vma) because
the new shared shmem VMA has no anon_vma.

Compare both the raw VMA uffd ops and the effective UFFDIO_COPY ops
across the retry. The raw comparison preserves the existing VMA-type
replacement guard, while the effective comparison also catches replacements
where the raw ops stay equal but the MAP_PRIVATE override result changes.
If either comparison changes, return -EAGAIN and let the ioctl retry
instead of installing the stale folio through the wrong path.

Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
Assisted-by: Codex:gpt-5-5-xhigh
Assisted-by: Claude:opus-4-7

Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 mm/userfaultfd.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..5af13953c29a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -69,6 +69,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
 	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
 }
 
+static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
+
+	if (!ops)
+		return NULL;
+
+	/*
+	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
+	 * memory. This is an effective ops override, so retry validation must
+	 * compare the override result, not just vma->vm_ops->uffd_ops.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		return &anon_uffd_ops;
+
+	return ops;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -447,6 +465,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
 				  struct folio *folio)
 {
 	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
+	const struct vm_uffd_ops *orig_copy_ops = vma_uffd_copy_ops(state->vma);
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
@@ -469,10 +488,11 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
 
 	/*
 	 * The VMA type may have changed while the lock was dropped
-	 * (e.g. replaced with a hugetlb mapping), making the caller's
-	 * ops pointer stale.
+	 * (e.g. replaced with a hugetlb mapping). Also catch changes where
+	 * the raw ops stay equal but the effective UFFDIO_COPY ops differ.
 	 */
-	if (vma_uffd_ops(state->vma) != orig_ops)
+	if (vma_uffd_ops(state->vma) != orig_ops ||
+	    vma_uffd_copy_ops(state->vma) != orig_copy_ops)
 		return -EAGAIN;
 
 	err = mfill_establish_pmd(state);
@@ -545,19 +565,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
+	const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);
 
 	return __mfill_atomic_pte(state, ops);
 }
-- 
2.46.0

