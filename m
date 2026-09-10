Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CE8C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CFCB6B00A6; Thu, 10 Sep 2026 08:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7D06B00A7; Thu, 10 Sep 2026 08:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD3A6B00A9; Thu, 10 Sep 2026 08:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 258456B00A6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A32FD1A0507
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:09 +0000 (UTC)
X-FDA: 85197716898.23.A161296
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf11.hostedemail.com (Postfix) with ESMTP id 811D540007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y 5uNEFu";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="wo/dhbxg";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkbS+/8H8cjRZTrO9cANk9swJlxr7xbA69wrjLxeH1k=;
	b=ZCffraL1CndoUBapRGGGKg4hKaW5jWEYprnZnN6CUvBxHI4+b7/nUsHLPQrFgToo4BEYyN
	ocWwRDnVdC0OeNsVo6TXyKcW9nLTy1QcB2gknNqBnbMypYG7MC7EZP9/cNPHFSoX5KX3ig
	r/nvken/hLkl9uUmMvteb9zin+qisRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041787;
	b=bPSHQGlvk7lYKyBcqbgeSlvIOlWg5dzVYDHiv1dS5Cg8PEK40QWkmgHHLWPh/36xyU6daM
	ihfeUU/4WODGB/JGnV/b21Dl9tNZuYoKoagkeA6/FB1Ic5lwf8At8VUt6MqCmKsIbfWIiv
	wkkqJ6Rm8SwXkiwet9Kvo9FsSps0AX0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Y 5uNEFu";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="wo/dhbxg";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 827641D00066;
	Thu, 10 Sep 2026 08:03:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 10 Sep 2026 08:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041786; x=
	1789128186; bh=gkbS+/8H8cjRZTrO9cANk9swJlxr7xbA69wrjLxeH1k=; b=Y
	5uNEFu9g5zI/9GZci4IlHuvqBZ65sxmy92epLuJiG2aGVsLjyFKl9EFIc092672P
	xojJI7z4z/P+ZsnRE9/aDGQQF1Wnr6Xix3HHJ2aIxS1BLpbg7LtH9ccBDr0Xk1f/
	1YBSype1bHc6pJGQPY9tmJ8G2NNg7vpf1GjTKZQwi3JuDmJ7dQOpJ79LmYHLGQR/
	aAKaiLQ+7NKWryD+2VVnh3yVnFXwiQHGfIY5NS4iUKHjVd9ZRUqH3Gu8bFfn0YQ8
	IQq1kj9qlJqLRzpxBZjt+5dgHRqF779mn8RBQ3sD2Zdk5nCAI6Ch7rxkKYotDI5l
	UKsopU1KAzsO1irtKZH3g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041786; x=1789128186; bh=g
	kbS+/8H8cjRZTrO9cANk9swJlxr7xbA69wrjLxeH1k=; b=wo/dhbxgqF0vFveNO
	w6Krudi5AcFkflQ+6CCl3zTfQ/PTnTik7/ZFiTKIGAmy+6I0iKbf4QY2cOLgAhXN
	3Pz7db9VWoEbFiOWTt+LNLLklPdHWplQgeEJDo27RwHNjmYn9yn+H8cmW+ZGmKed
	bg+Kfw2UpuUgk3DJThY2AFRU/dDAs/LUoZ0blSGJW822gxhgUK8dS9jZraKRdbtY
	T4mNzWw72xSFycPMGSJzFZxEbQHqhUMrSByCgV8FjnPoFHePUAmzFqgOHdEMxw8O
	1WCex/6rtDy3SAXvt9VpqG3qrAO/VIFRfamRy7wuqPHUUEpu0CyTeY1XUZ6lB5JY
	BN1Aw==
X-ME-Sender: <xms:epyiavI_3uYmjKMhNESzjZp8KPyXRi5lm-Tp78-yXJ5Q-6yfYrV5xg>
    <xme:epyiavFkcRLks4SqR77fp5Yp4-2M46JzuHMLOOENuXYQhx4T8bag73S8mSWrOe1OH
    FARAerwDIjgde8IGf4pYBVlesfbpiPD5g6KZz58l9GsI3o9wvkWNQpz>
X-ME-Received: <xmr:epyiat0cBoqNH8XcSQaRLdLCgOpKvO4nLDTOdi0mZnjpy1CaSkvXOBmlYZ8>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2Cuoou
    HO6PwX09gzkHi4Gfrp1fdDra8jIcgYFcUSIPWD8T0ZYcjJ6nwMoBf0TKt047iMECBtffKf
    rHkHW1XTqgiZy01N2cVx2fZ3gma/bpB2S4iN1pneY8zee/4AdZ4D2swSIHJ4TbOQgQY5/a
    7oVvzIcwhVzSBLAGWN0xi7FL+N4peXGFhJXorWyQ/ealT98Z9HQn+ypEiKi/ygbkGx7XTg
    ev2TK9XWzY2D4TU9M38D26PqkwmnpL6/mEW/CeVCfhgHn68miLohoQNvFETQ+eYzbg3o+6
    qhhRpEWSw7furBGYZ3huCTGHg34rPlTAxVnHBXTIHY7oomTW7auHCvNSa8eg
X-ME-Proxy: <xmx:epyiauyw6qYGna391a1fLfUsAnJF9-kygQxYmWl7uy1J_67XP5wAoA>
    <xmx:epyiakgPMbv9LhixuspM6eGwGVtNbyMcctDmvUZZ0CIZqqT-b4a7ww>
    <xmx:epyialzNJuvpq5bw_T2lFgDFRShg7XUd-hatK6KXyOeqe3mtGmXU9A>
    <xmx:epyiaqw3dV9tJxocY4TAMwWKUuOgf0p_xmutDE0p-CaAtFyQLYPAfg>
    <xmx:epyiauDzmFTiz5Mhf8UZi1iKX2NFYRtzKPg6c_4yG4jychCs0NjKvLN7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table from collapsing it
Date: Thu, 10 Sep 2026 13:02:28 +0100
Message-ID: <20260910120238.2529819-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 811D540007
X-Stat-Signature: j4sxybhdna3z3iuhaq36mcr6g5iysttu
X-HE-Tag: 1789041787-983532
X-HE-Meta: U2FsdGVkX1/RrQMTkfywJxZdDW1RgCz1dJmBWfULxDJJ0j+3rOfvcyxI7GnDVoWVslGgmGap/JuV1WvYXVhsrY82HJRH2djmA9/3I0GbxB+yzLgxilX3xa6A2ude8X5arsZijiBSOCLeV0oz3HxeeWv/mfduPV1vhJWFa3BjztNf42Oy0nXBC+/VxqymKLgFHzN4Do6i+pGLLyyPJ8yj6St1JrpbvNR7gUVFsZ4g2uYuSJO5KMtU4nV5PLeLzKEkQzaNE9UAfQlo1WEwbf/DxhCVkoo+W4NOd/QSn/MZn27Gj0oAKj1IKYdW9hFXjKxgqgsL57fpj62D0NNtvl7NrRZ8QdgwlH6bPAeaxy8/foBoaDxIYHuemTqrlsDi8muZa1qom0ovXzuRj24t5O5NSV//8b7hk1wsHAV8xVPq5m28+Xoc3zsYUjHEJYBbQvUl+n7fea/ZNA050Fp7sq6SGrB/UyeJ77vvKKEb0LFrmtpfoTuggNB/5gJ4/AF8rN3zeKzk8pjqzPYDu4LGZ/j8zl8cdtv8Y/yfsKeNENP3D9ouTW2o1S4Z7ZeLGhOKImlnxtOuWVC35edV3ZVeYpT5ZXg+CImSrQQX9m2lSPni/geeuzriLPtOiCNg2WFS/itk2nzFNdCAMNKlYqBIc3Nhz4Nv1hHMvj+Wbj4TSiaI0xOzg/3pYIB36Lp0EGARta1CFod8FT/WLHwr74mX/NsUXTXcvFo3Ixi0M30I4DkwFYGHCgOaWICo0WRMKf/s3QevIisZ4HmvuL46GTB0Q5mUgzoRJ5sQOuWHlwkFt52bYK0LX+bvIffTEnBO1GJRAbeuMtxz6dc+lG7beSmbIdELmTMIpXGA4Hfgr5DW++wtYMoakaCqFN58VfKmVg7OG5FWN421oad9D4iMSMoudHiXvk2WBj1+sayvMln3dHjcYA3015hJp5JSCw+U1Ugq+TKIFHQaQhcDv0Ns9sWQQqX
 0dRcvEVH
 GfXHXk0unmUYvMm+7UCt9JI8b78mLvPrhBNFqvWfzKAt3+wlMKDbI+PY3ON9xiOut5d0BJqwptxLKnCi0n6vtzZk2J/G/b9iWsLzGmo2hbqe2E7LXHNklnME6P8izAuPO4LZvCCJ3vJ45c1cnR1BfpjDUtogsFQ64+/jvNqzxtBjX7/7rCiQUAFXoZnP1NjIkd634MWtKuxyLi0dY4NCvnNyfgwL6ySRZT/1/RXbXCBB8Hb5NHiaND1LGUIU0Y0ZTLl3Yqwdz6aLc3TFqvgctUQsyiwDCdd4Am7XhunK+hYcvDD4MfDBs7Hoet3KPja4akNpaQ/Z6j+EiJaiRumKnWemL6w+KFfvCihDzLAOp3YJcGtLXNEWCGKGHjBArudUt45cSmpz5TSQon8s/1iBQpu+7kQLsqcwi6IN9j2EpeYUYdBVcusrFgzFcqJSABD3kuz5THWnvybIVay0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
whether the range is worth collapsing.  The other allocates, isolates,
copies and flushes, and wants the lock given up first.

collapse_single_pmd() did both, so the boundary between them was somewhere
in the middle of a function.

Give each half its own function:

  - collapse_scan_pmd() scans one table and only reads.  The anonymous
    scan that used to carry that name keeps its body as
    collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
    that picks the anonymous or the file side.

  - collapse_run_pmd() does the collapse the scan asked for.
    SCAN_SUCCEED from the scan means there is something to run; anything
    else is why there is not.

collapse_single_pmd() is now the two of them with the mmap_lock drop in
between, so its callers see what they saw before.

What the scan found and the run needs travels in collapse_control.  For
an anonymous table that is the orders and the referenced and swapped-out
counts.  For a file it is the file itself, the offset in it, and whether
the PMD folio is already in the page cache.

The file side moves with the anonymous one.  collapse_scan_file() used to
run with mmap_lock already given up, and called collapse_file() itself
when the page cache looked worth it.  It now runs under the lock like the
anonymous scan and only judges; the run does the collapse.  A file
collapse works on the page cache and never sees a VMA, so the scan takes
the file reference while it still has one and the run gives it back.

That changes what a refused file table costs khugepaged.  Every file
table it scanned used to end its pass over that mm, because the lock had
been dropped to scan it; now only a table it goes on to collapse does.

Two things on the file side stop being rescanned.  When the page cache
already holds the PMD folio, the scan says so and the run goes straight
to retracting the PTE table.  A run that refuses dirty pages and may
write them back retries collapse_file() alone.  The checks the scan makes
ahead of it are ones collapse_file() repeats under the page cache lock.

Tracing changes with it.  mm_khugepaged_scan_pmd and
mm_khugepaged_scan_file used to fire after the collapse, so for an
accepted table their status field carried what the collapse made of it.
They now fire before it and read SCAN_SUCCEED for an accepted table.  What
the collapse then made of it is for mm_collapse_huge_page and
mm_khugepaged_collapse_file to report.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  16 ++++++
 mm/khugepaged.c | 147 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 128 insertions(+), 35 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 7044dc71c7c2..346859a2184f 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -88,6 +88,22 @@ struct collapse_control {
 
 	/* Each bit marks a PTE the scan accepted as a collapse source */
 	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
+
+	/*
+	 * What a scan found and the run after it needs.  Live only between the
+	 * two, and read by nobody else.
+	 *
+	 * The file side takes a reference while it still has the VMA, since a
+	 * file collapse works on the page cache and never sees one; the run is
+	 * what gives it back.  A scan that found the PMD folio already in the
+	 * cache leaves only the PTE table to retract.
+	 */
+	unsigned long scan_orders;
+	int scan_referenced;
+	int scan_unmapped;
+	struct file *scan_file;
+	pgoff_t scan_pgoff;
+	bool scan_retract_only;
 };
 
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d38ba030107b..c26907300c23 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1550,14 +1550,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 	return last_result;
 }
 
-static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
+static enum scan_result collapse_scan_anon_pmd(struct vm_area_struct *vma,
+		unsigned long start_addr, struct collapse_control *cc)
 {
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
 	enum tva_type tva_flags = cc->policy.tva_type;
+	struct mm_struct *mm = vma->vm_mm;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1737,12 +1737,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
+		cc->scan_orders = enabled_orders;
+		cc->scan_referenced = referenced;
+		cc->scan_unmapped = unmapped;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
@@ -2739,45 +2736,95 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	else
 		cc->progress += HPAGE_PMD_NR;
 
-	if (result == SCAN_SUCCEED) {
-		if (present < HPAGE_PMD_NR - max_ptes_none) {
-			result = SCAN_EXCEED_NONE_PTE;
-			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-		} else {
-			result = collapse_file(mm, addr, file, start, cc);
-		}
+	if (result == SCAN_SUCCEED && present < HPAGE_PMD_NR - max_ptes_none) {
+		result = SCAN_EXCEED_NONE_PTE;
+		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 	}
 
-	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present, swap,
+				      result);
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
+static void collapse_control_init(struct collapse_control *cc)
+{
+	cc->progress = 0;
+	cc->scan_file = NULL;
+}
+
+static void collapse_control_release(struct collapse_control *cc)
+{
+	/* A scan that took a file reference should have been run */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
+}
+
+static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	bool triggered_wb = false;
 	enum scan_result result;
-	struct file *file;
 	pgoff_t pgoff;
 
-	mmap_assert_locked(mm);
+	mmap_assert_locked(vma->vm_mm);
+	/* Whatever the last scan found has to have been run by now */
+	if (WARN_ON_ONCE(cc->scan_file)) {
+		fput(cc->scan_file);
+		cc->scan_file = NULL;
+	}
 
 	if (vma_is_anonymous(vma))
-		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		return collapse_scan_anon_pmd(vma, addr, cc);
 
-	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
+	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
+	switch (result) {
+	case SCAN_SUCCEED:
+		cc->scan_retract_only = false;
+		break;
+	case SCAN_PTE_MAPPED_HUGEPAGE:
+		/*
+		 * The page cache already holds the PMD folio; what is left is
+		 * to retract the PTE table, which is the run's job.
+		 */
+		cc->scan_retract_only = true;
+		result = SCAN_SUCCEED;
+		break;
+	default:
+		return result;
+	}
 
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
+	/*
+	 * A file collapse works on the page cache and never sees a VMA, so take
+	 * what it needs from this one while it is still here.
+	 */
+	cc->scan_file = get_file(vma->vm_file);
+	cc->scan_pgoff = pgoff;
+	return result;
+}
+
+static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+		unsigned long addr, struct collapse_control *cc)
+{
+	struct file *file = cc->scan_file;
+	bool triggered_wb = false;
+	enum scan_result result;
+	pgoff_t pgoff;
+
+	if (!file)
+		return mthp_collapse(mm, addr, cc->scan_referenced,
+				     cc->scan_unmapped, cc, cc->scan_orders);
+
+	cc->scan_file = NULL;
+	pgoff = cc->scan_pgoff;
+
+	if (cc->scan_retract_only) {
+		result = SCAN_PTE_MAPPED_HUGEPAGE;
+		goto retract;
+	}
 retry:
-	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+	result = collapse_file(mm, addr, file, pgoff, cc);
 
 	/* Dirty pages are worth a writeback and one more try, if asked for */
 	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
@@ -2789,8 +2836,13 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		triggered_wb = true;
 		goto retry;
 	}
+retract:
 	fput(file);
 
+	/*
+	 * A PMD folio is in the page cache, whether the collapse just put it
+	 * there or found it: retract the PTE table, and map the PMD if asked.
+	 */
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
 		if (collapse_test_exit_or_disable(mm))
@@ -2805,6 +2857,28 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+
+	result = collapse_scan_pmd(vma, addr, cc);
+	if (result != SCAN_SUCCEED)
+		return result;
+
+	/* The collapse takes its own locks, so give this up */
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+
+	return collapse_run_pmd(mm, addr, cc);
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2947,10 +3021,10 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	collapse_control_init(cc);
 	/* One policy for the whole pass, so every table is judged the same */
 	collapse_policy_khugepaged(&cc->policy);
 
-	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -2981,6 +3055,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			khugepaged_alloc_sleep();
 		}
 	}
+
+	collapse_control_release(cc);
 }
 
 static bool khugepaged_should_wakeup(void)
@@ -3177,8 +3253,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
+	collapse_control_init(cc);
 	collapse_policy_forced(&cc->policy);
-	cc->progress = 0;
 
 	lru_add_drain_all();
 
@@ -3235,6 +3311,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
+	collapse_control_release(cc);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


