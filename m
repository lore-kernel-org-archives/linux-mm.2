Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BAE109B467
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 13:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792ED6B0096; Tue, 31 Mar 2026 09:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7430A6B0098; Tue, 31 Mar 2026 09:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631F26B0099; Tue, 31 Mar 2026 09:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2E56B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:42:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C83251401D0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:42:04 +0000 (UTC)
X-FDA: 84606471768.02.7EAE208
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0147B40009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:42:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aVYhPs1m;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774964523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0XBPyW/FQBiJPhH9zHfY1u4RgnH8XCesMBQUbga+4y4=;
	b=ROuViT6VDRZUmbOvw1/UMPLLcmoicSuz8Q06298IHHAM7MtVnCnk7zyyptx8AGmSSgeBMJ
	dFc/1zJwdFzmrfshi1mnNCkN7nB9dhSm5wVmbqK9DPICBl64xQeTSu+9/78Jpi9qF6DSLy
	kwjH9IbXtU1h6c79xnjVzsJ+0+LLAU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aVYhPs1m;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774964523; a=rsa-sha256;
	cv=none;
	b=CbQzAN5OtRNJDsBfj/d27nz7uft/TlxDkmdUtTR5yTaBeK1GKeL/KmMZ++d5SNqHpNexiQ
	EgOK6QvbhCzSCsiLrZYSreKUEUuR1ZtCGMnnXqf72XdiZ4pVHvs/MKimyt1zSgtG3oDgkJ
	DwUnbT77t3GankcKvk6V2FJ/ca3zWtw=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso47781825e9.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774964521; x=1775569321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0XBPyW/FQBiJPhH9zHfY1u4RgnH8XCesMBQUbga+4y4=;
        b=aVYhPs1mEa5XYBZjAtT5S5Qqni4azPw8cUIGFWe8QYMON8QVrIby2o25dukj57hLmm
         hJjunCRfyqBRA2L2HWh+v6xA/DK5iOQiMJYNUO5xLe8TazUj98l/iOidVOhs1rbMJ6zh
         +77qy1G3KTZNYJLdReVEiWSdFtrzdnIWKwLtuX9MrHJOzV8waoOsnbVyNwi5HyF6i8rR
         BejEq+j3DCD1HNdu5X+hqbPBuo6+HmwBn6QuRcWwxMCCIiyWyW4JlYd0/mRnmIc4wU9j
         KTITLqVa0c7yNqhl4wkLpAZASxPuxGkjvtV7cceg0eTpPXLlqSiqevqTSs/d9EI5S1OC
         oC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774964521; x=1775569321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0XBPyW/FQBiJPhH9zHfY1u4RgnH8XCesMBQUbga+4y4=;
        b=E51Hoj+6KOljP4/1q+7xweWoQppN4h8IxBIgz3LNxU3STX+xWj2vRC4KhHGjTebbrs
         i9bK95lUSfQrLm0UgLuapLP9URiMa1kVsBfrS1mv15xMUtTHGkNZ90ClNIcTqpHubJJj
         954St5q6uSMsyDVA8ZNyln6OQfKIKwNyRuoNfBB2vEfbDPFtmHeRP+ClajT0tUfknrhB
         326OJfKIqRZ/iygfrR98s5rCfCTznIqeeWrRJBAi+yXQLVXHUU3kpxj+TKOQf4AnezeN
         6rFscLwzQmipQ/4AJ22GaDPaJ9uYTU/FahBeiH4BMCSK+PsgBZLACiidEyWX8uXx87Rh
         6hQA==
X-Forwarded-Encrypted: i=1; AJvYcCXTqGn8U7YcmWz9LSbYxNdwIBHrcwZf7VAtWz6uFGyDjD5lmJDagb947kqum9wgWz3KP3abzo+nvg==@kvack.org
X-Gm-Message-State: AOJu0YyDSmj6oagd7F2V49wdFrJ9t8cljOmdnGhvPSwftKRYokvn9205
	l0/16MZmltISU+2S5cNfmwC0uzBI2EnkuOso6ASB6MS+48nU19IcOEUQAXEj5Cpn480=
X-Gm-Gg: ATEYQzzJIOoO17TXzGtqOFDtAWGONeFekISt8ISJWlJYijtpEVJen5O1qaNlW/c0DvL
	cOmsU4+STBusI3XxkQwEwsVNxdV6DyWbvBYjLr1U6KFQBpw3PoaA2W4p2mfzZOyteeSWb3Jyl7s
	J/isySEiaSyjk2a2RW7QiANCrwFyZHmV29PyJOEX5Aa1PeW/ghgQGAmALoX6y5AqXdc9w8OrVUl
	DUyzu1JDIWa46FTZrACOMERwH+NMHFQbtfJiJP3jDFCGuGJg1wVGzyHaaBmIM3oOqGkzh/e/rlL
	qGKS2NWRYygL5qB8ZOX0YWSlGGBhJqxFdEqaQ96KI2vMOaECcejAxXeJrxrG7hlungQLAiIJ6Gx
	huC2tTMt7Hjk8EXtwiP2Vs5vbF782OHNxJ9nY6hldE3G3H5TZb7HV3wDh5UmMOChscgkYQ7RcTE
	IsdX6HI++qZld6Vmk9/j4xW9q6VYYJOfJQFz3Qbom6rk+aYSfGErvCcD8GLX6sOz+hHFs7xQddB
	ECrOWRt5U0k
X-Received: by 2002:a05:600c:19cf:b0:487:1108:48bc with SMTP id 5b1f17b1804b1-48727ec7695mr285151835e9.17.1774964521150;
        Tue, 31 Mar 2026 06:42:01 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e822078sm46433505e9.9.2026.03.31.06.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 06:42:00 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy retry in mfill_copy_folio_retry()
Date: Tue, 31 Mar 2026 14:41:58 +0100
Message-ID: <20260331134158.622084-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0147B40009
X-Stat-Signature: z38wz19ktt6ax1875g4wr7sbpaaxfh9i
X-Rspamd-Server: rspam06
X-HE-Tag: 1774964522-18965
X-HE-Meta: U2FsdGVkX1+Rsb7cE4vox3dL0UvPEXnbEO0Ar7dQqR5B24BSY6ycKrSKyf4QCYST6j7IhisyQK8++aozC1K7938Js2X3a5B6Tm4XFK42zRNU5wk8Qk0JYKwO4p8uIU7HyoF6c0Rhhd/VA1Sh3ML5PWNN6ioI2h0DqIrA8NxTlyOUC4ooW8bGlfiOXvD19tb2G34pSIm9pwdVIInxyqMZ8+ajN/D7NyPTAAi/RO0k1OUxQcMz+2AdZWs5ZKNZPkHqg4b+y9jg4z8l0nxY0E3H5tnjJwYBzB5gJatTOXDoKtwip3y/IiU1Jo6kddaiCvOxr+4BNDkmF6ZDMkIOpq3hWuUo+t4DG20xtxdynaBv13SxNMCrX9SJ0QJ9VqHiN7DXFdt+PfUB35gNzVZwUlX/I9VFcHSBVkdL3B/irR2oUwZkI4xW4Eeqh0uQZiTN+UEN6ordJNLaU2BHJSSuWSkIPT2NlqrdQn1kOHUry7Nq/qcVHM9Sr1F/qDgrNDXLWENwuU1AF6O++jv6UmaW1p417kDx9h6dNa3NgGGAErA6sTCmje5geSKHCxckzxU5vLbGsA2K4C4yIRmnTFsqKGWB69P4f3Qx5gVaRYbpDzRLsfjCEe/qa0Lh+X7KGuhIaR7Qprwnu+eskaGuE8PX9QdctZ9L3OZwZUT0fsU7rzIMdZyOaNdOhJTrDgtGXNQuu8PDT+dRmPB0VJkFYX4vyRzNzFwpx9qRipVIxSHrhN7MOUXBG4C9UM7XBOjaQsA5kepp6IR4x6qYr4kziHo1thypA1M4Yb+gIVHvDCmbuSY8EzWVouIT1Tu/ji0Q9kJZF6h4lE7XZBAerUtdhkh5t7Sqm4mciHdYEE5l0/meuFLJ85j0CrdUftL1T4FciISz6NFQ7WGXiJCWgg9pRZZUKPHkFUwWWZXWC5XE2kIpUqv+40mQ6N/HCIlO2iuWZXPTSN9arGnIQg12Rg7FbL6Q8XG
 94Zh0eVs
 0ZHZQxmjJHuq4KlD4ZLotzxoNSvY2qg7bRMAJXvwHlfjcJU6jVokak3SDKZaLrnHLcp3iFxZ4S+XVkIKBpP2kDb+vxXKqCeJThx2XfjSqpxwZrLI5yaCV+cTVnPUZWon7QQLL2qHcSBM5i8NHjKfUo6sWNb6lh7pI+oeXZOHGs2wASYCVOMGA04dkg6mbPiEfQAgbH8fWggsMZwhwghbyEi+dPkzUEHGt2nluhEPCaxgHKZ16GJGp6uU4DhN0NxcuQ2248wuPngW4ATQoTceN4bMWErHuLQk1RHedsurn1dc8qmHuZBlpVyrXzA0d49ESTqWdBRQrXUurLM5iqaXAv0IhJEYX0RDQcVDVZtdSyb0Wgh+oPvNI47A4LUicTgieqm0bSv1F7KXca12ommiMGFI68L2m4rS/tYxDn3YaUMyvoDRnG9Ba0SclkP6Unn9rQGKMYiX8OvFX6wCwn5JUVWpQDJf4di3sHyem
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
backing inode. Take a snapshot of the VMA's file and flags before
dropping locks, and compare after re-acquiring them. If anything
changed, bail out with -EINVAL.

Use get_file()/fput() rather than ihold()/iput() to hold the file
reference across the lock-dropped window, avoiding potential deadlocks
from filesystem eviction under mmap_lock.

Fixes: 56a3706fd7f9 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/userfaultfd.c | 63 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 7 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb4442..93d6a954e659 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,33 +443,82 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+struct vma_snapshot {
+	struct file *file;
+	vma_flags_t flags;
+};
+
+static void vma_snapshot_take(struct vm_area_struct *vma,
+			      struct vma_snapshot *s)
+{
+	memcpy(&s->flags, &vma->flags, sizeof(s->flags));
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+	else
+		s->file = NULL;
+}
+
+static bool vma_snapshot_changed(struct vm_area_struct *vma,
+				 struct vma_snapshot *s)
+{
+	if (memcmp(&s->flags, &vma->flags, sizeof(s->flags)))
+		return true;
+
+	if (s->file && (!vma->vm_file ||
+	    vma->vm_file->f_inode != s->file->f_inode))
+		return true;
+
+	if (!s->file && !vma_is_anonymous(vma))
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_release(struct vma_snapshot *s)
+{
+	if (s->file) {
+		fput(s->file);
+		s->file = NULL;
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
+		err = -EINVAL;
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


