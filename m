Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35F4CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C34A86B0088; Sun, 18 Oct 2026 08:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A506B009D; Sun, 18 Oct 2026 08:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47666B009E; Sun, 18 Oct 2026 08:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAA26B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:32:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10D651C3B40
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:32:31 +0000 (UTC)
X-FDA: 85335685302.05.3A31202
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 557B81A000B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:32:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=owJbsEyP;
	spf=pass (imf19.hostedemail.com: domain of samarth.colleges@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FHebQQxZTBF8VhHuKubJ7Ol2fYKgzc9t878DoxD9tRs=;
	b=7i94iaC+m1Hu0et9yLftIChIBA9tNFs4EBmvYDG30Dw5LBjSFWqWl4C5VOeEaXKDfSijZp
	T+iWOaqCSSJ+zgHGth2ZB9N3UJAqQK9ajLGDFzy66l35c0q8SgFC0GMu+54aonSTX+esAE
	7ZaGdy+UxkmTqfrAdoTrdxhKyaUsHXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326749;
	b=q55ygr5lGA93mi5CtFB/KAb05KD+Bvq2970JEGjVsBqpz0gW5MRQGqpq1y8YbICmo3VNUn
	spgSGEQO80dqZo4inZigfxbH6uBi6hrztXIaLuJZehq3sSctdiR+sNuuV9B1MoAOZvJu+8
	eISeOrg9UmxeyHqOn1SQvVcBQwVuGbk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=owJbsEyP;
	spf=pass (imf19.hostedemail.com: domain of samarth.colleges@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33fb4680717so1351475eec.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 05:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792326748; x=1792931548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHebQQxZTBF8VhHuKubJ7Ol2fYKgzc9t878DoxD9tRs=;
        b=owJbsEyPod5VVvgiJ+SYw5WGMY+EbdT8oDVwtTZjyRiAUVeQdrs75t3yMBwZ98bPSf
         1pEIdp4YbAUCRLHjIyfSMMLOW8hPAFKSJCPMF59SsMEMEXBCibq2q95CKTUKyGOcwTf+
         mrWTUGZebMKYRebb7ud+7CIXz1w/qPCi344xLy0XKd8gu8k08o0OQcNyqQAz0g/qOuoM
         p2+yQxUeccsJ1jiSPBnOoBwdEtoZGueJrznUjHVbQUurFxcbPiIzZDmhX/rgSBRN3P/u
         4OLV5hgkrg5Ao0ag7nK9lQctYMPr79kIkCTVxmqx8X1pUI3p1z3tvxl3NgEsQxUP0Och
         KeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792326748; x=1792931548;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHebQQxZTBF8VhHuKubJ7Ol2fYKgzc9t878DoxD9tRs=;
        b=JmoD9MGCp5zC1EWMpeOtkx1bXowB1h8vvK6VIDlz6+zb94zkBP5kYj90AUQ7pklG8G
         RH139gmjRPfyUwgRHXhyrJV7rqatRZQIRZ+pZxGQs0hX7zJ3Oz6qovsaGf6PMhoQgUBf
         tAKy8QdEoKKWIKla0HUGkDfgyvRKX4mPjRYttI8blaGjjGTyPkmOhZUb0grIn0rfVSeO
         D9J5XvtpIjN3epwlzOj4AfBc2mxxikxvbD6VUHHVW2+MNw/jbeBwNS9XT+D+my1lNgW2
         4zPhI0oNHUpKcT4tE7tlBQ43Jt34wJFqRYaSOQR6iULfPzbJDvbMAzEpPjFaUOZ7P56c
         zagg==
X-Forwarded-Encrypted: i=1; AKwUvByrdx1thngwJiwWcBJWeos096CvWUa5dElL8YksXY+c6IOyISyiIs08C7PduyidS7xT/hM+aLu+4Q==@kvack.org
X-Gm-Message-State: AFq9FYLcx9ZSW2I+CfbTav4CvFnupdk8eSzuL/A7+yPXtUxdqpZ1DSw2
	Y0Ho6SlkRxGaR1JU3aKbsr/BE98/NbxfB02Z2jUuMvhS6NJ8c4bsFLra
X-Gm-Gg: AYBFou3vH5UYkYyn0+799ooJmij3bYNiFD4ueYjRrdL4LgurL++wO6sTRIo5Wk5ZUrc
	jbM+FE/GUGeDx44r4oLt4JKlPuZCbeyTyG8kuyxEUdnYWnU9FgJaR3zXqJlsAFPd7StadKH630f
	L5SS1lYFEjoIX0ObbHsMSl9DV0vFYpRf5yc4zrfxhYK/pKLcjMElSxVSZ4MoPGFOQ5lCNIqMYm2
	oEhc7+63no7lb/9s+euiQdfpC6097kTnNidR1ATLuBTRVitS1BE/hkw+tCguL1sZmusQtqDSO07
	wwiRGPeIIrjsr7poT+Nd2qa5LMDszQ6hrCsY7uZaIC5iYqnsktGaDujgVWR9SsEwcJD9iMwEALW
	0Kgrv0oe+ouS1dQMF0WfG+T6kpyGJUu0CNpbqOBRgqkvtKOcc9pxh1s954UuYWtIKsF4H2MhVO8
	OEWHJ96lNi3RA2WSuAjrh92vGefSGkAd/J5AgU4UyxvseVzPDY/UJbtHDl/mJvnlNt5yhh63Yzo
	mxxtA1wrhR0Jr0L66Ouzb5sGqdJUOEXd1HY8Qy1r/GL9Up7eyjjMNDQ
X-Received: by 2002:a05:7022:294:20b0:189:f7f6:38f3 with SMTP id a92af1059eb24-189f7f63acemr518737c88.13.1792326747918;
        Sun, 18 Oct 2026 05:32:27 -0700 (PDT)
Received: from 1u1g-b650-0212.nvidia.com ([72.25.70.131])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831ba424a6sm20953055c88.17.2026.10.18.05.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 05:32:27 -0700 (PDT)
From: Samarth Narang <samarth.colleges@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Date: Sun, 18 Oct 2026 05:29:56 -0700
Message-ID: <20261018122957.526467-1-samarth.colleges@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 557B81A000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 9rjdgrayantuz8kz6m845fmrhdz8yjbd
X-HE-Tag: 1792326749-444471
X-HE-Meta: U2FsdGVkX18VoEf3Mp3jPJ5Fe66t0IK76PztdDOOAXmWS6cqYmJGLo8hZilrKesq5l+Y6fYC5PzNjweQfGAf6b9cmwj9XFlwOP3bQDTN9X0Yjxn4/QtB9DTO7De7zl1Xf6O66D5+XZggi7YXk8TkS0gPqc9cVMFycEjzI+WBNfPCV5BrfkNOJpIzu6Kb/YYgI+v4pP3jN1ELoSvYtJTylMYoNfiTI1KXLxZsApSS5cbgZwmMn5Yc1B51lfhVgI5ew8nSAt+A4wNiVxlo45YyS49zYvfJy3/06MbZnEbpJQRAfOu9Ekt9z3wVkkLFCUGFLfwZxr20ARaR/QK6aNzvqDpchYf35BfoFnTfSPFzn5YZS8UJRTFpDkCU/ATYgZQVGECGnKCgNZRxy/pO+kAWqrqM7z3RvBkOst4xtY6KW9QA+8jVyTmwZV8d+UTy7WXj28ibZsHLi90zyunkhiq2RnbcA1dqLy5aZx7pqmO2C3JuScmUNUoej9YeLUNWYgdzVFeDEIflONeFFmKxweXGJSw1VOsjSi+micCTbPLpEbyUJy6M3/c0mJBroBq6DKeFvV9SUMMnd479iWckVGP7eIN7ltjEX0MFnhpkQRVIqYq1XUhPbg/Z3RMBirXKJKARzDF1azA82FV+xYeLfe233ZUXSPVtbF6o3PXi/IDRZVehn8FUIXQJZgl8IXFHKdnQhfFwxRuuOrdUziDwYNnnWg4oxquj3kFmk1D8HzOvm3HLHIGb16Wjo7/faQ0aK11HFTmfIxam+R7Zi1h8dGiUOYFB688JMS0QYXRhAq7ymn3II+LMYKfFUjGlkQe+ku1ll4LDhAvyfqd/Rrzvh29q4B6/ATUKurU9R50t9IG4/Mv/9qvlhL0StmCV0Q/7StCp/4bu0is7IlYoaymyKSzznRadlC4ylBo1OZoxQfhwpQKShn71Q6KV/dZPOThoIwsZZnGBAB6xDvH76zGiagd
 lCRIiUkp
 47JS1VbdeVZ7FP9hD8eQCBqXe2Nl/p2/XCHuW/jDo4v6yLJblL2sktZJCMsp2/WL+bJ/tpdZbWuMxPRXngoQv6iQgF6rhDQewcTjLuFsIiQI67OzzC8gFsA0dc1QPPkEN7mO2+1sgjvNOVkCBWKeHW6xd4CG1uFYZG+3czCrsS5k6cFa4U94J7gHB4/6Cp4q3yK1o3TrFzQheexMGWVm+H3JXOKFWn9lQOrez/7Nxr7VQCr/gx1/pgF0vYFk79YzKZ/wqbt4UYVkHRWuAdYIRykZ9TkejZp2wXaKKjT3po8gyiQpNYnst13agHjy1rIbcMalKHDe5esgQs0od5drGZhPNiibqOCAD0irr41TeoNiERj9+GYUW80apJuwzIUjbtcihUDYKCEbEf/nnHMx3H0nKi60lifrmad1YsVstOvRvm4lRt+geO0o0VtTcOKqg6sCjotVjdladC2XVqeYe5au0nMYi4lrIw53XHlz1ikLKqzxDFU30k5oRmr3QOkiyEHgq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
write before the merge no longer shows as soft-dirty, the next write to
a uffd-wp page raises no write-protect fault, and because the page is
mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
access raises no RWP fault.

Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
does.

Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
---
 mm/ksm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..b0d0555aa1b5 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/ksm.h>
 #include <linux/hashtable.h>
 #include <linux/freezer.h>
@@ -1463,6 +1464,18 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/*
+	 * The old PTE may carry soft-dirty and uffd-wp state that tracks writes
+	 * to this address. Make sure to preserve these bits in the new PTE.
+	 * On a uffd-rwp VMA, also restore PAGE_NONE.
+	 */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_uffd(orig_pte))
+		newpte = pte_mkuffd(newpte);
+	if (pte_uffd(orig_pte) && userfaultfd_rwp(vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another

base-commit: 48fe11c8d0f1e4e59426a3606f20ac1130b6d8dc
-- 
2.53.0


