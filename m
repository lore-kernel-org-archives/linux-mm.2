Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161B8606A88B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EV89ErD8
Received: by kanga.kvack.org (Postfix)
	id 64BAC6B05BC; Tue, 17 Nov 2026 02:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622FB6B05BD; Tue, 17 Nov 2026 02:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539026B05BE; Tue, 17 Nov 2026 02:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F132D6B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37DC5A035F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:48 +0000 (UTC)
X-FDA: 85443728496.13.8979E7C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B4C08000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EV89ErD8;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRJMwvDmLa0Mxt7lUvodHEIfZ5kLtrx4K/1ogYaxsoQ=;
	b=OlYl6biKYOXdsWplBupqMyZ+1UjMKeiIY6rWsYlODIcvFL9Bz07USchF6gsa6nt+H8XL90
	bfAZ+52CUotI1Q3U6TvcNvcCk+QyqasOxbumJh2QhDvcCApx0RxqO4PcURVas0iyHP9XRO
	7TA+F5QVwWxWajtUspMtXtWogt2I0PE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899206;
	b=ByJ6k4NDfzeuxgYnpDM+c+FzGp/llyj9qjdqjyZBPjtQBUdNFH6CjqX0b5VAnZtKza4i2c
	WB7Dv3WmzFSy/1I40vXS4s/JM5CD6barm0gKdcGVMD8CrLYeNjk0mAo7qSWVHpnEtZvQKv
	7xnXzgeSIE0WaEw0d5xK4nUV85svLC0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EV89ErD8;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7AF91476;
	Mon, 16 Nov 2026 23:06:42 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B04F3F763;
	Mon, 16 Nov 2026 23:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899205; bh=cjFCjsGjjj3NFQXfJiX7x6ODC1OdEC1eKFuR2TOwJ+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV89ErD8dmhrCVbgTiKEkJd0dmsZr5W+dUysQu7rq6Ef38hr1a8eEIJaRa9uVoDhJ
	 /Z/yaKebEMMt2WXEM8qXKJjo5Mg+j1a8Y3Vwn0PPF+PuGvprw8y24H1oqjdNvtPscF
	 4xgqMzOlIz4KoSBzl3lkSqgDicQ4ryI07hf66H6o=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 06/14] arm64/mm: Enable fixmap with 5 level page table
Date: Tue, 17 Nov 2026 12:36:05 +0530
Message-ID: <20261117070613.1183243-7-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B4C08000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6axmfke6oks1ra8qpog383dog7thobqk
X-HE-Tag: 1794899206-63811
X-HE-Meta: U2FsdGVkX1/kVyK/5HqgM8Hl1H0tEvZ+XhLDIBcf6yuxUQ0UkTUwJqjlZ0ZbcNhu5y70qQZ5ERQLpwb5xiJpjCSNbgbHofe3safD5Vjw5HG7243hOmQzMDL0BOo6ltO9EILpcMsONWTSE17CpC+/cKRzYgmHcfKVGzRY0fkDzgDkOzQ3/LcPjnLjfNtrZNdP6tIiUOyCWuziZhjPv2aylzxl0TW8TIJZs99qbbqZWpQdoLGrNyAbU2LFLx341EfnsUTP5NqXr09O7MDXS7GNup9TIBKDkWZ/D6bHW66bIngPWEyu/nP3GRKrik/JaEn/i9lS2edg6FPQt5RdQgoiXMwHljgPqfcWkh5HjJG59mqDoD74120p0tVpd7kicJBtSU0YUbQ/o09i4cYO5pAj3kPNBrgLYcljA4lhiCec9AwJiqzUu5R1m4yxBuo04QHtOipWnO2ti0debkLS+rIuhQm9RjIeRY0Cqm4GoMpiID0FCoNZ+3lVuIvh5lit71AtPRKh9JTtihktdy15q4pxFVEXAGayKoakE9SrBrvnw1ZnvRPdPfULT93+m7sqqoBgoCuAhJyqPygcqeTKWHVDWO1zSIB34VVrG/y3bv5IUMTBIIdWQDC3qkYpNbaNtVr0uU2NA0bPoAYnXowOyE5GS36UXlT0eaHQFM7Oxr+7U3yG1AJ8SEtX/XuVh/6Y/hCq4euSyOIRoLmyHudUAzVYHShDLNAsr0pa/jL2XFHv3lO4zLwXvrDQurHDsHapUMwSwl+fRwm0slAI2tmzf03lEvItSsS0r3Fe51tQx8rIKXYHwXhh03jVCQJjuf/KKz6nh5oo2+VLCG9mNI7SYj2nAaxmhjY8RAWA2sPYy6N0ZM7E6AqerwZ73WjhOYf0eaJLU1DyweiGnm5QSWV3WPf+hGgaVVZbfTh9oOlrDLLmsTDlxt8ITEifOIHswnuvp7bslLj0arorQairPqWOoe/
 0vSVCyZJ
 Uc9lxjkVZn3+mGhNirg7JabGrIERrXMMnnqPuucfNPw05u3E8uSoV1F2zxlAVanDa1ZlrT9TT3fcBjArQhZMH8/SQMVCiNON8vAILZk4lzwiNQZRHryvuKMlgbMhfZIRUUFjWtFDqf2ULHaIKufMxvpOEfzl3Zr6AtlwjuKHoibvo6b96PDE/b6o/0WEs+M9Qs2dspt/c90dkLXVRzm5ttl6uHMtAnCQrC7DOtvcvJPWZT+UvGCJ3LLVXrBUtPuV89n5v3O2Ql5ptxfPFlafhezr1nzP8UlrUA2frDriXjRhBqV86SR1r0v8z4eeb/ZsUQBKZMuvcezFad4XplkLyGtjtZVH7GsZOMplhMVjZvhye+bSd/dHgrJjL2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

FEAT_D128 halves PTRS_PER_PXX thus shrinking the VA range coverage for each
pgtable level. So in order to preserve all existing VA range configurations
for various base page sizes, some pgtable configurations now need to become
5-level which were 4-level earlier.

Since fixmap builds and manipulates kernel page tables early on during boot
these mappings must also gain that additional level, which was not required
earlier.

Changes in the page table geometry can result in the P4D table covering the
fixmap range no longer being populated by other kernel initialization code.

Enable this scenario by allocating and populating a static P4D table during
early fixmap initialization, similar to the existing handling of other page
table levels.

Add a pgd_page_paddr() fallback stub when (PGTBALE_LEVELS <= 4) which helps
in intercepting any unintended usage.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Updated the commit message

 arch/arm64/include/asm/pgtable.h |  1 +
 arch/arm64/mm/fixmap.c           | 18 +++++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 737e1e42f1ec0..290aefcf0f0f1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1184,6 +1184,7 @@ static inline p4d_t *p4d_offset_kimg(pgd_t *pgdp, u64 addr)
 #else
 
 static inline bool pgtable_l5_enabled(void) { return false; }
+#define pgd_page_paddr(pgd)	({ BUILD_BUG(); 0; })
 
 #define p4d_index(addr)		(((addr) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 2a0fe0b0f7710..5512521fef8fa 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -34,6 +34,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
+static p4d_t bm_p4d[PTRS_PER_P4D] __bss_pgtbl __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
@@ -95,6 +96,19 @@ static void __init early_fixmap_init_pud(p4d_t *p4dp, unsigned long addr,
 	early_fixmap_init_pmd(pudp, addr, end);
 }
 
+static void __init early_fixmap_init_p4d(pgd_t *pgdp, unsigned long addr,
+					 unsigned long end)
+{
+	pgd_t pgd = pgdp_get(pgdp);
+	p4d_t *p4dp;
+
+	if (pgd_none(pgd))
+		__pgd_populate(pgdp, __pa_symbol(bm_p4d),
+			       PGD_TYPE_TABLE | PGD_TABLE_AF);
+	p4dp = p4d_offset_kimg(pgdp, addr);
+	early_fixmap_init_pud(p4dp, addr, end);
+}
+
 /*
  * The p*d_populate functions call virt_to_phys implicitly so they can't be used
  * directly on kernel symbols (bm_p*d). This function is called too early to use
@@ -107,9 +121,7 @@ void __init early_fixmap_init(void)
 	unsigned long end = FIXADDR_TOP;
 
 	pgd_t *pgdp = pgd_offset_k(addr);
-	p4d_t *p4dp = p4d_offset_kimg(pgdp, addr);
-
-	early_fixmap_init_pud(p4dp, addr, end);
+	early_fixmap_init_p4d(pgdp, addr, end);
 }
 
 /*
-- 
2.43.0


