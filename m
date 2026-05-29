Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12945CD6E52
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230C16B00CF; Fri, 29 May 2026 11:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA3C6B00D1; Fri, 29 May 2026 11:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0326D6B00D2; Fri, 29 May 2026 11:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEC466B00CF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C5A81201C3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:37 +0000 (UTC)
X-FDA: 84820773954.02.7FFEF4F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7E4DB180006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P50A7aOR;
	spf=pass (imf06.hostedemail.com: domain of 3iaoZaggKCJw6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3iaoZaggKCJw6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuldBekegH9n0W4LLX2RtMOFJe4Z/6YrXjIgxtYQaL8=;
	b=XsjEauEdl9SSn/4Rb9/QN5XoFJQbv0yWYgO/EikFaYJZz69KzWGPy+VwczUonbKpmbwOA9
	6m9Bp1Mre2OyoeNoooHGwNGICvOX9jO+s9Bjb+xCth+6TiGXm9bazUr7wtElT9vNt3Yj+b
	89QgL9BtrJEt8zuTUNdyNBz/Ok85nbc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P50A7aOR;
	spf=pass (imf06.hostedemail.com: domain of 3iaoZaggKCJw6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3iaoZaggKCJw6N97+CEPCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066955; a=rsa-sha256;
	cv=none;
	b=xRDlAxaEtNVmlAneifZRakXEESySpVlEqloyGqjUQoPWvFkdDbco6nE0vsdcoUcDVuXFat
	oK+xkpp0HVfHx0GKyhGZMjPUj4mgD4QtYHKBRGb4wy/9CuZavZ/crdWw6D44yNZzE0sBRd
	ZfCjhH86YNYNVqkJ+EFi/7oGQe8FjFA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49050c44bcdso81471245e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066954; x=1780671754; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kuldBekegH9n0W4LLX2RtMOFJe4Z/6YrXjIgxtYQaL8=;
        b=P50A7aORWyJNMb8+LimBN5e54jI20kmYBrgG3HcxDjI3oTq9uHoFYz+0fK+nRQF09o
         JPWPOSlEyetDLNBJOhCAzyMZTMfgFP3yvOOiFFTuyOwLAwY1NmDbgKaCc6RjtKDTd0NA
         c6BowoxhJGhuHc8VhyapjYORyt1NP/fTVbEeMciDqPOsKyg2gN7vHyNybVbodUzhopkK
         1cBwB46QtRPqJGUtU1XsLuTxLG2UroII2MxelVROKEJzySykxwZdxrKvCGnfASom0O5b
         B6gfDd6v9NzSbcZ/Rs6atpnuRdCNTILSJ4evlBqd1kh9vUPTkQqZgluKYp1uQ0ui3EJ/
         BLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066954; x=1780671754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuldBekegH9n0W4LLX2RtMOFJe4Z/6YrXjIgxtYQaL8=;
        b=Z0TfugARcxQ9gG1LvbVQJB6nC00tcggIjSI2yPKofU+lQxL9rRAdaRR7W3Z1UoOpOf
         LXpsBGND8FU0cgX3vrd1xdrMWBljGhtwxy/CkDuNrY1jksVvlNM758dLP7V/LIZVOBb+
         xvnANOLwD/pTLYZOWs4GKvi5V0b+3e1kH+yRB9cuY/jI9TejhXZxn78ArPMdO3gh3aWw
         /dqKYYSsAYTxg5Ces5YZBy8VQf8o2uezO3lIqoahIyWAm9qdYsCRkcNW4ESvB/3Hz5lM
         Zj12Ts4prTp2uWU1b6JoJ5LYMclLcEfXhYanSC/g0Biy+iJYDd1SDMabKB5biPsi6Y3H
         ibqw==
X-Forwarded-Encrypted: i=1; AFNElJ84uXywDjjUHPjAVMSrk2bpYI0aIy0df/FkRSMw+Uej5DBIk3bCFEftuw3p1xP+NA+NyzbH6HQTFg==@kvack.org
X-Gm-Message-State: AOJu0YymtXYfSFNIR46/Db2F4+ZXWlwkLhdTEXgMBENG+SKSWJ/d036Q
	uufRMhQzFo9N+QjBTGht6147EvpnSTecG4faZW+Yy13p4LZSb0ODHUHpClkIWDNs0k+ltBL+pg=
	=
X-Received: from wmbds9.prod.google.com ([2002:a05:600c:6289:b0:488:c686:2b56])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3552:b0:490:58f4:ba23
 with SMTP id 5b1f17b1804b1-4909c0ea669mr54166795e9.30.1780066953743; Fri, 29
 May 2026 08:02:33 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:04 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1898; i=ardb@kernel.org;
 h=from:subject; bh=dIgftrvtjy9n7J++AHRmcZhewFAl9rYaD0F4euqeHS8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVd47S5EVE1yUzEILxG4o87+S6v8hxD9hp5NyQ8ruu
 0eqhL90lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIkcVGP4X3vEZYrpXP0XPhoq
 LB8n7Xn7w1MyccZGAxbjdtX1WbwLNjL89511yu9VgsV9/ZkbXeb/7X59yD7RKOaQzExH3lUBFrd CeQA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-30-ardb+git@google.com>
Subject: [PATCH v7 13/15] mm: Make empty_zero_page[] const
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Feng Tang <feng.tang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8161hq3cj4p6bz8o9cpek9io4dymymso
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E4DB180006
X-HE-Tag: 1780066955-768646
X-HE-Meta: U2FsdGVkX18/RkSCQwPw1ltUgrizYBlTgqOOyGz5JUoX5NE+0mMuGMZTtKZEK6lMW2OFjsSJCXj7lyzqcRlx3jguk1xnM3Dffx5i17K2M80ZH5PdttEdRuIlX0lm+xWyEQ+q12BDPht0/p9cwSOtf5V+3Xg6D1Z5ZZR5jBBHpWXfShMe7KcoQlE8t91fBmJbIQkxn68qXZKfmZSekzHoyhuQyx92qnNkVRrNfpM9kb7iSTXdi1ev3EGZDJP5m66v53F0Dkccq2Bm4dJql0aopVIwKHBLpxlqvZwzujTg4m7Q4zaj/Xq0HLHFHU4/c5mlOwEhB3yRug5IvqHS6Zk+aM6fwx9RopqtQnozT7RgK4tzfSp++8NQtDdL7MCLdJnkLCtoGJs9ouXXkJtp0ejK677UzhbQErA+gXnB9wdB27OjK4DScKJJ3rKAu8u1oeeuUbaxtdfc9Bk3QObvrm2emnaEUw5eShbnJA6X6i7jOy+jbIQXFCXM8tLE8/T6feLIvsgYTFPzxJd1HqNvxQHZ4gDIjCugFKFoDoaC8HpKojwOTsH1j8uhxt8+JUY5pRehknivKgsNEKaLtIjDb4AGpO03rTm9AsndEHIsGaP3g2TGg/A4rvkGcwhxB0dtAQGfRkEph8H7ouaNu4pPKP1Ly2WEqB3072c6EgyVV7cvclDP0I/QB0RmA/1hl2QWBoB4Lj5rsrdEj8w231cNk+tdqvB8TZGjJ7Gn+rDMe9FBIxN/WW7rxjCGmTIxsTiMzCHZkh1nfU2wSIoCSFLz6XuX1qj8YKCzPqRHq+xGX28WvkZQ0ArGVJGYo8P+bYrwmUjn7yySZORb06+XYACg8cHQxFEt5vkWUXhpcMRpP56KdlipnPxkfIQfiy1c40EqBg8bMyeHxrjWiu7ZHY+oGz7n0BuYrsRzsxjnpYVQMCYYm3O1I6M6B+CxxlliHkbrnEXp35Fp/A115yAADayklU3
 xtFMTl9Q
 IpmG5+t7KJtyByQuyu7s42QnLx2ZnxmbUY7hrxm1sMmNsWwwdOpLh82jaDPj2s1Om4TjOT3uj+knrmJD3lfDwJdhPRC7+5gznYXQtqyE/EYP33MWVB3Ro1UDhcwSii6UVFIvQNH12hZXyQzNkChe5y+nxOUMtUuPoZWbi8rqQG2lDnxJJNQQhiVlnnUU06Vb0w/RM+/PLx+lyjKaq0We0u67rtgduEOTK7Q+at3bK5/ve4YirpbzhLJilXA/yO7X2rb3y16pUE2sxRTPSXFX6oinbMHK1j+24/brUj51lqfSYCMqTHzX0S+97x2r+VjkbW3twlBT3Kt/WirSwIPZhlKAo9k8Zr69xm/c52r5EQ6AfG9eKevtx74MzWLq5SSU8WmGngrhXqc3hYZddX+wvVIrXFSGNMV9wNG7gHzvoNeCAodotIq20kopQE49aP9shJZ/El8TeHoKwkR2XfK6d5aqI2SarMHgI92xZWGnns2S39yxUQcaJveNTHBf7+yqJGJRR5Ee9Q56z8wgnm32fuUbl6U7EhwwLaexUsIYRd3o8gTnQjTOFI0LMUQK2/jKCjH8c0QJ3fImToOE9r97UFlskGYk18QQ6em4kO3pfdQbw93XqRMrqgAtPe6sDQj3xmWb3mPvdiMy8twlrmO1pymgKCwZqOBS0ZSFCY9R544YgyHZj/tDP7S68ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The empty zero page is used to back any kernel or user space mapping
that is supposed to remain cleared, and so the page itself is never
supposed to be modified.

So mark it as const, which moves it into .rodata rather than .bss: on
most architectures, this ensures that both the kernel's mapping of it
and any aliases that are accessible via the kernel direct (linear) map
are mapped read-only, and cannot be used (inadvertently or maliciously)
to corrupt the contents of the zero page.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/pgtable.h | 2 +-
 mm/mm_init.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..67aa23814010 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1993,7 +1993,7 @@ static inline unsigned long zero_pfn(unsigned long addr)
 	return zero_page_pfn;
 }
 
-extern uint8_t empty_zero_page[PAGE_SIZE];
+extern const uint8_t empty_zero_page[PAGE_SIZE];
 extern struct page *__zero_page;
 
 static inline struct page *_zero_page(unsigned long addr)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..46cf001238c5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);
 
 #ifndef __HAVE_COLOR_ZERO_PAGE
-uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
+const uint8_t empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 struct page *__zero_page __ro_after_init;
-- 
2.54.0.823.g6e5bcc1fc9-goog


