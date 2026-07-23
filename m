Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A541EC531FA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFFA36B008C; Thu, 23 Jul 2026 16:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1C36B0092; Thu, 23 Jul 2026 16:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978196B0095; Thu, 23 Jul 2026 16:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD7A6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:42:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBF67C0124
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:13 +0000 (UTC)
X-FDA: 85021213746.22.036BA48
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B32640004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=esF+LZew;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3onxiagUKCH8suddqjrrjoh.frpolqx0-ppnydfn.ruj@flex--praan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3onxiagUKCH8suddqjrrjoh.frpolqx0-ppnydfn.ruj@flex--praan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784839332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIhtxPilZww/6qXFXyt6pCELZXv5C+7yA4sMxjjosZU=;
	b=ps7f8k0rBSOuT4Prn3xMD+q2IyYqsbePEdbYpq5Ktf/+lyY+MgHbSJ7wrVzc5tVTA7rXk3
	AdIiFXYgY/I6Nhb6iuGE7PGDY9SwWZgrNVzCgt5MEa4VzixrszUPIVp0olhlbz/kpr5k7G
	rH0d7NrsuOJvT3wiEIamPa48BaxCfv0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=esF+LZew;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3onxiagUKCH8suddqjrrjoh.frpolqx0-ppnydfn.ruj@flex--praan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3onxiagUKCH8suddqjrrjoh.frpolqx0-ppnydfn.ruj@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784839332;
	b=j+CweL3JRpBYvNN7mP1USc/5KTcb8+IDcmOHHjP7Nk+0+ud76c8g/1jkcvWZhYOgmGT1Fa
	Ej2SI010ULcxS+XZA/2qaSP1t8XluScSM+b6fsCWy5MiDgmfve7WIdhxXphGhsrK3jCkPU
	LEvZtCBeXrIzfJjp1TC1RJO1xEOuvqA=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfa55c9430so11230145ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784839331; x=1785444131; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pIhtxPilZww/6qXFXyt6pCELZXv5C+7yA4sMxjjosZU=;
        b=esF+LZewqJ6eX/5xnaxVVwgFpORqFESCBZNWzPHQF4yMOFJ0PwPsIabHg8LmLMkchh
         uLjCK1cJMhWsevRXUV+Bj2uu6Xsyf15WqbHAKsKRdh1DR+cPYzDPzeA27sfA4sqbSFOK
         uGqHspgiHLHcOiyNiqa8qh+NQFdlbqohUcrRkBBJGrKcu5WigZZhDSyszI7suKIoup/h
         e6pO3wW4O1dT2MSKE9GI0SwBlKs8Nl5RzHNcqAVuxF/J2jnquotnVGymLNjxzLxiCLD1
         tjeqyGbLPQ+3lEcL9jEWbiCreNehhXOiJFfgheetgKpCRQhIY0a8NydQhuVg3ZzUtV4Y
         agUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839331; x=1785444131;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pIhtxPilZww/6qXFXyt6pCELZXv5C+7yA4sMxjjosZU=;
        b=q2p0cu6KqglxfFgME2BBiU0aJgX7MjOqvMqGiUo34Wz/RJTPRiizAjB4AW1agcIHga
         F6fAVOoyxAZUFxYaKV6plqDkitmXfQ17hI3MH1TmFnp0W2CWDyKfGFP/Sffvp0jKhwLw
         yDsDn4bMdawTedf6kQRwApaswbpYSJtTI71pvVj78lU/OPPKnRrKoKvuUhQ2fas/g0s6
         YrrLzd+23iqVxzkVPomW8bnUB0K0z0XNFf9Wzvb4NlN+qe5ncEk11mAc0dtkYIuuuuPY
         9KwS3wtZbpz/bli+lZPQpYnVNiLBQL87QIr4gGqRd7JfrEjkZixa7t2hiozmqvb/Yf+m
         9w0g==
X-Forwarded-Encrypted: i=1; AHgh+RpyMFGylMyZzjTjq1kt0xPI79xCYrut+PASQnxrsXx728fUNpdEQDpbtoliOXP+knZS6Ei0yym3vQ==@kvack.org
X-Gm-Message-State: AOJu0YyEncAxa2FvOyPKOqa3G46SkrymAdydFdkaTqvCXfnuFCSwwbv2
	oxQv2nrKO1K0y2Fi681yVMTK9XvVYEgPSTWHQaFZoDCdubs9kZCVqQCeJNZ3zgLnQxSOQ8Fe6/k
	V4Q==
X-Received: from plgi16.prod.google.com ([2002:a17:902:cf10:b0:2ca:f1f8:ea00])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2c9:b0:2ca:6514:9201
 with SMTP id d9443c01a7336-2cfa6b7a10dmr57623865ad.15.1784839330855; Thu, 23
 Jul 2026 13:42:10 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:42:01 +0000
In-Reply-To: <20260723204203.2997395-1-praan@google.com>
Mime-Version: 1.0
References: <20260723204203.2997395-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723204203.2997395-2-praan@google.com>
Subject: [PATCH v3 1/2] kho: Introduce a helper to init high order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B32640004
X-Rspam-User: 
X-Stat-Signature: 3zpt58nkz49dfrfm3t5d3go3udzafqrq
X-HE-Tag: 1784839332-620412
X-HE-Meta: U2FsdGVkX19n/vZSm8arpDyG8f7mLkbj7ijWuYETWi0Uwnbvze7gAHsDoCPkQxJOzuAQshw/fvmFvGsjk1+iHx6+Uioyp16RKbwnaRN7R29wc06BPRy3A/l7mwrV53CvJnV2rwHLza2diwydwlX+iRXYoiKectIfUY17i7V8qy7bUtwX/kak4PX+QeLLBlZp8d7Roaf6AWejfxLF8R59/RNhnMKXtwglIB9RRVjKP1ffMA+btOBiVHKsz3dA8VkjBYFtAqOcwjpDBUfP/w6XRGhfPFjWw9EMZRuLMsb1/ktFCpAnirD24Dw559Gm08gnwHqBoYSpJMu4v5l1uZyxgAQgK4ocNcU3ZdR4JIJFmBqJQLrs1kW24W+TvG//RlLCuge3CXTueXTaZGblhax8gAeOtcBSPlhOqFSuqE96XrF93cUsKnz4eZU183edg87/KCUvHpsYiF3qT4XS5ChgPjzvNvujf0YBsCXj8pWYqRp43tv78sAKTGDSDxc19zzPQNThUkz37jfmToA5ZD175pF6XyEMqd9CkJJhoOb+tGNFM57qKdH/ZPbPmRJihdu2Yh9T8e2pYcKM/FDU2UyeZ48jUMsS0TQW3R/7XxPctSGNn5n+7Wv0YREOrFeKt5CQF8dYLWoD1HN3j5+f6ZJzZgNTN3tdLIDn9vcCBrOvpDjLQz+9TlxiW7+YLll73H731R1O05ujf6j88YTjKeSim6EvTG4nOvw+j4imPojzxLdem4Bq1y4+d4OwVpdG+SD9sA/p8FfwCtMx9RDq4RGZhbmYwNlDdQKTg+pymnFguiqKU/3Ohb6Shp+ttubP0ZVgnmQoHKPUVvsjrM94FcQF5OeEctW6xoBdlPrTCfOK0/Xyyx6Yo/SKn/bRg8PKh07WllRA7TAJiTQR2kMzmvMKY6vtOrrqHwE3h8jvQ5yuYAHrxr2+Y2ckdL32kJKFChGQ7rJjaGp56OSfy6w73bA
 Sf718ixd
 yaDD5XHqAQ4wZ3mU4tI2pkNofvMNDItK1774mw9Z7KgbeZqfkzCyytIEUZox/pZpZR6OP/PheOrZA/l7mbrtsgu7oySHsV/N+3EQ66EKrO23uZ+XGCD4LIO2PbQpiBzMJFD2wkmQrCJ7B9R3DNFiIiavo3mSc1Yka1r+2HwEMm8vZx53JLxH654DlNDyhTrwByAnMzz0ybuTcZQNMqfKcCUqsCuwYOFl3EGs/f23NR/1BWjueion92uBK5DBKlYu++aQbNXr5W/6r1QgwvMZWQgvzPfZcqp+9Itn3p7CjO4xcKYHrE74sirM8wvaBW/r0K4hDPi/gtxYgmKZz/XtXqgW0VFYvQWlcgp5lyRJe9OSRpEAJMk0t4kaxc8R17e4zfxQ9g+ZiEhKVGGZWS7FFIgeAW1kj2tOOd6RBYdVHrrfIxiCkBheuDVUt6K/rH+qei4JfbWQG9i8Jm9G2fekjFtMMfQP/Hk2LEXdQqGEPWxWkmxZYn+stOMe8M1638B8n14dWL2QSeRYU4rQHoW19Agxydmq43VZMO9GnsZTNlDd3Q+VHFu8jIJ5qjAfJ2HoMphdX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current KHO restoration logic assumes all multi-page blocks are
split into independent 4KB pages. Break out a helper to prepare for
supporting high-order non-compound pages.

Extract kho_init_high_order_page() to handle the refcount pattern
where only the head page is refcounted. Use the helper for folio
restoration that requires a similar refcount logic.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..e836efd98795 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -357,6 +357,24 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
+/* For physically contiguous pages. */
+static void kho_init_high_order_page(struct page *page, unsigned int order)
+{
+	unsigned long nr_pages = (1UL << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+	/* Clear head page's codetag to avoid accounting mismatch. */
+	clear_page_tag_ref(page);
+
+	/* For high-order blocks, tail pages get a page count of zero. */
+	for (unsigned long i = 1; i < nr_pages; i++) {
+		set_page_count(page + i, 0);
+		/* Clear each page's codetag to avoid accounting mismatch. */
+		clear_page_tag_ref(page + i);
+	}
+}
+
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
@@ -369,16 +387,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
 
 static void kho_init_folio(struct page *page, unsigned int order)
 {
-	unsigned long nr_pages = (1 << order);
-
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-	/* Clear head page's codetag to avoid accounting mismatch. */
-	clear_page_tag_ref(page);
-
-	/* For higher order folios, tail pages get a page count of zero. */
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+	kho_init_high_order_page(page, order);
 
 	if (order > 0)
 		prep_compound_page(page, order);
-- 
2.55.0.229.g6434b31f56-goog


