Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6BCCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD9B6B008A; Tue, 26 May 2026 13:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D316B008C; Tue, 26 May 2026 13:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE4F6B0092; Tue, 26 May 2026 13:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF0A6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04D978CCC5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:24 +0000 (UTC)
X-FDA: 84810333090.06.DF878E6
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 172201C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HEESuz+X;
	spf=pass (imf21.hostedemail.com: domain of 3ed8VaggKCOYIZLJ+OQbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ed8VaggKCOYIZLJ+OQbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RFflol+bsWEcr4KlK98zfj4SqOIgycSAYTOMgzlgw0=;
	b=FW97ipRrFAbeRe80Pm9A2xKSboPUcXlriq7Ltk5qCy8m+xHQ0+WM24WTkC16X+uEIGcJlb
	ruJ613FuNkmAtJxUOFr4sCatnSFbO4Ek+rPIE1bqO0IJTFgU1I3AiDD+JKHzDDW6mkK060
	hQCQSYpI6EK1WfyZE6vyQfx0yWwWP9I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HEESuz+X;
	spf=pass (imf21.hostedemail.com: domain of 3ed8VaggKCOYIZLJ+OQbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ed8VaggKCOYIZLJ+OQbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818363; a=rsa-sha256;
	cv=none;
	b=ZeVzIgfjvdyNEEq7Hg219dnnAl8oriXoEjtgJgcUzs7ziyqlhFYDaJe3X3jL1yBZG8x3bq
	4fVQU8CbLPy+wHH/FY9/LSg5Yo4NqUosvuXrhUYHRz2m4YkU5mIrINSrb6uWelbs4KRVht
	wVbY7Tl6Kn7AmaWssE+wdFJPOyLC2Io=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490261c79fcso37463285e9.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818361; x=1780423161; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+RFflol+bsWEcr4KlK98zfj4SqOIgycSAYTOMgzlgw0=;
        b=HEESuz+XJpboLromgRH/aowoEQNQfpYb7mlHJOsmqEeIFWWL5je3HkPKj1VoRx0tLy
         nqIrrW+pTr5o2CX/FnQhByNMetFkOxT3dMT3xWzsq4cDn2Dk+ivDyPTZx1FaMuSiUa/P
         hp9YJCmHnAH9RxBBAF1s61gBzUVHMch0BNcHisdey8jV7JepeVQFwEQaHf5+q2LKqriH
         IAoH/uQryAMjRK0KsMxuhGrxo0XUjyIj8ofn63kmePUA9omYRH7NWWi11e16zYV5puIY
         RUhFkoxc2whAd0EJi7X/rzp7cdWN3kC4nRd+LaliQscwIb8i9BVf/ha8z0iwi/5RUQKF
         Jf3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818361; x=1780423161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+RFflol+bsWEcr4KlK98zfj4SqOIgycSAYTOMgzlgw0=;
        b=m0BwzizxtNqAafy18MyBrc++nin/fvOqksrnlIP8GXwpNj3S8N+cT9fWVi0edWl9cw
         H5vc0I2T5+4i9Kue4hSh5O4aSdrZVnJJ5Rm9M/Vk5fSNq9IGENSlrEvwpHEuj/TRV6C9
         0TlkldO/X4qw14dJNlPSdsRolrLIrig9QKdIU6pDFxyWlXAnCCWwWo8cwlTOfaVq7A2W
         WUbZzPMmXiZn/ZbuEQsWWz6vdQILGpwchvewdNznq2flnprxXV4TWC7xKe7clvpzgi+T
         5B1QzCkIGjJpEHUsPQfWwwT+0hudl49qUMK9+kp4w0pFL2Yb6Mg6M1fVd8Ht3oLwwzEn
         KjHw==
X-Forwarded-Encrypted: i=1; AFNElJ/hir4B9cWO5exhIAQ+Uwr8Jmhie3nTdyFtuU0DMVQa1bus4Kjq8jiyo1bgkmQyeQFKHG7Jz+pvIw==@kvack.org
X-Gm-Message-State: AOJu0YxT+CQqD9Pt3hfWLnxitiLani/EWfeMXRvrlCT5MCjrWaw/pamA
	vY+CbTVHiHDzNHc6oRSpIshlZH/d7eFpa4Rk/ZpprKNspOyy7aa2yWilz/f5Pr2SER9j4u9XWg=
	=
X-Received: from wmgb20.prod.google.com ([2002:a05:600c:1514:b0:48f:de5b:469b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8599:b0:48f:e230:29f4
 with SMTP id 5b1f17b1804b1-490426ade02mr205371775e9.15.1779818361151; Tue, 26
 May 2026 10:59:21 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:48 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1021; i=ardb@kernel.org;
 h=from:subject; bh=Kh7cxWXkNrSTDvznUsNThby14Lf6cpInZSVAIOoSUVU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fsQvk8viPq9V2vx6dMWennJ+dkQqIjT+cV/VLZF1b
 R7nhSZ2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgImsLWZk2HK0ii1yonQZe7ZV
 +ApXXrWOD0eLlqwV53zN/y7vkpHmYUaGZx8+meyLTM/2WSaWZW95P1zc+UOGxrXah+2Pw7MWVjW xAgA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-18-ardb+git@google.com>
Subject: [PATCH v6 01/15] arm64: mm: Remove bogus stop condition from
 map_mem() loop
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ty63hautcya7umrnzfzm1ydskzum5x4h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 172201C0007
X-HE-Tag: 1779818362-230516
X-HE-Meta: U2FsdGVkX19tbwKOkBxgqwrjfYtN8Qj6IbNh9Idj9aIrzvyZb8pgxN3x+yaIdZ9e4kLOx/1N8ruGfmI528dzIXD6HO97CHdkioDuJe9JomRZYeFwCnBC3g7xOYnBMqdQqjzFOMjkbCy1MxFeXrSY4ZAxMaVkJ5c8J2YzCZDVkktEvfYEmQgi9MJ43UvFLFt7jt4UvWY1hZ9GtM/GGsohYnOQgk4P9y9NKIftKwTFZSVgeTZdVA4S+mSW/4pKb2dK4K6dSrsRMk8yNFctmjIgvRcefLZfxECSCQ/jAnnC+E3q/E9xQDQSDw2tk6xwJQ2vq9FWS1kdExx4lkpRhmTHynHTTPNnTjwDk36V+pyzW8JRp/dC/JGyJz9u2jrmmePZTZaF0RrD0i0euNGjGgL9JtMQndADcbg4QuZwUPN5Lfqs3GPSE5+N0wMMhuAt6pALX/yDYvIMcsuFx5Bt4GYlU1k/4JkCUvMO1oTMkmN2qj8uaLcio4IXnLb7Aji0zUpP27vJEGTdcn3ljCOt4WlfjbKTk/HyBRXQu3/oomMtKGNNzjuRsQDo+heXmyrEMs1xc1NfXrG2MKlZ4+QHUX7oul83NQLW3/Q3/mUXTQyTwbBDuEmOn7zEWVZ+gxUE/llEhZi4YUDE3t04Y6RFGwCXkMaasuYbkyDGlNn4wIewszr6ro3k5IOHDGiyypfcJ+PKGtJqHWNqMPFd6TXKY22W/aG44LNjj8aRRHzUzkD9CVgNaltJgGhAE2wBe/BCaBUcaDuaoSVXEMW6BlY0hHlf5l2INuJfHsyOKvL3nlVGSUVCeftuz5K7lI7O3t9E6JxY3vYqsdNYwDDbrwyVbTTQOrv8ZRm1bM7cUj0cqm5dAMe5LXkbnnLq6XZ0yN7DTxtOmESE75WFxHJ3WSlfSX27lw+Dx30TrFHLgzST7FY0wSiTgmQpAMNiP7UqvBKmOH/kDQnRLPtBQXnKCUPbP64
 bOksqZik
 2EgU/jmsdOBge5zBUsEN0ZHkaNaehGy8NqeW6dwIZWkp6hIDnSBu0UeTHJ9EXAvJ38371k7G3T2MRlJeq3NPH3H/QTvjfCSED5l/clcocoLuXLAtH5PyToc+m/yVJKHAATrvIeH04CwFMDnw9w3k4ZS/zV0DveRNFrM5MW55EJE+QW5KAow78vVl6i73Ou3tsnPUH8F35A4y5OeQdWAnghxS+JKQUGWAGWnBERcM3YnchsUdHiuBv6dAnUeBvtmzf2ks+drskbUCiF20VMcBfmusDla/geFRX6S3am6ZDF5rk5/tZo4AaCA9yWNBiHuzOg9IQaIA0yZMMYyviLpS7F+BNlM+dvJMGA4tb2Wqt3/oAyOO7sXwb+2of+ZHgfRKAYCXubHkSERTTLpYGU6l5+lGLnVkT8hcJmM+7XFgxoEfgsyfOvWxZ3JiKznxqYSg9T3OGCRKEHu2F0pBI4NJjiak7pLZkl4bLIRVxq0E9AMtndGwW9p8IsHhE7aZBxmwS/D3UPirFp6Tl8jpPtYH3nl3KFNq+uU1hoYyZE4seS5Pghcnuai4d3Hg31TP4yC4fFfDck2h3i6BhN3hl37j3yYf/viI1WZuG1cIa0G3rWlmiqEkUVhnuMP1faaXElpVxHCEExRbdUZ2tNnce5bV8lrgo1QFlYgB5KDOR3a3GHbJGWlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The memblock API guarantees that start is not greater than or equal to
end, so there is no need to test it. And if it were, it is doubtful that
breaking out of the loop would be a reasonable course of action here
(rather than attempting to map the remaining regions)

So let's drop this check.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..112fa4a3b0eb 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1173,8 +1173,6 @@ static void __init map_mem(pgd_t *pgdp)
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
-- 
2.54.0.794.g4f17f83d09-goog


