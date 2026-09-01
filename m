Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B552C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733F16B0189; Tue,  1 Sep 2026 09:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C9C6B018A; Tue,  1 Sep 2026 09:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621696B018B; Tue,  1 Sep 2026 09:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF266B0189
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:18:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1114A41ED
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:31 +0000 (UTC)
X-FDA: 85165247622.10.10CB8B1
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11FE3A0011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDVoEucz;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268710;
	b=OoDgnfnIjQqTfYsZrf3rrw05K0k2Q2zZlUqcmQmde3gFg1rHTZB9eZBUhiICQtPnZnU1JP
	O67HQoHarG6sYPXJaZgKEI95NMx73+Em4uwPFMKZB2WwInCHJTZteC+IHeYuK3XOER4/nX
	x8VcJT+euPlcOtJM7OIVvbBbnJ5Xanw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDVoEucz;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hYZ9mTkKbflVQt98jHbC/mLce8oRUM09qM0H6dktBA8=;
	b=5Pcq2QEyEe2PGcID9JR3VBkr5UAIe++6Zlgd/DkCYFZIaV2nu8eqjgvF0wiEyQcZ/mUAbx
	m7oN6ViDgRgqvH5/dybt0aZuSBRvkLJIqZz42DDdZTOfTIMjQ8E+4aakL2m7cUr5LocVWP
	d5NvC3Y0Ai8nkpAHyqJvcyyp5leSawo=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so47625455e9.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 06:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788268709; x=1788873509; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hYZ9mTkKbflVQt98jHbC/mLce8oRUM09qM0H6dktBA8=;
        b=FDVoEuczec1GjNF4TYBiEK+l6VRNuI2Ukq7b0mqMij24UqNNmPN4WKAh7t280BJ23E
         UfUe320ZHqXV2Y3mjft6aFAwqGON/orIY91NpJOvb3wwGZHJxJWFDSlO8yezs722wpry
         /rgxsSHf1qrdV4CE12ZVWxFxZKVhyoMQbe+wRYaUrgpvHS1ro/zO/n5DBttFna7sifQe
         sRk0nmImdc5Dyu2XBDBvI79TcZE+ok1s6S18k5RH3W42N0MUL6TGVdqnquiyaEU2MMnj
         Pz/g++Utwqec9JlVroUq5+d3kbNfp70vzW6sK1QonM2BZJiOzQA4zij2yjCbMrjKH7ys
         9jPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788268709; x=1788873509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hYZ9mTkKbflVQt98jHbC/mLce8oRUM09qM0H6dktBA8=;
        b=jDZNYPTbDki1dyyNYyW2Q1fSnfOlm0I44B/RpzKzH0hJ6e4vQe4LUueDarEHNSZ6+4
         OOtkcS1NuNgMfp/Ayl9qwHbdslPNbR4MWXsNPIv4UB9xiyWpXwA9f1zKOnBnCF7qIysc
         13HtDwRIJxjDOpSfBahElmjokPnU8ZFIVTJan3/r+AOHofCUcVfwtoAiR0sc5u7h42E3
         pvqAhxyPIE0hXRV8wDk9So4U6qXvR4lQw6Xb0jNk9oneVsbDYC0++6iEzid6l2pBLhs5
         WbCj15tjkwN0cGP2ntWYX0Eqr0L4yniI3rGzzh5+NEib9Ar+2YyO+L56ccmTc7IVomK0
         f3Uw==
X-Forwarded-Encrypted: i=1; AHgh+RrE+cjOAmdyTUYOQB8i+s+519KTgcgn9vHDQdhy3NEOFYs4cNfx0eaH1eEEPD7b2V7rATxDYkMFnQ==@kvack.org
X-Gm-Message-State: AFuF++kvGD5vojnHQuOGAUpTk3RHIVMkXZFYg/B1v7qqlZqW3hGrB4jX
	V3mlNc2iNUUbF8KF/u1W3PgKTSPGmyZNO/WY7qrRlSXXAumB8ibKi3Nr
X-Gm-Gg: AR+sD11PzdLPDIkaByU/EAkJ9b8lEbEgIOXzxwY7e8SX5fFbBDgXmZ7dUfWqTcpdEhe
	3mSZAwBpQ9ATD6ipwEkEvvJPZy+uChaf+jkSKyQGgt31HRp/cb4kusYRtNC50epFsZ75Ys5RqIS
	xZs+pRODNCSrEFIc8AcF4PV/LyMSA9InRZwJRIV/VRRu/Ec2Fohh/W4C/cStr/E5L9d5UsyCUag
	TNfO66rleQvp99f2oWM0HuSc6EViTJNJ97QIXWPyy7FmWJ97EZgJx9BnQQ92zfy6ze5oJyLv5Rq
	kCJL9CYgiXeQ9wV0D95wi5wx5tgFr+LrA3ZgBrAoUTaaiYNV6EK/bTwy2y+PanhxWurDuO9LjAr
	/aXA+dGoaGXyj4N1lC3pzGa93I8wlW4UsNwhCuSdGJ0FYbLwdfRhQ6Ktatj0GhP6XGfZ14yslAu
	49VQQc95KjDQofp8VT/45/+uAm728+DUXuc7xkFmuPVitL3Z/VSkcvy41J9X/bu2NV5WlOhvSSx
	I4m4EXOBtoV4I3Q/PnnI9ppCuqrFiZa+R3KY8B4Dl7FYHocbVd+ov1nLm0pWdarH6SN/hQ5XLMw
	sxHfelMFJAL43iFutbASngqPPuk1erVefT+0R7qtw5cR0DCo3edIIQmB6r2y/D7G9aUKigprA1/
	fLTdWLg==
X-Received: by 2002:a05:600c:4f0e:b0:49b:9433:ea44 with SMTP id 5b1f17b1804b1-49cdc40ff56mr178836565e9.4.1788268708319;
        Tue, 01 Sep 2026 06:18:28 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a16a-7801-fd8c-4b37-36b4-e53a.310.pool.telefonica.de. [2a02:3100:a16a:7801:fd8c:4b37:36b4:e53a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b926874fdsm356104405e9.4.2026.09.01.06.18.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 06:18:27 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: hugetlb: fix BBM for mprotect() on contiguous PTEs
Date: Tue,  1 Sep 2026 15:18:23 +0200
Message-Id: <20260901131823.15799-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11FE3A0011
X-Stat-Signature: 57d969gu7gmidrckxf1p7749oaqqg964
X-Rspam-User: 
X-HE-Tag: 1788268709-216675
X-HE-Meta: U2FsdGVkX18oHrrvHIIE/tpgVZo8apNbUFJSPSKYMYtx1l98dpC2z8hx2/rd0auJ2RtO5e5xzXemEHsHOpo3v6C7v6QzvbwedtrA8SH7pWqc8bilYsHDzIB51q1jVP1LzR7fpWkt2laXHy+dzF2xLOAR5nj8Hl47xs+Tj0WJBNS4XnX6kn5gI2GLyn4gowk2tJ4ZcJvT8cg3ZkYyywQ0zoh2kCjhY0lK0QL20jv+LAmvC4HGxPVfc7DB0kGQw57wT7VmJnjY5FtvnvGUCrSZbpwBy2T+oszkvh0iYiI1cVxySw8TUiXCXnfu+1Y6jee5+Afz1E6SnVL6su4O61sf8UEPhBTNnPrWIAlM2dYnmotJJLHV90UMYlxY/Y6gQM34zYET7OTXwn+QsfyfuVPJZk7Xlc6KUZshGE71+tqtCRCOMKh+boPeVCtQ/H3+E4706hHqAjFH4LCg81QBx2wWCjaJ3qyMLEywXQkPsnnMeDy8StxmmYL/jUCgYd/yP8oY4STidH8PTcouFgZCymwUbcpe/Oqka+btV8B97gjXKgR76yf7Vb1Z1HPDNgebrNVyVhQEESG+/3/TbbnRYKTwvIV2JvLLRNekxnIHlb19tI0O9nvulpaT1RmOFCOYE5K2CDgVpVL6lnsm7FcNxNyrMkjUgV7PcaH49agSyKl7zSS25szHJsXqxFt6Y8//elFjAuWAVGlNMpkQxiDBXpsbTimw39kAVeMrm3/7jAoSrpi/q7CYsTFs3CDMJzD8CJNp6jMrvlgQCZi10ir8a2RVbwP9DrixDWtpSJZKrDpMO3NSWhrWH5AaYhyQxirgDkaAR3BtizJnilwfwL+t/1Vj8Y9Pyli8VCRNohDjD9p/j70NweXRtr+nkggcO9Itw5rBJpwrvDVht4RzwmxgWvsuAnlK+WQusZZbYQmq028o6miyvQEUPMMwtKXqBoMSskbJ1gbG9y0RipjbwSU2xJ0
 puoyAAZW
 v0Q+IBidN3RRVmA9+7OMdnYHGh69fQe0xvXqZHQL2Coqlnq38GYgqLw7xmzebGXUY+GhR9ciIAySkGl09fqDVpk2DIox5NrB9nk6LiJZN0bVg08vPNvxtwFjKMxwy72J1Yq86V80O50/DZTJ+8IJ5Xe1FOWIw4zOSPKydxpW9+OZ0GcHqkEXR9kQsex9vJ5Nyb6p04Ph1VAF4S5B6VpmGn2gtvvFgwyKUo2DFzQ9BQZc1Haxfd87LvNtwqct8LhVeMzktV0/8+bkTPRGMZyBM8pps6vgsFzSiS64zaqtVNOHRG8gyhedVPQviD75h9PG9EZAVmpdeN7vG818pQFkXTHe1FI4myoZMKVrcXVFM82iNu35NmmFRUkMt43eb9OHGfdGVTSYYqqVD47xB/pEnS/Bjq458+6cGGttA2uv9S1mVwqQDzKGOL06KRpT5P8tLMRx4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

huge_ptep_modify_prot_start() clears a hugetlb entry before changing its
permissions. For contiguous PTE mappings, break-before-make (BBM)
requires a TLB invalidation after clearing the set and before making any
entry valid again.

Commit fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from
get_clear_flush()") removed this invalidation, relying on the deferred
flush from the core code. Commit 410982303772 ("arm64: hugetlb: Restore
TLB invalidation for BBM on contiguous ptes") restored it for
huge_ptep_set_{access_flags,wrprotect}(), since a deferred flush is too
late for the break step. The modify-prot path has the same problem.

Use huge_ptep_clear_flush() for contiguous entries so that the TLB is
invalidated during the break step. Leave huge_ptep_get_and_clear()
unchanged because it is also used by teardown paths, where the deferred
flush is sufficient.

Fixes: fb396bb459c1 ("arm64/hugetlb: Drop TLB flush from get_clear_flush()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
An instrumented QEMU detected the missing break-step TLBI on an unpatched
kernel and none with this change. A fork() control exercising
huge_ptep_set_wrprotect() remained clean. No user-visible failure was
reproduced.

The QEMU checker was exercised with 4K and 64K base-page kernels. The
patched kernel passed the LTP hugetlb tests with both -cpu max and -cpu
cortex-a72 (16 TPASS and no failures).

Testing on Neoverse N1 hardware would be welcome, as it can use the
contiguous hint and can be configured to report TLB conflicts.

 arch/arm64/mm/hugetlbpage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa..bb53a04b73b2 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -517,6 +517,11 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
 pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	unsigned long psize = huge_page_size(hstate_vma(vma));
+	pte_t pte = __ptep_get(ptep);
+
+	/* The break step for contiguous PTEs must include the TLB flush. */
+	if (pte_cont(pte))
+		return huge_ptep_clear_flush(vma, addr, ptep);
 
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
@@ -524,7 +529,7 @@ pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr
 		 * when the permission changes from executable to non-executable
 		 * in cases where cpu is affected with errata #2645198.
 		 */
-		if (pte_user_exec(__ptep_get(ptep)))
+		if (pte_user_exec(pte))
 			return huge_ptep_clear_flush(vma, addr, ptep);
 	}
 	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep, psize);

base-commit: 786262be6048deab760f68c8acc2c85607165894
-- 
2.53.0

