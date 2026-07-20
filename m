Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75B0C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F1B6B0088; Sun, 19 Jul 2026 23:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF6E6B008A; Sun, 19 Jul 2026 23:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA2C6B008C; Sun, 19 Jul 2026 23:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 416D46B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:19:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB040160389
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:19:35 +0000 (UTC)
X-FDA: 85007699910.29.6C34D81
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09239140009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:19:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gsPGGQjS;
	spf=pass (imf09.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784517574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v2IFBQgGLhV/2VZq8Hcmtgn4n+KDnEkgWAqmJMMgNfY=;
	b=iK7CX0URt78XGWI2zN0gwJm9oZKGpm0reqeGJSIJpM3X9tb0GOuT0HHVpL+sjZOGsK3snw
	b1TRrIiAvaYOx7rlWsW7pATJWvLmYa01ZAnfnPnYhCYTb2X3dzGSb35Vx9y42rdU12RDX8
	xcaZ+QqFl5A+4uaJjnaW3Mtx4aen2Hg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gsPGGQjS;
	spf=pass (imf09.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784517574;
	b=n4r6H4ynMDCZ1hD6IZT9rNz2AI8Fq0hpzQWj5RfcdrXrkZGfuo/PcOEJJu5rtunQQK6fQk
	rx1yOu7aTyADOqBvWuGgWXUaClG+EDP/TlS+gZpJvAQ8rQo3q8AIlvb44B39FV3cyrFfy7
	mgI4IfgHO2Hgx43+uf6xT0ZhkM5vBF4=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c95d0a54ea5so7064107a12.0
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784517573; x=1785122373; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2IFBQgGLhV/2VZq8Hcmtgn4n+KDnEkgWAqmJMMgNfY=;
        b=gsPGGQjST409XaTstYPTsX5wHBk4ksNAEjmGehdMw1rLw4W2mzkpdODJB2+K8BT8ur
         NserOVQva5wxyWp0SHP9vg2HrzPfu6aKpiTXdvSnhq6K11bvx2YSmYn3DrnHYwVjBiKI
         EWXHJYER0swzHvVGRjZ/9ZMwyPqG6jt0NbX9DULn/N1fmIWFd/SUVIdA86itiSRKq7Ce
         VWKZBv/GBIiepZAJl369KE1oLTyoFWPI+AhAPnd9dGNJaPtgWPblgjUrYChxU+GclRuZ
         oMO9ZSDfg0h5eGKVBRolqNcsqsylAca0bYn0CXWVmUxI8JrfXVlCFUZHiECCJ6jReF0m
         67ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784517573; x=1785122373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v2IFBQgGLhV/2VZq8Hcmtgn4n+KDnEkgWAqmJMMgNfY=;
        b=hzv+5RTwMSD8TczbQ/EwcNeJYy6n9+GDZynFUA+uIHCWFnIg9WgEy08mjKnf1xj0/P
         oGJ3c20OcQLWuIi8L6lZ8d2rM7iF6Stbwza/A2pKHz/MjKdJ6Q9nlpA5nm5xTf8xaDK7
         fAmoZ94T06CUWj2B0IcCT5FGnuXjB6CI8Bqs+9Oj3TQCE+X3nicpni3QoL83gjFRimSA
         YaVc+f1Gy7TWb0fci4SwiDcE6cEyI/elhTBejWoJmI1/tYSLG+Vh2Suod8R5gu4jRoza
         C18xm5/URh6LVLTHDwQJMs1/0pDUhcD4AncilEEZKzD479RpNv+DuWtEVaZIV7wVMuGr
         ut+w==
X-Forwarded-Encrypted: i=1; AHgh+RpU65/l9//phcAR7kAJ/hnUgPU0msi/lkGkHek3xJaoJImBbY/q9DC9IydgGGGxAKls0RF62iNUHg==@kvack.org
X-Gm-Message-State: AOJu0YyEOMuzWob92o9fXX7xQNamWZzJcmd9D+BPUeTOWPdQWYL2f32W
	pTAKvHqkpdNY2K3qJXHo7/ei0n3RLx60DgTjnMaWwF6awAi/2wvpMY6G
X-Gm-Gg: AfdE7cmIU4U0dS6tlGAtsBgreFy6HYk6/4FftI98Sp1hMttmet8D1L26Dy7YDhyfcZd
	Z1ltRHZEBwwI/2EnqY3Ork9zhpKnGGGiVKk971jX9c9AFwb3SPbq0jo0aV704OeAR6n2fFMAD0O
	a5gwjaiM+s4V3qeLuBz84rU1ulIMZQwIWRjS9Q6Q18hr9NiUZpDqSwEBx6rBsGwGdQB5bXEzWjx
	EyP9BmYZdvIkdwLigqvrsMnngwj2Ui6Txld5xvtssw7q5hDfH6X8Kk0ph6ToFjy8jTnivoEeH7a
	k/bPUzqx++2Tkbs+ooM0rCobtC3cQP5c44c4aJvaUgfuHBJr1zSfGS9vjTIIuiLndLCthRGWLT0
	Y5jhDaiGjADIixrIf2O8VOVkEgHr6FIObJt/PQeU7sIULBrIMkL5TVHnsGyqkwLYmdHMr1cGOGv
	zZSD5UeXDHByMYS+KC
X-Received: by 2002:a05:6a21:114c:b0:3c3:8f3d:832f with SMTP id adf61e73a8af0-3c3ad9620f6mr12983309637.49.1784517572647;
        Sun, 19 Jul 2026 20:19:32 -0700 (PDT)
Received: from localhost.localdomain ([221.227.131.254])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb517aada63sm3827465a12.3.2026.07.19.20.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 20:19:32 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	baohua@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [RFC PATCH] mm: madvise: use per_vma lock for MADV_COLD/PAGEOUT
Date: Mon, 20 Jul 2026 11:19:01 +0800
Message-ID: <20260720031901.1724737-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09239140009
X-Stat-Signature: tbu55zteupo5u3abj1nama95ynzpqoqe
X-HE-Tag: 1784517573-702579
X-HE-Meta: U2FsdGVkX18J/b+/L6mBQShvT/7yHH3d+GEJ7VHB64sz/68evg7IoHqMiS8od81OuwWgZJlq/g6PmF7yGt39oUpjls/KTO0SISpmbaUT4tzQTiT99tuMu20dfUY71zs2/thzdF7TkNSQtcK5dDA9Nnlnpo8a8lNp2dwGbFdN3zy2TBoe3QAhWogCIMFIApqjtBCQzxK7I45H1gchPNzg6rrzpnqBhwyxTr0tEQXsBgg8NOCLy+QIFf0dXN01JaeR7sxfOSSt4h1kuuDbVevxqfUcenxng88I46ozVmHuMNDdHJh4YFzAUIHJ6xrf65bSA0w6YCOTnv0eIvtJBjBtpfUowQrzm3hLhTEybIVrYKP/7o90/zwJcVPtmwi+xiTxADTdsQP/O9DhS1Vp2neQ09JkSANAUjcrUUmBNx4BhfIUiv9HZIQZFdjeuoVTcAC89bqfdr4QYY3boYLx7Xc7sqWiBTf9gWGJEUBD4txeePETryuvLvhWLVHzTTsSdxaIUr7dfUk9VDlzdlTOg3ntVYIGxDzFfDhEmybWOrzp/DWAwEl3wVtbXwZK5E5XCsFl1q9tUXZNEIQpqaJ+e8PJpoUQDXfYGw6/MUcqB14Eo8txIN1WLVlxxTZ7uh5va0tYdXH5ckfaVilNCjE2R2OCIknTlJlTaXfGvwBetbp42Cr+LETHZ1DHadEdo1Q0hrfUTzl4y3CeMycd3r+w/JnCBQqZlE0mKfq0icUovX/icnkiMgqhY2t75IpBbzHcvGLRItPysskLeU0DiVFno2JJ6m1pM3rCWmgAKX3izeVOUzLv9zGZVTFWyFrDv5scedgT5tvgYUGu1eDLWn2l6WTSEHzAQSRltUvzPf+jGoBGiL71kcsw7R4nN8F19gHYwDoblD7cti+gXxOGNBtijqm/MEICBmc2KcUEA93j2JsGUE0bECqqwCEZCMdXLSyrVIU5Bxkc8+4gNQARQPV+k0W
 Ot5UcdRL
 vgbqCCfKGgZVbzq7DEF7e+VPmcJ5X3/TiEXStHeiYgNAP3XRODAFuedQvTEA5OgytrpER9WYvHXpgXdfj+G+jOoauVIUkyDYZW9/h0I7vnm3gDHaH4Wa+xtf+Nov6ycd27PjLCxyKscNhVQUpgFFz9q7rSwWPxPwlkxeUHjw11YF10Wq+xKqzCs2l1L9PGACNcUNrG+H0r0azTEa8CUYw/jSsGMAw53mYevlkkGXlOtcP+57k3fkiwxlS8S47MiHPGS4G24aZ1EUsvQSzxpq6dp4YdWMF8PBDP9sUykSxYwvz7FHE1AZ5EPXmONBp/xo+HEgsKDjrZTuoVDCyLDoBEn+fzy3nLj+hXVDXcfFTecH1TQeGMWipL+VGtcNdESleZdpwnUtBC1KIPUScmKO+n1e/iFbyWSRH3nZbFCEjgp6lqMFY+ZcMrDMEYcG1Z9Md403CVEu8/PBcS1OEYredU+6WeepeshfGXOV+xRC+XOrJezwU0RNfKpTQWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

MADV_COLD and MADV_PAGEOUT hold the mmap_lock read lock while walking
the target range. When a concurrent mmap_lock write lock is held,
MADV_COLD/PAGEOUT must wait and execute serially, even for unrelated
VMAs.

MADV_FREE/DONTNEED have already achieved this goal using the per_vma
read lock. With only simple modifications, MADV_COLD/PAGEOUT can also
use the per_vma read lock to replace the mmap_lock read lock.

Start 16 threads running mmap/unmap on separate VMAs, and benchmark the
time taken by 10,000 madvise(MADV_COLD/PAGEOUT) calls on another VMA[1].

                before    after
MADV_COLD        8.09 s   0.07 s
MADV_PAGEOUT    11.68 s   0.40 s

[1] https://github.com/vernon2gh/app_and_module/blob/main/madvise/app.c

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/madvise.c | 52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072c..795a8a6fb237 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -566,10 +566,19 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 	return 0;
 }
 
-static const struct mm_walk_ops cold_walk_ops = {
-	.pmd_entry = madvise_cold_or_pageout_pte_range,
-	.walk_lock = PGWALK_RDLOCK,
-};
+static inline enum page_walk_lock get_walk_lock(enum madvise_lock_mode mode)
+{
+	switch (mode) {
+	case MADVISE_VMA_READ_LOCK:
+		return PGWALK_VMA_RDLOCK_VERIFY;
+	case MADVISE_MMAP_READ_LOCK:
+		return PGWALK_RDLOCK;
+	default:
+		/* Other modes don't require fixing up the walk_lock */
+		WARN_ON_ONCE(1);
+		return PGWALK_RDLOCK;
+	}
+}
 
 static void madvise_cold_page_range(struct mmu_gather *tlb,
 		struct madvise_behavior *madv_behavior)
@@ -577,13 +586,17 @@ static void madvise_cold_page_range(struct mmu_gather *tlb,
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = madvise_cold_or_pageout_pte_range,
+	};
 	struct madvise_walk_private walk_private = {
 		.pageout = false,
 		.tlb = tlb,
 	};
 
+	walk_ops.walk_lock = get_walk_lock(madv_behavior->lock_mode);
 	tlb_start_vma(tlb, vma);
-	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
+	walk_page_range_vma(vma, range->start, range->end, &walk_ops,
 			&walk_private);
 	tlb_end_vma(tlb, vma);
 }
@@ -611,15 +624,20 @@ static long madvise_cold(struct madvise_behavior *madv_behavior)
 
 static void madvise_pageout_page_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma,
-		struct madvise_behavior_range *range)
+		struct madvise_behavior *madv_behavior)
 {
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = madvise_cold_or_pageout_pte_range,
+	};
 	struct madvise_walk_private walk_private = {
 		.pageout = true,
 		.tlb = tlb,
 	};
 
+	walk_ops.walk_lock = get_walk_lock(madv_behavior->lock_mode);
 	tlb_start_vma(tlb, vma);
-	walk_page_range_vma(vma, range->start, range->end, &cold_walk_ops,
+	walk_page_range_vma(vma, range->start, range->end, &walk_ops,
 			    &walk_private);
 	tlb_end_vma(tlb, vma);
 }
@@ -644,7 +662,7 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 
 	lru_add_drain();
 	tlb_gather_mmu(&tlb, madv_behavior->mm);
-	madvise_pageout_page_range(&tlb, vma, &madv_behavior->range);
+	madvise_pageout_page_range(&tlb, vma, madv_behavior);
 	tlb_finish_mmu(&tlb);
 
 	return 0;
@@ -783,20 +801,6 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-static inline enum page_walk_lock get_walk_lock(enum madvise_lock_mode mode)
-{
-	switch (mode) {
-	case MADVISE_VMA_READ_LOCK:
-		return PGWALK_VMA_RDLOCK_VERIFY;
-	case MADVISE_MMAP_READ_LOCK:
-		return PGWALK_RDLOCK;
-	default:
-		/* Other modes don't require fixing up the walk_lock */
-		WARN_ON_ONCE(1);
-		return PGWALK_RDLOCK;
-	}
-}
-
 static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
@@ -1748,8 +1752,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	switch (madv_behavior->behavior) {
 	case MADV_REMOVE:
 	case MADV_WILLNEED:
-	case MADV_COLD:
-	case MADV_PAGEOUT:
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
@@ -1759,6 +1761,8 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
+	case MADV_COLD:
+	case MADV_PAGEOUT:
 		return MADVISE_VMA_READ_LOCK;
 	default:
 		return MADVISE_MMAP_WRITE_LOCK;
-- 
2.53.0


