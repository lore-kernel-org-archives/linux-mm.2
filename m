Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31F9606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AQqElsSp
Received: by kanga.kvack.org (Postfix)
	id D91516B026B; Wed, 21 Oct 2026 17:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BFD6B026C; Wed, 21 Oct 2026 17:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09FB6B026E; Wed, 21 Oct 2026 17:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1686B026B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:11:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C468406C5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:12 +0000 (UTC)
X-FDA: 85347878784.03.BBB3D50
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37B8D100008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:11:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQqElsSp;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792617070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=093JJqrrOxUj2abNMLhbp+4Uc4OaHt2/cWwMxdwN2F8=;
	b=YxZIuRyjAH6CDOXg9tD6zxhSYL3+7UDqGXOrirrPf6bPBCSnNhAvKx3rp/zBaTx+oVzxw3
	HGNW+6sMlUB4HqwvoLpXYyVBF7I4mMWvq+rtBQe/GNf+1My6zGrnmUoasdaiN3YgArKHI9
	84KewqK+ENZtPBU7jCEn+J7b1mx3qZg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AQqElsSp;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792617070;
	b=l/TwzzJXH28ekD0VpMC9v2tYsmW5I+ucYgT3/gQkKoE3EmAqQJ8wx2qn8xjOOGxO9C3v0I
	LYEj8OyGOXFPL5DsE3CEuA0N4epWEN1JthCqYB8TnxxSVESIH6X+BScIM8yKWqfkQpuTFk
	zH9+kKgUrvg69OVcmve60PEEIQITKWs=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4956869750eso8517925e9.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792617069; x=1793221869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=093JJqrrOxUj2abNMLhbp+4Uc4OaHt2/cWwMxdwN2F8=;
        b=AQqElsSpXc1Cqksto+oEoAZSaAyKt9b9oKNjs8c4O9NGSGB1ayY7k8E8tW3ZBYTZMW
         SXlaclGaUGERAmKAyRMEirxNXe5xzzBSHuGLrp1x6aJYZw44vfBWdNEm4CW1F52NTalU
         UMubKE8yZqKtxWYaPVJuy/LdT0HnFAdreiyOySxk2g7+r8FS6ou4QC618jn7yzwa1nm3
         ZhgWtRdwgaab/K4jQ5GtLyszwmVVzvCOW1UIJB141ntE0Sm0yjwNM8ZvzKHUhKT2YMcw
         /EYNmh60igfb9geg6sIoEfytsneTDFlLBZX9qkHrh8BIB6qXewBFyFhQT92uEzN+6s68
         pI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617069; x=1793221869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=093JJqrrOxUj2abNMLhbp+4Uc4OaHt2/cWwMxdwN2F8=;
        b=0n2v+4OYcnc33T+alDu5ULmy2emTOdZnpKx2XMppw8DVJD3P7PLb+kSM0KZsm47+FD
         Od3+WtuOAEhEhOANnynvwkL+IwMnj1adnTlKeIYT/9X+KlznCV0U/QPGLvZuLNGGNXRk
         g8UI7DfOsjW/7acZX7TOjZekLCK1A/ATj27nj+8Nos5hwn77Heccquk35TirPK3brabB
         Abt/gaBfGr8e7JjxT8ylBLd+nCvjEaIiPJA/IIbrDYcQjQZ+oBop64pk434AT9imwHoJ
         e1sGALLzJFsjVb2aDsWB6eBIAH2EKCANEiV4aRWVnM7uzY9qhM4Y8EPo8rDqX00Ys/y+
         21fg==
X-Forwarded-Encrypted: i=1; AKwUvBxGyPKMJhLtF+moNdgXI4V9huyHyNYlu3lSJzdRNf9uNQZdarIWNPZ5qZndgmZ5NuC1rQDQCpytDQ==@kvack.org
X-Gm-Message-State: AFq9FYJebjArvYEEkQZuBe5Kh+5/8nQiR1a4Sc2J3fr8RCES0990Z+nJ
	8pJOPSRQlTbe6+JPxA8UsmLSgUWrCqNFMvRiM4yoxqlfqkMzEXMeK5Z4
X-Gm-Gg: AYBFou2baFOO9JwfzDOxjVAFsFf5VBTPOM6m8Z/HEywxJYjZkU/aiT28865Y7Pf2j9y
	PmOIVAxYoiGLbxJvyvJMBmX/Vp7hRZaWZQAEaANE8AB00uTksMn38Xyp18XW+HCVbBTdomyrEsa
	mxTzqXXebqUj6Et8fAPTgPp/+LTB2PiSMRCfmveNfi9nMyGki0HNEVQ2l+my14zbExm0nO6i5Zs
	bxhiqabUTafq3T+hwWf+w+XunmMBbqpCOQq66TQRs4inw9M1JfuZFN4ou0ZGqcwqQczh85ACYsm
	FKmxNvuBOEzA/iCuIrINddXuHkUdVOljwZ3Dvf8FaFlwcvZUotyeHX2IXYfxk3DeS/ZqP8YsB0g
	WOMfztrb+nWLl5tkqWl+G+zLZvAi7bv2qy2EulqKsk2tz2vMfmjn6iHbNyLh9F2xKydE0fhqPnR
	uZeeioXc2ZRYHLxo/OG6ZzwC4vy81d0DKCEVSpto0PClUU6vpElZQxBzVdNUbpWgRYH3IvBvXpp
	yKrWb7hw1YaBdr87pl3NnMuOLf1VKF/omFNKg7T
X-Received: by 2002:a05:600c:46c3:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4a1fd8cd9f5mr69945755e9.2.1792617068708;
        Wed, 21 Oct 2026 14:11:08 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a25fb5sm22891525e9.6.2026.10.21.14.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 14:11:08 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 1/2] memblock: factor out the KHO bootmem check from memblock_alloc_hugetlb()
Date: Wed, 21 Oct 2026 23:10:45 +0200
Message-ID: <20261021211058.83483-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021211058.83483-1-azpijr@gmail.com>
References: <20261021211058.83483-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37B8D100008
X-Stat-Signature: d4ik8qhqpgdbudahab5ogotxzzn9wzqq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792617070-190025
X-HE-Meta: U2FsdGVkX18jMKZSkGhmlG7rWbMb/kyBfEr1OaKATH2nZOWzVp+jwn6UBgCLpt6jq0fet9hp8w0vjHbq83WFlotVWSWumj1GRwE5B9Lwi9HUpEl78uTEGE+y1Vfw/D1+9Qcku7inrx6vLwGJKhwHPLZQQNjEAqszlc/N1fF28KJO/ntCuDEJNoajaSaJNVA6f4ebPNmEo8hTkcu87Z6p4jlgTuBbHg8/wdKy4coI8bKjw8t9Fzm2qC1RXvSrbv/xPsI5Qjdu9zfNEyKA16uyX9C0/CawKbYLD5EPa2ARNZx0qHrSwAaQE2Pp0Nti1qU6ZuhKzt476ZW3OURsdiYPk/Dhk3ebhisfSOtcJi4fOURa4VARk0aVWu27s99u3kUfRL8pRpEkMzYw8WeXFvjcP/Y5Uad+spO2J7B7snDnjpsoDKk9d2o1gVUpUlsqCKsln8Jm3XpIiSjARsc3OrAfbuetiSoPpsOHRdFdAaHYUwPwexK0DxHUcvMQQdKp/s5zHux2iSTUl59xlyePvNsvmCYqQV7hJiGQZ8XdlV7NinqrnJwpgWMPpBMntWKKgNoA+S4KHbh4RlTtmkWYMKuZjbJViiV54XNAKVEwDMp+iba0hLdjln5YE/gHvoIYkKuExyyVfQ9ZJnMCxK7P5TW7CszupTxu5SyHKvcZ1LUvHAbVjZAIc59eY7qwSGx+HXITqQCAZyoxGKWFv5N8B0CJWa8pp+g1W08KgSLDC8eRA5xT4FvHImGcN6sM5TNt56BJFofNNZnOFFV1F8Wc6sxeVr3yVCq7gz5qrqWWZUNmzdMSzkJkZgUgEGoq6tQ+A7koWEg8HjvE8OLMejMV/jl3ZVeBiMQUjmc2tmbCjQCU8cVFzeN+uCn7+N48rszGC6vqT+uwMewKIXvpCbV+CsAVT9dNbr8LOgWo2fFeDxdRpj4l8V8NMNW2tgPTFBCMEbw2fVs4YJYnSRWsi3GR7Ja
 z8KeLOBj
 dCVUOSSofLtAHTPVlEQ/YuazyiubyTbXtJHg0GkC5071XKlyVKP9iqi4G8OqO3fVVb+GJza3Y66HPEGIfwDR+nCG/z8oDeJCmesz3BSDb0vmDy56D3hKJa33CtHRDKQkrRDLooWTt7AxkKU4t03tsjoLLHbWQ8u8nmJ2zljXg7Frk/zIDxhkdDa4fPCWdIc3NyNJHLehe8KYzqIhVK/ywb27PuXxIZYVqyvmGM5K4VAsn7VOTQdjwfuXFgHUvTuY1Foey1rWvulW72bMxgLj0/U/v4VqKJOOhBzNi3e8HLMxqeLBAKV3nGgzlXBCSLYBrnyMwnuu6gk0eFsSDeVmnsSlb+jMLzpQ7vn/vMNFCv4N8zNgXKInTqs5iPcJ6OZ7JyckwAXGv7xthhq6eT1PflJs3b26RfgNb+VJlkfaF0YNByEKsaThGM7lfJqLepugBEGqvYbBaf/8gIYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

reserve_mem regions are preserved with KHO too, and need the same search
that keeps HugeTLB pages out of KHO bootmem. Move it into a helper.

No functional change intended.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/memblock.c | 70 ++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a450092a80fb..f43659688681 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1744,6 +1744,31 @@ void * __init memblock_alloc_try_nid_raw(
 	return memblock_alloc_internal(size, align, min_addr, max_addr, nid);
 }
 
+/*
+ * Memory that can be preserved with KHO can't be in KHO bootmem, since the
+ * next kernel boots out of it. Bootmem areas are normally not very large, so
+ * this shouldn't take too many retries.
+ */
+static phys_addr_t __init memblock_find_outside_kho_bootmem(phys_addr_t size,
+					phys_addr_t align, int nid,
+					enum memblock_flags flags)
+{
+	phys_addr_t addr, start = 0, end = MEMBLOCK_ALLOC_ACCESSIBLE;
+
+	while ((addr = memblock_find_in_range_node(size, align, start, end,
+						   nid, flags))) {
+		if (!kho_bootmem_overlap(addr, size))
+			break;
+
+		if (memblock_bottom_up())
+			start = addr + size;
+		else
+			end = addr;
+	}
+
+	return addr;
+}
+
 /**
  * memblock_alloc_hugetlb - allocate boot memory for HugeTLB pages
  * @size:      size of the memory to be allocated in bytes
@@ -1761,52 +1786,29 @@ void * __init memblock_alloc_try_nid_raw(
 void * __init memblock_alloc_hugetlb(phys_addr_t size, int nid, bool exact_nid)
 {
 	enum memblock_flags flags = choose_memblock_flags();
-	phys_addr_t addr, start = 0, end = MEMBLOCK_ALLOC_ACCESSIBLE;
+	phys_addr_t addr;
 
 	memblock_dbg("%s: %llu bytes, nid=%d, exact_nid=%d %pS\n", __func__,
 		     (u64)size, nid, exact_nid, (void *)_RET_IP_);
 
 	/* Don't waste mirrored memory on HugeTLB pages. */
 	flags &= ~MEMBLOCK_MIRROR;
-retry:
-	/* HugeTLB pages are always aligned by their size. */
-	addr = memblock_find_in_range_node(size, size, start, end, nid, flags);
-	if (addr)
-		goto found;
+
+	/*
+	 * HugeTLB pages are always aligned by their size, and can be preserved
+	 * with KHO.
+	 */
+	addr = memblock_find_outside_kho_bootmem(size, size, nid, flags);
 
 	/* Try all nodes if allowed. */
-	if (numa_valid_node(nid) && !exact_nid) {
+	if (!addr && numa_valid_node(nid) && !exact_nid) {
 		nid = NUMA_NO_NODE;
-		/*
-		 * If a previous candidate overlapped with KHO bootmem, it would
-		 * update start or end. Now that the search is opening to all
-		 * nodes, reset them.
-		 */
-		start = 0;
-		end = MEMBLOCK_ALLOC_ACCESSIBLE;
-
-		goto retry;
+		addr = memblock_find_outside_kho_bootmem(size, size, nid, flags);
 	}
 
 	/* Found nothing... :-( */
-	return NULL;
-
-found:
-	/*
-	 * HugeTLB pages can be preserved with KHO and no preserved memory can
-	 * be in bootmem. So retry if found address overlaps with bootmem.
-	 *
-	 * Bootmem areas are normally not very large, so this shouldn't take too
-	 * many retries.
-	 */
-	if (kho_bootmem_overlap(addr, size)) {
-		if (memblock_bottom_up())
-			start = addr + size;
-		else
-			end = addr;
-
-		goto retry;
-	}
+	if (!addr)
+		return NULL;
 
 	if (__memblock_reserve(addr, size, nid, MEMBLOCK_RSRV_KERN | MEMBLOCK_RSRV_HUGETLB))
 		return NULL;
-- 
2.55.0


