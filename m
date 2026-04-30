Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FAD4FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B286B0088; Thu, 30 Apr 2026 07:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1253C6B008A; Thu, 30 Apr 2026 07:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2EA96B008C; Thu, 30 Apr 2026 07:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD4776B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:31:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FF75A0161
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:31:58 +0000 (UTC)
X-FDA: 84715007916.04.931EA25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9CD51C0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:31:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PO7A+Z6C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777548716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7rgaagdvk5X+BPhver7PNTAkTh2XjtdqtERugOJknd4=;
	b=ZQmVTfWEZVW+98GrlvwzXI819wg+0FSylbKPoYpj2mA3PR2UP3qQbqxSchacQRdfl5o5Xm
	vMz/XslVG1jB0yX3lg1PiNT/aQH4GL63dfW7MnVBANp+yM7vDmFH/zSSOXoCiyPVQfV3WQ
	ypXiu6+hJQ2FwrjhXtQ3+Ki8y3DgUR8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PO7A+Z6C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777548716; a=rsa-sha256;
	cv=none;
	b=WiYGJ38PUcjnIR1f/Igt8M67p6sR5hFA+4NSFgyLzzsQ83YYOajA29AenzATTdqhr+mRvU
	oegqYs+mD0evPSIVIMc0wvQ90y8A5/5cK+h+aCQPygBQCBSQW+FBiZ8t/5cnXuwfD9faYa
	CMR9tvA5WFDMTxkgMAKXWGEG0kNNHqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C5756057A;
	Thu, 30 Apr 2026 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68341C2BCB3;
	Thu, 30 Apr 2026 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777548715;
	bh=GAVeUYrfD81Vgxhl/4MJAOtYKmr0cjXk10/5oQ2nEDM=;
	h=From:Date:Subject:To:Cc:From;
	b=PO7A+Z6CSYSyfV7aQwYqp2SRHmj4kkRrsddLZMzbjtkDjEPu33pdvOLXg1x/cq7Ro
	 tVFeT6roiky4eZBekVtFBAkyN+CpbWOyix2h/s5uO9+He9dYFBy4MhMgso2xGA9nnC
	 z+2VpX4usUvmrArf3ScDgAmL0hh+fukLQ/dfr0SctDhJoRagc2mPhDok1GVJI5Zvbb
	 hM96Jg//w7p6me4AW8RaKiO33otuDKipcx8MzGsI44vVitn8C/mdcvK9NFLnH28ADM
	 QUFx638NESL+SkYYaF4pWrVrk/viM6e2oe6zL9ngteF0RcmTybjp6H0wkODsxZ6Pdj
	 vQKkm8itzQPLw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 30 Apr 2026 13:31:22 +0200
Subject: [PATCH] mm: fix __vm_normal_page() to handle missing support for
 pmd_special()/pud_special()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIk982kC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDE2MD3YLclPjigtTkzMQcXTNDg5SklBSLxGTjZCWgjoKi1LTMCrBp0bG
 1tQDlEi9iXQAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9CD51C0009
X-Stat-Signature: ymkc89tmayoazzaw8byrunc5as4o6wmy
X-HE-Tag: 1777548716-260605
X-HE-Meta: U2FsdGVkX1+uFaWOsnltP8ym2dr0fN3ho7LIOd3QTWuwKQC22rBo/RS2inS8stnABSD2Ade+JYcAg9UjXSypbJ7LFNt+ECndibjxpMwavo6pHdp9/eG+vYcKgJ3/4KWog6AMzMZtaggGayQdLyKVkWxb8QncIVeR+v+OJ17GkOj2dB0IBnBCgC7LNJIG2Fv82/JqBWDT/wOK/n91sWL3UHpisGTH+SdTq+N7uruFOmGTz1pmu7JBXP0Z1ylmgtWGZGkfgFOsPgC9WG1IsMmrH9f8TBCs4C10WDoeqjjpUKeusVvw1DqQ9Hw+9v+qtW1ydoZNhu5/IaH83niE6cId0mqnXg7EhENshsnEUtHpD4NXEfUnclJrvaBKbi/NmVKq/VITvshZPHIjQYrf1WHz5EGTMoWBl0COszGmMUZZKPiRJ0VYnV784uCLiACgqZRuPCInvYuQoI/cGuJustBTg4bTWZYG19qKb6DlDpZEWXpdaaEgo0G3paIcyqtQK+eImuN1cTbd5hlQB9Qc0Vn2vRXnIVGNfJJjBf+qG2jVVaMEf8osucrS3fsZt9xvuyQ6swoRIkqran64LT8Hir1MWfX3raZpA1tY0sNB/fE4+ECWBNZztvd4NmijTagwfNahjD1rMRXr/z/C2YGn/tjwb1BIs9zaGCNA3vh4TTix1ddyTucYgrJxLOBIJcp0yyI9qFoYSzet9WSONKt9JY+QMldAdqiRpojgwWD4CSKBNmFK7FHTBVYDu4OTAlJHJDcEaATtHoD19xYIPziNFh+sI2W/eqpbt2IzjiyTUkoM97d2PqL9SpALrrodq4SYpqlbYPqjulo95WYw/akNaocZS9qbnRJvsNwJHrGec8RAMinLklhGREfGSuflf0wDg9q9UN4o1nbN/VYu2VKQRRK0Wo+DPXwNrE9jCbzF13kNit3mBuxc1yduKoILfv5fPzHkOFUvXFTar1DQ3nY2YVB
 SthUupN2
 CSA+wsEQVa2WRFKXz2/qgfGmttbl/snT8OYqd7rcuBsdClhu5wZzchHDLsBlSifRnIzUrTA28pguCXWb7678LGAxg6g5Ry3Ilb1l7g087qHShVu86HrFKtSf0d7Hfm+gCCeVEwSDH3qi5DfX1xTbhlPqZua9E0feMgDZnYkCxaWh3NxOFjt1N3Z12kTC8Jk0VOib6YkhxDUBO7nDud5AeW7ZWGEAusM9FgLwa3sm+EJsOgw6nErB3w5A3EWOGK8vDthLXVji7tCFE0/5E9fybY1p4BLmweR+FjjN5AwsY4dES9SdmWVafW830DA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
when reclaim gets to call shrink_huge_zero_folio_scan().

It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
and indeed, whereas pte_special() and pte_mkspecial() are subject to a
dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
on any 32-bit architecture.

While the problem was exposed through commit d80a9cb1a64a ("mm/huge_memory:
add and use normal_or_softleaf_folio_pmd()"), it was an oversight in commit
af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
and would result in other problems:
* huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
  numamaps as file-backed THP
* folio_walk_start() returning the folio even without FW_ZEROPAGE set.
  Callers seem to tolerate that, though.

... and triggering the VM_WARN_ON_ONE(), although never reported so far.

To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
whether pmd_special/pud_special is actually implemented.

Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
Reported-by: Hugh Dickins <hughd@google.com>
Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
Reported-by: Bibo Mao <maobibo@loongson.cn>
Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
Debugged-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Bibo Mao <maobibo@loongson.cn>
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
This is an alternative to Hugh's patch, whereby we leave pmd_special()
be a NOP and instead teach __vm_normal_page() about lack of support for
pmd_special/pud_special.
---
 mm/memory.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7322a40e73b9..4d84976fc7f4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
+
+static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
+{
+	switch (level) {
+	case PGTABLE_LEVEL_PTE:
+		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
+	case PGTABLE_LEVEL_PMD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
+	case PGTABLE_LEVEL_PUD:
+		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
+	default:
+		return false;
+	}
+}
+
 #define print_bad_pte(vma, addr, pte, page) \
 	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
 
@@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long pfn, bool special,
 		unsigned long long entry, enum pgtable_level level)
 {
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
+	if (pgtable_level_has_pxx_special(level)) {
 		if (unlikely(special)) {
 #ifdef CONFIG_FIND_NORMAL_PAGE
 			if (vma->vm_ops && vma->vm_ops->find_normal_page)
@@ -699,8 +714,9 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
 			return NULL;
 		}
 		/*
-		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
-		 * mappings (incl. shared zero folios) are marked accordingly.
+		 * With working pte_special()/pmd_special()..., any special page
+		 * table mappings (incl. shared zero folios) are marked
+		 * accordingly.
 		 */
 	} else {
 		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {

---

base-commit: d94322006a51b522dd361128a450bf9e75aad889

change-id: 20260430-pmd_special-610dbdd8ac3c

--

Cheers,

David


