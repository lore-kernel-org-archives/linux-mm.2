Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB7E9C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093D76B0088; Fri, 28 Aug 2026 05:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044936B008C; Fri, 28 Aug 2026 05:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74E96B0095; Fri, 28 Aug 2026 05:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C48396B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:47:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BDA780291
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:47:15 +0000 (UTC)
X-FDA: 85150200030.05.73B8DEF
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3ED3180008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:47:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUAGsXYB;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787910433;
	b=xuyjcHKW7ZvZt8WnLB9I++IfVDWhWjiV9q5hXkxEFfo1E0CVo4JWRt5kVRoRIk+DHn4FGR
	O3HF3UBHMi0OQt+H+6lWo8K/OXzV+UVupPnMEGgsJyWZL4ccvV2MOYhBDP82fxh+RPWzqN
	l/gFAAvg0AjAKFPXG1gMZ/ktP3ZZlKU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUAGsXYB;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787910433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ji1vQELSXjqqKQmu2zBHTbv1huQhC/YrPJAeBSczz/M=;
	b=paY+Z3pbXpiHkYZ01ARAW+xvzkrAtG+2J+dKKyYdqL8Lob31564lQf1s8vzaF7cpjTj1Df
	Gqj1oxPEz0NsP9go+tjxVTVCbkUVpdvP8a2J9uVempcL/ms3bw6jzrfQ57fbr3FC9k833Z
	1I59xETuQ6nGgZA8jzjsajqD2SU7omw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xyDcspAYGvgEUA23FnFj1KgLyE0byA+vZxYmYfg/wOw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787910428; v=1; x=1788515228;
 b=BUAGsXYBx+Rokivd7rlvfoNWfnV64jtTMEi7zJIHkW4AXYkB9XeqMwdSoaKgc4io9Y2KlrZW
 BXjvNHue82Lh5hcvVAXnNrdb4PtSpvURr95RH31RAVcdzIXQgcMPcAVT6k9c96dU0xecJY+quK6
 fSmRTc2YsbwmbErcVIouTIDE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e425fa70d8e74725;
	Fri, 28 Aug 2026 09:47:08 +0000
X-Mizu-Trace-ID: e425fa70d8e74725
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: jthoughton@google.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	shy828301@gmail.com,
	zokeefe@google.com,
	hughd@google.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Date: Fri, 28 Aug 2026 17:47:03 +0800
Message-Id: <20260828094703.11081-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260828005004.2870750-1-jthoughton@google.com>
References: <20260828005004.2870750-1-jthoughton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gx3bozfyptuboum335eqtuwymjzabneg
X-Rspamd-Queue-Id: C3ED3180008
X-Rspamd-Server: rspam06
X-HE-Tag: 1787910431-689594
X-HE-Meta: U2FsdGVkX19TBkjS32QJJHQc8CrmPMoUVMchZp6UI5n5A4OxHWjxGmyR1P8SBkcptZ6oRlrTonrJMNo7/VcvoheCX6V5IhR4E7CDkDhrOqX7Kz7DkciTfm3tpu4pH34svf/yuDaACObht+WjNJ1skqAqfiKT/Ac343EXhZjsDE2nSWLXq4VigmHAkmm2lTdERkwfbd9yiZNPmJLY2iumnMrfcRJu9K4qf5NQ/9/cPx5VBBzuMxLxCwWnRQrGlFSOq3a2lqzDwvD0wcwe8OT/0extd1kqoC7mQIC2TvC1MX71z8b/4wnKXEOjqW1YiIRPHUGiRbRB/xrmc9PXUyqcoREYbZXv8nLR4JZ1Q3IIpsCiKBaCLHgTzULPmB4Pst/WoVJ0Ro986mAM/apN8kH08I8r+l7d/jsxVo3zDQiHawpHLKRGizmKqo08Nr7SrZd+lxRTFH4F3axUAtjoMGSibuZcAUr5Qy+apQn+QT44mxOvnhzZjRwBsPFLlw9qH7L7eLn08B8a0eaeGqB9hUCYLuj6K3gNdRUOd/f59OctcCJbR4XhHMglkjZiCVYEZwl2OqW+ycpdnzllNYGq2lXSVbSvUl3r8kEycKvbRw9JMeY9I+oOvi3Hr4XkT+uFWXwP/D/zYw8KzUhfoCjlcVER7zFhKW/akTKUacpj1VJEd26UZAR8pOFwm/Az/1UEiAlwm15lnLLfyEjFFPK+/OLay9uCK7KIDyepcHsGmk/U5d2pWZVcNCDZwsRAuPVIVlV20cWj+MF5WsYg5w1+1gks7CEF5Phjcoj4TNcix69MioSjMslq0AQHAacXV45iyy/RYHUdCSl+3rg9XVWgCq6C2qT5EEIni7yFXYkVAEjkTQ8Qlbi7hIdwp16MY2uH/TVLsl7lAc1Yx6QCo6+UFhjbmUsNubQ4HuG/m+3n8HvpkpHlLlmDtDxINjlHAlkVWTy10uon39hE7J/8z/819Tx
 leA7cn1g
 yJC80mGkhd8XdLm+QL/wBivZr4EMayCYzS/I/aJ21bWzso2+ijyDmQJ1nNdoTR3Tmd3pduBSk7fpy8E8UZNKrmQYdIVobg/5wKAPHAxou77iPqSCPHVhCeExU3TxnETSPo8wjGNuwpBTfZ6aCGazb7kVBV69uC/CxtMNUGPNSVFFGYqUp+s5HbYRUQXUppUzNoXlpStYTYMZnze4yct+ulA7tHQKpuTN3eC892RH9hlN20fN7CFOLR+GtpZWw5gcHZW4HhpSBEphLcJZS1aFH4g3BAcqvaLv6PyfcCdHio1TY8FE5yzEVIuM1KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
>Userfaultfd minor faults provides userspace with the ability to manually
>install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
>map holes in the VMA when a naturally-aligned THP is present without
>explicit action from userspace.
>
>This is a problem, as it bypasses userfaultfd minor faults that
>userspace is expecting to handle.

One basic question first. Should MADV_COLLAPSE refuse to collapse a
UFFD-minor-registered VMA, regardless of whether all PTEs are present?

I'd leave that to the maintainers :D

Anyway, assuming the answer is yes, I wonder whether the new check is
sufficient. See below.

>
>If userspace implements post-copy live migration using userfaultfd minor
>faults, this situation is currently possible:
>1. The VMA for guest memory is userfaultfd-minor-registered and nothing
>   is mapped in the page tables.
>2. A stale copy of a page is present in a naturally-aligned THP (from
>   pre-copy live migration).
>3. khugepaged collapses the mapping of the THP, installs a PMD.
>4. The VM now has access to the stale contents => VM is broken.
>5. After installing the correct contents, userspace attempts to map the
>   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
>   unexpectedly mapped the page.
>
>The naturally-aligned THP case is the only case where this is a problem.
>khugepaged otherwise requires all PTEs to be present for
>userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
>correct. This check is essentially bypassed for naturally-aligned THPs.
>
>To deal with this issue, completely disallow collapsing in
>userfaultfd-minor-registered VMAs. This is slightly pessimistic; it
>would be nice to allow MADV_COLLAPSE to work if all PTEs are in fact
>present, but that seems more complex than it is worth.
>
>Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
>Cc: <stable@vger.kernel.org> # 6.1
>Signed-off-by: James Houghton <jthoughton@google.com>
>---
>This was caught with manual review while diagnosing a related issue
>that came up with in Google's live migration testing.
>
>I've uploaded a mostly-AI-generated reproducer here[1]. As long as
>/sys/kernel/mm/transparent_hugepage/shmem_enabled is not set to 'deny',
>the repro should work.
>
>[1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664
>---
> mm/khugepaged.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b237f6e7662a..66f956d3dd67 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2804,6 +2804,15 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
> 		goto end;
> 	}
> 
>+	/*
>+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
>+	 * userspace is expecting to explicitly install PTEs.
>+	 */
>+	if (userfaultfd_minor(vma)) {
>+		result = SCAN_PTE_UFFD;
>+		goto end;
>+	}

Assume UFFDIO_REGISTER_MODE_MINOR completes after collapse_single_pmd()
drops the mmap read lock and before it reacquires it.

Doesn't this still leave a registration race, no?


int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
		     unsigned long end, bool *lock_dropped)
{
...
	cc->is_khugepaged = false;
...
		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
...
}

static enum scan_result collapse_single_pmd(unsigned long addr,
		struct vm_area_struct *vma, bool *lock_dropped,
		struct collapse_control *cc)
{
...
	if (userfaultfd_minor(vma)) {
		result = SCAN_PTE_UFFD;
		goto end;
	}
...
	mmap_read_unlock(mm);
	*lock_dropped = true;
...
	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
		mmap_read_lock(mm);
		if (collapse_test_exit_or_disable(mm))
			result = SCAN_ANY_PROCESS;
		else
			result = try_collapse_pte_mapped_thp(mm, addr,
							     !cc->is_khugepaged);
...
		mmap_read_unlock(mm);
	}
...
}

static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
		bool install_pmd)
{
...
	struct vm_area_struct *vma = vma_lookup(mm, haddr);
...
	if (!vma || !vma->vm_file ||
	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
		return SCAN_VMA_CHECK;
...
	if (userfaultfd_protected(vma))
		return SCAN_PTE_UFFD;
...
	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
	switch (result) {
	case SCAN_SUCCEED:
		break;
	case SCAN_NO_PTE_TABLE:
...
		goto maybe_install_pmd;
	default:
		goto drop_folio;
	}
...
maybe_install_pmd:
	/* step 5: install pmd entry */
	result = install_pmd
			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
			: SCAN_SUCCEED;
...
}


static inline bool userfaultfd_minor(struct vm_area_struct *vma)
{
	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
}

static inline bool userfaultfd_protected(struct vm_area_struct *vma)
{
	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
}

Emm ... userfaultfd_protected() only covers WP and RWP. MADV_COLLAPSE
passes install_pmd=true, so the SCAN_NO_PTE_TABLE case can still reach
set_huge_pmd() after UFFDIO_REGISTER_MODE_MINOR has completed ...

Maybe:

---8<---
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 33c41bc32af8..0eada7265d59 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1893,6 +1893,8 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	 */
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
+	if (userfaultfd_minor(vma))
+		return SCAN_PTE_UFFD;

 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
--

With that, LGTM.

Tested-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

