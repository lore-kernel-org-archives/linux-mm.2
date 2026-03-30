Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A931061B20
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBD76B008C; Mon, 30 Mar 2026 16:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7CB66B0095; Mon, 30 Mar 2026 16:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D92A76B0096; Mon, 30 Mar 2026 16:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C36C56B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:29:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 637BAE0B3E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:29:17 +0000 (UTC)
X-FDA: 84603869154.30.A90A4A1
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67EAD1C0006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:29:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUvnjjdN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774902555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jgku29mUT83lD8y7CN581AIB6Twx2GMJTRo8ZlVZhlE=;
	b=Fmih+azEzliDagFG9e61sqoOUmcGgI3iY5ld9Q/qRhukeGXLJpo4FPRfjdZfQiDimmfbH5
	qXeBOuTT3nM56qoLQKzMC5/qjjUt4YhOCm2sD+ef+wCCza/GUG4xVpNW0t8L4g96gecwqN
	2anLUFifBH+BhyNJ+6H1vk2DyqRtYJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774902555; a=rsa-sha256;
	cv=none;
	b=AWv4tJeqMWrjnRsezXZZP+A2drJb73Y2sv3Q9bc7zu5ZsYyt48RDfyLTBAoan56a1oErxx
	XXmnHVJwCSC6gM9dy6BGiQAT/HxnKTkUlpsKVh78B7NWIbZwvHEinUB3DhYOXeXyD7o0SV
	a2THt7AmYTMc7Nxk8kQNw7yoBXQaMJ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mUvnjjdN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso44898165e9.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774902554; x=1775507354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jgku29mUT83lD8y7CN581AIB6Twx2GMJTRo8ZlVZhlE=;
        b=mUvnjjdNmjZEBcB7xIfWkZw8PDF/4Alo/9Hh2ug2DVrAQOUpC1tHrGeAVmUCjvkYk1
         HfQXeQIxZZ08kqRAmo9vIfZ8mm0wIkZpP66qbOOEm0x+6fts4dfb3jk0Axr6B3mYAS8S
         dK2+mAe5Z8GjxoweReCkMNb24MowV+/u1qEKdpsnt5jD6ZPSW3BPw5aXD1sNqe8Sflhf
         XD7FARu7dt+Q2bzoTT+MIztiMQrxNm6CkEuTV5JElIxHlgHIdd1pnrsAdjnGl/LpjPRd
         jJd9VLnYoLI74r+GARofyr4ImBm9h/C/I4UDgI1Z2wo28bLTg2zeMb9fPwq20ZWkZxLZ
         VD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774902554; x=1775507354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgku29mUT83lD8y7CN581AIB6Twx2GMJTRo8ZlVZhlE=;
        b=l6Sw+HVarZ7+BCpWsHZ37K4MXhW/dY6XxC3N5mghoFPJBiZJXDvKRGtdZmrLdkVUeE
         xdc2c9ofvT6z++hsY5uoCbS3tFwGBbu2/jtOz2/bhA0TmbUJQkr88P6dDh+R1DYXknyD
         o0ktet0/JL56pjNOIS5pnNBvxVpcsh31Qu3xapeBzGFoTEISM/pHYsQTFaQoQbVT+Qxy
         2OkXLja5wYqYlHJtJACN0T9MhfQgSud9VbR72EDDVSPuhA0iDjLt76EQsETE1mhalAew
         g/B3MG3GVuC0xwaWUPNLQAyBv7Jem+9TASfhPyBwImpl6VGi+EUxZCWKYV6GYH75yXsS
         M11A==
X-Forwarded-Encrypted: i=1; AJvYcCUVHh+8qh8cBxLb0VwDYKygj+oDwaaU2iwE+/SAaj4I/dVjvY9WNjPmXF3z/1j/qOIEAAGqEM6TZg==@kvack.org
X-Gm-Message-State: AOJu0YzuwAxfr1CQK+/vfeC2YQKSTDZ+R0HSo6UK1XNJGkNgI/SWx+e0
	NIovjr7kmU9BFa0JGW/sgwMvqoJQNMejONsRZjPzknThv0/mCy+lUcTr
X-Gm-Gg: ATEYQzw4eIXuUwaGcj0d9gphCzNd9w6Wwuf96ToIcKgzCvR1xO9eAOLzFKk0BFjd1uC
	GRJZtNGPkiuq+BUIkVonHTF3Fmw8vNk1hZ8uUySQWmUgHUXoE2qTRIGTMCJzEPkHSJyMk51yksY
	j+5Q2CpiKfxXXxscnLEjdbUY6gr8yklzLwtGB5euJQzKhguYlLq97oml0VjrRhYmwVBRmRvcoUI
	73mDmLTuEQMMKsSyunWhczI1eNSSDTMfVY2xmNbmeQj0B6dJhAijHsZmAKHMjh8w+EHWU0PVwwB
	ycnRyJosuN+9jkgptq9n7t0NVW7C7UQva/ND6EJuo/Z4LNl0HoQObzBnrt/0ba0kZ6Ojhx9D6w1
	qcoielHNQiQbJ6ZN965Qoc7LLFO5zWSnyFMrq7XUWWaw5PnM1HMIBZG05asue9iIVasEmuH2Afy
	+y3qnUA+DTE6gctCKJXrMJQS1DvJJbYYTH7mc1NXvvsOwab6ni/6/zawiuCw4o2tKCglCV5B1wi
	67vc3w4/pP8EJHXNBltFXQ=
X-Received: by 2002:a05:600c:4e15:b0:485:35ee:f836 with SMTP id 5b1f17b1804b1-48727d5a191mr239440995e9.2.1774902553673;
        Mon, 30 Mar 2026 13:29:13 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722be608bsm456579915e9.0.2026.03.30.13.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 13:29:13 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v2] mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
Date: Mon, 30 Mar 2026 21:29:09 +0100
Message-ID: <20260330202909.136776-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 67EAD1C0006
X-Stat-Signature: q8rx7ufeq37mq8ojq96gqzhuxugbmxsp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774902555-522492
X-HE-Meta: U2FsdGVkX19HuPKoyHnAcUAs9pgnO/GFse0TadWS+F/O7Ca4mOfoEiAJr70qWRsloYxDFeYhcxSCjRzd7PXtLt8H5O2vQrYVU1od6sD54fPyB/+eaCUt6mvvLoCwpr4IAi0qhGy5J/+npuf3Vx+VaG2Xoz5NY+SIeGJyV/9Zg1jAiwG8idNqxspOuNMbe53AnoGLxnZ4hpdVTJeqxYVK5GlXRQcFzg9hycFQkxP/x4Lv8bTaUFYq0d5oFcJwjmh29Pft3QoT4e07oohZNbRWIfE7Ay7QVCi8nc/HArYRdbPiTEcf2jtFQQmbSIYBbBXjVaVMdArlYwUQns0OOjyvy02HwBbbpwy/D9DsdUVmsh+7AXOrrWA7EvwdMmbHcZJEzXtcxWKye1G5ERDHoq9isjYWhjvjToWvv08qK//0l6Im5AcCRfsEqEJCSU0yDaxIaYTUmyMYApwaYKvllXM3zSbBCvXPxbJPpo9fyjFhqbddCpm+xoqUN02qwGDZt34+sGSqlpBywcIq0usO7a70neZkJVHEjrZFm8agjcVb1cR8StcQ4luf8TTHlBQN23zGWpcOKPfFugtrH4dNpxZZe2/JIDgzAonLaFGf7rWZXms3uFiFUcOz1++rp0jfXqR0OQc/6SRn3sMvur6IlZiU0B57aq7zn2rNcTEXbSAF9ZFMEMIwVLreKR/MZ7tkVgMmytrtVYJSq2JGVEkIhkOhgrgB/C2IjMef1iFvtH7hEY212lPD3lXsvTTZDmBrj+Cy1yWCvHQ2mow3Zq1VKyHdlm9wFF1lb7wdO8Na0Id2I3bWHi/JKeq3KCrIGQxy572DnaRGFOXfAX+GPtJvlGzVYaLummkfUUuoPbh+UL0GIS1+LdIM96Q7zInOKSXf0ZoLykS//h0VJpNLzZ2WhbWcveSSgvju2pxgtsFKaLVrXSv0GAKkCUAAyUPNZdqn9sPRLW3GXGq15Ry9tqydYaR
 9WcSohVg
 eL1hpHvzHU1vaEnNDs4NKeXi4ptkyAJbo/oAWPYnoauv3v0u5GQy1mIFQvVu0+XHz/I/Av2P2iV1JDhZ/HfDI92x2I/sg2br17qZdTv350viXX6NDxUTPcsSEIEcVbWhVa/rIECNkv2tvwiZUiwKa4YK6+lXLAKAr+KTPMYzOD1y3071aqbmiBpn43JAGYucGf4arEoj4PBpIE81XOWswqy+w+4AnLURL9vkz/IbB/Or0HEWi29A8WGBcP9bvJ+beEKL/4Xbgf0zn9SCnrxnzgDglGkNBj8dQuhYmR8JGeYcev/iV4E+XIdlPQVuOQ4qD2KjdNJSSd9szwS7V9XmHDR4Svh75LTz/RUuVrgrG0ei6SJd8EXS+RP6TkGzIhXSFQqfnEHs3ViGVycgkjnwfBtCAIkS4CY6teXn/hoEUg6RVhV7LPGMrGCwL2Jo04dGcoqD+xSKJG0llZlN09Hlfrh4Wx0Ur1A6LEEo61ENFf+ahjVcxbK6dbLKorWoSV9Jp6UvX3I6ctpLrvDtt3k4lH9Bq/euxFx0fEUI9fNfLnGIvS0TuAvXmBkkXeUoHK1hzZ1D8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_copy_folio_retry(), all locks are dropped to retry
copy_from_user() with page faults enabled. During this window, the VMA
can be replaced entirely (e.g. munmap + mmap + UFFDIO_REGISTER by
another thread), but the caller proceeds with a folio allocated from the
original VMA's backing store.

Checking ops alone is insufficient: the replacement VMA could be the
same type (e.g. shmem -> shmem) with identical flags but a different
backing inode. Take a snapshot of the VMA's inode and flags before
dropping locks, and compare after re-acquiring them. If anything
changed, bail out with -EAGAIN.

Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 64 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..22e82f953eb5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,33 +443,83 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+struct vma_snapshot {
+	struct inode *inode;
+	vm_flags_t flags;
+};
+
+static void vma_snapshot_take(struct vm_area_struct *vma,
+			      struct vma_snapshot *s)
+{
+	s->flags = vma->vm_flags;
+	if (vma->vm_file) {
+		s->inode = vma->vm_file->f_inode;
+		ihold(s->inode);
+	} else {
+		s->inode = NULL;
+	}
+}
+
+static bool vma_snapshot_changed(struct vm_area_struct *vma,
+				 struct vma_snapshot *s)
+{
+	if (s->flags != vma->vm_flags)
+		return true;
+
+	if (s->inode && vma->vm_file->f_inode != s->inode)
+		return true;
+
+	if (!s->inode && !vma_is_anonymous(vma))
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_release(struct vma_snapshot *s)
+{
+	if (s->inode) {
+		iput(s->inode);
+		s->inode = NULL;
+	}
+}
+
 static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
+	struct vma_snapshot s;
 	void *kaddr;
 	int err;
 
+	/* Take a quick snapshot of the current vma */
+	vma_snapshot_take(state->vma, &s);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
 	kunmap_local(kaddr);
-	if (unlikely(err))
-		return -EFAULT;
+	if (unlikely(err)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
 	err = mfill_get_vma(state);
 	if (err)
-		return err;
+		goto out;
 
-	err = mfill_establish_pmd(state);
-	if (err)
-		return err;
+	if (vma_snapshot_changed(state->vma, &s)) {
+		err = -EAGAIN;
+		goto out;
+	}
 
-	return 0;
+	err = mfill_establish_pmd(state);
+out:
+	vma_snapshot_release(&s);
+	return err;
 }
 
 static int __mfill_atomic_pte(struct mfill_state *state,
-- 
2.53.0


