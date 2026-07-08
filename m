Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66906C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC79D6B00B4; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52886B00B7; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C384D6B00B4; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 945E76B00B4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 181EA1A062A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:41 +0000 (UTC)
X-FDA: 84964134402.30.D0B761D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6DA39120007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NVSfd1YD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqMjZmPsv3+liEaC57LQksKr8l/QZSzOSPi/lkAXRvo=;
	b=s5E4XgxvSfoyJmepmfMtVkHn+7ISNe64L7WQcs+7Tt4qyqIvykeiW3WXhP2zl0pWo5yeCd
	TNpaeQD6GF4iXBjzUQN21nY9ylQAStX95Ah37Z9KxxSYnpXysJmyvc199XN5nPO+82i3DG
	R59O1sABGUZLK55jPJtgBNNQuqG0nag=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NVSfd1YD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=36r9NagoKCPkkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480299;
	b=OqjI6Jdc4aDWLqZ4KLeFZWrWK1hRyfvHMVZ1r7fx3yJlmbP0lGFi9+dlAT36jLj77kAPjn
	V6K0i9HI1FZcKmhLS9sC8bDirQOuWl6zX+CepNzOqQLWJ3haSK1NAN9Mnel9D3/MMe20DV
	PSYRW7fyuBZvyJ3Lkd/aAGq67fvymLM=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cc86a9ef97so6299945ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480298; x=1784085098; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqMjZmPsv3+liEaC57LQksKr8l/QZSzOSPi/lkAXRvo=;
        b=NVSfd1YDASDCqKW6PyEG9sr/19FkUfKWvBQ2VTdAJwPNCX8k/E9hWgX0NU7DgHtOM0
         dTbJOG1ZruvOM7XZEoBrps6kUNcej4h88tIQI+1waGwTZN3qAWCfR8YUsjNlJsHmKAih
         Z0QWY+2JhkQE7QApRsS7L/4YmL43XpYK9uAO1GuVxjzn/QEZN08tY40eyiV20p//HrxV
         3GEjSJOqEYsasb1XGF1HIJsl5tZ6uigqLfzg6ldf9NMU/zgIucYYDUZT4k8X7J4ojuZO
         /rpy827N0WbdYhZXGIP1PcjwblpokvfD5BdfdGSVKzxd0J6LM/3z2u/auQ+CE0dlSmIC
         2iNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480298; x=1784085098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nqMjZmPsv3+liEaC57LQksKr8l/QZSzOSPi/lkAXRvo=;
        b=K7naQJ/HL7ZKnxC+8elEOptCO8xyGIOKqhz0nI7TjrQv2Ep0UGBPd9Lf3zadWnNLB4
         61dcDMVl6jLO5DaxbnS4hfnwX0yBot/1MliCMy2hFELbgIXtpNkBa11xGUbvRHrUvhL+
         rRZXo8pNOHeI566STQOdOIRRlhm9YDZZHgyGQi+OW2964RaMGhA0kR0WV5yErYvcrn47
         TSgYWsE5tBkOGlI/vDeV2Rv3tda5STUiuOSKuifBz0WDBeO7Z3dhATTUqbQ4KVFA/FZu
         NyH5nf2pHLBQ+GOeGyiydH83l4s3mmrI4FgEcai0LqyLP6T5ewK2ZtgVPQLjKr+Z6EY4
         daJQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro7HK5gVZ+tN6kgJrHgU92PhwKeKUwTck6tsF1lmt+H0S6vWp5E1F390EEES9M9P/VY9+5g89FqFw==@kvack.org
X-Gm-Message-State: AOJu0Yzfd7mbXMDbh6tmsyLpr5Lyr+6jVVyk24fp0ypD1fXJKB1XrjEr
	+w9UgFuvJKzylwb/wzAqfWyBBntI98uPyiKHu4NKceS1USv+ial0S271mAu8yI6KgMnGNjsM0TT
	7UALX5bgtpRq9gTzTdXtRWg==
X-Received: from plml12.prod.google.com ([2002:a17:903:184c:b0:2b6:417:db8d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2b0b:b0:2ca:2753:f3cc with SMTP id d9443c01a7336-2ccea45a3a2mr7332045ad.33.1783480298065;
 Tue, 07 Jul 2026 20:11:38 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:15 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-6-jthoughton@google.com>
Subject: [PATCH 05/18] hugetlb_vmemmap: Allow architectures not to allow HVO
 at runtime
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6DA39120007
X-Stat-Signature: 6zp9uqph6yu3xupxbkzu4nn3grdf9hyc
X-Rspam-User: 
X-HE-Tag: 1783480299-580470
X-HE-Meta: U2FsdGVkX1/RiZwBHWU7v4u4mg0qN7/bpykE9qhFITTeefO09SVs9sNo9HRdxDU1y0hyvc6aLBxQfyjDBv3Xm0U3sKwIX7xPEkN7UzTMxo9HPixYKk1KgR1pm/FElKnERbYO/c9PKhy1nKSOfnvGl2Hchfq/5VAQlU30yrTcE1vcGnXkxi79+jWNSFfkUWNOrTBMo/Nhqe0LlCAqbyEwMEjvfbfsWJhg9isrgIfAIlCCCK5wfeDBByfUXwW8XVVyemMzui8TEo4qNDpy90RxXdd/YsyfI394JWWjwGvbEVZbJMTQqw4Unw6LN5GuCKh/FEyDDNiRsiHjE+gX57JRhJXuuhsCdGKVVaPtrXs6/3TDiesrd3RPJ3S8IUU2zI+tYajH5AMWfzRfYU0o/AIoxvhHJyN/qyfQbQ3hbAN+burcexShbL657GPmNKARH5kQdyb4y7MO0Ewd/vem4LxXNmgCVNmKMZwBz2CRGMBrvanXLfINfwmCkcV6U49Idf41tifTvrcag0GMsM0CcYIlu+lATryw/9Bwpf5evzeDz1FQPpp+DV552VrR4RyEpxNuZHcx/VN1rAS+MrYmmM2DbWYa0aYXv29zctzYGJYfcb8u3Ck1sl3VQqd4qLe5XgfA+p3+fOWUuDFqMz2X047VvxmkTenr2wjaPlSz2xoyqQb35eob4fK+GhYoM4PAcYQnexa9tgaYPFzDVX8U7ewJAUEsOrKfHobLB/egRVQh0J9ZYdJon7r2hT5VWV04z9r3eH3Tej79+trfFgcZvT7zW5SFuHqia0Pfplvs2HF34gsKQoTG/295z3/J+DHKSAg8LqQTUuoVUXiK8cwfxYuU5jXu6VtzC2k1zaZrNFpgG/Wmtc/kg+haJsOxxj3jc9VP4+9vDgHr9v4V/798tBHBQOvsMXQL2TQvvBPfTqM/8iy0EEZ9EadCKaHr3NPb90M0ToehJ1UBnzLZkHYb1qP
 015sN86H
 9caL8h/ocyjM6OQ9uSOU8EXpfMo1tsvwpKBsAwfhOZh7X7fgRbvA3JXUw9ObetAUtNvlIwaVpvKcnXEUR8ISQ2muDnBAzTwmLTvMWOS2HjksiAsBBMmoae568BCJHdmdn8QyhnNQCe8AlUPo1l9eNJTpO4VWzNY2Ut1YIm4e7CKs/omYtiy3c/w8LWayXX7hjYLMOzTxcZ1ieLl0vUeE1MukQcKrWt9sjtaBV5Eeb+OQQzRIwfZIY1XM9mVYITVjtaj9H9O1FXqiKa93q+g5N19AfP2PXd0ResOdFYVvhGmF0S0o2wr2vK2PwyVbCl0P9R9xeofJkrSZFAefbwo5CCiQvDR7qqMAvzVX52UC/fETHI1fOHza6b/6cY4Np9LvQSHxR/3uFr9xP11KTSmGqxMfTy0VtUZTUzTks+IQmVfQ4p0x0ZKqo1/NX4HZZ1mOfHG8iD1hrH++5HHzakq4thCIAvmKILp6E2ZhGo+aJIRf1E/E9FQyGZwQ+Bfb8IVJ5wSziXA7cY/P1yoOzbR9Hx6XQq6r57BIRxAcThkec9dB0M6zZD61w7QvTNg0gRrSKODKbvN4bp5IB8Y1n5JEQGQvfHUWhY+hZ/qSgJ6z8ZQx7aBRoDlrtNG0r7uW8lQ5Ok1wysOKk2i/LVkvY25NtNtKJYo8GQUnyLDu11t6gkGqFJcTyM/rTV3eVpek7avI8AMB0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Even if HVO is enabled, architectures may at run-time determine that it
cannot be used.

It may be the case that arch_supports_hugetlb_vmemmap_optimization()
returns false at first but eventually returns true. This is the case on
arm64. When this happens, bootmem hugepages won't be immediately HVOed,
but they will be optimized in prep_and_add_bootmem_folios(), part of
hugetlb_init().

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/asm-generic/hugetlb.h |  7 +++++++
 mm/hugetlb_vmemmap.c          | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetlb.h
index e1a2e1b7c8e7..c4796c54b702 100644
--- a/include/asm-generic/hugetlb.h
+++ b/include/asm-generic/hugetlb.h
@@ -128,4 +128,11 @@ static inline bool gigantic_page_runtime_supported(void)
 }
 #endif /* __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED */
 
+#ifndef __HAVE_ARCH_HVO_SUPPORTED
+static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
+{
+	return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
+}
+#endif /* __HAVE_ARCH_HVO_SUPPORTED */
+
 #endif /* _ASM_GENERIC_HUGETLB_H */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 3951c043164a..21377f795293 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -17,6 +17,7 @@
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
 
+#include "linux/hugetlb.h"
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "internal.h"
@@ -556,6 +557,9 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return false;
 
+	if (!arch_hugetlb_vmemmap_optimization_supported())
+		return false;
+
 	if (!hugetlb_vmemmap_optimizable(h))
 		return false;
 
@@ -764,6 +768,14 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return false;
 
+	/*
+	 * Architectures may return false here but true by the time
+	 * hugetlb_init() is called. In this case, although the folios will
+	 * not be pre-HVOed, they will be optimized in hugetlb_init().
+	 */
+	if (!arch_hugetlb_vmemmap_optimization_supported())
+		return false;
+
 	if (!hugetlb_vmemmap_optimizable(m->hstate))
 		return false;
 
-- 
2.55.0.795.g602f6c329a-goog


