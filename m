Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60762C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 05:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5E86B0088; Sat, 29 Aug 2026 01:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87826B008A; Sat, 29 Aug 2026 01:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E066B008C; Sat, 29 Aug 2026 01:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEB546B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:26:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28BBD140634
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:26:27 +0000 (UTC)
X-FDA: 85153171614.03.62D5BBA
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1105640005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:26:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sO0QlM1r;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787981185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fh8NY5GbjBRnaBk9ucLyMDpCBcn5O4yQtGHtElN+6go=;
	b=V6sktVDH5zTsVmf533CL0vTlzdPH0b2vChIxEbZGq2UoPPeuI3kI9RxejsjPTbop9llq73
	V89lNieHj7HSbzyUR50REPPVeQHGpUExTVSVRYvNrZjsvEP8yVzT4nLEjtk2wxnAuEybfu
	CVxcxvq/0Ppq7WpCXiHYDT7aQkOm98k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787981185;
	b=02HTl1gXKtQYUgHwFr7ISNcVKCYnEuwu/6SPhcupMV4tXLg7gy/scQCN9QZBzZjp6XfM8M
	u13KC83cwJRp9Mo12vW2BL9g5y+fZO8ByCXsysInalfbTCyT/hiYNgwRe4h2WfXd23Z1Nc
	Tm/Qp1tX/IdPhQW8Vnq6ezfkz5HMlfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sO0QlM1r;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gMiVGtvLV3mH/7H3GivycOy54NP7nzz97CqQNM/VtCU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787981181; v=1; x=1788585981;
 b=sO0QlM1rdCf8z3trdOWBO+0NmI0sgFfCtIogkd+kMvAINVYNkSC0io9Iwdd9kGuTDPGqtEhh
 iYB2pmdPwAOo/q6zCFf0f5Kl1zY8yfGf30zrj91ebnWrtH0rveHn7+0nazZzymTCaJdfrmn/QZU
 HGzX0jC+zKYfNUTvBzWaKxCE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9000a047d4d4bcd1;
	Sat, 29 Aug 2026 05:26:11 +0000
X-Mizu-Trace-ID: 9000a047d4d4bcd1
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
	usama.arif@linux.dev,
	shy828301@gmail.com,
	zokeefe@google.com,
	hughd@google.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
Date: Sat, 29 Aug 2026 13:26:06 +0800
Message-Id: <20260829052606.49470-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260828094703.11081-1-lance.yang@linux.dev>
References: <20260828094703.11081-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1105640005
X-Stat-Signature: 9yp55ruoh77od48xjae8zxhx7sqrepbt
X-HE-Tag: 1787981182-102762
X-HE-Meta: U2FsdGVkX18VhRRlU9EUbini46iGaf/65srsoI2Jm1mNV8pBDR5sFtaRJqA37bvmP2WAPzxvmGIfS8rWGgO/I5PKcICJT3AB/GBD08kfAAu33TUG9qXupkGhvAw3fYT6FZ1cBGLoKsJ49Oyb0Ci4i9qDaYXxlqAQKjmLXA7mGG8oTcLtQAYyRPIFkF9thAL4wG0Qq5RDl9DDhc1KEFxdZqgwXIT7S8lA2bbqnUrET2U9Qi6A/tCoOjV6ueHwM95iUbQw8huziZ5pyDTZLyqcgjE2P/2U5DkQBympM8R3mi8rOwvNQ2W4uAa5D256DUf4obuPKhe/6LjTnJw6957wtkAjM3tye680OLmbFIagFcMNxBGBman5JdHah8BgI3QbloMi9KtvmfYtfE6PQl28banA+RTOOrAdVAnVGZlW2Mqoa+NhPN07bj0ljX0ZjquHvVTbfmxqZ+OR5s8dSrKqKy/lK4gQBOfpiiFWnGvVQ5ynMdhAst+4IxCdLKAO1FgKesu2wPb0Gd9qlOdR4NH4uXhNHJcidrfSh4EEkbduUb9C2WbTULrpbqmQGWqoPfPaSHRNJ3JaBbYM1Obo7Z2nDWQk3Q0kZzkv8I3ndikfh3FsDgmnquW7HgYmdYenjsGND7ajUkYML2RiXbuJ/6IOsDjneRD0n78V7tE1rMK/NqbDJ35fQi5wOuWGDIlTjfkhvdAYFuolAOSz+NbunELE63EkwnScXnlcfO7Tia11WQ7o2QoLOjAxE6+6Gq+ePROAw5Rh7j+8eGEWXCNdPh8Zc5Lf+lJqFSs+4p0lq29BNadEmye9UJ0USI+SSaLFZ6HSqNSizqg4kz+ddIKh9Wj5j+SPky2Pg3qxv4VYa0BZA4rr2rDlSuOsnYcJ5HqhrFRPfBguzzQHGtYgmRgybIOxaCWtMjQ9xMWVmZow/hboNV8LQYYWrXOqCdvhtetaUv3M1G51JsiY0itjx4cJkSS
 Gy4xwGis
 tA7WEUrZeczPMiDiHcYxCDaBJDGXontQUYzY2Xs+89GUX04a14vHW7n61su2FgN7tOjGwHGy+ra5ctxk9J0Q3UCFbWIPCSckdXb5AC+8w6g+lklEOSmvHk8jgQ9luMwcpHt08duRlup100ZeO+3ncPCnlK+MZC3IspreRaEmVTc5hNoOZ95lr3uUPaypcQ6YYyRFxTAUpwO8lltJV6iRiaeTTOE35ikNG+ttSy9NarD3nRreF0tdkbZqnweCxdHHlGnE3m5P4mjftvKkgo28SykivNTgloU2M94oc8zByBIMvO6/r79CdZavsbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 28, 2026 at 05:47:03PM +0800, Lance Yang wrote:
>
>On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
>>Userfaultfd minor faults provides userspace with the ability to manually
>>install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
>>map holes in the VMA when a naturally-aligned THP is present without
>>explicit action from userspace.
>>
>>This is a problem, as it bypasses userfaultfd minor faults that
>>userspace is expecting to handle.
>
>One basic question first. Should MADV_COLLAPSE refuse to collapse a
>UFFD-minor-registered VMA, regardless of whether all PTEs are present?
>
>I'd leave that to the maintainers :D
>
>Anyway, assuming the answer is yes, I wonder whether the new check is
>sufficient. See below.
>
>>
>>If userspace implements post-copy live migration using userfaultfd minor
>>faults, this situation is currently possible:
>>1. The VMA for guest memory is userfaultfd-minor-registered and nothing
>>   is mapped in the page tables.
>>2. A stale copy of a page is present in a naturally-aligned THP (from
>>   pre-copy live migration).
>>3. khugepaged collapses the mapping of the THP, installs a PMD.

Ouch ... I missed this earlier. The problem is real, but this commit
message describes the wrong trigger.

Background khugepaged calls try_collapse_pte_mapped_thp() with
install_pmd=false, so it cannot install the PMD or trigger this
sequence. MADV_COLLAPSE passes install_pmd=true and installs the PMD.

So the problem described here can only be triggered by MADV_COLLAPSE,
whether it comes through madvise() or process_madvise(), no?

Cheers, Lance


>>4. The VM now has access to the stale contents => VM is broken.
>>5. After installing the correct contents, userspace attempts to map the
>>   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
>>   unexpectedly mapped the page.
>>
>>The naturally-aligned THP case is the only case where this is a problem.
>>khugepaged otherwise requires all PTEs to be present for
>>userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
>>correct. This check is essentially bypassed for naturally-aligned THPs.
>>
>>To deal with this issue, completely disallow collapsing in
>>userfaultfd-minor-registered VMAs. This is slightly pessimistic; it
>>would be nice to allow MADV_COLLAPSE to work if all PTEs are in fact
>>present, but that seems more complex than it is worth.
>>
>>Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
>>Cc: <stable@vger.kernel.org> # 6.1
>>Signed-off-by: James Houghton <jthoughton@google.com>
>>---
>>This was caught with manual review while diagnosing a related issue
>>that came up with in Google's live migration testing.
>>
>>I've uploaded a mostly-AI-generated reproducer here[1]. As long as
>>/sys/kernel/mm/transparent_hugepage/shmem_enabled is not set to 'deny',
>>the repro should work.
>>
>>[1] https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664
>>---
>> mm/khugepaged.c | 9 +++++++++
>> 1 file changed, 9 insertions(+)
>>
>>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>index b237f6e7662a..66f956d3dd67 100644
>>--- a/mm/khugepaged.c
>>+++ b/mm/khugepaged.c
>>@@ -2804,6 +2804,15 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
>> 		goto end;
>> 	}
>> 
>>+	/*
>>+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
>>+	 * userspace is expecting to explicitly install PTEs.
>>+	 */
>>+	if (userfaultfd_minor(vma)) {
>>+		result = SCAN_PTE_UFFD;
>>+		goto end;
>>+	}
>
>Assume UFFDIO_REGISTER_MODE_MINOR completes after collapse_single_pmd()
>drops the mmap read lock and before it reacquires it.
>
>Doesn't this still leave a registration race, no?
>
>
>int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>		     unsigned long end, bool *lock_dropped)
>{
>...
>	cc->is_khugepaged = false;
>...
>		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
>...
>}
>
>static enum scan_result collapse_single_pmd(unsigned long addr,
>		struct vm_area_struct *vma, bool *lock_dropped,
>		struct collapse_control *cc)
>{
>...
>	if (userfaultfd_minor(vma)) {
>		result = SCAN_PTE_UFFD;
>		goto end;
>	}
>...
>	mmap_read_unlock(mm);
>	*lock_dropped = true;
>...
>	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
>		mmap_read_lock(mm);
>		if (collapse_test_exit_or_disable(mm))
>			result = SCAN_ANY_PROCESS;
>		else
>			result = try_collapse_pte_mapped_thp(mm, addr,
>							     !cc->is_khugepaged);
>...
>		mmap_read_unlock(mm);
>	}
>...
>}
>
>static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>		bool install_pmd)
>{
>...
>	struct vm_area_struct *vma = vma_lookup(mm, haddr);
>...
>	if (!vma || !vma->vm_file ||
>	    !range_in_vma(vma, haddr, haddr + HPAGE_PMD_SIZE))
>		return SCAN_VMA_CHECK;
>...
>	if (userfaultfd_protected(vma))
>		return SCAN_PTE_UFFD;
>...
>	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
>	switch (result) {
>	case SCAN_SUCCEED:
>		break;
>	case SCAN_NO_PTE_TABLE:
>...
>		goto maybe_install_pmd;
>	default:
>		goto drop_folio;
>	}
>...
>maybe_install_pmd:
>	/* step 5: install pmd entry */
>	result = install_pmd
>			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
>			: SCAN_SUCCEED;
>...
>}
>
>
>static inline bool userfaultfd_minor(struct vm_area_struct *vma)
>{
>	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
>}
>
>static inline bool userfaultfd_protected(struct vm_area_struct *vma)
>{
>	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
>}
>
>Emm ... userfaultfd_protected() only covers WP and RWP. MADV_COLLAPSE
>passes install_pmd=true, so the SCAN_NO_PTE_TABLE case can still reach
>set_huge_pmd() after UFFDIO_REGISTER_MODE_MINOR has completed ...
>
>Maybe:
>
>---8<---
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 33c41bc32af8..0eada7265d59 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1893,6 +1893,8 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
> 	 */
> 	if (userfaultfd_protected(vma))
> 		return SCAN_PTE_UFFD;
>+	if (userfaultfd_minor(vma))
>+		return SCAN_PTE_UFFD;
>
> 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
> 			       linear_page_index(vma, haddr));
>--
>
>With that, LGTM.
>
>Tested-by: Lance Yang <lance.yang@linux.dev>
>
>Cheers, Lance
>

