Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63246C56201
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 14:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C70D6B0088; Fri, 20 Feb 2026 09:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374E36B0089; Fri, 20 Feb 2026 09:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256F16B008A; Fri, 20 Feb 2026 09:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDB256B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:49:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49E92896E5
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:49:48 +0000 (UTC)
X-FDA: 84465119256.24.5C265EB
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 811488000F
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:49:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pvCBdeQc;
	spf=pass (imf02.hostedemail.com: domain of 3iHSYaQYKCCcJOLGHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--glider.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iHSYaQYKCCcJOLGHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771598986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7l0Rk7sxPzClSemlodKxJT0xAUIi4Uh2P1WbS8uB91M=;
	b=Aefnf5PmnwDsonO1WDLy7MgxvYfMqIEx5apxLR5+bo1FiIGQ+/o5FBK2TZbuOBU107HnnY
	VwIceISwiKOAuVGFM/q3ijaKFpcA6lbbg+3GmcFmXXnbBAnBnmGFFKfKcX9PtX87OX+8Zg
	chtmOhP4v+AYWoK5+zpiRnNL3AYMLmY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pvCBdeQc;
	spf=pass (imf02.hostedemail.com: domain of 3iHSYaQYKCCcJOLGHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--glider.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3iHSYaQYKCCcJOLGHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--glider.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771598986; a=rsa-sha256;
	cv=none;
	b=Mz5Fn/LK9mMIYyZGcWyaTTG8AiThq1IVeCqHPDTMdklxrGuURBpauelqiL4o1zW9iF7BAH
	HUkv+EaeX7Q7vckXvOtXAY1ButqDCl6fM3Rg8/AEa6nlwwjxLx68GHXo6spIR4NCwWIBdS
	K1cOgKvSBWn8E/ls3xNNtngy+8ZfLME=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837cee2e9bso17294525e9.3
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771598985; x=1772203785; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7l0Rk7sxPzClSemlodKxJT0xAUIi4Uh2P1WbS8uB91M=;
        b=pvCBdeQcw5DoilTFbNnypcEd8R1ITwbFbooGS6Ne5mjDrP8ecQKMR+h7wt0zxCxA9U
         7srfn+jezW9EBM6xRJfEmmWBqe0r/9aSU8S8PXS+8kcvSZ02vQ+UIzlRsUH7DgVsFLLv
         4gZT71qNazab2ECykH8n7j/8+GKuX10NObU8hoQHVSOjRH4cddb6CP9SNx150W8J6pEq
         XnM/509U2oXuCciud2jkxlBS6B/LMzZ1yr1EOares4M+QVPNOJMXSManlEQ76pla3S3v
         +JGyj4i/8etezu1ePCQa7dJHGA5BHWaaW0DOm6aKxzz/kaaVTnZTdAKIDXmOC/3ZdcxM
         e/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771598985; x=1772203785;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7l0Rk7sxPzClSemlodKxJT0xAUIi4Uh2P1WbS8uB91M=;
        b=bxMnFk9ZqGu5R5NmHRygeN9pKNfs3+JMld5xZenQA1pR4r2evpP62ASJeLVe2yr/eS
         7lTARXANsygsOdcrdlZIkkqlpKXhefZTLmtBJ2QStv+/tKtseYXyeMhA288tIFEPaKIl
         /LTY1Q/a0PPEKd+zA2C/P15cQYHhoe6/ssUqFI5PaNssqjzWl/W0rnH0dgGxlwRVYSa8
         +W9TNm2DEnF+ui0qi2pcbiepXmOuUb6BUKb0nBsI8oXiqsGS8H/u1Xor7VYtAod6xSR1
         rJZuWVAHPksNUG+B9ultFJBWC5KoFRs3egmviRrUK2JMyxPEhsO8fMdiSlEGK8GXQNrb
         fHhw==
X-Forwarded-Encrypted: i=1; AJvYcCWcEUcsJ7VrIPKHSZv0imIRS795va/X3PCrmyiFJYJhEBKy5AFqltbKlIa8capUXUzxZrMxhPfNEQ==@kvack.org
X-Gm-Message-State: AOJu0YzK4bxwu5v47jl/NmaILXClAlkislCeRrdytDKIgS7+qNPvBidn
	gLmRlO4GdoWIGdwUEYVTm3GW8fHTUWCpxDzXpdZA+4x499GZcGpfbwQ8aKhdU34U2DPjZ4E0ckB
	FCJLXIg==
X-Received: from wmhn21.prod.google.com ([2002:a05:600c:3055:b0:483:6e28:c16f])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b2f:b0:47d:885d:d2ff
 with SMTP id 5b1f17b1804b1-48379c1faccmr309919275e9.29.1771598984385; Fri, 20
 Feb 2026 06:49:44 -0800 (PST)
Date: Fri, 20 Feb 2026 15:49:40 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260220144940.2779209-1-glider@google.com>
Subject: [PATCH v1] mm/kfence: fix KASAN hardware tag faults during late enablement
From: Alexander Potapenko <glider@google.com>
To: glider@google.com
Cc: akpm@linux-foundation.org, mark.rutland@arm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, pimyn@google.com, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 811488000F
X-Stat-Signature: ii4bj1xx6fzm6iqkk3o4ue9dmrg48zi8
X-Rspam-User: 
X-HE-Tag: 1771598986-298312
X-HE-Meta: U2FsdGVkX180yF+3NhniccQRvWfHB7m1BvI2PZXWGsYMMCe5lY1jkkFQMJVxAuexWJWg0O0H16ymqKel90+iVoEYHegJvIr7pCnSTzlii/6/AGq3f2iYZxvMU3IhacuPIGMqix+hyDMferqhoz6WWMAmLV5QIWd+h10GkKPl9NWwg9kS6luzjSS1r46O1AiP5pgr7iJHe1ie0jH0eeF43A5d6NViS9f8EMJ+aKhFp5BsZVSPXgVwIfgOax4tbcRb3r0dcgX/GXc4qTCBQMl0SHIfm5d4t2/kw5B46m42+df8cH/kyEBMp0cr6hEyzf/3nHDYQIqorN51nePWTScWY4t7X7pkLSpMDEB4v2DB7xPlcgykGyn7obTlIHg+9P/ipMmXRCxj3VTjJnHmwvpTkdKMUuimrQ6nQsRhkyUeeadJvjQZ8EYlFcrmDh1bMszFqXhlmsziLYg3a95xfjp98uqxDlnWEuUPAuKrGxZ/tcLRISq1gXkrH5eriOQfY52GHG2IkKwxSMv+5obE7S9YI5czzuRvuDR0ksaR5v7kZLGJ2Vw/QUEY3g74TYAXnwF8AVRByJ88QVJ3SbvWa4/EzFlo6rdfsU7DuiJ0ZDHLHC9ZK08laOImSXG7/RrJ8Y+LhuSGtnGm0ccLVlpA/8vHgWf1TYQZj2CUZZbyN0e59TKqPTXhjq8gotsLPZYTMRRXqtKKOWTvqVviyEMkh7lTXjOchLH5TFx+hi3hxH+Iv88HRp2lAaf9vVqh2Ja6+cTHlZaJq1bfEa2fcS4GCPeru0ifD+bL2H469MGtFkDtrm1C32Yfgf1xw8sPO0R+6IJ7xNUFMqMJ4ScBFWmTnSOYVw4GUsjnBcgAtAFTRl/cIGx1xXGiVoIptrhmP3HAEeDJXKAZRgSg5WRg+ktQ6HYQ00qaZ0mAULvsfDvziuWyFCRkUbkk7BV8IUmMQFR4L9KIBNz0pW7PLHVS478fYTu
 Y6M61XBM
 TqCAHrtfY6n+VmILEfwY0RBcAIVu8er41y517n5MWCVjML5bGTovpsEjDGUmUCrFgGn1wQXhkdXx0rhXanOiF9GA+JYXJm4H/HgpYt/di8jYPCSUHed358NI5kPWsimQah6N3FJY1GiZ4XDKc2QjGUG8qjUv6vFkofrgDtciwI3bAsA2RQj5lCgik/NsZfvzQ1+HskyMCY25KBjIV1rHBXSSwSyh2RJqVDtQKYcf14naAxCQSV3t8zvtCXPQnD8M18SC20lFmmeq3SzLIWIH44COaa9ZugNU9miUR3BLVJh5ZDZKdTYS3fAuU7ZL9z4oqWAeZsNrKn+qs9PND66DV2ToD+EekRQPmac6U0ZLllJRb/KG50v64wCSrXINQ6UaCl1Ti4yqNGjkwmt6LfRt2eDGiNTl10w+S5gnpe25w2iLFg5/z6dvmzDH4fF7/cUVfYlJpeBwj854FtgOPArHTmv91pz4VSEO+Clb5Euvi82ixSqF44Ei4Gc/facdoCz+YVwXuejXbVbF+x5NQbaoJTQaWPotgv2hiMw7kAr+5nHmNhHwYSYV86kgatJwt7grDAbfOgfIEuKFBZJVNFlZW5eazYEP6vljG1Fvd1xgmYP1TrRxQskM8jiN8hSTjSOmlegZgGvObdkBGordfEQrO86pgQi6K/ottg2Igv3TOeFFCE/k9GOwYULMJ+JwzrvRGGqunHop6C0ynFBZoDuJC1f+2IZ/em2ARmRUG2UOt7m6YC9WANr4ytT+/aezTDSb4cLcDCN20BZH1nUGqfM6niPwIVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KASAN hardware tags are enabled, re-enabling KFENCE late (via
/sys/module/kfence/parameters/sample_interval) causes KASAN faults.

This happens because the KFENCE pool and metadata are allocated via
the page allocator, which tags the memory, while KFENCE continues to
access it using untagged pointers during initialization.

Use __GFP_SKIP_KASAN for late KFENCE pool and metadata allocations to
ensure the memory remains untagged, consistent with early allocations
from memblock. To support this, add __GFP_SKIP_KASAN to the allowlist
in __alloc_contig_verify_gfp_mask().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Suggested-by: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Signed-off-by: Alexander Potapenko <glider@google.com>

---

This is a follow-up for
"mm/kfence: disable KFENCE upon KASAN HW tags enablement"
that is currently in mm-hotfixes-unstable
---
 mm/kfence/core.c | 14 ++++++++------
 mm/page_alloc.c  |  3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 71f87072baf9b..30959c97b881d 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -999,14 +999,14 @@ static int kfence_init_late(void)
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
 
-	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (!pages)
 		return -ENOMEM;
 
 	__kfence_pool = page_to_virt(pages);
-	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (pages)
 		kfence_metadata_init = page_to_virt(pages);
 #else
@@ -1016,11 +1016,13 @@ static int kfence_init_late(void)
 		return -EINVAL;
 	}
 
-	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
+	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE,
+					  GFP_KERNEL | __GFP_SKIP_KASAN);
 	if (!__kfence_pool)
 		return -ENOMEM;
 
-	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
+	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE,
+						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
 	if (!kfence_metadata_init)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2c..9d1887e3d4074 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6921,7 +6921,8 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 {
 	const gfp_t reclaim_mask = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
 	const gfp_t action_mask = __GFP_COMP | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
-				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO;
+				  __GFP_ZERO | __GFP_ZEROTAGS | __GFP_SKIP_ZERO |
+				  __GFP_SKIP_KASAN;
 	const gfp_t cc_action_mask = __GFP_RETRY_MAYFAIL | __GFP_NOWARN;
 
 	/*
-- 
2.53.0.345.g96ddfc5eaa-goog


