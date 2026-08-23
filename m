Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F665C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937956B00A3; Sun, 23 Aug 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F166B00A4; Sun, 23 Aug 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C336B00A5; Sun, 23 Aug 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61F706B00A3
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:18:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0E0D1C1302
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:15 +0000 (UTC)
X-FDA: 85132436550.23.C100598
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32F55C000A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g1iX059/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPcwKjVe7nvZQyU74ZGx+OhASVw5VhjTqdhj+ioxLpo=;
	b=0geEVegJ6aEa7CbECCluw07e9ncMZdI/wkPkvlskTcUvGuieELnT2UDxeaKpKuJkZftuOh
	h4v10aqsgPRSNpWIMIx+gyL1lowHMQIeh80AQeDLe/ODqEhwMKV4GYxScYnvIwKTZ6JAWb
	dnmgejQor99ST9IJy1mh6/NQc0qVAaM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g1iX059/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787487494;
	b=5JTo6vk2c5DQMoYAX/cf5Jj1UdfEVhlhtWsk+xdJna+xmhtupVFQdZtBUnGGYhhyO2JStZ
	8zTxpfAKX/52Dbp8QemiCdxPrBvatJQf/JQmQBLBI6aKvpy1N2kg0Y9mkhtpe/N+vcLgn8
	6kgAoPTYzXKItrS1HmVMQUSNPmjpRks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8108F4018A;
	Sun, 23 Aug 2026 12:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BB31F00A3A;
	Sun, 23 Aug 2026 12:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787487493;
	bh=nPcwKjVe7nvZQyU74ZGx+OhASVw5VhjTqdhj+ioxLpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g1iX059/4fd671ipoP1cbd8ep4SvuMjBn2cP6Nmd1GFSZz4JBgseMsWqA3UYSw0An
	 HQRWbf0n89PZVfi9hwgTvOF3htN9Dwr2umNmTOcziuGSoCxI6MrTZDkJonFATEkoXu
	 bOUH7gWOBRjroBmd9mMq+HVynUNmUXmAk3TcKzFkUV5z0NK6tKfCBzg528GuJtHtm3
	 1XHuHpTTiAWfznjJ2OKA6uRkSHTeREfiJNjVC/jBH7YeanuaqHH+/u6L0Rw0uHETqZ
	 kOywUx3JSn3XISIR1I+COtEeys1DRIiGtfh/TxvThI1iwPvEISDqM8MZJgZnUoDJ+y
	 J3FXqk71iVqwQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 15:17:40 +0300
Subject: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: 9ys8s6syo3jmfoa7wuuzapb5cqrfycn9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32F55C000A
X-HE-Tag: 1787487494-538763
X-HE-Meta: U2FsdGVkX18eaCB0GTc1Cqoy/qAlt2Vp90FLs4TODlgckMnSpZPmJbLa33ZBPXOVka1WKXyj1hSBzpOe827jWhZ0Fi9cCjyMEu1LshLEwpaJDurZ2WAyX1P38gPeWDRkEBFL9Z1Nf+keEHvoO20aHYZ8QpJ/5BqXoOJS41VkJoNF2jK2MKbiC+CIdRRHuNnZocy+tUt96as+7a1j7NHsTvcjz1/xl0fW8OQJ9UQ2fnZpVPC9nCjx/Ji8V3tHDYU/atIeD3CTXFCa0Va4JfTHA2A0YpdVpr9jIg+76rrehxcZ6LKAIn6W9hV3oKrTosjQZv2Rb44LpuY/hsklagd8iCvuOrGKQMnR+tDAz/pg7BbMXFNv+ihWZSXmK4rpw6ZfI1C8NtZttr6IEP0LuZkzD7z5PqNJvwW///BHgOHuwznF5s81zwLE3+MmHVrqXuos9vHgRRVTYtQNhJaNBE/p4cO0dQbreMbnWhEObNBNoLA/WObfh3nPPTgUcIXb1boiPvwkVgAmh8Bt/CqQY/m9qJGh0DrVChH/4np5xLjD3fB317EbhqQbfiAb5OOop5lve9m3ow5pTWY/3sC8UROJcrUq8lyi3m/iTg1OPcWRPQ8wzpROKMjUVPMhG1RK76UzDQzRe2E8XiwrM4it1sjdUVfyB2J0SwJ/oGP6F8GhhPv4yOnjee7E5eUNJKdCEDQObRZ2U5XR8/8nK8pvF0Rf2Lu2jwdq+R9u0PtzSZ34mx6tdLDhYTQQseNzHSsOWkt7Es3aVnHSyLgLEx7zvnJMvTec6ZJ6NmY7IG8DfmQflPpP5I5ZQPSZn4pEaR/mRpYwSf2rHXkw1DZzDQ/uDhKPj99RMFyDaj1YA+OJmEDS7IXDHN4tEOG1h+ffzWAP1pPeS1REd7vn85deaf/owH2KCP7Icpvt3+K10ZgQ/y3zGzlartfQlmJzg/gtcUROFwU6ZQeDphzfpWcwnz5JCfJ
 LMhp44oF
 9+SUZ1/KLHtZZ4PxlrsLB7soWfoNDrTlWHtHYUTxFPRTlWj9e8UrTKcIiBGkTO2DssR5YukOYLClqAt99DSWL/wfC7T7fNJPeMMTYGq1TpHPeVlJ+c+r6ygdueYZdtZuk34dfovNfbCLVBojAVf2onzG9082ML8PVfughcUlenSnESQobLxsZzdZWlnVS6UV9YkgaJ0mXJUhceBbwlx+Mg3AWLoBuXpTxZGpZwFwGuKOBTD4NeHRlOr4/m/7ypNllL/m3uJjgO7vd/LdZiPPKYqLySgxA2bzF7TmrweNzsxxvk2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected()
ahead of uffd_disable_huge_pmd_share() and uffd_disable_fault_around()
and make the latter two use the helpers rather than open coded VMA flag
masks.

Convert open coded VMA flag test in mfill_get_vma() to userfaultfd_wp()
as well.

With every user of the per-VMA uffd modes going through the helpers,
their underlying representation can be changed in the next step.

No functional change.

Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 70 +++++++++++++++++++++----------------------
 mm/userfaultfd.c              |  2 +-
 2 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 3396d270b159..d8262e3dc134 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -168,42 +168,6 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
 }
 
-/*
- * Never enable huge pmd sharing on some uffd registered vmas:
- *
- * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
- *   tracking information is per pgtable entry.
- *
- * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
- *   VMAs which share huge pmds. (If you have two mappings to the same
- *   underlying pages, and fault in the non-UFFD-registered one with a write,
- *   with huge pmd sharing this would *also* setup the second UFFD-registered
- *   mapping, and we'd not get minor faults.)
- */
-static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
-{
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
-}
-
-/*
- * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
- * MINOR registered range, fault around will be a total disaster and ptes can
- * be installed without notifications; for WP it should mostly be fine as long
- * as the fault around checks for pte_none() before the installation, however
- * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
- * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
- * and pollute the tracked working set, so each page must be populated by its
- * own fault.
- */
-static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
-{
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
-}
-
 static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
@@ -235,6 +199,40 @@ static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
 	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
 }
 
+/*
+ * Never enable huge pmd sharing on some uffd registered vmas:
+ *
+ * - uffd-WP and uffd-RWP VMAs, because the write protect / access tracking
+ *   information is per pgtable entry.
+ *
+ * - uffd-MINOR VMAs, because otherwise we would never get minor faults for
+ *   VMAs which share huge pmds. (If you have two mappings to the same
+ *   underlying pages, and fault in the non-UFFD-registered one with a write,
+ *   with huge pmd sharing this would *also* setup the second UFFD-registered
+ *   mapping, and we'd not get minor faults.)
+ */
+static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
+{
+	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
+	       userfaultfd_rwp(vma);
+}
+
+/*
+ * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
+ * MINOR registered range, fault around will be a total disaster and ptes can
+ * be installed without notifications; for WP it should mostly be fine as long
+ * as the fault around checks for pte_none() before the installation, however
+ * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
+ * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
+ * and pollute the tracked working set, so each page must be populated by its
+ * own fault.
+ */
+static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
+{
+	return userfaultfd_minor(vma) || userfaultfd_wp(vma) ||
+	       userfaultfd_rwp(vma);
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50..32003aa04943 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -261,7 +261,7 @@ static int mfill_get_vma(struct mfill_state *state)
 	 * validate 'mode' now that we know the dst_vma: don't allow
 	 * a wrprotect copy if the userfaultfd didn't register as WP.
 	 */
-	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+	if ((flags & MFILL_ATOMIC_WP) && !userfaultfd_wp(dst_vma))
 		goto out_unlock;
 
 	if (is_vm_hugetlb_page(dst_vma))

-- 
2.53.0


