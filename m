Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5442F606A6B1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsZvT1vj
Received: by kanga.kvack.org (Postfix)
	id 62BD16B05D6; Thu, 26 Nov 2026 06:17:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E026B05D7; Thu, 26 Nov 2026 06:17:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A34E6B05D8; Thu, 26 Nov 2026 06:17:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD806B05D6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:17:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 989DDC03DB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:27 +0000 (UTC)
X-FDA: 85477019334.09.8C4076C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E0F4F1C000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:17:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lsZvT1vj;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691846;
	b=ApbCylDza9NsyZqcdmCAItQAs2Bk3Z6W3oIo8VDpvYm55zB1jfs9KeJlhKyVh7XA5SkzQJ
	JCn+i79v9ohroQdkMlwNr/hZtBFpko54/JGB/0S6KN5IOSslw5XpJCyzuN/+SScORbf9dj
	0LYpEhjjj3pkw4ciUXWDdW4pWo7p1Tw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DoNm9BxMiCQEr+qNjgywS01tQK5uUyYap8n/VDfFq4=;
	b=4N/yYZ5bHFtFi7jJ+KH1IJUlcQiDdRhH6nk8qyWauUZwIiKnuEWMycUPexLvsQZ67NmBF8
	Z0M5BQmmNy5p1JksdsEOdq9YLe3hojULh1drsRciqMQZExoijW64Cq8so0pKp2MnBGkVSy
	9nHkROqaeyM6CH1dsmcXHZBkRZLvefs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lsZvT1vj;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A36544EC5;
	Thu, 26 Nov 2026 11:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8265A1F0093C;
	Thu, 26 Nov 2026 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691845;
	bh=5DoNm9BxMiCQEr+qNjgywS01tQK5uUyYap8n/VDfFq4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lsZvT1vjJ/BY9sTlQOvZYhVIq610w41r/GrWTSFBkc8Hn5MspOrOjbMVeN6Z5g9Ps
	 StHuwLpwVe1sqViKqK5rwJvNfsab4i10QpGgmoWRUpvZ0ZdHh5p1zC+DlzyDW7jJFh
	 ycSAiUPw9f4VQjltnizOeWzjcQXBt34T2JUF/n+LTCgxTcP0b675rE/QXn++VbbyjH
	 mEyk5cjy5y35X01PvcgUdscO++kGzHYNfut/I2oC/MOGODBPn4Q9CesZac+BwKrTdi
	 yWNv9RL/tL0sHZkybp6sfBNB3+3kHeVZI0f7IB75hUGO43/nFfIIyo5KtVdXHjoTT/
	 Gv8qIAENkH/7g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:31 +0200
Subject: [PATCH RFC v2 18/54] x86/mm/pat: consolidate encoding of page
 table entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-18-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0F4F1C000F
X-Stat-Signature: cergb11mrt43jakzkabtaaf63bkwn96y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691845-353030
X-HE-Meta: U2FsdGVkX1+q5IZpLcYQSrVaFoIAqwRKI3hdUMhJvA/4W3XT9+DxVTX4Cqemlcx7OVKG5HoiY+dXZW05vRwh6Dh4yuOj+MGRaXOeqBKtbd+EFGxGSY7GZpdkiQJ7nW8KhuwiQrCSi4nZjVleeN+GbgLPOxo5i7nGnBkYdwBNFfOhr0rOlH7m3c1smY+qGIIE3IXOvmVaypI3krZXqpchh24AObz68Y7uh0GEmHAiCcZ6Fd1j6uVi3YBBKaDwlAPiAIm7CgJUBto5e6rOvJKMQzjSx3sRMImtR+4/7XOAFrRttla+TIft3RB/NTlS/E+vrCEey+GvwJNMeDIjkwwK/MLFBvy03ygtfOROlH2UslAg9W8lrO7BGMHnQOq1eiB3DEPQk5t4JABX+yVa6WFq2b5iM0EJ3m2hWPcc1BKzD8LRFMLMvTkcC+RO3ZECIbG+dBDewmny/95FanYhfdGlvluuwG4crb3RxVoPckjaztPIkah1Cc60A3kjghk9X+nSOGgVviSxp7ALzvVlZBb67PpKeod7rPuTC0TOnSCwA3V+Y7E5sF6DZdUt1ek0vG6qWEWVzo2cHjaTapCsS69IxambAmvNtkHTzE4mEkobqWfeMtNANEefTj5ETS1rKKhblRptCBPRYrLABnGjvDIlAvkdU0HvHNlYddtIMtAF9T5qXI+t80yCAzs1fJuFmXwDy6Ti/F7VH1TFNb/lhGjdUg4ewuguvCtg0TRFUELYeaUXgmdtI7e3b2SZBk+ImcgprVF4jLA2qFHVJR8U/z6mrGTb0Hog/7ctZlpvcZrlpo0aAWifRuFrfnRakUirdtlcRZQYBXu2p4f8jvqz/cH1U6WVxNumtw3+ZGWLOmIKoknfjFr3DUXwu1Qki1Z5C64PvNKYsde3N4ULNpGm1UK7Jk6ZVzMFGg0aF16aOv2xNmJCmDMj7m5Zlh1/nqMlgAdUFLMOOG6/50D8g4Hh6xT
 AVlQGpqy
 ueMfFFF206ZXa/wcdAfQjzo4TGbVgDMplhnAU0AQi+bqUg9R5AwnKp/rg6KEc4cm48YD10bdGMrAmn3mziYIB2UWtLxwrwRn0XFbbduXxqUbv8HZGOf/i3NYOsm1HaPYoAr2yTb4hu50phhsZbKT0V/mZ/UVfZhw0nVzluC4pnTxi24b9Lza1dMksQL1iBaDSVyOTeQreNhkZSH8RPdMr9tSFjJIi9Qagi09k8NU/qz6SFAl/PL3snvWY7ysPi06vVfIMDcRhx1oqRv9xu+5yGdhYdBYtN0QAJKHtJwbwmR4KQfIJ4QWCYZ3S3fCcU/7ZgVH1TpMwxakJa7GVXCbDHKoZlwk/P3o/+u9+oZiXzFGiiGKuBDF6LfSjEJsREscxDj+yqf89GT/BhLWt/ZxRM1Lo3XJS+x3q8mW6WIkgcf8j6+CP64ZqVJTG+KuLUJqXh10xXshyISXztPjaOTiYHEMeJxosG69Onk7N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CPA encodes page table entries in three places: when it writes a PTE, when
it updates a large page it keeps and when it splits a large page.

Each place converts between the PTE and the large page formats and fixes up
PSE and PROTNONE.

The split of a PUD does it differently from the split of a PMD.

Add cpa_pte() that encodes an entry for a page table level and use it
everywhere.

The check for an unchanged large page no longer clears _PAGE_GLOBAL when
_PAGE_PRESENT is clear, so set_memory_global() on a non-present large page
rewrites or splits it, although nothing changes. Its only caller changes
the kernel text, which is always present.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 48 +++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9ccc08cf220f..068ab1e2bbc8 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -969,6 +969,24 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 	return prot;
 }
 
+/*
+ * The caching mode includes the PAT bit located at different bit positions
+ * in the 4K and large page formats, and _PAGE_PSE is only valid for present
+ * large pages.
+ */
+static pte_t cpa_pte(enum pg_level level, unsigned long pfn, pgprot_t prot)
+{
+	prot = pgprot_clear_protnone_bits(prot);
+
+	if (level != PG_LEVEL_4K) {
+		prot = pgprot_4k_2_large(prot);
+		if (pgprot_val(prot) & _PAGE_PRESENT)
+			pgprot_val(prot) |= _PAGE_PSE;
+	}
+
+	return pfn_pte(pfn, prot);
+}
+
 static int should_split_large_page(pte_t *kpte, unsigned long address,
 				   enum pg_level level, struct cpa_data *cpa)
 {
@@ -1018,16 +1036,6 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
-	/*
-	 * req_prot is in format of 4k pages. It must be converted to large
-	 * page format: the caching mode includes the PAT bit located at
-	 * different bit positions in the two formats.
-	 */
-	req_prot = pgprot_4k_2_large(req_prot);
-	req_prot = pgprot_clear_protnone_bits(req_prot);
-	if (pgprot_val(req_prot) & _PAGE_PRESENT)
-		pgprot_val(req_prot) |= _PAGE_PSE;
-
 	/*
 	 * old_pfn points to the large page base pfn. So we need to add the
 	 * offset of the virtual address:
@@ -1048,7 +1056,7 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 	 * required independent of alignment and length of the requested
 	 * range.
 	 */
-	if (pgprot_val(req_prot) == pgprot_val(old_prot)) {
+	if (pgprot_val(req_prot) == pgprot_val(pgprot_large_2_4k(old_prot))) {
 		cpa_inc_lp_sameprot(level);
 		return 0;
 	}
@@ -1082,7 +1090,7 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 		return 1;
 
 	/* All checks passed. Update the large page mapping. */
-	new_pte = pfn_pte(old_pfn, new_prot);
+	new_pte = cpa_pte(level, old_pfn, new_prot);
 	__set_pmd_pte(kpte, address, new_pte);
 	cpa->state |= CPA_ST_FLUSHTLB;
 	cpa_inc_lp_preserved(level);
@@ -1115,27 +1123,19 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		ref_prot = pud_pgprot(*(pud_t *)kpte);
 		ref_pfn = pud_pfn(*(pud_t *)kpte);
 		pfninc = PMD_SIZE >> PAGE_SHIFT;
-		/*
-		 * Clear the PSE flags if the PRESENT flag is not set
-		 * otherwise pmd_present() will return true even on a non
-		 * present pmd.
-		 */
-		if (!(pgprot_val(ref_prot) & _PAGE_PRESENT))
-			pgprot_val(ref_prot) &= ~_PAGE_PSE;
+		ref_prot = pgprot_large_2_4k(ref_prot);
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	ref_prot = pgprot_clear_protnone_bits(ref_prot);
-
 	/*
 	 * Get the target pfn from the original entry:
 	 */
 	pfn = ref_pfn;
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
-		set_pte(pbase + i, pfn_pte(pfn, ref_prot));
+		set_pte(pbase + i, cpa_pte(level - 1, pfn, ref_prot));
 
 	if (within(address, PAGE_OFFSET,
 		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
@@ -1833,14 +1833,12 @@ static int __change_page_attr(struct cpa_data *cpa)
 
 		new_prot = verify_rwx(cpa, old_prot, new_prot, address, pfn, 1);
 
-		new_prot = pgprot_clear_protnone_bits(new_prot);
-
 		/*
 		 * We need to keep the pfn from the existing PTE,
 		 * after all we're only going to change its attributes
 		 * not the memory it points to
 		 */
-		new_pte = pfn_pte(pfn, new_prot);
+		new_pte = cpa_pte(level, pfn, new_prot);
 		cpa->pfn = pfn;
 		/*
 		 * Do we really change anything ?

-- 
2.53.0


