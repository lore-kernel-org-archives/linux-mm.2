Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C65606A338
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=TYnrQk/k
Received: by kanga.kvack.org (Postfix)
	id A16BA6B05B5; Fri,  6 Nov 2026 21:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6BB6B05B6; Fri,  6 Nov 2026 21:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD0C6B05B7; Fri,  6 Nov 2026 21:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 492D06B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFF8580287
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:31 +0000 (UTC)
X-FDA: 85406741742.12.39DF599
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8471280004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="TYnrQk/k";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018570;
	b=4ttRt3LcUJFrtpIgiVyJwbFCdj/ZEBg+4ZOZkq1HHyzkrPM/zpSYeq7eGUYVb5rdNyE8r5
	RgDt9EaL5yK5JOlEVZro/SyX23hzwrthZSjJ9QSW8Q3NY776A8jFpPZ/R5t5E0L/+eiXaO
	ew1bMeBw21qwbezIJeBUUWuTCrb8qac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="TYnrQk/k";
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgfq1TjYmlVgFdPNAKA7e1QHh8SvaKABjVEcbQNBC1Q=;
	b=jey1trdDv64LkgH/9ElNG+E5k6MII+9ISLh/rRK7sWge/oBp6j+sfGXvR2v4zjXIKZHVcA
	RAf4BMgW2+BlFtGtfASXrLKLWLdykDEWd74zuT6ZXB3GxpMCJOoo/28mlTNjtRG+41MAoe
	LKS5aXQ4xpvMoiWWBtZm9zWpHfgWcn4=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so1981538eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018568; x=1794623368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hgfq1TjYmlVgFdPNAKA7e1QHh8SvaKABjVEcbQNBC1Q=;
        b=TYnrQk/kPU/SgY2aFlL2qGmp0h8WifDl6bXrAneqqKyhqj7hg2M5Tk8zgsxpZImhxz
         W3Z4rbXT0qxuLS25M5z2bYa5huPjum4xRf6qoe1vaAoK+BKDr3XpPhrxfIJNxluWnuji
         lCubFn1XZ2ldOw+LFWVWXuC3n4pZydJNOpazDZHyPOdIugZVEKfN2HZlYOhVZegcYtEH
         P9Ssam3Wm+dxALMTWTNRD+uCHjJPGJDly3j2THYQoWKvTeSBEcQhe9FFDeeEPGKI3i2j
         zojvdGkrvzd5H2zhklGFYo8l9iWsq6r+uAdFAw+SMo1d0jC/FHyLwHK7NG8A83k/cCJt
         ezPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018568; x=1794623368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hgfq1TjYmlVgFdPNAKA7e1QHh8SvaKABjVEcbQNBC1Q=;
        b=A5N16cK1sIg2VHQ4B3ErPIFYC2gvFGL9gS4jq9dOuHS6+fwW/Xis+Ch+aJTaV/PJay
         6fSTlNw91Qd5AkOeyN3CMqKc3WAyzGwOG5aMf3rD/n8v04N+8OoyamCGfere0np/uT9l
         ESYNtpqNGV5cgZU6M3Z2CofdqYU8WUunwkE7w1ThHIgCw/LKPE1XzeXmz8L89OOT+czI
         L9j6PnW+RsaM4tkV59VVper2CwOcJHgZrKA1ExAJIuhpD6vyoGyVcLUd6ezRu9MJZLbf
         iOdl7mCNsig8uuUP8AIs6+ZYynwsEfDGdCWBx3YDeMMt9BhgLZfyP2t9Iqr6VwpidcO/
         scpA==
X-Forwarded-Encrypted: i=1; AL+hErEC8izoHB4OeBsSqmHiwzXHILCwvzLhndF94IUc2kl+B1l+lvVJi116zVPPPNfSleWkaQhl4eYfOA==@kvack.org
X-Gm-Message-State: APuU4Z+s+ESTi6ibg+8GV7DtuxKq9agn8HPSibBIXadR9MrLun/LR1L/
	Yryp7zSeCaKWcMsPSCs7doSLlxuKtSirEli5iASGVrhVqarHxipR+GzKACi/YSWvqLE=
X-Gm-Gg: AYBFou1eGnA3nTj5sP14Q4reEm15PT3pBCbSWrcheKaQc3k5ZiQpDxNg2gvl/0YhfX6
	wyuIZpMQG98gTXLmUmWChGhlr4EyaHbOB6qI2lA0fROuxsCOUdj/HzsDPoLVkcKilC6t4u2s8iZ
	3Dk9zmoUNMrfUIkbh12EfSmQZ+AJGwdT9ioAcIvfEtI6g1Bo5IsL3ugQ6ib86qDiYG6AdX1j36C
	JCi0hIhdx4KCzdpjKhk1jZqiWyc+iEX/sihqqMgntMV3S4v07WLvA3N7ZyJgMM4oOfJ1KwyzFEM
	LdLApRf+EcXTAnKApQ8GttoVkWF5tG2tIzgmRHDahJmX3lpFpp2bdMQId3b8OIr8NPQGLOclJnt
	yNFLfxU8YweyieiL/YqaL6loNywhom9LM5ULv/AksWhykBunt0LeHmHglgpuTCByktxHwU+JNOx
	zkyzW9an2yJWPzMsNDRpjlzKT+NN/2tdMr5I2AkeFbmQMfKP7usA8gYULhAVVUDZUc2WVXZP3sd
	QXN4FIyBpvTi5zO+XYMz/FBlPXl/AL8DHBNGdqeP8101/sp0DA4LGlJ8MKMefUsXeEGxWE91Rc0
	9OPxrtli6wj+lhicaDtHt+hCi8MJtYSyk3K6wvo8qLVQGlWoGeq2qW83wHFX
X-Received: by 2002:a05:693c:2291:b0:36a:3453:a356 with SMTP id 5a478bee46e88-36f770080d8mr5918729eec.36.1794018568140;
        Fri, 06 Nov 2026 18:29:28 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:27 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 03/13] mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Sat,  7 Nov 2026 10:27:46 +0800
Message-ID: <20261107022756.77731-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zk4y4c59qcg818irha8hhq66ofrycn9z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8471280004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794018569-955327
X-HE-Meta: U2FsdGVkX19rgJ/mtm0e7CWjGKvhuN5S1TvAL/4uvfRYb8Nng3XADJQeDkqTSWOvYIe+uq+AfLvhPiYpg9mkuKTN75DiWNJTYTDLmbbKRqdlXWfZ5tPwbLwrNOLbGyV9TMDmrMaS726wWweyZWngARoXyFBIFfdjvgIxnh0C83PljTcgW+45QSjwjBQMZmSektmB9eU5RVcf3b8v4VoXd/98PGvsUgO83T9OYOYChruVyo+sxhO4SFMEYmnQ+3HuqZMBc3N2YpVi54FlwOQUFUBHwTKm8CkbwXo/A9yTgibYNcAyEzQsDXXXZFSq9WtPQ7oG9vKVGSNapCqdDeADicctgML1Be8bjpYmIsc2CLHSs2IsDwtZtqS4ud3OhSNzAYTJX47gKn2AVAUPJ9zsA5M8+YxmJOnwtlg/JmxtspaS1wO8guEyNmeN7CcRvU/v/5IQQRkiRUkPCGUYfgCTQvii8A8AXMi/AO6TZ89TuE8xrxyOKDgJQUyHQxiXeMq+/HhC0ir+dFKQUZGY3vJqKkCWeSWmY6x5NKxLz7pbH5tB/umq6fri3xkPSjsLBkz/IheNHUpwvu71ruKDKzXSbYo9YXbyb2PFge5VglH4/AIWUrm0zdtnNpjcBDPEkODlqiwHPDi1P1YDCfhCdhpQb+hXxGggDdeheYbdErAmBQ9pWEcll083wkogVhz3muLbg4+o/Wzpguyr25NQy9n9rn/LURHbbOZFK6OmkdP1+EOzkGMWtWCphGSnV+pQZWNW3zM6caVl4hW5aiUsI5jVrDtzTx3cJ98rACtJbwMNOmDI8HR+fndmboNe6SdDbGY9Jxy+YY3Lpe4/BKR2aJr3D3e+uu9VlnM5Xuww9PGOIzYcpZp8eZRa7mD9F39OpoOfqV5VTaeuGYQVYq9+lgR1FlgzTyT7uz8P9cOHGm5w/CDbr1lxVgehWb13pLkMxHgATF/ogoioZIh58kRI0Fv
 cF84bI99
 ygOuj1GiM4RtLHTuYy79j19cMVErUJgwI+yxzdPmD6xMa2Cyi+QfxPJaEX0pcvrlEH2kwx4SebPZ+hM4aQafKAdM2ypdPXLpzLNOzHrj8QT1059pdXJ3vryWyAiTAUrcDWL/52SZolGJZR0ACrlnAV8AU6FovmNaNE1njnqpmE2ZHKwazOUe8zl/CL55zDU6FWlTTOwjYkURkseqpKmsG+lakNOA/0sves9Arjl2mNMo93+nC7Pqur0syuKUEmEF6iHhzesYiIMk7cQwpR9kQaD4MNBn89jxKENuyqracA5uI0Kdhgefg291OZmOCcl8jVRZfj6dtD4ICoUkkLwsJOL8qPcXIWqZZY5WUs9zjVdQGOAqLT85KdSkquBSsSFl8lwSSbzL/Vnzv8pxP37xhkiZNz0AWetS/b2e5TZKJhNCVL0GL16iM1Nr3rM/UoH28oUB/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
describe fully independent choices. A split-only walk can defer the
PMD-split flush to a later global flush, and a remap-only walk can
defer the final remap flush. However, when a PMD split is followed
by PTE remapping, the split flush must happen before the PTEs are
changed, because stale large-page translations must not overlap with
new small-page translations that map different physical pages.

Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
new name reflects that only safely batchable flushes are deferred. Keep
split-only walks able to defer the flush, but force the split flush
whenever a remap_pte callback is present. Callers that batch HVO work
can still defer the final remap flush and issue their own global flush.

Current callers keep the same flushing behavior.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Collect Reviewed-by from Oscar Salvador and Mike Rapoport
- Collect Tested-by from Andrew Morton

v2:
- Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
  comment (suggested by Qi Zheng)
- Update the commit message for the new flag name
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e51f079f43e1..c436db31c6c5 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 
 
-/* Skip the TLB flush when we split the PMD */
-#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
-/* Skip the TLB flush when we remap the PTE */
-#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* Defer safely batchable TLB flushes to the caller. */
+#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
 };
 
@@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
+		/*
+		 * Modern MMUs allow overlapping TLB entries with different mapping
+		 * granularities only if they map the same physical address. So
+		 * remapping must not proceed without first flushing the TLB.
+		 */
+		if (walk->remap_pte || !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -166,7 +169,7 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	if (ret)
 		return ret;
 
-	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
+	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -274,7 +277,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
-		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
+		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -458,7 +461,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
@@ -517,7 +520,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	/*
 	 * Very Subtle
-	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
+	 * If VMEMMAP_DEFER_TLB_FLUSH is set, TLB flushing is not performed
 	 * immediately after remapping.  As a result, subsequent accesses
 	 * and modifications to struct pages associated with the hugetlb
 	 * page could be to the OLD struct pages.  Set the vmemmap optimized
@@ -596,7 +599,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	struct folio *folio;
 	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
-- 
2.54.0


