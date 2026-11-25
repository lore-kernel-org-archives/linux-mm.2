Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0990606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iiAXZPlE
Received: by kanga.kvack.org (Postfix)
	id E77A46B097B; Wed, 25 Nov 2026 05:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E022D6B097D; Wed, 25 Nov 2026 05:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54ED6B097E; Wed, 25 Nov 2026 05:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80FCD6B097B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:01:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3404140E02
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:17 +0000 (UTC)
X-FDA: 85473198594.18.FE837BA
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id E066A100007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iiAXZPlE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600876;
	b=4ehP4J2BMP+YYy3EnGoAoV6abYmY2tqwlUu+YHBmkENVg+8blCMb2nBWxZvwnENmLhcSJz
	tyMIyeZf0BkgHstMLuosvSByQAUsOjcn/ML2f/+Xsb50lssb3+/XNhzUG30xN8xPVjoPqg
	OTgM0hGWa+FgilhkVkdwhOuBCQLKAak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UvC3kLQVk7Jos86IsiNdep9C/zypw0aYvzz+vz5suo=;
	b=SNuJ5Ri8N9u+QKzSgqSyHG8uSbhNhOJnziOIH5FKIPLPidhJ60JmJtH93Da8zr48HUaCJf
	+KKvr5rTDXUFRRccTyQ7THRjNuat6cUoM8FU6jqLxLgz/lspqEp3jc/c13vZfi+uK1cFAs
	zDjulnbNyIT9UuIv9K2jQHwc6dRUWE8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iiAXZPlE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so71330605e9.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600874; x=1796205674; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7UvC3kLQVk7Jos86IsiNdep9C/zypw0aYvzz+vz5suo=;
        b=iiAXZPlEErKDp1E00CGz99Y75hf/iF/UqvOFDM8NMz/Uyc1az400cvfzE81JrBZlww
         OSYEf9E6V1lJT7iGxIJ0QChdWebJEaWHwsCSbcBGO61Z2JEIhV25dbmkZY83mYbqhXZ7
         rZqxVAsdvArpNOJXRtmcf+tp4p+B79KIgTp9w5SLopt7zkS1uGKGQHGtgQIBuLtb/0Rq
         PhttNmRJXZhCN3UgTOD38O4EaKCvzO+YWWaP8PcDV+7OlzuORyjIj3fze9StgCLf38ZJ
         3d79VylKeMaOUwY83ftZedXKZ7nywCSr1NQqHRvyk3cKRZuNZa3JtoPZ3ropQ80yKyyD
         To/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600874; x=1796205674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7UvC3kLQVk7Jos86IsiNdep9C/zypw0aYvzz+vz5suo=;
        b=mgkbEcSFIH04ePI4Gk9xhkkFtKVg2+fdximwirxsaFrejKiWJEuSOT40blRY5rlQ3W
         YFjh9jaCtgugNgLhfU5CR5E02Awuy6Sq5cYBWfoaryd+sbQZsFvH5Aq1JpugsSM+hh6K
         8pvoukXCHrAbFVlBr2kpHkvkcHDk3/AYRp3RhPmbYZ4OzAle7UfF1lxAcUVM4F2iQhIt
         mhIWgXsKfl/Rkib+KxsSOCiVJHKrpP2yeOKtOqweyjKfoP2jvYtACC1JIZyFYf7beRhx
         ofn2Eiiun7e4780caBSYwocgMo0x3plVplXcT0UknJIkHQX/PQz5IZoIN/nQqlNua6o1
         nc0Q==
X-Forwarded-Encrypted: i=1; AL+hErFsN1fKGkgiRsfuVKI3CsXqHqG+3HxX8Grg9N+/klMm/ZN2DbWBCiYAujLks+ZQGLFrHf05U08jDA==@kvack.org
X-Gm-Message-State: APuU4Z8w8HBp6HBH+BZxDU2pM8Ekdn5M0wX+Wcy28InYoPFJMsU0qswF
	/wbxq1+372/bLPmVatFUfuQ4gtEi0/nVVmcNH3eIUz3B66UcbKRLqUAD
X-Gm-Gg: AZFdTZfb3Fcw5v/mfOul+1b0bx4WyQZ9HdoHnfW0WMk9jMX+8YH6TI+v6lA5/2GWMiX
	YodB4uz9CVnnB1pmD86NIN0XH9yjHNUbtyQIg4BPT4RWU6TN05M0xRHukdeTEjYvt0vH38wd0bO
	lHQHn+kYvEOZnARkT1D37145Nd8AE/nOPpwxCW1FE3mkm5zlkb3dj2FMFj41HwhCQJwvAQPjEQF
	gftSlOTuMNhkzsPFR6/Qi58do9Nc/ZkPNXSXOQPALxcjjqRRlZxDTbjfDbVjZmyRq4vdfeSl7WG
	hrxiHhfwB61Ine5h6F1q+925JRO21stDHrm3mlhsM/KWUMnCre5YWCfMhYgjtyehQHVmbD0Abgf
	nptrcGnLpYhv8kd2mlBAsbRCxNMNnguEUh1l7ehX3wWiJRGFPvEXVGqAYgm0bDbaMWEivQHZw2v
	xyMD9ed217J3Nk2A1SeBKTk7gncz4IN2Dy8G84gPuNI7yEfV+ScM75uiqsvbsBdlTU/8qYk/9yY
	X70uij0umjEFd9G3FjxlmOV+cRSwUD3k0A/xQg7zalxEnhX5LakHh2YPkjrb3dmQSk+Tue7bqo9
	0KaVxoLv8u/GSA==
X-Received: by 2002:a05:600c:5901:b0:4bb:5e8a:7c9c with SMTP id 5b1f17b1804b1-4bb861467c8mr304008495e9.7.1795600874476;
        Wed, 25 Nov 2026 02:01:14 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm423898125e9.9.2026.11.25.02.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:01:14 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 3/4] mm/memory: never allocate a page table in do_set_pmd()
Date: Wed, 25 Nov 2026 10:59:46 +0100
Message-ID: <20261125100058.15200-4-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125100058.15200-1-azpijr@gmail.com>
References: <20261125100058.15200-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r3zui8h68yotnp8u81s5f81uteo53fjh
X-Rspamd-Queue-Id: E066A100007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795600875-524985
X-HE-Meta: U2FsdGVkX196fMmxeNQwvplgaD3fxX7eSmVXNJmDFrzLild4RzRe/J0PHvcnZSSqkQQIi8AN8JcUTnFdGFFEqXx/9r5x3eERNfnEnjIWb/RynjLSkfvKV4iL2ncQ8daeKBppSKFqYLOPQoqi1Ti90LnjZalPgJp2Xdj+7cVcM4sOsBK8swbJsyO9ENDKjzlkHyXmDv1PiB5sMRnE3sbX+Lxuc5A7+8AQmrwBBCaApL9E2uVdveJjYqAcG5PL3v5Q5qKlRAEjd5oV7vldQmT8BanyTiMHXfZc7m66bmDjlTqORwOwaXPj8BkAngOzOsmK6LVcePPvcAocTC2MBG3L2qWVtJVhpcV+LpYGSqgfcB1A5Egbx2/5OOjHLYx0pQibQG9OVpacWAvreajtrxsnihBkYaPxrv4gLVe5QQ4V9+deMjF2heulE2jC42AXXnHJe4RW9Eca7By4YdWRXPttwtbWDrpM6FZVI/MFO+Aw4Q36sZpBCKVToLV/qG+1GaBH4FpwBJrGsQrwJZBHPegMk/tjT/OXJePystir2J7oNmZucTJzfMf+3oa1a08SrrT8YjOwlHpyuy3hykb8Wn/g235QqJtEhDz4cLLUt4i3u/CnNT/UVsC6pjG8i13ZW8GmkQp2gqFsWut+tStijsf9CdPWDLP7sXgOScRw6g2ArQw4LbD26bdGFVKR7i458x8k0cmMGKMWOBWlzhAhUh7BzAR99YTdAchhVeaU017MFiuFfOj/OOJwek3eleJX2gF6QTujen6bLOFLwqmwUA51QXnR54ZjyywQo6rgoXX/jvgCnGY+veOLHq3ntLNwFD3u63wFlpc56d0ATConxOhdHopGLdSAhpo2/16Mjh5NhkV7cYyhOCD5+Mg008M9zNd6NNBvD/kbfbjIgIQ0z/JI9LFymNtBxw484ic67gkwhSvCr71ZnDzR60ZKoHdgMOJzZcJdFuOEp9nG1xkz0jA
 jrvxorJi
 rQgRUwAKJS3RyolwVGvutl/++ndpnmobGoF/GB00nWwsg/RHxB/EmYnivbEFOvz+OndpyEchBFhVHYBaNU6lFQ2nyUyp3ajecFO1HD6BFlHOx4eqHOYmcbo916IvqKiFDfCReEqPIYlMoEpgCJXtcOQ6Fa26oN//05KnRJk8Xq6EX88gNKNHwDuusCT7P7jlaol6WKM4rJHnXw7gAlCUQ3XrKzNfEgpZii1W7d2bgor8Bv2CemQ0xDsReNbHmb4Rx6l4lfv66KYz1rm9xqvPOEXSgBnmi1wu9Hvr3EgWRxVzHuG9w00LlZnxtCqbZqC9v6XRfQCrZ1/JiltI8M8Y+S16GSExzYJFLGiBSheGYA/tr5kYFJFymZsExjMtHx4+d/u0ABFQhUbPSJJPw0w0XiADZQV1OeWV/TRnGq05T3bg/ISRRdPLko8hjGMJA+e+oWtydk1dtG6jP9WrBA6l2qpTjjgZMj2qxmkSZ1Cq1dTQc9++2kTZGEDpRlFN/zzagbo1vjj5WXYJIwcxib1e7VqIqRY/NsayZYuzSchsmQe9Zj3kjRuq3E+hmX43YNbInpdddutptFTEh7LZnsQ473pQLraKw7ysppKTvQtxx54+NDD8iC08KmcrSQLzH0Yne6WeZvn5+84fDBV0+O/MN+zOMHuI5Nu8c1sA9I9G9KktEEUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_set_pmd() is always called with the folio locked, so it should not
allocate the page table to deposit. finish_fault() and khugepaged now
always pass one, and filemap_map_pmd() already passes may_alloc=false.

Drop may_alloc and fall back when no page table was preallocated.

No functional change intended.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 include/linux/mm.h |  3 +--
 mm/filemap.c       |  2 +-
 mm/khugepaged.c    |  2 +-
 mm/memory.c        | 26 +++++++-------------------
 4 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d09173a94e9c..5e7044b6ff87 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2160,8 +2160,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
 	return pte;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
-		bool may_alloc);
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index d730b0ea4667..b47c25808814 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3751,7 +3751,7 @@ static bool filemap_map_pmd(struct vm_fault *vmf, struct folio *folio,
 
 	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
 		struct page *page = folio_file_page(folio, start);
-		vm_fault_t ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ false);
+		vm_fault_t ret = do_set_pmd(vmf, folio, page);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
 			folio_unlock(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e5adf6960a7b..6d2431a20bc9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1870,7 +1870,7 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 
 	mmap_assert_locked(vma->vm_mm);
 
-	ret = do_set_pmd(&vmf, folio, page, /* may_alloc= */ false);
+	ret = do_set_pmd(&vmf, folio, page);
 	*prealloc_pte = vmf.prealloc_pte;
 	if (ret)
 		return SCAN_FAIL;
diff --git a/mm/memory.c b/mm/memory.c
index b7e53d7cf6e5..8c7c6be5495a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5758,13 +5758,11 @@ static void deposit_prealloc_pte(struct vm_fault *vmf)
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
-		bool may_alloc)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5803,16 +5801,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 
 	/*
 	 * Archs like ppc64 need additional space to store information
-	 * related to pte entry. Use the preallocated table for that.
+	 * related to pte entry. Use the table the caller preallocated
+	 * before locking the folio for that.
 	 */
-	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
-		if (!may_alloc)
-			return VM_FAULT_FALLBACK;
-		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
-		if (!vmf->prealloc_pte)
-			return VM_FAULT_OOM;
-		pgtable_allocated = true;
-	}
+	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte)
+		return ret;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_none(*vmf->pmd)))
@@ -5842,15 +5835,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(vmf->ptl);
-	if (pgtable_allocated && vmf->prealloc_pte) {
-		pte_free(vma->vm_mm, vmf->prealloc_pte);
-		vmf->prealloc_pte = NULL;
-	}
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page,
-		bool may_alloc)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5995,7 +5983,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return VM_FAULT_NOPAGE;
 
 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
-			ret = do_set_pmd(vmf, folio, page, /* may_alloc= */ true);
+			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
-- 
2.56.1


